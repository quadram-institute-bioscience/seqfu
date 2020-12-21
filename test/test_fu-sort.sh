
if [[ "NO" != "NO$DEBUG" ]]; then
  set -x pipefail
fi

BIN="$SCRIPTS/fu-sort"
#DATA="$SCRIPTS/../data"

echo " 1. Testing default"
MATCH=$($BIN  $DATA/compressed.fasta.gz | head -n 1 | grep "SEQ1_BamHI-EcoRI" |wc -l )

if [[  $MATCH -eq 1 ]];
then   printf "  $PASS\n";
else   printf "$FAIL: expecting 1 sequence, $MATCH found\n"; fi

echo " 2. Ascending order"
MATCH=$($BIN  $DATA/compressed.fasta.gz  --asc | head -n 1 | grep "Seq3" |wc -l )
if [[ $MATCH -eq 1 ]];
then   printf "  $PASS\n";
else   printf "$FAIL: expecting 1 sequence, $MATCH found\n"; fi
