package VM::Dreamer::Init;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( init_counter greatest_digit greatest_number total_width );

sub init_counter {
    my $width = shift;

    my @array;

    for ( my $i = 0; $i < $width; $i++ ) {
        push @array, 0;
    }

    return \@array;
}

sub greatest_digit {
    my $base = shift;
    return $base - 1;
}

# should just be able to pass 1 to greatest_number

# also, probably don't need to initialize
# $greatest_number to an empty string

sub greatest_number {
    my ( $base, $width ) = @_;

    unless ( $base && $width ) {
        die "Please pass the machine's base and this number's width\n";
    }

    my $greatest_digit  = greatest_digit($base);
    my $greatest_number = '';

    for ( my $i = 1; $i <= $width; $i++ ) {
        $greatest_number .= $greatest_digit;
    }

    return $greatest_number;
}

sub total_width {
    my $total_width = 0;
 
    foreach my $width (@_) {
        unless( $width =~ /^0$/ || $width =~ /^[1-9]\d*$/ ) {
            die "The widths may only be zero or a positive interger";
        }
        else {
            $total_width += $width;
        }
    }

    return $total_width;
}

1;

# init_counter takes an integer n and return a reference to an array which has n elements, each of which are 0

# greatest digit takes a number n (the base) and returns n - 1

# greatest_number takes two numbers n and r and returns a number p which has r digits, each of which are n

# total width taks two numbers n and r and returns n + r

=pod

=head1 AUTHOR

William Stevenson <dreamer at coders dot coop>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by William Stevenson.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)
 
=cut
