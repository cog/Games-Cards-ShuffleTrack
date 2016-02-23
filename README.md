# NAME

Games::Cards::ShuffleTrack - Track cards through shuffles and cuts

# VERSION

Version 0.01

# WARNING

This module is in development stage still. In fact, it's still under specification.

# SYNOPSIS

This module allows you to simulate true and false shuffles and cuts.

    use Games::Cards::ShuffleTrack;

    my $deck = Games::Cards::ShuffleTrack->new();

    $deck->riffle_shuffle();
    $deck->riffle_shuffle();
    $deck->cut();
    print $deck->get_deck();

Or perhaps with more control:

    my $deck = Games::Cards::ShuffleTrack->new();

    $deck->faro_in();
    $deck->cut(26);
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

## new

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

## get\_deck

Returns the deck as a list of strings.

    my @cards = $deck->get_deck();

## Shuffling

### riffle\_shuffle

Riffle shuffle the deck.

    $deck->riffle_shuffle();

In the act of riffle shuffling a deck the deck is cut into two halves of approximately the same size; each half is riffled so that the cards of both halves interlace; these cards usually drop in groups of 1 to 4 cards.

### faro\_in

Faro in the deck.

    $deck->faro_in();

The deck is cut in precisely half and the two halves are interlaced perfectly so that each card from each half is inserted in between two cards from the opposite half.

Considering the positions on the cards from 1 to 52 the result of the faro would be as follows:

    1, 27, 2, 28, 3, 29, 4, 30, 5, 31, 6, 32, 7, 33, ...

In a "faro in" the top and bottom cards remain in their original positions.

### faro\_out

    $deck->faro_out();

Faro out the deck.

## Cutting

### cut

Cut the deck.

    $deck->cut();

Cut at a precise position (moving X cards from top to bottom):

    $deck->cut(26);

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

- RT: CPAN's request tracker (report bugs here)

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-Cards-ShuffleTrack](http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-Cards-ShuffleTrack)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/Games-Cards-ShuffleTrack](http://annocpan.org/dist/Games-Cards-ShuffleTrack)

- CPAN Ratings

    [http://cpanratings.perl.org/d/Games-Cards-ShuffleTrack](http://cpanratings.perl.org/d/Games-Cards-ShuffleTrack)

- Search CPAN

    [http://search.cpan.org/dist/Games-Cards-ShuffleTrack/](http://search.cpan.org/dist/Games-Cards-ShuffleTrack/)

# ACKNOWLEDGEMENTS

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
