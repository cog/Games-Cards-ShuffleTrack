#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 16;

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

# running no cards does nothing
my @deck = @{$deck->get_deck};
ok($deck->run);
is_deeply( \@deck, $deck->get_deck );

# running a negative number of cards does nothing
ok($deck->run( -2 ));
is_deeply( \@deck, $deck->get_deck );

# overhand shuffling changes top and bottom cards

my ($t, $b) = $deck->find( 1, -1 );

ok( $deck->overhand_shuffle );

isnt( $deck->find(  1 ), $t );
isnt( $deck->find( -1 ), $b );

# overhand shuffle accepts a parameter
ok( $deck->overhand_shuffle( 2 ) );


# running cards in an empty deck does nothing and the deck remains with no cards
my $empty_deck = Games::Cards::ShuffleTrack->new( 'empty' );
ok($empty_deck->run(3));
is($empty_deck->deck_size, 0);

