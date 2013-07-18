package VM::Dreamer::Dump;

use strict;
use warnings;

use VM::Dreamer::Util qw( stringify_array );

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw( dump_status dump_memory );

sub dump_status {
    my $machine = shift;

    foreach my $part ( keys %$machine ) {
        my $current_value;
        unless ( $part eq 'memory' ) {
            if ( ref($machine->{$part}) eq "ARRAY" ) {
                $current_value = stringify_array( $machine->{$part} );
            }
            else {
                $current_value = $machine->{$part};
            }
            printf "%-11s\t%3s\n", $part, $current_value;
        }
    }
}

sub dump_memory {
    my $machine = shift;

    foreach my $address ( sort keys %{$machine->{memory}} ) {
        print "$address\t$machine->{memory}->{$address}\n";
    }

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
