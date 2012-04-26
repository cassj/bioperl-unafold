use strict;
use warnings;

#stack trace
use Carp;
$SIG{ __DIE__ } = sub { Carp::confess( @_ ) };

use Bio::Root::Test;

test_begin(-tests => 26);
my $debug = test_debug();

use_ok( 'Bio::Tools::Run::Unafold::melt' );

my $exe = 'melt.pl';

my $folder = Bio::Tools::Run::Unafold::melt->new();

$folder = Bio::Tools::Run::Unafold::melt->new(
						-verbose => $debug, 
						 -program_name => $exe
						);
isa_ok($folder, 'Bio::Tools::Run::Unafold::melt');


can_ok($folder, 'parameters');
can_ok($folder, 'valid_parameters');
can_ok($folder,  'is_valid_parameter');
can_ok($folder, 'NA');
can_ok($folder, 'temperature');
can_ok($folder, 'Ct');

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
$folder->temperature('62');

is($folder->parameter_string(-double_dash => 1), ' --temperature 62 --NA DNA');

can_ok($folder, 'run');

#Don't bother keeping tempfiles for this, we just want the dG and Tm
$folder->save_tempfiles(0); #?


#No sequence given
throws_ok { $folder->run() } qr/No sequences provided/, 'error ok when no seqs given';

# provide a single sequence
my $seq1 = 'AGCGTCCTGTGCTGGAATGTGCGGCTCCCGCGAGCTCGCGGCGCAGCAGCAGAAGACCGAGGAGCGCCGCCGAGGCCGCGGGCCCCAGACCCGGGCGGCCGGGACCGCAGCGACGGCAGAACCAGGGCCGGCGGTCTGATCCCGCTCCGCGATCGCACCCCGGGATCTCGAGGGCCTCGA';
my $seq2 = 'GGGGCGGGATCGAGTTACGGAGCGAGTCACGGGCTGGGCCGGGGGCTGGTGCGGAGCGGCGTGGGCATCGGCCCCCAGCGGAGCACGGGGAGGCCCTTCCGCACGGCGCTGAGATCCGGG';

my $seqobj1 = Bio::PrimarySeq->new ( -seq => $seq1,
				     -id  => 'A_sequence',
				     -alphabet => 'dna'
				   );
my $seqobj2 = Bio::PrimarySeq->new ( -seq => $seq2,
				     -id  => 'Another_sequence',
				     -alphabet => 'dna'
				   );


throws_ok {$folder->run($seqobj1, $seqobj1, $seqobj1) } qr/Too many sequences/, 'error ok when too many seqs';

throws_ok {$folder->run($seqobj1, $seqobj2)} qr/Ct is undefined/, 'error ok when Ct is undefined';

ok($folder->run($seqobj1));
can_ok($folder, 'last_result');

is_deeply($folder->last_result,
	  {
          'dH' => '-316.5',
          'temp' => '62',
          'Tm' => '82.8',
          'dG' => '-18.5',
          'dS' => '-889.2'
	  }
	 );

is_deeply($folder->run($seqobj1),
	  {
          'dH' => '-316.5',
          'temp' => '62',
          'Tm' => '82.8',
          'dG' => '-18.5',
          'dS' => '-889.2'
	  }
	 );

TODO: {
  local $TODO = "Parsing of multiple file results not working yet";
  #$folder->Ct(1);
  #ok($folder->run($seqobj1, $seqobj2));
  #is_deeply($folder->last_result, {});
}



