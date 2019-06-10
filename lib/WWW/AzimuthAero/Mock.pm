package WWW::AzimuthAero::Mock;

# ABSTRACT: additional subroutines for unit testing

=head1 SYNOPSIS

    perl -Ilib -e "use WWW::AzimuthAero::Mock; WWW::AzimuthAero::Mock->generate()"

=head1 DESCRIPTION

    Some helpers to generate mocks

=cut

use DateTime;
use Mojo::UserAgent::Mockable;
use feature 'say';

=head1 mock_data

Return data that is used for mock at unit tests

=cut

sub mock_data {
    return {
        get => {
            # uncomment when check for new DOM and change date next after testing
            # from => 'ROV', to => 'MOW', date => DateTime->now->add(weeks=>2)->dmy('.')        
            from => 'ROV', to => 'MOW', date => '23.06.2019'
        }
    }
}

sub filename {
    return 't/ua_mock.json';
}

sub generate {
    my $self = shift;
    my $mock_data = $self->mock_data->{get};
    
    my $ua = Mojo::UserAgent::Mockable->new( mode => 'record', file => $self->filename, ignore_headers => 1 );
    $ua->get('https://booking.azimuth.aero/');
    my $url = 'https://booking.azimuth.aero/!/'.$mock_data->{from}.'/'.$mock_data->{to}.'/'.$mock_data->{date}.'/1-0-0/';
    $ua->get($url)->res->dom;
    $ua->save;
    say 'please manually check prices at '.$url.' and fix 01-AzimuthAero.t if needed';
}




1;