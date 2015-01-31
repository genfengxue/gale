use warnings;
use strict;

$^I = '';

while (<>) {
  next if /^\d{1,2}\b:?/;
  next if /^\s*$/;
  print;
}

__END__

去掉BOM
find . -name '*.srt' -exec gsed -i -e '1s/^\xEF\xBB\xBF//' {} \;
