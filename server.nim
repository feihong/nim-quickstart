import random
import asynchttpserver, asyncdispatch
import json

randomize()

const weatherChoices = @["rain", "sun", "snow", "hail"]

var server = newAsyncHttpServer()
proc cb(req: Request) {.async.} =
  let data = %* {"message": "你好世界！",
                 "lucky_number": rand 666..888,
                 "weather": weatherChoices.rand()}
  let headers = newHttpHeaders([("Content-Type","application/json")])

  echo "Pause a bit like we are doing some intense computation"
  await sleepAsync 2500

  await req.respond(Http200, $data, headers)

waitFor server.serve(Port(8000), cb)
