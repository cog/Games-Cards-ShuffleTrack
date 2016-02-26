#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 4;

# TODO: relative position of cards is the same
# TODO: cutting 26 twice results in the original order

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();


# cutting one card moves it to the bottom
my @original_deck = @{$deck->get_deck};
my ($top_card, $second_card) = @original_deck[0, 1];

$deck->cut(1);

my @cut_deck = @{$deck->get_deck};
my ($new_top_card, $new_bottom_card) = @cut_deck[0, -1];

is( $top_card, $new_bottom_card);
is( $second_card, $new_top_card);


# cut the deck normally changes top and bottom cards
my @before_cutting = $deck->get_deck();

$deck->cut();

my @after_cutting = $deck->get_deck();

isnt( $before_cutting[0], $after_cutting[0] );
isnt( $before_cutting[-1], $after_cutting[-1] );
