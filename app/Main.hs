{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Concurrent        (forkFinally, forkIO, threadDelay)
import qualified Control.Exception         as E
import           Control.Monad             (forever, unless, void)
import qualified Data.ByteString           as S
import           Data.Either.Combinators   (fromRight')
import           Data.Maybe                (fromJust)
import           Data.Monoid               ((<>))
import           Data.ProtoLens            (showMessageWithRegistry)
import           Data.ProtoLens.Encoding   (encodeMessage)
import           Data.ProtoLens.Message    (register)
import           Data.Proxy                (Proxy (..))
import           Lib
import           Network.Socket            hiding (recv, recvFrom, send, sendTo)
import           Network.Socket.ByteString
import           Proto.Raft.Raft           (RaftMessage'Value (..))
import           Proto.Raft.Raft_Fields    (maybe'value)
import           System.Environment        (getArgs)

import           Lens.Family2              (view)

main :: IO ()
main = do
  args <- getArgs
  (port, host) <- getPortHost $ tail args
  case head args of
    "listen"  -> listenAt port host receiveRaft
    "connect" -> runTCPClient (fromJust host) port sendHeartbeat


