# Define $UNAFOLD_DIR if unafold executables are not in your path
# alter $exe if it isn't called hybrid-ss-min

use strict;
use warnings;

use Bio::Root::Test;
test_begin(-tests => 15);
my $debug = test_debug();

use_ok( 'Bio::Tools::Run::Unafold::hybrid_ss_min' ); 
require_ok( 'Bio::Tools::Run::Unafold::hybrid_ss_min' );

my $exe = 'hybrid-ss-min';

my $folder = Bio::Tools::Run::Unafold::hybrid_ss_min->new(
		      -verbose => $debug, 
		      -program_name => $exe
							 );
isa_ok($folder, 'Bio::Tools::Run::Unafold::hybrid_ss_min');


can_ok($folder, 'parameters');
can_ok($folder, 'valid_parameters');
can_ok($folder,  'is_valid_parameter');
can_ok($folder, 'NA');
can_ok($folder, 'tmax');
can_ok($folder, 'prohibit');

can_ok($folder, 'program_dir');
is($folder->program_dir, undef);

TODO: {
  local $TODO = 'version not implemeted yet';
  can_ok($folder, 'version');
  is($folder->version, 'version number');
}

can_ok($folder, 'executable');
isnt($folder->executable, '');

