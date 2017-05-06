+++
date = "2017-05-06T13:57:08-04:00"
title = "A Tale of Two Pipes"
draft = "True"
tags = ["python"]
+++
The moral of this story is, be careful when using pipes with python subprocesses.

<!--more-->

A story begins with a simple python script. The purpose of this script is to shell out using pythons subprocess module and capture the output.

```python
import subprocess

ps = subprocess.Popen(("ls", "-la"), stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# Wait for the process to finish
ps.wait()

print sys.stdout
print sys.stderr
```

This works all well and good, it will print the output of `ls -la` to the console. Lets go ahead and add another character to this story, a c program that logs messages to stderr which can be common for some scripts printing out debug information.

```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
  int logTimes = atoi(argv[1]);
  for (int i = 0; i < logTimes; i++)  {
    fprintf(stderr, "%s\n", "Hello stderr");
  }

  return 0;
}

```

After compiling this small program, running it will do what we expect, `./log 5` prints out `Hello stderr` 5 times to stderr on the console..

```
Hello stderr
Hello stderr
Hello stderr
Hello stderr
Hello stderr
```

As our story continues these two characters meet and start working together. We can modify our original python script to call out to our new c program to read its output.

```python
import subprocess
import sys

logTimes = sys.argv[1]
ps = subprocess.Popen(("./log", logTimes), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
print "PID: " + str(ps.pid)

ps.wait()

print ps.stdout.read()
print ps.stderr.read()

```

This again does what we expect, logs out the pid of the subprocess and then both the stdout and stderr once the subprocess has finished running. Lets pump up the jamz a bit and increase the number of log messages from 5 to 6000, if you're following along with this story at home you should see something unexpected.

```
Starting subprocess
PID: 90908

```

No log messages are printed to the console and the python script is actually stuck and does not exit. Let's fire up gdb and take a look to see whats going on.

```
(gdb) bt
#0  0x00007f14ebc9df80 in __write_nocancel () at ../sysdeps/unix/syscall-template.S:81
#1  0x00007f14ebc27f13 in _IO_new_file_write (f=0x7f14ebf711c0 <_IO_2_1_stderr_>, data=0x7ffc8f5b0ea0, n=13)
    at fileops.c:1261
#2  0x00007f14ebc286af in new_do_write (to_do=13, data=0x7ffc8f5b0ea0 "Hello stderr\n",
    fp=0x7f14ebf711c0 <_IO_2_1_stderr_>) at fileops.c:538
#3  _IO_new_file_xsputn (f=0x7f14ebf711c0 <_IO_2_1_stderr_>, data=<optimized out>, n=13) at fileops.c:1343
#4  0x00007f14ebbfdf0d in buffered_vfprintf (s=s@entry=0x7f14ebf711c0 <_IO_2_1_stderr_>,
    format=format@entry=0x400710 "%s\n", args=args@entry=0x7ffc8f5b34c8) at vfprintf.c:2377
#5  0x00007f14ebbf8dfe in _IO_vfprintf_internal (s=0x7f14ebf711c0 <_IO_2_1_stderr_>, format=0x400710 "%s\n",
    ap=ap@entry=0x7ffc8f5b34c8) at vfprintf.c:1313
#6  0x00007f14ebc03337 in __fprintf (stream=<optimized out>, format=<optimized out>) at fprintf.c:32
#7  0x0000000000400658 in main (argc=2, argv=0x7ffc8f5b36a8) at main.c:10
```

From this we can see that our c program is actually deadlocked on trying to write `"Hello stderr\n"` to stderr. So why was the program ok running when there were only 5 messages to log out but now that we've cranked it up to 6000 its deadlocks?

It turns out that there is a limited buffer size for pipes. On linux you can find this size by running `cat /proc/sys/fs/pipe-max-size`. Once this buffer files up and nothing on the other side is reading from the buffer the process logging will deadlock waiting for space in the buffer to free up. The [python documenation](https://docs.python.org/2/library/subprocess.html#subprocess.call) does mention the potential to deadlock but does not go into the circumstances where a deadlock can occur.

There are a few ways to handle this issue to make sure the subprocess does not deadlock. The [first](https://docs.python.org/2/library/subprocess.html#subprocess.Popen.communicate) and easiest is to use `subprocess.communicate` instead of calling `subprocess.wait()`. This will continually read off of the stdout and stderr pipes and buffer the messages in memory, wait for the process to finish, and return both stdout and stderr as a tuple once completed. You should be careful here as well since the log output is buffered in memory it has the potential to consume all available memory depending on the output log volume of the subprocess.

One place that `subprocess.communicate()` wont work however is if your python process is acting as a supervisor to many other subprocesses. Since we cannot block on any one process running at once we want to be able to stream the logs from the all of the subprocesses at once without blocking the execution of other processes. The easiest way to accomplish this to redirect stderr to stout and create a custom log streaming function that will stream the logs via a background thread.

```python
import subprocess
import sys
from threading import Thread

def async_stream_process_stdout(process, log_fn):
    """ Stream the stdout and stderr for a process out to display async
    :param process: the process to stream the log for
    :param log_fn: a function that will be called for each log line
    :return: None
    """
    logging_thread = Thread(target=stream_process_stdout, args=(process, log_fn, ))
    logging_thread.start()

    return logging_thread

def stream_process_stdout(process, log_fn):
    """ Stream the stdout and stderr for a process out to display
    :param process: the process to stream the logs for
    :param log_fn: a function that will be called for each log line
    :return: None
    """
    while 1:
        line = process.stdout.readline()
        if not line:
            break

        log_fn(line)

def log_fn(process):
    return lambda line: sys.stdout.write("%s: %s" % (process, line))

logTimes = sys.argv[1]
ps_one = subprocess.Popen(("./log", logTimes), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=1)
ps_two = subprocess.Popen(("./log", logTimes), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=1)

logger_one = async_stream_process_stdout(ps_one, log_fn("ps_one"))
logger_two = async_stream_process_stdout(ps_two, log_fn("ps_two"))

logger_one.join()
logger_two.join()
```

Moral of the story is be careful when using pipes between two processes. If you're not careful you can cause a deadlock because the allocated pipe buffer gets filled up.

The End
