---
title: "Be Careful Using tmux and Environment Variables"
postSlug: be-careful-using-tmux-and-environment-variables
pubDate: 2023-03-02T12:47:33-05:00
draft: false
tags:
  - tmux
---

tmux has an interesting quirk in the way it handles environment variables that if you're not careful can cause some seemingly strange behavior.

Fortunately, this behavior is documented but in my opinion, is not intuitive. From the tmux man page:

> <strong class="text-accent"> When the server is started, tmux copies the environment into the
> global environment; </strong> in addition, each session has a session
> environment. When a window is created, the session and global
> environments are merged. If a variable exists in both, the value
> from the session environment is used. The result is the initial
> environment passed to the new process.

What this says is that the global environment is copied over when the **server** is
started. Each session also has an environment that is merged with the original
global environment but it only has a set list of environment variables that are
updated. You can see this with the following command in a tmux session:

```console
> tmux show-environment
-DISPLAY
-KRB5CCNAME
-SSH_AGENT_PID
-SSH_ASKPASS
SSH_AUTH_SOCK
-SSH_CONNECTION
-WINDOWID
-XAUTHORITY
```

This can cause some interesting consequences when you have multiple named tmux sessions running. Here's an example of
this in action:

```console
> export FOO=foo
> tmux new-session -t first
> echo $FOO
foo

> export FOO=bar
> tmux new-session -t second
> echo $FOO
foo
```

As long as the tmux server is running, it will retain the copy of the environment at the moment it was started and
unless the environment variable is in a set list it will not be updated when a new session starts __even__ if its a
completely separate session.

There are a few different ways to work around this. If you know you'll want a specific environment variable updated each
time you start a new session, you can add the variable to the global update list.

```console
set-option -g update-environment "FOO"
```

This will tell tmux the session environment for `$FOO` whenever a new session is created or an existing session is
attached to.

Alternatively, you can manually update the environment using `tmux set-environment` this can be applied to either the
global environment so that each new session picks up the new value or for a specific session.

Lastly, you can avoid the problem altogether by providing a named socket to tmux using `-L` which will cause a new server to start
and copy the current environment into the global environment.

```console
> export FOO=foo
> tmux new-session -t first
> echo $FOO
foo

> export FOO=bar
> tmux -L other new-session -t second
> echo $FOO
bar
```

This does make the ergonomics for tmux a little more cumbersome since you'll need to provide the name of the socket
each time you want to run tmux commands. For example, to re-attach to the `second` session you'll need to do `tmux -L
other attach -t second`.
