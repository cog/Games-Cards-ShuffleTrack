package Games::Cards::ShuffleTrack;

use 5.006;
use strict;
use warnings;

use List::Util      qw/min/;
use List::MoreUtils qw/zip first_index/;
use Scalar::Util    qw/looks_like_number/;

=head1 NAME

Games::Cards::ShuffleTrack - Track cards through shuffles and cuts

=head1 VERSION

Version 0.01_6

=cut

our $VERSION = '0.01_6';

my $cut_limits = {
	normal  => [0.19, 0.82], # on a 52 cards deck, cut between 10 and 43 cards
	short   => [0.09, 0.28], # on a 52 cards deck, cut between 5  and 15 cards
	center  => [0.36, 0.59], # on a 52 cards deck, cut between 19 and 31 cards
	deep    => [0.67, 0.86], # on a 52 cards deck, cut between 35 and 45 cards
};

my $decks = {
	empty =>          [],
	new_deck_order => [qw/AH 2H 3H 4H 5H 6H 7H 8H 9H 10H JH QH KH
						  AC 2C 3C 4C 5C 6C 7C 8C 9C 10C JC QC KC
						  KD QD JD 10D 9D 8D 7D 6D 5D 4D 3D 2D AD
						  KS QS JS 10S 9S 8S 7S 6S 5S 4S 3S 2S AS/],
	fournier =>       [qw/AS 2S 3S 4S 5S 6S 7S 8S 9S 10S JS QS KS
						  AH 2H 3H 4H 5H 6H 7H 8H 9H 10H JH QH KH
						  KD QD JD 10D 9D 8D 7D 6D 5D 4D 3D 2D AD
						  KC QC JC 10C 9C 8C 7C 6C 5C 4C 3C 2C AC/],
};

my $shortcuts = {
    'top'     => 1,
    'second'  => 2,
    'greek'   => -2,
    'bottom'  => -1,
};


=head1 SYNOPSIS

This module allows you to simulate true and false shuffles and cuts.

	use Games::Cards::ShuffleTrack;

	my $deck = Games::Cards::ShuffleTrack->new();

	$deck->overhand_shuffle( 2 );
	$deck->riffle_shuffle();
	$deck->cut( 'short' );
	$deck->riffle_shuffle();
	print $deck->get_deck();

Or perhaps with more precision:

	my $deck = Games::Cards::ShuffleTrack->new();

	$deck->faro_in();
	$deck->cut( 26 );
	print $deck->get_deck();

See the rest of the documentation for more advanced features.


=head1 INSTALLATION

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install


=head1 DECK REPRESENTATION

At the moment a deck is represented as a list of strings; each string represents a card where the first letter or digit (or digits, in the case of a 10) is the value of the card and the following letter is the suit:

	C - Clubs
 	H - Hearts
 	S - Spades
 	D - Diamonds

As an example, some card representations:

	AC - Ace of Clubs
	10S - Ten of Spades
	4D - 4 of Diamonds
	KH - King of Hearts


=head1 SUBROUTINES/METHODS

=head2 Standard methods

=head3 new

Create a new deck.

	my $deck = Games::Cards::ShuffleTrack->new();

The order of the deck is from top to bottom, which means it is the reverse of what you see when you spread a deck in your hands with the cards facing you.

When you open most professional decks of cards you'll see the Ace of Spades (AS) in the front; this means it will actually be the 52nd card in the deck, since when you place the cards on the table facing down it will be the bottom card.

Currently this module doesn't support specific orders or different orders other than the new deck.

The order of the cards is as follows:

	Ace of Hearths through King of Hearts
	Ace of Clubs through King of Clubs
	King of Diamonds through Ace of Diamonds
	King of Spades through Ace of Spades

You can also specify the starting order of the deck among the following:

=over 4

=item * new_deck_order (the default order)

=item * fournier

=back

	my $deck = Games::Cards::ShuffleTrack->new( 'fournier' );

=cut

sub new {
	my ($self, $order) = @_;
	   $order ||= 'new_deck_order';
	my $deck    = $decks->{ $order };
	return bless {
		'deck'        => $deck,
		'original'    => $deck,
		'orientation' => 'down',
	}, $self;
}

=head3 restart

Reset the deck to its original status. The original is whatever you selected when you created the deck.

	$deck->restart;

Do bear in mind that by doing so you are replinishing the deck of whatever cards you took out of it.

=cut

sub restart {
	my $self = shift;
	return $self->_set_deck( @{$self->{'original'}} );
}


=head3 deck_size

Returns the size of the deck.

    for ( 1 .. $deck->deck_size ) {
        ...
    }

=cut

sub deck_size {
	my $self = shift;
	return scalar @{$self->{'deck'}};
}


=head3 get_deck

Returns the deck (a reference to a list of strings).

	my $cards = $deck->get_deck();

=cut

sub get_deck { # TODO: use wantarray to allow for an array to be returned
	my $self = shift;
	return $self->{'deck'};
}


=head3 orientation

Return whether the deck is face up or face down:

	if ( $deck->orientation eq 'down' ) {
		...
	}

The deck's orientation is either 'up' or 'down'.

=cut

sub orientation {
	my $self = shift;

	return $self->{'orientation'};
}


=head3 turn

If the deck was face up, it is turned face down; if the deck was face down, it is turned face up.

Turning the deck reverses its order.

	$deck->turn;

=cut

sub turn {
	my $self = shift;

	$self->{'orientation'} = $self->orientation eq 'down' ? 'up' : 'down';

	$self->_set_deck( reverse @{$self->get_deck} );

	return $self;
}


=head2 Shuffling

=head3 Overhand Shuffle

=head4 overhand_shuffle

In an overhand shuffle the cards are moved from hand to the other in packets, the result being similar to that of running cuts (the difference being that the packets in an overhand shuffle may be smaller than the ones in a running cut sequence).

	$deck->overhand_shuffle;

You can specify how many times you want to go through the deck (which is basically the same thing as calling the method that many times):

	$deck->overhand_shuffle( 2 );

=cut

sub overhand_shuffle {
	my $self  = shift;
	my $times = shift || 1;

	$self->_packet_transfer( 1, 10 );

	return $times > 1 ?
		   $self->overhand_shuffle( $times - 1 ) :
		   $self
}

=head3 Hindu Shuffle

=head4 hindu_shuffle

In a Hindu shuffle the cards are moved from hand to the other in packets, the result being similar to that of running cuts (the difference being that the packets in an overhand shuffle may be smaller than the ones in a running cut sequence).

	$deck->hindu_shuffle;

You can specify how many times you want to go through the deck (which is basically the same thing as calling the method that many times):

	$deck->hindu_shuffle( 2 );

The Hindu shuffle differs in result from the Overhand shuffle in that the packets are usually thicker; the reason for this is that while in the Overhand shuffle it's the thumb that grabs the cards (and the thumb can easily carry just one or two cards) in the Hindu shuffle it's more than one finger accomplishing this task, grabbing the deck by the sides, which makes it more difficult (hence, rare) to cut just one or two cards.

=cut

sub hindu_shuffle {
	my $self  = shift;
	my $times = shift || 1;

	$self->_packet_transfer( 4, 10 );

	return $times > 1 ?
		   $self->hindu_shuffle( $times - 1 ) :
		   $self
}

sub _packet_transfer {
	my $self = shift;
	my $min  = shift;
	my $max  = shift;

	my @deck = @{$self->get_deck};

	my @new_deck;

	while ( @deck ) {
		if (@deck < $max) { $max = scalar @deck }
		if (@deck < $min) { $min = scalar @deck }
		unshift @new_deck, splice @deck, 0, _rand( $min, $max );
	}

	return $self->_set_deck( @new_deck );
}


=head4 run

The act of running cards is similar to the overhand shuffle, but instead of in packets the cards are run singly.

	$deck->run( 10 );

When running cards you can choose whether to drop those cards on the top or on the bottom of the deck. By default, the cards are moved to the bottom of the deck.

	$deck->run( 10, 'drop-top' );
	$deck->run( 10, 'drop-bottom' );

Running cards basically reverses their order.

If no number is given then no cards are run.

=cut

sub run {
	my $self            = shift;
	my $number_of_cards = shift || return $self;
	my $where_to_drop   = shift || 'drop-bottom';

	$number_of_cards > 0 or return $self;


	# take cards from top and reverse their order
	my @deck = @{$self->get_deck};
	my @run  = reverse splice @deck, 0, $number_of_cards;

	if ( $where_to_drop eq 'drop-top' ) {
		$self->_set_deck( @run, @deck );
	}
	else { # drop-bottom is the default
		$self->_set_deck( @deck, @run );
	}

	return $self;
}


=head3 Riffle Shuffle

=head4 riffle_shuffle

Riffle shuffle the deck.

	$deck->riffle_shuffle();

In the act of riffle shuffling a deck the deck is cut into two halves of approximately the same size; each half is riffled so that the cards of both halves interlace; these cards usually drop in groups of 1 to 5 cards.

You can also decide where to cut the deck for the shuffle:

	$deck->riffle_shuffle( 'short' );  # closer to the top
	$deck->riffle_shuffle( 'center' ); # near the center
	$deck->riffle_shuffle( 'deep' );   # closer to the bottom
	$deck->riffle_shuffle( 26 );       # precisely under the 26th card

=cut

# TODO: add an option for an out-shuffle
# TODO: add an option to control top or bottom stock
# TODO: when dropping cards, should we favor numbers 2 and 3?
sub riffle_shuffle {
	my $self  = shift;
	my $depth = shift;

	# cut the deck (left pile is the original top half)
	my $cut_depth = _cut_depth( $self->deck_size, $depth );

	my @left_pile  = @{$self->get_deck};
	my @right_pile = splice @left_pile, $cut_depth;

	my @halves = ( \@left_pile, \@right_pile );

	# drop cards from the bottom of each half to the pile (1-5 at a time)
	my @new_pile = ();
	while ( @left_pile and @right_pile ) {
		my $current_half = $halves[0];
		my $number_of_cards = int(rand( min(5, scalar @$current_half) ))+1;

		unshift @new_pile, splice @$current_half, -$number_of_cards;

		@halves = reverse @halves;
	}

	# drop the balance on top and set the deck to be the result
	$self->_set_deck( @left_pile, @right_pile, @new_pile );

	return $self;
}


=head3 Faro shuffle

In a faro shuffle the deck is split in half and the two halves are interlaced perfectly so that each card from one half is inserted in between two cards from the opposite half.

=head4 faro out

Faro out the deck.

	$deck->faro( 'out' );

In a "faro out" the top and bottom cards remain in their original positions.

Considering the positions on the cards from 1 to 52 the result of the faro would be as follows:

	1, 27, 2, 28, 3, 29, 4, 30, 5, 31, 6, 32, 7, 33, ...

=head4 faro in

Faro in the deck.

	$deck->faro( 'in' );

In a "faro in" the top and bottom cards do not remain in their original positions (top card becomes second from the top, bottom card becomes second from the bottom).

Considering the positions on the cards from 1 to 52 the result of the faro would be as follows:

	27, 1, 28, 2, 29, 3, 30, 4, 31, 5, 32, 6, 33, 7, ...

=cut

sub faro {
	my $self = shift;
	my $faro = shift; # by default we're doing a faro out

	# TODO: what happens when the deck is odd-sized?
	my @first_half  = @{$self->get_deck};
	my @second_half = splice @first_half, $self->deck_size / 2;

	$self->_set_deck(
			$faro eq 'in' ?
			zip @second_half, @first_half :
			zip @first_half,  @second_half
		);

	return $self;
}


=head2 Cutting

=head3 cut

Cut the deck.

	$deck->cut();

In a 52 cards deck, this would cut somewhere between 10 and 43 cards.

Cut at a precise position (moving X cards from top to bottom):

	$deck->cut(26);

If you try to cut to a position that doesn't exist nothing will happen (apart from a warning that you tried to cut to a non-existing position, of course).

You can also cut at negative positions, meaning that you're counting from the bottom of the deck and cutting above that card. For instance, to cut the bottom two cards to the top:

	$deck->cut(-2);

Additional ways of cutting:

	$deck->cut( 'short'  ); # on a 52 cards deck, somewhere between 5  and 15 cards
	$deck->cut( 'center' ); # on a 52 cards deck, somewhere between 19 and 31 cards
	$deck->cut( 'deep'   ); # on a 52 cards deck, somewhere between 35 and 45 cards

=head3 cut_below

You can cut below a specific card.

	$deck->cut_below( '9D' );

If the desired card is already on the bottom of the deck nothing will happen.

For more information on how to cut to a specific card please refer to the L<SEE ALSO> section of this documentation.

=head3 cut_above

You can cut above a specific card.

	$deck->cut_above( 'JS' );

If the desired card is already on top of the deck nothing will happen.

For more information on how to cut to a specific card please refer to the L<SEE ALSO> section of this documentation.

=cut

sub cut {
	my $self     = shift;
	my $position = shift;

	if (     defined $position
		 and looks_like_number( $position )
		 and abs($position) > $self->deck_size ) {
				warn "Tried to cut the deck at a non-existing position ($position).\n";
				return $self;
	}

	my $cut_depth = _cut_depth( $self->deck_size, $position );

	my @deck = @{$self->get_deck};
	unshift @deck, splice @deck, $cut_depth;

	return $self->_set_deck( @deck );
}

sub cut_below {
	my $self = shift;
	my $card = shift;

	return $self->cut( $self->find( $card ) );
}

sub cut_above {
	my $self = shift;
	my $card = shift;

	return $self->cut( $self->find( $card ) - 1 );
}

=head3 running_cuts

Cut packets:

    $deck->running_cuts();

To do the procedure twice:

    $deck->running_cuts( 2 );

=cut

sub running_cuts {
	my $self  = shift;
	my $times = shift || 1;

	$self->_packet_transfer( 5, 15 );

	return $times > 1 ?
		   $self->overhand_shuffle( $times - 1 ) :
		   $self
}


=head2 Handling cards

There are a few different methods to track down cards.

=head3 find

Get the position of specific cards:

	my $position = $deck->find( 'AS' ); # find the position of the Ace of Spades

	my @positions = $deck->find( 'AS', 'KH' ); # find the position of two cards

If a card is not present on the deck the position returned will be a 0.

This method can also return the card at a specific position:

	my $card = $deck->find( 3 );

You can also request a card in a negative position (i.e., from the bottom of the deck). To get the second to last card in the deck:

	$deck->find( -2 );

If you're dealing five hands of poker from the top of the deck, for instance, you can easily find which cards will fall on the dealer's hand:

	$deck->find( 5, 10, 15, 20, 25 );

=cut

sub find {
	my $self  = shift;
	my @cards = @_;

	my @results;

	my $deck = $self->get_deck();

	for my $card ( @cards ) {

		push @results, looks_like_number( $card )
					 ? $self->_find_card_by_position( $card )
					 : $self->_find_card_by_name( $card );

	}

	return wantarray ? @results : $results[0];
}

sub _find_card_by_position {
	my $self = shift;
	my $card = shift;

	if ($card) {
		if ($card > 0) { $card--; }
		return $card > $self->deck_size - 1 ?
		        q{} :
		        $self->get_deck->[ $card ];
	}
	else {
		return q{};
	}
}

sub _find_card_by_name {
	my $self = shift;
	my $card = shift;

	my $position = 1 + first_index { $_ eq $card } @{$self->get_deck};

	return $position ? $position : 0;
}


=head3 find_card_before

Finds the card immediately before another card:

	# return the card immediately before the Ace of Spades
	$deck->find_card_before( 'AS' );

If the specified card is on top of the deck you will get the card on the bottom of the deck.

=cut

sub find_card_before {
	my $self = shift;
	my $card = shift;

	my $position = $self->find( $card );

	if ($position == 1) {
		return 0;
	}
	else {
		return $self->find( $position - 1 );
	}
}


=head3 find_card_after

Finds the card immediately after another card:

	# return the card immediately after the King of Hearts
	$deck->find_card_before( 'KH' );

If the specified card is on the bottom of the deck you will get the card on the top of the deck.

=cut

sub find_card_after {
	my $self = shift;
	my $card = shift;

    my $position = 1 + $self->find( $card );
    
    if ( $position > $self->deck_size ) {
        return 0;
    }

	return $self->find( $self->find( $card ) + 1 );
}


=head3 distance

Find the distance between two cards.

To find the distance between the Ace of Spades and the King of Hearts:

	$deck->distance( 'AS', 'KH' );

If the King of Hearts is just after the Ace of Spades, then the result is 1. If it's immediately before, the result is -1.

=cut

sub distance {
	my $self        = shift;
	my $first_card  = shift;
	my $second_card = shift;

	return $self->find( $second_card) - $self->find( $first_card );
}


=head3 put

Put a card on top of the deck. This is a new card, and not a card already on the deck.

	$deck->put( $card );

If the card was already on the deck, you now have a duplicate card.

=cut

sub put {
	my $self = shift;
	my $card = shift;

	$self->_set_deck( $card, @{$self->get_deck} );

	return $self;
}


=head3 deal

Deals a card, removing it from the deck.

	my $removed_card = $deck->deal();

Just as in regular gambling, you can deal cards from other positions:

	# deal the second card from the top
    my $card = $deck->deal( 'second' );

    # deal the second card from the bottom
    my $card = $deck->deal( 'greek' );

    # deal the card from the bottom of the deck
    my $card = $deck->deal( 'bottom' );

For more information on false dealing see the L<SEE ALSO> section.

=cut

sub deal {
	my $self = shift;
	my $deal = shift || 'top';

	# TODO: what if $deal is unknown?
	my $position = $shortcuts->{$deal};

	return $self->remove( $position );
}

=head3 remove

Removes a card from the deck.

	# remove the 4th card from the top
	my $card = $deck->remove( 4 );

=cut

sub remove {
	my $self = shift;
	my $position = shift;

	my @deck = @{$self->get_deck};

    if ($position > 0) { $position--; }

	my $card = splice @deck, $position, 1;

	$self->_set_deck( @deck );
	return $card;
}


=head3 peek

Peek at a position in the deck (this is essentially the same thing as &find()).

	# peek the top card
	my $card = $deck->peek( 1 );

You can also peek the top and bottom card by using an alias:

	# peek the top card
	my $card = $deck->peek( 'top' );

	# peek the bottom card
	my $card = $deck->peek( 'bottom' );

Negative indexes are also supported:

	# peek the second from bottom card
	my $card = $deck->peek( -2 );

=cut

sub peek {
	my $self     = shift;
	my $position = shift || 1;

	if (_is_shortcut( $position )) {
		$position = $shortcuts->{$position};
	}

	return $self->find( $position );
}


=head3 take_random

Remove a random card from the deck.

	my $random_card = $deck->take_random();

You can also specify limits (if you're somehow directing the person taking the card to a particular section of the deck):

	my $random_card = $deck->take_random( 13, 39 );

=cut

sub take_random {
	my $self = shift;

	my $lower_limit = shift || 1;
	my $upper_limit = shift;

	$upper_limit = defined $upper_limit ?
					$upper_limit :
					$self->deck_size;

	return $self->remove( _rand( $lower_limit, $upper_limit ) );
}


# subroutines

sub _set_deck {
	my $self = shift;
	return $self->{'deck'} = [@_];
}

sub _rand {
	my ($lower_limit, $upper_limit) = @_;

	return int($lower_limit + int(rand( $upper_limit - $lower_limit )));
}

sub _cut_depth {
	my $deck_size = shift;
	my $position  = shift;

	if (not defined $position) {
		$position = 'normal';
	}

	if ($position =~ /^short|center|deep|normal$/) {
		my ($lower, $upper) = @{$cut_limits->{ $position }};
		$position = _rand( $deck_size * $lower, $deck_size * $upper );
	}

	return $position;
}

sub _is_shortcut {
	my $shortcut = shift;

	return exists $shortcuts->{$shortcut};
}


=head1 AUTHOR

Jose Castro, C<< <cog at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-cards-shuffletrack at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-Cards-ShuffleTrack>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc Games::Cards::ShuffleTrack


You can also look for information at:

=over 4

=item * Github

L<https://github.com/cog/Games-Cards-ShuffleTrack>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-Cards-ShuffleTrack/>

=back


=head1 SEE ALSO

Recommended reading:

=over 4

=item * The Expert at the Card Table: The Classic Treatise on Card Manipulation, by S. W. Erdnase

=item * The Annotated Erdnase, by Darwin Ortiz

=back


=head1 LICENSE AND COPYRIGHT

Copyright 2016 Jose Castro.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Games::Cards::ShuffleTrack
