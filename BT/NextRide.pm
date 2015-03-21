package BT::NextRide;

use Moo;
use strictures 2;
use WWW::Mechanize;
use Mojo::DOM;
use namespace::clean;

my $NEXT_STOP_PAGE_URL = 'http://nextride.brampton.ca/mob/home.aspx?stop=';

has _mech => (
    is => 'ro',
    default => sub {
        WWW::Mechanize->new(
            agent => 'Mozilla/5.0 (X11; Linux i686; rv:25.2) Gecko'
                . '/20150112 Firefox/31.9 PaleMoon/25.2.0',
            timeout => 30,
        );
    },
);

sub get_next_ride {
    my ( $self, $stop ) = @_;

    my $mech = $self->_mech;

    $mech->get( $NEXT_STOP_PAGE_URL . $stop );

    return 'Stop not found'
        if $mech->content =~ /No stop found for given stop code/;

    my @times = grep length,
        Mojo::DOM->new( $mech->content )
        ->find('td + td')->map('text')->each;

    return @times ? @times : 'No service';
}


1;