use warnings;
use strict;

$^I = '';

my $i = 0;
while (<>) {
  if ($i % 5 == 2) {
    s/([.,?!])(\w)/$1 $2/g;
  }
  print;
  $i++;
}
