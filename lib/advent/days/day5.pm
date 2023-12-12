package Advent::Days::Day5;

use v5.38.2;
use warnings;
use strict;
use Scalar::Util qw(looks_like_number);
use Term::ANSIColor;

use Data::Dumper;

sub runDay {
    my ($self, $runConfig) = @_;
    my $lines = Advent::Common->getLines($runConfig);

    # create the map
    # biiiiiiiig assumption = no overlapping ranges in each map type
    my $mapArray = createMapArray($lines);

    # run question one
    my $lowestLocation;
    for ($runConfig->{questionNum}) {
        if    (/1/) { $lowestLocation = processQuestionOne($lines, $mapArray); }
        elsif (/2/) { $lowestLocation = processQuestionTwo($lines, $mapArray); }
    }

    return $lowestLocation ? $lowestLocation : "no total returned";
}

sub createMapArray {
    my ($lines) = @_;

    # maps for ranges
    # { source => { destination => \d, range => \d }
    my $seedSoilMap = {};
    my $soilFertilizerMap = {};
    my $fertilizerWaterMap = {};
    my $waterLightMap = {};
    my $lightTempMap = {};
    my $tempHumidityMap = {};
    my $humidityLocationMap = {};

    # array for iterative access and reduced key sorting (for quick )
    my $mapArray = [
        {
            sortedKeys => [],
            map => $seedSoilMap,
            name => 'seedSoil'
        },
        {
            sortedKeys => [],
            map => $soilFertilizerMap,
            name => 'soilFertilizer'
        },
        {
            sortedKeys => [],
            map => $fertilizerWaterMap,
            name => 'fertilizerWater'
        },
        {
            sortedKeys => [],
            map => $waterLightMap,
            name => 'waterLight'
        },
        {
            sortedKeys => [],
            map => $lightTempMap,
            name => 'lightTemp'
        },
        {
            sortedKeys => [],
            map => $tempHumidityMap,
            name => 'tempHumidity'
        },
        {
            sortedKeys => [],
            map => $humidityLocationMap,
            name => 'humidityLocation'
        }
    ];

    # to track which map we're working on
    my $mapArrayIndex = -1;

    # create the map data, index 2 b/c map info starts on line 3
    for (my $index = 2; $index < scalar @$lines; ++$index) {
        my $line = $lines->[$index];

        next if $line eq '';

        # get the right map item
        ++$mapArrayIndex;
        my $mapArrayItem = $mapArray->[$mapArrayIndex];

        # read each map line into the data structure
        while ($index + 1 < scalar @$lines and looks_like_number(substr($lines->[$index + 1], 0, 1))) {
            ++$index;

            my @lineItems = split(' ', $lines->[$index]);
            $mapArrayItem->{map}->{$lineItems[1]} = {
                destination => $lineItems[0],
                range => $lineItems[2]
            };
        }
    }

    # now sort the keys of the maps
    foreach my $mapItem (@$mapArray) {
        my @sortedKeys = sort { $a <=> $b } keys(%{$mapItem->{map}});
        $mapItem->{sortedKeys} = \@sortedKeys;
    }

    return $mapArray;
}

sub processQuestionOne {
    my ($lines, $mapArray) = @_;

    # get seeds
    my @seeds = sort {$a <=> $b} split(' ', substr($lines->[0], 7));

    # get the locations
    my $lowestLocation;
    my $numSeeds = scalar @seeds;

    for (my $seedIndex = 0; $seedIndex < $numSeeds; ++$seedIndex) {
        my $seedLocation = undef;
        my $seed = $seeds[$seedIndex];

        processSeedsToLocation(\$seed, 0, $mapArray, \$seedLocation);

        die colored("\nno location found for seed $seed\n", 'red') if not defined $seedLocation;

        if (not defined $lowestLocation or a_greater_b(\$lowestLocation, \$seedLocation)) {
            $lowestLocation = $seedLocation;
        };
    }

    return $lowestLocation;
}

sub processSeedsToLocation {
    my ($source, $mapArrayIndex, $mapArray, $seedLocation) = @_;

    # get the meta items
    my $mapArrayItem = $mapArray->[$mapArrayIndex];
    my $isLocation = $mapArrayItem->{name} eq 'humidityLocation';

    # find the right map key, where
    # (sortedKeys[$keyIndex] + range) < $source < ($sortedKeys[$keyIndex + 1])
    my $destination = undef;
    my $maxKeyIndex = scalar @{$mapArrayItem->{sortedKeys}} - 1;
    my %hashedKeys = map { $_, 1 } @{$mapArrayItem->{sortedKeys}};

    for (my $keyIndex = 0; (not defined $destination) and ($keyIndex <= $maxKeyIndex); ++$keyIndex) {
        my $key = $mapArrayItem->{sortedKeys}->[$keyIndex];
        my $map = $mapArrayItem->{map}->{$key};

        my $range = $map->{range};
        my $maxSource = $key + $range;

        if (a_greaterOrEqual_b($source, \$key) and a_greaterOrEqual_b(\$maxSource, $source)) {
            $destination = $map->{destination} + ($$source - $key);
            last;
        }
    }

    # if itemKey is undef then it's a 1:1 source -> destination
    if (not defined $destination) {
        $destination = $$source;
    }

    if (not $isLocation) {
        processSeedsToLocation(\$destination, $mapArrayIndex + 1, $mapArray, $seedLocation);
    } else {
        $$seedLocation = $destination;
    }
}

sub processQuestionTwo {
    my ($lines, $mapArray) = @_;

    my $lowestLocation;

    my $mapArrayIndex = scalar @$mapArray - 1;

    # get the location data
    my $locationMap = $mapArray->[$mapArrayIndex--];

    # we need to find the location with the lowest range
    my $locationData = findLowestLocationData($locationMap->{map});

    # now let's create the range of seeds we need to process
    my $seedRangeData = processLocationsToSeeds($locationData->{source}, $mapArray, $mapArrayIndex);

    # now process the seeds
    my @seedInfo = substr($lines->[0], 7) =~ /(\d+ \d+)/g;
    my @sortedSeeds = sort { ($a =~ /^(\d+)/)[0] <=> ($b =~ /^(\d+)/)[0]} @seedInfo;

    my @filteredSeeds;
    foreach my $seedData (@sortedSeeds) {
        my ($start, $range) = split(' ', $seedData);
        my $end = $start + ($range - 1);

        if (a_greaterOrEqual_b(\$start, \$seedRangeData->{start}) and a_greaterOrEqual_b(\$seedRangeData->{end}, \$end)) {
            push(@filteredSeeds, {
                start => $start,
                end => $end
            })
        }
    }

    my $numSeeds = 0;
    foreach my $seed (@filteredSeeds) {
        $numSeeds += $seed->{end} - $seed->{start};
    }

    say Dumper $numSeeds;


    return $lowestLocation;
}

sub findLowestLocationData {
    my ($map) = @_;

    my $locationData = {
        destination => undef,
        source => undef
    };

    while (my ($key, $value) = each %$map) {
        my $startDestination = $value->{destination};
        my $endDestination = $startDestination + ($value->{range} - 1);

        if (not defined $locationData->{destination} or a_greater_b(\$locationData->{destination}->{end}, \$endDestination)) {
            $locationData = {
                destination => {
                    start => $startDestination,
                    end => $endDestination
                },
                source => {
                    start => $key,
                    end => $key + ($value->{range} - 1)
                }
            };
        }
    }

    return $locationData;
}

sub processLocationsToSeeds {
    # destinationData = { start => int, end => int }
    my ($destinationData, $mapArray, $mapArrayIndex) = @_;

    # get the meta items
    my $mapArrayItem = $mapArray->[$mapArrayIndex--];

    my $map = $mapArrayItem->{map};
    my $isSeeds = $mapArrayItem->{name} eq 'seedSoil';

    my $sourceData = {
        start => undef,
        end => undef
    };

    my @sortedMapItems = sort { $a->{destination} <=> $b->{destination} } values %$map;

    for (my $index = 0; $index < scalar @sortedMapItems; ++$index) {
        my $value = $sortedMapItems[$index];

        my $startDestination = $value->{destination};
        my $endDestination = $startDestination + ($value->{range} - 1);

        if (not defined $sourceData->{start} or a_greater_b(\$destinationData->{start}, \$startDestination)) {
            $sourceData->{start} = $startDestination;
        }

        if (not defined $sourceData->{end} or a_greater_b(\$endDestination, \$destinationData->{end})) {
            $sourceData->{end} = $endDestination;
        }
    }

    my $seedData;
    if (not $isSeeds) {
        $seedData = processLocationsToSeeds($sourceData, $mapArray, $mapArrayIndex, $seedData)
    } else {
        $seedData = $sourceData;
    }

    return $seedData;
}

# do bitwise operations on the huge integers
sub a_greaterOrEqual_b {
    my ($a, $b) = @_;
    return ( ($$a - $$b) >> 63 ) ? 0 : 1;
}

sub a_greater_b {
    my ($a, $b) = @_;
    return (($$b - $$a) >> 63);
}

1;
