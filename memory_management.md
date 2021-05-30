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
  * **segmentation fault** - caused by trying to access an _invalid_ page
  * **page fault**: - _valid_ page but not currently in RAM and needs to be _paged in_
 
[Linux-System-Programming]:https://www.oreilly.com/library/view/linux-system-programming/9781449341527/
[Linux-Kernel-Development]:https://www.oreilly.com/library/view/linux-kernel-development/9780768696974/
[Operating-System-Concepts]: https://codex.cs.yale.edu/avi/os-book/
