package Zabbix2::API::Host;

use strict;
use warnings;
use 5.010;
use Carp;
use autodie;
use utf8;

use Moo::Lax;
extends qw/Zabbix2::API::CRUDE/;
use Zabbix2::API::HostInterface;

has 'items' => (is => 'ro',
                lazy => 1,
                builder => '_fetch_items');
has 'interfaces' => (is => 'rw');
has 'hostgroups' => (is => 'ro',
                     lazy => 1,
                     builder => '_fetch_hostgroups');
has 'graphs' => (is => 'ro',
                 lazy => 1,
                 builder => '_fetch_graphs');

sub id {
    ## mutator for id
    my ($self, $value) = @_;
    if (defined $value) {
        $self->data->{hostid} = $value;
        return $self->data->{hostid};
    } else {
        return $self->data->{hostid};
    }
}

sub _readonly_properties {
    return {
        hostid => 1,
        available => 1,
        disable_until => 1,
        error => 1,
        errors_from => 1,
        flags => 1,
        ipmi_available => 1,
        ipmi_disable_until => 1,
        ipmi_error => 1,
        ipmi_errors_from => 1,
        jmx_available => 1,
        jmx_error => 1,
        jmx_errors_from => 1,
        maintenance_from => 1,
        maintenance_status => 1,
        maintenance_type => 1,
        maintenanceid => 1,
        snmp_available => 1,
        snmp_disable_until => 1,
        snmp_error => 1,
        snmp_errors_from => 1,
    };
}

sub _prefix {
    my (undef, $suffix) = @_;
    if ($suffix) {
        return 'host'.$suffix;
    } else {
        return 'host';
    }
}

sub _extension {
    return (output => 'extend',
            selectMacros => 'extend',
            selectInterfaces => 'extend');
}

sub name {
    my $self = shift;
    return $self->data->{name} || '???';
}

sub _fetch_items {
    my $self = shift;
    my $items = $self->{root}->fetch('Item', params => { hostids => [ $self->data->{hostid} ] });
    return $items;
}

sub _fetch_hostgroups {
    my $self = shift;
    my $items = $self->{root}->fetch('HostGroup', params => { hostids => [ $self->data->{hostid} ] });
    return $items;
}

sub _fetch_graphs {
    my $self = shift;
    my $graphs = $self->{root}->fetch('Graph', params => { hostids => [ $self->data->{hostid} ] });
    return $graphs;
}

sub _map_interfaces_to_property {
    my ($self) = @_;
    $self->data->{interfaces} = [ map { $_->data } @{$self->interfaces} ];
    return;
}

sub _map_property_to_interfaces {
    my ($self) = @_;
    my @interfaces = map { Zabbix2::API::HostInterface->new(root => $self->root,
                                                            data => $_) } @{$self->data->{interfaces}};
    $self->interfaces(\@interfaces);
    return;
}

before 'create' => \&_map_interfaces_to_property;
before 'update' => \&_map_interfaces_to_property;
after 'pull' => \&_map_property_to_interfaces;
around 'new' => sub {
    my ($orig, @rest) = @_;
    my $host = $orig->(@rest);
    $host->_map_property_to_interfaces;
    return $host;
};

1;
__END__
=pod

=head1 NAME

Zabbix2::API::Host -- Zabbix host objects

=head1 SYNOPSIS

  use Zabbix2::API::Host;
  # fetch a single host by ID
  my $host = $zabbix->fetch_single('Host', params => { hostids => [ 10105 ] });
  
  # and delete it
  $host->delete;
  
  # helpers -- these all fire an API call
  my $items = $host->items;
  my $hostgroups = $host->hostgroups;
  my $graphs = $host->graphs;
  
  # this one doesn't
  my $interfaces = $host->interfaces;

=head1 DESCRIPTION

Handles CRUD for Zabbix host objects.

This is a subclass of C<Zabbix2::API::CRUDE>; see there for inherited
methods.

=head1 ATTRIBUTES

=head2 graphs

(read-only arrayref of L<Zabbix2::API::Graph> objects)

This attribute is lazily populated with the host's graphs from the
server.

=head2 hostgroups

(read-only arrayref of L<Zabbix2::API::HostGroup> objects)

This attribute is lazily populated with the host's hostgroups from the
server.

=head2 interfaces

(read-write arrayref of L<Zabbix2::API::HostInterface> instances)

This attribute is populated automatically when the Perl object is
updated from the "interfaces" server property (i.e. when the C<pull>
method is called).

Likewise, it is automatically used to populate the "interfaces"
property before either C<create> or C<update> are called.

Note that "interfaces" is a required property as far as the server is
concerned, so you must defined it one way or another.

=head2 items

(read-only arrayref of L<Zabbix2::API::Item> objects)

This attribute is lazily populated with the host's items from the
server.

=head1 SEE ALSO

L<Zabbix2::API::CRUDE>.

=head1 AUTHOR

Fabrice Gabolde <fga@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011, 2014 SFR

This library is free software; you can redistribute it and/or modify
it under the terms of the GPLv3.

=cut
