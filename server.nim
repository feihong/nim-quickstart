import asynchttpserver, asyncdispatch
import json

var server = newAsyncHttpServer()
proc cb(req: Request) {.async.} =
  let data = %* {"msg": "你好世界！", "lucky_number": 888, "weather": "rain"}
  let headers = newHttpHeaders([("Content-Type","application/json")])
  await req.respond(Http200, $data, headers)

waitFor server.serve(Port(8000), cb)
