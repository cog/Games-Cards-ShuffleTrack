#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 2;

use Games::Cards::ShuffleTrack;

my $deck = Games::Cards::ShuffleTrack->new();

my @original_deck = $deck->get_deck();


# a deck of 52 cards after 8 faro-outs should result in the original order
$deck->faro_out() for 1 .. 8;

my @after_8_faro_outs = $deck->get_deck();

is_deeply( \@after_8_faro_outs, \@original_deck );


# a deck of 52 cards after 52 faro-ins should see its order reversed
$deck->faro_in() for 1 .. 52;

my @after_52_faro_ins = $deck->get_deck;

is_deeply( \@after_52_faro_ins, [reverse @original_deck] );
