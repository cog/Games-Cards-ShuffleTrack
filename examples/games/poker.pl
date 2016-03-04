#usr/bin/perl -w

use strict;
use Games::Cards::ShuffleTrack;

###															###
### This is a simple demonstration of a friendly poker game ###
###															###

my $deck = Games::Cards::ShuffleTrack->new();
my @hands;
for ( 1 .. 5 ) {
    push @hands, Games::Cards::ShuffleTrack->new('empty');
}
$deck->riffle_shuffle() for 1 .. 12;
$deck->cut();

for ( 1 .. 5 ) {
    for my $hand ( @hands ) {
        $hand->put( $deck->deal() );
    }
}

my $hand_count = 0;
for my $hand ( @hands ) {
    $hand_count++;
    print "Hand $hand_count: @{$hand->get_deck}\n";
}

print "Cards left in the deck: @{$deck->get_deck}\n";