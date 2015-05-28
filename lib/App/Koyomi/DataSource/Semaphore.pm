package App::Koyomi::DataSource::Semaphore;

use strict;
use warnings;
use 5.010_001;
use Carp qw(croak);

use version; our $VERSION = 'v0.1.3';

sub instance { croak 'Must implement in child class!'; }

sub get_by_job_id { croak 'Must implement in child class!'; }

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::DataSource::Semaphore> - Abstract datasource class for semaphore entity

=head1 SYNOPSIS

    use parent qw(App::Koyomi::DataSource::Semaphore);

    # Your implementation goes below
    sub instance { ... }

=head1 DESCRIPTION

Abstract datasource class for koyomi semaphore entity.

=head1 METHODS

=over 4

=item B<instance>

Construct datasource object.
Probably it's singleton.

=back

=head1 SEE ALSO

L<App::Koyomi::Job>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

