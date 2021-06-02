# Threading

* [Operating-System-Concepts]
  * **Note:** _concurrency_ vs _parallelism_
  * programming callenges for multicore/multi-threaded systems:
    * identifying tasks - what can be divided into separate tasks (ideally independent)
    * balance - tasks performing equal work of equal value; if not worth separate task/thread at all?
    * data splitting - data accessed and changes by tasks must be divided too
    * data dependency - synchronization in case of data dependencies of tasks
    * testing debugging

* [Linux-Kernel-Development]
  > To the Linux kernel, there is no concept of a thread.  
  > Linux implements all threads as standard processes  
  > The Linux kernel does not provide any special scheduling semantics or  
  > data structures to represent threads. Instead, a thread is merely  
  > a process that shares certain resources with other processes.  
  * syscall `clone()` to create threads
  * _kernel threads_ standard processes that exist solely in kernel-space.

_Threading_ - creation and management of multiple units of execution within a single process. \
_Binary_ - dormant program resigin on storage \
_Process_ - OS abstraction representing the loaded binary, virtual. mem., kernel resources (fds etc)
_Thread_ - unit of execution withing a process: a virtualized processor, a stack, and program state

* [Linux-System-Programming]
  
  * Modern OSs have two fundamentaion (virtualized) abstractions to user-space:
    * virtualized prozesssor
      * associated with with threads (and not the process)
    * virtual memory
      * associated with process; hence each process has a unique view of memory
      * however all threads in a process _share_ this memory
  
  * Six primary benefits to multithreading:
    * (1) Programming abstraction - dividing work as assigning to units of execution (threads)
    * (2) Parallelism
    * (3) Improving responsiveness
    * (4) Blocking I/O
    * (5) Context switching - cheaper from thread-to-thread (_intraprocess switching_) than process-to-process
    * (6) Memory savings
  
  * User-level threading
    * _N:1 threading_, also called _user-level threading_
    * a process with _N_ threads maps to a single kernel process (N:1)
    * scheduler etc is a all user-space code
    * not true prallelism
  
  * Hyper threading
    * _N:M_ threading, also known as _hybrid threading_
    * the kernel provides a native thread concept, while user space also implements user threads
  
  * Threading patterns, the two core programming patterns are:
    * _thread-per-connection_ - unit of work is assigned to one thread, which "runs until completion"
    * _event-driven_
      * comes from observation that threads do a lot of waiting: reading files, waiting for dbs, ...
      * suggested to consider the _event-driven pattern_ first i.e.
        * asynchronous I/O
        * callbacks
        * an event loop
        * a small thread pool with just a thread per processor.

    * _Race condition_ situation in which unsynchronized access of shared resources lead to errors
      * shared resources examples: system's hw, a kernel resource, data in memory etc
      * _critical regtion - region of code that should be synchronized

    * **Synchronization**
      > The fundamental source of races is that critical regions are a window during which correct
      > program behavior requires that threads do not interleave execution. To prevent race conditions,
      > then, the programmer needs to synchronize access to that window, ensuring mutually exclusive
      > access to the critical region.
      * _atomic operation_ - indivisible, unable to be interleaved with other operations
        * problem with critical regions: they are not atomic

    * **Locks / Mutexes**
      * _lock_ mechanism for ensuring mutual exclusion within a cricial region, making it _atomic_
      * also knows as _mutexes_ (e.g. in Pthreads)
      * the smaller the critical region, the better:
        * locks prevent concurreny thus negating threading benefits

    * **_Deadlock_** - situation where 2 threads are waiting for the other to finish, thus neither does
  
## links / references

[Linux-System-Programming]:https://www.oreilly.com/library/view/linux-system-programming/9781449341527/
[Linux-Kernel-Development]:https://www.oreilly.com/library/view/linux-kernel-development/9780768696974/
[Operating-System-Concepts]: https://codex.cs.yale.edu/avi/os-book/
