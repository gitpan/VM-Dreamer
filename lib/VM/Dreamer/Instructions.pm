package VM::Dreamer::Instructions;

use strict;
use warnings;

use VM::Dreamer::IO qw( get_valid_input_from_user add_input_to_inbox shift_inbox_to_memory add_to_outbox shift_outbox_to_user );
use VM::Dreamer::Util qw( arrayify_string stringify_array add_two_arrays subtract_two_arrays );

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( input_to_mb output_from_mb store load add subtract branch_always branch_if_zero branch_if_positive halt );

sub input_to_mb {
    my ( $machine, $operand ) = @_;

    my $input = get_valid_input_from_user($machine);

    add_input_to_inbox( $machine, $input );

    shift_inbox_to_memory( $machine, $operand );

    return 0;
}

sub output_from_mb {
    my ( $machine, $operand ) = @_;

    add_to_outbox( $machine, $operand );

    shift_outbox_to_user($machine);

    return 0;
}

sub store {
    my ( $machine, $operand ) = @_;

    $machine->{memory}->{$operand} = stringify_array( $machine->{accumulator} );

    return 0;

    # Assuming that operand is a valid mailbox value
}

sub load {
    my ( $machine, $operand ) = @_;

    if ( $machine->{memory}->{$operand} ) {
        $machine->{accumulator} = arrayify_string( $machine->{memory}->{$operand} );
        $machine->{n_flag}      = 0;
    }
    else {
        die "No value stored at address $operand to load onto the accumulator\n";
    }

    return 0;
}

sub add {
    my ( $machine, $operand ) = @_;

    my $augend = $machine->{accumulator};
    my $addend = arrayify_string( $machine->{memory}->{$operand} );

    $machine->{accumulator} = add_two_arrays( $augend, $addend, $machine->{meta}->{greatest}->{digit} );

    return 0;
}

sub subtract {
    my ( $machine, $operand ) = @_;

    my $minuend    = $machine->{accumulator};
    my $subtrahend = arrayify_string( $machine->{memory}->{$operand} );

    ( $machine->{accumulator}, $machine->{n_flag} ) = subtract_two_arrays( $minuend, $subtrahend, $machine->{meta}->{greatest}->{digit} );

    return 0;
}

sub branch_always {
    my ( $machine, $operand ) = @_;

    $machine->{counter} = arrayify_string($operand);

    return 0;
}

sub branch_if_zero {
    my ( $machine, $operand ) = @_;

    my $accumulator = stringify_array( $machine->{accumulator} );

    if ( $accumulator == 0 ) {
        $machine->{counter} = arrayify_string($operand);
    }

    # in Perl, a string of zeros is treated as the number 0 when used
    # in numeric context, e.g. '000' == 0 would be true

    return 0;
}

sub branch_if_negative {
    my ( $machine, $operand ) = @_;

    if ( $machine->{n_flag} == 1 ) {
        $machine->{counter} = arrayify_string($operand);
    }

    return 0;
}

sub branch_if_positive {
    my ( $machine, $operand ) = @_;

    my $accumulator = stringify_array( $machine->{counter} );

    if ( $accumulator > 0 && $machine->{n_flag} == 0 ) {
        $machine->{counter} = arrayify_string($operand);
    }

    # just like above, in Perl, a sting of numbers is treated like
    # the number itself and padded zeros are ignored when used
    # in numeric context

    # e.g. '0050' > 0 would be true, so there is no need, in this
    # language, to strip them

    return 0;
}

sub halt {
    my $machine = shift;

    $machine->{halt} = 1;

    return 0;
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
