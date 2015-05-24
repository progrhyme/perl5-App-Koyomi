package App::Koyomi::Worker;

use strict;
use warnings;
use 5.010_001;
use Class::Accessor::Lite (
    ro => [qw/ctx config schedule/],
);
use DateTime;
use Time::Piece;

use App::Koyomi::Context;
use App::Koyomi::Schedule;

use version; our $VERSION = 'v0.1.0';

sub new {
    my $class = shift;
    my @args  = @_;
    my $ctx   = App::Koyomi::Context->instance;
    return bless +{
        ctx      => $ctx,
        config   => $ctx->config,
        schedule => App::Koyomi::Schedule->instance(ctx => $ctx),
    }, $class;
}

sub run {
    my $self = shift;

    my $now = $self->_now;

    ## main loop
    while (1) {
        $self->schedule->update($now);
        my @jobs = $self->schedule->get_jobs($now);

        for my $job (@jobs) {
            my $pid = fork();
            if ($pid == 0) { # child
                $job->proceed($now);
                exit;
            } elsif ($pid) { # parent
                # nothing to do
            } else {
                die "Can't fork: $!";
            }
        }

        my $prev_epoch = $now->epoch;
        $now->add(
            minutes => $self->config->{worker}{interval_minutes}
        )->truncate(to => 'minute');

        # Sleep to next tick
        my $min_seconds = $self->config->{worker}{minimum_interval_seconds};
        my $seconds = $now->epoch - $prev_epoch;
        if ($seconds < $min_seconds) {
            my $dsec = $min_seconds - $seconds;
            $seconds = $min_seconds;
            $now->add(seconds => $dsec);
        }
        if ($self->ctx->is_debug) {
            $seconds = $self->config->{debug}{worker}{sleep_seconds} // $seconds;
        }
        sleep($seconds);
    }
}

sub _now {
    my $self = shift;

    my $debug_datestr = sub {
        return unless $self->ctx->is_debug;
        return $self->config->{debug}{now} // undef;
    }->();
    if ($debug_datestr) {
        my $t = Time::Piece->strptime($debug_datestr, '%Y-%m-%dT%H:%M');
        return DateTime->from_epoch(epoch => $t->epoch);
    }
    return $self->ctx->now;
}

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::Worker> - koyomi worker module

=head1 SYNOPSIS

    use App::Koyomi::Worker;
    App::Koyomi::Worker->new(@ARGV)->run;

=head1 DESCRIPTION

This module is ...

=head1 METHODS

=over 4

=item B<new>

Construction.

=item B<run>

Runs worker.

=back

=head1 SEE ALSO

L<script/koyomi>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

