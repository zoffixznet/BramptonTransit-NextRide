package BT::NextRide;

use Moo;
use strictures 2;
use WWW::Mechanize;
use Mojo::DOM;
use namespace::clean;

my $NEXT_STOP_PAGE_URL = 'http://nextride.brampton.ca/mob/SearchBy.aspx';

has stop => (
    is => 'rw',
);

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
    my $self = shift;
    my $mech = $self->_mech;

    $mech->get($NEXT_STOP_PAGE_URL);
    $mech->form_number(1);
    $mech->set_fields(
        'ctl00$mainPanel$searchbyStop$txtStop' => $self->stop,
    );
    $mech->click_button( name => 'ctl00$mainPanel$btnGetRealtimeSchedule' );

    return grep length,
        Mojo::DOM->new( $content )
        ->find('td + td')->map('text')->each
}


1;