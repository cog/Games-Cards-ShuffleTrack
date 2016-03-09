#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 156;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();
my $top_card = $deck->peek( 1 );

# putting a card on top of the deck increases its size
$deck->put( 'AS' );
is( $deck->deck_size, 53 );

# dealing a card from the top of the deck decreases its size
my $card = $deck->deal();
is( $card, 'AS' );
is( $deck->deck_size, 52 );

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


# peeking works
for ( [ 1, 'top' ], [ 2, 'second' ], [ -2, 'greek' ], [ -1, 'bottom' ] ) {
    $card = $deck->find( $_->[0] );
    is( $deck->peek( $_->[1] ), $card );
}

for ( 1 .. $deck->deck_size ) {
    $card = $deck->find( $_ );
    is( $deck->peek($_), $card );
}

# TODO: bottom dealing to the top is the same as double uppercut
# TODO: bottom replacement a second deal is the same as a double undercut

# peeking without a parameter peeks the top card
$top_card = $deck->find( 1 );
is( $deck->peek, $top_card );

# taking a random card decreases the deck size and the card is no longer there
$deck->restart;
my $deck_size = $deck->deck_size();
$deck->remove( 1 );
is( $deck->deck_size, $deck_size - 1 );

$deck->take_random( );
is( $deck->deck_size, $deck_size - 2 );

# taking a random card after the 13th position preserves the top 13 cards
$deck->restart;
my @top_stock;
for ( 1 .. 13 ) {
	push @top_stock, $deck->find( $_ );
}
my $random_card = $deck->take_random( 14 );

ok( not grep {/$random_card/} @top_stock );

# taking a random card after the 51st position results in the 
$deck->restart;
my $card52 = $deck->find( 52 );
is( $deck->take_random( 52 ), $card52 );

# taking a random card at a specific position results in that specific card
$deck->restart;
for ( 1 .. 52 ) {
	is( $deck->find( $_ ), $deck->take_random( $_, $_ ) );
	$deck->restart;
}

# inserting cards in the deck
$deck->restart;
is( $deck->find( 'Joker' ), 0 );
$deck->insert(   'Joker',   10 );
is( $deck->find( 'Joker' ), 10 );

# inserting at position 1 places the card on top of the deck
$deck->restart;
is( $deck->find( 'Joker' ), 0 );
$deck->insert(   'Joker',   1 );
is( $deck->find( 'Joker' ), 1 );

# inserting at a non-existing position places the card on the bottom of the deck
$deck->restart;
is( $deck->find( 'Joker' ), 0 );
$deck->insert(   'Joker',   100 );
is( $deck->find( 'Joker' ), 53 );

# inserting at a random position also places the card in the deck
$deck->restart;
is( $deck->find( 'Joker' ), 0 );
$deck->insert(   'Joker' );
cmp_ok( $deck->find( 'Joker' ), '>', 0 );
