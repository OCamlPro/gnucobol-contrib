*>******************************************************************************
*>  This file is part of cobsha3.
*>
*>  TESTSHA3.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  TESTSHA3.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with TESTSHA3.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      TESTSHA3.cob
*>
*> Purpose:      Test program for the SHA3 modules 
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2016.05.17
*>
*> Tectonics:    cobc -x -W -free TESTSHA3.cob
*>
*> Usage:        ./TESTSHA3.exe
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2016.05.17 Laszlo Erdos: 
*>            - First version created.
*>------------------------------------------------------------------------------
*> yyyy.mm.dd
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. TESTSHA3.

 ENVIRONMENT DIVISION.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 01 WS-STRING-1MB                      PIC X(1000000). 

*> input fields 
 01 WS-INPUT                           PIC X(200).
 01 WS-INPUT-BYTE-LEN                  BINARY-DOUBLE UNSIGNED.

*> output fields 
 01 WS-SHA3-224-OUTPUT                 PIC X(28).
 01 WS-SHA3-256-OUTPUT                 PIC X(32).
 01 WS-SHA3-384-OUTPUT                 PIC X(48).
 01 WS-SHA3-512-OUTPUT                 PIC X(64).
 01 WS-SHAKE128-OUTPUT                 PIC X(1024).
 01 WS-SHAKE128-OUTPUT-BYTE-LEN        BINARY-DOUBLE UNSIGNED.
 01 WS-SHAKE256-OUTPUT                 PIC X(1024).
 01 WS-SHAKE256-OUTPUT-BYTE-LEN        BINARY-DOUBLE UNSIGNED.
   
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-TESTSHA3 SECTION.
*>------------------------------------------------------------------------------

*>  SHA3-224 module test
*>  ====================    
*>  Test case 1 
    PERFORM TEST-SHA3-224-1
    
*>  Test case 2 
    PERFORM TEST-SHA3-224-2

*>  Test case 3 
    PERFORM TEST-SHA3-224-3

*>  Test case 4 
    PERFORM TEST-SHA3-224-4
    
*>  Test case 5 
    PERFORM TEST-SHA3-224-5

*>  SHA3-256 module test
*>  ====================    
*>  Test case 1 
    PERFORM TEST-SHA3-256-1
    
*>  Test case 2 
    PERFORM TEST-SHA3-256-2

*>  Test case 3 
    PERFORM TEST-SHA3-256-3

*>  Test case 4 
    PERFORM TEST-SHA3-256-4
    
*>  Test case 5 
    PERFORM TEST-SHA3-256-5

*>  SHA3-384 module test
*>  ====================    
*>  Test case 1 
    PERFORM TEST-SHA3-384-1
    
*>  Test case 2 
    PERFORM TEST-SHA3-384-2

*>  Test case 3 
    PERFORM TEST-SHA3-384-3

*>  Test case 4 
    PERFORM TEST-SHA3-384-4
    
*>  Test case 5 
    PERFORM TEST-SHA3-384-5

*>  SHA3-512 module test
*>  ====================    
*>  Test case 1 
    PERFORM TEST-SHA3-512-1
    
*>  Test case 2 
    PERFORM TEST-SHA3-512-2

*>  Test case 3 
    PERFORM TEST-SHA3-512-3

*>  Test case 4 
    PERFORM TEST-SHA3-512-4
    
*>  Test case 5 
    PERFORM TEST-SHA3-512-5

*>  SHAKE128 module test
*>  ====================    
*>  Test case 1 
    PERFORM TEST-SHAKE128-1

*>  Test case 2 
    PERFORM TEST-SHAKE128-2

*>  Test case 3 
    PERFORM TEST-SHAKE128-3
    
*>  SHAKE256 module test
*>  ====================    
*>  Test case 1 
    PERFORM TEST-SHAKE256-1
    
    STOP RUN
    
    .
 MAIN-TESTSHA3-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-224-1 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 1 
    INITIALIZE WS-SHA3-224-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-224 test case 1:" END-DISPLAY
    DISPLAY "Input message: ""abc"", the bit string (0x)616263"-
            " of length 24 bits."   END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "e642824c3f8cf24a d09234ee7d3c766f c9a3a5168d0c94ad 73b46fdf"      
    END-DISPLAY
            
    MOVE "abc" TO WS-INPUT
    MOVE 3     TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-224" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-224-OUTPUT
    END-CALL

    IF WS-SHA3-224-OUTPUT =
       X"e642824c3f8cf24ad09234ee7d3c766fc9a3a5168d0c94ad73b46fdf"    
    THEN
       DISPLAY "SHA3-224 test case 1 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-224 test case 1!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-224-OUTPUT
    END-IF
    
    .
 TEST-SHA3-224-1-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-224-2 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 2 
    INITIALIZE WS-SHA3-224-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-224 test case 2:" END-DISPLAY
    DISPLAY "Input message: the empty string """", the bit string of length 0."
    END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "6b4e03423667dbb7 3b6e15454f0eb1ab d4597f9a1b078e3f 5b5a6bc7"      
    END-DISPLAY
            
    MOVE " " TO WS-INPUT
    MOVE 0   TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-224" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-224-OUTPUT
    END-CALL

    IF WS-SHA3-224-OUTPUT =
       X"6b4e03423667dbb73b6e15454f0eb1abd4597f9a1b078e3f5b5a6bc7"    
    THEN
       DISPLAY "SHA3-224 test case 2 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-224 test case 2!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-224-OUTPUT
    END-IF
    
    .
 TEST-SHA3-224-2-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 TEST-SHA3-224-3 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 3 
    INITIALIZE WS-SHA3-224-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-224 test case 3:" END-DISPLAY
    DISPLAY "Input message: ""abcdbcdecdefdefgefghfghighijhijkijkljklmklmn"-
            "lmnomnopnopq"" (length 448 bits)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "8a24108b154ada21 c9fd5574494479ba 5c7e7ab76ef264ea d0fcce33"      
    END-DISPLAY
            
    MOVE "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
      TO WS-INPUT
    MOVE 56 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-224" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-224-OUTPUT
    END-CALL

    IF WS-SHA3-224-OUTPUT =
       X"8a24108b154ada21c9fd5574494479ba5c7e7ab76ef264ead0fcce33"    
    THEN
       DISPLAY "SHA3-224 test case 3 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-224 test case 3!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-224-OUTPUT
    END-IF
    
    .
 TEST-SHA3-224-3-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-224-4 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 4 
    INITIALIZE WS-SHA3-224-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-224 test case 4:" END-DISPLAY
    DISPLAY "Input message:  ""abcdefghbcdefghicdefghijdefghijkefghijklfghi"-
            "jklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstno"-
            "pqrstu"" (length 896 bits)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "543e6868e1666c1a 643630df77367ae5 a62a85070a51c14c bf665cbc"      
    END-DISPLAY
            
    MOVE "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoi"-
         "jklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
      TO WS-INPUT
    MOVE 112 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-224" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-224-OUTPUT
    END-CALL

    IF WS-SHA3-224-OUTPUT =
       X"543e6868e1666c1a643630df77367ae5a62a85070a51c14cbf665cbc"    
    THEN
       DISPLAY "SHA3-224 test case 4 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-224 test case 4!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-224-OUTPUT
    END-IF
    
    .
 TEST-SHA3-224-4-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-224-5 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 5 
    INITIALIZE WS-SHA3-224-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-224 test case 5:" END-DISPLAY
    DISPLAY "Input message: one million (1,000,000) repetitions of the "- 
            "character ""a"" (0x61)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "d69335b93325192e 516a912e6d19a15c b51c6ed5c15243e7 a7fd653c"      
    END-DISPLAY
            
    MOVE ALL "a" TO WS-STRING-1MB
    MOVE 1000000 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-224" USING WS-STRING-1MB
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-224-OUTPUT
    END-CALL

    IF WS-SHA3-224-OUTPUT =
       X"d69335b93325192e516a912e6d19a15cb51c6ed5c15243e7a7fd653c"    
    THEN
       DISPLAY "SHA3-224 test case 5 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-224 test case 5!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-224-OUTPUT
    END-IF
    
    .
 TEST-SHA3-224-5-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-256-1 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 1 
    INITIALIZE WS-SHA3-256-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-256 test case 1:" END-DISPLAY
    DISPLAY "Input message: ""abc"", the bit string (0x)616263"-
            " of length 24 bits."   END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "3a985da74fe225b2 045c172d6bd390bd 855f086e3e9d525b "-
            "46bfe24511431532"      
    END-DISPLAY
            
    MOVE "abc" TO WS-INPUT
    MOVE 3     TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-256" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-256-OUTPUT
    END-CALL

    IF WS-SHA3-256-OUTPUT =
       X"3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532"    
    THEN
       DISPLAY "SHA3-256 test case 1 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-256 test case 1!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-256-OUTPUT
    END-IF
    
    .
 TEST-SHA3-256-1-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-256-2 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 2 
    INITIALIZE WS-SHA3-256-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-256 test case 2:" END-DISPLAY
    DISPLAY "Input message: the empty string """", the bit string of length 0."
    END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "a7ffc6f8bf1ed766 51c14756a061d662 f580ff4de43b49fa "-
            "82d80a4b80f8434a"      
    END-DISPLAY
            
    MOVE " " TO WS-INPUT
    MOVE 0   TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-256" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-256-OUTPUT
    END-CALL

    IF WS-SHA3-256-OUTPUT =
       X"a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a"    
    THEN
       DISPLAY "SHA3-256 test case 2 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-256 test case 2!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-256-OUTPUT
    END-IF
    
    .
 TEST-SHA3-256-2-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 TEST-SHA3-256-3 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 3 
    INITIALIZE WS-SHA3-256-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-256 test case 3:" END-DISPLAY
    DISPLAY "Input message: ""abcdbcdecdefdefgefghfghighijhijkijkljklmklmn"-
            "lmnomnopnopq"" (length 448 bits)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "41c0dba2a9d62408 49100376a8235e2c 82e1b9998a999e21 "-
            "db32dd97496d3376"      
    END-DISPLAY
            
    MOVE "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
      TO WS-INPUT
    MOVE 56 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-256" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-256-OUTPUT
    END-CALL

    IF WS-SHA3-256-OUTPUT =
       X"41c0dba2a9d6240849100376a8235e2c82e1b9998a999e21db32dd97496d3376"    
    THEN
       DISPLAY "SHA3-256 test case 3 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-256 test case 3!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-256-OUTPUT
    END-IF
    
    .
 TEST-SHA3-256-3-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-256-4 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 4 
    INITIALIZE WS-SHA3-256-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-256 test case 4:" END-DISPLAY
    DISPLAY "Input message:  ""abcdefghbcdefghicdefghijdefghijkefghijklfghi"-
            "jklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstno"-
            "pqrstu"" (length 896 bits)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "916f6061fe879741 ca6469b43971dfdb 28b1a32dc36cb325 "-
            "4e812be27aad1d18"      
    END-DISPLAY
            
    MOVE "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoi"-
         "jklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
      TO WS-INPUT
    MOVE 112 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-256" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-256-OUTPUT
    END-CALL

    IF WS-SHA3-256-OUTPUT =
       X"916f6061fe879741ca6469b43971dfdb28b1a32dc36cb3254e812be27aad1d18"    
    THEN
       DISPLAY "SHA3-256 test case 4 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-256 test case 4!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-256-OUTPUT
    END-IF
    
    .
 TEST-SHA3-256-4-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-256-5 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 5 
    INITIALIZE WS-SHA3-256-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-256 test case 5:" END-DISPLAY
    DISPLAY "Input message: one million (1,000,000) repetitions of the "- 
            "character ""a"" (0x61)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "5c8875ae474a3634 ba4fd55ec85bffd6 61f32aca75c6d699 "-
            "d0cdcb6c115891c1"      
    END-DISPLAY
            
    MOVE ALL "a" TO WS-STRING-1MB
    MOVE 1000000 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-256" USING WS-STRING-1MB
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-256-OUTPUT
    END-CALL

    IF WS-SHA3-256-OUTPUT =
       X"5c8875ae474a3634ba4fd55ec85bffd661f32aca75c6d699d0cdcb6c115891c1"    
    THEN
       DISPLAY "SHA3-256 test case 5 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-256 test case 5!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-256-OUTPUT
    END-IF
    
    .
 TEST-SHA3-256-5-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-384-1 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 1 
    INITIALIZE WS-SHA3-384-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-384 test case 1:" END-DISPLAY
    DISPLAY "Input message: ""abc"", the bit string (0x)616263"-
            " of length 24 bits."   END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "ec01498288516fc9 26459f58e2c6ad8d f9b473cb0fc08c25 "-
            "96da7cf0e49be4b2 98d88cea927ac7f5 39f1edf228376d25"
    END-DISPLAY
            
    MOVE "abc" TO WS-INPUT
    MOVE 3     TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-384" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-384-OUTPUT
    END-CALL

    IF WS-SHA3-384-OUTPUT =
       X"ec01498288516fc926459f58e2c6ad8df9b473cb0fc08c2596da7cf0e49be4b298d88cea927ac7f539f1edf228376d25"
    THEN
       DISPLAY "SHA3-384 test case 1 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-384 test case 1!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-384-OUTPUT
    END-IF
    
    .
 TEST-SHA3-384-1-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-384-2 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 2 
    INITIALIZE WS-SHA3-384-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-384 test case 2:" END-DISPLAY
    DISPLAY "Input message: the empty string """", the bit string of length 0."
    END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "0c63a75b845e4f7d 01107d852e4c2485 c51a50aaaa94fc61 "-
            "995e71bbee983a2a c3713831264adb47 fb6bd1e058d5f004"
    END-DISPLAY
            
    MOVE " " TO WS-INPUT
    MOVE 0   TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-384" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-384-OUTPUT
    END-CALL

    IF WS-SHA3-384-OUTPUT =
       X"0c63a75b845e4f7d01107d852e4c2485c51a50aaaa94fc61995e71bbee983a2ac3713831264adb47fb6bd1e058d5f004"    
    THEN
       DISPLAY "SHA3-384 test case 2 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-384 test case 2!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-384-OUTPUT
    END-IF
    
    .
 TEST-SHA3-384-2-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 TEST-SHA3-384-3 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 3 
    INITIALIZE WS-SHA3-384-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-384 test case 3:" END-DISPLAY
    DISPLAY "Input message: ""abcdbcdecdefdefgefghfghighijhijkijkljklmklmn"-
            "lmnomnopnopq"" (length 448 bits)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "991c665755eb3a4b 6bbdfb75c78a492e 8c56a22c5c4d7e42 "-
            "9bfdbc32b9d4ad5a a04a1f076e62fea1 9eef51acd0657c22"
    END-DISPLAY
            
    MOVE "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
      TO WS-INPUT
    MOVE 56 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-384" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-384-OUTPUT
    END-CALL

    IF WS-SHA3-384-OUTPUT =
       X"991c665755eb3a4b6bbdfb75c78a492e8c56a22c5c4d7e429bfdbc32b9d4ad5aa04a1f076e62fea19eef51acd0657c22"    
    THEN
       DISPLAY "SHA3-384 test case 3 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-384 test case 3!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-384-OUTPUT
    END-IF
    
    .
 TEST-SHA3-384-3-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-384-4 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 4 
    INITIALIZE WS-SHA3-384-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-384 test case 4:" END-DISPLAY
    DISPLAY "Input message:  ""abcdefghbcdefghicdefghijdefghijkefghijklfghi"-
            "jklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstno"-
            "pqrstu"" (length 896 bits)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "79407d3b5916b59c 3e30b09822974791 c313fb9ecc849e40 "-
            "6f23592d04f625dc 8c709b98b43b3852 b337216179aa7fc7"
    END-DISPLAY
            
    MOVE "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoi"-
         "jklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
      TO WS-INPUT
    MOVE 112 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-384" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-384-OUTPUT
    END-CALL

    IF WS-SHA3-384-OUTPUT =
       X"79407d3b5916b59c3e30b09822974791c313fb9ecc849e406f23592d04f625dc8c709b98b43b3852b337216179aa7fc7"    
    THEN
       DISPLAY "SHA3-384 test case 4 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-384 test case 4!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-384-OUTPUT
    END-IF
    
    .
 TEST-SHA3-384-4-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-384-5 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 5 
    INITIALIZE WS-SHA3-384-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-384 test case 5:" END-DISPLAY
    DISPLAY "Input message: one million (1,000,000) repetitions of the "- 
            "character ""a"" (0x61)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "eee9e24d78c18553 37983451df97c8ad 9eedf256c6334f8e "-
            "948d252d5e0e7684 7aa0774ddb90a842 190d2c558b4b8340"
    END-DISPLAY
            
    MOVE ALL "a" TO WS-STRING-1MB
    MOVE 1000000 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-384" USING WS-STRING-1MB
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-384-OUTPUT
    END-CALL

    IF WS-SHA3-384-OUTPUT =
       X"eee9e24d78c1855337983451df97c8ad9eedf256c6334f8e948d252d5e0e76847aa0774ddb90a842190d2c558b4b8340"    
    THEN
       DISPLAY "SHA3-384 test case 5 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-384 test case 5!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-384-OUTPUT
    END-IF
    
    .
 TEST-SHA3-384-5-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-512-1 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 1 
    INITIALIZE WS-SHA3-512-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-512 test case 1:" END-DISPLAY
    DISPLAY "Input message: ""abc"", the bit string (0x)616263"-
            " of length 24 bits."   END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "b751850b1a57168a 5693cd924b6b096e 08f621827444f70d "-
            "884f5d0240d2712e 10e116e9192af3c9 1a7ec57647e39340 "-
            "57340b4cf408d5a5 6592f8274eec53f0"
    END-DISPLAY
            
    MOVE "abc" TO WS-INPUT
    MOVE 3     TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-512" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-512-OUTPUT
    END-CALL

    IF WS-SHA3-512-OUTPUT =
       X"b751850b1a57168a5693cd924b6b096e08f621827444f70d884f5d0240d2712e10e116e9192af3c91a7ec57647e3934057340b4cf408d5a56592f8274eec53f0"
    THEN
       DISPLAY "SHA3-512 test case 1 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-512 test case 1!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-512-OUTPUT
    END-IF
    
    .
 TEST-SHA3-512-1-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-512-2 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 2 
    INITIALIZE WS-SHA3-512-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-512 test case 2:" END-DISPLAY
    DISPLAY "Input message: the empty string """", the bit string of length 0."
    END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "a69f73cca23a9ac5 c8b567dc185a756e 97c982164fe25859 "-
            "e0d1dcc1475c80a6 15b2123af1f5f94c 11e3e9402c3ac558 "-
            "f500199d95b6d3e3 01758586281dcd26"
    END-DISPLAY
            
    MOVE " " TO WS-INPUT
    MOVE 0   TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-512" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-512-OUTPUT
    END-CALL

    IF WS-SHA3-512-OUTPUT =
       X"a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26"
    THEN
       DISPLAY "SHA3-512 test case 2 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-512 test case 2!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-512-OUTPUT
    END-IF
    
    .
 TEST-SHA3-512-2-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 TEST-SHA3-512-3 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 3 
    INITIALIZE WS-SHA3-512-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-512 test case 3:" END-DISPLAY
    DISPLAY "Input message: ""abcdbcdecdefdefgefghfghighijhijkijkljklmklmn"-
            "lmnomnopnopq"" (length 448 bits)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "04a371e84ecfb5b8 b77cb48610fca818 2dd457ce6f326a0f "-
            "d3d7ec2f1e91636d ee691fbe0c985302 ba1b0d8dc78c0863 "-
            "46b533b49c030d99 a27daf1139d6e75e"
    END-DISPLAY
            
    MOVE "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
      TO WS-INPUT
    MOVE 56 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-512" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-512-OUTPUT
    END-CALL

    IF WS-SHA3-512-OUTPUT =
       X"04a371e84ecfb5b8b77cb48610fca8182dd457ce6f326a0fd3d7ec2f1e91636dee691fbe0c985302ba1b0d8dc78c086346b533b49c030d99a27daf1139d6e75e"    
    THEN
       DISPLAY "SHA3-512 test case 3 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-512 test case 3!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-512-OUTPUT
    END-IF
    
    .
 TEST-SHA3-512-3-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-512-4 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 4 
    INITIALIZE WS-SHA3-512-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-512 test case 4:" END-DISPLAY
    DISPLAY "Input message:  ""abcdefghbcdefghicdefghijdefghijkefghijklfghi"-
            "jklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstno"-
            "pqrstu"" (length 896 bits)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "afebb2ef542e6579 c50cad06d2e578f9 f8dd6881d7dc824d "-
            "26360feebf18a4fa 73e3261122948efc fd492e74e82e2189 "-
            "ed0fb440d187f382 270cb455f21dd185"
    END-DISPLAY
            
    MOVE "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoi"-
         "jklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"
      TO WS-INPUT
    MOVE 112 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-512" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-512-OUTPUT
    END-CALL

    IF WS-SHA3-512-OUTPUT =
       X"afebb2ef542e6579c50cad06d2e578f9f8dd6881d7dc824d26360feebf18a4fa73e3261122948efcfd492e74e82e2189ed0fb440d187f382270cb455f21dd185"
    THEN
       DISPLAY "SHA3-512 test case 4 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-512 test case 4!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-512-OUTPUT
    END-IF
    
    .
 TEST-SHA3-512-4-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHA3-512-5 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 5 
    INITIALIZE WS-SHA3-512-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHA3-512 test case 5:" END-DISPLAY
    DISPLAY "Input message: one million (1,000,000) repetitions of the "- 
            "character ""a"" (0x61)." END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "3c3a876da14034ab 60627c077bb98f7e 120a2a5370212dff "-
            "b3385a18d4f38859 ed311d0a9d5141ce 9cc5c66ee689b266 "-
            "a8aa18ace8282a0e 0db596c90b0a7b87"
    END-DISPLAY
            
    MOVE ALL "a" TO WS-STRING-1MB
    MOVE 1000000 TO WS-INPUT-BYTE-LEN  
    
    CALL "SHA3-512" USING WS-STRING-1MB
                          WS-INPUT-BYTE-LEN
                          WS-SHA3-512-OUTPUT
    END-CALL

    IF WS-SHA3-512-OUTPUT =
       X"3c3a876da14034ab60627c077bb98f7e120a2a5370212dffb3385a18d4f38859ed311d0a9d5141ce9cc5c66ee689b266a8aa18ace8282a0e0db596c90b0a7b87"
    THEN
       DISPLAY "SHA3-512 test case 5 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHA3-512 test case 5!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHA3-512-OUTPUT
    END-IF
    
    .
 TEST-SHA3-512-5-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHAKE128-1 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 1 
    INITIALIZE WS-SHAKE128-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHAKE128 test case 1:" END-DISPLAY
    DISPLAY "Input message: ""The quick brown fox jumps over the lazy dog""."
    END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "f4202e3c5852f9182a0430fd8144f0a74b95e7417ecae17db0f8cfeed0e3e66e"
    END-DISPLAY
            
    MOVE "The quick brown fox jumps over the lazy dog"
      TO WS-INPUT
    MOVE 43 TO WS-INPUT-BYTE-LEN  
    MOVE 32 TO WS-SHAKE128-OUTPUT-BYTE-LEN  
    
    CALL "SHAKE128" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHAKE128-OUTPUT
                          WS-SHAKE128-OUTPUT-BYTE-LEN
    END-CALL

    IF WS-SHAKE128-OUTPUT(1:32) =
       X"f4202e3c5852f9182a0430fd8144f0a74b95e7417ecae17db0f8cfeed0e3e66e"    
    THEN
       DISPLAY "SHAKE128 test case 1 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHAKE128 test case 1!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHAKE128-OUTPUT(1:32)
    END-IF
    
    .
 TEST-SHAKE128-1-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHAKE128-2 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 2 
    INITIALIZE WS-SHAKE128-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHAKE128 test case 2:" END-DISPLAY
    DISPLAY "Input message: ""The quick brown fox jumps over the lazy dof""."
    END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "853f4538be0db9621a6cea659a06c1107b1f83f02b13d18297bd39d7411cf10c"
    END-DISPLAY
            
    MOVE "The quick brown fox jumps over the lazy dof"
      TO WS-INPUT
    MOVE 43 TO WS-INPUT-BYTE-LEN  
    MOVE 32 TO WS-SHAKE128-OUTPUT-BYTE-LEN  
    
    CALL "SHAKE128" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHAKE128-OUTPUT
                          WS-SHAKE128-OUTPUT-BYTE-LEN
    END-CALL

    IF WS-SHAKE128-OUTPUT(1:32) =
       X"853f4538be0db9621a6cea659a06c1107b1f83f02b13d18297bd39d7411cf10c"    
    THEN
       DISPLAY "SHAKE128 test case 2 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHAKE128 test case 2!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHAKE128-OUTPUT(1:32)
    END-IF
    
    .
 TEST-SHAKE128-2-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHAKE128-3 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 3 
    INITIALIZE WS-SHAKE128-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHAKE128 test case 3:" END-DISPLAY
    DISPLAY "Input message: the empty string """", the bit string of length 0."
    END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "7f9c2ba4e88f827d616045507605853ed73b8093f6efbc88eb1a6eacfa66ef26"
    END-DISPLAY
            
    MOVE " "
      TO WS-INPUT
    MOVE 0  TO WS-INPUT-BYTE-LEN  
    MOVE 32 TO WS-SHAKE128-OUTPUT-BYTE-LEN  
    
    CALL "SHAKE128" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHAKE128-OUTPUT
                          WS-SHAKE128-OUTPUT-BYTE-LEN
    END-CALL

    IF WS-SHAKE128-OUTPUT(1:32) =
       X"7f9c2ba4e88f827d616045507605853ed73b8093f6efbc88eb1a6eacfa66ef26"    
    THEN
       DISPLAY "SHAKE128 test case 3 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHAKE128 test case 3!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHAKE128-OUTPUT(1:32)
    END-IF
    
    .
 TEST-SHAKE128-3-EX.
    EXIT.

*>------------------------------------------------------------------------------
 TEST-SHAKE256-1 SECTION.
*>------------------------------------------------------------------------------

*>  Test case 1 
    INITIALIZE WS-SHAKE256-OUTPUT

    DISPLAY " " END-DISPLAY
    DISPLAY "-------------------------------------------" END-DISPLAY
    DISPLAY "SHAKE256 test case 1:" END-DISPLAY
    DISPLAY "Input message: the empty string """", the bit string of length 0."
    END-DISPLAY   
    DISPLAY "Expected output:"      END-DISPLAY
    DISPLAY "46b9dd2b0ba88d13233b3feb743eeb243fcd52ea62b81b82b50c27646ed5762"-
            "fd75dc4ddd8c0f200cb05019d67b592f6fc821c49479ab48640292eacb3b7c4be"
    END-DISPLAY
            
    MOVE " "
      TO WS-INPUT
    MOVE 0  TO WS-INPUT-BYTE-LEN  
    MOVE 64 TO WS-SHAKE256-OUTPUT-BYTE-LEN  
    
    CALL "SHAKE256" USING WS-INPUT
                          WS-INPUT-BYTE-LEN
                          WS-SHAKE256-OUTPUT
                          WS-SHAKE256-OUTPUT-BYTE-LEN
    END-CALL

    IF WS-SHAKE256-OUTPUT(1:64) =
       X"46b9dd2b0ba88d13233b3feb743eeb243fcd52ea62b81b82b50c27646ed5762fd75dc4ddd8c0f200cb05019d67b592f6fc821c49479ab48640292eacb3b7c4be"    
    THEN
       DISPLAY "SHAKE256 test case 1 passed."     END-DISPLAY
    ELSE
       DISPLAY "Error in SHAKE256 test case 1!!!" END-DISPLAY
       CALL "CBL_OC_DUMP" using WS-SHAKE256-OUTPUT(1:64)
    END-IF
    
    .
 TEST-SHAKE256-1-EX.
    EXIT.
    
 END PROGRAM TESTSHA3.
