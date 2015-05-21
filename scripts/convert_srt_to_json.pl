use warnings;
use strict;
use Data::Dumper;
use Encode;
use JSON;

use lib 'scripts';
use Gale qw/getLessonNo write_file json_encode/;

# PERL_HASH_SEED=0x00 PERL_PERTURB_KEYS=0
# perl scripts/convert_srt_to_json.pl nceone
# perl scripts/convert_srt_to_json.pl de

my $type = $ARGV[0] or die "you must give one parameter";
my $src_path = "local_data/$type";
my $dst_path = "../../${src_path}_json";
chdir $src_path or die $!;

my $courseMap = {
  nceone => 1,
  de     => 2,
};

my $courseNo = $courseMap->{$type} or die;

my $map = {
  1 => 'timeline',
  2 => 'english',
  3 => 'chinese',
};

my @files = glob "*";
#@files = @files[10 .. 53];

for my $file (@files) {
  print "$file\n";
  my $lessonNo = getLessonNo($file);

  open my $fh, '<', $file or die $!;
  my @lines = <$fh>;
  my $objects = [];
  my ($count, $object) = (0, {courseNo => $courseNo, lessonNo => $lessonNo});
  for (my $i = 0; $i < scalar @lines; $i++) {
    $lines[$i] =~ s/\s*\r?\n//;
    $count = $i % 5;
    next if $count == 4; #遇到空行直接跳过
    if ($count == 0) {
      $object->{ sentenceNo } = int($i / 5) + 1;
    } else { # $count = 1, 2, 3的时候
      $object->{ $map->{$count} } = $lines[$i] or die;
    }

    if ($count == 3) {#一条字幕处理完成，加入到结果中
      push @{$objects}, {%{$object}};
    }
  }
#  print json_encode( $objects );
  write_file("$dst_path/$file.json", json_encode( $objects ) );
}
