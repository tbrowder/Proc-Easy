unit class Proc::Easy;

#| Subroutine: run-command
#| Purpose : Run a system command using class Proc.

#| Params : A string that contains a command suitable using Raku's run
#| routine, and four named parameters that describe inputs and desired
#| outputs.

#| Returns : A three-element list of exit code and results from stderr
#| and stdout, respectively. Either of the three may be selected
#| individually if desired. (If more than one is selected, only one is
#| returned in the order of exit code, stderr, or stdout.) There is
#| also the capability to send debug messages to stdout.

sub run-command(Str:D $cmd,
                :$err,
		:$out,
		:$exit,
		:$dir, # run command in dir 'dir'
		:$debug,
	       ) is export {
    # default is to return the exit code, stderr, and stdout
    # :dir runs the command in 'dir'
    # :exit returns exit code which should be zero (false) for a successful command execution
    # :err returns stderr
    # :out returns stdout
    # :debug prints extra info to stdout AFTER the proc command

    my $cwd = $*CWD;
    chdir $dir if $dir;
    #=== may be in another dir ===
    my $proc = run $cmd.words, :err, :out;
    my $exitcode = $proc.exitcode;
    # always need to close file handles if used
    my $stderr   = $proc.err.slurp(:close);
    my $stdout   = $proc.out.slurp(:close);
    #=== leave the other dir ===
    chdir $cwd if $dir;

    if $exitcode && $debug {
        say "ERROR:  Command '$cmd' returned with exit code '$exitcode'.";
        say "  stderr: $stderr" if $stderr;
        say "  stdout: $stdout" if $stdout;
    }

    if $exit {
        $exitcode
    }
    elsif $err {
        $stderr
    }
    elsif $out {
        $stdout
    }
    else {
        $exitcode, $stderr, $stdout
    }
} # run-command
