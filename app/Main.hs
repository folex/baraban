{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Control.Concurrent (forkFinally, forkIO)
import Control.Monad (forever, unless, void)
import Data.Maybe (fromJust)
import Network.Socket (Socket)
import Network.Socket.ByteString
import System.Environment (getArgs)
import qualified Control.Exception as E
import qualified Data.ByteString as S

main :: IO ()
main = do
  args <- getArgs
  (port, host) <- getPortHost $ tail args
  case head args of
    "listen" -> listenAt port host receive
    "connect" -> connectTo port $ fromJust host

receive :: Socket -> IO ()
receive conn = do
  msg <- recv conn 1024
  unless (S.null msg) $ do
    let raft = decodeRaftMessage msg
    putStrLn $ "Got message " ++ show raft

connectTo :: String -> String -> IO ()
connectTo port host = putStrLn $ "TODO: Will connect to " ++ host ++ ":" ++ port