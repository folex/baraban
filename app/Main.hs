{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Data.Maybe         (fromJust)
import           Lib
import           System.Environment (getArgs)

main = do
  args <- getArgs
  (port, host) <- getPortHost $ tail args
  case head args of
    "listen"  -> listenAt port host receiveRaft
    "connect" -> runTCPClient (fromJust host) port sendHeartbeat
    _         -> error usage
