#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 3;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

# putting a card on top of the deck increases its size
$deck->put( 'AS' );
is( $deck->_deck_size, 53 ); # TODO: change this to &deck_size

# dealing a card from the top of the deck decreases its size
my $card = $deck->deal();
is( $card, 'AS' );
is( $deck->_deck_size, 52 );

# TODO: dealing from special positions deals the right cards


# TODO: peeking works


# TODO: taking a random card decreases the deck size and the card is no longer there

