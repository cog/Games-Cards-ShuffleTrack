#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Warn;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();
my @original_deck = @{$deck->get_deck};

# Ensure a recent version of Test::Warn
my $min_tw = 0.30;
eval "use Test::Warn $min_tw";
if ($@) {
    plan skip_all => "Test::Warn $min_tw required for testing warnings";
}
else {
    plan tests => 5;
}

# cut at a non-existing position doesn't alter the order of the deck and issues warnings

my $deck_before_cutting = $deck->get_deck;

warnings_exist {$deck->cut( 100 )} [qr/Tried to cut the deck at a non-existing position/];
is_deeply( $deck_before_cutting, $deck->get_deck );
warnings_exist {$deck->cut( -100 )} [qr/Tried to cut the deck at a non-existing position/];
is_deeply( $deck_before_cutting, $deck->get_deck );

# final test to see if we can still restart the deck
$deck->restart;
is_deeply( [@{$deck->get_deck}], [@original_deck] );
