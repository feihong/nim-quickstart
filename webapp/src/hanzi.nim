import unicode, random, future, strutils

proc randomHanzi(): string =
  let num = rand 0x4e00..0x9fff
  toUTF8(Rune(num))

proc hanziString*(count: int): string =
  let posCount = if count < 1: 1
                 else: count
  let hanziSeq = lc[randomHanzi() | (x <- 1..posCount), string]
  join(hanziSeq, ", ")
