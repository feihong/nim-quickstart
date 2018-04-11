import asynchttpserver, asyncdispatch
import json

var server = newAsyncHttpServer()
proc cb(req: Request) {.async.} =
  await req.respond(Http200, "你好世界！")

waitFor server.serve(Port(8000), cb)
