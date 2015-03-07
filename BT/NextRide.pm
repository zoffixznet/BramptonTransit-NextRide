package BT::NextRide;

use Moo;
use strictures 2;
use WWW::Mechanize;
use Mojo::DOM;
use namespace::clean;

my $NEXT_STOP_PAGE_URL = 'http://nextride.brampton.ca/mob/SearchBy.aspx';

has _stop => (
    is => 'rw',
);

has _has_cache => (
    is => 'rw',
    default => sub { 0 },
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

sub init {
    my $self = shift;
    $self->_mech->get($NEXT_STOP_PAGE_URL);
    $self->_has_cache(1);
    return $self;
}

sub set_stop {
    my ( $self, $stop ) = @_;
    $self->_stop( $stop );
    return $self;
}

sub get_next_ride {
    my $self = shift;
    my $mech = $self->_mech;
return qw/Mock output when busses aren't running/;
    $self->init
        unless $self->_has_cache;

    $mech->form_number(1);
    $mech->set_fields(
        'ctl00$mainPanel$searchbyStop$txtStop' => $self->_stop,
    );
    $mech->click_button( name => 'ctl00$mainPanel$btnGetRealtimeSchedule' );

    # return qw/Mock output when busses aren't running/;

    my @times = grep length,
        Mojo::DOM->new( $mech->content )
        ->find('td + td')->map('text')->each;

    return @times ? @times : 'No service';
}


1;