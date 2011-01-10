# ABSTRACT: Wrapper for Unafold melt.pl

=head1 NAME

Bio::Tools::Run::Unafold::melt - quick description

=head1 SYNOPSIS

# Synopsis code demonstrating the module goes here

=head1 DESCRIPTION

A description about this module.

=cut
use strict;
use warnings;
package Bio::Tools::Run::Unafold::melt;

use base 'Bio::Tools::Run::WrapperBase::Accessor';

use Bio::Seq;
use Bio::SeqIO;


__PACKAGE__->_setup
  (

   '-params' => {
		 NA          => 'Nucleic Acid. RNA | DNA. Default is RNA',
		 temperature => 'Temperature for energy minimization, default is 37',
		 sodium      => 'Sodium ion concentration (molar). Default is 1',
		 magnesium   => 'Magnesium ion concentration (molar). Default is 0',
		 Ct          => 'Total strand concentration (molar)',
		 maxbp       => 'Bases farther apart than this value cannot form. Default is no limit'
		},
   '-switches' => {
		   polymer     => 'Use salt corrections for polymers instead of oligomers. Boolean. Default is 0',
		   noisolate   => 'Prohibit all isolated basepairs. Isolated basepairs are helices of length 2; that is, they do not stack on another basepair on either side. Boolean',
		   allpairs    => 'Allows basepairs to form between any two nucleotides. Watson-Crick and wobble are default',
		   nodangle    => 'Removes single-base stacking from consideration. Boolean',
		   simple      => 'Makes the penalty for multibranch loops constant rather than affine. Boolean',
		   prefilter   => 'Filter our all basepairs except those in groups of value2 adjacent basepairs, of which value1 can form. Default is 2 of 2',
		   circular    => 'treat sequences as circular rather than linear'
		  }
  );


=head2 new

  Title    : new
  Usage    : my $hss = Bio::Tools::Run::Unafold::melt->new();
  Function : Constructor
  Returns  : An object of class Bio::Tools::Run::Unafold::melt
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

  $self->{program_name} = $pn || 'melt.pl';

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


=head2 last_result

  Title    : last_result
  Usage    : my $res = $folder->last_result;
  Function : Returns the result of the last run.
  Returns  : A hashref with keys 'dH', 'temp', 'Tm', 'dG', 'dS'
             or undef
  Args     : none

=cut

sub last_result{
    my $self = shift;   
    return $self->{last_result};
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
  Usage    : $folder->run($bioseq_object, $bioseq_object);
  Function : Run the executable with the set parameters
  Returns  : A hashref with keys 'dH', 'temp', 'Tm', 'dG', 'dS'
  Args     : One or two bioseq objects to melt.

=cut

sub run {

  my $self = shift;
  my @seqs  = @_;

  $self->throw('No sequences provided') unless scalar @seqs;
  $self->throw('Too many sequences provided') if (scalar(@seqs)>2);

  my $tempdir = $self->tempdir;

  #write first seq to file
  my $seqfile = "$tempdir/seq.txt";
  my $seq_out = Bio::SeqIO->new('-file' => ">$seqfile",
				'-format' => 'raw');
  $seq_out->write_seq($seqs[0]);
  
  #write out second file if required
  my $seqfile2;
  if (scalar(@seqs) == 2){
    $self->throw("Can't melt 2 sequences when Ct is undefined") unless $self->Ct;
    $seqfile2 = "$tempdir/seq2.txt";
    my $seq2_out = Bio::SeqIO->new('-file' => ">$seqfile2",
				   '-format' => 'raw');
    $seq2_out->write_seq($seqs[1]);

  }

  my $exe = $self->executable;
  $self->throw("$exe was not found.") unless -e $exe;
  $self->throw("$exe not executable.") unless -x $exe;

  my $param_string = $self->parameter_string(-double_dash=>1);
  my $exe_string = join " ", $exe, $param_string, $seqfile;
  $exe_string .= " $seqfile2" if $seqfile2;

  my $res = `cd $tempdir && $exe_string`;

  my @res = split "\n", $res;
  my ($temp) = $res[0] =~ /t\s*=\s*(\d+)/;

  my %results;
  $results{temp} = $temp;
  @results{(split /\s+/, $res[1])} = (split /\s+/, $res[2]);

  #might as well hang on to them.
  $self->{last_result} = \%results;
  return \%results;
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
