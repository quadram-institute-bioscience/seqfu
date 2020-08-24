use 5.012;
use BioX::Seq::Stream;
use Data::Dumper;
my ($filename, $ksize) = @ARGV; 
my $parser = BioX::Seq::Stream->new( $filename );

$ksize = 7 if $ksize < 3;
my $kmers;

my $c = 0;
while (my $seq = $parser->next_seq) {
  $c++;
  print STDERR "$c parsed...\r" if ( $c % 100 == 0 );
  last if ($c > 24000);
  my $id = $seq->{id};
  for (my $i = 0; $i < length($seq->{seq}) - $ksize; $i++) {
   my $kmer = substr($seq->{seq}, $i, $ksize);
     $kmers->{$kmer}->{$id}++;
  }   
}
print STDERR "\n";
for my $kmer (sort keys %{ $kmers } ) {
  my $seqs = scalar keys %{ $kmers->{$kmer} };
  print $kmer, "\t", $seqs, "\t", $seqs == 1 ? "UNIQUE" : "MULTI", "\n";
}
