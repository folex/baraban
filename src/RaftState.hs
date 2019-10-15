{-# LANGUAGE ConstraintKinds            #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE FunctionalDependencies     #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedLabels           #-}
{-# LANGUAGE PolyKinds                  #-}
{-# LANGUAGE RankNTypes                 #-}
--{-# LANGUAGE RebindableSyntax           #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeOperators              #-}


module RaftState where

import           Prelude

import           Control.Concurrent     (threadDelay)
import           Control.Monad.Indexed
import           Control.Monad.IO.Class
import           Data.Row.Records
import           GHC.OverloadedLabels

import           Motor.FSM
import           Control.Monad.Indexed.Trans


import           Data.Maybe
import           Proto.Raft.Raft        (RaftMessage'Value(..))


-- State markers
-- TODO: associate a GHC.TypeLits.Nat with each marker to guarantee term correctness?
data Follower
data VotedFollower -- has voted on current term
data Candidate
data Leader

-- Connection TODO: how to manage connections? With a separate inner FSM?
class Connection c where
  messages :: c -> IO [RaftMessage'Value]

-- Rules
class MonadFSM m => Raft m where
  type State m :: * -> *

  init :: Name n -> Node -> Actions m '[ n !+ State m Follower ] r ()
  -- Waits for heartbeat to arrive for a randomized timeout, then either `timeout` or `vote`
  start :: Name n -> Actions m '[ n := State m Follower !--> State m Candidate ] r ()

  -- Receives request for vote when in Follower state: sends Vote, resets timeout
  voteRequestF :: Name n -> Actions m '[ n := State m Follower !--> State m VotedFollower ] r ()
  -- Receives request for vote when in VotedFollower state: if t >= t1 does nothing else sends Vote, resets timeout
  voteRequestVF :: Name n -> Actions m '[ n := State m VotedFollower !--> State m VotedFollower ] r ()
  -- Receives request for vote when in Candidate state
  voteRequestC :: Name n -> Actions m '[ n := State m Candidate !--> FromCandidate m ] r ()
  -- Receives request for vote when in Leader state: if t >= t1 does nothing else sends Vote, resets timeout
  -- TODO: how to represent several possible resulting states? Either doesn't seem to work
  voteRequestL :: Name n -> Actions m '[ n := State m Leader !--> State m (Either Leader VotedFollower) ] r () 
  -- Receives heartbeat, executes action (e.g. set Term for follower), stays in the same state
  receiveHeartbeat :: Name n -> Actions m '[ n := State m s !--> State m s ] r ()
  -- TODO: what if Leader / Candidate / VotedFollower receives a heartbeat with higher term?

  -- Adds new follower to list
  followerConnected :: Name n -> Actions m '[ n := State m Leader !--> State m Leader ] r ()

data FromCandidate m
  -- If not enough votes yet
  = Stay (State m Candidate)
  -- If received higher term
  | Vote (State m VotedFollower)
  -- If majority
  | Lead (State m Leader)


-- TCP implementation
newtype TcpRaft m (i :: Row *) (o :: Row *) a =
  TcpRaft { runRaft :: FSM m i o a }
  deriving (IxFunctor, IxPointed, IxApplicative, IxMonad, MonadFSM)

run :: Monad m => TcpRaft m Empty Empty () -> m ()
run = runFSM . runRaft

deriving instance Monad m => Functor (TcpRaft m i i)
deriving instance Monad m => Applicative (TcpRaft m i i)
deriving instance Monad m => Monad (TcpRaft m i i)

instance (MonadIO m) => MonadIO (TcpRaft m i i) where -- TODO: why is it `m i i`, not `m i o`?
  liftIO = TcpRaft . liftIO

newtype Term = Term Int
newtype NodeID = NodeID String --TODO: or UUID

-- Description of each node's data:
-- - Connections with other nodes; TODO: associate each connection with NodeID?
data Node where Node :: (Connection c) => [c] -> Node

data RaftState s where
  -- TODO: add cancellable timer to the Follower state to cancel it on heartbeat?
  Follower
    -- no term on init, will be set by receiveHeartbeat transition
    :: Node
    -> Maybe Term
    -> RaftState Follower

  VotedFollower
    :: Node
    -> Term
    -- vote for
    -> NodeID
    -> RaftState VotedFollower

  Candidate
    :: Node
    -> Term
    -- received votes
    -> [NodeID]
    -> RaftState Candidate

  Leader
    :: Node
    -> Term
    -> RaftState Leader

instance (MonadIO m) => Raft (TcpRaft m) where
  type State (TcpRaft m) = RaftState

  init n node = new n $ Follower node Nothing

  -- Start without a term
  -- TODO: connect to other nodes
  -- TODO: start timer here? How to work with concurrency in motor?
  --  Maybe block for a timeout, periodically checking if received heartbeats?
  --  This could work... But where to store messages? Take MVar everywhere?

  start n = enter n (Candidate undefined (Term 0) [])
--    if 1 == 0
--      then enter $ Left VotedFollower node (Term 0) undefined
--      else enter $ Right Candidate node (Term 0) []

--  start n = get n >>>= \case
--    Follower node maybeTerm -> wait (voteLeader node maybeTerm) heartbeat (voteSelf node maybeTerm)
--      >>>= \r -> enter n r
--    where
--      checkMsgs p cs = liftIO $ filter p . concat <$> traverse messages cs
--      -- If there's a message satisfying `p` – call onMsg, onNull otherwise
--      wait onMsg p onNull = checkMsgs p >>>= \msgs ->
--        if null msgs
--          then onNull
--          else onMsg
--      heartbeat (RaftMessage'Heartbeat _) = True
--      heartbeat _ = False
--      voteLeader :: _
--      voteLeader node maybeTerm = liftIO $ do
--        putStrLn "voting leader?"
--        return $ Left VotedFollower node (fromMaybe (Term 0) maybeTerm) undefined
--      voteSelf :: _
--      voteSelf node maybeTerm = liftIO $ do
--        putStrLn "voting self!"
--        return $ Right Candidate node (fromMaybe (Term 0) maybeTerm) []

   -- new n $ Follower node Nothing

--  timeout n = do
--    Follower maybeTerm <- get n
--    enter n $ Candidate (Term 0) [] -- Candidate $ fromMaybe (Term 0) maybeTerm

-- === Follower - initial
-- - Follower -> Candidate after timeout (randomized 150ms – 300ms)

-- === Candidate
-- - If followers don't hear from a leader then they can become a candidate
-- ... and increment election term
-- - Votes for himself
-- - Sends `Request Vote` message to others, nodes will reply with their vote

-- On majority votes, Candidate -> Leader (elected)

-- If the node (Follower, Candidate, Leader?) hasn't voted on current term, it votes for first received `Request Vote`
-- ... and resets its timeout

-- === Leader
-- - The candidate becomes the leader if it gets votes from a majority of nodes.


-- TODO:
-- - LogEntries:
--    - replication,
--    - not-commited
--    - committed – leader waits for majority, notify followers after commit
--    - revert on split brain

