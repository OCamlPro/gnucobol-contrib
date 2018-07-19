DBsample/PostgreSQL is an example for using GnuCOBOL with PostgreSQL
====================================================================

Licensed under the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your 
option) any later version.

Introduction
============

What does it do?
----------------
This example shows you how to pre-compile and compile a GnuCOBOL program 
with embedded PostgreSQL. The focus lies on the PGMODx.cbl modules, and
not on the PGTESTx.cob test program. 

Requirements
------------
To compile and run this example you need a PostgreSQL database and the
Open-COBOL-ESQL-1.1 pre-compiler: https://github.com/opensourcecobol/Open-COBOL-ESQL
  
Features of DBsample/PostgreSQL
-------------------------------
The examples build on each other. This means that example2 includes example1,
and example3 includes example2, and so on. All examples use only one simple
SQL table, the BOOK table. With this BOOK table will simple SQL commands be
performed. 

Screen-shots
------------
There are some screen-shots for every example program.
See under DBsample/PostgreSQL/screenshots. 

Test
----
This program was developed and tested using:
- Windows 10 (64 bit) running on a HP laptop 
- GnuCOBOL 3.0-rc1.0, built on Jun 26 2018
- cygwin (64 bit)
- PostgreSQL 10.4 under cygwin (64 bit)
- Open-COBOL-ESQL-1.1 pre-compiler

Installation and Configuration
==============================

Directory structure
-------------------
DBsample\PostgreSQL\             -> main directory
DBsample\PostgreSQL\example1     -> connect to PostgreSQL / disconnect
DBsample\PostgreSQL\example2     -> select book
DBsample\PostgreSQL\example3     -> insert book
DBsample\PostgreSQL\example4     -> update book
DBsample\PostgreSQL\example5     -> delete book
DBsample\PostgreSQL\example6     -> paging (select first, next, previous, last)
DBsample\PostgreSQL\example7     -> list   (select first, next, previous, last)
DBsample\PostgreSQL\screenshots  -> screen-shots 
DBsample\PostgreSQL\SQLtable     -> scripts for creating table and inserting
                                    test data

In the example1 (this is similar for the other examples) 
there are the following files:
cygwin_compile1.sh          -> compile shell script for cygwin
cygwin_run_PGTEST1.sh       -> this shell script starts the test program 
LNMOD1.cpy                  -> linkage for the PostgreSQL module
LNSQLMSG.cpy                -> linkage for the SQL message module
PGMOD1.cbl                  -> PostgreSQL module
PGSQLMSG.cob                -> this module reads the SQL messages
PGTEST1.cob                 -> test program for the PostgreSQL module
STATETXT.cpy                -> PostgreSQL v10 SQLCODE/SQLSTATE Error Codes
                               
Compile and run
---------------
First of all you have to create the BOOK SQL table in your
PostgreSQL database, and after it fill the table with the test data. 
For this please see the SQL-scripts under DBsample\PostgreSQL\SQLtable.

For compiling and running under cygwin please use the provided files:
- cygwin_compilex.sh
- cygwin_run_PGTESTx.sh

For other environment you have to do some small changes in these
shell script files.


A few remarks about Open-COBOL-ESQL-1.1 pre-compiler
====================================================
- OCDB_LOGLEVEL environment variable (not documented):
  If OCDB_LOGLEVEL is set (eg. export OCDB_LOGLEVEL=DEBUG), 
  then the file ocesql.log is created under \tmp.
  Possible values:
  - nothing to set -> same as NOLOG
  - NOLOG or nolog
  - ERR or err
  - DEBUG or debug

- OCDB_DB_CHAR environment variable (not documented):
  If you do not set the OCDB_DB_CHAR environment variable,
  then "SJIS" will be used as default. See ocesql.c in 
  function _ocesqlConnectMain(). If it is not set, then there
  are errors for example at duplacate key.

- Working with cursors:  
  - Before Cursor declare we need a connection to DB.
  - A Cursor can not be declared in WORKING-STORAGE with ocesql.
  - We can not use the "WITH HOLD" option in cursor with ocesql.
  - There is no "WITH HOLD" option in cursor, therefore we need
    a commit after the fetch loop. Without commit, the next cursor
    declare is not successful.


Changelog
=========

Program history, changes and bug fixes are listed in program headers.


*****************************************************************************
Date       Name / Change description 
========== ==================================================================
2018.07.13 Laszlo Erdos: 
           - first version. 
*****************************************************************************
