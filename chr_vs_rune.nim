from unicode import toUTF8, Rune

echo chr(65)
echo toUTF8(Rune(65))

# compile error: Error: cannot convert 25105 to range 0..255(int)
# echo chr(25105)
echo toUTF8(Rune(25105))
