#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 2;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

my @before_8_faros = $deck->get_deck();

# a deck of 52 cards after 8 faro-outs should result in the original order
$deck->faro_out();
$deck->faro_out();
$deck->faro_out();
$deck->faro_out();
$deck->faro_out();
$deck->faro_out();
$deck->faro_out();
$deck->faro_out();
my @after_8_faros = $deck->get_deck();

is_deeply( \@before_8_faros, \@after_8_faros );

# a deck of 52 cards after 52 faro-ins should see its order reversed
for (1 .. 52) {
	$deck->faro_in();
}
my @after_52_faros = $deck->get_deck;

is_deeply( \@after_52_faros, [reverse @before_8_faros] );
