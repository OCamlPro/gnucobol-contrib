      *> ***************************************************************
      *><* =========================================
      *><* ZLIB wrapper for ZLIB's utility functions
      *><* Note: needs zlib >= 1.0.2
      *><* =========================================
      *><* :Author:    Simon Sobisch
      *><* :Date:      12-June-2017
      *><* :Purpose:   Wrap the following zlib functions:
      *><*             * compress/compress2
      *><*             * uncompress
      *><*             * zlibVersion
      *><* :License:   Dedicated to the public domain
      *><* :Tectonics:
      *><*    cobc -m CBL_ZLIB.cob
      *><*    for static linking:
      *><*    cobc -m -static -lz CBL_ZLIB.cob
      *><*    note: for debugging (output parameters to syserr) add:
      *><*    -fdebugging-line
      *> ***************************************************************

       identification division.
       program-id. CBL_ZLIB.

      *> ***************************************************************

       data division.
       working-storage section.

       77  COMPRESSED-DATA-SIZE    usage BINARY-C-LONG.
       77  UNCOMPRESSED-DATA-SIZE  usage BINARY-C-LONG.

       77  COMPRESSION-MODE        usage BINARY-LONG.

      *> internal error / debug messages
       77  MSG                     pic x(80).

       01  DATA-PTR                usage pointer.

      *> ***************************************************************

       linkage section.
       copy ZLIBPARAMS.

       01  ZLIB-COMPRESSED-DATA    pic x any length.

       01  ZLIB-UNCOMPRESSED-DATA  pic x any length.

       01  DATA-PTR-DATA           pic x(80).

      *> ***************************************************************
       procedure division          using ZLIB-PARAMS,
                                         ZLIB-COMPRESSED-DATA,
                                         ZLIB-UNCOMPRESSED-DATA.
       main section.

           perform COMPRESSED-DATA-validation

           evaluate true
             when  ZLIB-GET-VERSION
               perform get-version
             when  ZLIB-UNCOMPRESS
               perform uncompress-data
             when  ZLIB-COMPRESS
               perform compress-data
             when  ZLIB-COMPRESS-TO-LEVEL
               perform compress2-data
           end-evaluate

           exit program.

      *> ***************************************************************

       COMPRESSED-DATA-validation section.

           move 0 to ZLIB-PROCESSED-DATA-SIZE

           if number-of-call-parameters < 1
             move 'not enough parameters passed' to msg
             perform output-error
             perform output-usage
             move -91 to return-code
             exit program
    >>D    else
      *>   dump COMPRESSED-DATA parameters when compiled with debugging mode
    >>D      display 'CBL_ZLIB - Debug - Parameter 1' upon syserr
    >>D      end-display
    >>D      call 'CBL_OC_DUMP' using ZLIB-PARAMS
    >>D       on exception
    >>D         move 'CBL_OC_DUMP not available' to msg
    >>D         perform output-error
    >>D      end-call
           end-if

           if not ZLIB-MODE-IS-VALID
             move 'ZLIB-MODE is invalid' to msg
             perform output-error
             perform output-usage
             set  ZLIB-INTERFACE-INVALID-MODE to true
             exit program
           end-if

           set  ZLIB-OK to true

           if ZLIB-OUTPUT-USAGE
             perform output-usage
             exit program
           end-if

           if number-of-call-parameters < 3
             move 'not enough parameters passed' to msg
             perform output-invalid-data-and-exit
           end-if

       *>  Get the length of the parameters
           call 'C$PARAMSIZE' using 2
                giving COMPRESSED-DATA-SIZE
           end-call
           call 'C$PARAMSIZE' using 3
                giving UNCOMPRESSED-DATA-SIZE
           end-call
      *>
           evaluate true
              when (ZLIB-COMPRESS or ZLIB-COMPRESS-TO-LEVEL)
               and UNCOMPRESSED-DATA-SIZE = 0
                move 'no compress of zero length data' to msg
                perform output-invalid-data-and-exit
              when ZLIB-UNCOMPRESS
               and COMPRESSED-DATA-SIZE = 0
                move 'no uncompress of zero length data' to msg
                perform output-invalid-data-and-exit
           end-evaluate
      *>
           continue.

      *> ***************************************************************

       output-invalid-data-and-exit section.

           perform output-error
           perform output-usage
           set  ZLIB-INTERFACE-INVALID-DATA to true
           exit program
      *>
           continue.

      *> ***************************************************************

       output-error section.

      *>   TODO: we *may* want to (optionally?)
      *>         return the error via LINKAGE
           display 'CBL_ZLIB - Error:' upon syserr end-display
           display function trim (msg) upon syserr end-display
      *>
           continue.

      *> ***************************************************************

       output-usage section.

      *>   TODO: decide if we want to do this, otherwise drop section

      *>
           continue.

      *> ***************************************************************

       get-version section.

    >>D    display 'CBL_ZLIB - Debug - Getting version number.'
    >>D            upon syserr
    >>D    end-display

           call 'zlibVersion'
              returning DATA-PTR
              on exception
                move 'zlib function "zlibVersion" not found' to msg
                perform output-error
                move 'either use static linking or set COB_PRE_LOAD'
                  to msg
                perform output-error
                set  ZLIB-INTERFACE-RESOLVE-ERROR to true
                exit section
           end-call
      *>
           set  ADDRESS OF  DATA-PTR-DATA to DATA-PTR
           unstring DATA-PTR-DATA
                    delimited by x'00'
                    into ZLIB-UNCOMPRESSED-DATA
                    count in ZLIB-PROCESSED-DATA-SIZE
           end-unstring
      *>
    >>D    display 'CBL_ZLIB - Debug - status: ' ZLIB-RETURN ', '
    >>D            'Bytes: ' ZLIB-PROCESSED-DATA-SIZE '.' upon syserr
    >>D    end-display
    >>D    if ZLIB-PROCESSED-DATA-SIZE not = 0
    >>D      display 'CBL_ZLIB - Debug - version data: '
    >>D              upon syserr
    >>D      end-display
    >>D      call 'CBL_OC_DUMP' using ZLIB-UNCOMPRESSED-DATA
    >>D                          (1:ZLIB-PROCESSED-DATA-SIZE)
    >>D        on exception
    >>D          move 'CBL_OC_DUMP not available' to msg
    >>D          perform output-error
    >>D      end-call
    >>D    end-if
      *>
           continue.

      *> ***************************************************************

       uncompress-data section.

    >>D    display 'CBL_ZLIB - Debug - Data to uncompress:' upon syserr
    >>D    end-display
    >>D    call 'CBL_OC_DUMP' using ZLIB-COMPRESSED-DATA
    >>D      on exception
    >>D        move 'CBL_OC_DUMP not available' to msg
    >>D        perform output-error
    >>D    end-call

           call 'uncompress'  using ZLIB-UNCOMPRESSED-DATA,
                                    UNCOMPRESSED-DATA-SIZE,
                                    ZLIB-COMPRESSED-DATA,
                                    by value COMPRESSED-DATA-SIZE
             returning ZLIB-RETURN
             on exception
               move 'zlib function "uncompress" not found' to msg
               perform output-error
               move 'either use static linking or set COB_PRE_LOAD'
                 to msg
               perform output-error
               set  ZLIB-INTERFACE-RESOLVE-ERROR to true
               exit section
           end-call
      *>
           move UNCOMPRESSED-DATA-SIZE to ZLIB-PROCESSED-DATA-SIZE
    >>D    display 'CBL_ZLIB - Debug - status: ' ZLIB-RETURN ', '
    >>D            'Bytes: ' ZLIB-PROCESSED-DATA-SIZE '.' upon syserr
    >>D    end-display
    >>D    if (ZLIB-OK or ZLIB-BUF-ERROR) and
    >>D        ZLIB-PROCESSED-DATA-SIZE not = 0
    >>D      display 'CBL_ZLIB - Debug - uncompressed data: '
    >>D              upon syserr
    >>D      end-display
    >>D      call 'CBL_OC_DUMP' using ZLIB-UNCOMPRESSED-DATA
    >>D                          (1:UNCOMPRESSED-DATA-SIZE)
    >>D        on exception
    >>D          move 'CBL_OC_DUMP not available' to msg
    >>D          perform output-error
    >>D      end-call
    >>D    end-if
      *>
           continue.

      *> ***************************************************************

       compress-data section.

    >>D    display 'CBL_ZLIB - Debug - Data to compress:' upon syserr
    >>D    end-display
    >>D    call 'CBL_OC_DUMP' using ZLIB-UNCOMPRESSED-DATA
    >>D      on exception
    >>D        move 'CBL_OC_DUMP not available' to msg
    >>D        perform output-error
    >>D    end-call

           call 'compress'  using ZLIB-COMPRESSED-DATA,
                                  COMPRESSED-DATA-SIZE,
                                  ZLIB-UNCOMPRESSED-DATA,
                                  by value UNCOMPRESSED-DATA-SIZE
             returning ZLIB-RETURN
             on exception
               move 'zlib function "compress" not found' to msg
               perform output-error
               move 'either use static linking or set COB_PRE_LOAD'
                 to msg
               perform output-error
               set  ZLIB-INTERFACE-RESOLVE-ERROR to true
               exit section
           end-call
      *>
           move COMPRESSED-DATA-SIZE to ZLIB-PROCESSED-DATA-SIZE
    >>D    display 'CBL_ZLIB - Debug - status: ' ZLIB-RETURN ', '
    >>D            'Bytes: ' ZLIB-PROCESSED-DATA-SIZE '.' upon syserr
    >>D    end-display
    >>D    if (ZLIB-OK or ZLIB-BUF-ERROR) and
    >>D        ZLIB-PROCESSED-DATA-SIZE not = 0
    >>D      display 'CBL_ZLIB - Debug - compressed data: '
    >>D              upon syserr
    >>D      end-display
    >>D      call 'CBL_OC_DUMP' using ZLIB-COMPRESSED-DATA
    >>D                          (1:COMPRESSED-DATA-SIZE)
    >>D        on exception
    >>D          move 'CBL_OC_DUMP not available' to msg
    >>D          perform output-error
    >>D      end-call
    >>D    end-if
      *>
           continue.

      *> ***************************************************************

       compress2-data section.

    >>D    call 'CBL_OC_DUMP' using ZLIB-UNCOMPRESSED-DATA
    >>D      on exception
    >>D        move 'CBL_OC_DUMP not available' to msg
    >>D        perform output-error
    >>D    end-call

           move ZLIB-COMPRESSION-LEVEL to COMPRESSION-MODE
           call 'compress2' using ZLIB-COMPRESSED-DATA,
                                  COMPRESSED-DATA-SIZE,
                                  ZLIB-UNCOMPRESSED-DATA,
                                  by value COMPRESSED-DATA-SIZE
                                  by value COMPRESSION-MODE
             returning ZLIB-RETURN
             on exception
               move 'zlib function "compress2" not found' to msg
               perform output-error
               move 'either use static linking or set COB_PRE_LOAD'
                 to msg
               perform output-error
               set  ZLIB-INTERFACE-RESOLVE-ERROR to true
               exit section
           end-call
      *>
           move COMPRESSED-DATA-SIZE to ZLIB-PROCESSED-DATA-SIZE
    >>D    display 'CBL_ZLIB - Debug - status: ' ZLIB-RETURN ', '
    >>D            'Bytes: ' ZLIB-PROCESSED-DATA-SIZE '.' upon syserr
    >>D    end-display
    >>D    if (ZLIB-OK or ZLIB-BUF-ERROR) and
    >>D        ZLIB-PROCESSED-DATA-SIZE not = 0
    >>D      display 'CBL_ZLIB - Debug - compressed data: '
    >>D              upon syserr
    >>D      end-display
    >>D      call 'CBL_OC_DUMP' using ZLIB-COMPRESSED-DATA
    >>D                          (1:COMPRESSED-DATA-SIZE)
    >>D        on exception
    >>D          move 'CBL_OC_DUMP not available' to msg
    >>D          perform output-error
    >>D      end-call
    >>D    end-if
      *>
           continue.

      *> ***************************************************************
