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

module RaftState where

import           Control.Monad.Indexed
import           Control.Monad.Indexed.State
import           Data.Maybe
import           Network.Socket                (AddrInfo, Socket)

import           Control.Lens
import qualified Control.Lens                  as Lens

import           Control.Monad.Indexed.Prelude
import           Control.Monad.Indexed.State   (IxMonadState, imodify)

data Term =
  Term Int
  deriving (Eq, Show, Ord)

newtype NodeId =
  NodeId String
  deriving (Eq, Show)

data Node =
  Node
    { _id         :: NodeId
    , _addr       :: AddrInfo
    , _neighbours :: [Node]
    }
  deriving (Eq, Show)

makeLenses ''Node

-- State
data InitState =
  InitState
    { _initNode :: Node
    }
  deriving (Eq, Show)

makeLenses ''InitState

data FollowerState =
  FollowerState
    { _leader :: NodeId
    , _followerTerm :: Term
    , _followerNode :: Node
    }
  deriving (Eq, Show)

makeLenses ''FollowerState

data VotedState =
  VotedState
    { _votedTerm :: Term
    , _votedNode :: Node
    , _votedFor  :: NodeId
    }
  deriving (Eq, Show)

makeLenses ''VotedState

data CandidateState =
  CandidateState
    { _candidateTerm  :: Term
    , _candidateNode  :: Node
    , _candidateVotes :: [NodeId]
    }
  deriving (Eq, Show)

makeLenses ''CandidateState

data LeaderState =
  LeaderState
    { _leaderTerm :: Term
    , _leaderNode :: Node
    }
  deriving (Eq, Show)

makeLenses ''LeaderState

data RaftState
  = Init InitState
  | Follower FollowerState
  | Voted VotedState
  | Candidate CandidateState
  | Leader LeaderState
  deriving (Eq, Show)

class WrappableState s where
  wrap :: s -> RaftState

instance WrappableState InitState where
  wrap = Init

instance WrappableState FollowerState where
  wrap = Follower

instance WrappableState VotedState where
  wrap = Voted

instance WrappableState CandidateState where
  wrap = Candidate

instance WrappableState LeaderState where
  wrap = Leader

class HasNode s where
  node :: s -> Node

instance HasNode InitState where
  node = view initNode

instance HasNode FollowerState where
  node = view followerNode

instance HasNode VotedState where
  node = view votedNode

instance HasNode CandidateState where
  node = view candidateNode

instance HasNode LeaderState where
  node = view leaderNode

--
--
--
--data State
--  = Init
--  | Follower
--  | Voted
--  | Candidate
--  | Leader
--type family RaftState (s :: State) where
--  RaftState 'Follower = FollowerState
--  RaftState 'Voted = VotedState
--  RaftState 'Candidate = CandidateState
--  RaftState 'Leader = LeaderState

-- Transition
--data Transition (from :: State) (to :: State) where
--  FollowerToVoted :: Transition 'Follower 'Voted
--  FollowerToCandidate :: Transition 'Follower 'Candidate
--  CandidateToLeader :: Transition 'Candidate 'Leader
--  -- fallback (higher term, etc)
--  VotedToFollower :: Transition 'Voted 'Follower
--  CandidateToFollower :: Transition 'Candidate 'Follower
--  LeaderToFollower :: Transition 'Leader 'Follower
--  Stay :: Transition a a
