{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module TasteOfConcurrency where

import           Data.Maybe                     (fromJust)
import           Lib
import           System.Environment             (getArgs)

import           Control.Lens

import           Control.Monad.Indexed.State
import           Raft                           (Action (..), Event (..),
                                                 execIxStateT, follow, timeout,
                                                 vote)
import           RaftState                      (CandidateState, RaftState (..),
                                                 WrappableState (..),
                                                 followerTerm, votedTerm)

import           Control.Concurrent             (forkIO, killThread,
                                                 threadDelay)
import           Control.Concurrent.STM         (STM, atomically)
import           Control.Concurrent.STM.Delay   (Delay, cancelDelay, newDelay,
                                                 tryWaitDelay, updateDelay,
                                                 waitDelay)
import           Control.Concurrent.STM.TMQueue
import           Control.Concurrent.STM.TMVar
import           Control.Monad.Base
import           Control.Monad.Reader
import qualified Data.ByteString                as BS
import           Data.Foldable                  (traverse_)
import           Data.Text                      (pack)
import           Data.Text.Encoding             (encodeUtf8)
import           Data.Time.Clock                (UTCTime (..), getCurrentTime)
import           GHC.Conc                       (unsafeIOToSTM)
import           System.IO                      (stdout)


-- Queue from stm-chans
-- Add synthetic events to queue in background, with delays TODO: stop that thread via bracket
-- Start delay. On each event (but timeout), restart delay. TODO: cancel & restart or update?
-- If there's no event for too long, delay rings, then enqueue a Timeout event
-- Stop on Stop event

data TasteEvent = Ping | TimedOut | Stop

data TasteEnv = TasteEnv { queue :: TMQueue TasteEvent, mvar :: TMVar Delay, timeout :: Int }

type TasteIO = ReaderT TasteEnv IO
type TasteSTM = ReaderT TasteEnv STM

taste = do
  q <- newTMQueueIO
  mvar <- newEmptyTMVarIO
  let env = TasteEnv q mvar (seconds 3)
  -- TODO: use threadId, and kill that thread via bracket
  -- TODO: how to avoid repetition on runReaderT? Need to abstract over atomically somehow...
  events <- forkIO $ runReaderT (startDelay >> traverse_ emitEvent [1, 5, 1, 2, 2, 1, 5, 1] >> emitStop) env
  timeout <- forkIO $ forever $ atomically $ runReaderT waitTimeout env
  forever $
    atomically (readTMQueue q) >>= \case
      Just Ping -> log "Got Ping" >> runReaderT restartDelay env
      Just TimedOut -> log "Got TimedOut"
      Just Stop -> log "Got Stop, will throw" >> kill [events, timeout] >> error "Stopping"
      Nothing -> log "Queue is closed and empty :(" >> kill [events, timeout] >> error "Queue was stopped"
  where
    kill = traverse killThread
    say = BS.hPutStrLn stdout . encodeUtf8
    print = say . pack
    log s = getCurrentTime >>= (\time -> print $ show time ++ "\t" ++ s)

    startDelay :: TasteIO ()
    startDelay = do
      TasteEnv _ mvar micros <- ask
      delay <- liftBase $ newDelay micros
      liftBase $ atomically $ putTMVar mvar delay

    restartDelay :: TasteIO ()
    restartDelay = do
      mvar <- asks mvar
      maybeDelay <- liftBase $ atomically $ tryTakeTMVar mvar
      case maybeDelay of
        Just delay -> liftBase $ cancelDelay delay
        _          -> return ()
      startDelay

    waitTimeout :: TasteSTM ()
    waitTimeout = do
      TasteEnv q mvar _ <- ask
      delay <- liftBase $ readTMVar mvar
      liftBase $ waitDelay delay
      newDelay <- liftBase $ tryTakeTMVar mvar -- clear mvar so next waitTimeout blocks until new delay is set
      case newDelay of
        Just d ->
          liftBase $ do
            rung <- liftBase $ tryWaitDelay d
            -- if delay hasn't rung yet – it's a new one, put it back
            unless rung $ putTMVar mvar d
        _ -> return ()
      liftBase $ writeTMQueue q TimedOut

    wait :: Int -> IO ()
    wait n = do
      delay <- newDelay n
      atomically $ waitDelay delay

    emitEvent :: Int -> TasteIO ()
    emitEvent n = do
      liftBase $ wait (seconds n)
      enqueue Ping -- TODO: wait n seconds before emitting event

    emitStop :: TasteIO ()
    emitStop = enqueue Stop

    enqueue :: TasteEvent -> TasteIO ()
    enqueue e = asks queue >>= liftBase . atomically . flip writeTMQueue e

    seconds micros = micros * 1000000
