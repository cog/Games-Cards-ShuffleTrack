#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 53;

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