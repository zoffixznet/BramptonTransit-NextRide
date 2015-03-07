#!/usr/bin/env perl

use strict;
use warnings;
use lib '/home/zoffix/perl5/lib/perl5/';

use CGI qw/Vars/;
use CGI::Carp qw/fatalsToBrowser/;
use HTML::Template;
use JSON::MaybeXS;

use BT::NextRide;

my $q = {Vars()};
my @stops_to_display = $q->{stop}
    ? split /\s*,\s*/, $q->{stop}
    : qw/3143  3114  1768  1506  2650/;

my $bt = BT::NextRide->new;

my %data = (
    stops => [
        map +{
            stop  => $_,
            times => [
                map +{ time => $_ },
                    $bt->set_stop( $_ )->get_next_ride,
            ],
        }, @stops_to_display,
    ],
);

if ( $q->{ajax} ) {
    print "Content-type: application/json \n\n",
        encode_json \%data;
}
else {
    my $t = HTML::Template->new_file(
        'template.html',
        die_on_bad_params => 0
    );
    $t->param( %data );

    print
    # "Content-type: text/html\n\n",
    $t->output;
}
