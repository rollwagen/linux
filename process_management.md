# process management

* in Unix, the creation of a new process and the act of loading a new binary is separated
  * `fork()`
  * `exec()`

* _idle process_ (PID=0) process the kernel 'runs' when there's not other runnable process
* _init process_ (PID=1) first process kernel executes after booting
  * can be specified with _init_ kernel command-line parameter
  * kernel tries four executables:
    * (1) `/sbin/init`
    * (2) `/etc/init`
    * (3) `/bin/init`
    * (4) `/bin/sh`
* **process id allocation**
  * kernel: pid is of type `pid_t`, generally `int` e.g. _posix_types.h_ `typedef int  __kernel_pid_t;`
  * maximum process id:
  ```bash
  $ cat /proc/sys/kernel/pid_max
  4194304
  ```
  * allocation is in a strictly linear fashion
  * kernel does not reuse process IDs until it wraps around from top
* **process hierarchy**
  * every process is spawned from another process (exept `init` with pid 1)
  * releationship is recorded in _parent process ID_ (**ppid)
  * each process is part of a _process group_
    * e.g. `ls|less` processes belong to same process group
  ```c
  #include <unistd.h>
  #include <stdio.h>
  int main()
  {
    printf("pid  = %d\n", getpid());
    printf("ppid = %d\n", getppid());
  }
  ```
* **exec()**
  * there's no single exec function, instead a range of exec functions built on singel syscall
  * `execl()` replaces current process image with new one specified with `path`
  ```c
  #include <unistd.h>
  #include <stdio.h>
  int main()
  {
    execl("/bin/ls", "ls", NULL);
  }
  ```
  * Unix convention is to pass the program name as the program’s first argument.
  * open files are inherited across an exec
    * often not the desired behavior
    * usual practice is to close files before the exec
    * can be done automatically via kernel with `fcntl()` (fcntl=file control)

* **fork()**
  * fork() creates a new process
  * child and the parent process are (almost) identical except for
    * pid / ppid
    * resource statistics (reset to zero in child)
    * any pending signals are cleared
    * file locks are not inherited by child
  ```c
  #include <unistd.h>
  #include <stdio.h>
  int main()
  {
    pid_t pid = fork ();
    //sleep(1);
    if (pid > 0)
      printf ("Parent of new child; child pid=%d\n", pid);
    else if (!pid)
      printf ("Child with pid=%d and ppid=%d\n", getpid(), getppid() );
  }
  ```
  ```bash
  # output without sleep -> parent terminates first and kernel reparents child to pid=1
  Parent of new child; child pid=60525
  Child with pid=60525 and ppid=1
  # output with sleep
  Parent of new child; child pid=60874
  Child with pid=60874 and ppid=60873
  ```
