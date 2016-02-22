package Games::Cards::ShuffleTrack;

use 5.006;
use strict;
use warnings;

=head1 NAME

Games::Cards::ShuffleTrack - Track cards through shuffles and cuts

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 WARNING

This module is in development stage still. In fact, it's still under specification.


=head1 SYNOPSIS

This module allows you to simulate true and false shuffles and cuts.

    use Games::Cards::ShuffleTrack;

    my $deck = Games::Cards::ShuffleTrack->new();

    $deck->riffle_shuffle();
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

Returns the deck as a list of strings.

=cut

sub get_deck {
	my $self = shift;
	return $self->{'deck'};
}

=head2 riffle_shuffle

Riffle shuffle the deck.

=cut

sub riffle_shuffle {
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
