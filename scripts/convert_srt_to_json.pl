use warnings;
use strict;
use Data::Dumper;
use Encode;

#binmode(STDOUT, ':encoding(utf8)');
my $src_path = '/Users/lutao/Downloads/L1-54';
my $dst_path = "$src_path-json";
chdir $src_path or die $!;

my $keys = ['sentenceNo', 'timeline', 'english', 'chinese'];
my @files = glob "*";
@files = @files[0, 1];
for my $file (@files) {
#  $file = Encode::decode('utf-8', $file);
  print $file;
#  open my $fh, '<:encoding(utf-8)', $file or die "$!";
  open my $fh, '<', $file or die "$!";
  my @lines = <$fh>;
  for (my $i = 0; $i < scalar @lines; $i++) {
    next if $i % 5 == 4;
    print $lines[$i];
  }
  print "\n" x 5;
}

sub read_file {
    my ($file) = @_;
    return do {
        local $/;
        open my $fh, '<:encoding(utf-16)', $file or die "$!";
        <$fh>
    };
}





#print "@files";

#my $file = $files[0];
#my $srt_text =  read_file($file);
#my @lines = split /^\s+$/m, $srt_text;
#print Dumper \@lines;
