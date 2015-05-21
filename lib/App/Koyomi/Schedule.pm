package App::Koyomi::Schedule;

use strict;
use warnings;
use 5.010_001;
use Class::Accessor::Lite (
    ro => [qw/ds_job jobs/],
);
use DateTime;
use Log::Minimal env_debug => 'KOYOMI_DEBUG';
use Smart::Args;

use App::Koyomi::Job;

use version; our $VERSION = 'v0.1.0';

my $SCHEDULE;

sub instance {
    args(
        my $class,
        my $ctx => 'App::Koyomi::Context',
    );
    $SCHEDULE //= sub {
        my %obj = (
            ds_job => $ctx->datasource_job,
            jobs   => undef,
        );
        return bless \%obj, $class;
    }->();
    return $SCHEDULE;
}

sub update {
    my $self = shift;
    debugf('update jobs');
    $self->_update_jobs;
    debugf(ddf($self->jobs));
}

sub _update_jobs {
    my $self = shift;
    $self->{jobs} = App::Koyomi::Job->get_jobs(ds => $self->ds_job);
}

sub get_jobs {
    my $self = shift;
    my $now  = shift // DateTime->now;
    return ( App::Koyomi::Job->new );
}

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::Schedule> - koyomi job schedule

=head1 SYNOPSIS

    use App::Koyomi::Schedule;
    my $schedule = App::Koyomi::Schedule->instance;

=head1 DESCRIPTION

This module represents Singleton schedule object.

=head1 METHODS

=over 4

=item B<instance>

Fetch schedule singleton.

=item B<update>

Update schedule if needed.

=item B<get_jobs> (DateTime)

Fetch jobs to execute at that time.

=back

=head1 SEE ALSO

L<App::Koyomi::Worker>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

