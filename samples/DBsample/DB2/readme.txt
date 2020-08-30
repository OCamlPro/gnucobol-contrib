DBsample/DB2 is an example for using GnuCOBOL with IBM DB2 SQL
==============================================================

Licensed under the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.

Introduction
============

What does it do?
----------------
This example shows you how to pre-compile and compile a GnuCOBOL program 
with embedded IBM DB2 SQL. The focus lies on the DB2MODx.sqb modules, and
not on the DB2TESTx.cob test program. 

Requirements
------------
To compile and run this example you need an IBM DB2 database. For example
you can use the DB2 Express-C, the no-charge community edition of DB2 server.
  
Features of DBsample/DB2
------------------------
The examples build on each other. This means that example2 includes example1,
and example3 includes example2, and so on. All examples use only one simple
SQL table, the BOOK table. With this BOOK table will simple SQL commands be
performed. 

Screen-shots
------------
There are some screen-shots for every example program.
See under DBsample/DB2/screenshots. 

Test
----
This program was developed and tested using:
- Windows 7 (64 bit) running on a HP laptop 
- GnuCOBOL 2.0.0, built on Jan 19 2015
- cygwin (64 bit)
- IBM DB2 Express-C 10.5 for Win (64 bit)

Retested using:
- Windows 10 (64 bit) running on a HP laptop 
- GnuCOBOL 2.2.0, built on Sep 07 2017
- cygwin (64 bit)
- IBM DB2 Express-C 11.1 for Win (64 bit)

Retested using:
- Windows 10 (64 bit) running on a HP laptop 
- MinGW GnuCOBOL 3.1-rc1.0 (64 bit), built on Jul 09 2020, Packaged  Jul 01 2020
  C version (MinGW) "10.1.0"
- IBM DB2 Express-C 11.1 for Win (64 bit)

Installation and Configuration
==============================

Directory structure
-------------------
DBsample\DB2\               -> main directory
DBsample\DB2\example1       -> connect to DB2 / connect reset
DBsample\DB2\example2       -> select book
DBsample\DB2\example3       -> insert book
DBsample\DB2\example4       -> update book
DBsample\DB2\example5       -> delete book
DBsample\DB2\example6       -> paging (select first, next, previous, last)
DBsample\DB2\example7       -> list   (select first, next, previous, last)
DBsample\DB2\screenshots    -> screen-shots 
DBsample\DB2\SQLtable       -> scripts for creating table and inserting
                               test data

In the example1 (this is similar for the other examples) 
there are the following files:
cygwin_compile1.sh          -> compile shell script for cygwin
cygwin_run_DB2TEST1.sh      -> this shell script starts the test program 
db2_precompile1.sql         -> DB2 pre-compiler command
DB2MOD1.sqb                 -> DB2 module
DB2SQLMSG.cob               -> this module reads the SQL messages
DB2TEST1.cob                -> test program for the DB2 module
LNMOD1.cpy                  -> linkage for the DB2 module
LNSQLMSG.cpy                -> linkage for the SQL message module
                               
Compile and run
---------------
First of all you have to create the BOOK SQL table in your
DB2 database, and after it fill the table with the test data. 
For this please see the shell- and SQL-scripts under DBsample\DB2\SQLtable.

For compiling and running under cygwin please use the provided files:
- cygwin_compilex.sh
- cygwin_run_DB2TESTx.sh

For other environment you have to do some small changes in these
shell script files.


Changelog
=========

Program history, changes and bug fixes are listed in program headers.


*****************************************************************************
Date       Name / Change description 
========== ==================================================================
2015.12.24 Laszlo Erdos: 
           - first version. 
2017.10.03 Laszlo Erdos: 
           - Reserved word "AUTHOR" renamed to "AUTHORS". 
           - Table OCCURS TO error corrected.
2020.08.29 Laszlo Erdos: 
           - Compiler parameter -fnot-reserved=TITLE added.
2020.08.30 Laszlo Erdos: 
           - Compile and run script win_mingw added.
*****************************************************************************
