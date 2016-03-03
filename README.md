# NAME

Games::Cards::ShuffleTrack - Track cards through shuffles and cuts

# VERSION

Version 0.01\_5

# SYNOPSIS

This module allows you to simulate true and false shuffles and cuts.

        use Games::Cards::ShuffleTrack;

        my $deck = Games::Cards::ShuffleTrack->new();

        $deck->overhand_shuffle( 2 );
        $deck->riffle_shuffle();
        $deck->cut( 'short' );
        $deck->riffle_shuffle();
        print $deck->get_deck();

Or perhaps with more control:

        my $deck = Games::Cards::ShuffleTrack->new();

        $deck->faro_in();
        $deck->cut( 26 );
        print $deck->get_deck();

See the rest of the documentation for more advanced features.

# INSTALLATION

To install this module, run the following commands:

        perl Makefile.PL
        make
        make test
        make install

# DECK REPRESENTATION

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

# SUBROUTINES/METHODS

## Standard methods

### new

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

- new\_deck\_order (the default order)
- fournier

        my $deck = Games::Cards::ShuffleTrack->new( 'fournier' );

### reorder

Reset the deck to its original status. The original is whatever you selected when you created the deck.

        $deck->reorder;

Do bear in mind that by doing so you are replinishing the deck of whatever cards you took out of it.

### get\_deck

Returns the deck (a reference to a list of strings).

        my $cards = $deck->get_deck();

### orientation

Return whether the deck is face up or face down:

        if ( $deck->orientation eq 'down' ) {
                ...
        }

The deck's orientation is either 'up' or 'down'.

### turn

If the deck was face up, it is turned face down; if the deck was face down, it is turned face up.

Turning the deck reverses its order.

        $deck->turn;

## Shuffling

### Overhand Shuffle

#### overhand\_shuffle

In an overhand shuffle the cards are moved from hand to the other in packets, the result being similar to that of running cuts (the difference being that the packets in an overhand shuffle may be smaller than the ones in a running cut sequence).

        $deck->overhand_shuffle;

You can specify how many times you want to go through the deck (which is basically the same thing as calling the method that many times):

        $deck->overhand_shuffle( 2 );

### Hindu Shuffle

#### hindu\_shuffle

In a Hindu shuffle the cards are moved from hand to the other in packets, the result being similar to that of running cuts (the difference being that the packets in an overhand shuffle may be smaller than the ones in a running cut sequence).

        $deck->hindu_shuffle;

You can specify how many times you want to go through the deck (which is basically the same thing as calling the method that many times):

        $deck->hindu_shuffle( 2 );

The Hindu shuffle differs in result from the Overhand shuffle in that the packets are usually thicker; the reason for this is that while in the Overhand shuffle it's the thumb that grabs the cards (and the thumb can easily carry just one or two cards) in the Hindu shuffle it's more than one finger accomplishing this task, grabbing the deck by the sides, which makes it more difficult (hence, rare) to cut just one or two cards.

#### run

The act of running cards is similar to the overhand shuffle, but instead of in packets the cards are run singly.

        $deck->run( 10 );

When running cards you can choose whether to drop those cards on the top or on the bottom of the deck. By default, the cards are moved to the bottom of the deck.

        $deck->run( 10, 'drop-top' );
        $deck->run( 10, 'drop-bottom' );

Running cards basically reverses their order.

If no number is given then no cards are run.

### Riffle Shuffle

#### riffle\_shuffle

Riffle shuffle the deck.

        $deck->riffle_shuffle();

In the act of riffle shuffling a deck the deck is cut into two halves of approximately the same size; each half is riffled so that the cards of both halves interlace; these cards usually drop in groups of 1 to 5 cards.

You can also decide where to cut the deck for the shuffle:

        $deck->riffle_shuffle( 'short' );  # closer to the top
        $deck->riffle_shuffle( 'center' ); # near the center
        $deck->riffle_shuffle( 'deep' );   # closer to the bottom
        $deck->riffle_shuffle( 26 );       # precisely under the 26th card

### Faro shuffle

In a faro shuffle the deck is split in half and the two halves are interlaced perfectly so that each card from one half is inserted in between two cards from the opposite half.

#### faro out

Faro out the deck.

        $deck->faro( 'out' );

In a "faro out" the top and bottom cards remain in their original positions.

Considering the positions on the cards from 1 to 52 the result of the faro would be as follows:

        1, 27, 2, 28, 3, 29, 4, 30, 5, 31, 6, 32, 7, 33, ...

#### faro in

Faro in the deck.

        $deck->faro( 'in' );

In a "faro in" the top and bottom cards do not remain in their original positions (top card becomes second from the top, bottom card becomes second from the bottom).

Considering the positions on the cards from 1 to 52 the result of the faro would be as follows:

        27, 1, 28, 2, 29, 3, 30, 4, 31, 5, 32, 6, 33, 7, ...

## Cutting

### cut

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

### cut\_below

You can cut below a specific card.

        $deck->cut_below( '9D' );

If the desired card is already on the bottom of the deck nothing will happen.

For more information on how to cut to a specific card please refer to the ["SEE ALSO"](#see-also) section of this documentation.

### cut\_above

You can cut above a specific card.

        $deck->cut_above( 'JS' );

If the desired card is already on top of the deck nothing will happen.

For more information on how to cut to a specific card please refer to the ["SEE ALSO"](#see-also) section of this documentation.

### running\_cuts

Cut packets:

    $deck->running_cuts();

To do the procedure twice:

    $deck->running_cuts( 2 );

## Handling cards

There are a few different methods to track down cards.

### find

Get the position of specific cards:

        $deck->find( 'AS' ); # find the position of the Ace of Spades

        $deck->find( 'AS', 'KH' ); # find the position of two cards

This method can also return the card at a specific position:

        $deck->find( 3 );

You can also request a card in a negative position (i.e., from the bottom of the deck). To get the second to last card in the deck:

        $deck->find( -2 );

If you're dealing five hands of poker from the top of the deck, for instance, you can easily find which cards will fall on the dealer's hand:

        $deck->find( 5, 10, 15, 20, 25 );

### find\_card\_before

Finds the card immediately before another card:

        # return the card immediately before the Ace of Spades
        $deck->find_card_before( 'AS' );

If the specified card is on top of the deck you will get the card on the bottom of the deck.

### find\_card\_after

Finds the card immediately after another card:

        # return the card immediately after the King of Hearts
        $deck->find_card_before( 'KH' );

If the specified card is on the bottom of the deck you will get the card on the top of the deck.

### distance

Find the distance between two cards.

To find the distance between the Ace of Spades and the King of Hearts:

        $deck->distance( 'AS', 'KH' );

If the King of Hearts is just after the Ace of Spades, then the result is 1. If it's immediately before, the result is -1.

### put

Put a card on top of the deck. This is a new card, and not a card already on the deck.

        $deck->put( $card );

If the card was already on the deck, you now have a duplicate card.

### deal

Deals a card, removing it from the deck.

        my $removed_card = $deck->deal();

Just as in regular gambling, you can deal cards from other positions:

        # deal the second card from the top
    my $card = $deck->deal( 'second' );

    # deal the second card from the bottom
    my $card = $deck->deal( 'greek' );

    # deal the card from the bottom of the deck
    my $card = $deck->deal( 'bottom' );

For more information on false dealing see the ["SEE ALSO"](#see-also) section.

### remove

Removes a card from the deck.

        # remove the 4th card from the top
        my $card = $deck->remove( 4 );

### peek

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

### take\_random

Remove a random card from the deck.

        my $random_card = $deck->take_random();

You can also specify limits (if you're somehow directing the person taking the card to a particular section of the deck):

        my $random_card = $deck->take_random( 13, 39 );

# AUTHOR

Jose Castro, `<cog at cpan.org>`

# BUGS

Please report any bugs or feature requests to `bug-games-cards-shuffletrack at rt.cpan.org`, or through
the web interface at [http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-Cards-ShuffleTrack](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-Cards-ShuffleTrack).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

        perldoc Games::Cards::ShuffleTrack

You can also look for information at:

- Github

    [https://github.com/cog/Games-Cards-ShuffleTrack](https://github.com/cog/Games-Cards-ShuffleTrack)

- Search CPAN

    [http://search.cpan.org/dist/Games-Cards-ShuffleTrack/](http://search.cpan.org/dist/Games-Cards-ShuffleTrack/)

# SEE ALSO

Recommended reading:

- The Expert at the Card Table: The Classic Treatise on Card Manipulation, by S. W. Erdnase
- The Annotated Erdnase, by Darwin Ortiz

# LICENSE AND COPYRIGHT

Copyright 2016 Jose Castro.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic_license_2_0)

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
