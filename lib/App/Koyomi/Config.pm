package App::Koyomi::Config;

use strict;
use warnings;
use 5.010_001;

our $VERSION = '0.01';

my $CONFIG;

sub get {
    my $class = shift;
    $CONFIG //= sub {
        return bless +{}, $class;
    }->();
    return $CONFIG;
}

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::Config> - koyomi config

=head1 SYNOPSIS

    use App::Koyomi::Config;
    my $config = App::Koyomi::Config->get;

=head1 DESCRIPTION

This module represents Singleton config object.

=head1 METHODS

=over 4

=item B<get>

Fetch schedule singleton.

=back

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

