use warnings;
use strict;
use Encode;
binmode(STDOUT, ':encoding(utf8)');

my $old_name = '';
my $count = 1;

while (<>) {
  if ($old_name ne $ARGV) {
    $old_name = $ARGV;
    $count = 1;
  }
  s/^\s+|\s+$//g;
  if ($count % 5 == 1) {
    if (!/\d+/) {
      die "bad format: $ARGV";
    }
  } elsif ($count % 5 == 2) {
    if (!/[\d:,->]+/) {
      die "bad format: $ARGV";
    }
  } elsif ($count % 5 == 3) {
    if (!/[\x00-\xff]+/) {
      die "bad format: $ARGV";
    }
  } elsif ($count % 5 == 4) {
    $_ = Encode::decode('utf-8', $_);
    print "$_\n";
  } elsif ($count % 5 == 0) {
    if (!/^$/) {
      die "bad format: $ARGV";
    }
  }
  $count++;
}
