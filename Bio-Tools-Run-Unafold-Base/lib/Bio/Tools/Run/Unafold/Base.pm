# ABSTRACT: Base class for Bioperl compatible Unafold wrappers

=head1 NAME

Bio::Tools::Run::Unafold::Base - Base class for Bioperl compatible Unafold wrappers

=head1 SYNOPSIS

Do not attempt to directly instantiate objects from this class. 
Use the appropriate subclass.


=head1 DESCRIPTION

Base class for Bioperl compatible Unafold wrappers

=cut

use strict;
use warnings;
package Bio::Tools::Run::Unafold::Base;

use base qw('Class::Accessor','Bio::Tools::Run::Wrapper::Base');


sub new{
  my $class = shift;
  my $self = 

  # create getters/setters for all of the valid parameters:
  __PACKAGE__->mk_accessors( keys __PACKAGE__->parameters );

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
