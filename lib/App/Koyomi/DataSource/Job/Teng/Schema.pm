package App::Koyomi::DataSource::Job::Teng::Schema;

use strict;
use warnings;
use 5.010_001;
use Teng::Schema::Declare;

use version; our $VERSION = 'v0.1.0';

table {
    name    'jobs';
    pk      'id';
    columns qw/id user command memo year month day hour minute weekday created_on updated_at/;
};

1;
__END__

=encoding utf-8

=head1 NAME

App::Koyomi::DataSource::Job::Teng::Schema - Teng::Schema interface as schedule datasource

=head1 SYNOPSIS

    use App::Koyomi::DataSource::Job::Teng::Schema;
    my $ds = App::Koyomi::DataSource::Job::Teng::Schema->instance;

=head1 DESCRIPTION

Teng::Schema interface as datasource for koyomi job schedule.

=head1 SEE ALSO

L<App::Koyomi::DataSource::Job>,
L<Teng::Schema>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

