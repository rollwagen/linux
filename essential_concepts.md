
# Linus Essential Concepts

## System calls

* **system calls** (short: _syscalls_): function invocations made from user spaceinto kernel, to request services/resources from the OS e.g. `read()`, `write()`, `get_thread_area()` (~ 380 syscalls)

* **glibc**
  * implements standard C library
  * provides wrappers for system calls (and threading support +  basic application facilities)

* **API** and **ABI** 
  * Application Programming Interface (_API_) defines interfaces by which one piece of software communicates with another at the _source level_
  * Application Binary Interface (_ABI_) defines binary interface between pieces of software on a particular architecture (e.g. x86-64)
  * concerned with e.g. calling conventions, byte ordering, register use, system call invocation, linking, library behavior, and the binary object format
  * enforced by the toolchain (compiler, linker)

* **standards**
  * _POSIX_ - Portable Operating System Interface
  * _SUS_ - Single UNIX Specification
  * POSIX and SUS document e.g. the C API for a Unix-like operating system interface
  * SUS subsumes/includes POSIX
  * _LSB_ Linux Standard Base
    * [LSB Wikipedia](https://en.wikipedia.org/wiki/Linux_Standard_Base)
      > ... standardize the software system structure,
      > including the Filesystem Hierarchy Standard used in the Linux kernel.
      > The LSB is based on the POSIX specification, the Single UNIX Specification (SUS)
      > and several other open standards, but extends them in certain areas. 
    
