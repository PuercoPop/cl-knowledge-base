----
title: How do one inspects the Intermediate representantion for a given lambda expression
tags: sbcl
----

Xof Version

1. Set a breakpoint on sb-c::generate-code. (trace sb-c::generate-code :break t)
2. (sb-c::describe-component sb-c::*current-component *standard-output*)
Also (sb-c::describe-ir2-component sb-c::*current-component *standard-output*)

Stas version

1. (setf sb-c::*compiler-trace-output* *standard-output*)

Consider combining it with symbolics idea of netcating terminal output


Scymtym version

1. (trace sb-c::ir1-phases :print (graph-component (sb-debug:arg 0))). Replace IR1-PHASES and (sb-debug:arg 0) with appropriate function and argument


Source:

```irc
10:15 <nml> [02:46:52] Is there a way to output the IRs for a given
            expression or lambda in the REPL?
10:15 <Xof> [04:28:39] nml: set a breakpoint on sb-c::generate-code [use
            (TRACE :BREAK T) ]
10:15 <Xof> [04:29:10] then (sb-c::describe-component
            sb-c::*current-component* *standard-output*)
10:15 <Xof> [04:29:23] and (sb-c::describe-ir2-component
            sb-c::*current-component *standard-output*)
10:15 <stassats> [04:29:33] (setf sb-c::*compiler-trace-output*
                 *standard-output*)
10:15 <nml> [04:46:57] xof, stassats I'll try it later. Thank you
10:15 <nml> [04:51:08] BTW, is it possible to retrieve those data structure
            as 'first-class' object rather than serialized strings?
10:15 <nml> [04:51:54] (then I might be able to print them using general
            object printer?)
10:15 <scymtym> [05:23:58] nml: i use something like this: (trace
                sb-c::ir1-phases :print (graph-component (sb-debug:arg 0)))
10:15 <scymtym> [05:24:51] (replace IR1-PHASES and (sb-debug:arg 0) with
appropriate function and argument)
```



scymtym: https://github.com/scymtym/cl-dot/tree/wip-clusters http://www.techfak.uni-bielefeld.de/~jmoringe/graph.png https://gist.github.com/scymtym/7de957988aff9a1edb34
Note: David Lichteblau McCLIM's IR1 inspector  http://www.lichteblau.com/blubba/irspect.png
