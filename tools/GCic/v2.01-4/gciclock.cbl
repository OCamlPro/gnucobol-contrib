       >>SOURCE FORMAT IS VARIABLE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. gciclock.
      *>************************************************************************
      *> Part of the GnuCOBOL Interactive Compiler package, this program will **
      *> create a lock file on behalf of the GCic instance that spawns it (by **
      *> "SYSTEM") as a background task.  Part of the lock file name is the   **
      *> name of the file being compiled by the parent GCic process.  This    **
      *> program then waits for the parent GCic process to terminate.  Once   **
      *> that happens, the lock file is deleted and this process terminates.  **
      *>                                                                      **
      *> As long as the lock file exists, no one may compile that file this   **
      *> program's parent is compiling.                                       **
      *>                                                                      **
      *> The syntax for this program's execution is as follows:               **
      *>                                                                      **
      *> gciclock filename pid                                                **
      *>          |        |                                                  **
      *>          |        +---- The process-id (PID) of the parent GCic      **
      *>          +------------- The fully-qualified lock file name           **
      *>************************************************************************
      *> AUTHOR:       Gary L. Cutler (GLC)                                   **
      *>               Copyright (C) 2022, Gary L. Cutler, GPL                **
      *> DATE-WRITTEN: June 14, 2009                                          **
      *> LAST-UPDATED: September, 2022                                        **
      *>************************************************************************
      *> CHANGE HISTORY                                                       **
      *>************************************************************************
      *> CHG ID Who Description                                               **
      *> ====== === ========================================================= **
      *> GC0922 GLC Original version                                          **
      *>************************************************************************
       ENVIRONMENT DIVISION.
      *> Cobc Switches: -x -std=default
LOCAL *> On Success:                          Set-Icon    gciclock.exe     gciclock.ico           gciclock.lst
LOCAL *> On Success:                          PromoteToP  \GnuCOBOL\extras gciclock.cbl COPYSTRIP gciclock.lst
LOCAL *> On Success:                          PromoteToP  \GnuCOBOL\extras gciclock.ico COPY      gciclock.lst
LOCAL *> On Success:                          PromoteToP  \GnuCOBOL\bin    gciclock.exe COPY      gciclock.lst
LOCAL *> On Success:                          Promote     extras           gciclock.cbl COPYSTRIP gciclock.lst
LOCAL *> On Success:                          Promote     extras           gciclock.ico COPY      gciclock.lst
LOCAL *> On Success:    START /MIN cmd.exe /C Promote     bin              gciclock.exe MOVEWAIT  gciclock.lst
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT Lock-File            ASSIGN TO Lock-Filename
                                       ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.

       FD  Lock-File.
       01  Lock-Record                 PIC X(80).

       WORKING-STORAGE SECTION.
       01  Arg2                        PIC X(12).          *> PID value (character).

       01  Lock-Filename               PIC X(256).         *> Fully-qualified. name of the lock file

       01  NArgs                       PIC 9(2).           *> Total # of args specified on the command line

       01  PID                         USAGE BINARY-LONG.  *> "Arg2" converted to COMP form

       PROCEDURE DIVISION.
       000-Main.
      *>************************************************************************
      *> Validate argument count                                              **
      *>************************************************************************
           ACCEPT NArgs FROM ARGUMENT-NUMBER END-ACCEPT
           IF NArgs NOT = 2
               STOP RUN
           END-IF
      *>************************************************************************
      *> Get argument 1 - lock filename                                       **
      *>************************************************************************
           DISPLAY 1 UPON ARGUMENT-NUMBER END-DISPLAY
           ACCEPT Lock-Filename FROM ARGUMENT-VALUE END-ACCEPT
      *>************************************************************************
      *> Get argument 2 - PID to wait on                                      **
      *>************************************************************************
           DISPLAY 2 UPON ARGUMENT-NUMBER END-DISPLAY
           ACCEPT ARG2 FROM ARGUMENT-VALUE END-ACCEPT
           IF TEST-NUMVAL(Arg2) = 0
               MOVE NUMVAL(Arg2) TO PID
           END-IF
      *>************************************************************************
      *> Create the lock file                                                 **
      *>************************************************************************
           OPEN OUTPUT Lock-File
           CLOSE Lock-File
           DISPLAY "GnuCOBOL Interactive Compiler (GCic) Lock Monitor" UPON SYSOUT END-DISPLAY
           DISPLAY " "                                                 UPON SYSOUT END-DISPLAY
           DISPLAY "Lock File: " TRIM(Lock-Filename)                   UPON SYSOUT END-DISPLAY
           DISPLAY "GCic PID:  " TRIM(Arg2)                            UPON SYSOUT END-DISPLAY
           DISPLAY " "                                                 UPON SYSOUT END-DISPLAY
           DISPLAY "DO NOT CLOSE THIS WINDOW"                          UPON SYSOUT END-DISPLAY
      *>************************************************************************
      *> Wait for the process to finish                                       **
      *>************************************************************************
           CALL "CBL_GC_WAITPID" USING PID END-CALL
      *>************************************************************************
      *> We're awake again, so delete the lock file                           **
      *>************************************************************************
           CALL "CBL_DELETE_FILE" USING Lock-Filename
           STOP RUN
           .
