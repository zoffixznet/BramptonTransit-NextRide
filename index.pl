#!/usr/bin/env perl

use strict;
use warnings;
use CGI::Carp qw/fatalsToBrowser/;
use lib '/home/zoffix/perl5/lib/perl5/';

use HTML::Template;
use BT::NextRide;
use HTML::Entities;
my $bt = BT::NextRide->new( stop => 3114 )->get_next_ride;

print "Content-type: text/html\n\n";
print $bt;

# print "</pre>\n";