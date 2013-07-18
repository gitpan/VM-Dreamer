package VM::Dreamer::IO;

use strict;
use warnings;

use VM::Dreamer::Validate qw{ get_valid_input_regex };

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( get_valid_input_from_user add_input_to_inbox shift_inbox_to_memory add_to_outbox shift_outbox_to_user );

sub get_valid_input_from_user {
    my $machine = shift;
    my $max_tries = 5;

    unless ($machine) {
        die "Please pass the machine href to get_input_from_user";
    }

    my $input;
    my $valid_input = get_valid_input_regex($machine);

    my $greatest_instruction = $machine->{meta}->{greatest}->{instruction};
    my $base                 = $machine->{meta}->{base};
    my $instruction_width    = $machine->{meta}->{width}->{instruction};

    my $tries;
    for ( $tries = 1; $tries <= $max_tries; $tries++ ) {
        print "Please enter a number from 0 to $greatest_instruction in base $base\n";

        $input = readline(*STDIN);
        chomp $input;
        my $length = length($input);

        if (!$length) {
            print "It doesn't look like you entered any characters. ";
            next;
        }
        elsif ( $length > $instruction_width ) {
            print "It looks like you entered too many characters. ";
            next;
        }
        elsif ( $length < $instruction_width ) {
            $input = sprintf "%03s", $input;
        }

        if ( $input !~ $valid_input ) {
            print "Your input doesn't look valid. ";
            next;
        }
        else {
            last;
        }
    }

    if ( $tries > $max_tries ) {
        die "Did not receive valid input after $max_tries attempts. Please restart your program\n";
    }
    else {
        return $input;
    }
}

sub add_input_to_inbox {
    my ( $machine, $input ) = @_;

    push @{$machine->{inbox}}, $input;

    return 0;

    # maybe make this more generic and just call it add_to_inbox

    # how would I abstract the keyboard / display? what would they
    # look like? how would I represent them in this code?
}

sub shift_inbox_to_memory {
    my ( $machine, $address ) = @_;

    $machine->{memory}->{$address} = shift @{$machine->{inbox}};

    return 0;

    # like shift_outbox, maybe make this more generic
    # at some point and have a target of where to shift
    # it
}

sub add_to_outbox {
    my ( $machine, $operand ) = @_;

    push @{$machine->{outbox}}, $machine->{memory}->{$operand};

    return 0;
}

sub shift_outbox_to_user { 
    my $machine = shift;

    print shift ( @{$machine->{outbox}} ) . "\n";

    return 0;

    # maybe, at some point, make this more generic
    # where it is just called shift_outbox and there
    # is a target of where to shift it to...

    # consider stripping leading 0's when outputting
    # to user
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
