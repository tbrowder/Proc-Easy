use v6;
use Test;

use Proc::Easy;

use File::Temp;

plan 23;

my ($exitcode, $stderr, $stdout);

# tests 1-7
dies-ok { $exitcode = run-command 'fooie'; die if $exitcode; }
cmp-ok $exitcode, '!=', 0;
dies-ok { $exitcode = run-command 'fooie', :dir($*TMPDIR); die if $exitcode; };
cmp-ok $exitcode, '!=', 0;
dies-ok { ($exitcode, $stderr, $stdout) = run-command 'fooie', :dir($*TMPDIR); die if $exitcode; };
cmp-ok $exitcode, '!=', 0;
lives-ok { run-command 'ls -l', :dir($*TMPDIR), :out, :err; }

# run some real commands with errors
# tests 8-15
lives-ok { run-command 'ls -l' }
lives-ok { run-command 'ls -l', :dir($*TMPDIR); }
lives-ok { run-command 'ls -l'; }
lives-ok { run-command 'ls -l', :dir($*TMPDIR); }
lives-ok { run-command 'ls -l', :dir($*TMPDIR), :out; }
lives-ok { run-command 'ls -l', :dir($*TMPDIR), :exit; }
lives-ok { run-command 'ls -l', :dir($*TMPDIR), :err; }
lives-ok { run-command 'ls -l', :dir($*TMPDIR), :exit, :err, :out; }

# get a prog with known output
my $prog = q:to/HERE/;
$*ERR.print: 'stderr';
$*OUT.print: 'stdout';
HERE

my ($prog-file, $fh) = tempfile;
$fh.print: $prog;
$fh.close;

my $cmd = "raku $prog-file";

# run tests in the local dir
# tests 16-18
{
    ($exitcode, $stderr, $stdout) = run-command $cmd;
    is $stderr, 'stderr';
    is $stdout, 'stdout';
    cmp-ok $exitcode, '==', 0;
}

# run tests in the tmp dir
# tests 19-21
{
    ($exitcode, $stderr, $stdout) = run-command $cmd, :dir($*TMPDIR);
    is $stderr, 'stderr';
    is $stdout, 'stdout';
    cmp-ok $exitcode, '==', 0;
}

# two more tests
# tests 22-23
dies-ok { $exitcode = run-command "cd $*TMPDIR; fooie", :exit; die if $exitcode; }
cmp-ok $exitcode, '!=', 0;


