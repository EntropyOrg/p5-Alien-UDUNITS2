package Alien::UDUNITS2;

use strict;
use warnings;

require Alien::Base;
require Exporter;
our @ISA = qw(Alien::Base Exporter);
our @EXPORT_OK = qw(Inline);
use Perl::OSType qw(os_type);
use File::Spec;

sub inline_auto_include {
	[ 'udunits2.h' ];
}

sub Inline {
	my ($class, $lang) = @_;
	return unless $lang eq 'C'; # Inline's error message is good
	my $params = Alien::Base::Inline(@_);

	# Use static linking instead of dynamic linking. This works
	# better on some platforms. On macOS, to use dynamic linking,
	# the `install_name` of the library must be set, but since this
	# is the final path by default, linking to the `.dylib` under
	# `blib/` at test time does not work without using `@rpath`.
	if( $^O eq 'darwin' and $class->install_type eq 'share' ) {
		$params->{MYEXTLIB} .= ' ' .
			join( " ",
				map { File::Spec->catfile(
					File::Spec->rel2abs($class->dist_dir),
					'lib',  $_ ) }
				qw(libudunits2.a)
			);
		$params->{LIBS} =~ s/-ludunits2//g;
	}

	$params;
}

sub units_xml {
	my ($self) = @_;

	my ($file) = grep
		{ -f }
		map {
			(
				"$_/share/xml/udunits/udunits2.xml",
				"$_/share/udunits/udunits2.xml",
				"$_/lib/udunits2.xml"
			)
		} (
			$self->install_type eq 'share'
			? $self->dist_dir
			: "/usr"
		);

	$file;
}

1;

__END__
# ABSTRACT: Alien package for the UDUNITS-2 physical unit manipulation and conversion library

=pod

=head1 Inline support

This module supports L<Inline's with functionality|Inline/"Playing 'with' Others">.

=head1 SEE ALSO

L<UDUNITS-2|http://www.unidata.ucar.edu/software/udunits/>
