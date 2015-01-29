use warnings;
use strict;
use Data::Dumper;
use Encode;
use JSON;

my $src_path = '/Users/lutao/Downloads/L1-54';
my $dst_path = "$src_path-json";
chdir $src_path or die $!;

my $keys = ['sentenceNo', 'timeline', 'english', 'chinese'];
my @files = glob "*";
@files = @files[0, 1];

for my $file (@files) {
  my $lessonNo = getLessonNo($file);
  print $lessonNo;

  open my $fh, '<', $file or die "$!";
  my @lines = <$fh>;
  my $objects = [];
  my ($count, $object) = (0, {lessonNo => $lessonNo});
  for (my $i = 0; $i < scalar @lines; $i++) {
    $lines[$i] =~ s/\r?\n//;
    $count = $i % 5;
    next if $count == 4;
    $object->{ $keys->[$count] } = $lines[$i];
    if ($count == 3) {
      push @{$objects}, {%{$object}};
    }
  }
#  print json_encode( $objects );
  write_file("$dst_path/$file.json", json_encode( $objects ) );
}

sub getLessonNo {
  my ($file) = @_;

  if ($file =~ /^lesson(\d+)/) {
    return int($1);
  }
  die;#如果没匹配成功，就die
}

sub write_file {
    my ($file, $text) = @_;
    open my $fh, '>', $file or die "$!";
    print $fh $text;
    close $fh;
}

sub json_encode {
    my ($json_obj) = @_;
    my $JSON = JSON->new->allow_nonref;
    return $JSON->pretty->encode($json_obj);
}
