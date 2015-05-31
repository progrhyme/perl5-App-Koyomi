package App::Koyomi::CLI;

use strict;
use warnings;
use 5.010_001;
use Class::Accessor::Lite (
    ro => [qw/ctx/],
);
use Getopt::Long qw(:config posix_default no_ignore_case no_ignore_case_always);
use Log::Minimal env_debug => 'KOYOMI_LOG_DEBUG';

use App::Koyomi::Context;

use version; our $VERSION = 'v0.2.0';

my @CLI_METHODS = qw/add list modify delete/;

sub new {
    my $class = shift;
    my %args  = @_;
    my $ctx   = App::Koyomi::Context->instance;
    return bless +{ ctx => $ctx }, $class;
}

sub parse_args {
    my $class  = shift;
    my $method = shift or return;
    my @args   = @_;

    unless (grep { $_ eq $method } @CLI_METHODS) {
        warnf('No such method:%s', $method);
        return;
    }

    Getopt::Long::GetOptionsFromArray(\@args, \my %opt);
    return ($method, \%opt);
}

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::CLI> - Koyomi CLI module

=head1 SYNOPSIS

    use App::Koyomi::CLI;
    my ($method, $props) = App::Koyomi::CLI->parse_args(@ARGV);
    App::Koyomi::CLI->new(%$props)->$method;

=head1 DESCRIPTION

I<Koyomi> CLI module.

=head1 METHODS

=over 4

=item B<new>

Construction.

=item B<add>

Create a job schedule.
NOT implemented yet.

=item B<list>

List scheduled jobs.
NOT implemented yet.

=item B<modify>

Modify a job schedule.
NOT implemented yet.

=item B<delete>

Delete a job schedule.
NOT implemented yet.

=back

=head1 SEE ALSO

L<koyomi-cli>,
L<App::Koyomi::Context>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut
