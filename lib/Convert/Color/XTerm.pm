#  You may distribute under the terms of either the GNU General Public License
#  or the Artistic License (the same terms as Perl itself)
#
#  (C) Paul Evans, 2009 -- leonerd@leonerd.org.uk

package Convert::Color::XTerm;

use strict;
use base qw( Convert::Color::RGB8 );

use constant COLOR_SPACE => 'xterm';

use Carp;

our $VERSION = '0.01';

=head1 NAME

C<Convert::Color::XTerm> - indexed colors used by F<xterm>

=head1 SYNOPSIS

Directly:

 use Convert::Color::XTerm;

 my $red = Convert::Color::XTerm->new( 1 );

Via L<Convert::Color>:

 use Convert::Color;

 my $cyan = Convert::Color->new( 'xterm:14' );

=head1 DESCRIPTION

This subclass of L<Convert::Color::RGB8> provides lookup of the colors that 
F<xterm> uses by default. Note that the module is not intelligent enough to
actually parse the XTerm configuration on a machine, nor to query a running
terminal for its actual colors. It simply implements the colors that are
present as defaults in the XTerm source code.

It implements the complete 256-color model in XTerm. This range consists of:

=over 4

=item *

0-7: The basic VGA colors, dark intensity. 7 is a "dark" white, i.e. a light
grey.

=item *

8-15: The basic VGA colors, light intensity. 8 represents a "light" black,
i.e. a dark grey.

=item *

16-231: A 6x6x6 RGB color cube.

=item *

232-255: 24 greyscale ramp.

=back

=cut

my @color;

sub _init_colors
{
   # The first 16 colors are dark and light versions of the basic 8 VGA colors.
   # XTerm itself pulls these from the X11 database, except for light blue.
   # These color names from xterm's charproc.c

   require Convert::Color::X11;

   my @colnames = (qw(
      x11:black   x11:red3     x11:green3 x11:yellow3
      x11:blue2   x11:magenta3 x11:cyan3  x11:gray90
      x11:gray50  x11:red      x11:green  x11:yellow
      rgb8:5C5CFF x11:magenta  x11:cyan   x11:white
   ));

   foreach my $index ( 0 .. $#colnames ) 
   {
      $color[$index] = Convert::Color->new( $colnames[$index] )->as_rgb8;
   }

   # These descriptions and formulae from xterm's 256colres.pl

   # Next is a 6x6x6 color cube, with an attempt at a gamma correction
   foreach my $red ( 0 .. 5 ) {
      foreach my $green ( 0 .. 5 ) {
         foreach my $blue ( 0 .. 5 ) {
            my $index = 16 + ($red*36) + ($green*6) + $blue;

            $color[$index] = Convert::Color::RGB8->new(
               map { $_ ? $_*40 + 55 : 0 } ( $red, $green, $blue )
            );
         }
      }
   }

   # Finally a 24-level greyscale ramp
   foreach my $grey ( 0 .. 23 ) {
      my $index = 232 + $grey;
      my $whiteness = $grey*10 + 8;

      $color[$index] = Convert::Color::RGB8->new( $whiteness, $whiteness, $whiteness );
   }
}

=head1 CONSTRUCTOR

=cut

=head2 $color = Convert::Color::XTerm->new( $index )

Returns a new object to represent the color at that index.

=cut

sub new
{
   my $class = shift;

   if( @_ == 1 ) {
      my $index = $_[0];

      @color or _init_colors;

      $index >= 0 and $index < 256 or
         croak "No such XTerm color at index '$index'";

      return $color[$index];
   }
   else {
      croak "usage: Convert::Color::XTerm->new( INDEX )";
   }
}

# Keep perl happy; keep Britain tidy
1;

__END__

=head1 SEE ALSO

=over 4

=item *

L<Convert::Color> - color space conversions

=back

=head1 AUTHOR

Paul Evans E<lt>leonerd@leonerd.org.ukE<gt>
