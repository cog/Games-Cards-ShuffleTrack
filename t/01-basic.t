#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 105;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

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
