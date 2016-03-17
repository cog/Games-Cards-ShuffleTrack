#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 2;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();
my $top_card = $deck->peek( 1 );

# putting a card on top of the deck increases its size and the card gets added on top
$deck->put( 'Joker' );
is( $deck->deck_size, 53 );

is( $deck->find( 'Joker' ), 1 );
