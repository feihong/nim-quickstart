import random, unicode, future, strutils, strformat
import asyncdispatch
import jester

proc randomHanzi(): string =
  let num = rand 0x4e00..0x9fff
  toUTF8(Rune(num))

proc hanziString(count: int): string =
  let posCount = if count < 1: 1
                 else: count
  let hanziSeq = lc[randomHanzi() | (x <- 1..posCount), string]
  join(hanziSeq, ", ")

settings:
  port = Port(8000)

routes:
  get "/@count?":
    let count = if @"count" == "":
                  5
                else:
                  parseInt(@"count")
    resp fmt"""
      <meta charset="utf-8"><h1>{hanziString(count)}</h1>
    """

runForever()
