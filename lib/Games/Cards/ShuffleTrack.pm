package Games::Cards::ShuffleTrack;

use 5.006;
use strict;
use warnings;

use List::Util qw/min/;
use List::MoreUtils qw/zip first_index/;
use Scalar::Util qw(looks_like_number);

=head1 NAME

Games::Cards::ShuffleTrack - Track cards through shuffles and cuts

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

our $cut_limits = {
	normal	=> [0.19, 0.82], # on a 52 cards deck, cut between 10 and 43 cards
	short 	=> [0.09, 0.28], # on a 52 cards deck, cut between 5  and 15 cards
	center 	=> [0.36, 0.59], # on a 52 cards deck, cut between 19 and 31 cards
	deep 	=> [0.67, 0.86], # on a 52 cards deck, cut between 35 and 45 cards
};


=head1 WARNING

This module is in development stage still. In fact, it's still under specification.

Some of the methods documented here haven't been fully implemented yet (nor has the module been uploaded to CPAN yet).


=head1 SYNOPSIS

This module allows you to simulate true and false shuffles and cuts.

    use Games::Cards::ShuffleTrack;

    my $deck = Games::Cards::ShuffleTrack->new();

    $deck->riffle_shuffle();
    $deck->riffle_shuffle();
    $deck->cut( 'short' );
    print $deck->get_deck();

Or perhaps with more control:

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

=head2 new

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

=cut

our $decks = {
	new_deck_order => [qw/AH 2H 3H 4H 5H 6H 7H 8H 9H 10H JH QH KH
						  AC 2C 3C 4C 5C 6C 7C 8C 9C 10C JC QC KC
						  KD QD JD 10D 9D 8D 7D 6D 5D 4D 3D 2D AD
						  KS QS JS 10S 9S 8S 7S 6S 5S 4S 3S 2S AS/],
};

sub new {
  my ($self) = @_;
  my $deck = $decks->{'new_deck_order'};
  bless {'deck' => $deck}, $self;
}


=head2 get_deck

Returns the deck (a reference to a list of strings).

    my $cards = $deck->get_deck();

=cut

sub get_deck { # TODO: use wantarray to allow for an array to be returned
	my $self = shift;
	return $self->{'deck'};
}


=head2 Shuffling

=head3 riffle_shuffle

Riffle shuffle the deck.

    $deck->riffle_shuffle();

In the act of riffle shuffling a deck the deck is cut into two halves of approximately the same size; each half is riffled so that the cards of both halves interlace; these cards usually drop in groups of 1 to 4 cards.

=cut

# TODO: add an option for an out-shuffle
# TODO: add an option to control top or bottom stock
# TODO: add an option to select where the deck is cut before the shuffle
# TODO: when dropping cards, should we favor numbers 2 and 3?
sub riffle_shuffle {
	my $self = shift;

	# cut the deck (left pile is the original top half)
	my $size = $self->_deck_size;

	# we're cutting somewhere between 18 and 31 cards
	my $cut_depth = _rand( $size * 0.35, $size * 0.60 );

	my @left  = @{$self->get_deck};
	my @right = splice @left, $cut_depth;

	my @halves = ( \@left, \@right );

	# drop cards from the bottom of each half to the pile (1-5 at a time)
	my @new_pile = ();
	while ( @left and @right ) {
		my $current_half = $halves[0];
		my $number_of_cards = int(rand( min(5, scalar @$current_half) ))+1;

		unshift @new_pile, splice @$current_half, -$number_of_cards;

		@halves = reverse @halves;
	}

	# drop the balance on top and set the deck to be the result
	$self->_set_deck( @left, @right, @new_pile );

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
	my @second_half = splice @first_half, $self->_deck_size / 2;

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

Additional ways of cutting:

	$deck->cut( 'short'  ); # on a 52 cards deck, somewhere between 5  and 15 cards
	$deck->cut( 'center' ); # on a 52 cards deck, somewhere between 19 and 31 cards
	$deck->cut( 'deep'   ); # on a 52 cards deck, somewhere between 35 and 45 cards
	$deck->cut_below('AS'); # cutting right above the Ace of Spades
	$deck->cut_above('KH'); # cutting right below the King of Hearts

=cut

sub cut {
	my $self = shift;
	my $position = shift; # TODO: what happens if the position doesn't exist?

	if (not defined $position) {
		$position = 'normal';
	}

	if ($position =~ /^short|center|deep|normal$/) {
		my ($lower, $upper) = @{$cut_limits->{ $position }};
		my $size = $self->_deck_size;
		$position = _rand( $size * $lower, $size * $upper );
	}

	my @deck = @{$self->get_deck};
	unshift @deck, splice @deck, $position;

	$self->_set_deck( @deck );
}


=head3 Finding cards

There are a few different routines to track down cards.

=head4 find

Get the position of specific cards:

    $deck->find( 'AS' ); # find the position of the Ace of Spades

    $deck->find( 'AS', 'KH' ); # find the position of two cards

This method can also return the card at a specific position:

    $deck->find( 3 );

=cut

sub find {
    my $self  = shift;
    my @cards = @_;

    my @results;

    my $deck = $self->get_deck();

    for my $card ( @cards ) {

        if (looks_like_number($card)) {
            # TODO: what happens when the desired position doesn't exist?
            push @results, $deck->[ $card - 1 ];
        }
        else {
            # TODO: what happens when the desired card doesn't exist?
            push @results, 1 + first_index { $_ eq $card } @$deck;
        }

    }

    return wantarray ? @results : $results[0];
}


=head4 find_relative

Find the distance between two cards.

To find the distance between the Ace of Spades and the King of Hearts:

    $deck->find_relative( 'AS', 'KH' );

If the King of Hearts is just after the Ace of Spades, then the result is 1. If it's immediately before, the result is -1.

=cut

sub distance {
    my $self   = shift;
    my $first  = shift;
    my $second = shift;
    
    return $self->find( $second) - $self->find( $first );
}


=head4 find_card_before

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
    	return undef;
    }
    else {
		return $self->find( $position - 1 );
    }
}


=head4 find_card_after

Finds the card immediately after another card:

    # return the card immediately after the King of Hearts
    $deck->find_card_before( 'KH' );

If the specified card is on the bottom of the deck you will get the card on the top of the deck.

=cut

sub find_card_after {
    my $self = shift;
    my $card = shift;

    $self->find( $self->find( $card ) + 1 );
}


# subroutines

sub _set_deck {
	my $self = shift;
	$self->{'deck'} = [@_];
}

sub _deck_size {
	my $self = shift;
	return scalar @{$self->{'deck'}};
}

sub _rand {
	my ($lower_limit, $upper_limit) = @_;

	return int($lower_limit + int(rand( $upper_limit - $lower_limit )));
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

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-Cards-ShuffleTrack>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-Cards-ShuffleTrack>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-Cards-ShuffleTrack>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-Cards-ShuffleTrack/>

=back


=head1 SEE ALSO

Recommended reading:

    * The Expert at the Card Table: The Classic Treatise on Card Manipulation, by S. W. Erdnase

    * The Annotated Erdnase, by Darwin Ortiz


=head1 ACKNOWLEDGEMENTS


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
