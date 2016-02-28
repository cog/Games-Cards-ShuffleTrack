#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 5;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();


# AH is first card
is( $deck->find('AH'), 1 );

# First card is AH
is( $deck->find( 1 ), 'AH' );

# 2H is 1 card away from AH
is( $deck->find_relative( 'AH', '2H' ), 1 );

# AH is -1 card away from 2H
is( $deck->find_relative( '2H', 'AH' ), -1 );

# AS is 51 cards away from AH
is( $deck->find_relative( 'AH', 'AS' ), 51 );
