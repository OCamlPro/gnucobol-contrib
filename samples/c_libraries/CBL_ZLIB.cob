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
       77  DECOMPRESSED-DATA-SIZE  usage BINARY-C-LONG.

       77  COMPRESSION-MODE        usage BINARY-LONG.

      *> internal error / debug messages
       77  MSG                     pic x(80).

       01  DATA-PTR                usage pointer.

      *> ***************************************************************

       linkage section.
       copy ZLIBPARAMS.

       01  ZLIB-COMPRESSED-DATA    pic x any length.

       01  ZLIB-DECOMPRESSED-DATA  pic x any length.

       01  DATA-PTR-DATA           pic x(80).

      *> ***************************************************************
       procedure division          using ZLIB-PARAMS,
                                         ZLIB-COMPRESSED-DATA,
                                         ZLIB-DECOMPRESSED-DATA.
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
             perform output-error
             perform output-usage
             set  ZLIB-INTERFACE-INVALID-DATA to true
             exit program
           end-if

       *>  Get the length of the parameters
           call 'C$PARAMSIZE' using 2
                giving COMPRESSED-DATA-SIZE
           end-call
           call 'C$PARAMSIZE' using 3
                giving DECOMPRESSED-DATA-SIZE
           end-call
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
                    into ZLIB-DECOMPRESSED-DATA
                    count in ZLIB-PROCESSED-DATA-SIZE
           end-unstring
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

           call 'uncompress'  using ZLIB-COMPRESSED-DATA,
                                    COMPRESSED-DATA-SIZE,
                                    ZLIB-DECOMPRESSED-DATA,
                                    DECOMPRESSED-DATA-SIZE
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
           if ZLIB-OK
             move DECOMPRESSED-DATA-SIZE to ZLIB-PROCESSED-DATA-SIZE
           end-if
      *>
           continue.

      *> ***************************************************************

       compress-data section.

    >>D    display 'CBL_ZLIB - Debug - Data to compress:' upon syserr
    >>D    end-display
    >>D    call 'CBL_OC_DUMP' using ZLIB-DECOMPRESSED-DATA
    >>D      on exception
    >>D        move 'CBL_OC_DUMP not available' to msg
    >>D        perform output-error
    >>D    end-call

           call 'compress'  using ZLIB-DECOMPRESSED-DATA,
                                  DECOMPRESSED-DATA-SIZE,
                                  ZLIB-COMPRESSED-DATA,
                                  COMPRESSED-DATA-SIZE
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
           if ZLIB-OK
             move COMPRESSED-DATA-SIZE   to ZLIB-PROCESSED-DATA-SIZE
           end-if
      *>
           continue.

      *> ***************************************************************

       compress2-data section.

    >>D    call 'CBL_OC_DUMP' using ZLIB-DECOMPRESSED-DATA
    >>D      on exception
    >>D        move 'CBL_OC_DUMP not available' to msg
    >>D        perform output-error
    >>D    end-call

           move ZLIB-COMPRESSION-LEVEL to COMPRESSION-MODE
           call 'compress2' using ZLIB-DECOMPRESSED-DATA,
                                  DECOMPRESSED-DATA-SIZE,
                                  ZLIB-COMPRESSED-DATA,
                                  COMPRESSED-DATA-SIZE
                                  COMPRESSION-MODE
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
           if ZLIB-OK
             move COMPRESSED-DATA-SIZE   to ZLIB-PROCESSED-DATA-SIZE
           end-if
      *>
           continue.

      *> ***************************************************************
