use strict;
use warnings;
use Test::More tests => 8;

use Sub::Signature;

eval 'sub foo ($bar) { $bar }';
ok(!$@, 'signatures parse in eval');
diag $@ if $@;
ok(\&foo, 'sub declared in eval');
is(foo(42), 42, 'eval signature works');

no Sub::Signature;

$SIG{__WARN__} = sub {};
eval 'sub bar ($baz) { $baz }';
like($@, qr/requires explicit package name/, 'string eval disabled');

{
    use Sub::Signature;

    eval 'sub bar ($baz) { $baz }';
    ok(!$@, 'signatures parse in eval');
    diag $@ if $@;
    ok(\&bar, 'sub declared in eval');
    is(bar(42), 42, 'eval signature works');
}

$SIG{__WARN__} = sub {};
eval 'sub moo ($kooh) { $kooh }';
like($@, qr/requires explicit package name/, 'string eval disabled');
