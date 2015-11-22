use warnings;
use strict;

use lib 'scripts';
use Data::Dumper;
use Gale qw/read_file write_file json_encode json_decode/;

#my $json_dir = 'local_data/L01-54-json';
#my $COUNT_WORDS_DIR = 'local_data/count_words';
my $json_dir = 'local_data/family_album_json';
my $count_words_json = '../../local_data/count_words/family_album_count_words.json';
my $converted_count_words_json = '../../local_data/count_words/family_album_converted_count_words.json';

chdir $json_dir or die $!;
my @files = glob "*";
#@files = ($files[0]);

my $result = {};
for my $file (@files) {
  my $sentences = json_decode(read_file($file));
  for my $sentence (@$sentences) {
    my $english = lc $sentence->{english};
#    print $english, "\n";
    $english =~ s/(?<!\w)-+//g; #如果-前面为非法字符
    $english =~ s/[^a-zA-Z0-9'_:-]+/ /g;
    $english =~ s/^\s+|\s+$//g; #去掉首尾空白
    my @words = split /\s+/, $english; #根据空白切割成单词
#    print "@words\n";
    for my $word (@words) {
      $result->{$word}->{count}++;
      $result->{$word}->{stats}->{ $sentence->{lessonNo} }->{ $sentence->{sentenceNo} } = $sentence->{english};
    }
  }
}
print Dumper $result;
write_file($count_words_json, json_encode($result));

my $convertedResult = [];
for my $word (keys %$result) {
  my $one = {word => $word, count => $result->{$word}->{count}};
  for my $lessonNo (keys %{ $result->{$word}->{stats} }) {
    for my $sentenceNo (keys %{ $result->{$word}->{stats}->{$lessonNo} }) {
      push @{ $one->{stats} }, {
        sentence => $result->{$word}->{stats}->{$lessonNo}->{$sentenceNo},
        lessonNo => $lessonNo,
        sentenceNo => $sentenceNo,
      }
    }
  }
  push @{ $convertedResult }, $one;
}
print Dumper $convertedResult;
write_file($converted_count_words_json, json_encode($convertedResult));
