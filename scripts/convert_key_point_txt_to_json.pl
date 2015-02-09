use warnings;
use strict;

use lib 'scripts';
use Data::Dumper;
use Gale qw/read_file write_file json_encode/;

my $TXT_DIR = 'local_data/key_point_txt';
my $KP_DIR = 'local_data/key_point_json';

chdir $TXT_DIR or die $!;
my @files = glob "*";
#@files = @files[10 .. 53];

for my $file (@files) {
  my $lessonNo = Gale::getLessonNo($file);
  my $result = {};
  my $file_content = read_file($file);
  while ($file_content =~ m#(\d+)\n.*?`(.+?)`.*?<k>(.*?)</k>#sg) {
    next unless $3;
    my ($sentenceNo, $key, $text) = (int($1), $2, $3);
    push @{ $result->{$lessonNo}->{$sentenceNo}->{$key} }, $text;
  }
  write_file("../../$KP_DIR/$file.json", json_encode($result));
#  print Dumper $result;
}

__END__
#  print $lessonNo;

#    print "*" x 20, "\n";
#    print "$1#####$2#####$3\n";
#    print "#" x 20, "\n";
