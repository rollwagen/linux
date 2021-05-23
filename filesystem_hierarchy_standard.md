# Filesystem Hierarchy Standard (FHS)

[FHS Specification Series](https://refspecs.linuxfoundation.org/fhs.shtml)

* based on two independent distinctions:
  * shareable vs. unshareable
  * variable vs. static
  * example:
    * _sharable_: user home dirs are shareable, device lock files not
    * _static_: binaries, libraries; files that do not change without system admin invtervention

## root filesystem

| dir  |  description                 |
|------|------------------------------|
|bin   |   Essential command binaries |
|boot  |   Static files of the boot loader |
|dev   |   Device files |
|etc   |   Host-specific system configuration |
|lib   |   Essential shared libraries and kernel modules (in subdir/link `moduels`) |
|media |   Mount point for removable media |
|mnt   |   Mount point for mounting a filesystem temporarily |
|opt   |   Add-on application software packages |
|run   |   Data relevant to running processes |
|sbin  |   Essential (vital) system binaries and root-only commands |
|srv   |   Data for services provided by this system |
|tmp   |   Temporary files |
|usr   |   Secondary hierarchy |
|var   |   Variable data |

* Examples:
  ```bash
  /run/sshd.pid
  $ ls /srv/
  ftp  http
  ```
* Optional:
  * `/home` user home dirs
  * `/root` home dir for root user
  * `/lib<qual>` alternate format essential libraries, e.g.
    ```bash
    $ ls /lib
    lib/   lib64/
    ```
* **/run**

> The purposes of this directory were once served by `/var/run`.
> In general, programs may continue to use `/var/run` to fulfill
> the requirements set out for /run for the purposes of backwards compatibility.
E.g. on both Ubuntu and ArchLinux

```bash
$ ls -ld /var/run
lrwxrwxrwx 6 root 19 Jan 02:32 /var/run -> ../run
```

* **/tmp**

> Programs must not assume that any files or directories in `/tmp`
> are preserved between invocations of the program.

### /usr

| dir  |  description                 |
|------|------------------------------|
|bin   | Most user commands |
|lib   | Libraries |
|local | Local hierarchy (empty after main installation) |
|sbin  | Non-vital system binaries |
|share | Architecture-independent data |

* Optional:
  * `games` games and educational binaries
  * `include` header files included by C programs
  * `libexec` binaries run by other programs
  * `lib<qual>` alternate Format Libraries
  * `src` source code

* **/urs/bin**

> primary directory of executable commands on the system.
E.g. python, perl, etc \
_/bin_ contains _essential_ user command binaries such as `mount`, `rm`, `ls` etc

? /var/tmp vs /tmp
