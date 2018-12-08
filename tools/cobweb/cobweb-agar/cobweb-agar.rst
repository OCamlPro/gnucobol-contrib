===========
cobweb-agar
===========

Agar is a cross-platform GUI toolkit.  cobweb-agar exposes some of the
functionality in libAgar as a set of GnuCOBOL user defined functions.


Installation
============

Agar
----

cobweb-agar is tested against libagar configured with --disable-threads.

::

    prompt$ ./configure --disable-threads
    prompt$ make depend all
    prompt$ sudo make install
    prompt$ sudo ldconfig

cobweb-agar also assumes, or the support utilities assume, /usr/local.

cobweb-agar.so
--------------

Build cobweb-agar.so with ``make``.  This builds a DSO (Dynamic Shared Object)
file that contains the cobweb-agar user defined function repository.  This can
be linked against, or for ease of use, just add cobweb-agar.cob to an
application ``cobc`` compile command.  cobweb-agar.so is also a command line
utility, using ``cobcrun``.

::

#indent make -s targets#

Makefile
--------

.. include:: Makefile
   :code: make

Usage
=====

cobweb-agar mixes GnuCOBOL User Defined Functions with direct access to some
libAgar features via the CALL verb.  This mix exposes all the powers of Agar
while also providing a fairly easy to use pure COBOL interface to common GUI,
networking, memory and file stream services.

Main module commands
--------------------

Run using::

    prompt$ cobcrun cobweb-agar [[command] [options]]

::

#indent cobcrun cobweb-agar help#

GUI
---

The graphical user interface features are rooted in the Agar Window.

``agar-window(position, width, height, title) to window-widget-record``

.. sourcecode:: cobolfree

    COPY AGAR-CONSTANTS.

    01 win-record.
       05 win usage pointer.

    01 extraneous usage binary-long.
    01 result-code usage binary-long.

    move agar-window(AG-WINDOW-CENTER, numval(640), numval(480), "Title") to win-record
    move agar-window-show(win) to extraneous
    move agar-eventloop() to result-code

.. note::

    numval() is used to properly transfer binary integers to the user defined
    function.  Literal numeric values in UDF arguments are treated as USAGE
    DISPLAY, and numval() ensures they are passed as USAGE BINARY.

::

#indent cobcrun cobweb-agar repo#


Label
.....

Labels are fixed or polled text entries.

Button
......

Buttons generate events that can callback into GnuCOBOL, passed an event
structure. The structure allows for naming *and* attaching a key value
variable list to the event processing routine.

Some care must be shown with the callback data scoping rules due to some C and
COBOL differences interfering with COBOL return values and other scoped name
mangling.

It can all work out though, and be easy on the eyes and mind.

There may be a patch to upstream libagar sources, to allow very simple ENTRY
point event handlers in source without worry of scoping and call frames.
