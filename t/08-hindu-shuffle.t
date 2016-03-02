#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 2;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

my @initial_deck = @{$deck->get_deck};

# hindu shuffling changes top and bottom cards

my ($t, $b) = $deck->find( 1, -1 );

$deck->hindu_shuffle;

isnt( $deck->find(  1 ), $t );
isnt( $deck->find( -1 ), $b );
