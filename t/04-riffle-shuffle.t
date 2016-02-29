#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 3;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

my @before_shuffling = $deck->get_deck();
my ($bottom, $tenth_from_bottom) = $deck->find( -1, -10 );

# shuffle the deck
$deck->riffle_shuffle();

my @after_shuffling = $deck->get_deck();

# deck is now not in the same order
cmp_ok( $deck->distance( $tenth_from_bottom, $bottom ), '>', 9);

# bottom card has changed
isnt( $before_shuffling[-1], $after_shuffling[-1] );

# deck has the same amount of cards as in the beginning
is( scalar @before_shuffling, scalar @after_shuffling );