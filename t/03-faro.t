#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

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