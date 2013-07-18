package VM::Dreamer::Validate;

use strict;
use warnings;

use VM::Dreamer::Environment qw( get_restrictions );
use VM::Dreamer::Error qw( missing_term invalid_term );

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( validate_definition build_valid_line_regex get_valid_input_regex );

our $restrictions = get_restrictions();

sub validate_definition {
    my $machine_definition = shift;

    foreach my $term ( qw( base op_code_width operand_width ) ) { 
        unless ( defined $machine_definition->{$term} ) {
            die missing_term($term);
        }
        unless ( validate_term( $term, $machine_definition->{$term} ) ) {
            die invalid_term( $term, $machine_definition->{$term} );
        }
    }

    return 1;
}

sub validate_term {
    my( $term, $value ) = @_;

    if( $value !~ /^[1-9]\d*$/ ) {
        return 0;
    }
    elsif( $value < $restrictions->{$term}->{min} ||
           $value > $restrictions->{$term}->{max} ) {
        return 0;
    }
    else {
        return 1;
    }
}

sub build_valid_line_regex {
    my $machine = shift;

    my( $greatest_digit, $operand_width, $instruction_width ) = (
        $machine->{meta}->{greatest}->{digit},
        $machine->{meta}->{width}->{operand},
        $machine->{meta}->{width}->{instruction}
    );

    # consider replacing above with a slice

    if ( ! defined $greatest_digit ) {
        die "Please pass the machine's greatest digit to build_valid_line_regex\n";
    }
    elsif ( ! defined $operand_width ) {
        die "Please pass the machine's op code width to build_valid_line_regex\n";
    }
    elsif( ! defined $instruction_width ) {
        die "Please pass the machine's instruction width to build_valid_line_regex\n";
    }

    return qr/^[0-$greatest_digit]{$operand_width}\t[0-$greatest_digit]{$instruction_width}$/;

}

sub get_valid_input_regex {
    my $machine = shift;

    my $greatest_digit    = $machine->{meta}->{greatest}->{digit};
    my $instruction_width = $machine->{meta}->{width}->{instruction};

    return qr/^[0-$greatest_digit]{$instruction_width}$/;
}


# sub validate_program_line {
#     my $line = shift;
#     my $meta = shift;
# 
#     my $greatest_digit  = $meta->{greatest_digit};
#     my $operand_width   = $meta->{operand_width};
#     my $total_width     = $meta->{total_width};
# 
#     my $regex = qr/^[0-$greatest_digit]{$operand_width}\t[0-$greatest_digit]{$total_width}$/; 
# 
#     if ( $line =~ $regex ) {
#         return;
#     }
#     else {
#         die "Line was not properly formatted: $line\n";
#     }
# }

1;

=pod

=head1 AUTHOR

William Stevenson <dreamer at coders dot coop>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by William Stevenson.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)
 
=cut
