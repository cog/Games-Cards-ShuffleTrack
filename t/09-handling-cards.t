#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 61;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

# putting a card on top of the deck increases its size
$deck->put( 'AS' );
is( $deck->deck_size, 53 );

# dealing a card from the top of the deck decreases its size
my $card = $deck->deal();
is( $card, 'AS' );
is( $deck->deck_size, 52 );

# dealing from special positions deals the right cards
for ( [ 1, 'top' ], [ 2, 'second' ], [ -2, 'greek' ], [ -1, 'bottom' ] ) {
    $card = $deck->find( $_->[0] );
    is( $deck->deal( $_->[1] ), $card );
}

# peeking works
for ( [ 1, 'top' ], [ 2, 'second' ], [ -2, 'greek' ], [ -1, 'bottom' ] ) {
    $card = $deck->find( $_->[0] );
    is( $deck->peek( $_->[1] ), $card );
}

for ( 1 .. $deck->deck_size ) {
    $card = $deck->find( $_ );
    is( $deck->peek($_), $card );
}

# peeking without a parameter peeks the top card
my $top_card = $deck->find( 1 );
is( $deck->peek, $top_card );

# taking a random card decreases the deck size and the card is no longer there
$deck->restart;
my $deck_size = $deck->deck_size();
$deck->remove( 1 );
is( $deck->deck_size(), $deck_size - 1 );
