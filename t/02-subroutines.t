#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

# deck has 52 cards
is( $deck->_deck_size(), 52 );
