# Linux/Unix concepts, kernel internals etc

## Notes / Summaries

[Essential Concepts](essential_concepts.md) ([pdf](pdfs/essential_concepts.pdf))

[Filesystem Hierarchy Standard (FHS)](filesystem_hierarchy_standard.md) ([pdf](pdfs/filesystem_hierarchy_standard.pdf))

[Process Management](process_management.md) ([pdf](pdfs/process_management.pdf))

[Scheduling](scheduling.md) ([pdf](pdfs/scheduling.pdf))

[Memory Management](memory_management.md) ([pdf](pdfs/memory_management.pdf))

[Multithreading / Synchronization](threading.md) ([pdf](pdfs/threading.pdf))

### Code samples

Regaring copy-pasting and compiling C-code samples: necessary `#includes` are in
the first sample of each section. For readability they are ommitted in following
samples. However, if the includes change (e.g. additional ones needed) they are
included in the code sample again.

### Sources / Books

The notes/summaries are mostly from the following books:

* [Linux System Programming (2nd ed)](https://www.oreilly.com/library/view/linux-system-programming/9781449341527/)
* [Linux Kernel Development](https://www.oreilly.com/library/view/linux-kernel-development/9780768696974/)
* [Operating-System-Concepts](https://codex.cs.yale.edu/avi/os-book/)

## All in one pdf

All the above sections (.md files) in one printable [pdf](pdfs/linux.pdf)

## Convert to PDF

`pandoc.sh`:

```bash
for MDFILE in $(ls [a-z]*.md);
do
        BASEFILENAME=$(basename "$MDFILE" ".md")
        pandoc --variable geometry:margin=1.2cm --variable fontsize=10.5pt "$MDFILE" -o "$BASEFILENAME".pdf
done
```
