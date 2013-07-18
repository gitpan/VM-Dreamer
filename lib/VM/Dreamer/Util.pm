package VM::Dreamer::Util;

use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( stringify_array arrayify_string parse_program_line parse_next_instruction add_two_arrays subtract_two_arrays );

sub stringify_array {
   my $aref = shift;
   return join( '', @$aref );
}

sub arrayify_string {
    my $string = shift;
    return [ split //, $string ];
}

sub parse_program_line {
    my $line = shift;
    return split /\t/, $line;
}

sub parse_next_instruction {
    my $machine = shift;

    my ( $op_code, $operand );

    my $little_endian_instruction = reverse $machine->{next_instruction};

    for ( my $i = 0; $i < $machine->{meta}->{width}->{op_code}; $i++ ) {
        my $digit = chop $little_endian_instruction;
        $op_code .= $digit;
    }
 
    if( length $little_endian_instruction != $machine->{meta}->{width}->{operand} ) {
        die "Operand was not of expected width in instruction: $machine->{next_instruction}"; # want to give programmer better feedback here
    }
    else {
        $operand = reverse $little_endian_instruction;
    }

    return $op_code, $operand;
}

sub add_two_arrays {
    my ( $augend, $addend, $greatest_digit ) = @_;

    my @little_auggie = reverse @$augend;
    my @little_addie  = reverse @$addend;

    if ( @little_addie != @little_auggie ) {
        die "The augend and addend are not of the same length: " . stringify_array( $augend ) . " " . stringify_array( $addend ) . "\n";
    }

    # When I want to store a "stringteger" I think of it from left to
    # right, but when I want to operate on one, it's easier for me to
    # do so on its mirror image 

    for ( my $i = 0; $i <= $#little_auggie; $i++ ) {
        my $k = $i + 1;

        for ( my $j = $little_addie[$i] - 1; $j >= 0; $j-- ) {

            if ( $little_auggie[$i] < $greatest_digit ) {
	        $little_auggie[$i]++;
            }
            else {
		$little_auggie[$i] = $j;

		while ( $k <= $#little_auggie && $little_auggie[$k] == $greatest_digit ) {
		    $little_auggie[$k] = 0;
		    $k++;
                }

	        if ( $k <= $#little_auggie ) {
	            $little_auggie[$k]++;
		}
	
	        last;	
	    }
	}
    }

    return [ reverse @little_auggie ];
}

sub subtract_two_arrays {
    my ( $minuend, $subtrahend, $greatest_digit ) = @_;

    my $n_flag = 0;

    my @little_minnie = reverse @$minuend;
    my @little_subbie = reverse @$subtrahend;

    if ( scalar @little_minnie != scalar @little_subbie ) {
        die "The minuend and subtrahend are not of the same length: " . stringify_array($minuend) . " " . stringify_array($subtrahend) . "\n";
    }

    SUBTR_LOOP:
    for ( my $i = 0; $i <= $#little_minnie; $i++ ) {
	for ( my $j = $little_subbie[$i] - 1; $j >= 0; $j-- ) {
	    if ( $little_minnie[$i] > 0 ) {
	        $little_minnie[$i]--;
	    }
	    else {
	        my $k = $i + 1;

		while ( $k <= $#little_minnie && $little_minnie[$k] == 0 ) {
                    $little_minnie[$k] = $greatest_digit;
		    $k++;
                }

		if ( $k > $#little_minnie ) {
		    $n_flag = 1;
		    last SUBTR_LOOP;
		}
		else {
                    $little_minnie[$k]--;
                    $little_minnie[$i] = $greatest_digit;
		}
	    }
	}
    }

    return [ reverse @little_minnie ], $n_flag ;
}

1;

=pod

=head1 AUTHOR

William Stevenson <dreamer at coders dot coop>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by William Stevenson.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)
 
=cut
