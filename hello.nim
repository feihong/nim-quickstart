import random
import strformat
from unicode import toUTF8, Rune

# This is a comment
echo "你好世界！"

randomize()

for i in 0..10:
  let num = rand 0x4e00..0x9fff
  let hanzi = toUTF8(Rune(num))
  echo fmt"{i+1}. Random hanzi: {hanzi} ({num})"
