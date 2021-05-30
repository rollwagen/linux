# Memory Management

[Operating-System-Concepts]
* **paging** - a memory-management scheme allowing process’s physical address space to be non-contiguous.

[Linux-System-Programming] 
* processes do not directly address physical memory
* each process is associates with a (unique) _virtual address space_
* address space is _linear_ (start at zero) and _flat_

* **page** smallest addressable unit of memory by MMU (memory management unit)
  * page size is defined by the hardware
  * get pagesize via `/proc`, `getconf`, or syscall `getpagesize()`

    ```bash
    # cat /proc/1/smaps | grep -i pagesize | head -2
    KernelPageSize:        4 kB
    MMUPageSize:           4 kB
    # getconf PAGESIZE
    4096
    ```

    ```c
    #include <unistd.h>
    #include <stdio.h>
    int main() {
       printf("%d\n", getpagesize());
    }
    ```
  * pages are either valid or invalid
    * _valid page_ - associated with a page of data (in RAM or secondary storage/swap)
    * _invalid page_ - not associated with anything (unused, unallocated address space)
  * **page fault**: - _valid_ page but not currently in RAM and needs to be _paged in_
  * **segmentation fault** - caused by trying to access an _invalid_ page
  ```c
    #include <stdlib.h>
    int main() {
      int *ip;
      ip = (int *) malloc( sizeof(int)*10 );
      ip[100000] = 99; // outside array's 10 elements, seg fault
    }
  ```

* memory regtions (areas/mappings) in every process
  * _text segment_ the actual program code, constants etc; ready only data
  * _stack_ grows/shrinks dynamically; e.g. local vars, function return data. Thread: one stack per thread
  * _data segment_ or _head_ - dynamic memory (`malloc()`)
  * _bss segment_ unitialzed global variables (zeroes)

* **dynamic memory** - allocated at runtim
  * `void * malloc (size_t size);`
  * `calloc()` - zero's out bytes ('c'=clear)
  * `realloc()`
    > if unable to enlarge the existing chunk of memory by growing the chunk in situ,
    > the function may allocate a new region of memory size bytes in length,
    > copy the old region into the new one, and free the old region

 
[Linux-System-Programming]:https://www.oreilly.com/library/view/linux-system-programming/9781449341527/
[Linux-Kernel-Development]:https://www.oreilly.com/library/view/linux-kernel-development/9780768696974/
[Operating-System-Concepts]: https://codex.cs.yale.edu/avi/os-book/
