BIN="$SCRIPTS"/fu-cat
echo "Dereplication: "
TOT=$($SCRIPTS/fu-cat $DATA/test.fa $DATA/test.fa  | grep -c '>')
DER=$($SCRIPTS/fu-cat $DATA/test.fa $DATA/test.fa --dereplicate  | grep -c '>')
if [[ $TOT -ne $DER ]];
then   printf "  $PASS\n"; else   printf "$FAIL: dereplication should bring $DER < $TOT"; fi

