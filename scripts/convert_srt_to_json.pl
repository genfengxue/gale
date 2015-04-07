use warnings;
use strict;
use Data::Dumper;
use Encode;
use JSON;

my $type = $ARGV[0] or 'direct_english';
my $src_path = "local_data/$type";
my $dst_path = "../../${src_path}_json";
chdir $src_path or die $!;

my $map = {
  1 => 'timeline',
  2 => 'english',
  3 => 'chinese'
};

my @files = glob "*";
#@files = @files[10 .. 53];

for my $file (@files) {
  print "$file\n";
  my $lessonNo = getLessonNo($file);

  open my $fh, '<', $file or die $!;
  my @lines = <$fh>;
  my $objects = [];
  my ($count, $object) = (0, {lessonNo => $lessonNo});
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

sub getLessonNo {
  my ($file) = @_;

  if ($file =~ /lesson(\d+)/i) {
    return int($1);
  }
  die;#如果没匹配成功，就die
}

sub write_file {
    my ($file, $text) = @_;
    open my $fh, '>', $file or die "$!";
    print $fh $text;
    close $fh;
}

sub json_encode {
    my ($json_obj) = @_;
    my $JSON = JSON->new->allow_nonref;
    return $JSON->pretty->encode($json_obj);
}
