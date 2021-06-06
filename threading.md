# Multithreading / Synchronization

## Threading

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
    * _event-driven_:
      * comes from observation that threads do a lot of waiting: reading files, waiting for dbs, ...
      * suggested to consider the _event-driven pattern_ first i.e.
      * asynchronous I/O, callbacks, an event loop, a small thread pool with just a thread per processor.

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

## Synchronization

[Operating-System-Concepts]

* **race condition**
  > several processes access and manipulate the same data concurrently and the outcome of the
  > execution depends on the particular order in which the access takes place
  * examples in _kernel code_
    * data stracture maintaining a list of all open files
    * variable _next\_available\_pid_

* **mutex lock** - simplest 'tool' to protect critical sections and prevent race conditions
  * short for **mu**tual **ex**clusion
  * example, _note_ calls to `acquire` and `release` must be performed atomacially e.g. using CAS (compare-and-swap)
  ```c
    acquire() {
      while (!available)
        ; /* busy wait */
        available = false;
    }

    release() {
      available = true;
    }
  ```
  * mutex **lock** states:
    * _contended_ thread blocks while trying to aquire lock
    * _uncontended_ lock is available when thread attempts to require it
  * main **disadvantage**: **_busy waiting_**
  * another name for this type of mutex lock: **spinlock**
    * process _spins_ while watiting for lock
    * advantage: no context switch required
    > a context switch to move the thread to the waiting state and a
    > second context switch to restore the waiting thread once the lock becomes available

* **semaphore** - and `int` accessed only through two standard atomic operations: `wait()` and `signal()`

* **monitor** 
  * _"The monitor construct ensures that only one process at a time is active within the monitor."_
  > A monitor is an abstract data type that provides a high-level form of process synchronization.
  > A monitor uses condition variables that allow processes to wait for certain conditions to become
  > true and to signal one another when conditions have been set to true.

* **liveness**
  > refers to a set of properties that a system must satisfy to ensure that processes make progress
  > during their execution life cycle.

* **deadlock**
  > a set of processes is in a deadlocked state when every process in the set is waiting for
  > an event that can be caused only by another process in the set. 

* locking _approaches_
  * _optimistic_ - first update variable and then use collision detection
  * _pessimistic_ - assume another thread is concurrently updating the variable...
    * so you pessimistically acquire the lock before making any updates.

### Synchronization Examples

_Note:_
> Prior kernel 2.6, Linux was a nonpreemptive kernel, meaning that a process running in
> kernel mode could not be preempted—even if a higher-priority process became available to run.

* **Kernel**
  * _Atomics_: Linux kernel atomic integer `atomic_t` with atomic operations `atomic_inc(&i)` or `atomic_read(&i)`
  * _Mutex locks_: `mutex_lock()` / `mutex_unlock()`
  > If the mutex lock is unavailable, a task calling `mutex lock()` is put into a sleep state
  > and is awakened when the lock’s owner invokes `mutex unlock()`

* POSIX **Pthreads**
  * mutex locks data type `pthread mutex t`
  ```c
  #include <pthread.h>
  int main() {
      pthread_mutex_t mutex;
      pthread_mutex_init(&mutex,NULL); /* create + init the mutex lock */
      pthread_mutex_lock(&mutex); /* acquire lock */
      /* ******************************
       * critical section goes here
       * ******************************/
      pthread_mutex_unlock(&mutex); /* release lock */
  }
  ```


[Linux-System-Programming]:https://www.oreilly.com/library/view/linux-system-programming/9781449341527/
[Linux-Kernel-Development]:https://www.oreilly.com/library/view/linux-kernel-development/9780768696974/
[Operating-System-Concepts]: https://codex.cs.yale.edu/avi/os-book/
