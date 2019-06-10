# NAME

WWW::AzimuthAero - Parser for https://azimuth.aero/

# VERSION

version 0.1

# SYNOPSIS

    use WWW::AzimuthAero;
    my $az = WWW::AzimuthAero->new();
    
    $az->get_schedule_dates( from => 'ROV', to => 'KLF' );
    
    $az->get( from => 'ROV', to => 'LED', date => '14.06.2019' );
    
    $az->get_lowest_fares( from => 'ROV', to => 'LED', max => '14.08.2019' );
    
    $az->print_flights(
        $az->get_lowest_fares(
            from          => 'ROV',
            to            => 'LED',
            max           => '14.08.2019',
            progress_bar => 1
        )
    )

Outside:

    perl -Ilib -MData::Dumper -MWWW::AzimuthAero -e 'my $x = WWW::AzimuthAero->new->route_map->transfer_routes; warn Dumper $x;'

# DESCRIPTION

This module provides a parser for https://azimuth.aero/

Module can be useful for creating price monitoring services and flexible travel planners

Module uses [Mojo::UserAgent](https://metacpan.org/pod/Mojo::UserAgent) as user agent and  [Mojo::DOM](https://metacpan.org/pod/Mojo::DOM) + [JavaScript::V8](https://metacpan.org/pod/JavaScript::V8) as DOM parser

# FOR DEVELOPERS

How to generate DOM samples for unit tests after git clone: 

    $ perl -Ilib -e "use WWW::AzimuthAero::Mock; WWW::AzimuthAero::Mock->generate()"

See [WWW::AzimuthAero::Mock](https://metacpan.org/pod/WWW::AzimuthAero::Mock) and [Mojo::UserAgent::Mockable](https://metacpan.org/pod/Mojo::UserAgent::Mockable) for more details

# TO-DO

implement find\_transits

Checking more than 1 transfer

["get\_fares\_schedule" in WWW::AzimuthAero](https://metacpan.org/pod/WWW::AzimuthAero#get_fares_schedule) get requests debug stat

# new

    use WWW::AzimuthAero;
    my $az = Azimuth->new();

# route\_map  

Return [WWW::AzimuthAero::RouteMap](https://metacpan.org/pod/WWW::AzimuthAero::RouteMap) object

    perl -Ilib -MWWW::AzimuthAero -MData::Dumper::AutoEncode -e 'my $x = WWW::AzimuthAero->new->route_map->raw; warn eDumper $x;'

# get\_schedule\_dates

Get schedule by requested direction

    $az->get_schedule_dates( from => 'ROV', to => 'KLF' );
    
    $az->get_schedule_dates( from => 'ROV', to => 'PKV', max => '20.06.2019' ); # will start search from today
    
    $az->get_schedule_dates( from => 'ROV', to => 'PKV', min => '16.06.2019', max => '20.06.2019' );

Return list of available dates in '%d.%m.%Y' format

Method is useful for minimize amount of API requests

If no available\_to property set (like at https://azimuth.aero/ru/flights?from=ROV&to=PKV ) will return all dates in range

# print\_flights

    my @x = $az->get_lowest_fares( from => 'ROV', to => 'MOW', max => '16.06.2019', progress_bar => 1 );
    $az->print_flights(@x);

# get

Checks for flight between two cities on selected date. 

Cities are specified as IATA codes.

    $az->get( from => 'ROV', to => 'LED', date => '04.06.2019' );

Return ARRAYref with flights data of hash with error like 

    { 'error' => 'No flights found' }

Example output 

    [
        {
            'date' => '16.06.2019',
            'fares' => { 'lowest' => '5620', 'svobodnyy' => '5620' },
            'to' => 'KLF',
            'from' => 'ROV',
            'flight' => { 'arrival' => '11:35', 'departure' => '10:00' }
        },from is not defined
        ...
    ];

Example of output if flight has transfers :

\[
      {
        'date' => '12.06.2019',
        'fares' => {
                     'lowest' => '6930',
                     'optimalnyy' => '8430',
                     'svobodnyy' => '16360',
                     'vygodnyy' => '6930'
                   },
        'to' => 'PKV',
        'flight' => {
                      'flight\_duration' => '5ч 35м',
                      'has\_stops' => 1,
                      'departure' => '07:45',
                      'arrival' => '13:20'
                    },
        'from' => 'ROV'
      }
    \];

( flight property will have has\_stops option )

# get\_fares\_schedule

Get fares schedule between selected cities. Cities are specified as IATA codes.

Returned data is sorted by date, ascending

    $az->get_lowest_fares(
        from         => 'ROV',
        to           => 'LED',
        min          => '7.06.2019',
        max          => '15.06.2019',
        progress_bar => 1,
    );

# get\_lowest\_fares

Get lowest fares between selected cities. Cities are specified as IATA codes.

    $az->get_lowest_fares(
        from            => 'ROV',
        to              => 'LED',
        min        => '7.06.2019',
        max        => '15.06.2019',
        progress_bar  => 1,
        check_neighbors => 1,   # will check PKV instead LED and KLG instead of MOW
        find_transits   => 1,   # will find transit cities that are not mentioned by azimuth
        max_delay_days  => 1,   
        # max_edges     => 2    # hardcoded cow
    );

# AUTHOR

Pavel Serikov <pavelsr@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Pavel Serikov.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.