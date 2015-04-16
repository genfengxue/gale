use warnings;
use strict;

use lib 'scripts';
use Gale qw/getCourseNoFromName/;

# perl scripts/insert_media_url_to_lesson_list.pl de
# perl scripts/insert_media_url_to_lesson_list.pl nceone
my $courseName = $ARGV[0];
die "you must give courseName: [de/nceone]" unless $courseName;

my $courseNo = getCourseNoFromName($courseName);
die "courseName is illegal" unless $courseNo;

my $originalFile = sprintf 'local_data/others/%s_original_lesson_list.txt', $courseNo;
my $outputFile   = sprintf 'local_data/lesson_list/%s_lesson_list.txt',     $courseNo;

open my $inFh, '<', $originalFile or die $!;
open my $outFh, '>', $outputFile or die $!;

my $count = 0;
while (my $line = <$inFh>) {
  $count++;
  print $outFh $line;
  if ($count % 4 == 3) {
    printf $outFh "http://7u2qm8.com1.z0.glb.clouddn.com/%s%03s.jpg\n", $courseName, int($count / 4) + 1;
    printf $outFh "http://7u2qm8.com1.z0.glb.clouddn.com/%s%03s.mp4\n", $courseName, int($count / 4) + 1;
  }
}
close $inFh or die $!;
close $outFh or die $!;
