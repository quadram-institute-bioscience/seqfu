# Package
version       = "0.9.0"
author        = "Andrea Telatin"
description   = "SeqFU command-line tools"
license       = "MIT"

# Dependencies
requires "nim >= 0.17.2", "docopt", "terminaltables"

srcDir = "src"
bin = @["seqfu"]

task seqfu, "compile SeqFU":
  mkdir  "bin"
  exec "nimble c -d:release  --opt:speed -p:lib/ --out:bin/seqfu src/sfu"

task makedebug, "compile SeqFU":
  mkdir  "bin"
  exec "nimble c -p:lib/ --out:bin/seqfu_debug src/sfu"
