package Advent::Days::Day5;

use v5.38.2;
use warnings;
use strict;
use Data::Dumper;
use Math::BigInt;
use Scalar::Util qw(looks_like_number);
use Term::ANSIColor;

sub runDay {
    my ($self, $runConfig) = @_;
    my $lines = Advent::Common->getLines($runConfig);

    # create the map
    # biiiiiiiig assumption = no overlapping ranges in each map type
    my $mapArray = createMapArray($lines);

    # collect the seeds
    my @seeds = ();
    for ($runConfig->{questionNum}) {
        if    (/1/) { @seeds = sort {$a <=> $b} split(' ', substr($lines->[0], 7)); }
        elsif (/2/) {
            my @seedData = sort { ($a =~ /^(\d+)/)[0] <=> ($b =~ /^(\d+)/)[0] } substr($lines->[0], 7) =~ m/(\d+ \d+)/g;
            foreach my $data (@seedData) {
                my @dataParts = split(' ', $data);
                push(@seeds, ($dataParts[0]..($dataParts[0] + $dataParts[1])));
            }
        }
    }

    # get the locations
    my $lowestLocation;
    for (my $seedIndex = 0; $seedIndex < scalar @seeds; ++$seedIndex) {
        my $seedLocation = undef;
        my $seed = $seeds[$seedIndex];

        processItem(\$seed, 0, $mapArray, \$seedLocation);

        die "no location found for seed $seed" if not defined $seedLocation;

        if (not defined $lowestLocation or bitCompare($lowestLocation, $seedLocation)) {
            $lowestLocation = $seedLocation;
        };
    }

    return $lowestLocation;
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
            map => $seedSoilMap
        },
        {
            sortedKeys => [],
            map => $soilFertilizerMap
        },
        {
            sortedKeys => [],
            map => $fertilizerWaterMap
        },
        {
            sortedKeys => [],
            map => $waterLightMap
        },
        {
            sortedKeys => [],
            map => $lightTempMap
        },
        {
            sortedKeys => [],
            map => $tempHumidityMap
        },
        {
            sortedKeys => [],
            map => $humidityLocationMap
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

sub processItem {
    my ($source, $mapArrayIndex, $mapArray, $seedLocation) = @_;

    # say colored("map #$mapArrayIndex", 'blue');

    # get the meta items
    my $mapArrayItem = $mapArray->[$mapArrayIndex];
    my $isLocation = $mapArrayIndex == (scalar @$mapArray - 1);

    # find the right map key, where
    # (sortedKeys[$keyIndex] + range) < $source < ($sortedKeys[$keyIndex + 1])
    my $destination = undef;
    my $maxKeyIndex = scalar @{$mapArrayItem->{sortedKeys}} - 1;

    for (my $keyIndex = 0; (not defined $destination) and ($keyIndex <= $maxKeyIndex); ++$keyIndex) {
        my $key = $mapArrayItem->{sortedKeys}->[$keyIndex];
        my $map = $mapArrayItem->{map}->{$key};

        my $range = $map->{range};
        my $maxSource = $key + $range;

        if (bitCompare($$source, $key) and bitCompare($maxSource, $$source)) {
            $destination = $map->{destination} + ($$source - $key);
            last;
        }
    }

    # if itemKey is undef then it's a 1:1 source -> destination
    if (not defined $destination) {
        $destination = $$source;
    }

    if (not $isLocation) {
        processItem(\$destination, $mapArrayIndex + 1, $mapArray, $seedLocation);
    } else {
        $$seedLocation = $destination;
    }
}

# this does a bitwise operation on the huge integers
# it returns true for $a >= $b
sub bitCompare {
    my ($a, $b) = @_;
    return ( ($a - $b) >> 63 ) ? 0 : 1;
}

1;
