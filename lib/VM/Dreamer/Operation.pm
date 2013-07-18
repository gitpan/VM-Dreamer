package VM::Dreamer::Operation;

use strict;
use warnings;

use VM::Dreamer::Init qw( total_width greatest_digit greatest_number init_counter );

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( get_new_machine add_one_to_counter input_to_mb output_from_mb store load add subtract branch_always branch_if_zero branch_if_positive halt );

sub get_new_machine {
    my ( $base, $op_code_width, $operand_width, $instruction_set ) = @_;

    my $total_width    = total_width( $op_code_width, $operand_width ); 
    my $greatest_digit = greatest_digit($base);

    my %machine = (
        memory      => {},

        inbox       => [],
        outbox      => [],

        n_flag      => 0,
        halt        => 0,

        next_instr  => '',

        instruction_set => $instruction_set,
    );

    @machine{ 'counter', 'accumulator' } = (
        init_counter($operand_width),
        init_counter($total_width)
    );

    $machine{meta} = {
        base  => $base,
        width => {
            op_code     => $op_code_width,
            operand     => $operand_width,
            instruction => $total_width
        },
        greatest => {
            digit       => $greatest_digit,
            op_code     => greatest_number( $base, $op_code_width ),
            operand     => greatest_number( $base, $operand_width),
            instruction => greatest_number( $base, $total_width )
        }
    };

    return \%machine;
}

sub add_one_to_counter {
    my ( $counter, $greatest_digit ) = @_;

    my $i          = 0;
    my $carry_flag = 0;

    my @little_endian_counter = reverse @$counter;

    if ( $little_endian_counter[0] < $greatest_digit ) {
        $little_endian_counter[0]++;
    }
    else {
        while ( $i <= $#little_endian_counter && $little_endian_counter[$i] == $greatest_digit ) {
           $little_endian_counter[$i] = 0;
           $i++;
        }
        if ( $i <= $#little_endian_counter ) {
            $little_endian_counter[$i]++;
        }
    }

    return [ reverse @little_endian_counter ];
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
