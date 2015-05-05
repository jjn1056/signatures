BEGIN {
  use Test::Most;
  eval "use Catalyst 5.90060; 1" || do {
    plan skip_all => "Need a version of Catalyst => $@";
  };
}

{
  package Catalyst::ActionRole::Dummy;

  use Moose::Role;

  ## I do nothing at all except exist...

  $INC{'Catalyst/ActionRole/Dummy.pm'} = __FILE__;

  package MyApp::Controller::Root;
  use base 'Catalyst::Controller';

  use signatures;

  sub test_model($self, $c) :Local Does(Dummy) {
    Test::Most::is ref $self, 'MyApp::Controller::Root';
    Test::Most::is ref $c, 'MyApp';
}

  $INC{'MyApp/Controller/Root.pm'} = __FILE__;

  package MyApp;
  use Catalyst;
  
  MyApp->setup;
}

use Catalyst::Test 'MyApp';

ok my ($res, $c) = ctx_request('/root/test_model');

done_testing(3);

__END__

Generates an error like this:

johns-MBP-2:signatures jnapiorkowski$ perl -Mblib t/catalyst.t 
Global symbol "$self" requires explicit package name at t/catalyst.t line 23.
Global symbol "$c" requires explicit package name at t/catalyst.t line 24.
BEGIN not safe after errors--compilation aborted at t/catalyst.t line 30.

I think its something to do with how Catalyst::Controller builds the
action class instance, and applies the role, like we can't find the
right method anymore...
