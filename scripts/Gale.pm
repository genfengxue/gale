package Gale;

use warnings;
use strict;

use JSON;
use Data::Dumper;

BEGIN {
    use Exporter();
    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(read_file write_file json_decode json_encode);
}

run() unless caller;

sub run {
    print "hello world";
#    my ($x, $y) = (2, 3);
#    swap($x, $y);
#    print $x, " ", $y;
}

sub swap {
    $_[0] = $_[1] ^ $_[0];#a = b ^ a;
    $_[1] = $_[1] ^ $_[0];#b = b ^ a;
    $_[0] = $_[1] ^ $_[0];#a = b ^ a;
}

sub swap1 {
    $_[0] = $_[1] - $_[0];#a = b - a;
    $_[1] = $_[1] - $_[0];#b = b - a;
    $_[0] = $_[1] + $_[0];#a = b + a;
}

sub read_file {
    my ($file) = @_;
    return do {
        local $/;
        open my $fh, '<', $file or die "$!";
        <$fh>
    };
}

sub write_file {
    my ($file, $text) = @_;
    open my $fh, '>', $file or die "$!";
    print $fh $text;
    close $fh;
}

sub json_decode {
    my ($json_text) = @_;
    my $JSON = JSON->new->allow_nonref;
    return $JSON->decode($json_text);
}

sub json_encode {
    my ($json_obj) = @_;
    my $JSON = JSON->new->allow_nonref;
    return $JSON->pretty->encode($json_obj);
}

1;
