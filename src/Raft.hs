{-# LANGUAGE DataKinds              #-}
{-# LANGUAGE DeriveFunctor          #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FlexibleContexts       #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE GADTs                  #-}
{-# LANGUAGE KindSignatures         #-}
{-# LANGUAGE LambdaCase             #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE RebindableSyntax       #-}
{-# LANGUAGE StandaloneDeriving     #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeFamilies           #-}

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
module Raft where

import           Control.Lens                  hiding (use, view)
import qualified Control.Lens                  as Lens
import           Control.Monad.Indexed
import           Control.Monad.Indexed.Prelude
import           Control.Monad.Indexed.State
import           Control.Monad.IO.Class
import           Data.Maybe
import           Network.Socket                (AddrInfo, Socket)

import           RaftState

initState :: Node -> InitState
initState = InitState

follow :: (IxMonadState m, HasNode s) => NodeId -> Term -> m s FollowerState Action
follow id term = imodify (FollowerState id term . node) >> return defaultTimeout

vote :: (IxMonadState m, MonadIO (m FollowerState FollowerState)) => NodeId -> Term -> m FollowerState VotedState Action
vote candidate term = do
  liftIO $ putStrLn "voting"
  imodify (\s -> VotedState term (s ^. followerNode) candidate)
  return NoAction

timeout :: (IxMonadState m, MonadIO (m FollowerState FollowerState)) => m FollowerState CandidateState Action
timeout = do
  liftIO $ putStrLn "ballotting"
  imodify
    (\case
       FollowerState _ term node -> CandidateState term node [])
  return NoAction

receiveVote :: (IxMonadState m) => NodeId -> m CandidateState CandidateState Action
receiveVote from = do
  imodify $ over candidateVotes (from :) -- append from to candidateVotes
  -- TODO: should I check majority here, and return bool?
  igets (\s -> WaitVotes $ length (s ^. candidateNode . neighbours) - length (s ^. candidateVotes)) -- remaining votes

lead :: (IxMonadState m) => m CandidateState LeaderState Action
lead =
  imodify
    (\case
       CandidateState term node _ -> LeaderState term node) >>
  return NoAction

data Event
  = Heartbeat NodeId Term
  | Vote NodeId Term
  | VoteRequest NodeId Term

data Action
  = NoAction
  | Timeout Int -- TODO: add CancelTimeout action?
  | WaitVotes Int

-- Dispatch timeout. If timeout occurs and term & state are the same as on dispatch, execute action on timeout
-- TODO: customizable duration :: Int
-- TODO: whole state is too much, just info about constructor would do. Propositional equality, Data.Type.Equality? DataTypeable + Data.Data?
defaultTimeout = Timeout 100000

execIxStateT :: Functor m => IxStateT m i j () -> i -> m j
execIxStateT a s = snd `fmap` runIxStateT a s
