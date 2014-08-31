package Alien::UDUNITS2;

use strict;
use warnings;

use parent qw(Alien::Base Exporter);
our @EXPORT_OK = qw(Inline);

sub Inline {
	return unless $_[-1] eq 'C'; # Inline's error message is good
	my $self = __PACKAGE__->new;
	+{
		LIBS => $self->libs,
		INC => $self->cflags,
		AUTO_INCLUDE => '#include "udunits2.h"',
	};
}

1;

__END__
# ABSTRACT: Alien package for the UDUNITS-2 physical unit manipulation and conversion library

=pod

=head1 Inline support

This module supports L<Inline's with functionality|Inline/"Playing 'with' Others">.

=head1 SEE ALSO

L<UDUNITS-2|http://www.unidata.ucar.edu/software/udunits/>
