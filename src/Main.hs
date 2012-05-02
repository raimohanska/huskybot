import System.Environment(getArgs)

import Network.Socket
import System.IO

import Text.JSON

main = getArgs >>= huskyBot

huskyBot [host, port, name] = do
  handle <- connectSocket host port
  let json = encode $ toJSObject [("msgType", "join"), ("data", name)]
  hPutStrLn handle json
  hFlush handle
  putStrLn $ ">> " ++ json
  dumpStuff handle

huskyBot _ = putStrLn "USAGE : huskybot <host> <port> <name>"

connectSocket host port = do
  addrinfos <- getAddrInfo Nothing (Just host) (Just port)
  let serveraddr = head addrinfos
  sock <- socket (addrFamily serveraddr) Stream defaultProtocol
  setSocketOption sock KeepAlive 1
  connect sock (addrAddress serveraddr)
  h <- socketToHandle sock ReadWriteMode
  hSetBuffering h (BlockBuffering Nothing)
  return h

dumpStuff handle = do
  msg <- hGetLine handle
  putStrLn $ "<< " ++ msg
  dumpStuff handle
