#!/usr/bin/perl
use v5.38.2;
use warnings;
use strict;
use Data::Dumper;
use Term::ANSIColor;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Advent::Common;
use Advent::Days;

Advent::Days->run(4, getArgs(@ARGV));
