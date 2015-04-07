use warnings;
use strict;

$^I = '';

my $old_name = '';
my $count = 0;
while (<>) {
  $count++;
  unless ($count % 4) {
    printf "http://7u2qm8.com1.z0.glb.clouddn.com/de%02s.JPG\n", int($count / 4);
  }
  print;
}

# perl scripts/insert_image_url_to_lesson_list.pl local_data/others/direct_english_lesson_list_without_image_url.txt
