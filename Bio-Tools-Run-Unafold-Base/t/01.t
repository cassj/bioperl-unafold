use strict;
use warnings;

use Data::Dumper;
use Bio::Root::Test;

use Bio::Tools::Run::Unafold::Base;

test_begin(-tests => 10,
           -requires_modules => [],
           -requires_networking => 0);

is(1,1,"an example test");


# Cobble a subclass together:
push @ATestClass::ISA, 'Bio::Tools::Run::Unafold::Base';
#define some parameters for it
$ATestClass::Parameters = {
			    foo => 'a numeric value',
			    bar => 'a string',
			    baz => 'a boolean value'
			   };

can_ok('ATestClass', '_register_parameters');
ok(ATestClass->_register_parameters($ATestClass::Parameters), 'registering parameters');

# check we've added the parameter accessors
can_ok('ATestClass', 'valid_parameters');
can_ok('ATestClass', 'is_valid_parameter'); 


# and argument accessors for each parameter
can_ok('ATestClass', 'foo');
can_ok('ATestClass', 'bar');
can_ok('ATestClass', 'baz');


# and that we can create a new object
my $obj = ATestClass->new();
isa_ok($obj, 'ATestClass');


# and use those accessors
is($obj->foo(123), 123);


