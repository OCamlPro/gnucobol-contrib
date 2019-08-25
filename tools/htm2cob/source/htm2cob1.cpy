*> HTM2COB sections template
 01 C-HTM2COB-SECTIONS-MAX-LINE            CONSTANT AS 1982.
 
 01 WS-HTM2COB-SECTIONS.
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> ********* end user defined content   SECTIONs *********                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-PROCESS-DATA SECTION.                                                  ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-ERROR-NO OF HTM2COB-ERROR-FLAG TO TRUE                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> !!!this is only for windows, GnuCOBOL with MS Visual Studio!!!               ".
   02 FILLER PIC X(80) VALUE "*> we have to switch stdin in binary mode                                       ".
   02 FILLER PIC X(80) VALUE ">>IF OS = ""WINDOWS""                                                           ".
   02 FILLER PIC X(80) VALUE "    PERFORM HTM2COB-SET-BINARY-MODE                                             ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                                ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>Error in SET-BINARY-MODE <BR>"" END-DISPLAY             ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE ">>END-IF                                                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> check REQUEST_METHOD                                                     ".
   02 FILLER PIC X(80) VALUE "    MOVE ""REQUEST_METHOD"" TO LNK-ENV-NAME OF LNK-HTM2COB-ENV                  ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-ENV"" USING LNK-HTM2COB-ENV END-CALL                         ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-ENV-VALUE OF LNK-HTM2COB-ENV TO HTM2COB-ENV-VALUE                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF  HTM2COB-ENV-VALUE NOT = ""GET""                                         ".
   02 FILLER PIC X(80) VALUE "    AND HTM2COB-ENV-VALUE NOT = ""POST""                                        ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>Error: wrong REQUEST_METHOD: ""                         ".
   02 FILLER PIC X(80) VALUE "                  HTM2COB-ENV-VALUE "" <BR>"" END-DISPLAY                       ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF  HTM2COB-ENV-VALUE = ""GET""                                             ".
   02 FILLER PIC X(80) VALUE "    AND NOT V-HTM2COB-RM-GET             OF HTM2COB-REQUEST-METHOD-FLAG         ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>HTM2COB-REQUEST-METHOD-FLAG: ""                         ".
   02 FILLER PIC X(80) VALUE "                  HTM2COB-REQUEST-METHOD-FLAG ""<BR>"" END-DISPLAY              ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>Error: wrong REQUEST_METHOD: ""                         ".
   02 FILLER PIC X(80) VALUE "                  HTM2COB-ENV-VALUE "" <BR>"" END-DISPLAY                       ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF  HTM2COB-ENV-VALUE = ""POST""                                            ".
   02 FILLER PIC X(80) VALUE "    AND NOT V-HTM2COB-RM-POST            OF HTM2COB-REQUEST-METHOD-FLAG         ".
   02 FILLER PIC X(80) VALUE "    AND NOT V-HTM2COB-RM-POST-UPLOAD     OF HTM2COB-REQUEST-METHOD-FLAG         ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>HTM2COB-REQUEST-METHOD-FLAG: ""                         ".
   02 FILLER PIC X(80) VALUE "                  HTM2COB-REQUEST-METHOD-FLAG ""<BR>"" END-DISPLAY              ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>Error: wrong REQUEST_METHOD: ""                         ".
   02 FILLER PIC X(80) VALUE "                  HTM2COB-ENV-VALUE "" <BR>"" END-DISPLAY                       ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-ENV-VALUE = ""GET""                                              ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-PROCESS-GET                                              ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""<BR>Error in PROCESS-GET <BR>"" END-DISPLAY              ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-PROCESS-POST                                             ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""<BR>Error in PROCESS-POST <BR>"" END-DISPLAY             ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*> !!!this is only for windows, GnuCOBOL with MS Visual Studio!!!               ".
   02 FILLER PIC X(80) VALUE "*> we have to switch stdin in binary mode                                       ".
   02 FILLER PIC X(80) VALUE ">>IF OS = ""WINDOWS""                                                           ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SET-BINARY-MODE SECTION.                                               ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL STATIC ""_setmode""                                                    ".
   02 FILLER PIC X(80) VALUE "         USING BY VALUE 0                                                       ".
   02 FILLER PIC X(80) VALUE "               BY VALUE HTM2COB-MODE-BINARY                                     ".
   02 FILLER PIC X(80) VALUE "         RETURNING HTM2COB-RET                                                  ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> if cannot set binary mode, then result = -1                              ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-RET = -1                                                         ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: cannot set binary mode""                             ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE ">>END-IF                                                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-PROCESS-GET SECTION.                                                   ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> QUERY_STRING is the URL-encoded information                              ".
   02 FILLER PIC X(80) VALUE "    *> that is sent with GET method request.                                    ".
   02 FILLER PIC X(80) VALUE "    MOVE ""QUERY_STRING"" TO LNK-ENV-NAME OF LNK-HTM2COB-ENV                    ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-ENV"" USING LNK-HTM2COB-ENV END-CALL                         ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-ENV-VALUE OF LNK-HTM2COB-ENV TO HTM2COB-QUERY-STR                  ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION STORED-CHAR-LENGTH(HTM2COB-QUERY-STR)                         ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-QUERY-STR-LEN                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> no data                                                                  ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-QUERY-STR-LEN = ZEROES                                           ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> check QUERY_STRING data length                                           ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-QUERY-STR-LEN > HTM2COB-QUERY-STR-MAX-LEN                        ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>Error: QUERY_STRING length "" HTM2COB-QUERY-STR-LEN     ".
   02 FILLER PIC X(80) VALUE "                 "" greater than "" HTM2COB-QUERY-STR-MAX-LEN ""                ".
   02 FILLER PIC X(80) VALUE "                 max. length <BR>"" END-DISPLAY                                 ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> parse GET data                                                           ".
   02 FILLER PIC X(80) VALUE "    PERFORM HTM2COB-PARSE-GET-POST                                              ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                                ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>Error in PARSE-GET-POST <BR>"" END-DISPLAY              ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-PROCESS-POST SECTION.                                                  ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> check CONTENT_LENGTH                                                     ".
   02 FILLER PIC X(80) VALUE "    MOVE ""CONTENT_LENGTH"" TO LNK-ENV-NAME OF LNK-HTM2COB-ENV                  ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-ENV"" USING LNK-HTM2COB-ENV END-CALL                         ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-ENV-VALUE OF LNK-HTM2COB-ENV TO HTM2COB-ENV-VALUE                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE NUMVAL(HTM2COB-ENV-VALUE)                                              ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-CONTENT-LEN                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-CONTENT-LEN > HTM2COB-CONTENT-MAX-LEN                            ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>Error: CONTENT_LENGTH "" HTM2COB-CONTENT-LEN            ".
   02 FILLER PIC X(80) VALUE "                  "" greater than "" HTM2COB-CONTENT-MAX-LEN ""                 ".
   02 FILLER PIC X(80) VALUE "                  max. length <BR>"" END-DISPLAY                                ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> no data                                                                  ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-CONTENT-LEN = ZEROES                                             ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> check CONTENT_TYPE                                                       ".
   02 FILLER PIC X(80) VALUE "    MOVE ""CONTENT_TYPE"" TO LNK-ENV-NAME OF LNK-HTM2COB-ENV                    ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-ENV"" USING LNK-HTM2COB-ENV END-CALL                         ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-ENV-VALUE OF LNK-HTM2COB-ENV TO HTM2COB-ENV-VALUE                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EVALUATE TRUE                                                               ".
   02 FILLER PIC X(80) VALUE "       *> this is only a POST                                                   ".
   02 FILLER PIC X(80) VALUE "       WHEN HTM2COB-ENV-VALUE(1:33) = ""application/x-www-form-urlencoded""     ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-MULTIPART-NO OF HTM2COB-MULTIPART-FLAG TO TRUE          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> parse POST data                                                    ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-PARSE-GET-POST                                        ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                       ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                PERFORM HTM2COB-DISP-CONTENT-TYPE                               ".
   02 FILLER PIC X(80) VALUE "                DISPLAY ""<BR>Error in PARSE-GET-POST <BR>"" END-DISPLAY        ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "             EXIT SECTION                                                       ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> this is a POST with file UPLOAD                                       ".
   02 FILLER PIC X(80) VALUE "       WHEN HTM2COB-ENV-VALUE(1:29) = ""multipart/form-data; boundary""         ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-MULTIPART-YES OF HTM2COB-MULTIPART-FLAG TO TRUE         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> check request method                                               ".
   02 FILLER PIC X(80) VALUE "          IF  NOT V-HTM2COB-RM-POST-UPLOAD OF HTM2COB-REQUEST-METHOD-FLAG       ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                       ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                PERFORM HTM2COB-DISP-CONTENT-TYPE                               ".
   02 FILLER PIC X(80) VALUE "                DISPLAY ""<BR>HTM2COB-REQUEST-METHOD-FLAG: ""                   ".
   02 FILLER PIC X(80) VALUE "                        HTM2COB-REQUEST-METHOD-FLAG ""<BR>"" END-DISPLAY        ".
   02 FILLER PIC X(80) VALUE "                DISPLAY ""<BR>Error: wrong REQUEST_METHOD: ""                   ".
   02 FILLER PIC X(80) VALUE "                        HTM2COB-ENV-VALUE ""<BR>"" END-DISPLAY                  ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "             SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE              ".
   02 FILLER PIC X(80) VALUE "             EXIT SECTION                                                       ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> parse multipart POST data, save UPLOAD                             ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-PARSE-UPLOAD                                          ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                       ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                PERFORM HTM2COB-DISP-CONTENT-TYPE                               ".
   02 FILLER PIC X(80) VALUE "                DISPLAY ""<BR>Error in PARSE-UPLOAD <BR>"" END-DISPLAY          ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "             EXIT SECTION                                                       ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       WHEN OTHER                                                               ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""<BR>Error: wrong CONTENT_TYPE: ""                        ".
   02 FILLER PIC X(80) VALUE "                     HTM2COB-ENV-VALUE ""<BR>"" END-DISPLAY                     ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "    END-EVALUATE                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-PARSE-GET-POST SECTION.                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-QUERY-STR-IND                                        ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-CHAR-COUNT                                           ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-GETCHAR                                              ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-EOF-NO OF HTM2COB-EOF-FLAG TO TRUE                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> field name comes first                                                   ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-POST-FIELD OF HTM2COB-POST-FIELD-VALUE-FLAG TO TRUE           ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO HTM2COB-TAB-IND                                                   ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO HTM2COB-TAB-NR                                                    ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-TAB-LINE(HTM2COB-TAB-IND)                                ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO HTM2COB-IND-1                                                     ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO HTM2COB-IND-2                                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL V-HTM2COB-EOF-YES   OF HTM2COB-EOF-FLAG                       ".
   02 FILLER PIC X(80) VALUE "            OR    V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                     ".
   02 FILLER PIC X(80) VALUE "       *> read next char from CGI input stream                                  ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-READ-NEXT-CHAR                                           ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-EOF-YES OF HTM2COB-EOF-FLAG                                 ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          EXIT PERFORM                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       EVALUATE TRUE                                                            ".
   02 FILLER PIC X(80) VALUE "          *> end of field name                                                  ".
   02 FILLER PIC X(80) VALUE "          WHEN HTM2COB-CHAR = ""=""                                             ".
   02 FILLER PIC X(80) VALUE "             SET V-HTM2COB-POST-VALUE OF HTM2COB-POST-FIELD-VALUE-FLAG TO TRUE  ".
   02 FILLER PIC X(80) VALUE "             COMPUTE HTM2COB-TAB-FIELD-LEN(HTM2COB-TAB-IND)                     ".
   02 FILLER PIC X(80) VALUE "                   = HTM2COB-IND-1 - 1                                          ".
   02 FILLER PIC X(80) VALUE "             END-COMPUTE                                                        ".
   02 FILLER PIC X(80) VALUE "             MOVE 1 TO HTM2COB-IND-1                                            ".
   02 FILLER PIC X(80) VALUE "             MOVE HTM2COB-IND-2                                                 ".
   02 FILLER PIC X(80) VALUE "               TO HTM2COB-TAB-VALUE-PTR(HTM2COB-TAB-IND)                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> end of value, start a field name                                   ".
   02 FILLER PIC X(80) VALUE "          WHEN HTM2COB-CHAR = ""&""                                             ".
   02 FILLER PIC X(80) VALUE "             SET V-HTM2COB-POST-FIELD OF HTM2COB-POST-FIELD-VALUE-FLAG TO TRUE  ".
   02 FILLER PIC X(80) VALUE "             IF HTM2COB-TAB-IND = 1                                             ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                COMPUTE HTM2COB-TAB-VALUE-LEN(HTM2COB-TAB-IND)                  ".
   02 FILLER PIC X(80) VALUE "                      = HTM2COB-IND-2 - 1                                       ".
   02 FILLER PIC X(80) VALUE "                END-COMPUTE                                                     ".
   02 FILLER PIC X(80) VALUE "             ELSE                                                               ".
   02 FILLER PIC X(80) VALUE "                COMPUTE HTM2COB-TAB-VALUE-LEN(HTM2COB-TAB-IND)                  ".
   02 FILLER PIC X(80) VALUE "                      = HTM2COB-IND-2 - HTM2COB-TAB-VALUE-PTR(HTM2COB-TAB-IND)  ".
   02 FILLER PIC X(80) VALUE "                END-COMPUTE                                                     ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             ADD 1 TO HTM2COB-TAB-IND END-ADD                                   ".
   02 FILLER PIC X(80) VALUE "             ADD 1 TO HTM2COB-TAB-NR  END-ADD                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             *> check table limit                                               ".
   02 FILLER PIC X(80) VALUE "             IF HTM2COB-TAB-IND > HTM2COB-TAB-MAX-LINE                          ".
   02 FILLER PIC X(80) VALUE "             OR HTM2COB-TAB-NR  > HTM2COB-TAB-MAX-LINE                          ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                    ".
   02 FILLER PIC X(80) VALUE "                THEN                                                            ".
   02 FILLER PIC X(80) VALUE "                   PERFORM HTM2COB-DISP-CONTENT-TYPE                            ".
   02 FILLER PIC X(80) VALUE "                   DISPLAY ""<BR>Error: DATA-TAB-NR "" HTM2COB-TAB-NR           ".
   02 FILLER PIC X(80) VALUE "                           "" greater than "" HTM2COB-TAB-MAX-LINE              ".
   02 FILLER PIC X(80) VALUE "                           "" DATA-TAB-MAX-LINE <BR>""                          ".
   02 FILLER PIC X(80) VALUE "                   END-DISPLAY                                                  ".
   02 FILLER PIC X(80) VALUE "                END-IF                                                          ".
   02 FILLER PIC X(80) VALUE "                SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE           ".
   02 FILLER PIC X(80) VALUE "                EXIT SECTION                                                    ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "             *> init next line in the table                                     ".
   02 FILLER PIC X(80) VALUE "             INITIALIZE HTM2COB-TAB-LINE(HTM2COB-TAB-IND)                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> UTF8 special char in hexa code                                     ".
   02 FILLER PIC X(80) VALUE "          WHEN HTM2COB-CHAR = ""%""                                             ".
   02 FILLER PIC X(80) VALUE "             MOVE HTM2COB-CHAR TO HTM2COB-UTF8-STR(1:1)                         ".
   02 FILLER PIC X(80) VALUE "             *> read next char from CGI input stream                            ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-READ-NEXT-CHAR                                     ".
   02 FILLER PIC X(80) VALUE "             IF V-HTM2COB-EOF-YES OF HTM2COB-EOF-FLAG                           ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                EXIT PERFORM                                                    ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "             MOVE HTM2COB-CHAR TO HTM2COB-UTF8-STR(2:1)                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             *> read next char from CGI input stream                            ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-READ-NEXT-CHAR                                     ".
   02 FILLER PIC X(80) VALUE "             IF V-HTM2COB-EOF-YES OF HTM2COB-EOF-FLAG                           ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                EXIT PERFORM                                                    ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "             MOVE HTM2COB-CHAR TO HTM2COB-UTF8-STR(3:1)                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             *> convert UTF8 string                                             ".
   02 FILLER PIC X(80) VALUE "             INITIALIZE LNK-HTM2COB-DECODE                                      ".
   02 FILLER PIC X(80) VALUE "             MOVE HTM2COB-UTF8-STR TO LNK-UTF8-STR OF LNK-HTM2COB-DECODE        ".
   02 FILLER PIC X(80) VALUE "             CALL ""HTM2COB-DECODE"" USING LNK-HTM2COB-DECODE END-CALL          ".
   02 FILLER PIC X(80) VALUE "             MOVE LNK-UTF8-VAL OF LNK-HTM2COB-DECODE                            ".
   02 FILLER PIC X(80) VALUE "               TO HTM2COB-DATA-VALUE(HTM2COB-IND-2:1)                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             *> check value limit                                               ".
   02 FILLER PIC X(80) VALUE "             ADD 1 TO HTM2COB-IND-2 END-ADD                                     ".
   02 FILLER PIC X(80) VALUE "             IF HTM2COB-IND-2 > HTM2COB-DATA-VALUE-MAX-LEN                      ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                    ".
   02 FILLER PIC X(80) VALUE "                THEN                                                            ".
   02 FILLER PIC X(80) VALUE "                   PERFORM HTM2COB-DISP-CONTENT-TYPE                            ".
   02 FILLER PIC X(80) VALUE "                   DISPLAY ""<BR>Error: DATA-VALUE-LEN "" HTM2COB-IND-2         ".
   02 FILLER PIC X(80) VALUE "                           "" greater than "" HTM2COB-DATA-VALUE-MAX-LEN        ".
   02 FILLER PIC X(80) VALUE "                           "" DATA-VALUE-MAX-LEN <BR>""                         ".
   02 FILLER PIC X(80) VALUE "                   END-DISPLAY                                                  ".
   02 FILLER PIC X(80) VALUE "                END-IF                                                          ".
   02 FILLER PIC X(80) VALUE "                SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE           ".
   02 FILLER PIC X(80) VALUE "                EXIT SECTION                                                    ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> a SPACE char                                                       ".
   02 FILLER PIC X(80) VALUE "          WHEN HTM2COB-CHAR = ""+""                                             ".
   02 FILLER PIC X(80) VALUE "             MOVE SPACES                                                        ".
   02 FILLER PIC X(80) VALUE "               TO HTM2COB-DATA-VALUE(HTM2COB-IND-2:1)                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             *> check value limit                                               ".
   02 FILLER PIC X(80) VALUE "             ADD 1 TO HTM2COB-IND-2 END-ADD                                     ".
   02 FILLER PIC X(80) VALUE "             IF HTM2COB-IND-2 > HTM2COB-DATA-VALUE-MAX-LEN                      ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                    ".
   02 FILLER PIC X(80) VALUE "                THEN                                                            ".
   02 FILLER PIC X(80) VALUE "                   PERFORM HTM2COB-DISP-CONTENT-TYPE                            ".
   02 FILLER PIC X(80) VALUE "                   DISPLAY ""<BR>Error: DATA-VALUE-LEN "" HTM2COB-IND-2         ".
   02 FILLER PIC X(80) VALUE "                           "" greater than "" HTM2COB-DATA-VALUE-MAX-LEN        ".
   02 FILLER PIC X(80) VALUE "                           "" DATA-VALUE-MAX-LEN <BR>""                         ".
   02 FILLER PIC X(80) VALUE "                   END-DISPLAY                                                  ".
   02 FILLER PIC X(80) VALUE "                END-IF                                                          ".
   02 FILLER PIC X(80) VALUE "                SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE           ".
   02 FILLER PIC X(80) VALUE "                EXIT SECTION                                                    ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> other chars                                                        ".
   02 FILLER PIC X(80) VALUE "          WHEN OTHER                                                            ".
   02 FILLER PIC X(80) VALUE "             IF V-HTM2COB-POST-FIELD OF HTM2COB-POST-FIELD-VALUE-FLAG           ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                MOVE HTM2COB-CHAR                                               ".
   02 FILLER PIC X(80) VALUE "                  TO HTM2COB-TAB-FIELD(HTM2COB-TAB-IND)                         ".
   02 FILLER PIC X(80) VALUE "                                           (HTM2COB-IND-1:1)                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "                *> check field limit                                            ".
   02 FILLER PIC X(80) VALUE "                ADD 1 TO HTM2COB-IND-1 END-ADD                                  ".
   02 FILLER PIC X(80) VALUE "                IF HTM2COB-IND-1 > HTM2COB-TAB-FIELD-MAX-LEN                    ".
   02 FILLER PIC X(80) VALUE "                THEN                                                            ".
   02 FILLER PIC X(80) VALUE "                   IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                 ".
   02 FILLER PIC X(80) VALUE "                   THEN                                                         ".
   02 FILLER PIC X(80) VALUE "                      PERFORM HTM2COB-DISP-CONTENT-TYPE                         ".
   02 FILLER PIC X(80) VALUE "                      DISPLAY ""<BR>Error: FIELD-LEN "" HTM2COB-IND-1           ".
   02 FILLER PIC X(80) VALUE "                              "" greater than "" HTM2COB-TAB-FIELD-MAX-LEN      ".
   02 FILLER PIC X(80) VALUE "                              "" DATA-TAB-FIELD-MAX-LEN <BR>""                  ".
   02 FILLER PIC X(80) VALUE "                      END-DISPLAY                                               ".
   02 FILLER PIC X(80) VALUE "                      DISPLAY ""<BR>HTM2COB-TAB-FIELD: ""                       ".
   02 FILLER PIC X(80) VALUE "                              HTM2COB-TAB-FIELD(HTM2COB-TAB-IND) ""<BR>""       ".
   02 FILLER PIC X(80) VALUE "                      END-DISPLAY                                               ".
   02 FILLER PIC X(80) VALUE "                   END-IF                                                       ".
   02 FILLER PIC X(80) VALUE "                   SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE        ".
   02 FILLER PIC X(80) VALUE "                   EXIT SECTION                                                 ".
   02 FILLER PIC X(80) VALUE "                END-IF                                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "                *> check field ALPHANUM and ""_"", ""-""                        ".
   02 FILLER PIC X(80) VALUE "                IF FUNCTION TRIM(HTM2COB-TAB-FIELD(HTM2COB-TAB-IND))            ".
   02 FILLER PIC X(80) VALUE "                   IS NOT FIELDNAME                                             ".
   02 FILLER PIC X(80) VALUE "                THEN                                                            ".
   02 FILLER PIC X(80) VALUE "                   IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                 ".
   02 FILLER PIC X(80) VALUE "                   THEN                                                         ".
   02 FILLER PIC X(80) VALUE "                      PERFORM HTM2COB-DISP-CONTENT-TYPE                         ".
   02 FILLER PIC X(80) VALUE "                      DISPLAY ""<BR>Error: invalid char in FIELD<BR>""          ".
   02 FILLER PIC X(80) VALUE "                      END-DISPLAY                                               ".
   02 FILLER PIC X(80) VALUE "                      DISPLAY ""<BR>HTM2COB-TAB-FIELD: ""                       ".
   02 FILLER PIC X(80) VALUE "                              HTM2COB-TAB-FIELD(HTM2COB-TAB-IND) ""<BR>""       ".
   02 FILLER PIC X(80) VALUE "                      END-DISPLAY                                               ".
   02 FILLER PIC X(80) VALUE "                   END-IF                                                       ".
   02 FILLER PIC X(80) VALUE "                   SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE        ".
   02 FILLER PIC X(80) VALUE "                   EXIT SECTION                                                 ".
   02 FILLER PIC X(80) VALUE "                END-IF                                                          ".
   02 FILLER PIC X(80) VALUE "             ELSE                                                               ".
   02 FILLER PIC X(80) VALUE "                MOVE HTM2COB-CHAR                                               ".
   02 FILLER PIC X(80) VALUE "                  TO HTM2COB-DATA-VALUE(HTM2COB-IND-2:1)                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "                *> check value limit                                            ".
   02 FILLER PIC X(80) VALUE "                ADD 1 TO HTM2COB-IND-2 END-ADD                                  ".
   02 FILLER PIC X(80) VALUE "                IF HTM2COB-IND-2 > HTM2COB-DATA-VALUE-MAX-LEN                   ".
   02 FILLER PIC X(80) VALUE "                THEN                                                            ".
   02 FILLER PIC X(80) VALUE "                   IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                 ".
   02 FILLER PIC X(80) VALUE "                   THEN                                                         ".
   02 FILLER PIC X(80) VALUE "                      PERFORM HTM2COB-DISP-CONTENT-TYPE                         ".
   02 FILLER PIC X(80) VALUE "                      DISPLAY ""<BR>Error: DATA-VALUE-LEN "" HTM2COB-IND-2      ".
   02 FILLER PIC X(80) VALUE "                              "" greater than "" HTM2COB-DATA-VALUE-MAX-LEN     ".
   02 FILLER PIC X(80) VALUE "                              "" DATA-VALUE-MAX-LEN <BR>""                      ".
   02 FILLER PIC X(80) VALUE "                      END-DISPLAY                                               ".
   02 FILLER PIC X(80) VALUE "                   END-IF                                                       ".
   02 FILLER PIC X(80) VALUE "                   SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE        ".
   02 FILLER PIC X(80) VALUE "                   EXIT SECTION                                                 ".
   02 FILLER PIC X(80) VALUE "                END-IF                                                          ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "       END-EVALUATE                                                             ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-TAB-IND = 1                                                      ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       COMPUTE HTM2COB-TAB-VALUE-LEN(HTM2COB-TAB-IND)                           ".
   02 FILLER PIC X(80) VALUE "             = HTM2COB-IND-2 - 1                                                ".
   02 FILLER PIC X(80) VALUE "       END-COMPUTE                                                              ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       COMPUTE HTM2COB-TAB-VALUE-LEN(HTM2COB-TAB-IND)                           ".
   02 FILLER PIC X(80) VALUE "             = HTM2COB-IND-2 - HTM2COB-TAB-VALUE-PTR(HTM2COB-TAB-IND)           ".
   02 FILLER PIC X(80) VALUE "       END-COMPUTE                                                              ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-READ-NEXT-CHAR SECTION.                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-RM-GET OF HTM2COB-REQUEST-METHOD-FLAG                          ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       *> data with GET                                                         ".
   02 FILLER PIC X(80) VALUE "       ADD 1 TO HTM2COB-QUERY-STR-IND END-ADD                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-QUERY-STR-IND > HTM2COB-QUERY-STR-MAX-LEN                     ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""<BR>Error: QUERY-STR-IND "" HTM2COB-QUERY-STR-IND        ".
   02 FILLER PIC X(80) VALUE "                     "" greater than "" HTM2COB-QUERY-STR-MAX-LEN               ".
   02 FILLER PIC X(80) VALUE "                     "" QUERY-STR-MAX-LEN <BR>""                                ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-QUERY-STR-IND > HTM2COB-QUERY-STR-LEN                         ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-EOF-YES OF HTM2COB-EOF-FLAG TO TRUE                     ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE HTM2COB-QUERY-STR(HTM2COB-QUERY-STR-IND:1)                          ".
   02 FILLER PIC X(80) VALUE "         TO HTM2COB-CHAR                                                        ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       *> data with POST                                                        ".
   02 FILLER PIC X(80) VALUE "       ADD 1 TO HTM2COB-CHAR-COUNT END-ADD                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-CHAR-COUNT > HTM2COB-CONTENT-LEN + 1                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""<BR>Error: CHAR-COUNT "" HTM2COB-CHAR-COUNT              ".
   02 FILLER PIC X(80) VALUE "                     "" greater than "" HTM2COB-CONTENT-LEN                     ".
   02 FILLER PIC X(80) VALUE "                     "" CONTENT-LEN <BR>"" END-DISPLAY                          ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       CALL STATIC ""getchar"" RETURNING HTM2COB-GETCHAR END-CALL               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-GETCHAR < ZEROES                                              ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-EOF-YES OF HTM2COB-EOF-FLAG TO TRUE                     ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE HTM2COB-GETCHAR TO HTM2COB-CHAR-R                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> !!!only for test!!!                                                      ".
   02 FILLER PIC X(80) VALUE "    *>IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                              ".
   02 FILLER PIC X(80) VALUE "    *>THEN                                                                      ".
   02 FILLER PIC X(80) VALUE "    *>   PERFORM HTM2COB-DISP-CONTENT-TYPE                                      ".
   02 FILLER PIC X(80) VALUE "    *>   DISPLAY ""HTM2COB-GETCHAR: "" HTM2COB-GETCHAR END-DISPLAY              ".
   02 FILLER PIC X(80) VALUE "    *>   DISPLAY "", HTM2COB-CHAR: "" HTM2COB-CHAR                              ".
   02 FILLER PIC X(80) VALUE "    *>           WITH NO ADVANCING END-DISPLAY                                  ".
   02 FILLER PIC X(80) VALUE "    *>END-IF                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-PARSE-UPLOAD SECTION.                                                  ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM HTM2COB-UPL-GET-BOUNDARY                                            ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                                ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>Error in UPL-GET-BOUNDARY <BR>"" END-DISPLAY            ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> !!!only for test, display boundary data!!!                               ".
   02 FILLER PIC X(80) VALUE "    *> IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "    *> THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "    *>    PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "    *>    DISPLAY ""BOUNDARY: "" HTM2COB-BOUNDARY ""<BR>"" END-DISPLAY          ".
   02 FILLER PIC X(80) VALUE "    *>    DISPLAY ""BOUNDARY-LEN: "" HTM2COB-BOUNDARY-LEN ""<BR>"" END-DISPLAY  ".
   02 FILLER PIC X(80) VALUE "    *>    DISPLAY ""BOUNDARY-EOF: "" HTM2COB-BOUNDARY-EOF ""<BR>"" ""<BR>""     ".
   02 FILLER PIC X(80) VALUE "    *>                                                             END-DISPLAY  ".
   02 FILLER PIC X(80) VALUE "    *> END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM HTM2COB-UPL-READ-POST                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> !!!only for test!!!                                                      ".
   02 FILLER PIC X(80) VALUE "    *> success, if boundary EOF string found, without any error                 ".
   02 FILLER PIC X(80) VALUE "    *> IF  V-HTM2COB-ERROR-NO OF HTM2COB-ERROR-FLAG                             ".
   02 FILLER PIC X(80) VALUE "    *> AND V-HTM2COB-BOUNDARY-EOF-YES OF HTM2COB-BOUNDARY-EOF-FLAG              ".
   02 FILLER PIC X(80) VALUE "    *> THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "    *>    IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "    *>    THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "    *>       PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "    *>       DISPLAY ""<BR>"" ""<BR>""                                          ".
   02 FILLER PIC X(80) VALUE "    *>               ""BOUNDARY-EOF found, CGI post processed successfully""    ".
   02 FILLER PIC X(80) VALUE "    *>               ""<BR>"" ""<BR>""                                          ".
   02 FILLER PIC X(80) VALUE "    *>       END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "    *>    END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "    *> END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-UPL-GET-BOUNDARY SECTION.                                              ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-ENV-VALUE(1:30) = ""multipart/form-data; boundary=""             ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       MOVE HTM2COB-ENV-VALUE(31:) TO HTM2COB-BOUNDARY                          ".
   02 FILLER PIC X(80) VALUE "       MOVE FUNCTION STORED-CHAR-LENGTH(HTM2COB-BOUNDARY)                       ".
   02 FILLER PIC X(80) VALUE "         TO HTM2COB-BOUNDARY-LEN                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE SPACES TO HTM2COB-BOUNDARY-EOF                                      ".
   02 FILLER PIC X(80) VALUE "       STRING HTM2COB-BOUNDARY(1:HTM2COB-BOUNDARY-LEN)                          ".
   02 FILLER PIC X(80) VALUE "              ""--""                                                            ".
   02 FILLER PIC X(80) VALUE "         INTO HTM2COB-BOUNDARY-EOF                                              ".
   02 FILLER PIC X(80) VALUE "       END-STRING                                                               ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: can not find boundary string: ""                     ".
   02 FILLER PIC X(80) VALUE "                  HTM2COB-ENV-VALUE                                             ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-UPL-READ-POST SECTION.                                                 ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-CHAR-COUNT                                           ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-GETCHAR                                              ".
   02 FILLER PIC X(80) VALUE "    MOVE 1 TO HTM2COB-IND-2                                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> read a ""boundary"" line with EOL                                        ".
   02 FILLER PIC X(80) VALUE "    PERFORM HTM2COB-READ-NEXT-LINE                                              ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-EOL-YES OF HTM2COB-EOL-FLAG                                    ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-CHECK-BOUNDARY                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> this must be a ""boundary"" line                                      ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-BOUNDARY-NO OF HTM2COB-BOUNDARY-FLAG                        ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: boundary line not found""                         ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: end of line not found""                              ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL HTM2COB-CHAR-COUNT > HTM2COB-CONTENT-LEN                      ".
   02 FILLER PIC X(80) VALUE "            OR    HTM2COB-GETCHAR < ZEROES                                      ".
   02 FILLER PIC X(80) VALUE "            OR    V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                     ".
   02 FILLER PIC X(80) VALUE "            OR    V-HTM2COB-BOUNDARY-EOF-YES OF HTM2COB-BOUNDARY-EOF-FLAG       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> read a ""Content-Disposition"" line with EOL                          ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-READ-NEXT-LINE                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> this must have an EOL                                                 ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-EOL-YES OF HTM2COB-EOL-FLAG                                 ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-CHECK-CONTENT-DISP                                    ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             EXIT SECTION                                                       ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> this must be a ""Content-Disposition"" line                        ".
   02 FILLER PIC X(80) VALUE "          EVALUATE TRUE                                                         ".
   02 FILLER PIC X(80) VALUE "          WHEN V-HTM2COB-CONTENT-DISP-FIELD OF HTM2COB-CONTENT-DISP-FLAG        ".
   02 FILLER PIC X(80) VALUE "             *> read and save field value                                       ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-PARSE-FIELD-VALUE                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          WHEN V-HTM2COB-CONTENT-DISP-FILE  OF HTM2COB-CONTENT-DISP-FLAG        ".
   02 FILLER PIC X(80) VALUE "             *> read and save the uploaded file                                 ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-PARSE-FILE-UPLOAD                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          WHEN OTHER                                                            ".
   02 FILLER PIC X(80) VALUE "             IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                       ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                PERFORM HTM2COB-DISP-CONTENT-TYPE                               ".
   02 FILLER PIC X(80) VALUE "                DISPLAY ""Error: Content-Disposition not found""                ".
   02 FILLER PIC X(80) VALUE "                        ""<BR>""                                                ".
   02 FILLER PIC X(80) VALUE "                END-DISPLAY                                                     ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "             SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE              ".
   02 FILLER PIC X(80) VALUE "             EXIT SECTION                                                       ".
   02 FILLER PIC X(80) VALUE "          END-EVALUATE                                                          ".
   02 FILLER PIC X(80) VALUE "       ELSE                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: end of line not found""                           ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-READ-NEXT-LINE SECTION.                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES    TO HTM2COB-INPUT-BUF-IND                                     ".
   02 FILLER PIC X(80) VALUE "    MOVE LOW-VALUE TO HTM2COB-INPUT-BUF                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-EOL-NO OF HTM2COB-EOL-FLAG TO TRUE                            ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-EOF-NO OF HTM2COB-EOF-FLAG TO TRUE                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM UNTIL HTM2COB-CHAR-COUNT > HTM2COB-CONTENT-LEN                      ".
   02 FILLER PIC X(80) VALUE "            OR    HTM2COB-INPUT-BUF-IND > HTM2COB-INPUT-BUF-MAX-LEN             ".
   02 FILLER PIC X(80) VALUE "            OR    HTM2COB-GETCHAR < ZEROES                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       CALL STATIC ""getchar"" RETURNING HTM2COB-GETCHAR END-CALL               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-CHAR-COUNT > HTM2COB-CONTENT-LEN                              ".
   02 FILLER PIC X(80) VALUE "       OR HTM2COB-GETCHAR < ZEROES                                              ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-EOF-YES OF HTM2COB-EOF-FLAG TO TRUE                     ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       ADD 1 TO HTM2COB-CHAR-COUNT    END-ADD                                   ".
   02 FILLER PIC X(80) VALUE "       ADD 1 TO HTM2COB-INPUT-BUF-IND END-ADD                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-INPUT-BUF-IND <= HTM2COB-INPUT-BUF-MAX-LEN                    ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          MOVE HTM2COB-GETCHAR TO HTM2COB-CHAR-R                                ".
   02 FILLER PIC X(80) VALUE "          MOVE HTM2COB-CHAR TO HTM2COB-INPUT-BUF(HTM2COB-INPUT-BUF-IND:1)       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> !!!only for test!!!                                                ".
   02 FILLER PIC X(80) VALUE "          *>IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                        ".
   02 FILLER PIC X(80) VALUE "          *>THEN                                                                ".
   02 FILLER PIC X(80) VALUE "          *>   PERFORM HTM2COB-DISP-CONTENT-TYPE                                ".
   02 FILLER PIC X(80) VALUE "          *>   *> received chars                                                ".
   02 FILLER PIC X(80) VALUE "          *>   DISPLAY HTM2COB-CHAR WITH NO ADVANCING END-DISPLAY               ".
   02 FILLER PIC X(80) VALUE "          *>   *> received chars with num values                                ".
   02 FILLER PIC X(80) VALUE "          *>   DISPLAY ""("" HTM2COB-GETCHAR "")"" END-DISPLAY                  ".
   02 FILLER PIC X(80) VALUE "          *>   IF HTM2COB-GETCHAR = 10                                          ".
   02 FILLER PIC X(80) VALUE "          *>   THEN                                                             ".
   02 FILLER PIC X(80) VALUE "          *>      DISPLAY ""<BR>"" END-DISPLAY                                  ".
   02 FILLER PIC X(80) VALUE "          *>   END-IF                                                           ".
   02 FILLER PIC X(80) VALUE "          *>END-IF                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> check end of line X""0A"" or X""0D0A""                             ".
   02 FILLER PIC X(80) VALUE "          IF HTM2COB-GETCHAR = 10                                               ".
   02 FILLER PIC X(80) VALUE "          OR HTM2COB-INPUT-BUF-IND = HTM2COB-INPUT-BUF-MAX-LEN                  ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             SET V-HTM2COB-EOL-YES OF HTM2COB-EOL-FLAG TO TRUE                  ".
   02 FILLER PIC X(80) VALUE "             EXIT SECTION                                                       ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "       ELSE                                                                     ".
   02 FILLER PIC X(80) VALUE "          *> input buffer full                                                  ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-CHECK-BOUNDARY SECTION.                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-BOUNDARY-NO     OF HTM2COB-BOUNDARY-FLAG     TO TRUE          ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-BOUNDARY-EOF-NO OF HTM2COB-BOUNDARY-EOF-FLAG TO TRUE          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> search boundary string                                                   ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-INSPECT-COUNT                                        ".
   02 FILLER PIC X(80) VALUE "    INSPECT HTM2COB-INPUT-BUF(1:HTM2COB-INPUT-BUF-IND)                          ".
   02 FILLER PIC X(80) VALUE "       TALLYING HTM2COB-INSPECT-COUNT                                           ".
   02 FILLER PIC X(80) VALUE "       FOR ALL  HTM2COB-BOUNDARY(1:HTM2COB-BOUNDARY-LEN)                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-INSPECT-COUNT > ZEROES                                           ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-BOUNDARY-YES OF HTM2COB-BOUNDARY-FLAG TO TRUE              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> search boundary EOF string                                            ".
   02 FILLER PIC X(80) VALUE "       MOVE ZEROES TO HTM2COB-INSPECT-COUNT                                     ".
   02 FILLER PIC X(80) VALUE "       INSPECT HTM2COB-INPUT-BUF(1:HTM2COB-INPUT-BUF-IND)                       ".
   02 FILLER PIC X(80) VALUE "          TALLYING HTM2COB-INSPECT-COUNT                                        ".
   02 FILLER PIC X(80) VALUE "          FOR ALL  HTM2COB-BOUNDARY-EOF(1:HTM2COB-BOUNDARY-LEN + 2)             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-INSPECT-COUNT > ZEROES                                        ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-BOUNDARY-EOF-YES OF HTM2COB-BOUNDARY-EOF-FLAG TO TRUE   ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-CHECK-CONTENT-DISP SECTION.                                            ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-CONTENT-DISP-ERROR OF HTM2COB-CONTENT-DISP-FLAG TO TRUE       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-INPUT-BUF(1:38) NOT =                                            ".
   02 FILLER PIC X(80) VALUE "       ""Content-Disposition: form-data; name=""""""                            ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> for every Content-Disposition there is a line in the internal table      ".
   02 FILLER PIC X(80) VALUE "    ADD 1 TO HTM2COB-TAB-IND END-ADD                                            ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-TAB-IND TO HTM2COB-TAB-NR                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-TAB-IND > HTM2COB-TAB-MAX-LINE                                   ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: internal table full""                                ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> get length of field name                                                 ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-INSPECT-COUNT                                        ".
   02 FILLER PIC X(80) VALUE "    INSPECT HTM2COB-INPUT-BUF(39:)                                              ".
   02 FILLER PIC X(80) VALUE "       TALLYING HTM2COB-INSPECT-COUNT                                           ".
   02 FILLER PIC X(80) VALUE "       FOR CHARACTERS BEFORE INITIAL """"""""                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> save length of field name                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-INSPECT-COUNT                                                  ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-TAB-FIELD-LEN(HTM2COB-TAB-IND)                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> save field name                                                          ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-INPUT-BUF(39:HTM2COB-INSPECT-COUNT)                            ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-TAB-FIELD(HTM2COB-TAB-IND)                                     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> check field ALPHANUM and ""_"", ""-""                                    ".
   02 FILLER PIC X(80) VALUE "    IF FUNCTION TRIM(HTM2COB-TAB-FIELD(HTM2COB-TAB-IND)) IS NOT FIELDNAME       ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>Error: invalid char in FIELD<BR>""                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""<BR>HTM2COB-TAB-FIELD: ""                                   ".
   02 FILLER PIC X(80) VALUE "                  HTM2COB-TAB-FIELD(HTM2COB-TAB-IND) ""<BR>""                   ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> search number of fields                                                  ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-INSPECT-COUNT                                        ".
   02 FILLER PIC X(80) VALUE "    INSPECT HTM2COB-INPUT-BUF(39:)                                              ".
   02 FILLER PIC X(80) VALUE "       TALLYING HTM2COB-INSPECT-COUNT                                           ".
   02 FILLER PIC X(80) VALUE "       FOR ALL """"""""                                                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> this is only one field --> exit section                                  ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-INSPECT-COUNT = 1                                                ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-CONTENT-DISP-FIELD OF HTM2COB-CONTENT-DISP-FLAG TO TRUE    ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-TAB-FILE-NO OF HTM2COB-TAB-FILE-FLAG(HTM2COB-TAB-IND)      ".
   02 FILLER PIC X(80) VALUE "                                                                     TO TRUE    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> search file name                                                         ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-INSPECT-COUNT                                        ".
   02 FILLER PIC X(80) VALUE "    INSPECT HTM2COB-INPUT-BUF(39 + HTM2COB-TAB-FIELD-LEN(HTM2COB-TAB-IND):)     ".
   02 FILLER PIC X(80) VALUE "       TALLYING HTM2COB-INSPECT-COUNT                                           ".
   02 FILLER PIC X(80) VALUE "       FOR CHARACTERS BEFORE INITIAL ""filename=""""""                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-INSPECT-COUNT = 3                                                ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-CONTENT-DISP-FILE OF HTM2COB-CONTENT-DISP-FLAG TO TRUE     ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-TAB-FILE-YES OF HTM2COB-TAB-FILE-FLAG(HTM2COB-TAB-IND)     ".
   02 FILLER PIC X(80) VALUE "                                                                    TO TRUE     ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> get length of file name                                               ".
   02 FILLER PIC X(80) VALUE "       MOVE ZEROES TO HTM2COB-INSPECT-COUNT                                     ".
   02 FILLER PIC X(80) VALUE "       INSPECT HTM2COB-INPUT-BUF(39 + HTM2COB-TAB-FIELD-LEN(HTM2COB-TAB-IND)    ".
   02 FILLER PIC X(80) VALUE "                                    + 13:)                                      ".
   02 FILLER PIC X(80) VALUE "          TALLYING HTM2COB-INSPECT-COUNT                                        ".
   02 FILLER PIC X(80) VALUE "          FOR CHARACTERS BEFORE INITIAL """"""""                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> save length of file name in temp                                      ".
   02 FILLER PIC X(80) VALUE "       MOVE HTM2COB-INSPECT-COUNT                                               ".
   02 FILLER PIC X(80) VALUE "         TO HTM2COB-TMP-FILE-NAME-LEN                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> save file name in temp                                                ".
   02 FILLER PIC X(80) VALUE "       MOVE HTM2COB-INPUT-BUF(39 + HTM2COB-TAB-FIELD-LEN(HTM2COB-TAB-IND)       ".
   02 FILLER PIC X(80) VALUE "                                 + 13:HTM2COB-INSPECT-COUNT)                    ".
   02 FILLER PIC X(80) VALUE "         TO HTM2COB-TMP-FILE-NAME                                               ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> Check file name. Internet Explorer sends a file name with full        ".
   02 FILLER PIC X(80) VALUE "       *> file path, but Firefox sends only a file name.                        ".
   02 FILLER PIC X(80) VALUE "       MOVE ZEROES TO HTM2COB-INSPECT-COUNT                                     ".
   02 FILLER PIC X(80) VALUE "       INSPECT HTM2COB-TMP-FILE-NAME                                            ".
   02 FILLER PIC X(80) VALUE "          TALLYING HTM2COB-INSPECT-COUNT                                        ".
   02 FILLER PIC X(80) VALUE "          FOR ALL ""\"" ""/""                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-INSPECT-COUNT = ZEROES                                        ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          *> this is only a file name without file path                         ".
   02 FILLER PIC X(80) VALUE "          *> save length of file name                                           ".
   02 FILLER PIC X(80) VALUE "          MOVE HTM2COB-TMP-FILE-NAME-LEN                                        ".
   02 FILLER PIC X(80) VALUE "            TO HTM2COB-TAB-FILE-NAME-LEN(HTM2COB-TAB-IND)                       ".
   02 FILLER PIC X(80) VALUE "          *> save file name                                                     ".
   02 FILLER PIC X(80) VALUE "          MOVE HTM2COB-TMP-FILE-NAME                                            ".
   02 FILLER PIC X(80) VALUE "            TO HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND)                           ".
   02 FILLER PIC X(80) VALUE "       ELSE                                                                     ".
   02 FILLER PIC X(80) VALUE "          *> this is a file name with full file path, get file name from it     ".
   02 FILLER PIC X(80) VALUE "          MOVE ZEROES TO HTM2COB-INSPECT-COUNT                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          MOVE ZEROES TO HTM2COB-INSPECT-COUNT-1                                ".
   02 FILLER PIC X(80) VALUE "          INSPECT FUNCTION REVERSE(HTM2COB-TMP-FILE-NAME)                       ".
   02 FILLER PIC X(80) VALUE "             TALLYING HTM2COB-INSPECT-COUNT-1                                   ".
   02 FILLER PIC X(80) VALUE "             FOR CHARACTERS BEFORE INITIAL ""\""                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          MOVE ZEROES TO HTM2COB-INSPECT-COUNT-2                                ".
   02 FILLER PIC X(80) VALUE "          INSPECT FUNCTION REVERSE(HTM2COB-TMP-FILE-NAME)                       ".
   02 FILLER PIC X(80) VALUE "             TALLYING HTM2COB-INSPECT-COUNT-2                                   ".
   02 FILLER PIC X(80) VALUE "             FOR CHARACTERS BEFORE INITIAL ""/""                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          MOVE FUNCTION MIN(HTM2COB-INSPECT-COUNT-1, HTM2COB-INSPECT-COUNT-2)   ".
   02 FILLER PIC X(80) VALUE "            TO HTM2COB-INSPECT-COUNT                                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          COMPUTE HTM2COB-TMP-FILE-PATH-LEN                                     ".
   02 FILLER PIC X(80) VALUE "                = FUNCTION LENGTH(HTM2COB-TMP-FILE-NAME)                        ".
   02 FILLER PIC X(80) VALUE "                - HTM2COB-INSPECT-COUNT + 1                                     ".
   02 FILLER PIC X(80) VALUE "          END-COMPUTE                                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> save length of file name                                           ".
   02 FILLER PIC X(80) VALUE "          COMPUTE HTM2COB-TAB-FILE-NAME-LEN(HTM2COB-TAB-IND)                    ".
   02 FILLER PIC X(80) VALUE "                = HTM2COB-TMP-FILE-NAME-LEN                                     ".
   02 FILLER PIC X(80) VALUE "                - HTM2COB-TMP-FILE-PATH-LEN + 1                                 ".
   02 FILLER PIC X(80) VALUE "          END-COMPUTE                                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> save file name                                                     ".
   02 FILLER PIC X(80) VALUE "          MOVE HTM2COB-TMP-FILE-NAME(HTM2COB-TMP-FILE-PATH-LEN:                 ".
   02 FILLER PIC X(80) VALUE "                                     HTM2COB-TAB-FILE-NAME-LEN(HTM2COB-TAB-IND))".
   02 FILLER PIC X(80) VALUE "            TO HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND)                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> check filename chars                                                  ".
   02 FILLER PIC X(80) VALUE "       IF FUNCTION TRIM(HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND))                 ".
   02 FILLER PIC X(80) VALUE "          IS NOT FILENAME                                                       ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: invalid char in filename""                        ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> check filename extension                                              ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-CHECK-FILENAME-EXT                                       ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    ELSE                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: filename not found in Content-Disposition""          ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-PARSE-FIELD-VALUE SECTION.                                             ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> this must be an empty line                                               ".
   02 FILLER PIC X(80) VALUE "    PERFORM HTM2COB-READ-NEXT-LINE                                              ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-EOL-NO OF HTM2COB-EOL-FLAG                                     ".
   02 FILLER PIC X(80) VALUE "    OR HTM2COB-INPUT-BUF(1:2) NOT = HTM2COB-CRLF                                ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: end of line not found""                              ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> init char counter                                                        ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-IND-1                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-FIRST-LINE-YES OF HTM2COB-FIRST-LINE-FLAG TO TRUE             ".
   02 FILLER PIC X(80) VALUE "    MOVE SPACES TO HTM2COB-INPUT-BUF-SAVE                                       ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-INPUT-BUF-SAVE-IND                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> set value pointer in the table                                           ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-IND-2                                                          ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-TAB-VALUE-PTR(HTM2COB-TAB-IND)                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM TEST AFTER                                                          ".
   02 FILLER PIC X(80) VALUE "      UNTIL V-HTM2COB-BOUNDARY-YES     OF HTM2COB-BOUNDARY-FLAG                 ".
   02 FILLER PIC X(80) VALUE "      OR    V-HTM2COB-BOUNDARY-EOF-YES OF HTM2COB-BOUNDARY-EOF-FLAG             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> read a line                                                           ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-READ-NEXT-LINE                                           ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-EOF-YES OF HTM2COB-EOF-FLAG                                 ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: boundary line not found""                         ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-CHECK-BOUNDARY                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-BOUNDARY-YES     OF HTM2COB-BOUNDARY-FLAG                   ".
   02 FILLER PIC X(80) VALUE "       OR V-HTM2COB-BOUNDARY-EOF-YES OF HTM2COB-BOUNDARY-EOF-FLAG               ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          *> end of field reached                                               ".
   02 FILLER PIC X(80) VALUE "          *> write last line without CRLF                                       ".
   02 FILLER PIC X(80) VALUE "          IF HTM2COB-INPUT-BUF-SAVE-IND > 2                                     ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             IF HTM2COB-IND-2 < HTM2COB-DATA-VALUE-MAX-LEN                      ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                MOVE HTM2COB-INPUT-BUF-SAVE(1:HTM2COB-INPUT-BUF-SAVE-IND - 2)   ".
   02 FILLER PIC X(80) VALUE "                  TO HTM2COB-DATA-VALUE(HTM2COB-IND-2:)                         ".
   02 FILLER PIC X(80) VALUE "                COMPUTE HTM2COB-IND-1 = HTM2COB-IND-1                           ".
   02 FILLER PIC X(80) VALUE "                                 + HTM2COB-INPUT-BUF-SAVE-IND - 2               ".
   02 FILLER PIC X(80) VALUE "                END-COMPUTE                                                     ".
   02 FILLER PIC X(80) VALUE "                MOVE HTM2COB-IND-1                                              ".
   02 FILLER PIC X(80) VALUE "                  TO HTM2COB-TAB-VALUE-LEN(HTM2COB-TAB-IND)                     ".
   02 FILLER PIC X(80) VALUE "                ADD HTM2COB-IND-1 TO HTM2COB-IND-2 END-ADD                      ".
   02 FILLER PIC X(80) VALUE "             ELSE                                                               ".
   02 FILLER PIC X(80) VALUE "                IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                    ".
   02 FILLER PIC X(80) VALUE "                THEN                                                            ".
   02 FILLER PIC X(80) VALUE "                   PERFORM HTM2COB-DISP-CONTENT-TYPE                            ".
   02 FILLER PIC X(80) VALUE "                   DISPLAY ""Error: value is too long""                         ".
   02 FILLER PIC X(80) VALUE "                           ""<BR>""                                             ".
   02 FILLER PIC X(80) VALUE "                   END-DISPLAY                                                  ".
   02 FILLER PIC X(80) VALUE "                END-IF                                                          ".
   02 FILLER PIC X(80) VALUE "                SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE           ".
   02 FILLER PIC X(80) VALUE "                EXIT SECTION                                                    ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          EXIT PERFORM                                                          ".
   02 FILLER PIC X(80) VALUE "       ELSE                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-FIRST-LINE-NO OF HTM2COB-FIRST-LINE-FLAG                 ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             *> this was only a CRLF, we have to write it in the internal table ".
   02 FILLER PIC X(80) VALUE "             IF HTM2COB-IND-2 < HTM2COB-DATA-VALUE-MAX-LEN                      ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                MOVE HTM2COB-INPUT-BUF-SAVE(1:HTM2COB-INPUT-BUF-SAVE-IND)       ".
   02 FILLER PIC X(80) VALUE "                  TO HTM2COB-DATA-VALUE(HTM2COB-IND-2:)                         ".
   02 FILLER PIC X(80) VALUE "                ADD HTM2COB-INPUT-BUF-SAVE-IND TO HTM2COB-IND-1 END-ADD         ".
   02 FILLER PIC X(80) VALUE "                MOVE HTM2COB-IND-1                                              ".
   02 FILLER PIC X(80) VALUE "                  TO HTM2COB-TAB-VALUE-LEN(HTM2COB-TAB-IND)                     ".
   02 FILLER PIC X(80) VALUE "                ADD HTM2COB-IND-1 TO HTM2COB-IND-2 END-ADD                      ".
   02 FILLER PIC X(80) VALUE "             ELSE                                                               ".
   02 FILLER PIC X(80) VALUE "                IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                    ".
   02 FILLER PIC X(80) VALUE "                THEN                                                            ".
   02 FILLER PIC X(80) VALUE "                   PERFORM HTM2COB-DISP-CONTENT-TYPE                            ".
   02 FILLER PIC X(80) VALUE "                   DISPLAY ""Error: value is too long""                         ".
   02 FILLER PIC X(80) VALUE "                           ""<BR>""                                             ".
   02 FILLER PIC X(80) VALUE "                   END-DISPLAY                                                  ".
   02 FILLER PIC X(80) VALUE "                END-IF                                                          ".
   02 FILLER PIC X(80) VALUE "                SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE           ".
   02 FILLER PIC X(80) VALUE "                EXIT SECTION                                                    ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> save line                                                          ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-FIRST-LINE-NO OF HTM2COB-FIRST-LINE-FLAG TO TRUE        ".
   02 FILLER PIC X(80) VALUE "          MOVE HTM2COB-INPUT-BUF     TO HTM2COB-INPUT-BUF-SAVE                  ".
   02 FILLER PIC X(80) VALUE "          MOVE HTM2COB-INPUT-BUF-IND TO HTM2COB-INPUT-BUF-SAVE-IND              ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-PARSE-FILE-UPLOAD SECTION.                                             ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> this must be a Content-Type                                              ".
   02 FILLER PIC X(80) VALUE "    PERFORM HTM2COB-READ-NEXT-LINE                                              ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-EOL-NO OF HTM2COB-EOL-FLAG                                     ".
   02 FILLER PIC X(80) VALUE "    OR HTM2COB-INPUT-BUF(1:14) NOT = ""Content-Type: ""                         ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: Content-Type not found""                             ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> save Content-Type as file type                                           ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-INSPECT-COUNT                                        ".
   02 FILLER PIC X(80) VALUE "    INSPECT HTM2COB-INPUT-BUF(15:)                                              ".
   02 FILLER PIC X(80) VALUE "       TALLYING HTM2COB-INSPECT-COUNT                                           ".
   02 FILLER PIC X(80) VALUE "       FOR CHARACTERS BEFORE INITIAL HTM2COB-CRLF                               ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-INPUT-BUF(15:HTM2COB-INSPECT-COUNT)                            ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-TAB-FILE-TYPE(HTM2COB-TAB-IND)                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> if not empty file                                                        ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-TAB-FILE-NAME-LEN(HTM2COB-TAB-IND) NOT = ZEROES                  ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       *> check file type                                                       ".
   02 FILLER PIC X(80) VALUE "       MOVE HTM2COB-TAB-FILE-TYPE(HTM2COB-TAB-IND) TO HTM2COB-CHECK-FILE-TYPE   ".
   02 FILLER PIC X(80) VALUE "       IF  NOT V-HTM2COB-FILE-TYPE-ALLOWED OF HTM2COB-CHECK-FILE-TYPE           ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type not allowed""                           ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> this must be an empty line                                               ".
   02 FILLER PIC X(80) VALUE "    PERFORM HTM2COB-READ-NEXT-LINE                                              ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-EOL-NO OF HTM2COB-EOL-FLAG                                     ".
   02 FILLER PIC X(80) VALUE "    OR HTM2COB-INPUT-BUF(1:2) NOT = HTM2COB-CRLF                                ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: end of line not found""                              ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> if not empty file                                                        ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-TAB-FILE-NAME-LEN(HTM2COB-TAB-IND) NOT = ZEROES                  ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       *> create uploaded file                                                  ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-FILE-CREATE                                              ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> init offset                                                              ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-FILE-OFFSET                                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-HTM2COB-FIRST-LINE-YES OF HTM2COB-FIRST-LINE-FLAG TO TRUE             ".
   02 FILLER PIC X(80) VALUE "    MOVE SPACES TO HTM2COB-INPUT-BUF-SAVE                                       ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-INPUT-BUF-SAVE-IND                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    PERFORM TEST AFTER                                                          ".
   02 FILLER PIC X(80) VALUE "      UNTIL V-HTM2COB-BOUNDARY-YES     OF HTM2COB-BOUNDARY-FLAG                 ".
   02 FILLER PIC X(80) VALUE "      OR    V-HTM2COB-BOUNDARY-EOF-YES OF HTM2COB-BOUNDARY-EOF-FLAG             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       *> read a line                                                           ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-READ-NEXT-LINE                                           ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-EOF-YES OF HTM2COB-EOF-FLAG                                 ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: boundary line not found""                         ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT PERFORM                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-CHECK-BOUNDARY                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-BOUNDARY-YES     OF HTM2COB-BOUNDARY-FLAG                   ".
   02 FILLER PIC X(80) VALUE "       OR V-HTM2COB-BOUNDARY-EOF-YES OF HTM2COB-BOUNDARY-EOF-FLAG               ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          *> end of uploaded file reached                                       ".
   02 FILLER PIC X(80) VALUE "          *> write last line without CRLF                                       ".
   02 FILLER PIC X(80) VALUE "          IF HTM2COB-INPUT-BUF-SAVE-IND > 2                                     ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             MOVE HTM2COB-INPUT-BUF-SAVE(1:HTM2COB-INPUT-BUF-SAVE-IND - 2)      ".
   02 FILLER PIC X(80) VALUE "               TO HTM2COB-FILE-BUF                                              ".
   02 FILLER PIC X(80) VALUE "             COMPUTE HTM2COB-FILE-NBYTES = HTM2COB-INPUT-BUF-SAVE-IND - 2       ".
   02 FILLER PIC X(80) VALUE "             END-COMPUTE                                                        ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-FILE-WRITE                                         ".
   02 FILLER PIC X(80) VALUE "             IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                       ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                EXIT PERFORM                                                    ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          EXIT PERFORM                                                          ".
   02 FILLER PIC X(80) VALUE "       ELSE                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-FIRST-LINE-NO OF HTM2COB-FIRST-LINE-FLAG                 ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             *> this was only a CRLF, we have to write it in the file           ".
   02 FILLER PIC X(80) VALUE "             MOVE HTM2COB-INPUT-BUF-SAVE(1:HTM2COB-INPUT-BUF-SAVE-IND)          ".
   02 FILLER PIC X(80) VALUE "               TO HTM2COB-FILE-BUF                                              ".
   02 FILLER PIC X(80) VALUE "             MOVE HTM2COB-INPUT-BUF-SAVE-IND TO HTM2COB-FILE-NBYTES             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-FILE-WRITE                                         ".
   02 FILLER PIC X(80) VALUE "             IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                       ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                EXIT PERFORM                                                    ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "          ELSE                                                                  ".
   02 FILLER PIC X(80) VALUE "             *> if not empty file                                               ".
   02 FILLER PIC X(80) VALUE "             IF HTM2COB-TAB-FILE-NAME-LEN(HTM2COB-TAB-IND) NOT = ZEROES         ".
   02 FILLER PIC X(80) VALUE "             THEN                                                               ".
   02 FILLER PIC X(80) VALUE "                *> this is the first line, we can check here the file data      ".    
   02 FILLER PIC X(80) VALUE "                PERFORM HTM2COB-CHECK-FILE-DATA                                 ".
   02 FILLER PIC X(80) VALUE "                IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                    ".
   02 FILLER PIC X(80) VALUE "                THEN                                                            ".
   02 FILLER PIC X(80) VALUE "                   EXIT PERFORM                                                 ".
   02 FILLER PIC X(80) VALUE "                END-IF                                                          ".
   02 FILLER PIC X(80) VALUE "             END-IF                                                             ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "          *> save line                                                          ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-FIRST-LINE-NO OF HTM2COB-FIRST-LINE-FLAG TO TRUE        ".
   02 FILLER PIC X(80) VALUE "          MOVE HTM2COB-INPUT-BUF     TO HTM2COB-INPUT-BUF-SAVE                  ".
   02 FILLER PIC X(80) VALUE "          MOVE HTM2COB-INPUT-BUF-IND TO HTM2COB-INPUT-BUF-SAVE-IND              ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-PERFORM                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> if not empty file                                                        ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-TAB-FILE-NAME-LEN(HTM2COB-TAB-IND) NOT = ZEROES                  ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       PERFORM HTM2COB-FILE-CLOSE                                               ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-CHECK-FILENAME-EXT SECTION.                                            ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE ZEROES TO HTM2COB-INSPECT-COUNT-1                                      ".
   02 FILLER PIC X(80) VALUE "    INSPECT FUNCTION REVERSE(HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND))            ".
   02 FILLER PIC X(80) VALUE "       TALLYING HTM2COB-INSPECT-COUNT-1                                         ".
   02 FILLER PIC X(80) VALUE "       FOR CHARACTERS BEFORE INITIAL "".""                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    COMPUTE HTM2COB-INSPECT-COUNT-2                                             ".
   02 FILLER PIC X(80) VALUE "          = FUNCTION LENGTH(HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND))             ".
   02 FILLER PIC X(80) VALUE "          - HTM2COB-INSPECT-COUNT-1                                             ".
   02 FILLER PIC X(80) VALUE "    END-COMPUTE                                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-INSPECT-COUNT-2 >=                                               ".
   02 FILLER PIC X(80) VALUE "       FUNCTION LENGTH(HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND))                  ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: Invalid filename extension""                         ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND)(HTM2COB-INSPECT-COUNT-2:1)        ".
   02 FILLER PIC X(80) VALUE "       NOT = "".""                                                              ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: Invalid filename extension""                         ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> save filename extension in table                                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND)(HTM2COB-INSPECT-COUNT-2 + 1:4)  ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-TAB-FILE-NAME-EXT(HTM2COB-TAB-IND)                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION LOWER-CASE(HTM2COB-TAB-FILE-NAME-EXT(HTM2COB-TAB-IND))        ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-CHECK-FILE-NAME-EXT                                            ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> check uploaded filename extension                                        ".
   02 FILLER PIC X(80) VALUE "    EVALUATE TRUE                                                               ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-NAME-EXT-BMP OF HTM2COB-CHECK-FILE-NAME-EXT             ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-BMP-NO OF HTM2COB-IMG-BMP-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type BMP not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-NAME-EXT-GIF OF HTM2COB-CHECK-FILE-NAME-EXT             ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-GIF-NO OF HTM2COB-IMG-GIF-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type GIF not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-NAME-EXT-JPG OF HTM2COB-CHECK-FILE-NAME-EXT             ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-JPG-NO OF HTM2COB-IMG-JPG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type JPG not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-NAME-EXT-PNG OF HTM2COB-CHECK-FILE-NAME-EXT             ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-PNG-NO OF HTM2COB-IMG-PNG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type PNG not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-NAME-EXT-TIF OF HTM2COB-CHECK-FILE-NAME-EXT             ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-TIF-NO OF HTM2COB-IMG-TIF-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type TIF not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN OTHER                                                                  ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: File-Type not allowed""                              ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-EVALUATE                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-CHECK-FILE-DATA SECTION.                                               ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> check uploaded file data                                                 ".
   02 FILLER PIC X(80) VALUE "    EVALUATE TRUE                                                               ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-TYPE-BMP OF HTM2COB-CHECK-FILE-TYPE                     ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-BMP-NO OF HTM2COB-IMG-BMP-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type BMP not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-INPUT-BUF(1:2) NOT = ""BM""                                   ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: Image content not BMP""                           ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-TYPE-GIF OF HTM2COB-CHECK-FILE-TYPE                     ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-GIF-NO OF HTM2COB-IMG-GIF-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type GIF not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-INPUT-BUF(1:3) NOT = ""GIF""                                  ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: Image content not GIF""                           ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-TYPE-JPG OF HTM2COB-CHECK-FILE-TYPE                     ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-JPG-NO OF HTM2COB-IMG-JPG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type JPG not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF  HTM2COB-INPUT-BUF(1:4) NOT = X""FFD8FFE0""                           ".
   02 FILLER PIC X(80) VALUE "       AND HTM2COB-INPUT-BUF(1:4) NOT = X""FFD8FFE1""                           ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: Image content not JPG""                           ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-TYPE-PNG OF HTM2COB-CHECK-FILE-TYPE                     ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-PNG-NO OF HTM2COB-IMG-PNG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type PNG not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF HTM2COB-INPUT-BUF(1:4) NOT = X""89504E47""                            ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: Image content not PNG""                           ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN V-HTM2COB-FILE-TYPE-TIF OF HTM2COB-CHECK-FILE-TYPE                     ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-IMG-TIF-NO OF HTM2COB-IMG-TIF-FLAG                          ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: File-Type TIF not allowed""                       ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "       IF  HTM2COB-INPUT-BUF(1:3) NOT = X""49492A""                             ".
   02 FILLER PIC X(80) VALUE "       AND HTM2COB-INPUT-BUF(1:3) NOT = X""4D4D2A""                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                          ".
   02 FILLER PIC X(80) VALUE "          THEN                                                                  ".
   02 FILLER PIC X(80) VALUE "             PERFORM HTM2COB-DISP-CONTENT-TYPE                                  ".
   02 FILLER PIC X(80) VALUE "             DISPLAY ""Error: Image content not TIF""                           ".
   02 FILLER PIC X(80) VALUE "                     ""<BR>""                                                   ".
   02 FILLER PIC X(80) VALUE "             END-DISPLAY                                                        ".
   02 FILLER PIC X(80) VALUE "          END-IF                                                                ".
   02 FILLER PIC X(80) VALUE "          SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                 ".
   02 FILLER PIC X(80) VALUE "          EXIT SECTION                                                          ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    WHEN OTHER                                                                  ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: File-Type not allowed""                              ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-EVALUATE                                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-FILE-CREATE SECTION.                                                   ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-FILE-NAME                                                ".
   02 FILLER PIC X(80) VALUE "    STRING FUNCTION TRIM(HTM2COB-UPLOAD-FILE-PATH) DELIMITED BY SIZE            ".
   02 FILLER PIC X(80) VALUE "           HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND)                               ".
   02 FILLER PIC X(80) VALUE "             (1:HTM2COB-TAB-FILE-NAME-LEN(HTM2COB-TAB-IND)) DELIMITED BY SIZE   ".
   02 FILLER PIC X(80) VALUE "      INTO HTM2COB-FILE-NAME                                                    ".
   02 FILLER PIC X(80) VALUE "    END-STRING                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_CREATE_FILE""                                                    ".
   02 FILLER PIC X(80) VALUE "         USING HTM2COB-FILE-NAME                                                ".
   02 FILLER PIC X(80) VALUE "             , 2                                                                ".
   02 FILLER PIC X(80) VALUE "             , 0                                                                ".
   02 FILLER PIC X(80) VALUE "             , 0                                                                ".
   02 FILLER PIC X(80) VALUE "             , HTM2COB-FILE-HANDLE                                              ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF RETURN-CODE NOT = ZEROES                                                 ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: CBL_CREATE_FILE, ""                                  ".
   02 FILLER PIC X(80) VALUE "                  ""FILE: "" HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND)             ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-FILE-WRITE SECTION.                                                    ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_WRITE_FILE""                                                     ".
   02 FILLER PIC X(80) VALUE "         USING HTM2COB-FILE-HANDLE                                              ".
   02 FILLER PIC X(80) VALUE "       , HTM2COB-FILE-OFFSET                                                    ".
   02 FILLER PIC X(80) VALUE "       , HTM2COB-FILE-NBYTES                                                    ".
   02 FILLER PIC X(80) VALUE "       , 0                                                                      ".
   02 FILLER PIC X(80) VALUE "       , HTM2COB-FILE-BUF(1:HTM2COB-INPUT-BUF-IND)                              ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF RETURN-CODE NOT = ZEROES                                                 ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: CBL_WRITE_FILE, ""                                   ".
   02 FILLER PIC X(80) VALUE "                  ""FILE: "" HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND)             ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    ADD HTM2COB-FILE-NBYTES TO HTM2COB-FILE-OFFSET END-ADD                      ".
   02 FILLER PIC X(80) VALUE "    *> update uploaded file size                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-FILE-OFFSET TO HTM2COB-TAB-FILE-DATA-LEN(HTM2COB-TAB-IND)      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> check max. allowed file size                                             ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-UPLOAD-FILE-MAX-SIZE < HTM2COB-TAB-FILE-DATA-LEN(HTM2COB-TAB-IND)".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: "" HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND)            ".
   02 FILLER PIC X(80) VALUE "                  "" file size"" "" > "" HTM2COB-UPLOAD-FILE-MAX-SIZE           ".
   02 FILLER PIC X(80) VALUE "                  "" max. allowed size"" ""<BR>""                               ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-FILE-CLOSE SECTION.                                                    ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""CBL_CLOSE_FILE""                                                     ".
   02 FILLER PIC X(80) VALUE "         USING HTM2COB-FILE-HANDLE                                              ".
   02 FILLER PIC X(80) VALUE "    END-CALL                                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF RETURN-CODE NOT = ZEROES                                                 ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       IF V-HTM2COB-DEBUG-YES OF HTM2COB-DEBUG-FLAG                             ".
   02 FILLER PIC X(80) VALUE "       THEN                                                                     ".
   02 FILLER PIC X(80) VALUE "          PERFORM HTM2COB-DISP-CONTENT-TYPE                                     ".
   02 FILLER PIC X(80) VALUE "          DISPLAY ""Error: CBL_CLOSE_FILE, ""                                   ".
   02 FILLER PIC X(80) VALUE "                  ""FILE: "" HTM2COB-TAB-FILE-NAME(HTM2COB-TAB-IND)             ".
   02 FILLER PIC X(80) VALUE "                  ""<BR>""                                                      ".
   02 FILLER PIC X(80) VALUE "          END-DISPLAY                                                           ".
   02 FILLER PIC X(80) VALUE "       END-IF                                                                   ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-ERROR-YES OF HTM2COB-ERROR-FLAG TO TRUE                    ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-DISP-CONTENT-TYPE SECTION.                                             ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF V-HTM2COB-DISP-CONT-TYPE-NO OF HTM2COB-DISP-CONT-TYPE-FLAG               ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       DISPLAY ""Content-Type: text/html; charset=utf-8""                       ".
   02 FILLER PIC X(80) VALUE "               WITH NO ADVANCING HTM2COB-LF                                     ".
   02 FILLER PIC X(80) VALUE "       END-DISPLAY                                                              ".
   02 FILLER PIC X(80) VALUE "       SET V-HTM2COB-DISP-CONT-TYPE-YES OF HTM2COB-DISP-CONT-TYPE-FLAG TO TRUE  ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-GET-SESS-ENV-PARAMS SECTION.                                           ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> get remote address of the visitor                                        ".
   02 FILLER PIC X(80) VALUE "    MOVE ""REMOTE_ADDR"" TO LNK-ENV-NAME OF LNK-HTM2COB-ENV                     ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-ENV"" USING LNK-HTM2COB-ENV END-CALL                         ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION TRIM(LNK-ENV-VALUE OF LNK-HTM2COB-ENV)                        ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-REMOTE-ADDR                                                    ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    *> get http user agent of the visitor                                       ".
   02 FILLER PIC X(80) VALUE "    MOVE ""HTTP_USER_AGENT"" TO LNK-ENV-NAME OF LNK-HTM2COB-ENV                 ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-ENV"" USING LNK-HTM2COB-ENV END-CALL                         ".
   02 FILLER PIC X(80) VALUE "    MOVE FUNCTION TRIM(LNK-ENV-VALUE OF LNK-HTM2COB-ENV)                        ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-HTTP-USER-AGENT                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-CREATE-SESSION-ID SECTION.                                             ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION-ID                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-YES OF LNK-REMOTE-ADDR-FLAG OF LNK-HTM2COB-SESSION-ID TO TRUE         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-REMOTE-ADDR                                                    ".
   02 FILLER PIC X(80) VALUE "      TO LNK-REMOTE-ADDR OF LNK-HTM2COB-SESSION-ID                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-YES OF LNK-HTTP-USER-AGENT-FLAG OF LNK-HTM2COB-SESSION-ID TO TRUE     ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-HTTP-USER-AGENT                                                ".
   02 FILLER PIC X(80) VALUE "      TO LNK-HTTP-USER-AGENT OF LNK-HTM2COB-SESSION-ID                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SESSION-ID"" USING LNK-HTM2COB-SESSION-ID END-CALL           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-ID-HEX      OF LNK-HTM2COB-SESSION-ID                      ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-HIDDEN-SESSION-ID                                              ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-USER-AGENT-HASH-HEX OF LNK-HTM2COB-SESSION-ID                      ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-USER-AGENT-HASH                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-CREATE-USER-AGENT-HASH SECTION.                                        ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION-ID                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-YES OF LNK-HTTP-USER-AGENT-FLAG OF LNK-HTM2COB-SESSION-ID TO TRUE     ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-HTTP-USER-AGENT                                                ".
   02 FILLER PIC X(80) VALUE "      TO LNK-HTTP-USER-AGENT OF LNK-HTM2COB-SESSION-ID                          ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SESSION-ID"" USING LNK-HTM2COB-SESSION-ID END-CALL           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-USER-AGENT-HASH-HEX OF LNK-HTM2COB-SESSION-ID                      ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-USER-AGENT-HASH                                                ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-CHECK-SESSION-ID SECTION.                                              ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-YES OF HTM2COB-SESS-ID-VALID-FLAG TO TRUE                             ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF FUNCTION STORED-CHAR-LENGTH(HTM2COB-HIDDEN-SESSION-ID) NOT = 128         ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-NO OF HTM2COB-SESS-ID-VALID-FLAG TO TRUE                           ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    IF HTM2COB-HIDDEN-SESSION-ID IS NOT HEXADECIMAL                             ".
   02 FILLER PIC X(80) VALUE "    THEN                                                                        ".
   02 FILLER PIC X(80) VALUE "       SET V-NO OF HTM2COB-SESS-ID-VALID-FLAG TO TRUE                           ".
   02 FILLER PIC X(80) VALUE "       EXIT SECTION                                                             ".
   02 FILLER PIC X(80) VALUE "    END-IF                                                                      ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SESS-START SECTION.                                                    ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-START-SESSION OF LNK-FUNCTION OF LNK-HTM2COB-SESSION TO TRUE          ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-HIDDEN-SESSION-ID                                              ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-ID-HEX      OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-USER-AGENT-HASH                                                ".
   02 FILLER PIC X(80) VALUE "      TO LNK-USER-AGENT-HASH-HEX OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-REMOTE-ADDR                                                    ".
   02 FILLER PIC X(80) VALUE "      TO LNK-REMOTE-ADDR         OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SESSION"" USING LNK-HTM2COB-SESSION END-CALL                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SESS-DEL-OLD SECTION.                                                  ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION                                              ". 
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-DEL-OLD-SESSION OF LNK-FUNCTION OF LNK-HTM2COB-SESSION TO TRUE        ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-FIRST-REQ-DIFF-SEC                                             ".
   02 FILLER PIC X(80) VALUE "      TO LNK-FIRST-REQ-DIFF-SEC OF LNK-HTM2COB-SESSION                          ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-LAST-REQ-DIFF-SEC                                              ".
   02 FILLER PIC X(80) VALUE "      TO LNK-LAST-REQ-DIFF-SEC OF LNK-HTM2COB-SESSION                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SESSION"" USING LNK-HTM2COB-SESSION END-CALL                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SESS-DESTROY SECTION.                                                  ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-DESTROY-SESSION OF LNK-FUNCTION OF LNK-HTM2COB-SESSION TO TRUE        ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-HIDDEN-SESSION-ID                                              ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-ID-HEX      OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-USER-AGENT-HASH                                                ".
   02 FILLER PIC X(80) VALUE "      TO LNK-USER-AGENT-HASH-HEX OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-REMOTE-ADDR                                                    ".
   02 FILLER PIC X(80) VALUE "      TO LNK-REMOTE-ADDR         OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SESSION"" USING LNK-HTM2COB-SESSION END-CALL                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SESS-REGENERATE SECTION.                                               ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-REGENERATE-SESSION OF LNK-FUNCTION OF LNK-HTM2COB-SESSION TO TRUE     ".
   02 FILLER PIC X(80) VALUE "*>  set actual session-id as old session-id                                     ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-HIDDEN-SESSION-ID                                              ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-ID-HEX-OLD  OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  create new session-id and user-agent-hash                                   ".
   02 FILLER PIC X(80) VALUE "    PERFORM HTM2COB-CREATE-SESSION-ID                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-HIDDEN-SESSION-ID                                              ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-ID-HEX      OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-USER-AGENT-HASH                                                ".
   02 FILLER PIC X(80) VALUE "      TO LNK-USER-AGENT-HASH-HEX OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-REMOTE-ADDR                                                    ".
   02 FILLER PIC X(80) VALUE "      TO LNK-REMOTE-ADDR         OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SESSION"" USING LNK-HTM2COB-SESSION END-CALL                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SESS-SET SECTION.                                                      ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-SET-SESSION-VAR OF LNK-FUNCTION OF LNK-HTM2COB-SESSION TO TRUE        ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-HIDDEN-SESSION-ID                                              ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-ID-HEX      OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-USER-AGENT-HASH                                                ".
   02 FILLER PIC X(80) VALUE "      TO LNK-USER-AGENT-HASH-HEX OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-REMOTE-ADDR                                                    ".
   02 FILLER PIC X(80) VALUE "      TO LNK-REMOTE-ADDR         OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-SESS-VAR-NAME                                                  ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-VAR-NAME    OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-SESS-VAR-VALUE                                                 ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-VAR-INP-VALUE OF LNK-HTM2COB-SESSION                       ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SESSION"" USING LNK-HTM2COB-SESSION END-CALL                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SESS-GET SECTION.                                                      ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-GET-SESSION-VAR OF LNK-FUNCTION OF LNK-HTM2COB-SESSION TO TRUE        ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-HIDDEN-SESSION-ID                                              ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-ID-HEX      OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-USER-AGENT-HASH                                                ".
   02 FILLER PIC X(80) VALUE "      TO LNK-USER-AGENT-HASH-HEX OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-REMOTE-ADDR                                                    ".
   02 FILLER PIC X(80) VALUE "      TO LNK-REMOTE-ADDR         OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-SESS-VAR-NAME                                                  ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-VAR-NAME    OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SESSION"" USING LNK-HTM2COB-SESSION END-CALL                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    MOVE LNK-SESSION-VAR-OUT-VALUE OF LNK-HTM2COB-SESSION                       ".
   02 FILLER PIC X(80) VALUE "      TO HTM2COB-SESS-VAR-VALUE                                                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-SESS-DEL SECTION.                                                      ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    SET V-DEL-SESSION-VAR OF LNK-FUNCTION OF LNK-HTM2COB-SESSION TO TRUE        ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-HIDDEN-SESSION-ID                                              ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-ID-HEX      OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-USER-AGENT-HASH                                                ".
   02 FILLER PIC X(80) VALUE "      TO LNK-USER-AGENT-HASH-HEX OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-REMOTE-ADDR                                                    ".
   02 FILLER PIC X(80) VALUE "      TO LNK-REMOTE-ADDR         OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "    MOVE HTM2COB-SESS-VAR-NAME                                                  ".
   02 FILLER PIC X(80) VALUE "      TO LNK-SESSION-VAR-NAME    OF LNK-HTM2COB-SESSION                         ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    CALL ""HTM2COB-SESSION"" USING LNK-HTM2COB-SESSION END-CALL                 ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-ACCEPT-HTTP-COOKIE SECTION.                                            ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-HTTP-COOKIE                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    ACCEPT HTM2COB-HTTP-COOKIE FROM ENVIRONMENT                                 ".
   02 FILLER PIC X(80) VALUE "           ""HTTP_COOKIE""                                                      ".
   02 FILLER PIC X(80) VALUE "    END-ACCEPT                                                                  ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE " HTM2COB-INIT-MEMORY SECTION.                                                   ".
   02 FILLER PIC X(80) VALUE "*>------------------------------------------------------------------------------".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "*>  Init memory                                                                 ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-ERROR-FLAG                                               ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-MULTIPART-FLAG                                           ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-POST-FIELD-VALUE-FLAG                                    ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-EOF-FLAG                                                 ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-DISP-CONT-TYPE-FLAG                                      ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-ENV-VALUE                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-QUERY-STR                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-QUERY-STR-LEN                                            ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-QUERY-STR-IND                                            ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-CONTENT-LEN                                              ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-CHAR-COUNT                                               ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-GETCHAR                                                  ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-CHAR                                                     ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-UTF8-STR                                                 ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-TAB-IND                                                  ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-TAB-NR                                                   ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-TABLE                                                    ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-DATA-VALUE                                               ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-EOL-FLAG                                                 ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-BOUNDARY-FLAG                                            ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-BOUNDARY-EOF-FLAG                                        ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-CONTENT-DISP-FLAG                                        ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-FIRST-LINE-FLAG                                          ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-BOUNDARY                                                 ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-BOUNDARY-LEN                                             ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-BOUNDARY-EOF                                             ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-INPUT-BUF                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-INPUT-BUF-IND                                            ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-INPUT-BUF-SAVE                                           ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-INPUT-BUF-SAVE-IND                                       ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-CHECK-FILE-TYPE                                          ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-CHECK-FILE-NAME-EXT                                      ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-TMP-FILE-NAME                                            ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-FILE-BUF                                                 ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-FILE-NAME                                                ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-REMOTE-ADDR                                              ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-HTTP-USER-AGENT                                          ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-HIDDEN-SESSION-ID                                        ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-USER-AGENT-HASH                                          ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-SESS-VAR-NAME                                            ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-SESS-VAR-VALUE                                           ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE HTM2COB-HTTP-COOKIE                                              ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-ENV                                                  ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-DECODE                                               ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION-ID                                           ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SESSION                                              ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-SET-COOKIE                                           ".
   02 FILLER PIC X(80) VALUE "    INITIALIZE LNK-HTM2COB-GET-COOKIE                                           ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   02 FILLER PIC X(80) VALUE "    EXIT SECTION .                                                              ".
   02 FILLER PIC X(80) VALUE "                                                                                ".
   
 01 WS-HTM2COB-SECTIONS-R REDEFINES WS-HTM2COB-SECTIONS.
   02 WS-HTM2COB-SECTIONS-LINES OCCURS C-HTM2COB-SECTIONS-MAX-LINE TIMES.
     03 WS-HTM2COB-SECTIONS-LINE           PIC X(80).
