import klib
import re
import argparse
import tables, strutils
from os import fileExists

const prog = "fu-cov"
const version = "0.1.0"
#[
   extract contigs by coverage

]#

proc verbose(msg: string, print: bool) =
  if print:
    stderr.writeLine(" - ", msg)


proc format_dna(seq: string, format_width: int): string =
  if format_width == 0:
    return seq
  for i in countup(0,seq.len - 1,format_width):
    #let endPos = if (seq.len - i < format_width): seq.len - 1
    #            else: i + format_width - 1
    if (seq.len - i <= format_width):
      result &= seq[i..seq.len - 1]
    else:
      result &= seq[i..i + format_width - 1] & "\n"

var p = newParser(prog):
  help("Extract contig by sequence length and coverage, if provided in the sequence name.")
  flag("-v", "--verbose", help="Print verbose messages")
  option("-c", "--min-cov", help="Minimum coverage", default="0.0")
  option("-l", "--min-len", help = "Minimum length", default = "0")
  option("-x", "--max-cov", help = "Maximum coverage", default = "0.0")
  option("-y", "--max-len", help = "Maximum length", default = "0")
  arg("inputfile",  nargs = -1)
 
proc getNumberAfterPos(s: string, pos: int): float =
  var ans = ""
  let nums = @['0','1','2','3','4','5','6','7','8','9','0','.']
  for i in pos .. s.high:
    if s[i] notin nums:
      break
    ans.add(s[i])
  return parseFloat(ans)

proc getCovFromString(s: string): float =
  let prefixes = @["cov=", "multi=", "cov_"]
  for i in 0 .. s.high:
    for prefix in prefixes:
      if i + len(prefix) >= s.high:
        break
      if s[i ..< i + len(prefix)] == prefix:
        return getNumberAfterPos(s, i + len(prefix))



proc main(args: seq[string]) =

  try:
    var
      opts = p.parse(commandLineParams()) 
      skip_hi_cov = 0
      skip_lo_cov = 0
      skip_short  = 0
      skip_long   = 0
 
    if opts.inputfile.len() == 0:
      echo "Missing arguments."
      if not opts.help:
        echo "Type --help for more info."
      quit(0)
    
    for filename in opts.inputfile:      
      if not existsFile(filename):
        echo "FATAL ERROR: File ", filename, " not found."
        quit(1)

      var f = xopen[GzFile](filename)
      defer: f.close()
      var r: FastxRecord
      verbose("Reading " & filename, opts.verbose)

      # Prse FASTX
      var match: array[1, string]
      var c = 0

      while f.readFastx(r):
        c+=1
        # Always consider uppercase sequences
        r.seq = toUpperAscii(r.seq)

        if opts.min_len != "0" and len(r.seq) < parseInt(opts.min_len):
          skip_short += 1
          continue
        if opts.max_len != "0" and len(r.seq) > parseInt(opts.max_len):
          skip_long += 1
          continue
        
        if opts.min_cov != "0.0" or opts.max_cov != "0.0":
          var cov = getCovFromString(r.name & " " & r.comment)
          if opts.min_cov != "0.0" and cov < parseFloat(opts.min_cov):
            skip_lo_cov += 1
            continue
          if opts.max_cov != "0.0" and cov > parseFloat(opts.max_cov):
            skip_hi_cov += 1
            continue

        echo ">", r.name, " ", r.comment, "\n", r.seq;
       
  except:
    echo p.help
    stderr.writeLine("Arguments error: ", getCurrentExceptionMsg())
    quit(0)
  

when isMainModule:
  main(commandLineParams())
