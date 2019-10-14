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
{-# LANGUAGE RebindableSyntax           #-}
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


-- State markers
-- TODO: associate a GHC.TypeLits.Nat with each marker to guarantee term correctness?
data Follower
data VotedFollower -- has voted on current term
data Candidate
data Leader

-- Rules
class MonadFSM m => Raft m where
  type State m :: * -> *

  -- Waits for heartbeat to arrive for a randomized timeout
  start :: Name n -> Actions m '[ n !+ State m Follower ] r ()
  -- Becomes a candidate, votes for self, sends Request Vote
  timeout :: Name n -> Actions m '[ n := State m Follower !--> State m Candidate ] r ()

  -- Receives request for vote when in Follower state: sends Vote, resets timeout
  voteRequestF :: Name n -> Actions m '[ n := State m Follower !--> State m VotedFollower ] r ()
  -- Receives request for vote when in VotedFollower state: if t >= t1 does nothing else sends Vote, resets timeout
  voteRequestVF :: Name n -> Actions m '[ n := State m VotedFollower !--> State m VotedFollower ] r ()
  -- Receives request for vote when in Candidate state
  voteRequestC :: Name n -> Actions m '[ n := State m Candidate !--> FromCandidate m ] r ()
  -- Receives request for vote when in Leader state: if t >= t1 does nothing else sends Vote, resets timeout
  voteRequestL :: Name n -> Actions m '[ n := State m Leader !--> State m (Either Leader VotedFollower) ] r ()

  -- TODO: receiveHeartbeat (e.g. set Term for follower). Again repeat for each state?


data FromCandidate m
  -- If not enough votes yet
  = Stay (State m Candidate)
  -- If received higher term
  | Vote (State m VotedFollower)
  -- If majority
  | Lead (State m Leader)

newtype TcpRaft m (i :: Row *) (o :: Row *) a =
  TcpRaft { runRaft :: FSM m i o a }
  deriving (IxFunctor, IxPointed, IxApplicative, IxMonad, MonadFSM)

run :: Monad m => TcpRaft m Empty Empty () -> m ()
run = runFSM . runRaft

deriving instance Monad m => Functor (TcpRaft m i i)
deriving instance Monad m => Applicative (TcpRaft m i i)
deriving instance Monad m => Monad (TcpRaft m i i)

instance (MonadIO m) => MonadIO (TcpRaft m i i) where
  liftIO = TcpRaft . liftIO

newtype Term = Term Int
newtype NodeID = NodeID String --TODO: or UUID
data RaftState s where
  Follower
    -- no term on init, will be set by receiveHeartbeat transition
    :: Maybe Term
    -> RaftState Follower

  VotedFollower
    :: Term
    -- vote for
    -> NodeID
    -> RaftState VotedFollower

  Candidate
    :: Term
    -- received votes
    -> [NodeID]
    -> RaftState Candidate

  Leader
    :: Term
    -> RaftState Leader


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

