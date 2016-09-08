      *> ***************************************************************
      *>****R* cobweb/cobweb-call-pipes
      *> AUTHOR
      *>   Brian Tiffin, Simon Sobisch
      *> DATE
      *>   20150216, 20150417 Brian Tiffin
      *>            creation of cobweb-pipes
      *>   20150417 Simon Sobisch
      *>            Added WIN_NO_POSIX for use in native Windows environments
      *>            use STATIC clause for C library calls
      *>   20160908 Simon Sobisch
      *>            Added missing implementation for characters-read,
      *>            reset pipe-pointer on pclose, initialize fields;
      *>            changed from cobweb-pipes to cobweb-call-pipes
      *>            for compatibility with other compilers
      *>            (including OpenCOBOL 1.1)
      *> LICENSE
      *>   GNU Lesser General Public License, LGPL, 3.0 (or greater)
      *> PURPOSE
      *>   cobweb-call-pipes program. Read OR Write on most POSIX
      *>   systems: pipe-open, pipe-read, pipe-write, pipe-close
      *> TECTONICS
      *>   cobc -m -static -debug cobweb-call-pipes.cob
      *>   COB_PRE_LOAD=cobweb-call-pipes  cobcrun yourprog
      *> USAGE
      *>
      *>   Introduction
      *>   ------------
      *>   POSIX ``popen`` pipes.
      *>
      *>   Pass a command to the shell, and either read from the result
      *>   or write to the pipe line.
      *>
      *>   Read from a pipe-open(command, "r")
      *>   And write to a pipe-open(command, "w") pipe channel
      *>
      *>   See manpage: `popen(3)`
      *>
      *> SOURCE
      *> ***************************************************************
      *> un-comment the following REPLACE for WIN_NO_POSIX
      *>  REPLACE "popen"  by "_popen", "pclose" by "_pclose".
      *> ***************************************************************
       identification division.
       program-id. cobweb-call-pipes.
       procedure division.

      *> cobcrun default, display the repository
       display "      *> cobweb-call-pipes call repository" end-display
       display "            call pipe-open"                 end-display
       display "            call pipe-read"                 end-display
       display "            call pipe-write"                end-display
       display "            call pipe-close"                end-display

       goback.
       end program cobweb-call-pipes.
      *>****


      *> ***************************************************************
      *>****F* cobweb-call-pipes/pipe-open
      *> PURPOSE
      *>   Open a pipe channel, Read or Write
      *> INPUTS
      *>   shell command, pic x any, must be null terminated
      *>   pipe open mode, "r" or "w", not both on POSIX, but maybe Mac
      *> OUTPUTS
      *>   pipe record, first field pointer
      *> SOURCE
      *> ***************************************************************
       identification division.
       program-id. pipe-open.

       environment division.
       configuration section.

       data division.
       working-storage section.

       77 pipe-mode-internal   pic x(10).

       linkage section.
       01 pipe-command         pic x any length.
       01 pipe-mode            pic x any length.
       01 pipe-record.
          05 pipe-pointer      usage pointer.
          05 pipe-return       usage binary-long.

      *> ***************************************************************
       procedure division using
           pipe-command
           pipe-mode
           pipe-record.

       move pipe-mode to pipe-mode-internal
       inspect pipe-mode-internal replacing trailing spaces by x'00'

       call "popen" using
           by reference pipe-command
           by reference pipe-mode-internal
         returning pipe-pointer
         on exception
             display "link error: popen" upon syserr end-display
             set  pipe-pointer to NULL
             move 255          to pipe-return
             goback
       end-call

       if pipe-pointer equal null then
           display "exec error: popen" upon syserr end-display
           move 255          to pipe-return
           goback
       end-if

       goback.
       end program pipe-open.
      *>****


      *> ***************************************************************
      *>****F* cobweb-pipes/pipe-read
      *> PURPOSE
      *>   Read from a pipe.
      *> INPUTS
      *>   pipe record, first field pointer
      *>   line buffer, pic x any
      *> OUTPUTS
      *>   pipe record
      *>     c string, pointer, possibly NULL
      *>     length, integer, possibly 0.
      *> SOURCE
      *> ***************************************************************
       identification division.
       program-id. pipe-read.

       environment division.
       configuration section.

       data division.
       working-storage section.
       01 line-buffer-length   usage binary-long.

       linkage section.
       01 pipe-pointer      usage pointer.
       01 line-buffer          pic x any length.
       01 pipe-record-out.
          05 pipe-read-status  usage pointer.
          05 characters-read   usage binary-long.

      *> ***************************************************************
       procedure division using
           pipe-pointer
           line-buffer
           pipe-record-out.

       move spaces to line-buffer
       move 0      to characters-read
       move function length(line-buffer) to line-buffer-length
       call "fgets" using
           by reference line-buffer
           by value line-buffer-length
           by value pipe-pointer
         returning pipe-read-status
         on exception
             display "link error: fgets" upon syserr end-display
             goback
       end-call
       if pipe-read-status not = NULL
          inspect line-buffer
            tallying characters-read for characters before x'00'
       end-if
       goback.
       end program pipe-read.
      *>****


      *> ***************************************************************
      *>****F* cobweb-pipes/pipe-write
      *> PURPOSE
      *>   Write to a pipe channel
      *> INPUTS
      *>   pipe record, first field pointer
      *>   line buffer, must be null terminated
      *> OUTPUTS
      *>   pipe record, first field pointer
      *> SOURCE
      *> ***************************************************************
       identification division.
       program-id. pipe-write.

       environment division.
       configuration section.

       data division.
       working-storage section.
       01 line-buffer-length   usage binary-long.

       linkage section.
       01 pipe-record-in.
          05 pipe-pointer      usage pointer.
          05 filler            usage binary-long.
       01 line-buffer          pic x any length.
       01 pipe-record-out.
          05 filler            usage pointer.
          05 pipe-write-status usage binary-long.

      *> ***************************************************************
       procedure division using
           pipe-record-in
           line-buffer
           pipe-record-out.

       call "fputs" using
           by reference line-buffer
           by value pipe-pointer
         returning pipe-write-status
         on exception
             display "link error: fputs" upon syserr end-display
             move 255 to pipe-write-status
             goback
       end-call

       goback.
       end program pipe-write.
      *>****


      *> ***************************************************************
      *>****F* cobweb-pipes/pipe-close
      *> PURPOSE
      *>   Close a pipe channel
      *> INPUTS
      *>   pipe record, first field pointer
      *> OUTPUTS
      *>   pipe close status, integer
      *> SOURCE
      *> ***************************************************************
       identification division.
       program-id. pipe-close.

       environment division.
       configuration section.

       data division.
       working-storage section.
       01  pclose-status        usage binary-long.
       linkage section.
       01  pipe-pointer         usage pointer.

      *> ***************************************************************
       procedure division using pipe-pointer.

       call "pclose" using
           by value pipe-pointer
         returning pclose-status
         on exception
             display "link error: pclose" upon syserr end-display
             move 255 to return-code
             goback
       end-call

       set  pipe-pointer  to NULL
       move pclose-status to return-code
       goback.
       end program pipe-close.
      *>****
