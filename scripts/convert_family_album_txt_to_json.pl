use warnings;
use strict;
use Data::Dumper;

use lib 'scripts';
use Gale qw/write_file json_encode/;

my $src_path = "local_data/family_album";
#my $dst_path = "../../${src_path}_json";
my $json_file = "../../local_data/others/family_album_all.json";

chdir $src_path or die $!;

my @files = glob "*";
#@files = ($files[0]);

my $objects = [];
for my $file (@files) {
  print "$file\n";
  my $lessonNo = substr $file, 0, 5;

  open my $fh, '<', $file or die $!;
  my $sentenceNo = 0;
  while (my $line = <$fh>) {
    $sentenceNo++;
    $line =~ s/^\s+|\s+$//g;#去掉首尾空白

    my $object = {
      lessonNo => $lessonNo,
      sentenceNo => $sentenceNo,
      english  => $line || die "$lessonNo $sentenceNo",
    };

    push @{$objects}, {%{$object}};
  }
}
#print json_encode( $objects );
write_file($json_file, json_encode( $objects ) );
