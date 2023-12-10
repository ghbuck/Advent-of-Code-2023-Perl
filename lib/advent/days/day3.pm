package Advent::Days::Day3;

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
    my $lines = getLines(3, $questionNum, $doExample);

    # declare the total
    my $total = 0;

    # create hashes to hold boolean for nums/symbols
    # these top level are keyed to file line numbers
    my $numMatrix = {};
    my $symbolMatrix = {};

    # fill hashes
    for (my $index = 0; $index < scalar @$lines; ++$index) {
        my @line = split('', $lines->[$index]);

        # each value for the above line numbers is a hash of true/false for
        # the char at the line index being a num or symbol, respectively
        my $lineNumMatrix = {};
        my $lineSymbolMatrix = {};

        # fill the line level hashes
        for (my $lineIndex = 0; $lineIndex < scalar @line; ++$lineIndex) {
            my $char = $line[$lineIndex];

            $lineNumMatrix->{$lineIndex} = $char =~ m/([0-9])/ ? 1 : 0;
            $lineSymbolMatrix->{$lineIndex} = $char =~/([^.0-9])/ ? 1 : 0;
        }

        # place the line level data into the file level hashes
        $numMatrix->{$index} = $lineNumMatrix;
        $symbolMatrix->{$index} = $lineSymbolMatrix;
    }

    # process the questions
    given ($questionNum) {
        when (1) { processQuestionOne($lines, $numMatrix, $symbolMatrix, \$total) }
        when (2) { processQuestionTwo($lines, $numMatrix, $symbolMatrix, \$total) }
    }

    say "\ntotal: $total\n";
}

sub processQuestionOne {
    my ($lines, $numMatrix, $symbolMatrix, $total) = @_;

    # now process those data
    for (my $index = 0; $index < scalar @$lines; ++$index) {
        # get the line num data
        my $currentLineNums = $numMatrix->{$index};

        # iterate
        for (my $lineIndex = 0; $lineIndex < scalar keys %$currentLineNums;) {
            my $itemIsNum = $currentLineNums->{$lineIndex};

            if ($itemIsNum) {
                # if the line index is a num, keep going to find the end of the num
                my $startIndex = $lineIndex;
                my $endIndex = $lineIndex;

                while ($currentLineNums->{$lineIndex + 1}) {
                    $endIndex = ++$lineIndex;
                }

                # now check the previous, current, and next lines for symbols
                # we break at the first true value
                my $symbolFound = 0;
                while (not $symbolFound) {
                    #check current line
                    my $currentLineSymbols = $symbolMatrix->{$index};
                    $symbolFound = (($currentLineSymbols->{$startIndex - 1}) or ($currentLineSymbols->{$endIndex + 1}));

                    last if $symbolFound;

                    # check previous line
                    my $previousLineSymbols = $symbolMatrix->{$index - 1};
                    if (defined $previousLineSymbols) {
                        foreach my $checkIndex (($startIndex - 1)..($endIndex + 1)) {
                            $symbolFound = $previousLineSymbols->{$checkIndex};
                            last if $symbolFound;
                        }
                    }

                    last if $symbolFound;

                    # check next line
                    my $nextLineSymbols = $symbolMatrix->{$index + 1};
                    if (defined $nextLineSymbols) {
                        foreach my $checkIndex (($startIndex - 1)..($endIndex + 1)) {
                            $symbolFound = $nextLineSymbols->{$checkIndex};
                            last if $symbolFound;
                        }
                    }

                    last;
                }

                # if the number is adjacent to a symbol we get the value
                # and add it to the total
                if ($symbolFound) {
                    my $num = substr($lines->[$index], $startIndex, ($endIndex - $startIndex + 1));
                    $$total += $num;
                }
            }

            ++$lineIndex;
        }
    }
}

sub processQuestionTwo {
    my ($lines, $numMatrix, $symbolMatrix, $total) = @_;

    # now process those data
    for (my $index = 0; $index < scalar @$lines; ++$index) {
        # get the line symbol data
        my $currentLineSymbols = $symbolMatrix->{$index};

        # iterate
        for (my $lineIndex = 0; $lineIndex < scalar keys %$currentLineSymbols;) {
            my $itemIsSymbol = $currentLineSymbols->{$lineIndex};

            my $isAStar = 0;
            if ($itemIsSymbol) {
                # if the line index is a symbol see if it's a star
                $isAStar = substr($lines->[$index], $lineIndex, 1) eq '*';
            }

            if ($isAStar) {
                # now check the previous, current, and next lines for numbers
                # we only calculate if adjacent to exactly two numbers
                my $numberData = {
                    numNumbers => 0,
                    num1 => undef,
                    num2 => undef
                };

                #check current line
                my $currentLineNumbers = $numMatrix->{$index};
                if ($currentLineNumbers->{$lineIndex - 1}) {
                    # iterate the num counter
                    $numberData->{numNumbers}++;

                    # walk backwards to collect the entire number
                    my $startIndex = $lineIndex - 1;
                    my $endIndex = $startIndex;

                    while ($currentLineNumbers->{$startIndex - 1}) {
                        --$startIndex;
                    }

                    # now collect
                    $numberData->{num1} = substr($lines->[$index], $startIndex, ($endIndex - $startIndex + 1));
                }

                if ($currentLineNumbers->{$lineIndex + 1}) {
                    # iterate the num counter
                    $numberData->{numNumbers}++;

                    # walk forwaads to collect the entire number
                    my $startIndex = $lineIndex + 1;
                    my $endIndex = $startIndex;

                    while ($currentLineNumbers->{$endIndex + 1}) {
                        ++$endIndex;
                    }

                    # now collect
                    $numberData->{'num' . $numberData->{numNumbers}} = substr($lines->[$index], $startIndex, ($endIndex - $startIndex + 1));
                }

                # check previous line
                processOtherLine($index - 1, $lineIndex, $numberData, $numMatrix, $lines);
                processOtherLine($index + 1, $lineIndex, $numberData, $numMatrix, $lines);

                # if the star is adjacent to exactly two numbers do the calculation
                if ($numberData->{numNumbers} == 2) {
                    my $num = $numberData->{num1} * $numberData->{num2};
                    $$total += $num;
                }
            }

            ++$lineIndex;
        }
    }
}

sub processOtherLine {
    my ($index, $lineIndex, $numberData, $numMatrix, $lines) = @_;

    my $lineNums = $numMatrix->{$index};
    if (defined $lineNums) {
        foreach my $checkIndex (($lineIndex - 1)..($lineIndex + 1)) {
            if ($lineNums->{$checkIndex}) {
                # iterate the num counter
                $numberData->{numNumbers}++;

                # we have to look both ways, we might be in the middle of a number
                my $startIndex = $checkIndex;
                my $endIndex = $checkIndex;

                while ($lineNums->{$startIndex - 1}) {
                    --$startIndex;
                }
                while ($lineNums->{$endIndex + 1}) {
                    ++$endIndex;
                }

                # now collect
                $numberData->{'num' . $numberData->{numNumbers}} = substr($lines->[$index], $startIndex, ($endIndex - $startIndex + 1));

                # don't break the loop if $endIndex == ($lineIndex - 1)
                # ($lineIndex + 1) could have another number
                last unless ($endIndex == ($lineIndex - 1));
            }
        }
    }
}

1;
