#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 2;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

my @before_shuffling = $deck->get_deck();

# shuffle the deck
$deck->riffle_shuffle();

my @after_shuffling = $deck->get_deck();

# TODO: deck is now not in the same order

# bottom card has changed
isnt( $before_shuffling[-1], $after_shuffling[-1] );

# deck has the same amount of cards as in the beginning
is( scalar @before_shuffling, scalar @after_shuffling );