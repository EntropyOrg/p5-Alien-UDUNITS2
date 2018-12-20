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

sub cflags {
	my ($class) = @_;

	$class->install_type eq 'share'
		? '-I' . File::Spec->catfile($class->dist_dir, qw(include))
		: $class->SUPER::cflags;
}

sub libs {
	my ($class) = @_;

	my $path = $class->install_type eq 'share'
		? '-L' . File::Spec->catfile($class->dist_dir, qw(lib))
		: $class->SUPER::cflags;

	join ' ', (
		$path,
		'-ludunits2',
		($^O eq 'MSWin32' ? '-lexpat' : '')
	);

}

sub Inline {
	return unless $_[-1] eq 'C'; # Inline's error message is good
	my $params = Alien::Base::Inline(@_);
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
