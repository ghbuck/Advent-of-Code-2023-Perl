use v5.38.2;
use warnings;
use strict;

use FindBin qw($Bin);

BEGIN {
   unshift @INC, "$Bin/lib";
}

use Advent::Common;
use Advent::Days;

my $runConfig = Advent::Common->getArgs(@ARGV);

Advent::Days->run($runConfig);
