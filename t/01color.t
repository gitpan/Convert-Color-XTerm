#!/usr/bin/perl

use Convert::Color::XTerm;

use Test::More tests => 8;

my $black = Convert::Color::XTerm->new( 0 );

is( $black->red,   0, 'black red' );
is( $black->green, 0, 'black green' );
is( $black->blue,  0, 'black blue' );

is( $black->index, 0, 'black index' );

my $green = Convert::Color::XTerm->new( 2 );

is( $green->red,     0, 'green red' );
is( $green->green, 205, 'green green' );
is( $green->blue,    0, 'green blue' );

is( $green->index, 2, 'green index' );
