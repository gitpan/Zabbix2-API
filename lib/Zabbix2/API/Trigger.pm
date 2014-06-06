package Zabbix2::API::Trigger;

use strict;
use warnings;
use 5.010;
use Carp;
use autodie;
use utf8;

use Moo::Lax;
extends qw/Zabbix2::API::CRUDE/;

sub _readonly_properties {
    return {
        triggerid => 1,
        error => 1,
        flags => 1,
        lastchange => 1,
        state => 1,
        templateid => 1,
        value => 1,
    };
}

sub id {
    ## mutator for id
    my ($self, $value) = @_;
    if (defined $value) {
        $self->data->{triggerid} = $value;
        return $self->data->{triggerid};
    } else {
        return $self->data->{triggerid};
    }
}

sub _prefix {
    my (undef, $suffix) = @_;
    if ($suffix) {
        return 'trigger'.$suffix;
    } else {
        return 'trigger';
    }
}

sub _extension {
    return (output => 'extend',
            selectHosts => ['hostid'],
            selectItems => ['itemid'],
            selectFunctions => 'extend',
            selectDependencies => ['triggerid']);
}

sub name {
    my $self = shift;
    # can't think of a good name for triggers -- descriptions are too long
    return $self->data->{description};
}

1;
__END__
=pod

=head1 NAME

Zabbix2::API::Trigger -- Zabbix trigger objects

=head1 SYNOPSIS

  use Zabbix2::API::Trigger;
  
  # fetch a single trigger...
  my $trigger = $zabbix->fetch_single('Trigger', params => { triggerids => [ 22379 ] });
  
  # manipulate its properties: make it "average" severity
  $trigger->data->{priority} = 3;
  
  # and update the properties on the server.
  $trigger->update;
  
  # create a new trigger
  my $new_trigger = Zabbix2::API::Trigger->new(
      root => $zabbix,
      data => {
          description => 'some trigger',
          expression => '{Zabbix server:system.uptime.last(0)}<600',
      });
  $new_trigger->create;
  
  # get the triggers that have been triggered and not acked yet, and
  # their parent hosts' IDs in the "hosts" property
  my $triggers = $zabbix->fetch(
      'Trigger',
      params => {
          filter => { value => 1 },
          withLastEventUnacknowledged => 1,
          selectHosts => ['hostid'],
      });

=head1 DESCRIPTION

Handles CRUD for Zabbix trigger objects.

This is a subclass of C<Zabbix2::API::CRUDE>; see there for inherited
methods.

=head1 BUGS AND LIMITATIONS

L<Zabbix::API::Trigger> used to have rudimentary dependency support;
this version doesn't, because I don't need it right now.  Patches
welcome.

=head1 SEE ALSO

L<Zabbix2::API::CRUDE>.

=head1 AUTHOR

Fabrice Gabolde <fga@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011, 2014 Devoteam

This library is free software; you can redistribute it and/or modify it under
the terms of the GPLv3.

=cut
