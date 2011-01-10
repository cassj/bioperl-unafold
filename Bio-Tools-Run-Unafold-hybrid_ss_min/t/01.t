# Define $UNAFOLD_DIR if unafold executables are not in your path
# alter $exe if it isn't called hybrid-ss-min

use strict;
use warnings;

use Bio::Root::Test;
test_begin(-tests => 21);
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
ok(-x $folder->executable,'executable exists');

can_ok($folder, 'parameter_string');
is($folder->parameter_string(-double_dash => 1), '');

#set some params to test
$folder->NA('DNA');
$folder->tmin('60');
$folder->tmax('60');


is($folder->parameter_string(-double_dash => 1), ' --tmin 60 --tmax 60 --NA DNA');

can_ok($folder, 'run');

#No sequence given
throws_ok { $folder->run() } qr/No sequences provided/, 'error ok when no seqs given';

# provide a single sequence
my $seq1 = 'AGCGTCCTGTGCTGGAATGTGCGGCTCCCGCGAGCTCGCGGCGCAGCAGCAGAAGACCGAGGAGCGCCGCCGAGGCCGCGGGCCCCAGACCCGGGCGGCCGGGACCGCAGCGACGGCAGAACCAGGGCCGGCGGTCTGATCCCGCTCCGCGATCGCACCCCGGGATCTCGAGGGCCTCGA';
my $seq2 = 'GGGGCGGGATCGAGTTACGGAGCGAGTCACGGGCTGGGCCGGGGGCTGGTGCGGAGCGGCGTGGGCATCGGCCCCCAGCGGAGCACGGGGAGGCCCTTCCGCACGGCGCTGAGATCCGGG';

my $seqobj1 = Bio::PrimarySeq->new ( -seq => $seq1,
				     -id  => 'A sequence',
				     -alphabet => 'dna'
				   );
my $seqobj2 = Bio::PrimarySeq->new ( -seq => $seq2,
				     -id  => 'A sequence',
				     -alphabet => 'dna'
				   );

#for testing purposes, keep the tempdir:
$folder->save_tempfiles(1);

warn "\n\n";
warn $folder->run($seqobj1, $seqobj2);




#CGCCCAACTTTTCCCCGCTCTCCCTCCCCTCCCCTCCCCCGAAAGTCCAGCAACAAAGAA
#AAGGAGTTGGAGCGGCGGCGACGCGGGGGTGGCGGACCGTGGGCGCACAGTTCAGAGGGT
#AGGACGCGGCGGAGCGAGGAGAGCGACGGGGGAGGGCGGCGGGCAGGCGCGGAGCGGCGC
#GAGGCGCTGTCCAGGGCTGATTTGCAGATACTGTGGCTCGGGCGGCGCGGCGGCCGGGCG
#GGGGCGGGATCGAGTTACGGAGCGAGTCACGGGCTGGGCCGGGGGCTGGTGCGGAGCGGC
#GTGGGCATCGGCCCCCAGCGGAGCACGGGGAGGCCCTTCCGCACGGCGCTGAGATCCGGG
#GCCACGGAGGCCGGAGCGCCGCTGCTGGTGACCGCGGTCCTGAAACTTCCCCCCTCCGCC
#CTCCCTCCGCCTCGGG

#warn "\n\n";
#warn $folder->executable, $folder->run;
