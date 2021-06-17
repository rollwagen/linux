# Scheduling

[Linux-Kernel-Development]

Two flavours of multitasking OS:

* _cooperateive multitasking_
  * process does not stop until it itself voluntarily decides so
* _preemtive multitasking_
  * scheduler decides when a process ceases running and a new process begins running
  * the act of involuntarily suspending a running process is called preemption
  * time process runs before preempted is predetermined = _timeslice_

* Process classification (not mutually exclusive):
  * _I/O bound_
    * spends much of its time submitting and waiting on I/O
    * runs only shortly before it blocks waiting on I/O
  * _Processor bound_
    * majority of time spend executing code

* Process priority - Linux kernel has two separate priority ranges
  * _nice_ -20 to +19, default 0  (lower = higher prio)
    * in Linux, a control over the _proportion of timeslice_ (other Unixes: _absolute timeslice_)
    * `nice` syscall:
    ```c
        #include <unistd.h>
        int nice(int inc);
     ```
  * _real-time priority_ 0 to 99

* Timeslice / scheduler
  * Linux’s CFS - Completely Fair Scheduler
    * does not directly assign timeslices to processes
    * assigns processes a proportion of the processor.
    * thus, amount of processor time a process receives is a function of the load of the system

[Linux-Kernel-Development]:https://www.oreilly.com/library/view/linux-kernel-development/9780768696974/
[Operating-System-Concepts]: https://codex.cs.yale.edu/avi/os-book/
