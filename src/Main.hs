import System.Environment(getArgs)

import Network.Socket
import System.IO

import Text.JSON

main = getArgs >>= huskyBot

huskyBot [name] = do
  handle <- connectSocket "localhost" 8090
  let json = encode $ toJSObject [("msgType", "join"), ("data", name)]
  hPutStrLn handle json
  hFlush handle
  putStrLn $ ">> " ++ json
  dumpStuff handle

huskyBot _ = putStrLn "USAGE : huskybot <name>"

connectSocket host port = do
  addrinfos <- getAddrInfo Nothing (Just host) (Just (show port))
  let serveraddr = head addrinfos
  sock <- socket (addrFamily serveraddr) Stream defaultProtocol
  setSocketOption sock KeepAlive 1
  connect sock (addrAddress serveraddr)
  h <- socketToHandle sock WriteMode
  hSetBuffering h (BlockBuffering Nothing)
  return h

dumpStuff handle = do
  msg <- hGetLine handle
  putStrLn $ "<< " ++ msg
  dumpStuff handle
