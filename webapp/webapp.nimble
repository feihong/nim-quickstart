# Package

version       = "0.1.0"
author        = "Feihong Hsu"
description   = "A new awesome Nim web app"
license       = "MIT"
srcDir        = "src"
bin           = @["app"]
skipExt       = @["nim"]

# Dependencies

requires "nim >= 0.18.0"
requires "jester >= 0.2.0"
