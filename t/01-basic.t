#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 116;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

# deck is face down
is( $deck->orientation, 'down' );

# turning the deck face up results in a face up deck and the original top and bottom cards are now reversed
my ($top_card, $bottom_card) = $deck->find( 1, -1 );
ok( $deck->turn );
is( $deck->orientation, 'up' );

is( $deck->find( $top_card ),    52 );
is( $deck->find( $bottom_card ), 1  );

ok( $deck->turn );
is( $deck->orientation, 'down' );

# deck has 52 cards
is( scalar @{$deck->get_deck()}, 52);

# all cards are different (only one of each card)
my $cards;
for my $card ( @{$deck->get_deck()} ) {
	$cards->{$card}++;
};

for my $card (keys %$cards) {
	is($cards->{$card}, 1);
};

# fournier and new_deck_order share the order of diamonds
my $new_deck = Games::Cards::ShuffleTrack->new();
my $fournier = Games::Cards::ShuffleTrack->new('fournier');

for ( 27 .. 39 ) {
	is( $new_deck->find( $_ ), $fournier->find( $_ ) );
}

# fournier and new_deck_order don't share the order of hearts, spades and clubs
for ( 1 .. 26, 40 .. 52 ) {
	isnt( $new_deck->find( $_ ), $fournier->find( $_ ) );
}

# empty deck doesn't have cards
my $empty_deck = Games::Cards::ShuffleTrack->new( 'empty' );
is_deeply( $empty_deck->get_deck, [] );

# reseting an empty deck results in an empty deck
$empty_deck->reorder;
is_deeply( $empty_deck->get_deck, [] );

# reseting a shuffled deck that started with new_deck order results in a deck in new deck order
my $other_new_deck = Games::Cards::ShuffleTrack->new;

$new_deck->riffle_shuffle;
$new_deck->riffle_shuffle;
$new_deck->reorder;
is_deeply( $new_deck->get_deck, $other_new_deck->get_deck );
$new_deck->riffle_shuffle;
$new_deck->reorder;
is_deeply( $new_deck->get_deck, $other_new_deck->get_deck );


