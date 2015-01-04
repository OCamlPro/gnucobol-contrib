COBJAPI a GnuCOBOL interface (wrapper) for JAPI
===============================================

This is a work in progress. 

Licensed under the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.


************************************************************************
Acknowledgement
===============
The author of JAPI is Dr. Merten Joost (University of Koblenz-Landau).   
Website of JAPI: http://www.japi.de

I would like to express my special thanks to Dr. Merten Joost who gave 
me the opportunity to do this contribution. He has sent me an updated 
version of the JAPI package, and he has replaced all the outdated Java 
functions with new ones. Even more, he has allowed the use and upload of
the JAPI package along with COBJAPI on SourceForge. The JAPI package
contains the Java programs, C programs, documentation, pictures and 
sound files for the examples.
************************************************************************


Introduction
============

What does it do?
----------------
COBJAPI is a collection of UDFs (User Defined Functions), it is an
interface to JAPI. With COBJAPI you can easily write GUI programs with
GnuCOBOL. There is no complicated OO theory and no pointer, only two 
data types (integers and text), and you can use the full Java AWT 
tool-kit. 

Requirements
------------
- Requires GnuCOBOL 2.0 or above as it makes extensive use of 
  FUNCTION-ID.
- If you use GnuCOBOL with MS Visual Studio, then you have to link the
  programs with the library WS2_32.Lib. This is the newer version of the
  wsock32.lib. The library WS2_32.Lib comes with the Windows SDK and not 
  with MS Visual Studio. (Windows SDKs are available free on the 
  Microsoft Download Center.)
- For compile: JDK (Java Development Kit) 1.7 or above, but you can also
  try it with older versions.
- For running: JRE (Java Runtime Environment) or JDK. 
  
Features of JAPI (from http://www.japi.de)
------------------------------------------
- JAPI is an open source free software GUI tool-kit, which makes it easy
  to develop platform independent applications. Written in JAVA and C, 
  it provides the JAVA AWT tool-kit to non object oriented languages.

- JAPI is free software. You can use under the conditions of the 
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
	
- JAPI is built on top of the AWT. The AWT (abstract windowing tool-kit)
  is part of the freely distributed Java Developer Tool-kit (JDK). The 
  AWT is composed of a package of classes and it supports everything
  from creating buttons, menus, and dialog boxes to complete GUI 
  applications. Notable, the AWT is platform independent. 
  
- The functionality of AWT is now brought to GnuCOBOL via JAPI.
  So you do not need to learn JAVA. All you need is a running Java 
  Runtime Environment (JRE) on your host. 

Screen-shots
------------
For every GnuCOBOL example program I have included screen-shots.
See under cobjapi/examples_simple/screenshots. 

Test
----
This program was developed using GnuCOBOL 2.0.0. 
Built Dec 03 2014 09:52:44 and Windows 7 (64 bit) running on a HP 
laptop. 
It was tested 
- with cygwin (64 bit) and Java version: 1.7.0_51 (64 bit).
- with MS Visual Studio Express V10 (32 bit) 
  and Java version: 1.7.0_51 (64 bit).


Installation and Configuration
==============================

Directory structure
-------------------
cobjapi                     -> main directory
cobjapi/doc                 -> programming and reference manual for JAPI
cobjapi/examples            -> this is a work in progress...
cobjapi/examples/texteditor -> text editor demo program
cobjapi/examples/video      -> video demo program
cobjapi/examples_simple     -> 48 simple GUI examples
                            
cobjapi/src_c               -> C programs for JAPI
cobjapi/src_cobol           -> GnuCOBOL functions for JAPI
cobjapi/src_java            -> Java programs for JAPI


Compile with cygwin
-------------------
Use the makefiles, first compile the sources, then the examples. 

Or compile with MS Visual Studio
--------------------------------
Change the batch compile files according to your environment.
Use the batch files, first compile the sources, then the examples. 
There are the following batch compile files:
- win_compile_src_c.bat
- win_compile_src_cobol.bat
- win_compile_src_java.bat
- win_compile_examples_simple.bat
- win_compile_texteditor.bat
- win_compile_video.bat

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
C:\Java\jdk1.7.0_51\bin 

Env. var.: 
COBJAPI_JAPIJAR_HOME=C:\cygwin64\home\Laszlo.Erdoes\cobjapi\src_java 


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
java -cp JAPI.jar JAPI 

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


Todo's
======

- Porting a few example programs.
- A complex example program with a data base and multiple windows.
- A COBOL screen section to JAPI converter.
- A GUI designer for JAPI.
- Add Java swing GUI components support to JAPI.


Changelog
=========

Program history, changes and bug fixes are listed in program headers.


*****************************************************************************
Date       Name / Change description 
========== ==================================================================
2014.12.24 Laszlo Erdos: 
           - GnuCOBOL support for JAPI added. 
-----------------------------------------------------------------------------
2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
           JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*****************************************************************************
