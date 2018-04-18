import algorithm

type
  Character = object
    name: string
    level: int

var characters = @[
  Character(name: "Bob", level: 4),
  Character(name: "Nancy", level: 7),
  Character(name: "Val", level: 3),
  Character(name: "Mononoke", level: 11)
]

characters.sort do (x, y: Character) -> int:
  return -cmp(x.level, y.level)

for ch in characters:
  echo ch
