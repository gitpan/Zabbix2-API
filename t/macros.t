use Test::More;
use Test::Exception;
use Data::Dumper;

use Zabbix2::API;

use lib 't/lib';
use Zabbix2::API::TestUtils;
use Zabbix2::API::Macro;

unless ($ENV{ZABBIX_SERVER}) {
    plan skip_all => 'Needs an URL in $ENV{ZABBIX_SERVER} to run tests.';
}

my $zabber = Zabbix2::API::TestUtils::canonical_login;

my $macro = Zabbix2::API::Macro->new(root => $zabber,
                                     data => { macro => '{$SUPERMACRO}',
                                               value => 'ITSABIRD' });

isa_ok($macro, 'Zabbix2::API::Macro',
       '... and a macro created manually');

lives_ok(sub { $macro->create }, '... and pushing a new macro works');

ok($macro->exists, '... and the pushed macro returns true to existence tests (id is '.$macro->id.')');

$macro->value('ITSAPLANE');

$macro->update;
$macro->pull;

is($macro->value, 'ITSAPLANE',
   '... and pushing a modified macro updates its data on the server');

lives_ok(sub { $macro->delete }, '... and deleting a macro works');

ok(!$macro->exists,
   '... and deleting a macro removes it from the server');

eval { $zabber->logout };

done_testing;
