#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 2;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();


# AH is first card
is( $deck->find('AH'), 1 );

# First card is AH
is( $deck->find( 1 ), 'AH' );
