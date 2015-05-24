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

    ## main loop
    while (1) {
        my $now = _now();
        $self->schedule->update($now);
        my @jobs = $self->schedule->get_jobs($now);
        for my $job (@jobs) {
            my $pid = fork();
            if ($pid == 0) { # child
                $job->proceed;
                exit;
            } elsif ($pid) { # parent
                # nothing to do
            } else {
                die "Can't fork: $!";
            }
        }
        sleep($self->config->{worker}{sleep_seconds});
    }
}

sub _now {
    if (my $datestr = $ENV{KOYOMI_DEBUG_NOW}) {
        my $t = Time::Piece->strptime($datestr, '%Y-%m-%dT%H:%M');
        return DateTime->from_epoch(epoch => $t->epoch);
    }
    return DateTime->now;
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

