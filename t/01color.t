#!/usr/bin/perl

use Convert::Color::XTerm;

use Test::More tests => 6;

my $black = Convert::Color::XTerm->new( 0 );

is( $black->red,   0, 'black red' );
is( $black->green, 0, 'black green' );
is( $black->blue,  0, 'black blue' );

my $green = Convert::Color::XTerm->new( 2 );

is( $green->red,     0, 'green red' );
is( $green->green, 205, 'green green' );
is( $green->blue,    0, 'green blue' );
