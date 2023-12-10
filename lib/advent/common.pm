package Advent::Common;

use v5.38.2;
use warnings;
use strict;
use FindBin qw($Bin);

use Exporter 'import';
our @EXPORT = qw/getArgs getLines/;

sub getArgs {
    my ($questionNum, $doExample) = (1, 0);

    foreach my $arg (@_) {
        if ($arg eq '-e') {
            $doExample = 1;
        } elsif ($arg =~ m/^[1-2]$/) {
            $questionNum = int($arg);
        }
    }

    return ($questionNum, $doExample);
}

sub getLines {
    my ($dayNum, $questionNum, $doExample) = @_;

    my $path = "$Bin/sources/day$dayNum";
    my $file = $doExample ? "example$questionNum.txt" : 'input.txt';

    open my $handle, '<', "$path/$file";
    chomp(my @lines = <$handle>);
    close $handle;

    return \@lines;
}

1;
