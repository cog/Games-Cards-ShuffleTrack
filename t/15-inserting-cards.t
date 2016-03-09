#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 8;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();
my $top_card = $deck->peek( 1 );
my $card;

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