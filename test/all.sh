#!/bin/bash
TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SCRIPTS="$TEST_DIR/../bin"
INPUT="$TEST_DIR/../data/test.fa"

echo -ne "[fq-len]\tcheck minimum length:\t"
MIN_LEN=$($SCRIPTS/fu-len.pl -m 100 $INPUT | wc -l)
if [[ $MIN_LEN -eq 8 ]]; then
	echo "PASS"
else
	echo "FAIL ($MIN_LEN != 8)"
	exit
fi

echo -ne "[fq-len]\tmin and max length:\t"
MINMAX=$($SCRIPTS/fu-len.pl -m 10 -x 150 $INPUT | wc -l)
if [[ $MINMAX -eq 2 ]]; then
	echo "PASS"
else
	echo "FAIL ($MINMAX != 2)"
	exit
fi

echo -ne "[fq-grep]\tcheck forward match:\t"
GREP1=$($SCRIPTS/fu-grep.pl   CCCC $INPUT |wc -l )                                                      
if [[ $GREP1 -eq 8 ]]; then
	echo "PASS"
else
	echo "FAIL ($GREP1 != 8)"
	exit
fi

echo -ne "[fq-grep]\tcheck reverse compl.:\t"
GREP2=$($SCRIPTS/fu-grep.pl   GGGG $INPUT |wc -l )                                                      
if [[ $GREP2 -eq 8 ]]; then
	echo "PASS"
else
	echo "FAIL ($GREP2 != 8)"
	exit
fi

echo -ne "[fq-rename]\tcheck prefix rename:\t"
RENAME=$($SCRIPTS/fu-rename.pl $INPUT -p new_prefix | grep new_prefix | wc -l)                                                      
if [[ $RENAME -eq 8 ]]; then
	echo "PASS"
else
	echo "FAIL ($RENAME != 8)"
	exit
fi




