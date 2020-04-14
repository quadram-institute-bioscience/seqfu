echo "Count lines of of a sinfle FASTA file: "
TOT=$($SCRIPTS/fu-count $DATA/test.fa  | awk ' {sum+=$2} END {print sum}')
if [[ $TOT -eq 8 ]];
then   printf "  $PASS\n"; else   printf "$FAIL: expecting 8 sequence, $TOT found"; fi

echo "Count lines of two files, one being gzipped: "
TOT=$($SCRIPTS/fu-count $DATA/test.fa $DATA/test_4.fa.gz | awk ' {sum+=$2} END {print sum}')
if [[ $TOT -eq 40 ]];
then   printf "  $PASS\n"; else   printf "$FAIL: expecting 40 sequence, $TOT found"; fi

echo "Count lines in JSON format: "
GZIP=$(ls  data/*fa*gz  |wc -l)
JSON=$($SCRIPTS/fu-count -p data/*fa* | grep compressed| cut -f2 -d: | sed 's/,//'| awk ' {sum+=$1} END {print sum}')
if [[ $JSON -eq $GZIP ]];
then   printf "  $PASS\n"; else   printf "$FAIL: expecting $GZIP compressed, $JSON found"; fi
