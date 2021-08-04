use strict;
use warnings;
use Proch::N50;
use Test::More;
use FindBin qw($RealBin);

my $file = "$RealBin/../data/encodings/test-lf.fa";
my $win  = "$RealBin/../data/encodings/test-crlf.fa";
SKIP: {
	skip "missing input file" if (! -e "$file" or ! -e "$win");
	my $N50 = getN50($file);
	my $W50 = getN50($win);
	ok($N50 > 0, 'got an N50');
	ok($N50 == $W50, 'CRLF file has same N50 than LF');
}

done_testing();
