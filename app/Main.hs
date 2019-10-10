module Main where

import Control.Concurrent (forkFinally, forkIO)
import qualified Control.Exception as E
import Control.Monad (forever, unless, void)
import qualified Data.ByteString as S
import Lib
import Network.Socket hiding (send, sendTo, recv, recvFrom)
import Network.Socket.ByteString
import System.Environment (getArgs)
import System.IO (BufferMode(..), Handle, hGetLine, hPutStrLn, hSetBuffering)

--main = withSocketsDo $ do
--  args <- getArgs
--  let port = fromIntegral (read $ head args :: Int)
--  sock <- listen port
--  putStrLn $ "Listening on " ++ head args
--  sockHandler sock
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
--sockHandler :: Socket -> IO ()
--sockHandler sock = do
--  (handle, _, _) <- accept sock
--  hSetBuffering handle NoBuffering
--  forkIO $ commandProcessor handle
--  sockHandler sock
--commandProcessor :: Handle -> IO ()
--commandProcessor handle = do
--  line <- hGetLine handle
--  let cmd = words line
--  case head cmd of
--    "echo" -> echoCommand handle cmd
--    "add" -> addCommand handle cmd
--    _ -> hPutStrLn handle "Unknown command"
--  commandProcessor handle
--
--echoCommand :: Handle -> [String] -> IO ()
--echoCommand handle cmd = hPutStrLn handle (unwords $ tail cmd)
--
--addCommand :: Handle -> [String] -> IO ()
--addCommand handle cmd = hPutStrLn handle $ show $ (read $ cmd !! 1) + (read $ cmd !! 2)