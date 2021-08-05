unit class Proc::Easy:ver<0.0.1>:auth<cpan:TBROWDER>;

#| Subroutine: run-command
#| Purpose : Run a system command using class Proc.
#| Params  : A string that contains a command suitable using Raku's run routine, and four named parameters that describe inputs and desired outputs.
#| Returns : Either the exit code (default), a list of exit code and results from stderr and stderr, or just the results from stdout.  There is also the capability to send debug messages to stdout.
sub run-command(Str:D $cmd,
                :$err,
		:$out,
		:$all,
		:$dir,                # run command in dir 'dir'
                Hash() :$env = %*ENV,
		:$debug,
	       ) is export {
    # default is to return the exit code which should be zero (false) for a successful command execuiton
    # :dir runs the command in 'dir'
    # :all returns a list of three items: exit code, stderr, and stdout
    # :err returns stderr
    # :out returns stdout
    # :debug prints extra info to stdout AFTER the proc command

    my $cwd = $*CWD;
    chdir $dir if $dir;
    #=== may be in another dir ===
    my $proc = run $cmd.words, :err, :out;
    my $exitcode = $proc.exitcode;
    # always need to close file handles if used
    my $stderr   = $proc.err.slurp(:close) if $all || $err;
    my $stdout   = $proc.out.slurp(:close) if $all || $out;
    #=== leave the other dir ===
    chdir $cwd if $dir;

    if $exitcode && $debug {
        say "ERROR:  Command '$cmd' returned with exit code '$exitcode'.";
        say "  stderr: $stderr" if $stderr;
        say "  stdout: $stdout" if $stdout;
    }

    if $all {
        return $exitcode, $stderr, $stdout;
    }
    elsif $out {
        return $stdout;
    }
    else {
        return $exitcode;
    }
} # run-command
