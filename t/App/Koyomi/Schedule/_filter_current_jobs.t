use strict;
use warnings;
use Test::Base;
use DateTime;
use Time::Piece;

use App::Koyomi::Schedule;
use Test::Koyomi::Job;

plan tests => 1 * blocks;

filters {
    job_date    => [qw/chomp/],
    executed_on => [qw/chomp/],
    match       => [qw/eval/],
};

run {
    my $block = shift;

    my @job_date = split(/ /, $block->job_date);
    my $job = Test::Koyomi::Job->mock(@job_date);

    my $now_t = Time::Piece->strptime($block->executed_on, '%Y-%m-%dT%H:%M');
    my $now = DateTime->from_epoch(epoch => $now_t->epoch);

    my @jobs = App::Koyomi::Schedule::_filter_current_jobs([$job], $now);

    diag sprintf q{Job: '%s/%s/%s %s:%s (%s)', Now: '%s'}, @job_date, $block->executed_on;

    if ($block->match) {
        ok(scalar(@jobs), 'match');
    } else {
        ok(!scalar(@jobs), 'not match');
    }
};

__END__

=== Compare minutes OK
--- job_date
* * * * 5 *
--- executed_on
2015-05-24T09:05
--- match
1

=== Compare minutes NG
--- job_date
* * * * 5 *
--- executed_on
2015-05-24T09:06
--- match
0

=== Compare hours OK
--- job_date
* * * 0 * *
--- executed_on
2015-05-24T00:15
--- match
1

=== Compare hours NG
--- job_date
* * * 23 * *
--- executed_on
2015-05-24T11:06
--- match
0

=== Compare months OK
--- job_date
* 12 * * * *
--- executed_on
2015-12-24T00:15
--- match
1

=== Compare months NG
--- job_date
* 1 * * * *
--- executed_on
2015-02-24T11:06
--- match
0

=== Compare years OK
--- job_date
2015 * * * * *
--- executed_on
2015-12-24T00:15
--- match
1

=== Compare years NG
--- job_date
2020 * * * * *
--- executed_on
2015-02-24T11:06
--- match
0

# for Emacsen
# Local Variables:
# mode: cperl
# cperl-indent-level: 4
# cperl-close-paren-offset: -4
# cperl-indent-parens-as-block: t
# indent-tabs-mode: nil
# coding: utf-8
# End:

# vi: set ts=4 sw=4 sts=0 et ft=perl fenc=utf-8 ff=unix :
