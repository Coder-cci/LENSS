# SLICER
### File Slicer *for [FreeDOS](http://www.freedos.org)*

A simple file archiving and slicing/spanning program for DOS. Slicer is very
similar to tar. However, it has different primary focus and objectives.

**Copyright (c) 2019-2020, Jerome Shidel. All rights reserved.**

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

### How is *File Slicer* different?

Unlike other archiving utilities, *File Slicer* is more of a multi-language group
based file resource splitter, archiver and installer hybrid utility.

*Hunh?*

When files are added to an archive, they may be given group tags. These tags
can be used to pull only specific classes of files from the archive. For
example, if storing a program, you could tag source files as ***src*** and store
binaries ungrouped. Then on extraction, the binaries would always get extracted.
But, the sources files would only get extracted if the ***src*** group is is
requested.

Then the multi-language thing... Language specific text can be embedded into an
archive. This text may be displayed automatically during the extraction of an
archive and also supports group tags. So, you could embed English and Spanish
text at the start of a ***src*** group that gets displayed when the ***src***
group begins extraction.

Installer kinda stuff. Well, only to the extent that multi-language text can
be flagged whith the **/M** switch to require user acceptance. This would allow
a license to be displayed and accepted before a group is extracted.

A file splitter thingy. It always works in splitting mode. The size for each
file is defined when an archive is created and cannot be changed unless it
is re-sliced. The primary archive file always ends in **SAF** and additional files
are numbered **001** and up. The first portion of primary archive file's header is
in pure text and can be viewed by simply using the type command. If any
additional non-language specific text was appended to the header using the **/m**
switch, it will be shown as well.

### One more thing...

The FreeDOS installer for the Floppy Edition uses **SLICEREX** to perform the
installation of all the software packages. This is specially tuned version of
**SLICER** for the primary function of extracting FreeDOS under the extreme
memory limitations (everything loaded into low memory) that the Floppy Edition
operates. **SLICER/EX** is still very new. So if for whatever reason the
installation of packages fails, you can try again and turn on logging for
**SLICEREX** by setting an environment variable **SLICER.LOG**. This log
is gigantic and pushes 6mb under normal installations. It also really slows
down the installation process. When you set the variable to turn on logging,
I recommend using **set SLICER.LOG=C:\SLICER.LOG** for the file.
