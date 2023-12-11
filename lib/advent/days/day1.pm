package Advent::Days::Day1;

use v5.38.2;
use warnings;
use strict;
use Data::Dumper;

use Advent::Common;

sub runDay {
    my ($self, $questionNum, $doExample) = @_;
    my $lines = getLines(1, $questionNum, $doExample);

    my $hash = {};
    my $hashIndex = 0;

    my @words = ('zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine');
    foreach my $word (@words) {
        $hash->{$hashIndex} = $hashIndex;

        if (defined $questionNum and $questionNum == 2) {
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

    say "\ntotal: " . $total . "\n";
}

1;
