import
  random, strformat, unicode, parsecfg, strutils, sequtils, times, json, tables
import asynchttpserver, asyncdispatch, cgi

randomize()

const weatherChoices = ["rain", "sun", "snow", "hail"]

proc getParams(query: string) : Table[string, string] =
  result = {"count": "1"}.toTable
  for k, v in cgi.decodeData(query):
    result[k] = v

proc randomHanzi() : string =
  let num = rand 0x4e00..0x9fff
  toUTF8(Rune(num))

proc hanziString(count : int) : string =
  let posCount = if count < 1: 1
                 else: count
  var hanziSeq = newSeq[string](posCount)
  for i in 0..<posCount:
    hanziSeq[i] = randomHanzi()
  join(hanziSeq, ", ")

proc cb(req: Request) {.async.} =
  # echo req.url.path
  case req.url.path
  of "/json", "/json/":
    let data = %* {"message": "你好世界！",
                   "lucky_number": rand 666..888,
                   "weather": weatherChoices.rand()}
    let headers = newHttpHeaders([("Content-Type", "application/json")])
    await req.respond(Http200, $data, headers)
  else:
    let params = getParams(req.url.query)
    let count = try: params["count"].parseInt
                except: 1
    let timestr = times.format(now(), "MMMM d, yyyy h:mm:ss tt")
    let html = fmt"""
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
      </head>
      <body>
      <p>Generated: {timestr}</p>
      <div style="font-size: 6rem">{hanziString(count)}</div>
      </body>
    </html>
    """
    await req.respond(Http200, html)

let cfg = loadConfig("server.ini")
let port = cfg.getSectionValue("", "port").parseUInt.Port
let server = newAsyncHttpServer()
waitFor server.serve(port, cb)
