package Advent::Days;

use v5.38.2;
use strict;
use warnings;

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

    for ($day) {
        if    (/1/) { Advent::Days::Day1->runDay($question, $doExample); }
        elsif (/2/) { Advent::Days::Day2->runDay($question, $doExample); }
        elsif (/3/) { Advent::Days::Day3->runDay($question, $doExample); }
        elsif (/4/) { Advent::Days::Day4->runDay($question, $doExample); }
        elsif (/5/) { Advent::Days::Day5->runDay($question, $doExample); }
        elsif (/6/) { Advent::Days::Day6->runDay($question, $doExample); }
        elsif (/7/) { Advent::Days::Day7->runDay($question, $doExample); }
        elsif (/8/) { Advent::Days::Day8->runDay($question, $doExample); }
        elsif (/9/) { Advent::Days::Day9->runDay($question, $doExample); }
        elsif (/10/) { Advent::Days::Day10->runDay($question, $doExample); }
        elsif (/11/) { Advent::Days::Day11->runDay($question, $doExample); }
        elsif (/12/) { Advent::Days::Day12->runDay($question, $doExample); }
        elsif (/13/) { Advent::Days::Day13->runDay($question, $doExample); }
        elsif (/14/) { Advent::Days::Day14->runDay($question, $doExample); }
        elsif (/15/) { Advent::Days::Day15->runDay($question, $doExample); }
        elsif (/16/) { Advent::Days::Day16->runDay($question, $doExample); }
        elsif (/17/) { Advent::Days::Day17->runDay($question, $doExample); }
        elsif (/18/) { Advent::Days::Day18->runDay($question, $doExample); }
        elsif (/19/) { Advent::Days::Day19->runDay($question, $doExample); }
        elsif (/20/) { Advent::Days::Day20->runDay($question, $doExample); }
        elsif (/21/) { Advent::Days::Day21->runDay($question, $doExample); }
        elsif (/22/) { Advent::Days::Day22->runDay($question, $doExample); }
        elsif (/23/) { Advent::Days::Day23->runDay($question, $doExample); }
        elsif (/24/) { Advent::Days::Day24->runDay($question, $doExample); }
    }

}

1;
