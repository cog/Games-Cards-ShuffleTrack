#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 2;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

my @before_cutting = $deck->get_deck();

# shuffle the deck
$deck->cut();

my @after_cutting = $deck->get_deck();


# top card has changed
isnt( $before_cutting[0], $after_cutting[0] );

# bottom card has changed
isnt( $before_cutting[-1], $after_cutting[-1] );

# TODO: relative position of cards is the same
