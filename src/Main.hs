import System.Environment(getArgs)
import Network.TCP(openTCPPort)
import Network.Stream
import Text.JSON

main = getArgs >>= huskyBot

huskyBot [name] = do
  conn <- openTCPPort "localhost" 8090
  let json = encode $ toJSObject [("msgType", "join"), ("data", name)]
  writeBlock conn json
  putStrLn $ ">> " ++ json
  dumpStuff conn

huskyBot _ = putStrLn "USAGE : huskybot <name>"

dumpStuff conn = do
  result <- readLine conn
  case result of
    Left err -> fail (show err)
    Right msg -> putStrLn $ "<< " ++ msg
  dumpStuff conn
