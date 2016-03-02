#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 6;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

my @initial_deck = @{$deck->get_deck};

# running two cards on top reverses top and second cards
my ($top_card, $second_card) = $deck->find( 1, 2 );
$deck->run( 2, 'drop-top' );
is( $deck->find($top_card),    2 );
is( $deck->find($second_card), 1 );

# running two cards on top again brings the deck back to its initial position
$deck->run( 2, 'drop-top' );
is( $deck->find($top_card),    1 );
is( $deck->find($second_card), 2 );

# running one card moves it to the bottom
$deck->run( 1 );
is( $deck->find($top_card),    52 );

# running 10 cards to the bottom moves the 10th card to the -10th position
my $tenth_card = $deck->find(10);
$deck->run(10);
is( $deck->find(-10), $tenth_card);