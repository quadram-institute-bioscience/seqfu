#!/bin/bash
TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SCRIPTS="$TEST_DIR/../bin"
INPUT="$TEST_DIR/../data/test.fa"

echo -e "Env path:\t$(which env)"
echo -e "Perl path:\t$(which perl)"
echo -e "Perl version:\t$(env perl -v | grep version)"

echo -e "conda_prefix:\t$CONDA_PREFIX"
echo -e "conda_prompt:\t$CONDA_PROMPT_MODIFIER"
echo -e "current_path:\t$PWD"
echo -e "list_binaries:\n"$(ls "$SCRIPTS")
echo ''

if [ ! -e "$INPUT" ]; then
	echo "Input file ($INPUT) not found"
fi

set -x pipefail

$SCRIPTS/fu-len.pl      -m 150 -x 170 $INPUT
$SCRIPTS/fu-grep.pl   GGGGGGGGGGGGGGG $INPUT 

set +x pipefail


# ----------------------------------------------------------------

echo -ne "[fq-len]\tcheck minimum length:\t"
MIN_LEN=$($SCRIPTS/fu-len.pl -m 100 $INPUT 2>/dev/null | wc -l)
if [[ $MIN_LEN -eq 8 ]]; then
	echo "PASS"
else
	echo "FAIL ($MIN_LEN != 8)"
	exit 1
fi
echo ""

echo -ne "[fq-len]\tmin and max length:\t"
MINMAX=$($SCRIPTS/fu-len.pl -m 10 -x 150 $INPUT 2>/dev/null| wc -l)
if [[ $MINMAX -eq 2 ]]; then
	echo "PASS"
else
	echo "FAIL ($MINMAX != 2)"
	exit 1
fi
echo ""

echo -ne "[fq-grep]\tcheck forward match:\t"
GREP1=$($SCRIPTS/fu-grep.pl   CCCC $INPUT 2>/dev/null|wc -l )                                                      
if [[ $GREP1 -eq 8 ]]; then
	echo "PASS"
else
	echo "FAIL ($GREP1 != 8)"
	exit 1
fi
echo ""

echo -ne "[fq-grep]\tcheck reverse compl.:\t"
GREP2=$($SCRIPTS/fu-grep.pl   GGGG $INPUT 2>/dev/null|wc -l )                                                      
if [[ $GREP2 -eq 8 ]]; then
	echo "PASS"
else
	echo "FAIL ($GREP2 != 8)"
	exit 1 
fi
echo ""

echo -ne "[fq-rename]\tcheck prefix rename:\t"
RENAME=$($SCRIPTS/fu-rename.pl $INPUT -p new_prefix 2>/dev/null| grep new_prefix | wc -l)                                                      
if [[ $RENAME -eq 8 ]]; then
	echo "PASS"
else
	echo "FAIL ($RENAME != 8)"
	exit 1
fi
echo ""

# Conda installed:
n50 $INPUT


