package Advent::Common;

use v5.38.2;
use warnings;
use strict;
use FindBin qw($Bin);

sub getArgs {
    my $runConfig = {
        dayNum => undef,
        questionNum => undef,
        doExample => 0,
        validate => 0
    };

    foreach my $arg (@_) {
        for ($arg) {
            if    (/-v/)                  { $runConfig->{validate} = 1; }
            elsif (/-e/)                  { $runConfig->{doExample} = 1; }
            elsif (/-q:([1-2])/)          { $runConfig->{questionNum} = int($1); }
            elsif (/-d:(\d+)/)            { $runConfig->{dayNum} = int($1); }
            elsif (/^< (.+?\/stdin.txt)/) {
                if (open my $handle, '<', $1) {
                    chomp(my @lines = <$handle>);
                    close $handle;

                    $lines[0] =~ m/-d:(\d+)/;
                    $runConfig->{dayNum} = int($1);
                }
            }
        }
    }

    die "dayNum not defined" if not $runConfig->{validate} and not defined $runConfig->{dayNum};
    die "questionNum not defined" if not $runConfig->{validate} and not defined $runConfig->{questionNum};

    return $runConfig;
}

sub getLines {
    my ($self, $runConfig) = @_;

    my $base = "$Bin/sources/day$runConfig->{dayNum}";
    my $file = $runConfig->{doExample} ? "example$runConfig->{questionNum}.txt" : 'input.txt';
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
