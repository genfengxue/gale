use warnings;
use strict;

$^I = '';

while (<>) {
  next if /^\d{1,2}\b:?/;
  next if /^\s*$/;
  print;
}
