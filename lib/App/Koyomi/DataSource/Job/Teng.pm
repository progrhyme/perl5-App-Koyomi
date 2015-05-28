package App::Koyomi::DataSource::Job::Teng;

use strict;
use warnings;
use 5.010_001;
use Class::Accessor::Lite (
    ro => [qw/teng/],
);
use Smart::Args;

use App::Koyomi::DataSource::Job::Teng::Object;
use App::Koyomi::DataSource::Job::Teng::Schema;

use parent qw(App::Koyomi::DataSource::Job);

use version; our $VERSION = 'v0.1.1';

my $JOB;

sub instance {
    args(
        my $class,
        my $ctx => 'App::Koyomi::Context',
    );
    $JOB //= sub {
        my $connector
            = $ctx->config->{datasource}{connector}{job}
            // $ctx->config->{datasource}{connector};
        my $teng = App::Koyomi::DataSource::Job::Teng::Object->new(
            connect_info => [
                $connector->{dsn}, $connector->{user}, $connector->{password},
                +{ RaiseError => 1, PrintError => 0, AutoCommit => 1 },
            ],
            schema => App::Koyomi::DataSource::Job::Teng::Schema->instance,
        );
        my %obj = (teng => $teng);
        return bless \%obj, $class;
    }->();
    return $JOB;
}

sub gets {
    my $self = shift;
    my $itr = $self->teng->search('jobs' => +{});
    return $itr->all;
}

1;

__END__

=encoding utf-8

=head1 NAME

App::Koyomi::DataSource::Job::Teng - Teng interface as schedule datasource

=head1 SYNOPSIS

    use App::Koyomi::DataSource::Job::Teng;
    my $ds = App::Koyomi::DataSource::Job::Teng->instance(ctx => $ctx);
    my @jobs = $ds->gets

=head1 DESCRIPTION

Teng interface as datasource for koyomi job schedule.

=head1 SEE ALSO

L<App::Koyomi::DataSource::Job>,
L<Teng>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

