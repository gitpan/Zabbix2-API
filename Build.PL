use 5.010;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Zabbix2::API',
    license             => 'gpl_3',
    dist_author         => q{Fabrice Gabolde <fgabolde@weborama.com>},
    dist_version_from   => 'lib/Zabbix2/API.pm',
    dist_abstract       => 'Access the JSON-RPC API of a Zabbix 2.x server',
    configure_requires => { 'Module::Build' => '0.36_14' },
    build_requires => {
        'Test::More' => 0,
        'Test::Exception' => 0,
        'Test::Deep' => 0,
    },
    requires => {
        'perl' => 5.010,
        'autodie' => 0,
        'Carp' => 0,
        'constant' => 0,
        'JSON' => 0,
        'List::Util' => 0,
        'Log::Any' => 0,
        'LWP::UserAgent' => 0,
        'Module::Load' => 0,
        'Module::Loaded' => 0,
        'Moo' => 1.001000,
        'Moo::Lax' => 0,
        'Params::Validate' => 0,
        'Scalar::Util' => 0,
        'strict' => 0,
        'Text::ParseWords' => 0,
        'URI' => 0,
        'utf8' => 0,
        'warnings' => 0,
    },
    add_to_cleanup      => [ 'Zabbix2-API-*' ],
    release_status      => 'stable',
    meta_merge          => { resources =>
                             { repository => 'https://bitbucket.org/fgabolde/zabbix2-api',
                               bugtracker => 'https://bitbucket.org/fgabolde/zabbix2-api/issues' } },
);

$builder->create_build_script();
