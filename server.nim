import
  random, strformat, unicode, parsecfg, strutils, times, json
import asynchttpserver, asyncdispatch

randomize()

const weatherChoices = ["rain", "sun", "snow", "hail"]

proc cb(req: Request) {.async.} =
  case req.url.path
  of "/json", "/json/":
    let data = %* {"message": "你好世界！",
                   "lucky_number": rand 666..888,
                   "weather": weatherChoices.rand()}
    let headers = newHttpHeaders([("Content-Type","application/json")])
    await req.respond(Http200, $data, headers)
  else:
    let num = rand 0x4e00..0x9fff
    let hanzi = toUTF8(Rune(num))
    let timestr = format(now(), "MMMM d, yyyy h:mm t")
    let html = fmt"""
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
      </head>
      <body>
      <div style="font-size: 6rem">{hanzi}</div>
      <p>Time: {timestr}</p>
      </body>
    </html>
    """
    await req.respond(Http200, html)

let cfg = loadConfig("server.ini")
let port = Port(cfg.getSectionValue("", "port").parseUInt)
let server = newAsyncHttpServer()
waitFor server.serve(port, cb)
