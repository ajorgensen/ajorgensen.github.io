+++
date = "2017-06-01T13:57:08-04:00"
title = "A Tale of Two Pipes"
tags = ["python"]
+++
Let me first introduce you to two leading characters: STDIN and STDOUT

<!--more-->

This story begins with a simple python script who's purpose is to shell out using pythons subprocess module and capture the output.

```python
import subprocess

ps = subprocess.Popen(("ls", "-la"),
                      stdout=subprocess.PIPE,
                      stderr=subprocess.PIPE)

# Wait for the process to finish
ps.wait()

print sys.stdout
print sys.stderr
```

At first glance this appears to work well for our use case, it will print the output of `ls -la` to the console. At this point we must add another character to this story, a c program that logs meaningless messages to stderr in order to prove a point.

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

After compiling this small program, running it will do what we expect, `./log 5` prints out `Hello stderr` 5 times to stderr.

```shell
Hello stderr
Hello stderr
Hello stderr
Hello stderr
Hello stderr
```

Now that we have our shiny new program we want to use our python script to call it. We can modify our original python script to call out to our new c program to read its output.

```python
import subprocess
import sys

logTimes = sys.argv[1]
ps = subprocess.Popen(("./log", logTimes),
                      stdout=subprocess.PIPE,
                      stderr=subprocess.PIPE)

print "PID: " + str(ps.pid)

ps.wait()

print ps.stdout.read()
print ps.stderr.read()
```

This again does what we expect, logs out the PID of the subprocess and then both STDOUT and STDERR once the subprocess has finished running. Lets pump up the jamz a bit and increase the number of log messages from 5 to 6000, if you're following along with this story at home you should see something unexpected.

```shell
Starting subprocess
PID: 90908
```

No log messages are printed to the console and the python script is actually stopped and will exit the stage. Let's fire up gdb and take a look to see whats going on.

```shell
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

It turns out that there is a limited buffer size for pipes. On linux you can find this limit by running `cat /proc/sys/fs/pipe-max-size`. Once this buffer files up and nothing on the other side is reading from the buffer the process will deadlock waiting for space in the buffer to free up. The [python documenation](https://docs.python.org/2/library/subprocess.html#subprocess.call) does mention the potential to deadlock but does not go into the circumstances where a deadlock can occur.

There are a few ways to work around this issue. The [first](https://docs.python.org/2/library/subprocess.html#subprocess.Popen.communicate) and easiest is to use `subprocess.communicate` instead of calling `subprocess.wait()`. This will continually read off of the STDOUT and STDERR pipes and buffer the messages in memory, wait for the process to finish, and return them both as a tuple once the subprocess has finished. You should be careful here as well since the log output is buffered in memory it has the potential to consume all available memory depending on the output log volume of the subprocess. This is also not suitable for long running processes where python is acting as a supervisor as you will eventually run out of memory.

For applications where python is performing the role of a supervisor we need to be stream the logs from the subprocess to another location. The easiest way to accomplish this is to redirect STDERR to STDOUT and create a log streaming function that will stream the logs via a background thread.

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
    logging_thread = Thread(target=stream_process_stdout,
                            args=(process, log_fn, ))
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

One other alternative is to make sure that you are always streaming the STDOUT and STDERR of a subprocess to a dedicated file rather than to `subprocess.PIPE`.
