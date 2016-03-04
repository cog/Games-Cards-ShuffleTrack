#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 4;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

my @initial_deck = @{$deck->get_deck};

# running cuts changes top and bottom cards

my ($t, $b) = $deck->find( 1, -1 );

ok( $deck->running_cuts );

isnt( $deck->find(  1 ), $t );
isnt( $deck->find( -1 ), $b );

# running cuts accepts a parameter
ok( $deck->running_cuts( 2 ) );
