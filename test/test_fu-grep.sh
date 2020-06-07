
BIN="$SCRIPTS/fu-grep"
#DATA="$SCRIPTS/../data"

echo " 1. Testing grep with annotation on gzipped file"
TOT=$($BIN -a GAT $DATA/compressed.fasta.gz | grep '>' |wc -l)
if [[ $TOT -eq 1 ]];
then   printf "  $PASS\n"; else   printf "$FAIL: expecting 1 sequence, $TOT found"; fi

echo " 2. Testing annotation"

MATCHES=$($BIN -a GAT $DATA/compressed.fasta.gz | grep -o matches=. )
if [[ $MATCHES == 'matches=2' ]];
then   printf "  $PASS\n"; else   printf "$FAIL: expecting annotation 'maatches=2', $MATCHES found"; fi
