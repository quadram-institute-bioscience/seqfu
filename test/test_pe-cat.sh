
BIN="$SCRIPTS/pe-cat"
echo " 1. Print paired end to STDOUT as interleaved"

TOT=$($BIN -io $DATA/illumina_?.* | grep '^@A00'  | wc -l )
if [[ $TOT -eq 28 ]];
then   printf "  $PASS\n"; else   printf "$FAIL: expecting 14 sequence, $TOT found"; fi

echo " 2. Testing streaming I/O"

TOT=$($BIN -io $DATA/illumina_?.* | $BIN -io -i 2>/dev/null | grep '^@A00'  | wc -l )
if [[ $TOT -eq 28 ]];
then   printf "  $PASS\n"; else   printf "$FAIL: expecting 14 sequence, $TOT found"; fi
