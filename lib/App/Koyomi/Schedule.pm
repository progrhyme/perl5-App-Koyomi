package App::Koyomi::Schedule;

use strict;
use warnings;
use 5.010_001;
use Smart::Args;

our $VERSION = '0.01';

my $SCHEDULE;

sub get {
    args(
        my $class,
        my $ctx => 'App::Koyomi::Context',
    );
    $SCHEDULE //= sub {
        return bless +{}, $class;
    }->();
    return $SCHEDULE;
}

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::Schedule> - koyomi job schedule

=head1 SYNOPSIS

    use App::Koyomi::Schedule;
    my $schedule = App::Koyomi::Schedule->get;

=head1 DESCRIPTION

This module represents Singleton schedule object.

=head1 METHODS

=over 4

=item B<get>

Fetch schedule singleton.

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

