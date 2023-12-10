package Advent::Days::Day0;

use v5.38.2;
use warnings;
use strict;
use feature qw(switch);
    no warnings 'experimental';
use Data::Dumper;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Advent::Common;

sub runDay {
    my ($self, $questionNum, $doExample) = @_;
    my $lines = getLines(0, $questionNum, $doExample);
}
