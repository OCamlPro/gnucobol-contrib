      *> ***************************************************************
      *><* ==================
      *><* ZLIB access sample
      *><* ==================
      *><* :Author:    Simon Sobisch
      *><* :Date:      12-June-2017
      *><* :Purpose:   Demonstrate CBL_ZLIB calls
      *><* :Copyright: Dedicated to the public domain
      *><* :Tectonics:
      *>y*    cobc -m -static -lz CBL_ZLIB.cob
      *><*    cobc -x sample_ZLIB.cob
      *><*    ./sample_ZLIB
      *><* or
      *>y*    cobc -m -static -lz -fdebugging-line CBL_ZLIB.cob
      *><*    cobc -x sample_ZLIB.cob
      *><*    COB_PRE_LOAD=CBL_OC_DUMP ./sample_ZLIB

      *> ***************************************************************
       identification division.
       program-id. sample_ZLIB.

       environment division.
       input-output section.
       file-control.
          select bin-file assign to bin-name
              organization is sequential
              FILE STATUS is bin-file-status
              .
      *
       data division.
       file section.
       FD bin-file.
       01 bin-byte  pic x.

       working-storage section.
      *
       78  COMPRESSED-DATA-MAX VALUE 5000.
       77  COMPRESSED-DATA    PIC X(COMPRESSED-DATA-MAX).
       77  UNCOMPRESSED-DATA  PIC X(20000).

       77  bin-name           PIC X(50) value "textstream.bin".
       77  BIN-FILE-STATUS    PIC XX.
       77  BIN-SIZE           PIC 9(05).
       77  BIN-POS            USAGE BINARY-LONG.

       copy ZLIBPARAMS.
      *
       procedure division.
       sample section.
      *
           display ' '
           display 'Reading zlib version number...'
           set  ZLIB-GET-VERSION to true
           call 'CBL_ZLIB' using ZLIB-PARAMS,
                                 COMPRESSED-DATA,
                                 UNCOMPRESSED-DATA
           display 'finished, status: ' ZLIB-RETURN ' '
                   'size: ' ZLIB-PROCESSED-DATA-SIZE
           display 'Version number was read: ' UNCOMPRESSED-DATA
                   (1:ZLIB-PROCESSED-DATA-SIZE)
      *
           move "textstream.bin" to bin-name
           display 'Opening ' bin-name
           open input bin-file
           display 'Bin data was opened with status: ' bin-file-status
      *
           display ' '
           display 'Reading complete file...'
           move 0 to BIN-POS
           move spaces to compressed-data
           perform COMPRESSED-DATA-MAX times
              add 1 to BIN-POS
              read bin-file into compressed-data(BIN-POS:1)
                at end
                  move 0 to bin-file-status
                  subtract 1 from bin-pos
                  exit perform
              end-read
           end-perform
           move bin-pos to bin-size
           display 'Bin data was read with ' bin-size ' bytes. '
                   'Status: ' bin-file-status
      *
           close bin-file
      *
           display ' '
           display 'uncompress data...'
           set  ZLIB-UNCOMPRESS to true
           call 'CBL_ZLIB' using ZLIB-PARAMS,
                                 COMPRESSED-DATA (1:bin-size),
                                 UNCOMPRESSED-DATA
           display 'finished, status: ' ZLIB-RETURN ' '
                   'size: ' ZLIB-PROCESSED-DATA-SIZE
      *
           display ' '
           move "textstream.out" to bin-name
           display 'Creating ' bin-name
           open output bin-file
           display 'Bin data was opened with status: ' bin-file-status
      *
           display ' '
           move ZLIB-PROCESSED-DATA-SIZE to bin-size
           display 'Writing ' bin-size ' bytes to file...'

           move 0 to BIN-POS
           perform ZLIB-PROCESSED-DATA-SIZE times
              add 1 to BIN-POS
              write bin-byte from uncompressed-data(BIN-POS:1)
              end-write
           end-perform
           move bin-pos to bin-size
           display 'Bin data was written with ' bin-size ' bytes. '
                   'Status: ' bin-file-status
      *
           close bin-file
      *
           exit program.
