package Advent::Days::Day2;

use v5.38.2;
use warnings;
use strict;
use Data::Dumper;

sub runDay {
    my ($self, $runConfig) = @_;
    my $lines = Advent::Common->getLines($runConfig);

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

                my @cubes = split(/, */, $round);
                foreach my $cubeData (@cubes) {
                    my ($value, $key) = ($1, $2) if $cubeData =~ m/(\d+) (red|green|blue)/;

                    if (defined $value and defined $key) {
                        for ($runConfig->{questionNum}) {
                            if    (/1/) { $roundCubes->{$key} = $value; }
                            elsif (/2/) {
                                my $maxValue = int($gameCubes->{$key});

                                if ($value > $maxValue) {
                                    $gameCubes->{$key} = $value;
                                }
                            }
                        }
                    }
                }

                if ($runConfig->{questionNum} == 1) {
                    $gameIsPossible = (($roundCubes->{red} <= $maxCubes->{red}) and ($roundCubes->{green} <= $maxCubes->{green}) and ($roundCubes->{blue} <= $maxCubes->{blue}));
                    last if not $gameIsPossible;
                }
            }
        }

        if ($runConfig->{questionNum} == 1 and $gameIsPossible) {
            $total += $gameId;
        } elsif ($runConfig->{questionNum} == 2) {
            $total += $gameCubes->{red} * $gameCubes->{green} * $gameCubes->{blue}
        }
    }

    return $total;
}

1;
