      *> Purpose   : REOPEN example and test program.
      *>
      *> Author    : Simon Sobisch <simonsobisch@gnu.org>
      *> Dedicated to the public domain.
      *>
      *> Written   : January 2022
      *>
      *> Tectonics : compile REOPEN, then this program and run it
      *>             prompt$ cobc REOPEN.c
      *>             prompt$ cobc -xj DISPTEST.cob
      *>         or  prompt$ cobc -x DISPTEST.cob && ./DISPTEST

       IDENTIFICATION DIVISION.
       PROGRAM-ID. 'DISPTEST'.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *> the following 
       01 stdout-name pic x(30) value z'+DISP.out'.
       01 stderr-name pic x(30) value 'DISP.$$.err' & x'00'.
       PROCEDURE DIVISION.
           DISPLAY 'STDOUT HERE'
           DISPLAY 'SYSERR HERE' UPON SYSERR
           call 'REOPEN' using stdout-name stderr-name
           DISPLAY 'SYSERR HERE AGAIN' UPON SYSERR
           DISPLAY 'STDOUT HERE - file''d'
           DISPLAY 'STDOUT AGAIN'
           call 'REOPEN' using z'CLOSE' NULL
           call 'REOPEN' using NULL z'CLOSE'
      *> the following _may- abort because stdout/stderr are closed,
      *> it _seems_ it just goes to nirvana
           DISPLAY 'SYSOUT CLOSED'
           DISPLAY 'SYSERR LAST TIME' UPON SYSERR
      *> note: the DOS CONERR$ doesn't work on MinGW or MSYS2 builds
           call 'REOPEN' using z'CONOUT$' NULL
           DISPLAY 'on the screen again'
      *>
           GOBACK.
