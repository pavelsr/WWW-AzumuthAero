package WWW::AzimuthAero::Flight;

# ABSTRACT: Flight representation

use Class::Tiny qw(from to date departure arrival flight_num duration fares has_stops hours_bf);

=head1 SYNOPSIS

    my $az = WWW::AzimuthAero::Flight->new(date => '16.06.2019', from => 'ROV', to => 'KLF');

=head1 DESCRIPTION

    Object representation of data on pages like https://booking.azimuth.aero/!/ROV/LED/21.06.2019/1-0-0/

=head1 new

    my $az = WWW::AzimuthAero::Flight->new(date => '16.06.2019', from => 'ROV', to => 'KLF');
    
=cut

# sub date {
#     return $self->{date};
# }

1;
