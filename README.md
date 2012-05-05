HuskyBot
========

Starting point for building a Haskell game bot for the upcoming Reaktor code camp.

Game Protocol
=============

- JSON over TCP/IP
- Single JSON object message per line (separated by `\n`)
- Message structure consists of `msgType` and `data`
- Client starts with a JOIN message:

~~~ json
     {"msgType":"join","data":"lollerström"}
~~~

- Client waits until server starts a game
- Start message is a list of player names:

~~~ json
     {"msgType":"gameStarted","data":["lollerström", "ökytunkkaaja"]}
~~~

- During game, client/server communicate with game-specific messages
- Game end message contains the name of the winner:

~~~ json
     {"msgType":"gameEnded","data":{"winner":"ökytunkkaaja"}}
~~~

- When playing a tournament, multiple games are played. The single TCP connection must be maintained even between games.
- If a players disconnects during tournament, there's no way to reconnect.
- Prepare for non-recognized message types!

