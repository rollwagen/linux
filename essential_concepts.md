
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
    * a file can be opened more than once, each open instance has their own unique fd
    * concurrent file access - must be coordinated by user-space programs themselves

  * **regular files**
    * bytes of data, organized in linear array called _byte stream_
    * _file offset_ or _file position_ = location within the file
    * _offset_ max value = size of the C type used to store it (64 bits usually on modern systems)
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

  * **inodes** 
    * a file is referenced by an _inode_ (information node)
    * inode number (or _i-number_ or _ino_ = integer value unique to filesystem
    * _inode_ stores file _metadata_ e.g.
      * e.g. modification timestamp, owner, type, length, and the location
      * metadata does _not_ include filename
    * inode is both physical obj on disk; and data structure `struct inode` / in-memory representation in kernel
    * `ls -i` lists inode numbers e.g. `ls -i /tmp/file.bin`, output:  `2671722 /tmp/file.bin`
    * _directories_ - mapping of human-readable names to inode numbers
      * directory is like any normal file, with difference that it contains only mappings of names to inodes
    * _link_ = (file-)name and inode pair(-mapping)
      * _...The physical on-disk form of this mapping—for example, a simple table or a hash—is implemented and managed by the kernel code that supports a given filesystem..._
    * _dentry_ = directory entry
    * _directory or pathname resolution_ - kernel's walk though dentries to find a specific inode
    * _fully qualified_ / _ absolute pathname_ - starting at `root` "/" directory
    * unlike normal files, kernel does not allow directories to be opened and manipulated like regular files
      * can only be manipulated via specific syscalls

  * **hard links** and **symbolic links**
    * _hard link_ multiple links map different (file-)names to the same inode
      * deleting a file _unlinks_ it from directory (removing name-inode pair from directory)
      * each inode contains a _link count_
    * _symlinks_ - has its own inode and data chunk, which contains the complete pathname of the linked-to file
    * Example:   _note string length "hardlink.txt" = 12_
    ```bash
       	inode Permissions   Links Size  Name
	2674927 .rw-r--r--      2    0  hardlink.txt
	2674927 .rw-r--r--      2    0  hardlink2.txt
	2674944 lrwxr-xr-x      1   12  softlink.txt -> hardlink.txt
    ```


## special files
  * types of special files (four)
    * block device files
    * character device files
    * named pipes (FIFO)
    * Unix domain sockets


