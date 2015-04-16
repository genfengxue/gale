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

my $LINES_PER_BLOCK = 4; #每4行是一组
my $BEFORE_BLANK_LINE = 3; #空行之前有3行
my $FIRST_LINE_OF_BLOCK = 1;
my $QINIU_URL = Gale::Const()->{qiniuUrl};

my $count = 0;
my $lessonNo = 0;
while (my $line = <$inFh>) {
  $count++;
  print $outFh $line;
  if ($count % $LINES_PER_BLOCK == $FIRST_LINE_OF_BLOCK) {
    chomp $line;
    $lessonNo = int($line);
  } elsif ($count % $LINES_PER_BLOCK == $BEFORE_BLANK_LINE) {
    printf $outFh "$QINIU_URL/%s%03s.jpg\n", $courseName, $lessonNo;
    printf $outFh "$QINIU_URL/%s%03s.mp4\n", $courseName, $lessonNo;
  }
}
close $inFh or die $!;
close $outFh or die $!;
