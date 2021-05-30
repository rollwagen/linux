# Linux

## Book [Linux System Programming (2nd ed)](https://www.oreilly.com/library/view/linux-system-programming/9781449341527/)

Notes from the book, with additional links and samples.
Regaring copy-pasting and compiling C-code samples: necessary `#includes` are in
the first sample of each section. For readability they are ommitted in following
samples. However, if the includes change (e.g. additional ones needed) they are
included in the code sample again.

[Essential Concepts](essential_concepts.md)

[Process Management](process_management.md)

[Memory Management](memory_management.md)

## Filesystem Hierarchy Standard (FHS)

Summary/notes/examples from going over the FHS: [Filesystem Hierarchy Standard](filesystem_hierarchy_standard.md)

## Convert to PDF

`pandoc.sh`:

```bash
for MDFILE in $(ls [a-z]*.md);
do
        BASEFILENAME=$(basename "$MDFILE" ".md")
        pandoc --variable geometry:margin=1.2cm --variable fontsize=10.5pt "$MDFILE" -o "$BASEFILENAME".pdf
done
```
