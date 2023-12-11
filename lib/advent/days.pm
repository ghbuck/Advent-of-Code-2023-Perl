package Advent::Days;

use v5.38.2;
use strict;
use warnings;
use Module::Load;

use Exporter 'import';
our @EXPORT = qw(run);

sub run {
    my ($self, $dayNum, $questionNum, $doExample) = @_;

    my $module = "Advent::Days::Day$dayNum";
    load $module;

    $module->runDay($questionNum, $doExample);
}

1;
