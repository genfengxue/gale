use warnings;
use strict;
#use Encode;
#use Unicode::String;

my $snippet = '?';
$snippet =~ s/[^a-zA-Z0-9'_:-]+/ /g; #将非法单词字符都转为空格
$snippet =~ s/^\s+|\s+$//g; #去掉首尾空白
my @words = split /\s+/, $snippet;
print scalar @words;
#print lc 'xxX';
#while (<>) {
#  print $ARGV;
#}
#my $str = " hello ";
#$str =~ s/^\s+|\s+$//;
#my @arr = split /\s+/, $str;
#for (@arr) {
#  print "##$_**";
#}


#my $us = Unicode::String->new();
#$us->utf8("\u4e91\u7acb\u65b9\u5b66\u9662");
#$us->utf8("\x4e91\x7acb\x65b9\x5b66\x9662");
#print $us->utf8;

#my $string = "\u4e91\u7acb\u65b9\u5b66\u9662";
#print Encode::decode('utf-8', $string);
