package App::Koyomi::DataSource::Semaphore::Teng;

use strict;
use warnings;
use 5.010_001;
use Class::Accessor::Lite (
    ro => [qw/teng/],
);
use Smart::Args;

use App::Koyomi::DataSource::Semaphore::Teng::Data;
use App::Koyomi::DataSource::Semaphore::Teng::Object;
use App::Koyomi::DataSource::Semaphore::Teng::Schema;

use parent qw(App::Koyomi::DataSource::Semaphore);

use version; our $VERSION = 'v0.4.0';

my $DATASOURCE;

sub instance {
    args(
        my $class,
        my $ctx => 'App::Koyomi::Context',
    );
    $DATASOURCE //= sub {
        my $connector
            = $ctx->config->{datasource}{connector}{semaphore}
            // $ctx->config->{datasource}{connector};
        my $teng = App::Koyomi::DataSource::Semaphore::Teng::Object->new(
            connect_info => [
                $connector->{dsn}, $connector->{user}, $connector->{password},
                +{ RaiseError => 1, PrintError => 0, AutoCommit => 1 },
            ],
            schema => App::Koyomi::DataSource::Semaphore::Teng::Schema->instance,
        );
        my %obj = (teng => $teng);
        return bless \%obj, $class;
    }->();
    return $DATASOURCE;
}

sub get_by_job_id {
    args(
        my $self,
        my $job_id => 'Int',
        my $ctx    => 'App::Koyomi::Context',
    );
    my $row = $self->teng->single('semaphores', +{job_id => $job_id});
    return unless $row;
    return App::Koyomi::DataSource::Semaphore::Teng::Data->new(
        row => $row,
        ctx => $ctx,
    );
}

1;

__END__

=encoding utf-8

=head1 NAME

App::Koyomi::DataSource::Semaphore::Teng - Teng interface as schedule datasource

=head1 SYNOPSIS

    use App::Koyomi::DataSource::Semaphore::Teng;
    my $ds = App::Koyomi::DataSource::Semaphore::Teng->instance(ctx => $ctx);

=head1 DESCRIPTION

Teng interface as datasource for koyomi semaphore schedule.

=head1 SEE ALSO

L<App::Koyomi::DataSource::Semaphore>,
L<Teng>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

