#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 35;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();
my $top_card = $deck->peek( 1 );

# dealing a card from the top of the deck decreases its size
my $card = $deck->deal();
is( $card, $top_card );
is( $deck->deck_size, 51 );

# dealing from a non existing position defaults to the top of the deck (also document this behavior)
$deck->restart;
$top_card = $deck->peek( 1 );

$card  = $deck->deal( 'nowhere' );

is( $card, $top_card );
is( $deck->deck_size, 51 );

# dealing from special positions deals the right cards
for ( [ 1, 'top' ], [ 2, 'second' ], [ -2, 'greek' ], [ -1, 'bottom' ] ) {
    $card = $deck->find( $_->[0] );
    is( $deck->deal( $_->[1] ), $card );
}

# dealing a card to a pile is possible
$deck->restart;
my $pile = Games::Cards::ShuffleTrack->new( 'empty' );

$top_card = $deck->find( 1 );

$deck->deal( $pile );
is( $deck->deck_size, 51 );
is( $pile->deck_size,  1 );
is( $pile->find( 1 ), $top_card );

# dealing a card to a pile works, regardless of the type of deal
for ( [ 1, 'top' ], [ 2, 'second' ], [ -2, 'greek' ], [ -1, 'bottom' ] ) {
    $pile->restart;
    $deck->restart;
    $card = $deck->find( $_->[0] );
    $deck->deal( $_->[1], $pile );

    is( $deck->deck_size, 51 );
    is( $pile->deck_size,  1 );
    is( $pile->find( 1 ), $card );

    $pile->restart;
    $deck->restart;
    $card = $deck->find( $_->[0] );
    $deck->deal( $pile, $_->[1] );

    is( $deck->deck_size, 51 );
    is( $pile->deck_size,  1 );
    is( $pile->find( 1 ), $card );
}

# TODO: dealing from a pile onto itself does nothing
# TODO: bottom dealing to the top is the same as double uppercut
# TODO: bottom replacement a second deal is the same as a double undercut