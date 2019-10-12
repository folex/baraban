{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedLabels           #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeApplications           #-}

module Main where

import Control.Concurrent (forkFinally, forkIO)
import qualified Control.Exception as E
import Control.Monad (forever, unless, void)
import qualified Data.ByteString as S
import Data.ProtoLens (defMessage, buildMessage, parseMessage)
import Data.ProtoLens.Labels ()
import Lens.Micro
import Lens.Micro.Extras (view)
import Lib
import Network.Socket hiding (recv, recvFrom, send, sendTo)
import Network.Socket.ByteString
import Proto.Raft.Raft (Heartbeat)
import System.Environment (getArgs)
import System.IO (BufferMode(..), Handle, hGetLine, hPutStrLn, hSetBuffering)
import Data.ProtoLens.Runtime.Data.Word (Word32)

main :: IO ()
main =
  withSocketsDo $ do
    args <- getArgs
    (port, host) <-
      return $
      case args of
        [p] -> (p, Nothing)
        p:h:_ -> (p, Just h)
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
      return sock
    loop sock =
      forever $ do
        (conn, peer) <- accept sock
        putStrLn $ "Connection from " ++ show peer
        void $ forkFinally (talk conn) (\_ -> close conn)
    talk conn = do
      msg <- recv conn 1024
      unless (S.null msg) $ do
        sendAll conn msg
        talk conn

heartbeat :: Word32 -> Heartbeat
heartbeat t =
  defMessage
      & #term .~ t
