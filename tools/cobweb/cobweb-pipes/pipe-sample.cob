GCobol >>SOURCE FORMAT IS FREE
>>IF docpass NOT DEFINED
      *> ***************************************************************
      *>****P* cobweb/pipes
      *> AUTHOR
      *>     Brian Tiffin
      *> DATE
      *>     20150217
      *> LICENSE
      *>     GNU General Public License, GPL, 3.0 (or greater)
      *> PURPOSE
      *>     Purpose: pipe execute and read or write
      *> TECTONICS
      *>     cobc -x pipe-sample.cob cobweb-pipes.cob -g -debug
      *> or: cobc -x -DWIN_NO_POSIX pipe-sample.cob cobweb-pipes.cob -g -debug
      *> ***************************************************************
      
       REPLACE ==:BUFFER-SIZE:== BY ==32768==.

       identification division.
       program-id. pipe-sample.

       environment division.
       configuration section.
       repository.
           function pipe-open
           function pipe-read
           function pipe-write
           function pipe-close
           function pinpoint
           function entrammel
           function cmove
           function all intrinsic.

       data division.
       working-storage section.
       01 pipe-line            pic x(:BUFFER-SIZE:).
       01 pipe-out             pic x(:BUFFER-SIZE:).

       01 read-length          pic 9(5).
       01 display-speed        pic s9(8)v9(8).

       01 command-arguments    pic x(2048).
          88 write-test              value "--write".
          88 units                   value "--units".
          88 graphing                value "--graph".

       01 pipe-command         pic x(64).
       01 newline              pic x value x"0a".
       01 perhaps-newline      pic x.

      *> a file pointer
       01 pipe-record.
          05 pipe-pointer      usage pointer.
          05 pipe-return       usage binary-long.

      *> return of fgets and fputs
       01 pipe-record-out.
          05 pipe-read-status  usage pointer.
             88 pipe-gone                          value null.
          05 pipe-write-status usage binary-long.
       01 pipe-status          usage binary-long.

      *> constant for used "cat" command (for using "more" on native win)
>>IF WIN_NO_POSIX NOT DEFINED
       78 cat                  value "cat".
>>ELSE
       78 cat                  value "more".
>>END-IF

      *> ***************************************************************
       procedure division.

      *> pass args to pipe, read and display the output
       accept command-arguments from command-line end-accept

      *> write to pipe test?
       if write-test then     
           move pipe-open(cat, "w") to pipe-record
           if pipe-return not equal 255 then 
               move pipe-write(pipe-record, "test 1" & x"0a")
                 to pipe-record-out
               move pipe-write(pipe-record, "test 2") to pipe-record-out
               move pipe-close(pipe-record) to return-code
           end-if
           goback
       end-if

      *> graph to X
       if graphing then     
           move pipe-open(
               "graph -TX -x 1 13 -y -1000 6000" &
               " -X 'Month' -Y 'Pennies' -S 4", "w")
             to pipe-record
           if pipe-return not equal 255 then 
               move pipe-write(pipe-record,
                   "1 1234 2 2345 3 3456 4 1234" &
                   " 5 4567 6 3456 7 5678 8 2345" &
                   " 9 4567 10 3456 11 5678 12 -500")
                 to pipe-record-out
               move pipe-close(pipe-record) to return-code
               if return-code not equal 0 then
                   display "return-code: " return-code
               end-if
           end-if
           goback
       end-if

      *> hard coded unit conversion example
       if units then
           move 'units "miles per hour" "furlongs/fortnight" -t'
             to pipe-command
           move pipe-open(pipe-command, "r") to pipe-record
           if pipe-return not equal 255 then 
               move pipe-read(pipe-record, pipe-line) to pipe-record-out
    
               unstring pipe-line delimited by x"0a" into pipe-line
                   count in read-length
               end-unstring
               move pipe-line(1 : read-length) to display-speed
               display
                   "units reports, " pipe-line(1 : read-length)
                   ", as s9(8)v9(8), 1 mile per hour is "
                   display-speed " furlongs/fortnight" 
               end-display
        
               move pipe-close(pipe-record) to pipe-status
               if pipe-status not equal zero then
                   display
                       "Yeah, that result is very likey invalid: "
                       pipe-status upon syserr
                   end-display
               end-if
           end-if
           goback
       end-if

       if command-arguments equal spaces then
           display
               "cobweb-pipes sample and tests" newline
               "Usage: pipe-sample [option | shell command]" newline 
               "  options: --write, write two line to cat`" newline 
               "           --units, call 'units', get speed" newline 
               "           --graph, pop up an X11 graph output" newline 
               "           or shell command string"
           end-display
           goback
       end-if

      *> default action, read test using command line arguments
      *> pass args to pipe, display the output
       move pipe-open(trim(command-arguments), "r") to pipe-record
       if pipe-return equal 255 then 
           goback
       end-if

      *> the pipe-line may include a newline and will be null terminated
       move pipe-read(pipe-record, pipe-line) to pipe-record-out
       perform until pipe-gone
           unstring pipe-line
               delimited by x"00" or x"0a"
               into pipe-out
               delimiter in perhaps-newline
               count in read-length
           end-unstring

           if perhaps-newline not equal newline then
               display
                   pipe-out(1 : read-length) with no advancing
               end-display
           else 
               display pipe-out(1 : read-length) end-display
           end-if

           move pipe-read(pipe-record, pipe-line) to pipe-record-out
       end-perform

      *> close uses an int status
       move pipe-close(pipe-record) to pipe-status
       move pipe-status to return-code

       goback.
       end program pipe-sample.
>>ELSE
============
pipe-sample usage
============

Introduction
------------
Test head, and sample for cobweb-pipes

Accepts::

    --write
    --units
    --graph

Default action is to run arguments as a shell command and display the
results.

Source
------

.. code-include::  pipe-sample.cob
   :language: cobol
>>END-IF
