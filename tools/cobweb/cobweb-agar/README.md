cobweb-agar
===========

**cobweb-agar** is a [GnuCOBOL] function repository interface to [Agar].

**Agar** (or libagar) is a cross-platform GUI toolkit. Agar provides a base
framework, a utility suite, and a set of widgets from which applications can
be built. Supports X11, Windows, MacOS X, and other graphic engine drivers via
SDL or OpenGL (including SDL framebuffers with or without a window manager).

Getting started
---------------

Install Agar.  http://www.libagar.org/download.html  1.5.0 preferred.

- http://www.libagar.org/docs/
- http://www.libagar.org/docs/inst/linux.html

Get the contribution.

    prompt$ svn checkout svn://svn.code.sf.net/p/open-cobol/contrib/ contrib

Copy contrib/trunk/tools/cobweb/cobweb-agar to a comfortable working
directory.

In cobweb-agar

    prompt$ make
    prompt$ make basic
    prompt$ make test
    prompt$ make template


Commands
--------

**cobweb-agar** is a DSO repository and a command line module, via `cobcrun`
that includes a small command option handler. To display the command line
options use

    prompt$ cobcrun cobweb-agar --help

To display a full list of help topics, use:

    prompt$ cobcrun cobweb-agar help list

UDF Repository
--------------

The main goal of **cobweb-agar** is for GnuCOBOL GUI application development.
One of the command options is `cobcrun cobweb-agar --repository` which displays
the available COBOL REPOSITORY of user defined functions.

*Subject to change from what was captured here*

    prompt$ cobcrun cobweb-agar repo

    repository.
           function agar-window 
           function agar-windowshow 
           function agar-windowhide 
           function agar-zoom 
           function agar-setevent 
           function agar-eventname 
           function agar-setevent-with-field 
           function agar-eventloop 
           function agar-box 
           function agar-label 
           function agar-button 
           function agar-checkbox 
           function agar-textbox 
           function agar-combo 
           function agar-close-datasource 
           function agar-console 
           function agar-consolemsg 
           function agar-dirdlg 
           function agar-editable 
           function agar-execute 
           function agar-filedlg 
           function agar-fixed 
           function agar-fixed-put 
           function agar-fixed-del 
           function agar-fixed-size 
           function agar-fixed-move 
           function agar-fixedplotter 
           function agar-fixedplottercurve 
           function agar-fixedplotterdatum 
           function agar-fontselector 
           function agar-bindvariable 
           function agar-get-error 
           function agar-get-error-pic 
           function agar-graph 
           function agar-graphvertex 
           function agar-graphvertex-label 
           function agar-graphvertex-position 
           function agar-graphedge 
           function agar-graphedge-label 
           function agar-hsvpal 
           function agar-kill-process 
           function agar-menu 
           function agar-menunode 
           function agar-menuaction 
           function agar-mpane 
           function agar-netsocket 
           function agar-netsocketfree 
           function agar-netsocketset 
           function agar-netsocketset-add 
           function agar-netsocketset-first 
           function agar-netsocketset-next 
           function agar-netpoll 
           function agar-netresolve 
           function agar-netconnect 
           function agar-netbind 
           function agar-netaccept 
           function agar-netclose 
           function agar-netread 
           function agar-netread-pic 
           function agar-netwrite 
           function agar-netwrite-pic 
           function agar-notebook 
           function agar-notebook-add 
           function agar-numerical 
           function agar-open-core 
           function agar-open-core-pic 
           function agar-open-file 
           function agar-open-filehandle 
           function agar-open-netsocket 
           function agar-pane 
           function agar-pixmap 
           function agar-pixmap-file 
           function agar-pixmap-surface 
           function agar-pixmap-surface-scaled
           function agar-progressbar
           function agar-radio
           function agar-scrollview
           function agar-separator
           function agar-set-style
           function agar-slider
           function agar-socket
           function agar-static-icon
           function agar-table
           function agar-timer
           function agar-tlist-add
           function agar-treetbl
           function agar-read
           function agar-read-pic
           function agar-read-at
           function agar-read-at-pic
           function agar-wait-on-process
           function agar-widget-focus
           function agar-widget-unfocus
           function agar-write
           function agar-write-pic
           function agar-write-at
           function agar-write-at-pic

Output is in a form that can be copied right into the configuration section of
the environment division.

gcv, commands.sed
-----------------
In order to alleviate some of the hurdles involved in cross-platform COBOL/C
mixing, a small utility is included called Get C Value, **gcv**.  `gcv` writes
small, on the fly, C programs to extract pertinent information from C for use
in COBOL source. First argument is an expression (such as 'sizeof(field)')
followed by a list of C header includes that might be required to get at the
field declaration. Set CFLAGS before calling `gcv` if you need to set any
include search path overrides.

This utility is paired with a small GNU `sed` script, **commands.sed**, that
acts as a text pre-processor by leveraging the `e` (eval) extension of the
`sed` `s` (substitute) command and some custom keywords in the source text
which are surrounded by double square brackets.

During installation, `libagar.gcv` is processed to produce `libagar.cpy` using
the local C compiler to guarantee proper cross-platform GnuCOBOL use of
**libagar**. This creates a site specific `libagar.cpy` COBOL copy book to
ensure proper data widths and structure alignments for the machine used to
compile **cobweb-agar** GnuCOBOL applications.

As an example.  The inner text box field of the `AG_Editable` widget is
at offset 732 for a 32 bit machine, and at offset 800 for a 64 bit build of
libagar 1.5.0.

The `gcv` commands.sed pass will be required if *any* of the cobweb-agar,
libagar or operating system sources are updated between compiles.

A possible future version of GnuCOBOL will hide all of this in a `cobc`
command (access to external pre-processors from within `cobc`); but for now
creating a platform specific `libagar.cpy` is a site local responsibility
placed on the developer.

Template
--------
**cobweb-agar** includes a small starter kit, via `cobcrun cobweb-agar new`
which generates a small COBOL program source file, for a quick leg up on GUI
programming with GnuCOBOL and Agar.

Self testing
------------
**cobweb-agar** also includes a few test heads and demos, via `cobcrun
cobweb-agar test`, or `cobcrun cobweb-agar starter`.

Features
--------
libAgar is feature rich.

- a full suite of GUI widgets
- a complete "object" access system
- event handling, including user defined variable slots
- eventloop, with callbacks to C functions or COBOL subprograms
- interactive graphs
- plotting of integral data
- fixed position widgets and text
- icons, pixel maps and graphic surfaces
- dialogs for file, directory, font and colour selection
- font management
- colour management
- character encoding transforms (UTF-8, UCS-2, ASCII, ...)
- a logging console supporting clipboard access
- a cross-platform network API
- portable process query, control and program execution
- timers
- data sources with persistent serialization features
- database access; Berkeley hash, Berkeley tree, MySQL/MariaDB
- unit conversions (feet to metres for example)
- portable access to file systems
- a configuration module
- error handling
- keyboard and mouse routines
- vector graphics
- 3d math, including a general purpose plotter
- audio
- so much more...

The next release (Agar 1.5.1, not out yet), has a full Web application
framework available; coming soon.

Anything not covered by the **cobweb-agar** COBOL functions can be accessed
via `CALL` to libagar routines.

Example
-------

~~~
::cobolfree

       identification division.
       program-id. hello.

       environment division.
       configuration section.
       repository.
           COPY cobweb-agar-repository.
           function all intrinsic.

       data division.
       working-storage section.
       COPY libagar.

       01 win-record.
          05 win usage pointer.
       01 place-holder.
          05 filler usage pointer.
       01 extraneous usage binary-long.

       procedure division.

       move agar-window(AG-WINDOW-CENTER, numval(160), numval(40), "Hello") to win-record
       move agar-label(win, AG-LABEL-HFILL, "Hello, world") to place-holder
       move agar-window-show(win) to extraneous
       move agar-eventloop() to extraneous

       goback.
       end program hello.
~~~

[GnuCOBOL]: https://sourceforge.net/projects/open-cobol/
[Agar]: http://www.libagar.org
