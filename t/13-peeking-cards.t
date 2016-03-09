#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 57;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();
my $top_card = $deck->peek( 1 );
my $card;

# peeking works
for ( [ 1, 'top' ], [ 2, 'second' ], [ -2, 'greek' ], [ -1, 'bottom' ] ) {
    $card = $deck->find( $_->[0] );
    is( $deck->peek( $_->[1] ), $card );
}

for ( 1 .. $deck->deck_size ) {
    $card = $deck->find( $_ );
    is( $deck->peek($_), $card );
}

# peeking without a parameter peeks the top card
$top_card = $deck->find( 1 );
is( $deck->peek, $top_card );
