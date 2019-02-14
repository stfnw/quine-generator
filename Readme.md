Quine generator
===============

Demo pre-generated example quine (assembly)
-------------------------------------------



Demo invocation of the generator (assembly)
-------------------------------------------


---

This project offers a generalized quine generator in both C and s390x assembly
language -- simply paste in your (almost) arbitrary existing code into the given
base-frame at `quine_generator_src/*/basis.{c,s}` and compile the project with
`make`.  Your code can then print the source code of the whole program by
invoking `print_src`.

Disclaimer: see [Resources](#resources-and-references) for the basic idea.

A [quine](https://en.wikipedia.org/wiki/Quine_(computing)) is a program which
takes no input and prints its own source code (without cheats or shortcuts like
e.g. opening the own source file etc.).

It can be implemented in every turing-complete programming language that has
the ability to print stuff; this is a direct consequence of Kleene's recursion
theorem.


Project structure
-----------------

  * **`quine_generator_src`** contains the actual generator for creating your
    own quines

  * **`quine_example_src`** contains pre-generated source code for two example
    quines


Resources and references
------------------------

The idea behind quines is commonly known and there are multiple well written
articles and tutorials about it on the internet.

In this instance the approach was directly copied from [this Quine
Tutorial](http://dwcope.freeshell.org/projects/quine/), but the specific quine
construction is a bit different, and manages without one intermediate step of a
quine generator program.

[This is a more in-depth
tutorial](http://www.madore.org/~david/computers/quine.html), describing a bit
of the theory behind it.

The book "Gödel, Escher, Bach: An Eternal Golden Braid" provides a fascinating
read on quines and self-reference in general.

Resources for IBM Z assembly: z/Architecture Principles of Operation

Resources for s390x assembly under linux specifically:

  * [Debugging on Linux for s/390 & z/Architecture](https://www.kernel.org/doc/Documentation/s390/Debugging390.txt)

  * [ELFApplicationBinaryInterface Supplement](http://legacy.redhat.com/pub/redhat/linux/7.1/es/os/s390x/doc/lzsabi0.pdf)

The s390x assembly was tested on the [IBM LinuxONE Community
Cloud](https://linuxone.cloud.marist.edu/cloud/#/register).  
But it can also easily be tested on x86:

  * Cross-compilation is possible with installing `binutils-s390x-linux-gnu` and
    simply replacing `as` with `s390x-linux-gnu-as`, and `ld` with
    `s390x-linux-gnu-ld` in the provided Makefiles.

  * Transparent execution of non-x86-binaries (just as usual, e.g. with
    `./quine`) is possible with installing qemu and its binary format handler
    `qemu-user-binfmt`.  This is very well described in [this
    article](https://ownyourbits.com/2018/06/13/transparently-running-binaries-from-any-architecture-in-linux-with-qemu-and-binfmt_misc/).
