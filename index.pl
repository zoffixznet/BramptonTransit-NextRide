#!/usr/bin/env perl

use strict;
use warnings;
use CGI::Carp qw/fatalsToBrowser/;
use lib '/home/zoffix/perl5/lib/perl5/';

use HTML::Template;
use BT::NextRide;

my @STOPS_TO_DISPLAY = qw/3143  3114  1768  1506  2650/;

my $bt = BT::NextRide->new;

my $t = HTML::Template->new_file( 'template.html', die_on_bad_params => 0 );
$t->param(
    stops => [
        map +{
            stop  => $_,
            times => [
                map +{ time => $_ },
                    $bt->set_stop( $_ )->get_next_ride,
            ],
        }, @STOPS_TO_DISPLAY,
    ],
);

print "Content-type: text/html\n\n", $t->output;