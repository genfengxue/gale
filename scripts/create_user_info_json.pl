use warnings;
use strict;
use Data::Dumper;
use Digest::SHA1 qw/sha1_hex/;

use lib 'scripts';
use Gale qw/json_encode write_file/;

my $map = {
  "学生" => 1,
  "老师" => 2,
};

my $results;
open my $out_fh, '>', 'local_data/others/user_info_readable.txt' or die $!;

while (my $line = <>) {
  chomp $line;
  my ($userNo, $nickname, $roleName) = split /\s+/, $line;
  my $role = $map->{$roleName};
  my $password = substr sha1_hex($userNo), 0, 6;

  push @{$results}, +{
    userNo => $userNo,
    nickname => $nickname,
    role => $role,
    password => $password,
  };
  print $out_fh (join "  ", $userNo, $password, $nickname, $roleName), "\n";
}

close $out_fh or die $!;
print Dumper $results;
#print scalar @{$results};
#write_file('local_data/others/user_info.json', json_encode($results));
