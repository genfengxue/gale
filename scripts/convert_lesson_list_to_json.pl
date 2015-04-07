use warnings;
use strict;
use Data::Dumper;

use lib 'scripts';
use Gale qw/write_file json_encode/;

my $src_path = 'local_data/lesson_list';
my $dst_path = "${src_path}_json";

my $map = {
  1 => 'lessonNo',
  2 => 'englishTitle',
  3 => 'chineseTitle',
  4 => 'imageUrl',
};

my @files = glob "$src_path/*";
#print "@files";

for my $file (@files) {
  my $courseNo = getCourseNo($file);

  open my $fh, '<', $file or die $!;
  my $count = 0;
  my $objects = [];
  my $object = {courseNo => $courseNo};
  while (my $line = <$fh>) {
    $count++;
    next if $count % 5 == 0;
    $line =~ s/^\s+|\s+$//g; #去掉首尾空白
    $object->{ $map->{ $count % 5 } } = $line;
    if ($count % 5 == 4) {
      push @{$objects}, {%$object};
    }
  }
#  print Dumper $objects;
  write_file("$dst_path/$courseNo.json", json_encode( $objects ) );
}

sub getCourseNo {
  my ($file) = @_;
  my $filename = (split '/', $file)[-1];

  if ($filename =~ /^(\d+)_lesson_list.txt/i) {
    return int($1);
  }
  die;#如果没匹配成功，就die
}
