package Advent::Days::Day4;

use v5.38.2;
use warnings;
use strict;
use feature qw(switch);
    no warnings 'experimental';
use Data::Dumper;

use threads;
use threads::shared;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Advent::Common;

sub runDay {
    my ($self, $questionNum, $doExample) = @_;
    my $lines = getLines(4, $questionNum, $doExample);

    my $total = 0;

    # key => cardNum, value => numCards
    my $winningCardData = {};
    share($winningCardData);

    # threading config
    my $threadConfig = {};
    share($threadConfig);

    $threadConfig = {
        maxThreads => 20,
        numActive => 0
    };

    my $sharedQuestionNum :shared;
    $sharedQuestionNum = $questionNum;

    # process the file
    my $numLines = scalar @$lines;
    foreach my $line (@$lines) {
        my ($id, $winningNums, $nums) = ($1, $2, $3) if $line =~ m/^Card *(\d+): *(.+?) *\| *(.+?) *$/;

        if (defined $id and defined $winningNums and defined $nums) {
            my %winningNums :shared;
            %winningNums = map { $_, 1 } split(' ', $winningNums);

            my @nums :shared;
            @nums = split(' ', $nums);

            my $numCardsToProcess = 1 + ($winningCardData->{$id} ? $winningCardData->{$id} : 0);
            print Dumper $threadConfig;
#             for (my $iterator = 1; $iterator <= $numCardsToProcess; ++$iterator) {
#                 while ($threadConfig->{numActive} == $threadConfig->{maxThreads}) {}
#                 $threadConfig->{numActive}++;

#                 threads->create(sub {
#                     say Dumper $sharedQuestionNum;
#                     # processCard(\$questionNum, \$numLines, \$id, \%winningNums, \@nums, $winningCardData, \$total);

#                     # lock($threadConfig);
#                     $threadConfig->{numActive}--;
# # print Dumper $threadConfig;
#                     threads->detach();
#                 }, ($threadConfig, \$sharedQuestionNum, $numLines, $id, %winningNums, @nums, $winningCardData, $total));
#             }
        }
    }

    while ($threadConfig->{numActive} > 0) {}

    if ($questionNum == 2) {
        # you start with 201 cards
        $total = 201;

        foreach my $numCards (values %$winningCardData) {
            $total += $numCards;
        }
    }

    say "\n total: $total\n";
}

sub processCard {
    my ($questionNum, $totalNumCards, $currentCardId, $winningNums, $nums, $winningCardData, $total) = @_;

    my $matches = 0;

    foreach my $num (@$nums) {
        if ($winningNums->{$num}) {
            ++$matches;
        }
    }

    if ($matches > 0) {
        given ($$questionNum) {
            when (1) {
                my $score = 1 << ($matches - 1);
                $$total += $score;
            }
            when (2) {
                for (my $iterator = 1; $iterator <= $matches; ++$iterator) {
                    my $wonCardId = $$currentCardId + $iterator;

                    if ($wonCardId <= $$totalNumCards) {
                        lock($winningCardData);

                        if (not defined $winningCardData->{$wonCardId}) {
                            $winningCardData->{$wonCardId} = 1;
                        } else {
                            $winningCardData->{$wonCardId}++;
                        }
                    }
                }
            }
        }
    }
}

1;
