package Alien::UDUNITS2::Install::Files;

# allows other packages to use ExtUtils::Depends like so:
#   use ExtUtils::Depends;
#   my $p = new ExtUtils::Depends MyMod, Alien::UDUNITS2;
# and their code will have all UDUNITS2 available at C level

use strict;
use warnings;

use Alien::UDUNITS2 qw(Inline);
BEGIN { *Inline = *Alien::UDUNITS2::Inline }
sub deps { () }
