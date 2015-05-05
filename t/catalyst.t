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
