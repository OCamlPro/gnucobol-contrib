DB2sample is an example for using GnuCOBOL with IBM DB2 SQL
===========================================================

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
  
Features of DB2sample
---------------------
The examples build on each other. This means that example2 includes example1,
and example3 includes example2, and so on. All examples use only one simple
SQL table, the BOOK table. With this BOOK table will simple SQL commands be
performed. 

Screen-shots
------------
There are some screen-shots for every example program.
See under DB2sample/screenshots. 

Test
----
This program was developed and tested using:
- Windows 7 (64 bit) running on a HP laptop 
- GnuCOBOL 2.0.0, built on Jan 19 2015
- cygwin (64 bit)
- IBM DB2 Express-C 10.5 for Win (64 bit)

Installation and Configuration
==============================

Directory structure
-------------------
DB2sample\                  -> main directory
DB2sample\example1          -> connect to DB2 / connect reset
DB2sample\example2          -> select book
DB2sample\example3          -> insert book
DB2sample\example4          -> update book
DB2sample\example5          -> delete book
DB2sample\example6          -> paging (select first, next, previous, last)
DB2sample\example7          -> list   (select first, next, previous, last)
DB2sample\screenshots       -> screen-shots 
DB2sample\SQLtable          -> scripts for creating table and inserting
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
For this please see the shell- and SQL-scripts under DB2sample\SQLtable.

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
*****************************************************************************
