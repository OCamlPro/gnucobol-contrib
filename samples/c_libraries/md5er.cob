      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: September 2017
      *> Modified: 2017-09-16/16:16-0400 btiffin
      *>+<*
      *>
      *> md5er.cob, Compute an MD5 hash using OpenSSL, mbedtls
      *> Tectonics:
      *>     cobc -xj md5er.cob -lssl
      *>  or cobc -xj md5er.cob -lmbedcrypto -DMBEDTLS
      *> OpenSSL is the default
      *>
       >>SOURCE FORMAT IS VARIABLE
       identification division.
       program-id. sample.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 MD5-DIGEST-LENGTH constant as 16.
       01 datum.
          05 value "The quick brown fox jumps over the lazy dog".
       01 digest pic x(MD5-DIGEST-LENGTH).

       01 md5-hash pic x(11) value "mbedtls_md5".

       procedure division.
       sample-main.

      *> OpenSSL default, or mbedtls if defined,
      *>  different names, identical call prototypes
       >>IF MBEDTLS DEFINED
       move "mbedtls_md5" to md5-hash
       >>ELSE
       move "MD5" to md5-hash
       >>END-IF

       call md5-hash using datum value length(datum) reference digest
           on exception display "no MD5 linkage" upon syserr end-display
       end-call
       call "CBL_OC_DUMP" using digest

      *> if linking to a static version of the libraries, 
      *>   you would use a static call (no variable for the name) 
      *> call static "mbedtls_md5" using
      *>     by reference datum
      *>     by value length(datum)
      *>     by reference digest
      *> end-call
           
       goback.
       end program sample.
