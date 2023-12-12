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

        my $output = $module->runDay($runConfig);

        say "\noutput: " . $output . "\n";
    }
}

sub runValidation {
    my ($runConfig) = @_;

    my $answersPath = "$Bin/sources/validations.csv";

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
        questions => $hasQuestionConfig ? [$runConfig->{questionNum}] : [1, 2],
        doExamples => $runConfig->{doExample}
    };

    # validate the day
    # $answers[0] is a header
    for (my $dayIndex = $dayConfig->{startIndex}; $dayIndex <= $dayConfig->{endIndex} ; ++$dayIndex) {
        my @dayAnswers = split(', *', $allAnswers[$dayIndex]);
        my $dayAnswers = {
            e1 => $dayAnswers[0],
            q1 => $dayAnswers[1],
            e2 => $dayAnswers[2],
            q2 => $dayAnswers[3]
        };

        # do the question
        foreach my $questionNum (@{$dayConfig->{questions}}) {
            my $answerKey = ($dayConfig->{doExamples} ? 'e' : 'q') . $questionNum;
            my $answer = $dayAnswers->{$answerKey};

            next if not defined $answer or $answer eq '';

            my $validationConfig = {
                dayNum => $dayIndex,
                questionNum => $questionNum,
                doExample => $dayConfig->{doExamples},
                validate => 1
            };

            my $module = "Advent::Days::Day$dayIndex";
            load $module;

            my $runStartFeedback = "\nValidating Day $dayIndex - Question $questionNum";
            if ($validationConfig->{doExample}) {
                $runStartFeedback = $runStartFeedback . " Example";
            }

            say colored($runStartFeedback, 'green');
            my $return = $module->runDay($validationConfig);

            if ($return eq $answer) {
                say colored("\nSuccessful validation: $return (calculation) == $answer (answer)", 'blue');
            } else {
                say colored("\nValidation failed: $return (calculation) != $answer (answer)", 'red');
            }
        }
    }
}

1;
