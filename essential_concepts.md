
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

  * **device files** - two groups 1. _character devices_ and 2. _block devices_
    * character device - linear queue of bytes
    * block device - (accessed as) an array of bytes

  * **names pipes** (or **FIFO**)
    * Named pipes are an interprocess communication (IPC)
    * communication channel over a fd (file descriptor), accessed via a special file

  * **sockets** (Unix domain sockets)
    * advanced form of IPC (interprocess communication), multiple varieties
    * communication between two different processes; on same of different machines
    * _Unix domain socket_ = form of socket used for communication within the local machine


## filesystem and namespaces
  * _unified namespace_ in Linux/Unix (e.g. in Windows drives have a separate namespace such as `A:\`
  * _filesystem_ =  collection of files and directories in a hierarchy
  * _mount_ / _unmount_ - adding/removing a filesystem to global namespace
  * filesystems...
    * _physical_ - stored on disk
    * _virtual_ - only exist in memory
    * _network_ - exist on machines across network

  * _sector_ - smallest addressable unit on a block device; pysical attribute of device; physical attr. of a device
  * _block_ - smallest logically addressable unit on a filesystem
    * usually a power-of-two multiple of the sector size
    * generally larger than sector
      * note: must be smaller than _page size_ (smallest unit addressable by the _memory management unit_ [artificial kernel limitation for simplicity, might go away])

  * see [Queue sysfs files](https://www.kernel.org/doc/html/latest/block/queue-sysfs.html)
    * **hw_sector_size (RO)** - hardware sector size of the device, in bytes.
    ```bash
      $ cat /sys/block/dm-0/queue/hw_sector_size
      512
      # block size
      $ sudo blockdev --getbsz /dev/dm-0
      4096
      $ stat -f .
      Block size: 4096       Fundamental block size: 4096
      Blocks: Total: 3724026    Free: 2246906    Available: 2052807
      Inodes: Total: 950272     Free: 794298
    ```

  * _per-process namespaces_ by default, each process inherits the namespace of parent; a process may create its own namespace with own set of mount points and a unique root directory.


## processes
  * _processes_ are object code in executing /  active, running programs, consisting of
    * object code
    * data
    * resources
    * state
    * a virtualized computer
  * **ELF** _Excecutable and Linkable Format_; machine-runnable code in executable format kernel understands, contains:
    * metadata
    * multiple _sections_ of code and data
  * ELF **sections** - linear chunks of obj code, all bytes in a section are treated the same (permission etc)
    * _text section_ - executable code and read-only data (e.g. constands); read-only
    * _data sections_ - initialized data e.g. C variables with defined values; read-write
    * _bss section__ - uninitialized global data to be initialized (optimization) by _zero page_
    * _absolute section_ - nonrelocatable symbols
    * _undefined section_ - (catchall)
  * process **resources**
    * managed by kernel
    * resource manipulation through system calls
    * examples: timers, pending signals, open files, network connections, IPC, ..

  * **process descriptor** - inside kernel sotere for process resources, data, statistics, ..

  * a process is a **virtualization abstraction** - kernel supporting boht preemptive multitasking and virtual memory 
    * each process is afforded a single linear address space, as if it alone were in control of all of system memory
 

  * **threads**
    * each process consists of one or more _threads_ ('thread of execution')
    * _thread_ = the unit of activity within a process
    * a _thread_ consists of
      * a stack (stores local variables)
      * processor status
      * current location of object code (usually processor's _instruction pointer_) 
    * shared with process:
      * address space; thread share same virtual memory abstraction
    * kernel internal - views thread as normal processes to share some resources


  * **process hierarchy**
    * each process is identified by unique positive integer _process ID_
    * processes form a strict hierarcy, the _process tree_
    * PID = 1 first process or _init process_
    * new processes created via the `fork()` syscall
      * creates a duplicate of the calling (=parent) process
      * original process = _parent_, new process = _child_
      * child processes inherit the uids of their parents.
      * _reparenting_ - if parent terminates before child, kernel will _reparent_ child to init process
    * a process is not immediately removed, instead kernel keeps part in memory to allow parent to inquiry about staus `wait()` 
      * WAIT(2) "...In the case of a terminated child,
       performing a wait allows the system to release the resources associated with the child; if a wait  is  not  per‐
       formed, then the terminated child remains in a "zombie" state ..."

## users and groups
  * _authorization_ in Linux is provided by _users_ and _groups_
  * _user ID_ (uid) - unique positive int associated with user
    * each process in turn associated with one uid; called process _real uid_
  * uid 0 = _root_
  * earch user has a _primary_ or _login group_ (listed in `/etc/passwd`); _supplemental groups_ are in `/etc/groups`

## permissions
  * each file is associated with
    * an owning user
    * an owning group
    * three sets of permission bits

## signals
  * _signals_ - mechanism for one-way asynchronous notification
  * typically alert a process about some event; about 30 signals implemented in kernel
  * may be sent from:
   * kernel to process
   * process to another process
   * process to itself
  * each signal is represented by a numeric constanct and a textual name
  * some examples
| Signal | Value | Comment
|:------:|:-----:|--------
|SIGHUP  |   1   |  Hangup detected on controlling terminal
|SIGINT  |   2   |  Interrupt from keyboard
|SIGKILL |   9   |  Kill signal
  * signals interrupt a process, causing it to stop whatever it is doing and immediately perform a predetermined action
  * processes may control what happens when receiving a signal
    * exceptions `SIGKILL` (always terminates) and `SIGSTOP` (always stops) processes

## interprocess communication
  * IPC mechanisms supported by Linux include:
    * pipes
    * named pipes
    * semaphores
    * message queues
    * shared memory
    * futexes


