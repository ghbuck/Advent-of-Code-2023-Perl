package Advent::Days::Day2;

use v5.38.2;
use warnings;
use strict;
use Data::Dumper;

use Advent::Common;

sub runDay {
    my ($self, $questionNum, $doExample) = @_;
    my $lines = getLines(2, $questionNum, $doExample);

    my $total = 0;
    my $maxCubes = {
        red => 12,
        green => 13,
        blue => 14
    };

    foreach my $line (@$lines) {
        my ($gameId, $game) = ($1, $2) if $line =~ m/^Game (\d+): (.+)/;

        my $gameIsPossible = 0;
        my $gameCubes = {
            red => 0,
            green => 0,
            blue => 0
        };

        if (defined $gameId and defined $game) {
            my @rounds = split(/ *; */, $game);

            foreach my $round (@rounds) {
                my $roundCubes = {
                    red => 0,
                    green => 0,
                    blue => 0
                };

                $round =~ s/(\d+) (red|green|blue)/
                    my ($value, $key) = (int($1), $2);

                    for ($questionNum) {
                        if    ({1}) { $roundCubes->{$key} = $value; }
                        elsif ({2}) {
                            my $maxValue = int($gameCubes->{$key});

                            if ($value > $maxValue) {
                                $gameCubes->{$key} = $value;
                            }
                        }
                    }
                /eg;

                if ($questionNum == 1) {
                    $gameIsPossible = (($roundCubes->{red} <= $maxCubes->{red}) and ($roundCubes->{green} <= $maxCubes->{green}) and ($roundCubes->{blue} <= $maxCubes->{blue}));
                    last if not $gameIsPossible;
                }
            }
        }

        if ($questionNum == 1 and $gameIsPossible) {
            $total += $gameId;
        } elsif ($questionNum == 2) {
            $total += $gameCubes->{red} * $gameCubes->{green} * $gameCubes->{blue}
        }
    }

    say "\n total: $total\n";
}

1;
