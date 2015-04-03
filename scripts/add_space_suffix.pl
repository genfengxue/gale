use warnings;
use strict;

$^I = '';

my $old_name = '';
my $i = 0;
while (<>) {
  if ($old_name ne $ARGV) {
    $old_name = $ARGV;
    $i = 0;
  }

  if ($i % 5 == 2) {
    s/(".+?")(\w)/$1 $2/g;
    s/([.,?!;\)\]\}])(\w)/$1 $2/g;
  }
  print;
  $i++;
}
