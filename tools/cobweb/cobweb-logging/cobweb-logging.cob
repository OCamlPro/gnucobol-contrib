GCobol >>SOURCE FORMAT IS FREE
>>IF docpass NOT DEFINED
      *> ***************************************************************
      *>****R* cobweb/cobweb-logging
      *> AUTHOR
      *>   Brian Tiffin
      *> DATE
      *>   20150413
      *> LICENSE
      *>   GNU Lesser General Public License, LGPL, 3.0 (or greater)
      *> PURPOSE
      *>   Application logging
      *> TECTONICS
      *>   cobc -x program.cob cobweb-logging.cob -g -debug
      *> SOURCE
      *> ***************************************************************
       identification division.
       program-id. cobweb-logging.

      *> cobcrun default; display the repository, as source code
       procedure division.
       display "      *> cobweb-logging repository"     end-display
       display "           function open-log"           end-display        
       display "           function write-log"          end-display        
       display "           function mask-log"           end-display        
       display "           function close-log"          end-display        
       goback.

       end program cobweb-logging.
      *>****

      *> ***************************************************************
      *>****F* cobweb-logging/open-log
      *> AUTHOR
      *>   Brian Tiffin
      *> DATE
      *>   20150413
      *> LICENSE
      *>   GNU Lesser General Public License, LGPL, 3.0 (or greater)
      *> PURPOSE
      *>   Open application logging, optional, sets non defaults
      *> INPUT
      *>   log-identifier (entry prefix string), pic x any
      *>   log-options (coded integer)
      *>   log-facility (coded integer)
      *> OUTPUT
      *>   extraneous
      *> SEE ALSO
      *>   man page for syslog
      *>   cobweb-logging.cpy for coded integers
      *> TECTONICS
      *>   cobc -x program.cob cobweb-logging.cob -g -debug
      *> SOURCE
      *> ***************************************************************
       identification division.
       function-id. open-log.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
       01 log-identifier       pic x any length.
       01 log-options          usage binary-long.
       01 log-facility         usage binary-long.
       01 extraneous           usage binary-long.

      *> ***************************************************************
       procedure division using
           log-identifier
           log-options
           log-facility
         returning extraneous.

      *> from man syslog(3)
       call "openlog" using
           by content concatenate(trim(log-identifier), x"00")
           by value log-options
           by value log-facility
           returning omitted
           on exception
               display
                   "error: openlog link err" upon syserr
               end-display
               move 255 to extraneous
       end-call

       goback.
       end function open-log.
      *>****

      *> ***************************************************************
      *>****F* cobweb-logging/write-log
      *> PURPOSE
      *>   Application log writer
      *> INPUT
      *>   message-priority, coded integer
      *>   log-message pic x any
      *> OUTPUT
      *>   extraneous
      *> SOURCE
      *> ***************************************************************
       identification division.
       function-id. write-log.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
       01 message-priority     usage binary-long.
       01 log-message          pic x any length.
       01 extraneous           usage binary-long.

      *> ***************************************************************
       procedure division using
           message-priority
           log-message
         returning extraneous.

       call "syslog" using
           by value message-priority
           by content z"%s"
           by content concatenate(trim(log-message), x"00")
           returning omitted
           on exception
               display "error: syslog link error" upon syserr end-display
               move 255 to extraneous
       end-call

       goback.
       end function write-log.
      *>****

      *> ***************************************************************
      *>****F* cobweb-logging/close-log
      *> PURPOSE
      *>   close log channel resources
      *> SOURCE
      *> ***************************************************************
       identification division.
       function-id. close-log.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
       01 extraneous           usage binary-long.

      *> ***************************************************************
       procedure division returning extraneous.

      *> from man syslog(3)
       call "closelog" returning omitted
           on exception
               display
                   "error: closelog link error" upon syserr
               end-display
               move 255 to extraneous
       end-call

       goback.
       end function close-log.
      *>****
       
      *> ***************************************************************
      *>****F* cobweb-logging/mask-log
      *> PURPOSE
      *>   Log priority mask, ala setlogmask(3)
      *> INPUT
      *>   log-mask, coded integer. No change on 0.
      *> OUTPUT
      *>   previous mask
      *> SOURCE
      *> ***************************************************************
       identification division.
       function-id. mask-log.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       linkage section.
       01 log-mask             usage binary-long.
       01 extraneous           usage binary-long.

      *> ***************************************************************
       procedure division using log-mask returning extraneous.

      *> from man setlogmask(3)
       call "setlogmask"
           using by value log-mask
           returning extraneous
           on exception
               display
                   "error: setlogmask link error" upon syserr
               end-display
               move 0 to extraneous
       end-call

       goback.
       end function mask-log.
      *>****
>>ELSE
====================
cobweb-logging usage
====================

A cobweb repository to ease use of POSIX :manpage:`syslog(3)`.

Introduction
------------

Configure syslog, rsyslog, and/or journald, appropriately for local logging applications.

For example, in ``/etc/rsyslog.d/gnucobol.conf``

::

    # ...
    # site dependent, but you may need to comment out
    # $OmitLocalLogging on
    #    if journald is complicating the rsyslog setup
    # ...

    # GnuCOBOL, local3 
    local3.*                                /var/log/gnucobol.log

    # extra log for cobweb applications, by name
    :programname, contains, "cobweb"        /var/log/cobweb.log

which

* forwards all LOCAL3 facility messages to ``/var/log/gnucobol.log``

* forwards any messages that have **cobweb** in the identifier field;
  (usually, but not always, the program name, can be set in ``open-log``)
  to ``/var/log/cobweb.log``

At a glance
-----------

.. code-block:: cobolfree

    MOVE WRITE-LOG(LOG-DEBUG, "debug message")

or for finer control

.. code-block:: cobolfree

    move open-log("cobweb", LOG-PERROR + LOG-PID, LOG-LOCAL3) to return-code
    move write-log(LOG-ERR, "cobweb error message") to return-code
    move setlogmask(LOG-EMERG) to previous-mask
    move write-log(LOG-ERR, "another cobweb error message") to return-code 

``open-log``, and ``close-log`` are optional; default write-log will be
by priority, and most likely end up in ``/var/log/messages``, if default
configurations are in place.

*By the way, ``LOG-PERROR`` sets an option flag to also send log messages to
``stderr`` and the LOG-PID sets `a flag to include the process id in the
formatted log entry.*

.. note::

    The open-log option flags are usually OR'ed together, this uses
    addition, for a similar effect, in this case.


Source
------

.. code-include::  cobweb-logging.cob
   :language: cobol
>>END-IF

