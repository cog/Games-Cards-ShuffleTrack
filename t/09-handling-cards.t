#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();
my $top_card = $deck->peek( 1 );
my $card;

# putting a card on top of the deck increases its size
$deck->put( 'AS' );
is( $deck->deck_size, 53 );
