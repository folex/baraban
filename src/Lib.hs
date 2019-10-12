{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( getPortHost
  , listenAt
  , runTCPClient
  , heartbeat
  , decodeHeartbeat
  , decodeRaftMessage
  ) where

import Control.Concurrent (forkFinally, forkIO)
import qualified Control.Exception as E
import Control.Monad (forever, unless, void)
import qualified Data.ByteString as S
import Data.Maybe (fromJust)
import Data.ProtoLens (buildMessage, defMessage, parseMessage)
import Data.ProtoLens.Encoding (decodeMessage, encodeMessage)
import Data.ProtoLens.Labels ()
import Data.ProtoLens.Runtime.Data.Word (Word32)
import Lens.Micro
import Lens.Micro.Extras (view)
import Network.Socket hiding (recv, recvFrom, send, sendTo)
import Network.Socket.ByteString
import Proto.Raft.Raft
import System.Environment (getArgs)
import System.IO (BufferMode(..), Handle, hGetLine, hPutStrLn, hSetBuffering)

-- CLI 
getPortHost :: [String] -> IO (String, Maybe HostName)
getPortHost args =
  return $
  case args of
    [p] -> (p, Nothing)
    p:(h:_) -> (p, Just h)

-- Network functions
listenAt :: String -> Maybe HostName -> (Socket -> IO ()) -> IO ()
listenAt port host talk =
  withSocketsDo $ do
    addr <- resolve port host
    E.bracket (open addr) close loop
  where
    resolve port host = do
      let hints = defaultHints {addrFlags = [AI_PASSIVE], addrSocketType = Stream}
      addr:_ <- getAddrInfo (Just hints) host (Just port)
      return addr
    open addr = do
      sock <- socket (addrFamily addr) (addrSocketType addr) (addrProtocol addr)
      setSocketOption sock ReuseAddr 1
      bind sock (addrAddress addr)
        -- If the prefork technique is not used,
        -- set CloseOnExec for the security reasons.
      let fd = fdSocket sock
      setCloseOnExecIfNeeded fd
      listen sock 10
      putStrLn $ "Listening at " ++ show addr
      return sock
    loop sock =
      forever $ do
        (conn, peer) <- accept sock
        putStrLn $ "Connection from " ++ show peer
        void $ forkFinally (talk conn) (\_ -> close conn)

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

-- Protobuf funtions
heartbeat :: Word32 -> Heartbeat
heartbeat t = defMessage & #term .~ t

decodeHeartbeat :: S.ByteString -> Either String Heartbeat
decodeHeartbeat = decodeMessage

decodeRaftMessage :: S.ByteString -> Either String RaftMessage
decodeRaftMessage = decodeMessage