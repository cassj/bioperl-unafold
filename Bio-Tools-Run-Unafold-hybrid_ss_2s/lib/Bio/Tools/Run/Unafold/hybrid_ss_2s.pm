# ABSTRACT: what this module is for
=head1 NAME

Bio::Tools::Run::Unafold::hybrid_ss_2s - quick description

=head1 SYNOPSIS

# Synopsis code demonstrating the module goes here

=head1 DESCRIPTION

A description about this module.

=cut 
use strict;
use warnings;
package Bio::Tools::Run::Unafold::hybrid_ss_2s;

use base 'Bio::Tools::Run::WrapperBase::Accessor';

use Bio::Seq;
use Bio::SeqIO;


__PACKAGE__->_setup
  (

   '-params' => {
		 NA          => 'Nucleic Acid. RNA | DNA. Default is RNA',
		 tmin        => 'Minimum Temperature. Default is 37',
		 tinc        => 'Temperature Increment. Default is 1',
		 tmax        => 'Maximum Temperature. Default is 37',
		 sodium      => 'Sodium ion concentration (molar). Default is 1',
		 magnesium   => 'Magnesium ion concentration (molar). Default is 0',
		 output      => 'Name output files with the given string as a prefix. Default is ""',
		 prohibit    => 'Prohibit all basepairs in the helix from i,j to i+k-1,j-k+1. If j is 0, prohibit bases i to i+k-1 from pairing at all; if i is 0, prohibit bases j to j-k+1 from pairing at all. k defaults to 1',
		 force       => 'Force all basepairs in the helix from i,j to i+k-1,j-k+1. If j is 0, forces bases i to i+k-1 to be double-stranded; if i is 0, forces bases j to j-k+1 to be double-stranded. k defaults to 1',
		 mfold       => '[P,W,MAX], perform multiple (suboptimal) tracebacks in the style of mfold. P indicates the percent suboptimality to consider; only structures with energies within P% of the minimum will be output. W indicates the window size; a structure must have at least W basepairs that are each a distance of at least W away from any basepair in a previous structure. MAX represents an absolute limit on the number of structures computed.',
		 tracebacks  => 'Computes the given number of stochastic tracebacks. Computed according to the Boltzmann probability distribution so that the probability of a structure is its Boltzmann factor divided by the partition function',
		 maxbp       => 'Bases further apart than the specified number cannot form. Default is no limit',
		 maxloop     => 'Maximum size of bulge/interior loops. Default is 30',
		 temperature => 'The temperature at which the minimum free energy folding is computed. Default is 37'
	      },
   '-switches' => {
		   polymer     => 'Use salt corrections for polymers instead of oligomers. Boolean. Default is 0',
		   energyOnly  => 'Skips computation of probabilities. Boolean',
		   noisolate   => 'Prohibit all isolated basepairs. Isolated basepairs are helices of length 2; that is, they do not stack on another basepair on either side. Boolean',
		   allpairs    => 'Allows basepairs to form between any two nucleotides. Watson-Crick and wobble are default',
		   nodangle    => 'Removes single-base stacking from consideration. Boolean',
		   simple      => 'Makes the penalty for multibranch loops constant rather than affine. Boolean',
		   prefilter   => 'Filter our all basepairs except those in groups of ',
		   circular    => 'treat sequences as circular rather than linear',
		   zip         => 'Force zipping up of helices by forcing single-stranded bases to dangle on adjacent basepairs when possible. Boolean',
		  }
  );


=head2 new

  Title    : new
  Usage    : my $hss = Bio::Tools::Run::Unafold::hybrid_ss->new();
  Function : Constructor
  Returns  : An object of class Bio::Tools::Run::Unafold::hybrid_ss
  Args     : Any of the command line parameters can be passed to the 
             constructor. It will also accept -program_dir

=cut

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_); 
  bless $self, $class;

  # setup program dir and name
  my ($pd, $pn) =  $self->_rearrange(['program_dir', 'program_name'], @_);
  $pd = $ENV{UNAFOLD_DIR} unless $pd;
  $self->{program_dir} = $pd if $pd;

  $self->{program_name} = $pn || 'hybrid-ss-2s.pl';

  return $self;

}

=head2 program_name

  Title    : program_name
  Usage    : $folder->program_name
  Function : returns the name of the executable
  Returns  : string
  Args     : none

=cut

sub program_name{
  my $self = shift;
  return $self->{program_name};
}
  

=head2 program_dir

  Title    : program_dir
  Usage    : my $path = $folder->program_dir;
  Function : Returns the current program_dir, the location in which 
             the Unafold executables can be found, if one is defined.
             You can define the program_dir by setting the 
             $UNAFOLD_DIR environment variable, or by passing a path
             to the -program_dir parameter of ->new().
             If left undefined, the system $PATH will be searched for
             the executables.
  Returns  : A path, or undef
  Args     : none

=cut

sub program_dir{
    my $self = shift;   
    return $self->{program_dir};
}


=head2 version

  Title    : version
  Usage    : $folder->version;
  Function : returns the hybrid-ss-min version
  Returns  : A string
  Args     : None

=cut

sub version{
    my $self = shift;
    return;
}



=head2 run

  Title    : run
  Usage    : $folder->run($bioseq_object, $bioseq_object, ...);
  Function : Run the executable with the set parameters
  Returns  : The location of the output files.
  Args     : None

=cut

sub run {

  my $self = shift;
  my @seqs  = @_;

  $self->throw('No sequences provided') unless scalar @seqs;

  my $tempdir = $self->tempdir;
  my $seqfile = "$tempdir/sequences.txt";
  my $seq_out = Bio::SeqIO->new('-file' => ">$seqfile",
				'-format' => 'raw');
  foreach(@seqs){
    $seq_out->write_seq($_);
  }

  my $exe = $self->executable;
  $self->throw("$exe was not found.") unless -e $exe;
  $self->throw("$exe not executable.") unless -x $exe;

  my $param_string = $self->parameter_string(-double_dash=>1);
  my $exe_string = join " ", $exe, $param_string, $seqfile;

  my $status = system("cd $tempdir && $exe_string");

  return $exe_string;
}




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
