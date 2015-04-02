use warnings;
use strict;

use lib 'scripts';
use Data::Dumper;
use Gale qw/read_file write_file json_encode/;

my $TXT_DIR = 'local_data/key_point_txt';
my $KP_DIR = 'local_data/key_point_json';

chdir $TXT_DIR or die $!;
my @files = glob "*";
@files = @files[40 .. 49];

for my $file (@files) {
  my $lessonNo = Gale::getLessonNo($file);
  my $result = {};
  my $fileContent = read_file($file);
  while ($fileContent =~ m#(?<![^\n])(\d+)\n(.+?)\n<k>(.*?)</k>#sg) { #(?<![^\n]) 表示在那个位置之前除了\n，其他都是非法字符
    next unless $3;
    my ($sentenceNo, $sentence, $text) = (int($1), $2, $3);
    my @snippets = split /(`.*?`)/, $sentence;
#    print scalar @snippets;
    my @keyIndexes = ();
    my $from = 0; ##这个变量非常关键，用来跟踪关键词出现的时候的位置
    for my $snippet (@snippets) {
      if ($snippet =~ /^`(.+)`$/) {
        my $keyStr = $1;
        $keyStr =~ s/[^a-zA-Z0-9'_:-]+/ /g; #将非法单词字符都转为空格
        $keyStr =~ s/^\s+|\s+$//g; #去掉首尾空白
        my @keys = split /\s+/, $keyStr; #根据空白切割成单词
        push @keyIndexes, ++$from for @keys; #将关键词对应的索引位置放到数组中去
#        for (@keys) {
#          print "$_\n";
#        }
      } else {
        $snippet =~ s/[^a-zA-Z0-9'_:-]+/ /g; #将非法单词字符都转为空格
        $snippet =~ s/^\s+|\s+$//g; #去掉首尾空白
        my @words = split /\s+/, $snippet;
        $from += scalar @words;
      }
    }
#    print "@keyIndexes\n";
    my $key = join ",", @keyIndexes;
#    push @{ $result->{$lessonNo}->{$sentenceNo}->{$key} }, "key point text";
    push @{ $result->{$lessonNo}->{$sentenceNo}->{$key} }, $text;
  }
  print Dumper $result;

  my $shouldDie = 0;
  for my $sentenceNo (keys %{ $result->{$lessonNo} }) {
    my %seen = ();
    my @duplicated = ();
    for my $key (keys %{ $result->{$lessonNo}->{$sentenceNo} }) {
      @duplicated = grep { $seen{$_}++ } (split /,/, $key);
      if (@duplicated) {
        print "$lessonNo $sentenceNo duplicated: @duplicated\n";
        $shouldDie = 1;
      }
    }
  }
  die if $shouldDie;
  write_file("../../$KP_DIR/$file.json", json_encode($result));
}

__END__
#  print $lessonNo;

#    print "*" x 20, "\n";
#    print "$1#####$2#####$3\n";
#    print "#" x 20, "\n";
# Pam,give me a `.garden .sal-ad.` and `a gril-led fish.` appetizer.
#    print join "\n", @snippets;
