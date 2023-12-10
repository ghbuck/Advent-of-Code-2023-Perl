package Advent::Days;

use v5.38.2;
use strict;
use warnings;
use feature qw(switch);
    no warnings 'experimental';

use FindBin qw($Bin);
use lib "$Bin/lib";

use Advent::Days::Day1;
use Advent::Days::Day2;
use Advent::Days::Day3;
use Advent::Days::Day4;
# use Advent::Days::Day5;
# use Advent::Days::Day6;
# use Advent::Days::Day7;
# use Advent::Days::Day8;
# use Advent::Days::Day9;
# use Advent::Days::Day10;
# use Advent::Days::Day11;
# use Advent::Days::Day12;
# use Advent::Days::Day13;
# use Advent::Days::Day14;
# use Advent::Days::Day15;
# use Advent::Days::Day16;
# use Advent::Days::Day17;
# use Advent::Days::Day18;
# use Advent::Days::Day19;
# use Advent::Days::Day20;
# use Advent::Days::Day21;
# use Advent::Days::Day22;
# use Advent::Days::Day23;
# use Advent::Days::Day24;

use Exporter 'import';
our @EXPORT = qw(run);

sub run {
    my ($self, $day, $question, $doExample) = @_;

    given ($day) {
        when (1) { Advent::Days::Day1->runDay($question, $doExample); }
        when (2) { Advent::Days::Day2->runDay($question, $doExample); }
        when (3) { Advent::Days::Day3->runDay($question, $doExample); }
        when (4) { Advent::Days::Day4->runDay($question, $doExample); }
        when (5) { Advent::Days::Day5->runDay($question, $doExample); }
        when (6) { Advent::Days::Day6->runDay($question, $doExample); }
        when (7) { Advent::Days::Day7->runDay($question, $doExample); }
        when (8) { Advent::Days::Day8->runDay($question, $doExample); }
        when (9) { Advent::Days::Day9->runDay($question, $doExample); }
        when (10) { Advent::Days::Day10->runDay($question, $doExample); }
        when (11) { Advent::Days::Day11->runDay($question, $doExample); }
        when (12) { Advent::Days::Day12->runDay($question, $doExample); }
        when (13) { Advent::Days::Day13->runDay($question, $doExample); }
        when (14) { Advent::Days::Day14->runDay($question, $doExample); }
        when (15) { Advent::Days::Day15->runDay($question, $doExample); }
        when (16) { Advent::Days::Day16->runDay($question, $doExample); }
        when (17) { Advent::Days::Day17->runDay($question, $doExample); }
        when (18) { Advent::Days::Day18->runDay($question, $doExample); }
        when (19) { Advent::Days::Day19->runDay($question, $doExample); }
        when (20) { Advent::Days::Day20->runDay($question, $doExample); }
        when (21) { Advent::Days::Day21->runDay($question, $doExample); }
        when (22) { Advent::Days::Day22->runDay($question, $doExample); }
        when (23) { Advent::Days::Day23->runDay($question, $doExample); }
        when (24) { Advent::Days::Day24->runDay($question, $doExample); }
    }

}

1;
