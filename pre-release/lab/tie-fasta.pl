use Tie::File;
tie @array, 'Tie::File', "$ARGV[0]", recsep => '>' or die "...\n";
for my $seq (@array) {
  print '>', $seq if ($seq);
}
