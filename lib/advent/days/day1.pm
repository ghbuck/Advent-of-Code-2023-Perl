package Advent::Days::Day1;

use v5.38.2;
use warnings;
use strict;

sub runDay {
    my ($self, $runConfig) = @_;
    my $lines = Advent::Common->getLines($runConfig);

    my $hash = {};
    my $hashIndex = 0;

    my @words = ('zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine');
    foreach my $word (@words) {
        $hash->{$hashIndex} = $hashIndex;

        if (defined $runConfig->{questionNum} and $runConfig->{questionNum} == 2) {
            $hash->{$word} = $hashIndex;
        }

        ++$hashIndex;
    }

    my $regex = join('|', keys %$hash);

    my $first = qr/^.*?($regex)/i;
    my $last = qr/.*($regex).*?$/i;

    my $total = 0;
    foreach my $line (@$lines) {
        my $num1 = $1 if $line =~ m/$first/;
        my $num2 = $1 if $line =~ m/$last/;

        $total += "$hash->{$num1}$hash->{$num2}";
    }

    return $total;
}

1;
