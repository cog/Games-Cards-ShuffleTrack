#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();
$deck->riffle_shuffle() for 1 .. 4;

my $selected_card = $deck->take_random();

my $key_card      = $deck->peek( -1 ); # peek the bottom card

$deck->put( $selected_card );
$deck->cut;

is( $deck->find_card_after( $key_card ), $selected_card );
