cobsha3 is a GnuCOBOL implementation of the SHA-3 standard.
Date-Written: 2016.05.17 
Author:       Laszlo Erdos - https://www.facebook.com/wortfee
================================================================================

Licensed under the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.

Introduction
============
SHA-3 (Secure Hash Algorithm 3), a subset of the cryptographic primitive family
Keccak. It is a cryptographic hash function. The SHA-3 standard was released 
by NIST on August 5, 2015, and the reference implementation source code was 
dedicated to public domain. [Ref. 1.] [Ref. 2.]

For detailed description of the used algorithm please see the 
Keccak-reference. [Ref. 3.]

What does it do?
----------------
SHA-3 can be used for example for password hashing or session-id creation.
With this GnuCOBOL implementation you get all SHA-3 functions as COBOL modules.
Calling these modules in your application is very easy. For usage examples
please see the test program: TESTSHA3.cob.

Requirements
------------
To run cobsha3 successfully you need a newer GnuCOBOL 2.0 version. I used
GnuCOBOL 2.0.0, branches [r885]. Older versions have some problems with 
BINARY-DOUBLE UNSIGNED data type.

Test
----
This program was developed and tested using:
- Windows 7 (64 bit) running on a HP laptop 
- GnuCOBOL 2.0.0, branches [r885], built on May 18 2016 
- cygwin (64 bit)
- With MS Visual Studio Express V12 (32 bit). 

Installation and Configuration
==============================

The delivered files:
- KECCAK.cob   - the KECCAK module (it will be called in SHA3 and SHAKE modules)
- makefile     - makefile for compiling under cygwin
- readme.txt   - this file
- SHA3-224.cob - computes SHA3-224 with 28 bytes output length
- SHA3-256.cob - computes SHA3-256 with 32 bytes output length
- SHA3-384.cob - computes SHA3-384 with 48 bytes output length
- SHA3-512.cob - computes SHA3-512 with 64 bytes output length
- SHAKE128.cob - computes SHAKE128 with any output length
- SHAKE256.cob - computes SHAKE256 with any output length
- TESTSHA3.cob - test program 
- win_compile.bat - Windows batch compile file    

- SESSION-ID.cob      - generates a session ID, it uses SHA3-256
- TEST-SESSION-ID.cob - test program

Compiling with cygwin
---------------------
Use the makefile.

Compiling with MS Visual Studio
-------------------------------
Use the batch file win_compile.bat. First change the batch compile file 
according to your environment.

Known Problems
==============
cobsha3 was developed and tested in a little-endian environment. There are
some issues with big-endian, because of redefines and BINARY-DOUBLE. 
Very important: Before you use cobsha3, you have to run the test program in
your environment, and then you have to check the results!

Change-log
==========
Program history, changes and bug fixes are listed in program headers.

References
==========
1. https://en.wikipedia.org/wiki/SHA-3
2. http://keccak.noekeon.org/
3. http://keccak.noekeon.org/Keccak-reference-3.0.pdf
