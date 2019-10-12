{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Control.Concurrent (forkFinally, forkIO, threadDelay)
import Control.Monad (forever, unless, void)
import Data.Maybe (fromJust)
import Network.Socket hiding (recv, recvFrom, send, sendTo)
import Network.Socket.ByteString
import System.Environment (getArgs)
import Data.ProtoLens.Encoding (encodeMessage)
import qualified Control.Exception as E
import qualified Data.ByteString as S

main :: IO ()
main = do
  args <- getArgs
  (port, host) <- getPortHost $ tail args
  case head args of
    "listen" -> listenAt port host receiveRaft
    "connect" -> runTCPClient (fromJust host) port sendHeartbeat

receiveRaft :: Socket -> IO ()
receiveRaft socket = forever $ do
  msg <- recv socket 1024
  unless (S.null msg) $ do
    let raft = decodeRaftMessage msg
    putStrLn $ "Got message " ++ show raft

sendHeartbeat :: Socket -> IO()
sendHeartbeat socket = repeatedly $ sendAll socket ping
  where
    ping = encodeMessage $ heartbeat 1000
    repeatedly action = forever $ threadDelay (1 * 1000000) >> action
