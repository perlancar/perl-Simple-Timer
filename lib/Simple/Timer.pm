package Simple::Timer;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
no strict 'refs';
no warnings 'once';

use Time::HiRes;
use Time::Stopwatch;

tie our($TIMER), 'Time::Stopwatch';

sub timer(&) {
    local $TIMER = 0;
    shift->();
    say $TIMER;
}

sub import {
    my $class = shift;
    my $caller = caller;

    # this does not work, caller's $TIMER is not tied
    #${"$caller\::TIMER"} = $TIMER;
    tie ${"$caller\::TIMER"}, 'Time::Stopwatch';

    *{"$caller\::timer"} = \&timer;
}

1;
# ABSTRACT: Yet another simple timer

=head1 SYNOPSIS

 use Simple::Timer; # exports timer() and $TIMER

 # pick your preferred interface. either ...
 $TIMER = 0; do_something(); say $TIMER;

 # or ...
 timer { do_something_else() }; # prints elapsed time


=head1 DESCRIPTION

This module offers yet another way (actually two ways) to time your code. The
goal of this module is very simple interface, so no cumbersombe OO with the need
to instantiate a class. You just use a single variable or a single function.

There are two ways which you can choose. You can either:

Use B<a special (tied) variable $TIMER>. This variable is a stopwatch that
starts running when you load the module. At the top of the portion of code you
want to time, reset C<$TIMER> to 0. Then at the bottom of the code, you read the
value of C<$TIMER> to get elapsed time.

Or alternatively you can also use the B<timer> function. Just enclose the code
you want to time with this function and at the end the elapsed time is printed.

Using the C<timer> function is simpler, but it introduces another scope so you
can't always use it. That's why there's an alternative C<$TIMER> method.


=head1 EXPORTS

=head2 $TIMER => float

A tied variable that contains a running stopwatch. You can read its value to get
elapsed time, or you can also set its value (usually reset it to 0).


=head1 FUNCTIONS

=head2 timer CODE

Execute CODE and print the number of seconds passed.


=head1 SEE ALSO

Benchmark modules which I often use: L<Benchmark>, L<Benchmark::Dumb>, L<Bench>

To time whole programs simply, you might want to try L<Bench> (just use/load
it).

For alternatives to this module, you can try: L<Time::HiRes> directly,
L<Time::Stopwatch> (the backend module which this module uses), L<Timer::Simple>
(OO), L<Devel::Timer> (OO).
