{-# LANGUAGE OverloadedStrings, FlexibleInstances #-}
import System.Environment(getArgs)

import Network
import Control.Monad
import System.IO(Handle, hFlush, hPutChar)
import Data.Aeson
import qualified Data.Aeson.Generic as GJ
import Data.Maybe
import Data.Data
import Data.Typeable
import qualified Data.ByteString.Lazy.Char8 as L

import Domain

main = do
  handle <- connectSocket "localhost" 8080
  let name = "rapala" :: String
  send handle "join" name
  handleMessages handle

connectSocket host port = connectTo host (PortNumber $ fromInteger port)

send :: ToJSON a => Handle -> String -> a -> IO ()
send h msgType msgData = do
  let json = encode $ object ["msgType" .= msgType, "data" .= msgData]
  L.hPut h $ json
  hPutChar h '\n'
  hFlush h
  --putStrLn $ ">> " ++ (show json)

handleMessages h = do
  lines <- liftM (L.split '\n') $ L.hGetContents h
  forM_ lines $ \msg -> do
    case decode msg of
      Just json -> do
        let (msgType, msgData) = fromOk $ fromJSON json
        handleMessage h msgType msgData
      Nothing -> fail $ "Error parsing JSON: " ++ (show msg)

handleMessage ::Handle -> [Char] -> Value -> IO ()
handleMessage h "chessboard" boardJson = do
  let board = fromOk $ GJ.fromJSON boardJson :: ChessBoard
  putStrLn $ "<< " ++ (show board)

instance FromJSON (String, Value) where
  parseJSON (Object v) = do
    msgType <- v .: "msgType"
    msgData <- v .: "data"
    return (msgType, msgData)
  parseJSON x          = fail $ "Not an JSON object: " ++ (show x)

-- JSON helpers --
fromOk (Success x) = x
