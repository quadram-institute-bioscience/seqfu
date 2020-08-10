# Package
version       = "0.9.0"
author        = "Andrea Telatin"
description   = "SeqFU command-line tools"
license       = "MIT"

# Dependencies
requires "nim >= 0.17.2", "docopt"

srcDir = "src"
bin = @["seqfu"]

task named_build, "custom build":
  mkdir -p "bin"
  exec "nimble c  --opt:speed --out:bin/seqfu src/seqfu"
