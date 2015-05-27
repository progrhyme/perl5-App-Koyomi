use strict;
use warnings;
use Cwd;
use Module::Build;

my $cwd = Cwd::cwd();

my %args = (
    module_name          => 'App::Koyomi',
    license              => 'perl',
    dist_author          => 'YASUTAKE Kiyoshi <yasutake.kiyoshi@gmail.com>',
    dist_version_from    => 'lib/App/Koyomi.pm',
    add_to_cleanup       => ['App-Koyomi-*'],
    test_files           => 't/',
    recursive_test_files => 1,
    tap_harness_args     => {
        lib => ["$cwd/lib", "$cwd/t/lib"],
    },
    configure_requires       => {
        'Module::Build' => 0.42,
    },
    build_requires       => {
        'TAP::Harness'  => 3.34,
    },
);

my $builder = Module::Build->subclass(
    class => 'KoyomiBuilder',
    code  => q{
        sub ACTION_test_libs {
            my $self = shift;
            local @INC = @INC;
            unshift @INC, 't/lib';
            $self->SUPER::ACTION_test(@_);
        }
    },
)->new(%args);

$builder->create_build_script();
