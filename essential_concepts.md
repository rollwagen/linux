
# Linus Essential Concepts


## system calls
* system calls (short: _syscalls_): function invocations made from user spaceinto kernel, to request services/resources from the OS e.g. `read()`, `write()`, `get_thread_area()` (~ 380 syscalls)


## glibc
  * implements standard C library
  * provides wrappers for system calls (and threading support +  basic application facilities)


## API and ABI 
  * Application Programming Interface (_API_) defines interfaces by which one piece of software communicates with another at the _source level_
  * Application Binary Interface (_ABI_) defines binary interface between pieces of software on a particular architecture (e.g. x86-64)
  * concerned with e.g. calling conventions, byte ordering, register use, system call invocation, linking, library behavior, and the binary object format
  * enforced by the toolchain (compiler, linker)


## standards
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
    
# files / filesystem
  * _everything is a file_ philosophy
  * to be accessed, a file must be opened; can be open for reading or writing or both

  * **file _descriptor_** - reference to open file, maps metadata of open file to specific file
    * of C type `int`
    * _fd_ abbreviated
    * shared with user space 

  * **regular files**
    * bytes of data, organized in linear array called _byte stream_
    * _file offset_ or _file position_ = location within the file
    * writing a byte to a file position beyond the end of file will cause intervening bytes padded with zero
    ```c
    #include <fcntl.h> // open
    #include <unistd.h> // write
    int main()
    {
      int fd; // file descriptor
      fd = open("file.bin", O_RDWR|O_CREAT); // O_RDWR open read+write, O_CREAT create if not exist
      char onebyte = 1;
      write(fd, &onebyte, sizeof(char));
      pwrite(fd, &onebyte, sizeof(char), 10); // 'p'=position, last param = off_t offset
      close(fd);
    }
    ```
    ```bash
    hexdump file.bin
    0000000 01 00 00 00 00 00 00 00 00 00 01
    ```
