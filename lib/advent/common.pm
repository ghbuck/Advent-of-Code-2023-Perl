package Advent::Common;

use v5.38.2;
use warnings;
use strict;
use Data::Dumper;
use FindBin qw($Bin);

use Exporter 'import';
our @EXPORT = qw/getArgs getLines/;

sub getArgs {
    my ($dayNum, $questionNum, $doExample) = (undef, 1, 0);

    foreach my $arg (@_) {
        for ($arg) {
            if    (/-q:([1-2])/)          { $questionNum = int($1); }
            elsif (/-e/)                  { $doExample = 1; }
            elsif (/-d:(\d+)/)            { $dayNum = int($1); }
            elsif (/^< (.+?\/stdin.txt)/) {
                if (open my $handle, '<', $1) {
                    chomp(my @lines = <$handle>);
                    close $handle;

                    $lines[0] =~ m/-d:(\d+)/;
                    $dayNum = int($1);
                }
            }
        }
    }

    die "dayNum not defined" if not defined $dayNum;

    return ($dayNum, $questionNum, $doExample);
}

sub getLines {
    my ($dayNum, $questionNum, $doExample) = @_;

    my $base = "$Bin/sources/day$dayNum";
    my $file = $doExample ? "example$questionNum.txt" : 'input.txt';
    my $path = "$base/$file";

    my @lines;
    if (open my $handle, '<', $path) {
        chomp(@lines = <$handle>);
        close $handle;
    } else {
        die "$path not found";
    }

    return \@lines;
}

1;
