#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Warn;

plan tests => 27;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();


# cutting 26 twice results in the original order
my $deck_1 = $deck->get_deck;
$deck->cut(26) for 1 .. 2;
is_deeply( $deck_1, $deck->get_deck );


# cutting 13 four times results in the original order
$deck->cut(13) for 1 .. 4;
is_deeply( $deck_1, $deck->get_deck );


# cutting one card moves it to the bottom
my @original_deck = @{$deck->get_deck};
my ($top_card, $second_card) = @original_deck[0, 1];

$deck->cut(1);

my @cut_deck = @{$deck->get_deck};
my ($new_top_card, $new_bottom_card) = @cut_deck[0, -1];

is( $top_card, $new_bottom_card);
is( $second_card, $new_top_card);

# relative position of cards (as long as they're kept in the same packet) is the same
my $distance = $deck->distance( '3H', 'KH' );
$deck->cut(26);
is( $deck->distance( '3H', 'KH' ), $distance );

# cut the deck normally changes top and bottom cards
my @before_cutting = $deck->get_deck();

$deck->cut();

my @after_cutting = $deck->get_deck();

isnt( $before_cutting[0], $after_cutting[0] );
isnt( $before_cutting[-1], $after_cutting[-1] );

# cutting above a card moves it to the top_card
for my $card ( qw/AS JS 10H/ ) {
	$deck->cut_above( $card );
	is( $deck->find( $card ), 1 );
}

# cutting below a card moves it to te bottom
for my $card ( qw/AS JS 10H/ ) {
	$deck->cut_below( $card );
	is( $deck->find( $card ), 52 );
}

# cutting above a card that is already on top doesn't do anything
$deck->cut_above( 'JS' );
is( $deck->find( 'JS' ), 1 );
$deck->cut_above( 'JS' );
is( $deck->find( 'JS' ), 1 );

# cutting below a card that is already on the bottom doesn't do anything
$deck->cut_below( 'JS' );
is( $deck->find( 'JS' ), 52 );
$deck->cut_below( 'JS' );
is( $deck->find( 'JS' ), 52 );

# additional ways of cutting also work
ok( $deck->cut( 'short'  ) );
ok( $deck->cut( 'center' ) );
ok( $deck->cut( 'deep'   ) );

# cutting at the top or bottom of the deck doesn't do anything
my $deck_before_cutting = $deck->get_deck;
$deck->cut( 0 );
is_deeply( $deck_before_cutting, $deck->get_deck );
$deck->cut( 52 );
is_deeply( $deck_before_cutting, $deck->get_deck );
$deck->cut( -52 );
is_deeply( $deck_before_cutting, $deck->get_deck );

# cut at a non-existing position doesn't alter the order of the deck and issues warnings
my $min_tp = 0.30;
eval "use Test::Warn $min_tp";
plan skip_all => "Test::Warn $min_tp required for testing warnings" if $@;

warnings_exist {$deck->cut( 100 )} [qr/Tried to cut the deck at a non-existing position/];
is_deeply( $deck_before_cutting, $deck->get_deck );
warnings_exist {$deck->cut( -100 )} [qr/Tried to cut the deck at a non-existing position/];
is_deeply( $deck_before_cutting, $deck->get_deck );
