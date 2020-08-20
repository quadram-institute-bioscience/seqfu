import klib
import re
import argparse
import strutils
import stats
import strformat
from os import fileExists
import algorithm 

const prog = "fu-cov"
const version = "0.3.0"

#[
   extract contigs by coverage

  0.3   Added in memory sorting
  0.2   Added statistics
]#


# Chars in numbers (floating)
let nums = @['0','1','2','3','4','5','6','7','8','9','0','.']
# Coverage strings in assembly outputs (spades, unicycler, megahit, shovill, skesa)
let prefixes = @["cov=", "multi=", "cov_", "depth="]

# Contig data
type
    ContigInfo = tuple[name: string, comment: string, cov: float, length: int, sequence: string]
var
  covStats: RunningStat
  lenStats: RunningStat
  ctgData = newSeq[ContigInfo]()


proc rev[T](xs: openarray[T]): seq[T] =
  result = newSeq[T](xs.len)
  for i, x in xs:
    #result[^i-1] = x # or: 
    result[xs.high-i] = x

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
  flag("-s", "--sort", help="Store contigs in memory and sort by descending coverage")
  option("-c", "--min-cov", help="Minimum coverage", default="0.0")
  option("-l", "--min-len", help = "Minimum length", default = "0")
  option("-x", "--max-cov", help = "Maximum coverage", default = "0.0")
  option("-y", "--max-len", help = "Maximum length", default = "0")
  option("-t", "--top", help = "Print the first TOP sequences (passing filters) when using --sort", default="1")
  arg("inputfile",  nargs = -1)
 
proc getNumberAfterPos(s: string, pos: int): float =
  var ans = ""  
  for i in pos .. s.high:
    if s[i] notin nums:
      break
    ans.add(s[i])
  return parseFloat(ans)

proc getCovFromString(s: string): float =
  for i in 0 .. s.high:
    for prefix in prefixes:
      if i + len(prefix) >= s.high:
        break
      if s[i ..< i + len(prefix)] == prefix:
        return getNumberAfterPos(s, i + len(prefix))
  return -1



proc main(args: seq[string]) =

  try:
    var
      opts = p.parse(commandLineParams()) 
      skip_hi_cov = 0
      skip_lo_cov = 0
      skip_short  = 0
      skip_long   = 0
      covTable    = newSeq[ContigInfo]()

 
    if opts.inputfile.len() == 0:
      echo "Missing arguments."
      if not opts.help:
        echo "Type --help for more info."
      quit(0)

    var
      c  = 0      # total count of sequences
      pf = 0      # passing filters 
      ff = 0      # parsed files 
    for filename in opts.inputfile:      
      if not existsFile(filename):
        echo "FATAL ERROR: File ", filename, " not found."
        quit(1)

      var f = xopen[GzFile](filename)
      defer: f.close()
      var r: FastxRecord
      verbose("Reading " & filename, opts.verbose)
      ff += 1
      # Prse FASTX
      var match: array[1, string]


      while f.readFastx(r):
        c+=1

        if opts.min_len != "0" and len(r.seq) < parseInt(opts.min_len):
          skip_short += 1
          continue
        if opts.max_len != "0" and len(r.seq) > parseInt(opts.max_len):
          skip_long += 1
          continue
        
        lenStats.push(len(r.seq))

        # Coverage check
        var cov = getCovFromString(r.name & " " & r.comment)
        if cov >= 0:
          covStats.push(cov)
          
          if opts.min_cov != "0.0" and cov < parseFloat(opts.min_cov):
            skip_lo_cov += 1
            continue
          if opts.max_cov != "0.0" and cov > parseFloat(opts.max_cov):
            skip_hi_cov += 1
            continue
        
        pf += 1
        if opts.sort == false:
          echo ">", r.name, " ", r.comment, "\n", r.seq;
        else:
          covTable.add((name: r.name, comment: r.comment, cov: cov, length: len(r.seq), sequence: r.seq))
      
    stderr.writeLine(pf, "/", lenStats.n, " sequences printed (", covStats.n ," with coverage info) from ", ff , " files.")
    stderr.writeLine(fmt"Skipped:          {skip_short} too short, {skip_long} too long, then {skip_lo_cov} low coverage, {skip_hi_cov} high coverage, .")
    stderr.writeLine(fmt"Average length:   {lenStats.mean():.2f} bp, [{lenStats.min} - {lenStats.max}]")
    if covStats.n > 0:
      stderr.writeLine(fmt"Average coverage: {covStats.mean():.2f}X, [{covStats.min:.1f}-{covStats.max:.1f}]")

    if opts.sort == true:
      var
        top = 0
      for i in rev(covTable.sortedByIt(it.cov)):
        top += 1
        echo ">", i.name, " ", i.comment, "\n", i.sequence
        if top > parseInt(opts.top):
          break
      
  except:
    echo p.help
    stderr.writeLine("Arguments error: ", getCurrentExceptionMsg())
    quit(0)
  

when isMainModule:
  main(commandLineParams())
