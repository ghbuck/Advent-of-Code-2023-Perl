package Advent::Days::Day4;

use v5.38.2;
use warnings;
use strict;
use Data::Dumper;
use List::Util qw(sum0);

use Advent::Common;

sub runDay {
    my ($self, $questionNum, $doExample) = @_;
    my $lines = getLines(4, $questionNum, $doExample);

    my $total = 0;

    # index = cardId, value = numCards
    my @numCardsData = (1)x(scalar @$lines);

    # process the file
    my $numLines = scalar @$lines;
    foreach my $line (@$lines) {
        my ($id, $winningNums, $nums) = ($1, $2, $3) if $line =~ m/^Card *(\d+): *(.+?) *\| *(.+?) *$/;

        if (defined $id and defined $winningNums and defined $nums) {
            my %winningNums = map { $_, 1 } split(' ', $winningNums);
            my @nums = split(' ', $nums);

            processCard(\$questionNum, \$numLines, \$id, \%winningNums, \@nums, \@numCardsData, \$total);
        }
    }

    if ($questionNum == 2) {
        $total = sum0(@numCardsData);
    }

    say "\n total: $total\n";
}

sub processCard {
    my ($questionNum, $totalNumCards, $currentCardId, $winningNums, $nums, $numCardsData, $total) = @_;

    my $matches = 0;

    foreach my $num (@$nums) {
        if ($winningNums->{$num}) {
            ++$matches;
        }
    }

    if ($matches > 0) {
        for ($$questionNum) {
            if (/1/) {
                my $score = 1 << ($matches - 1);
                $$total += $score;
            }
            elsif (/2/) {
                my $multiplier = $numCardsData->[$$currentCardId];
                for (my $iterator = 1; $iterator <= $matches; ++$iterator) {
                    my $wonCardId = $$currentCardId + $iterator;

                    if ($wonCardId <= $$totalNumCards) {
                        $numCardsData->[$wonCardId] += $multiplier;
                    }
                }
            }
        }
    }
}

1;
