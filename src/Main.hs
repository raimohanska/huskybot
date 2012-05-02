import System.Environment(getArgs)

import Network
import System.IO

import Text.JSON

main = getArgs >>= huskyBot

huskyBot [host, port, name] = do
  handle <- connectSocket host (read port)
  let json = encode $ toJSObject [("msgType", "join"), ("data", name)]
  hPutStrLn handle json
  hFlush handle
  putStrLn $ ">> " ++ json
  dumpStuff handle

huskyBot _ = putStrLn "USAGE : huskybot <host> <port> <name>"

connectSocket host port = connectTo host (PortNumber $ fromInteger port)

dumpStuff handle = do
  msg <- hGetLine handle
  putStrLn $ "<< " ++ msg
  dumpStuff handle
