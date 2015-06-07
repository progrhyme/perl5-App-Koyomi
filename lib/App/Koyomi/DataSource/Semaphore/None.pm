package App::Koyomi::DataSource::Semaphore::None;

use strict;
use warnings;
use 5.010_001;

use parent qw(App::Koyomi::DataSource::Semaphore);

use version; our $VERSION = 'v0.4.2';

sub instance {
    my $class = shift;
    state $self = bless +{}, $class;
}

sub get_by_job_id    { undef;  }
sub create           { return; }
sub delete_by_job_id { return; }

1;

__END__

=encoding utf-8

=head1 NAME

App::Koyomi::DataSource::Semaphore::None - Fake module of semaphore datasource

=head1 SYNOPSIS

    use App::Koyomi::DataSource::Semaphore::None;
    my $ds = App::Koyomi::DataSource::Semaphore::None->instance(ctx => $ctx);

=head1 DESCRIPTION

Fake implementation as datasource for koyomi semaphore.
This module does nothing about semaphore but works in the code.

=head1 SEE ALSO

L<App::Koyomi::DataSource::Semaphore>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut
