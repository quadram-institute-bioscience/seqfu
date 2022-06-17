
if [[ "NO" != "NO$DEBUG" ]]; then
  set -x pipefail
fi
BIN="$SCRIPTS/fu-rename"
#DATA="$SCRIPTS/../data"

echo " 1. Testing default"
MATCH=$($BIN  $DATA/test.fa | grep "test" | wc -l )
TOTAL=$($BIN  $DATA/test.fa | grep ">"    | wc -l )
if [[ $TOTAL -eq $MATCH ]];
then   printf "  $PASS\n";
else   printf "$FAIL: expecting $TOTAL sequence, $MATCH found\n"; fi

echo " 2. Renaming to DNA"
MATCH=$($BIN  -p DNA $DATA/test.fa | grep "DNA" | wc -l )
TOTAL=$($BIN  $DATA/test.fa | grep ">"    | wc -l )
if [[ $TOTAL -eq $MATCH ]];
then   printf "  $PASS\n";
else   printf "$FAIL: expecting $TOTAL sequence, $MATCH found\n"; fi

echo " 2. Stripping comments"
NOCOM=$($BIN  $DATA/test.fa --nocomments )
ORIGIN=$($BIN  $DATA/test.fa)
if [[ $TOTAL -eq $MATCH ]];
then   printf "  $PASS\n";
else   printf "$FAIL: expecting $TOTAL sequence, $MATCH found\n"; fi
