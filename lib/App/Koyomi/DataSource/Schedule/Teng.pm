package App::Koyomi::DataSource::Schedule::Teng;

use strict;
use warnings;
use 5.010_001;

use parent qw(App::Koyomi::DataSource::Schedule);

use version; our $VERSION = 'v0.1.0';

sub instance {
    my $class = shift;
    return bless +{}, $class;
}

1;
__END__

=encoding utf-8

=head1 NAME

App::Koyomi::DataSource::Schedule::Teng - Teng interface as schedule datasource

=head1 SYNOPSIS

    use App::Koyomi::DataSource::Schedule::Teng;
    my $ds = App::Koyomi::DataSource::Schedule::Teng->instance;

=head1 DESCRIPTION

Teng interface as datasource for koyomi job schedule.

=head1 SEE ALSO

L<App::Koyomi::DataSource::Schedule>,
L<Teng>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

