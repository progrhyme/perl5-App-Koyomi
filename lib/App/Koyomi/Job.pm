package App::Koyomi::Job;

use strict;
use warnings;
use 5.010_001;
use Class::Accessor::Lite (
    ro => [qw/data/],
);
use IPC::Cmd;
use Log::Minimal env_debug => 'KOYOMI_LOG_DEBUG';
use Smart::Args;

use version; our $VERSION = 'v0.1.0';

our @FIELDS = qw/
id user command memo year month day hour minute weekday created_on updated_at
/;

{
    no strict 'refs';
    for my $field (@FIELDS) {
        *{ __PACKAGE__ . '::' . $field } = sub {
            my $self = shift;
            $self->data->$field;
        };
    }
}

sub new {
    my $class = shift;
    return bless +{}, $class;
}

sub get_jobs {
    args(
        my $class,
        my $ds => 'App::Koyomi::DataSource::Job',
    );
    my @data = $ds->gets;
    my @jobs;
    for my $d (@data) {
        my $job = bless +{ data => $d }, $class;
        debugf(
            q/(id,user,command,time) = (%d,%s,"%s","%s %s %s %s %s")/,
            $job->id, $job->user || '<NULL>', $job->command, $job->minute,
            $job->hour, $job->day, $job->month, $job->weekday
        );
        push(@jobs, $job);
    }
    return \@jobs;
}

sub proceed {
    my $self = shift;

    my $header = sprintf(q/%d %d/, $$, $self->id);
    my $user = $self->user || $ENV{USER} || $ENV{LOGNAME} || getlogin() || getpwuid($<) || '<Undefined>';
    infof(q/%s USER=%s COMMAND="%s"/, $header, $user, $self->command);
    my ($ok, $err, undef, $stdout, $stderr) = IPC::Cmd::run(command => $self->command);
    if ($ok) {
        infof(q/%s Succeeded./, $header);
        if (scalar(@$stdout)) {
            infof(q/%s ===== STDOUT =====/, $header);
            infof(q/%s %s/, $header, $_) for @$stdout;
        }
        if (scalar(@$stderr)) {
            infof(q/%s ===== STDERR =====/, $header);
            infof(q/%s %s/, $header, $_) for @$stderr;
        }
    } else {
        critf(q/%d Failed!!/, $self->id);
        critf(q/%d ERROR=%s/, $self->id, $err);
        if (scalar(@$stdout)) {
            critf(q/%d ===== STDOUT =====/, $self->id);
            critf(q/%d %s/, $self->id, $_) for @$stdout;
        }
        if (scalar(@$stderr)) {
            critf(q/%d ===== STDERR =====/, $self->id);
            critf(q/%d %s/, $self->id, $_) for @$stderr;
        }
    }
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

