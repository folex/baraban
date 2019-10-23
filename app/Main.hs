{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import           Data.Maybe         (fromJust)
import           Lib
import           System.Environment (getArgs)

import Control.Lens

import Raft (Event(..), execIxStateT, timeout, follow, vote, Action, Timeout)
import RaftState (RaftState(..), CandidateState, WrappableState(..), followerTerm, votedTerm)
import           Control.Monad.Indexed.State

main = do
  args <- getArgs
  (port, host) <- getPortHost $ tail args
  case head args of
    "listen"  -> listenAt port host receiveRaft
    "connect" -> runTCPClient (fromJust host) port sendHeartbeat
    _         -> error usage


step :: IO Event -> RaftState -> IO ()
step getEvent = loop
  where
    handleEvent :: RaftState -> Event -> IO (Maybe Action, RaftState)
    handleEvent state event
      -- TODO: maybe match on (state, event)? Easier to handle common events
     =
      case state of
        Init state' ->
          case event of
            Heartbeat leader term -> run (follow leader term) state'
            _ -> stay state
        Follower state' ->
          case event of
            VoteRequest candidate term -> run (vote candidate term) state'
            Heartbeat leader term
              | term > (state' ^. followerTerm) -> run (follow leader term) state'
            Heartbeat _ _ -> stay state -- TODO: restart timer
            _ -> stay state
        Voted state' ->
          -- TODO: timeout if voting hanged?
          case event of
            Heartbeat leader term
              | term > (state' ^. votedTerm) -> run (follow leader term) state'
            Heartbeat _ _ -> stay state
            _ -> stay state
        -- TODO: leader
        _ -> stay state

    stay state = return (Nothing, state)

    wrapTuple :: (WrappableState s) => (a, s) -> (Maybe a, RaftState)
    wrapTuple (a, s) = (Just a, wrap s)

    run :: (Functor f, WrappableState s) => IxStateT f i s a -> i -> f (Maybe a, RaftState)
    run trans state = wrapTuple <$> runIxStateT trans state

    handleAction :: Maybe Action -> IO ()
    handleAction = \case
      Just Timeout tout -> putStrLn $ "waiting " ++ show tout
      Just WaitVotes rem -> putStrLn $ "votes to leader " ++ show rem
      _ -> putStrLn "Nothing to do"

    loop :: RaftState -> IO ()
    loop state = do
      event <- getEvent
      (action, state') <- handleEvent state event
      handleAction action
      loop state'
