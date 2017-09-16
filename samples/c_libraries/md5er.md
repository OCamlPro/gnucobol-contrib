# MD5

## Sample run of md5er.cob

    prompt$ cobc -xj md5er.cob -l:libmbedcrypto.so -DMBEDTLS
     
    Offset  HEX-- -- -- -5 -- -- -- -- 10 -- -- -- -- 15 --   CHARS----1----5-
    000000  9e 10 7d 9d 37 2b b6 82 6b d8 1d 35 42 a4 19 d6   ..}.7+..k..5B...
     
    prompt$ cobc -xj md5er.cob -lssl
     
    Offset  HEX-- -- -- -5 -- -- -- -- 10 -- -- -- -- 15 --   CHARS----1----5-
    000000  9e 10 7d 9d 37 2b b6 82 6b d8 1d 35 42 a4 19 d6   ..}.7+..k..5B...

    prompt$ printf "The quick brown fox jumps over the lazy dog" | md5sum
    9e107d9d372bb6826bd81d3542a419d6  -

## Notes on md5er.cob

MD5 hash digests are still common, but the cryptographic reliability was
compromised as far back as 2004.  Accidental 128-bit digest collisions are
highly unlikely but not a true zero probability (discovered in 1996).  At this
time, a determined attacker can defeat the use of the 128-bit digest as a
trusted unique file identifier. For informal use, MD5 is still a fairly
reasonable protection against unintentional corruption (from network line noise
or disk sector read errors, for example) and is still in wide spread use in
many public facing source code repository systems, such as Git.

MD5 is **not** recommended for secure work or where automated trust in the
information is tantamount. For source code text files, just looking at the
result will usually suffice (forced collision trickery will be visible), but as
encryption keys or digital signatures, MD5 is deemed broken and unfit for
purpose.
