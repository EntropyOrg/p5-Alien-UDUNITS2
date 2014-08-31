use Test::More;
use Module::Load;
use File::Basename;
use File::Spec;

use Alien::UDUNITS2;

# for dev testing, get the headers out of the build directory
my ($built_udunits2) = glob '_alien/udunits-*/lib/udunits2.h';
my ($built_unitsdb) = glob '_alien/udunits-*/lib/udunits2.xml';
my $built_dir = File::Spec->rel2abs(dirname($built_udunits2));
my @inc_built = defined $built_udunits2 && -f $built_udunits2 ? (INC => "-I$built_dir") : ();

SKIP: {
	eval { load 'Inline::C' } or do {
		my $error = $@;
		skip "Inline::C not installed", 1 if $error;
	};

	plan tests => 1;

	Inline->import( with => qw(Alien::UDUNITS2) );
	Inline->bind( C => q{
		double convert_inch_to_metre(const char* path_to_xml, double inch_value) {

			ut_system* sys = ut_read_xml(path_to_xml);

			ut_unit* from_in_unit = ut_get_unit_by_name(sys, "inch" );
			ut_unit* to_m_unit    = ut_get_unit_by_name(sys, "metre");

			cv_converter* converter = ut_get_converter(from_in_unit, to_m_unit);

			double m_value = cv_convert_double(converter, inch_value);

			cv_free(converter);
			ut_free_system(sys);

			return m_value;
		}
	},
		ENABLE => AUTOWRAP => @inc_built);

	# 100 inches is 2.54 metres
	is( convert_inch_to_metre($built_unitsdb, 100), 2.54 , 'covert 100 inches to metres');
}

done_testing;
