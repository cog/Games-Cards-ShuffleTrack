#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 16;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();


# AH is first card
is( $deck->find('AH'), 1 );

# First card is AH
is( $deck->find( 1 ), 'AH' );

# AH is first card and AS is last card
is_deeply( [$deck->find( 1, 52 )], ['AH', 'AS'] );
is_deeply( [$deck->find( 'AH', 'AS' )], [1, 52] );

# 2H is 1 card away from AH
is( $deck->distance( 'AH', '2H' ), 1 );

# AH is -1 card away from 2H
is( $deck->distance( '2H', 'AH' ), -1 );

# AS is 51 cards away from AH
is( $deck->distance( 'AH', 'AS' ), 51 );

# 2H comes after AH
is( $deck->find_card_after(  'AH' ), '2H' );
# AH comes before 2H
is( $deck->find_card_before( '2H' ), 'AH' );


# Card before AH is AS (card before the first one is the last)
is( $deck->find_card_before( 'AH' ), undef );
# Card after AS is AH (card after last is the first one)
is( $deck->find_card_after(  'AS' ), undef );


# managing errors
is_deeply( [$deck->find( )], [] );
is_deeply( [$deck->find( 0 )], [ undef ] );
is_deeply( [$deck->find( 100 )], [ undef ] );
is_deeply( [$deck->find( 0, 100 )], [ (undef, undef) ] );
is_deeply( [$deck->find( 'no such card' )], [ (undef) ] );
