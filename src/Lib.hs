{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( getPortHost
  , usage
  , listenAt
  , runTCPClient
  , heartbeat
  , decodeHeartbeat
  , raftMessage
  , decodeRaftMessage
  , decodeRaftMessage'
  , encodeRaftMessage
  , receiveRaft
  , sendHeartbeat
  ) where

import           Control.Concurrent               (forkFinally, threadDelay)
import qualified Control.Exception                as E
import           Control.Monad                    (forever, unless, void)
import qualified Data.ByteString                  as S
import           Data.Either.Combinators          (fromRight')
import           Data.Maybe                       (fromJust)
import           Data.ProtoLens                   (defMessage)
import           Data.ProtoLens.Encoding          (decodeMessage, encodeMessage)
import           Data.ProtoLens.Labels            ()
import           Data.ProtoLens.Runtime.Data.Word (Word32)
import           Lens.Micro
import           Lens.Micro.Extras                (view)
import           Network.Socket                   hiding (recv, recvFrom, send)
import           Network.Socket.ByteString
import           Proto.Raft.Raft
import           Proto.Raft.Raft_Fields           (maybe'value)

-- CLI
getPortHost :: [String] -> IO (String, Maybe HostName)
getPortHost args =
  return $
  case args of
    [p]     -> (p, Nothing)
    p:(h:_) -> (p, Just h)
    []      -> error usage

usage = "Usage: ./baraban (connect | listen) port [host]"

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
      listen sock 10 -- max number of queued connections
      putStrLn $ "Listening at " ++ show addr
      return sock
    loop sock =
      forever $ do
        (conn, peer) <- accept sock
        putStrLn $ "Connection from " ++ show peer
        void $ forkFinally (talk conn) (\_ -> close conn)

runTCPClient :: HostName -> ServiceName -> (Socket -> IO ()) -> IO ()
runTCPClient host port client =
  withSocketsDo $ do
    addr <- resolve
    E.bracket (open addr) close client
  where
    resolve = do
      let hints = defaultHints {addrSocketType = Stream}
      head <$> getAddrInfo (Just hints) (Just host) (Just port)
    open addr = do
      sock <- socket (addrFamily addr) (addrSocketType addr) (addrProtocol addr)
      connect sock $ addrAddress addr
      return sock

receiveRaft :: Socket -> IO ()
receiveRaft socket =
  forever $ do
    msg <- recv socket 1024
    unless (S.null msg) $
      case decodeRaftMessage' msg of
        RaftMessage'Heartbeat hb -> putStrLn $ "Got heartbeat " ++ show hb
        etc -> putStrLn $ "Got something else " ++ show etc

sendHeartbeat :: Socket -> IO ()
sendHeartbeat socket = repeatedly $ sendAll socket ping
  where
    ping = encodeRaftMessage $ heartbeat 1000
    repeatedly action = forever $ threadDelay (1 * 1000000) >> action

-- Protobuf funtions
heartbeat :: Word32 -> Heartbeat
heartbeat t = defMessage & #term .~ t

raftMessage :: RaftMessage
raftMessage = defMessage & #heartbeat .~ heartbeat 1000

decodeHeartbeat :: S.ByteString -> Either String Heartbeat
decodeHeartbeat = decodeMessage

decodeRaftMessage :: S.ByteString -> Either String RaftMessage
decodeRaftMessage = decodeMessage

decodeRaftMessage' :: S.ByteString -> RaftMessage'Value
decodeRaftMessage' m = fromJust $ view maybe'value $ fromRight' $ decodeRaftMessage m

encodeRaftMessage :: (RaftMsg msg) => msg -> S.ByteString
encodeRaftMessage = encodeMessage . wrap

-- Protobuf Typeclasses
class RaftMsg a where
  wrap :: a -> RaftMessage

instance RaftMsg Heartbeat where
  wrap heartbeat = defMessage & #heartbeat .~ heartbeat

instance RaftMsg Vote where
  wrap vote = defMessage & #vote .~ vote

instance RaftMsg Stand where
  wrap stand = defMessage & #stand .~ stand

instance RaftMsg Leader where
  wrap leader = defMessage & #leader .~ leader
