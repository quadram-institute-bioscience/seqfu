package Local::SeqFu;
use 5.014;
use warnings;
use Carp qw(confess);
use Data::Dumper;
use Term::ANSIColor qw(:constants);
require Exporter;

$Local::SeqFu::VERSION = '0.5.0';
$Local::SeqFu::fu_linesize = 0;
$Local::SeqFu::fu_verbose  = 0;

our @ISA = qw(Exporter);
our @EXPORT = qw(rc fu_printfasta fu_printfastq verbose);
our @EXPORT_OK = qw(munge frobnicate $fu_linesize $fu_verbose);  # symbols to export on request




sub fu_printfasta {
    my ($name, $comment, $seq) = @_;
    my $print_comment = '';
    if (defined $comment) {
        $print_comment = ' ' . $comment;
    }

    say '>', $name, $print_comment;
    print split_string($seq);
}

sub fu_printfastq {
    my ($name, $comment, $seq, $qual) = @_;
    my $print_comment = '';
    if (defined $comment) {
        $print_comment = ' ' . $comment;
    }

    say '@', $name, $print_comment;
    print split_string($seq) , "+\n", split_string($qual);
}

# Print verbose info
sub verbose {
    if ($Local::SeqFu::fu_verbose) {
        say STDERR " - ", $_[0];
    }
}
sub rc {
    my   $sequence = reverse($_[0]);
    if (is_seq($sequence)) {
        $sequence =~tr/ACGTacgt/TGCAtgca/;
        return $sequence;
    }
}

sub is_seq {
    my $string = $_[0];
    if ($string =~/[^ACGTRYSWKMBDHVN]/i) {
        return 0;
    } else {
        return 1;
    }
}

sub split_string {
	my $input_string = $_[0];
	my $formatted = '';
	my $line_width = $Local::SeqFu::fu_linesize; # change here
    return $input_string. "\n" unless ($line_width);
	for (my $i = 0; $i < length($input_string); $i += $line_width) {
		my $frag = substr($input_string, $i, $line_width);
		$formatted .= $frag."\n";
	}
	return $formatted;
}
1;

__END__

Nucleotide Code:  Base:
----------------  -----
A.................Adenine
C.................Cytosine
G.................Guanine
T (or U)..........Thymine (or Uracil)
R.................A or G
Y.................C or T
S.................G or C
W.................A or T
K.................G or T
M.................A or C
B.................C or G or T
D.................A or G or T
H.................A or C or T
V.................A or C or G
N.................any base
. or -............gap
