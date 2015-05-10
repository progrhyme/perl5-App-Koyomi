package App::Koyomi::Job;

use strict;
use warnings;
use 5.010_001;

use version; our $VERSION = 'v0.1.0';

sub new {
    my $class = shift;
    return bless +{}, $class;
}

sub proceed {
    my $self = shift;

    ## dummy output for debugging
    printf "%s proceed.\n", $$;
}

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::Job> - koyomi job

=head1 SYNOPSIS

    use App::Koyomi::Job;
    my $job = App::Koyomi::Job->new;

=head1 DESCRIPTION

This module represents job object.

=head1 METHODS

=over 4

=item B<new>

Construction.

=item B<proceed>

Execute job.

=back

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

