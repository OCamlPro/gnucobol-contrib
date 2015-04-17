GCobol >>SOURCE FORMAT IS FREE
REPLACE ==SAMPLE== BY ==program-name==.
>>IF docpass NOT DEFINED
      *> ***************************************************************
      *>****J* project/SAMPLE
      *> AUTHOR
      *>   Brian Tiffin
      *> DATE
      *>   20150405
      *> LICENSE
      *>   GNU Lesser General Public License, LGPL, 3.0 (or greater)
      *> PURPOSE
      *>   SAMPLE program.
      *> TECTONICS
      *>   cobc -x SAMPLE.cob -g -debug
      *> ***************************************************************
       identification division.
       program-id. cobweb-log.

       environment division.
       configuration section.
       repository.
           function open-log
           function write-log
           function mask-log
           function close-log
           function all intrinsic.

       input-output section.
       file-control.

       data division.
       file section.
       working-storage section.
       COPY cobweb-logging.
  
       01 new-logging-mask     usage binary-long.
       01 default-log-mask     usage binary-long.

      *> ***************************************************************
       procedure division.
       move open-log("cobweb", LOG-PERROR + LOG-PID, LOG-LOCAL3)
         to return-code
       move write-log(LOG-ERR, "this is an error test") to return-code
       move write-log(LOG-WARNING, "this a warning test") to return-code
       
      *> each level is a bit, 0 thru 7. 
      *>  lower bits, more important. 0 is emergency, debug being the 7
      *> Computation Belows masks out anything less
      *>  important than ERR.
       compute new-logging-mask = (2 ** (LOG-ERR + 1)) - 1 end-compute
       move mask-log(new-logging-mask) to default-log-mask
       display default-log-mask
       move write-log(LOG-INFO, "this is a post mask info test")
         to return-code
       move write-log(LOG-ERR, "this is a post mask error test")
         to return-code

       move close-log() to return-code
       goback.
       end program cobweb-log.
      *> ***************************************************************
>>ELSE
============
SAMPLE usage
============

Introduction
------------

Source
------

.. code-include::  SAMPLE.cob
   :language: cobol
>>END-IF

