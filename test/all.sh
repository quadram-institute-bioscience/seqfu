#!/bin/bash
TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SCRIPTS="$TEST_DIR/../bin"
DATA="$TEST_DIR/../data/"
INPUT="$DATA/test.fa"
PASS="\e[32mPASS\e[0m"
FAIL="\e[31m** FAIL **\e[0m"
echo -e "Env path:\t$(which env)"
echo -e "Perl path:\t$(which perl)"
echo -e "Perl version:\t$(env perl -v | grep version)"

echo -e "conda_prefix:\t$CONDA_PREFIX"
echo -e "conda_prompt:\t$CONDA_PROMPT_MODIFIER"
echo -e "current_path:\t$PWD"
echo -e "list_binaries:\n"$(ls "$SCRIPTS")
echo ''

chmod +x "$SCRIPTS"/*

if [ ! -e "$INPUT" ]; then
	echo "Input file ($INPUT) not found"
fi

set -x pipefail

$SCRIPTS/fu-len      -m 150 -x 170 $INPUT
$SCRIPTS/fu-grep   GGGGGGGGGGGGGGG $INPUT
set -eo pipefail
set +x pipefail


# ----------------------------------------------------------------

echo -ne "[fq-len]\tcheck minimum length:\t"
MIN_LEN=$($SCRIPTS/fu-len -m 100 $INPUT 2>/dev/null | wc -l)
if [[ $MIN_LEN -eq 8 ]]; then
	printf "$PASS"
else
	printf  "$FAIL ($MIN_LEN != 8)"
	exit 1
fi
echo ""

echo -ne "[fq-len]\tmin and max length:\t"
MINMAX=$($SCRIPTS/fu-len -m 10 -x 150 $INPUT 2>/dev/null| wc -l)
if [[ $MINMAX -eq 2 ]]; then
	printf "$PASS"
else
	printf "$FAIL ($MINMAX != 2)"
	exit 1
fi
echo ""

echo -ne "[fq-grep]\tcheck forward match:\t"
GREP1=$($SCRIPTS/fu-grep   CCCC $INPUT 2>/dev/null|wc -l )
if [[ $GREP1 -eq 8 ]]; then
	printf  "$PASS"
else
	printf "$FAIL ($GREP1 != 8)"
	exit 1
fi
echo ""

echo -ne "[fq-grep]\tcheck reverse compl.:\t"
GREP2=$($SCRIPTS/fu-grep   GGGG $INPUT 2>/dev/null|wc -l )
if [[ $GREP2 -eq 8 ]]; then
	printf "$PASS"
else
	printf  "$FAIL ($GREP2 != 8)"
	exit 1
fi
echo ""

echo -ne "[fq-rename]\tcheck prefix rename:\t"
RENAME=$($SCRIPTS/fu-rename $INPUT -p new_prefix 2>/dev/null| grep new_prefix | wc -l)
if [[ $RENAME -eq 8 ]]; then
	printf "$PASS"
else
	printf "$FAIL ($RENAME != 8)"
	exit 1
fi
echo ""

# Conda installed:
N50=$(n50 $INPUT)
if [[ $N50 -gt 0 ]]; then
	printf "[bundled-n50]\trunning basic N50 calc: $PASS\n"
else
	printf "[bundled-n50]\trunning basic N50 calc: $FAIL\n"
fi
echo ''
for i in $TEST_DIR/test_*.sh;
do
	UNIT=$(basename $i | cut -f2 -d_ | cut -f1 -d.);
	printf "\e[32m =====  Now testing: \e[1m$UNIT\e[0m\n"
	echo " ======================================"
	source $i
done
