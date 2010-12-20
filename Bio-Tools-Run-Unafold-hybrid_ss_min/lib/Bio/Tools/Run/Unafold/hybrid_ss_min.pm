# ABSTRACT: Bioperl-compatible wrapper for Unafold hybrid-ss-min

=head1 NAME

Bio::Tools::Run::Unafold::hybrid_ss_min - Bioperl-compatible wrapper for Unafold hybrid-ss-min

=head1 SYNOPSIS

my $folder = Bio::Tools::Run::Unafold::hybrid_ss_min->new();
my $params = {};
$folder->run($params);

=head1 DESCRIPTION

Bioperl-compatible wrapper for Unafold hybrid-ss-min

=cut 
use strict;
use warnings;
package Bio::Tools::Run::Unafold::hybrid_ss_min;

use base 'Bio::Tools::Run::Unafold::Base';


=head2 parameters

Title    : parameters
Usage    : Accessor
Function : Returns a list of valid parameters and descriptions.
Returns  : HashRef in the form {paramname => 'description', ... }
Args     : None

=cut


BEGIN { 
  my $params = {
		NA          => 'Nucleic Acid. RNA | DNA. Default is RNA',
		tmin        => 'Minimum Temperature. Default is 0',
		tinc        => 'Temperature Increment. Default is 1',
		tmax        => 'Maximum Temperature. Default is 100',
		sodium      => 'Sodium ion concentration (molar). Default is 1',
		magnesium   => 'Magnesium ion concentration (molar). Default is 0',
		polymer     => 'Use salt corrections for polymers instead of oligomers. Boolean. Default is 0',
		#suffix      => 'Use energy rules with the given suffix. Default is ""',
		output      => 'Name output files with the given string as a prefix. Default is ""',
		prohibit    => 'Prohibit all basepairs in the helix from i,j to i+k-1,j-k+1. If j is 0, prohibit bases i to i+k-1 from pairing at all; if i is 0, prohibit bases j to j-k+1 from pairing at all. k defaults to 1',
		force       => 'Force all basepairs in the helix from i,j to i+k-1,j-k+1. If j is 0, forces bases i to i+k-1 to be double-stranded; if i is 0, forces bases j to j-k+1 to be double-stranded. k defaults to 1',
		energyOnly  => 'Skips computation of probabilities. Boolean',
		noisolate   => 'Prohibit all isolated basepairs. Isolated basepairs are helices of length 2; that is, they do not stack on another basepair on either side. Boolean',
		mfold       => '[P,W,MAX], perform multiple (suboptimal) tracebacks in the style of mfold. P indicates the percent suboptimality to consider; only structures with energies within P% of the minimum will be output. W indicates the window size; a structure must have at least W basepairs that are each a distance of at least W away from any basepair in a previous structure. MAX represents an absolute limit on the number of structures computed.',
		zip         => 'Force zipping up of helices by forcing single-stranded bases to dangle on adjacent basepairs when possible. Boolean',
		tracebacks  => 'Computes the given number of stochastic tracebacks. Computed according to the Boltzmann probability distribution so that the probability of a structure is its Boltzmann factor divided by the partition function',
		maxbp       => 'Bases further apart than the specified number cannot form. Default is no limit',
		allpairs    => 'Allows basepairs to form between any two nucleotides. Watson-Crick and wobble are default',
		maxloop     => 'Maximum size of bulge/interior loops. Default is 30',
		nodangle    => 'Removes single-base stacking from consideration. Boolean',
		simple      => 'Makes the penalty for multibranch loops constant rather than affine. Boolean',
		prefilter   => 'Filter our all basepairs except those in groups of ',
		circular    => 'treat sequences as circular rather than linear',
		stream      => 'read sequences from STDIN rather than a file. Implies quiet.',
		quiet       => 'In quiet mode hybrid-ss-min interprets the arguments on the command line as sequences themselves, rather than as names of files containing sequences. In addition, no files are written and standard output consists only of the free energies.'
	       }

    __PACKAGE__->_mk_param_accessors($params);

  } # BEGIN


sub new{
  my $class = shift;

  # Use the Bio::Root::Root constructor from WrapperBase
  my $self = $class->SUPER->new(@_);
  
  # initialise our parameters with passed values. 
  # Bioperl insists on using this _rearrange thing.
  # which is just a pita if you ask me, but meh.
  
  bless $self, $class;
}


# this is what the Class::Accessor constructor does
# personally I don't like the whole $proto thing - I don't
# think that you *should* be able to create new instances
# from existing ones. 
#sub new {
#    my($proto, $fields) = @_;
#    my($class) = ref $proto || $proto;
#
#    $fields = {} unless defined $fields;
#
#    # make a copy of $fields.
#    bless {%$fields}, $class;
#}


=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this and other
Bioperl modules. Send your comments and suggestions preferably to the
Bioperl mailing list. Your participation is much appreciated. 

  bioperl-l@bioperl.org                  - General discussion
  http://bioperl.org/wiki/Mailing_lists  - About the mailing lists

=head2 Reporting Bugs 

Report bugs to the Bioperl bug tracking system to help us keep track
of the bugs and their resolution. Bug reports can be submitted via the
web:

  http://bugzilla.open-bio.org/  

=head1 AUTHOR - Cass Johnston <cassjohnston@gmail.com>

The author(s) and contact details should be included here (this insures you get credit for creating the module.  
Lesser contributions can be documented in a separate CONTRIBUTORS section if you prefer. 

=cut

1;
