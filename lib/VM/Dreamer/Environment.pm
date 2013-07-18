package VM::Dreamer::Environment;

use strict;
use warnings;

require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw( get_restrictions get_say_normal );

my $restrictions = {
    base => {
        min => 2,
        max => 10
    },

    op_code_width => {
        min => 1,
        max => 8
    },

    operand_width => {
        min => 1,
        max => 248
    }
};

our $say_normal = {
    base          => "base",
    op_code_width => "op-code's width",
    operand_width => "operand's width"
};

sub get_restrictions {
    return $restrictions;
}

sub get_say_normal {
    return $say_normal;
}

1;

=pod

=head1 Overview

VM::Dreamer::Environment provides a place for environmental variables. These can restrict the machines which are defined and also provide...

=head2

get_restrictions takes no arguments and just returns a hash ref. eference to a hash whose keys are the boundaries for

=head1 AUTHOR

William Stevenson <dreamer at coders dot coop>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by William Stevenson.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)
 
=cut
