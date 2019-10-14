{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeFamilies               #-}

module EnforcingLegalStateTransitions where

import           Control.Monad.IO.Class
import           Data.List.NonEmpty
import qualified Data.Text.IO           as T

import           Checkout               (Card (..), CartItem, OrderId (..),
                                         calculatePrice, mkItem, newOrderId)
import qualified ConsoleInput
import qualified PaymentProvider

-- State markers
data NoItems

data HasItems

data NoCard

data CardSelected

data CardConfirmed

data OrderPlaced

-- Protocol
class Checkout m where
  type State m :: * -> *
  initial :: m (State m NoItems)
  select :: SelectState m -> CartItem -> m (State m HasItems)
  checkout :: State m HasItems -> m (State m NoCard)
  selectCard :: State m NoCard -> Card -> m (State m CardSelected)
  confirm :: State m CardSelected -> m (State m CardConfirmed)
  placeOrder :: State m CardConfirmed -> m (State m OrderPlaced)
  cancel :: CancelState m -> m (State m HasItems)
  end :: State m OrderPlaced -> m OrderId

data SelectState m
  = NoItemsSelect (State m NoItems)
  | HasItemsSelect (State m HasItems)

data CancelState m
  = NoCardCancel (State m NoCard)
  | CardSelectedCancel (State m CardSelected)
  | CardConfirmedCancel (State m CardConfirmed)

-- Program
fillCart :: (Checkout m, MonadIO m) => State m NoItems -> m (State m HasItems)
fillCart noItems =
  mkItem <$> ConsoleInput.prompt "First item:"
  >>= select (NoItemsSelect noItems)
  >>= selectMoreItems

selectMoreItems :: (Checkout m, MonadIO m) => State m HasItems -> m (State m HasItems)
selectMoreItems s = do
  more <- ConsoleInput.confirm "More items?"
  if more
    then
      mkItem <$> ConsoleInput.prompt "Next item:"
      >>= select (HasItemsSelect s)
      >>= selectMoreItems
    else return s

startCheckout :: (Checkout m, MonadIO m) => State m HasItems -> m (State m OrderPlaced)
startCheckout hasItems = do
  continue <- ConsoleInput.confirm "Continue?" --"Your cart: " <> showt hasItems <>
  if continue
    then do
      check <- checkout hasItems
      card <- ConsoleInput.prompt "Specify card name:"
      selected <- selectCard check $ Card card
      cardOK <- ConsoleInput.confirm $ "Will use card '" <> card <> "'. OK?"
      if cardOK
        then confirm selected >>= placeOrder
        else cancel (CardSelectedCancel selected)
         >>= selectMoreItems
         >>= startCheckout
    else selectMoreItems hasItems >>= startCheckout

doBadThings :: (Checkout m, MonadIO m) => State m CardConfirmed -> m (State m OrderPlaced)
doBadThings cardConfirmed = placeOrder cardConfirmed >> placeOrder cardConfirmed

checkoutProgram
  :: (Checkout m, MonadIO m)
  => m OrderId
checkoutProgram =
  initial >>= fillCart >>= startCheckout >>= end


-- Instance
newtype CheckoutT m a = CheckoutT
  { runCheckoutT :: m a
  } deriving ( Functor
             , Monad
             , Applicative
             , MonadIO
             )

data CheckoutState s where
  EmptyItems
    :: CheckoutState NoItems

  HasItems
    :: NonEmpty CartItem
    -> CheckoutState HasItems

  NoCard
    :: NonEmpty CartItem
    -> CheckoutState NoCard

  CardSelected
    :: NonEmpty CartItem
    -> Card
    -> CheckoutState CardSelected

  CardConfirmed
    :: NonEmpty CartItem
    -> Card
    -> CheckoutState CardConfirmed

  OrderPlaced
    :: OrderId
    -> CheckoutState OrderPlaced

instance (MonadIO m) => Checkout (CheckoutT m) where
  type State (CheckoutT m) = CheckoutState
  initial = return EmptyItems

  select (NoItemsSelect EmptyItems) item = return $ HasItems $ item :| []
  select (HasItemsSelect (HasItems items)) item = return $ HasItems $ item <| items

  checkout (HasItems items) = return $ NoCard items
  selectCard (NoCard items) card = return $ CardSelected items card
  confirm (CardSelected items card) = return $ CardConfirmed items card
  placeOrder (CardConfirmed items card) = do
    orderId <- newOrderId
    let price = calculatePrice items
    PaymentProvider.chargeCard card price
    return $ OrderPlaced orderId

  cancel (NoCardCancel (NoCard items)) = return $ HasItems items
  cancel (CardSelectedCancel (CardSelected items _)) = return $ HasItems items
  cancel (CardConfirmedCancel (CardConfirmed items _)) = return $ HasItems items

  end (OrderPlaced orderId) = return orderId

example :: IO ()
example = do
  OrderId orderId <- runCheckoutT checkoutProgram
  T.putStrLn ("Completed with order ID: " <> orderId)
