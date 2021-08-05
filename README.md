[![Actions Status](https://github.com/tbrowder/Proc-Easy/workflows/test/badge.svg)](https://github.com/tbrowder/Proc-Easy/actions)

NAME
====

**Proc::Easy** - Provides routine `run-command` to ease using Raku's **Proc** class.

NOTE: This module replaces the `run-command` portion of the deprecated module `Proc::More`.

SYNOPSIS
========

```raku
    use Proc::Easy;
    my $cmd = "some-user-prog arg1 arg2";
    my $other-dir = $*TMPDIR";
    my ($exitcode, $stderr, $stdout) = run-command $cmd, :dir($other-dir);
```

DESCRIPTION
===========

**Proc::Easy** is designed to make using the `run` routine from class `Proc` easier for the usual, simple case when the myriad ways to use `Proc`'s `run` are not required.

sub `run-command`
-----------------

```raku
sub run-command(Str:D $cmd,
		:$exit,
                :$err,
		:$out,
		:$dir, # run command in dir 'dir'
		:$debug,
	       ) is export {...}
```

### Parameters:

  * `$cmd` - A string that contains a command suitable for using Raku's `run` routine

  * `:$exit` - returns the exit code which should be zero (false) for a successful command execution

  * `:$err` - returns `stderr`

  * `:$out` - returns `stdout`

  * `:$dir` - runs the command in directory 'dir'

  * `:$debug` - prints extra info to stdout AFTER the proc command

### Returns:

A three-element list of exit code and results from stderr and stdout, respectively. Either of the three may be selected individually if desired. (If more than one is selected, only one is returned in the order of exit code, stderr, or stdout.) There is also the capability to send debug messages to stdout by including the `:$debug` option.

AUTHOR
======

Tom Browder <tbrowder@cpan.org>

COPYRIGHT and LICENSE
=====================

Copyright © 2017-2021 Tom Browder

This library is free software; you may redistribute or modify it under the Artistic License 2.0.

