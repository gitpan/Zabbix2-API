package Zabbix2::API::HostInterface;

use strict;
use warnings;
use 5.010;
use Carp;
use autodie;
use utf8;

use Moo::Lax;
extends qw/Exporter Zabbix2::API::CRUDE/;

use constant {
    INTERFACE_TYPE_UNKNOWN => 0,
    INTERFACE_TYPE_AGENT => 1,
    INTERFACE_TYPE_SNMP => 2,
    INTERFACE_TYPE_IPMI => 3,
    INTERFACE_TYPE_JMX => 4,
    INTERFACE_TYPE_ANY => 255,
};

our @EXPORT_OK = qw/
INTERFACE_TYPE_UNKNOWN
INTERFACE_TYPE_AGENT
INTERFACE_TYPE_SNMP
INTERFACE_TYPE_IPMI
INTERFACE_TYPE_JMX
INTERFACE_TYPE_ANY
/;

our %EXPORT_TAGS = (
    interface_types => [
        qw/INTERFACE_TYPE_UNKNOWN
           INTERFACE_TYPE_AGENT
           INTERFACE_TYPE_SNMP
           INTERFACE_TYPE_IPMI
           INTERFACE_TYPE_JMX
           INTERFACE_TYPE_ANY/
    ],
);

sub _prefix {
    my (undef, $suffix) = @_;
    if ($suffix) {
        if ($suffix =~ m/ids?/) {
            return 'interface'.$suffix;
        }
        return 'hostinterface'.$suffix;
    } else {
        return 'hostinterface';
    }
}

1;
__END__
=pod

=head1 NAME

Zabbix2::API::HostInterface -- Zabbix host interface objects

=head1 SYNOPSIS

  my $new_host = Zabbix2::API::Host->new(root => $zabber,
                                         data => { host => 'Another Server',
                                                   ip => '255.255.255.255',
                                                   useip => 1,
                                                   groups => [ { groupid => 4 } ] });
  $new_host->interfaces([ Zabbix2::API::HostInterface->new(
                              root => $zabber,
                              data => {
                                  dns => 'localhost',
                                  ip => '',
                                  main => 1,
                                  port => 10000,
                                  type => Zabbix2::API::HostInterface::INTERFACE_TYPE_AGENT,
                                  useip => 0,
                              }) ]);
  $new_host->create;

=head1 DESCRIPTION

While technically a subclass of L<Zabbix2::API::CRUDE>, this class
does not actually implement all methods necessary to behave as a
full-fledged Zabbix object.  Instead, we recommend using
L<Zabbix2::API::HostInterface> objects via their parent
L<Zabbix2::API::Host> object.  Calls to unimplemented methods will
throw an exception.

Unlike L<Zabbix2::API::GraphItem> objects, for which the usual API
methods are not all implemented on the server, this is mostly a case
of laziness of our part, so patches are welcome.

L<Zabbix2::API::HostInterface> objects will be automatically created
from a L<Zabbix2::API::Host> object's properties whenever it is pulled
from the server.  Conversely, if you add interfaces manually to a
L<Zabbix2::API::Host> object, the L<Zabbix2::API::HostInterface>
objects will be automatically turned into properties just before a
call to C<create> or C<update>, causing the relevant host interface
objects to be created or updated on the server.

=head1 EXPORTS

Some constants:

  INTERFACE_TYPE_UNKNOWN
  INTERFACE_TYPE_AGENT
  INTERFACE_TYPE_SNMP
  INTERFACE_TYPE_IPMI
  INTERFACE_TYPE_JMX
  INTERFACE_TYPE_ANY

They are not exported by default, only on request; or you could import
the C<:interface_types> tag.

=head1 SEE ALSO

L<Zabbix2::API::CRUDE>, L<Zabbix2::API::Host>

=head1 AUTHOR

Fabrice Gabolde <fga@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 Fabrice Gabolde

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
