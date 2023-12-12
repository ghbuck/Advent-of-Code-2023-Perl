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
        runValidation($runConfig);
    } else {
        my $module = "Advent::Days::Day$runConfig->{dayNum}";
        load $module;

        my $returnTotal = $module->runDay($runConfig);

        say "\ntotal: " . $returnTotal . "\n";
    }
}

sub runValidation {
    my ($runConfig) = @_;

    my $answersPath = "$Bin/sources/validations.txt";

    # read answers file
    my @allAnswers;
    if (open my $handle, '<', $answersPath) {
        chomp(@allAnswers = <$handle>);
        close $handle;
    } else {
        die "$answersPath not found";
    }

    # set day(s) and question(s) to validate
    my $hasDayConfig = defined $runConfig->{dayNum};
    my $hasQuestionConfig = defined $runConfig->{questionNum};
    my $dayConfig = {
        startIndex => $hasDayConfig ? $runConfig->{dayNum} : 1,
        endIndex => $hasDayConfig ? $runConfig->{dayNum} : scalar @allAnswers - 1,
        questions => $hasQuestionConfig ? [$runConfig->{questionNum}] : [1, 2]
    };

    # validate the day
    # $answers[0] is a header
    for (my $dayIndex = $dayConfig->{startIndex}; $dayIndex <= $dayConfig->{endIndex} ; ++$dayIndex) {
        my @dayAnswers = split(' ', $allAnswers[$dayIndex]);

        foreach my $questionNum (@{$dayConfig->{questions}}) {
            my $index = $questionNum - 1;

            my $answer = $dayAnswers[$index];

            next if not defined $answer or $answer eq '';

            my $validationConfig = {
                dayNum => $dayIndex,
                questionNum => $questionNum,
                doExample => 0,
                validate => 1
            };

            my $module = "Advent::Days::Day$dayIndex";
            load $module;

            say colored("\nValidating Day $dayIndex - Question $questionNum", 'green');
            my $return = $module->runDay($validationConfig);

            if ($return eq $answer) {
                say colored("\nSuccessful validation", 'blue');
            } else {
                say colored("\nValidation failed", 'red');
            }
        }
    }
}

1;
