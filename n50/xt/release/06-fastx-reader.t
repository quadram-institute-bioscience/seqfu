use strict;
use warnings;
use Test::More;
use FASTX::Reader;
my $raw_version = $FASTX::Reader::VERSION;
my ($version) = $raw_version=~/^(\d+.\d+)/;
ok($version > 0.5, "FASTX::Reader is updated (version: $raw_version)");
done_testing(); 
