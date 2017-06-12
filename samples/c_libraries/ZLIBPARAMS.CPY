      *> ***************************************************************
      *><* ======================
      *><* ZLIB wrapper constants
      *><* ======================
      *><* :Author:    Simon Sobisch
      *><* :Date:      12-June-2017
      *><* :License:   Dedicated to the public domain
      *> ***************************************************************

      *> linkage for CBL_ZLIB:
       01  ZLIB-PARAMS.

      *> Mode for operation
           03  ZLIB-MODE                 PIC 9     VALUE   0.
               88  ZLIB-OUTPUT-USAGE               VALUE   0.
               88  ZLIB-GET-VERSION                VALUE   1.
               88  ZLIB-UNCOMPRESS                 VALUE   2.
               88  ZLIB-COMPRESS                   VALUE   3.
               88  ZLIB-COMPRESS-TO-LEVEL          VALUE   4.
               88  ZLIB-MODE-IS-VALID              VALUES  0 thru 4.

      *> ZLIB: Return codes for the zlib functions in use.
      *>       Negative values are errors, positive values are used
      *>       for special but normal events.
      *>       Negative values -99 thru -90 are reserved for
      *>       errors in the CBL_ZLIB wrapper interface.
           03  ZLIB-RETURN               PIC S99   VALUE   0.
               88  ZLIB-OK                         VALUE   0.
      *        88  ZLIB-STREAM-END                 VALUE   1.
      *        88  ZLIB-NEED-DICT                  VALUE   2.
               88  ZLIB-LIBRARY-ERROR              VALUES -1  thru -9.
      *        88  ZLIB-ERRNO                      VALUE  -1.
      *        88  ZLIB-STREAM-ERROR               VALUE  -2.
               88  ZLIB-DATA-ERROR                 VALUE  -3.
               88  ZLIB-MEM-ERROR                  VALUE  -4.
               88  ZLIB-BUF-ERROR                  VALUE  -5.
               88  ZLIB-VERSION-ERROR              VALUE  -6.
               88  ZLIB-INTERFACE-ERROR            VALUES -90 thru -99.
               88  ZLIB-INTERFACE-INVALID-MODE     VALUE  -90.
               88  ZLIB-INTERFACE-INVALID-DATA     VALUE  -91.
               88  ZLIB-INTERFACE-RESOLVE-ERROR    VALUE  -92.

      *> Compression level for mode ZLIB-COMPRESS-TO-LEVEL
           03  ZLIB-COMPRESSION-LEVEL    PIC S9    VALUE  -1.
               88  ZLIB-NO-COMPRESSION             VALUE   0.
               88  ZLIB-BEST-SPEED                 VALUE   1.
               88  ZLIB-BEST-COMPRESSION           VALUE   9.
               88  ZLIB-DEFAULT-COMPRESSION        VALUE  -1.

      *> Size of actual bytes in the resulting (un)compressed data
           03  ZLIB-PROCESSED-DATA-SIZE  USAGE     BINARY-LONG.
