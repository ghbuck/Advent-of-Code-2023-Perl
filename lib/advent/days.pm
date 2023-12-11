package Advent::Days;

use v5.38.2;
use strict;
use warnings;
use FindBin qw($Bin);
use Module::Load;
use Term::ANSIColor;

use Exporter 'import';
our @EXPORT = qw(run);

sub run {
    my ($self, $runConfig) = @_;

    if ($runConfig->{validate}) {
        runValidation()
    } else {
        my $module = "Advent::Days::Day$runConfig->{dayNum}";
        load $module;

        my $returnTotal = $module->runDay($runConfig);

        say "\ntotal: " . $returnTotal . "\n";
    }
}

sub runValidation {
    my $answersPath = "$Bin/sources/validations.txt";

    # read answers file
    my @allAnswers;
    if (open my $handle, '<', $answersPath) {
        chomp(@allAnswers = <$handle>);
        close $handle;
    } else {
        die "$answersPath not found";
    }

    # validate the day
    # $answers[0] is a header
    for (my $dayIndex = 1; $dayIndex < scalar @allAnswers; ++$dayIndex) {
        my @dayAnswers = split(' ', $allAnswers[$dayIndex]);

        foreach my $questionNum (1, 2) {
            my $index = $questionNum - 1;

            my $answer = $dayAnswers[$index];
            my $runConfig = {
                dayNum => $dayIndex,
                questionNum => $questionNum,
                doExample => 0,
                validate => 1
            };

            my $module = "Advent::Days::Day$dayIndex";
            load $module;

            say colored("\nValidating Day $dayIndex - Question $questionNum", 'green');
            my $return = $module->runDay($runConfig);

            if ($return eq $answer) {
                say colored("\nSuccessful validation", 'blue');
            } else {
                say colored("\nValidation failed", 'red');
            }
        }
    }
}

1;
