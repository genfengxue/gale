use warnings;
use strict;
use Data::Dumper;
use Encode;
use JSON;

use lib 'scripts';
use Gale qw/write_file json_encode/;

my $infile = 'local_data/others/course_list.txt';
my $outfile = 'local_data/others/course_list.json';

my $map = {
  1 => 'courseNo',
  2 => 'englishTitle',
  3 => 'chineseTitle',
  4 => 'description',
  5 => 'imageUrl',
};

open my $fh, '<', $infile or die $!;
my $count = 0;
my $objects = [];
my $object = {};
while (my $line = <$fh>) {
  $count++;
  next if $count % 6 == 0;
  $line =~ s/^\s+|\s+$//g; #去掉首尾空白
  $object->{ $map->{ $count % 6 } } = $line;
  if ($count % 6 == 5) {
    push @{$objects}, {%$object};
  }
}
print Dumper $objects;
write_file($outfile, json_encode( $objects ) );
