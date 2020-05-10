COBJAPI a GnuCOBOL interface (wrapper) for JAPI 2
=================================================

COBJAPI is free software: you can redistribute it and/or modify it under the
terms of the GNU Lesser General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

COBJAPI is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along
with COBJAPI in the file COPYING. If not, see <http://www.gnu.org/licenses/>.


************************************************************************
Acknowledgment
===============
The author of JAPI is Dr. Merten Joost (University of Koblenz-Landau).
Website of JAPI: https://userpages.uni-koblenz.de/~evol/japi/japi.html

I would like to express my special thanks to Dr. Merten Joost who gave
me the opportunity to do this contribution. He has sent me an updated
version of the JAPI package, and he has replaced all the outdated Java
functions with new ones. Even more, he has allowed the use and upload of
the JAPI package along with COBJAPI on SourceForge. The JAPI package
contains the Java programs, C programs, documentation, pictures and
sound files for the examples.

The newer Japi 2 kernel was created by Vera Christ, Daniel Vivas Estevao
and Maximilian Strauch in 2015. The SWING GUI toolkit providing more
modern GUI elements and features.
https://userpages.uni-koblenz.de/~evol/japi/japi2/japi.html
https://github.com/maxstrauch/Japi2-kernel

Japi and Japi 2 kernel are free software and licensed under the terms and
conditions of the GNU Lesser General Public License.
In short this means that you can use it free of charge and you can also embed
it into proprietary, non-free software.
This program is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
************************************************************************


Introduction
============

What does it do?
----------------
COBJAPI is a collection of UDFs (User Defined Functions), it is an
interface to JAPI 2. With COBJAPI you can easily write GUI programs with
GnuCOBOL. There is no complicated OO theory and no pointer, only two
data types (integers and text), and you can use the Java SWING tool-kit.

Requirements
------------
- Requires GnuCOBOL 2.0 or above as it makes extensive use of
  FUNCTION-ID.
- If you use GnuCOBOL with MS Visual Studio, then you have to link the
  programs with the library WS2_32.Lib. This is the newer version of the
  wsock32.lib. The library WS2_32.Lib comes with the Windows SDK and not
  with MS Visual Studio. (Windows SDKs are available free on the
  Microsoft Download Center.)
- For compile: JDK (Java Development Kit) 1.7 or above.
- For running: JRE (Java Runtime Environment) or JDK.

Features of JAPI 2
------------------
- JAPI 2 is an open source free software GUI tool-kit, which makes it easy
  to develop platform independent applications. Written in JAVA and C,
  it provides the JAVA SWING tool-kit to non object oriented languages.

- JAPI 2 is free software. You can use under the conditions of the
  GNU Lesser General Public License. In short this means that you can
  use it free of charge and you can also embed it into proprietary,
  non-free software.

- Easy to learn and use. It is easier to learn and use than all common
  APIs. Since its not object-oriented, it is possible to learn it even
  with little experience in programming. Even beginners with little
  experience in programming are now able to write their first
  applications with graphical user interfaces.

- Platform independent. Currently supports all Windows platforms, Linux
  and Solaris. Porting your application between platforms is as easy as
  recompiling.

- JAPI 2 is built on top of the SWING. The SWING is part of the freely
  distributed Java Developer Tool-kit (JDK). The SWING is composed of
  a package of classes and it supports everything from creating buttons,
  menus, and dialog boxes to complete GUI applications. Notable, the SWING
  is platform independent.

- The functionality of SWING is now brought to GnuCOBOL via JAPI 2.
  So you do not need to learn JAVA. All you need is a running Java
  Runtime Environment (JRE) on your host.

Screen-shots
------------
For every GnuCOBOL example program I have included screen-shots.
See under examples_simple/screenshots.

Test
----
This program was developed using GnuCOBOL 2.2.0.
Built Dec 09 2017 14:45:54 and Windows 10 (64 bit) running on a HP laptop.
It was tested
- with cygwin (64 bit) and Java version: 1.8.0_161 (64 bit).


Installation and Configuration
==============================

Directory structure
-------------------
SWING                     -> main directory
SWING/examples/...        -> examples
SWING/examples_simple     -> simple GUI examples

SWING/src_c               -> C programs for JAPI 2
SWING/src_cobol           -> GnuCOBOL functions for JAPI 2
SWING/src_java            -> Java programs for JAPI 2
                             Java doc: src_java/dist/javadoc/index.html


Compile with linux or cygwin
----------------------------
Use the makefiles, first compile the sources, then the examples.

There are recursive make files on every directory levels. That means, you can
compile all programs if you start the make file in the cobjapi main directory.

With make you can use the following options (please see the make file):
Usage: make [DEBUG=Y] [VERBOSE=Y] [COBFLAGS=-Wno-unfinished] [CFLAGS=-Wno-unused-result]


Compile with MinGW 32 or 64 bit (MinGW packages provided by Arnold)
-------------------------------------------------------------------
Change the batch compile files according to your environment (32 or 64 bit).
Use the batch files, first compile the sources, then the examples.
There are the following batch compile files for MinGW:
- win_mingw_compile_src_c.bat
- win_mingw_compile_src_cobol.bat
- win_compile_src_java.bat   (this is only java compile, independent from MinGW)

- win_mingw_compile_examples_simple.bat
- win_mingw_compile_colorpicker.bat
- win_mingw_compile_digits.bat
- win_mingw_compile_drawables.bat
- win_mingw_compile_imageviewer.bat
- win_mingw_compile_mandelbrot.bat
- win_mingw_compile_texteditor.bat
- win_mingw_compile_thinclient.bat
- win_mingw_compile_video.bat


Compile with MS Visual Studio
-----------------------------
Change the batch compile files according to your environment.
Use the batch files, first compile the sources, then the examples.
There are the following batch compile files for MS Visual Studio:
- win_msvs_compile_src_c.bat
- win_msvs_compile_src_cobol.bat
- win_compile_src_java.bat   (this is only java compile, independent from msvs)

- win_msvs_compile_examples_simple.bat
- win_msvs_compile_colorpicker.bat
- win_msvs_compile_digits.bat
- win_msvs_compile_drawables.bat
- win_msvs_compile_imageviewer.bat
- win_msvs_compile_mandelbrot.bat
- win_msvs_compile_texteditor.bat
- win_msvs_compile_thinclient.bat
- win_msvs_compile_video.bat


Configuration
-------------
- The japilib.c program uses the C function spawnvp(). This function
  looks up the PATH for a Java runtime. Therefore you have to configure
  a JDK or JRE bin directory in PATH.
- After compilation, you have created the JAPI.jar file. For the
  location of this file you have to set an environment variable
  COBJAPI_JAPIJAR_HOME.

Please set your PATH and the environment variable, example on windows:
In PATH:
C:\Java\jdk1.8.0_144\bin

Env. var.:
COBJAPI_JAPIJAR_HOME=C:\cygwin64\home\laszlo.erdoes\cobjapi\SWING\src_java


Usage
=====

How does it work?
-----------------
If you start a GnuCOBOL GUI Program, then there is the following
calling sequence and communication:

myprog.cob ---> cobjapi.cob ---> japilib.c ---> JAPI.jar
            1.               2.             3.

1. myprog.cob calls the UDFs (User Defined Functions) in cobjapi.cob.

2. The UDFs (User Defined Functions) calls the C functions in japilib.c.

3. The japilib.c program sends a message over TCP/IP to JAPI.jar


The japilib.c program checks if a JAPI.jar is already running. If not,
then it starts a new JAPI.jar.

But you can also start a JAPI.jar manually by running:
java -jar japi2.jar

(For start parameters please read the docs under SWING/src_java.)

Therefore, it is possible that your program and the GUI (JAPI.jar)
run on different computers and communicate via TCP/IP. See the
functions J-CONNECT() and J-SETPORT() for this scenario.

The default port number is 5089. It is hard coded in japi_p.h and in
JAPI_Calls.java files.

Important: If you start your program the first time, you might get a
warning security message from your OS. You have to allow to run
your program.

Programming
-----------
There are two useful COBOL copy files in the src_cobol directory:
- cobjapifn.cpy - includes all functions, place this file
                  in your CONFIGURATION SECTION under REPOSITORY.
- cobjapi.cpy   - pre-defined constants for the GUI, place this file
                  in your WORKING-STORAGE SECTION.

First compile and study the programs under examples_simple.

Troubleshooting
---------------
The J-SETDEBUG() function opens a debug window. Here you can see the
communication over TCP/IP. You can set various debug levels (max. 5).
Try this, and activate these lines in an example program.

MOVE 5 TO WS-DEBUG-LEVEL
MOVE J-SETDEBUG(WS-DEBUG-LEVEL) TO WS-RET


Known Problems
==============

At the moment there are two bugs and a wish for UDFs (User Defined
Functions). See the tickets.

Bug #112 UDF does not work with numeric literal
-----------------------------------------------
Example:

This does not work:
MOVE J-SETSIZE(WS-BUTTON, 80, 20) TO WS-RET

You must use variables in the functions:
MOVE 80 TO WS-WIDTH
MOVE 20 TO WS-HEIGHT
MOVE J-SETSIZE(WS-BUTTON, WS-WIDTH, WS-HEIGHT) TO WS-RET

Bug #113 UDF does not work with arithmetic expression
-----------------------------------------------------
Example:

This does not work:
MOVE J-SETSIZE(WS-BUTTON, 80 + X, 20 + Y) TO WS-RET

Wish #50 UDF without return value
---------------------------------
Example:

The function J-SETSIZE gives no return value back, but I have to define
a return variable. I would like to write only this in my program:

"J-SETSIZE(WS-BUTTON, 80, 20)"

and not this:

"MOVE J-SETSIZE(WS-BUTTON, 80, 20) TO WS-RET"


Changelog
=========

Program history, changes and bug fixes are listed in program headers.


*****************************************************************************
Date       Name / Change description
========== ==================================================================
2020.05.10 Laszlo Erdos:
           - New component Japi2FormattedTextField added.
-----------------------------------------------------------------------------
2018.03.13 Laszlo Erdos:
           - GnuCOBOL support for JAPI 2 added.
-----------------------------------------------------------------------------
2014.12.24 Laszlo Erdos:
           - GnuCOBOL support for JAPI added.
-----------------------------------------------------------------------------
2003.02.26 This comment is only for History. The latest Version (V1.0.6) of
           JAPI was released on 02/26/2003. Homepage: http://www.japi.de
*****************************************************************************
