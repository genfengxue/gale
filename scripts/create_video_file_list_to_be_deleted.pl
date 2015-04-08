use warnings;
use strict;
use Data::Dumper;

use lib 'scripts';
use Gale qw/json_encode write_file/;

my $results = [];
for my $i (61 .. 81) {
  print $i, "\n";
  for my $k (1 .. 4) {
    push @$results, "video${i}_$k.mp4";
  }
}

for my $j (371 .. 443) {
  if ($j % 2) {
    print $j, "\n";
    for my $k (1 .. 4) {
      push @$results, "video${j}_$k.mp4";
    }
  }
}

print Dumper $results;
write_file("local_data/others/video_file_list_to_be_deleted.json", json_encode($results));
