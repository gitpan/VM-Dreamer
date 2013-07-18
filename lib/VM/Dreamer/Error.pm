package VM::Dreamer::Error;

use strict;
use warnings;

use VM::Dreamer::Environment qw( get_restrictions get_say_normal );

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw( missing_term invalid_term );

my $restrictions = get_restrictions();
my $say_normal   = get_say_normal();

sub missing_term {
    my $missing_term = shift;

    return "Please include the $say_normal->{$missing_term} in the machine's definition\n";
}

sub invalid_term {
    my ( $term, $value ) = @_;

    my $min = $restrictions->{$term}->{min};
    my $max = $restrictions->{$term}->{max};

    return "The $say_normal->{$term} can only be an integer between $min and $max, but you gave it a value of $value\n";
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
