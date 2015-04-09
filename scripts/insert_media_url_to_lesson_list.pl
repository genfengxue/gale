use warnings;
use strict;

# perl scripts/insert_media_url_to_lesson_list.pl local_data/others/2_original_lesson_list.txt > local_data/lesson_list/2_lesson_list.txt

my $count = 0;
while (<>) {
  $count++;
  unless ($count % 4) {
    printf "http://7u2qm8.com1.z0.glb.clouddn.com/de%03s.jpg\n", int($count / 4);
    printf "http://7u2qm8.com1.z0.glb.clouddn.com/de%03s.mp4\n", int($count / 4);
  }
  print;
}
