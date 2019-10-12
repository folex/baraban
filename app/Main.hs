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
    "listen" -> listenAt port host receive
    "connect" -> connectTo (fromJust host) port

receive :: Socket -> IO ()
receive conn = forever $ do
  msg <- recv conn 1024
  unless (S.null msg) $ do
    let raft = decodeRaftMessage msg
    putStrLn $ "Got message " ++ show raft

connectTo :: String -> String -> IO ()
connectTo host port = runTCPClient host port talk
  where
    talk conn = repeatedly $ sendAll conn $ encodeMessage $ heartbeat 1000
    repeatedly action = forever $ threadDelay (1 * 1000000) >> action


runTCPClient :: HostName -> ServiceName -> (Socket -> IO ()) -> IO ()
runTCPClient host port client = withSocketsDo $ do
    addr <- resolve
    E.bracket (open addr) close client
  where
    resolve = do
        let hints = defaultHints { addrSocketType = Stream }
        head <$> getAddrInfo (Just hints) (Just host) (Just port)
    open addr = do
        sock <- socket (addrFamily addr) (addrSocketType addr) (addrProtocol addr)
        connect sock $ addrAddress addr
        return sock