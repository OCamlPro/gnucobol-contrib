*>******************************************************************************
*>  cgiupload is free software: you can redistribute it and/or modify it
*>  under the terms of the GNU General Public License as published by the Free
*>  Software Foundation, either version 3 of the License, or (at your option)
*>  any later version.
*>
*>  cgiupload is distributed in the hope that it will be useful, but
*>  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
*>  or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU General Public License for more details.
*>
*>  You should have received a copy of the GNU General Public License along
*>  with cgiupload.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      cgiupload.cob
*>
*> Purpose:      CGI file upload example
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2014.10.05
*>
*> Tectonics:    cobc -x -free cgiupload.cob
*>
*>               Compile for Windows with this define "OS=WINDOWS"
*>               (GnuCOBOL with MS Visual Studio): 
*>
*>               cobc -x -free cgiupload.cob -D OS=WINDOWS
*>
*> Usage:        Compile this program and copy the runnable code to your web
*>               servers cgi-bin directory. Create a HTML file, and copy it in
*>               the htdocs directory. If you want to upload a file, you
*>               have to use enctype="multipart/form-data" in your HTML form. 
*>
*>               This program processes every field in a HTML form, not only
*>               input type="file". The processed data will be written in an
*>               internal table. The uploaded files will be created in your 
*>               cgi-bin directory. You can simply change this if you add a 
*>               a file path to the file at the function "CBL_CREATE_FILE".
*>               
*>               The file type and content will be checked. For this demo
*>               only images (BMP, GIF, JPG, PNG, TIFF) are allowed. See the 
*>               definition WS-CHECK-FILE-TYPE and the section CHECK-FILE-DATA.
*>               
*>               There are some limits. (You can change these if you want.)
*>               C-POST-MAX-LEN  = 1000000. (incl. files)
*>               C-TAB-MAX-LINE  = 50. (max. number of fields in the HTML form)
*>               C-TAB-MAX-VALUE = 10000. (max. length of a field value)
*>               C-UPLOAD-FILE-MAX-SIZE = 300000. (max. size of a file)
*>
*>******************************************************************************
*> Date       Change description 
*> ========== ==================================================================
*> 2014.10.05 First version.
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. cgiupload.

 ENVIRONMENT DIVISION.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
 78 C-LF                               VALUE X"0A".
 78 C-CRLF                             VALUE X"0D0A".

*> flags 
 01 WS-ERROR-FLAG                      PIC 9.
    88 V-ERROR-NO                      VALUE 0.
    88 V-ERROR-YES                     VALUE 1.
 01 WS-EOL-FLAG                        PIC 9.
    88 V-EOL-NO                        VALUE 0.
    88 V-EOL-YES                       VALUE 1.
 01 WS-EOF-FLAG                        PIC 9.
    88 V-EOF-NO                        VALUE 0.
    88 V-EOF-YES                       VALUE 1.
 01 WS-BOUNDARY-FLAG                   PIC 9.
    88 V-BOUNDARY-NO                   VALUE 0.
    88 V-BOUNDARY-YES                  VALUE 1.
 01 WS-BOUNDARY-EOF-FLAG               PIC 9.
    88 V-BOUNDARY-EOF-NO               VALUE 0.
    88 V-BOUNDARY-EOF-YES              VALUE 1.
 01 WS-CONTENT-DISP-FLAG               PIC 9.
    88 V-CONTENT-DISP-ERROR            VALUE 0.
    88 V-CONTENT-DISP-FIELD            VALUE 1.
    88 V-CONTENT-DISP-FILE             VALUE 2.
 01 WS-FIRST-LINE-FLAG                 PIC 9.
    88 V-FIRST-LINE-NO                 VALUE 0.
    88 V-FIRST-LINE-YES                VALUE 1.

 01 WS-ENV-REQUEST-METHOD              PIC X(256).
 01 WS-ENV-CONTENT-TYPE                PIC X(256).
 01 WS-ENV-CONTENT-LENGTH              PIC X(256).

*> boundary string in CONTENT_TYPE
*> example: "---------------------------5276231769132"
*> this boundary string splits the form fields and uploaded files
 01 WS-BOUNDARY                        PIC X(256).
 01 WS-BOUNDARY-LEN                    PIC S9(9) COMP.
*> boundary string plus "--", this is the last boundary string 
*> example: "---------------------------5276231769132--"
 01 WS-BOUNDARY-EOF                    PIC X(256).
 
 78 C-POST-MAX-LEN                     VALUE 1000000.
 01 WS-POST-LEN                        PIC S9(9) COMP.

*> for the C function getchar()
 01 WS-GETCHAR                         BINARY-INT.
 
*> !!!this is only for windows, GnuCOBOL with MS Visual Studio!!!
*> we have to switch stdin in binary mode
>>IF OS = "WINDOWS"
 01 WS-RET                             BINARY-INT.
*> file mode is binary (untranslated) x"8000"
 01 C-O-BINARY                         BINARY-INT VALUE 32768.
>>END-IF
 
*> counts all received chars 
 01 WS-GETCHAR-COUNT                   PIC S9(9) COMP.
 
*> character conversion 
 01 WS-CHAR                            PIC X(1).
 01 WS-CHAR-R REDEFINES WS-CHAR        PIC S9(2) COMP-5.
 
*> input buffer
 78 C-INPUT-BUF-MAX-LEN                VALUE 1024.
 01 WS-INPUT-BUF                       PIC X(C-INPUT-BUF-MAX-LEN).
 01 WS-INPUT-BUF-IND                   PIC S9(09) COMP.
 01 WS-INPUT-BUF-SAVE                  PIC X(C-INPUT-BUF-MAX-LEN).
 01 WS-INPUT-BUF-SAVE-IND              PIC S9(09) COMP.

*> counter for COBOL inspect 
 01 WS-INSPECT-COUNT                   PIC S9(09) COMP.

*> internal table for HTML form fields, field values, file attributes 
 01 WS-TAB-IND                         PIC 9(9) COMP.
*> actual number of lines in the table
 01 WS-TAB-COUNT                       PIC 9(9) COMP.
 78 C-TAB-MAX-LINE                     VALUE 50.
 78 C-TAB-MAX-VALUE                    VALUE 10000.
 01 WS-TAB.                           
   03 WS-TAB-LINE                      OCCURS 1 TO C-TAB-MAX-LINE TIMES.
     04 WS-TAB-FIELD                   PIC X(40).
     04 WS-TAB-FIELD-LEN               PIC 9(9) COMP.
     04 WS-TAB-VALUE                   PIC X(C-TAB-MAX-VALUE).
     04 WS-TAB-VALUE-LEN               PIC 9(9) COMP.
     04 WS-TAB-FILE-FLAG               PIC 9.
        88 V-TAB-FILE-NO               VALUE 0.
        88 V-TAB-FILE-YES              VALUE 1.
     04 WS-TAB-FILE-NAME               PIC X(256).
     04 WS-TAB-FILE-NAME-LEN           PIC 9(9) COMP.
     04 WS-TAB-FILE-TYPE               PIC X(40).
     04 WS-TAB-FILE-DATA-LEN           PIC 9(9) COMP.

*> max. uploaded file size                                             
 78 C-UPLOAD-FILE-MAX-SIZE             VALUE 300000.
     
*> check uploaded file type
 01 WS-CHECK-FILE-TYPE                 PIC X(40).
    88 V-FILE-TYPE-TXT                 VALUE "text/plain". 
*>  application    
    88 V-FILE-TYPE-EXE                 VALUE "application/octet-stream".
    88 V-FILE-TYPE-PDF                 VALUE "application/pdf".
    88 V-FILE-TYPE-ZIP                 VALUE "application/zip".
*>  image
    88 V-FILE-TYPE-BMP                 VALUE "image/bmp".
    88 V-FILE-TYPE-GIF                 VALUE "image/gif".
    88 V-FILE-TYPE-JPG                 VALUE "image/jpeg".
    88 V-FILE-TYPE-PNG                 VALUE "image/png".
    88 V-FILE-TYPE-TIF                 VALUE "image/tiff".
*>  only images allowed
    88 V-FILE-TYPE-ALLOWED             VALUE "image/bmp",  "image/gif"
                                             "image/jpeg", "image/png"
                                             "image/tiff".

*> temp file name                                             
 01 WS-TMP-FILE-NAME                   PIC X(C-INPUT-BUF-MAX-LEN).
 01 WS-TMP-FILE-NAME-LEN               PIC 9(9) COMP.
 01 WS-TMP-FILE-PATH-LEN               PIC 9(9) COMP.

*> indices for cycles
 01 WS-IND-1                           PIC S9(9) COMP.

*> create and write the uploaded file                                             
 01 WS-FILE-HANDLE                     PIC X(4) USAGE COMP-X.
 01 WS-FILE-OFFSET                     PIC X(8) USAGE COMP-X.
 01 WS-FILE-NBYTES                     PIC X(4) USAGE COMP-X.
 01 WS-FILE-BUF                        PIC X(C-INPUT-BUF-MAX-LEN).

 
 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 MAIN-CGIUPLOAD SECTION.
*>------------------------------------------------------------------------------

*>  always send out the Content-type before any other IO
    DISPLAY "Content-Type: text/html; charset=utf-8"
            C-LF
    END-DISPLAY

*>  init error flag    
    SET V-ERROR-NO OF WS-ERROR-FLAG TO TRUE
*>  init internal table for post data   
    INITIALIZE WS-TAB-IND
    INITIALIZE WS-TAB-COUNT
    INITIALIZE WS-TAB

*> !!!this is only for windows, GnuCOBOL with MS Visual Studio!!!
*> we have to switch stdin in binary mode
>>IF OS = "WINDOWS"
    PERFORM SET-BINARY-MODE
>>END-IF

    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM CHECK-ENV
    END-IF

*>  display env. var.    
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       DISPLAY "REQUEST_METHOD: " WS-ENV-REQUEST-METHOD "<BR>"
               "CONTENT_TYPE:   " WS-ENV-CONTENT-TYPE "<BR>"
               "CONTENT_LENGTH: " WS-POST-LEN "<BR>"
       END-DISPLAY        
    END-IF
    
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM GET-BOUNDARY
    END-IF

*>  display boundary data    
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       DISPLAY "BOUNDARY: " WS-BOUNDARY "<BR>" END-DISPLAY
       DISPLAY "BOUNDARY-LEN: " WS-BOUNDARY-LEN "<BR>" END-DISPLAY
       DISPLAY "BOUNDARY-EOF: " WS-BOUNDARY-EOF "<BR>" "<BR>"  END-DISPLAY
    END-IF
    
    IF V-ERROR-NO OF WS-ERROR-FLAG
    THEN
       PERFORM READ-CGI-POST
    END-IF

*>  success, if boundary EOF string found, without any error    
    IF  V-ERROR-NO OF WS-ERROR-FLAG
    AND V-BOUNDARY-EOF-YES OF WS-BOUNDARY-EOF-FLAG    
    THEN
       DISPLAY "<BR>" "<BR>" 
               "BOUNDARY-EOF found, CGI post processed successfully"
               "<BR>" "<BR>" 
       END-DISPLAY
    END-IF
    
*>  display received data from the internal table
    DISPLAY "<BR>" "<BR>" "*** Received data ***" "<BR>" END-DISPLAY

    PERFORM VARYING WS-TAB-IND FROM 1 BY 1
      UNTIL WS-TAB-IND > C-TAB-MAX-LINE
      OR    WS-TAB-IND > WS-TAB-COUNT
    
       DISPLAY "FIELD: "     WS-TAB-FIELD(WS-TAB-IND)     "<BR>"
               "FIELD-LEN: " WS-TAB-FIELD-LEN(WS-TAB-IND) "<BR>"
       END-DISPLAY               

       DISPLAY "VALUE: "     WS-TAB-VALUE(WS-TAB-IND)     "<BR>"
               "VALUE-LEN: " WS-TAB-VALUE-LEN(WS-TAB-IND) "<BR>"
       END-DISPLAY               

       IF V-TAB-FILE-NO OF WS-TAB-FILE-FLAG(WS-TAB-IND)
       THEN
          DISPLAY "FILE: NO"  "<BR>" END-DISPLAY  
       ELSE
          DISPLAY "FILE: YES" "<BR>" END-DISPLAY  
       END-IF       

       DISPLAY "FILE-NAME: "     WS-TAB-FILE-NAME(WS-TAB-IND)     "<BR>"
               "FILE-NAME-LEN: " WS-TAB-FILE-NAME-LEN(WS-TAB-IND) "<BR>"
               "FILE-TYPE:     " WS-TAB-FILE-TYPE(WS-TAB-IND)     "<BR>"
               "FILE-DATA-LEN: " WS-TAB-FILE-DATA-LEN(WS-TAB-IND) "<BR>"
       END-DISPLAY               
       
       DISPLAY "<BR>" END-DISPLAY  
    END-PERFORM    
    
    STOP RUN

    .
 MAIN-CGIUPLOAD-EX.
    EXIT.

*> !!!this is only for windows, GnuCOBOL with MS Visual Studio!!!
*> we have to switch stdin in binary mode
>>IF OS = "WINDOWS"
*>------------------------------------------------------------------------------
 SET-BINARY-MODE SECTION.
*>------------------------------------------------------------------------------

    CALL STATIC "_setmode" 
         USING BY VALUE 0
               BY VALUE C-O-BINARY
         RETURNING WS-RET 
    END-CALL

*>  if cannot set binary mode, then result = -1
    IF WS-RET = -1
    THEN
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       DISPLAY "Error: cannot set binary mode" 
               "<BR>"
       END-DISPLAY
    END-IF
    
    .
 SET-BINARY-MODE-EX.
    EXIT.
>>END-IF
    
*>------------------------------------------------------------------------------
 CHECK-ENV SECTION.
*>------------------------------------------------------------------------------

*>  check REQUEST_METHOD
    ACCEPT WS-ENV-REQUEST-METHOD FROM ENVIRONMENT
           "REQUEST_METHOD"
    END-ACCEPT

    IF WS-ENV-REQUEST-METHOD NOT = "POST"
    THEN
       DISPLAY "Error: wrong REQUEST_METHOD: " 
               WS-ENV-REQUEST-METHOD 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

*>  check CONTENT_TYPE
    ACCEPT WS-ENV-CONTENT-TYPE FROM ENVIRONMENT
           "CONTENT_TYPE"
    END-ACCEPT

    IF WS-ENV-CONTENT-TYPE(1:20) NOT = "multipart/form-data;"
    THEN
       DISPLAY "Error: wrong CONTENT_TYPE: " 
               WS-ENV-CONTENT-TYPE 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

*>  check CONTENT_LENGTH
    ACCEPT WS-ENV-CONTENT-LENGTH FROM ENVIRONMENT
           "CONTENT_LENGTH"
    END-ACCEPT

    MOVE FUNCTION NUMVAL(WS-ENV-CONTENT-LENGTH)
      TO WS-POST-LEN
      
    IF WS-POST-LEN > C-POST-MAX-LEN
    THEN
       DISPLAY "Error: content length " WS-POST-LEN
               " > " C-POST-MAX-LEN " max. length <BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF
    
    .
 CHECK-ENV-EX.
    EXIT.

*>------------------------------------------------------------------------------
 GET-BOUNDARY SECTION.
*>------------------------------------------------------------------------------

    IF WS-ENV-CONTENT-TYPE(1:30) = "multipart/form-data; boundary="
    THEN
       MOVE WS-ENV-CONTENT-TYPE(31:) TO WS-BOUNDARY
       MOVE FUNCTION STORED-CHAR-LENGTH(WS-BOUNDARY) TO WS-BOUNDARY-LEN
       
       MOVE SPACES TO WS-BOUNDARY-EOF
       STRING WS-BOUNDARY(1:WS-BOUNDARY-LEN)
              "--"
         INTO WS-BOUNDARY-EOF
       END-STRING  
    ELSE
       DISPLAY "Error: can not find boundary string: " 
               WS-ENV-CONTENT-TYPE 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

    .
 GET-BOUNDARY-EX.
    EXIT.

*>------------------------------------------------------------------------------
 READ-CGI-POST SECTION.
*>------------------------------------------------------------------------------

    MOVE ZEROES TO WS-GETCHAR-COUNT
    MOVE ZEROES TO WS-GETCHAR

*>  read a "boundary" line with EOL
    PERFORM READ-NEXT-LINE   
    IF V-EOL-YES OF WS-EOL-FLAG
    THEN
       PERFORM CHECK-BOUNDARY

*>     this must be a "boundary" line         
       IF V-BOUNDARY-NO OF WS-BOUNDARY-FLAG
       THEN
          DISPLAY "Error: boundary line not found" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    ELSE   
       DISPLAY "Error: end of line not found" 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF
          
    PERFORM UNTIL WS-GETCHAR-COUNT > WS-POST-LEN
            OR    WS-GETCHAR < ZEROES
            OR    V-ERROR-YES OF WS-ERROR-FLAG
            OR    V-BOUNDARY-EOF-YES OF WS-BOUNDARY-EOF-FLAG

*>     read a "Content-Disposition" line with EOL
       PERFORM READ-NEXT-LINE   
       
*>     this must have an EOL
       IF V-EOL-YES OF WS-EOL-FLAG
       THEN
          PERFORM CHECK-CONTENT-DISPOSITION
          IF V-ERROR-YES OF WS-ERROR-FLAG
          THEN
             EXIT SECTION
          END-IF
       
*>        this must be a "Content-Disposition" line         
          EVALUATE TRUE
          WHEN V-CONTENT-DISP-FIELD OF WS-CONTENT-DISP-FLAG
*>           read and save field value                
             PERFORM PARSE-FIELD-VALUE
       
          WHEN V-CONTENT-DISP-FILE  OF WS-CONTENT-DISP-FLAG
*>           read and save the uploaded file                
             PERFORM PARSE-FILE-UPLOAD
       
          WHEN OTHER
             DISPLAY "Error: Content-Disposition not found" 
                     "<BR>"
             END-DISPLAY
             SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
             EXIT SECTION
          END-EVALUATE
       ELSE   
          DISPLAY "Error: end of line not found" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM   
      
    .
 READ-CGI-POST-EX.
    EXIT.

*>------------------------------------------------------------------------------
 READ-NEXT-LINE SECTION.
*>------------------------------------------------------------------------------

    MOVE ZEROES    TO WS-INPUT-BUF-IND
    MOVE LOW-VALUE TO WS-INPUT-BUF
    
    SET V-EOL-NO OF WS-EOL-FLAG TO TRUE
    SET V-EOF-NO OF WS-EOF-FLAG TO TRUE

    PERFORM UNTIL WS-GETCHAR-COUNT > WS-POST-LEN
            OR    WS-INPUT-BUF-IND > C-INPUT-BUF-MAX-LEN
            OR    WS-GETCHAR < ZEROES

       CALL STATIC "getchar" RETURNING WS-GETCHAR END-CALL

       IF WS-GETCHAR-COUNT > WS-POST-LEN
       OR WS-GETCHAR < ZEROES
       THEN
          SET V-EOF-YES OF WS-EOF-FLAG TO TRUE
          EXIT SECTION
       END-IF
       
       ADD 1 TO WS-GETCHAR-COUNT
       ADD 1 TO WS-INPUT-BUF-IND

       IF WS-INPUT-BUF-IND <= C-INPUT-BUF-MAX-LEN
       THEN
          MOVE WS-GETCHAR TO WS-CHAR-R 
          MOVE WS-CHAR    TO WS-INPUT-BUF(WS-INPUT-BUF-IND:1)

*>        !!!only for test!!! 
*>        received chars         
*>        DISPLAY WS-CHAR WITH NO ADVANCING END-DISPLAY
*>        received chars with num values        
*>        DISPLAY "(" WS-GETCHAR ")" END-DISPLAY
*>        IF WS-GETCHAR = 10
*>        THEN
*>           DISPLAY "<BR>" END-DISPLAY
*>        END-IF
          
*>        check end of line X"0A" or X"0D0A"         
          IF WS-GETCHAR = 10
          OR WS-INPUT-BUF-IND = C-INPUT-BUF-MAX-LEN
          THEN
             SET V-EOL-YES OF WS-EOL-FLAG TO TRUE
             EXIT SECTION 
          END-IF
       ELSE   
*>        input buffer full       
          EXIT SECTION
       END-IF
    END-PERFORM   
    
    .
 READ-NEXT-LINE-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 CHECK-BOUNDARY SECTION.
*>------------------------------------------------------------------------------

    SET V-BOUNDARY-NO OF WS-BOUNDARY-FLAG TO TRUE
    SET V-BOUNDARY-EOF-NO OF WS-BOUNDARY-EOF-FLAG TO TRUE
     
*>  search boundary string   
    MOVE ZEROES TO WS-INSPECT-COUNT
    INSPECT WS-INPUT-BUF(1:WS-INPUT-BUF-IND) 
       TALLYING WS-INSPECT-COUNT
       FOR ALL  WS-BOUNDARY(1:WS-BOUNDARY-LEN)    
    
    IF WS-INSPECT-COUNT > ZEROES
    THEN
       SET V-BOUNDARY-YES OF WS-BOUNDARY-FLAG TO TRUE
       
*>     search boundary EOF string   
       MOVE ZEROES TO WS-INSPECT-COUNT
       INSPECT WS-INPUT-BUF(1:WS-INPUT-BUF-IND) 
          TALLYING WS-INSPECT-COUNT
          FOR ALL  WS-BOUNDARY-EOF(1:WS-BOUNDARY-LEN + 2)    
          
       IF WS-INSPECT-COUNT > ZEROES
       THEN
          SET V-BOUNDARY-EOF-YES OF WS-BOUNDARY-EOF-FLAG TO TRUE
       END-IF        
    END-IF
    
    .
 CHECK-BOUNDARY-EX.
    EXIT.

*>------------------------------------------------------------------------------
 CHECK-CONTENT-DISPOSITION SECTION.
*>------------------------------------------------------------------------------

    SET V-CONTENT-DISP-ERROR OF WS-CONTENT-DISP-FLAG TO TRUE

    IF WS-INPUT-BUF(1:38) NOT = "Content-Disposition: form-data; name="""
    THEN
       EXIT SECTION
    END-IF

*>  for every Content-Disposition there is a line in the internal table    
    ADD 1 TO WS-TAB-IND  
    MOVE WS-TAB-IND TO WS-TAB-COUNT
    
    IF WS-TAB-IND > C-TAB-MAX-LINE
    THEN
       DISPLAY "Error: internal table full" 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF  
    
*>  get length of field name       
    MOVE ZEROES TO WS-INSPECT-COUNT    
    INSPECT WS-INPUT-BUF(39:) 
       TALLYING WS-INSPECT-COUNT
       FOR CHARACTERS BEFORE INITIAL """"

*>  save length of field name          
    MOVE WS-INSPECT-COUNT 
      TO WS-TAB-FIELD-LEN(WS-TAB-IND)
       
*>  save field name          
    MOVE WS-INPUT-BUF(39:WS-INSPECT-COUNT) 
      TO WS-TAB-FIELD(WS-TAB-IND)
    
*>  search number of fields
    MOVE ZEROES TO WS-INSPECT-COUNT    
    INSPECT WS-INPUT-BUF(39:) 
       TALLYING WS-INSPECT-COUNT
       FOR ALL """"
    
*>  this is only one field --> exit section      
    IF WS-INSPECT-COUNT = 1
    THEN
       SET V-CONTENT-DISP-FIELD OF WS-CONTENT-DISP-FLAG TO TRUE
       SET V-TAB-FILE-NO OF WS-TAB-FILE-FLAG(WS-TAB-IND) TO TRUE
       EXIT SECTION
    END-IF

*>  search file name       
    MOVE ZEROES TO WS-INSPECT-COUNT    
    INSPECT WS-INPUT-BUF(39 + WS-TAB-FIELD-LEN(WS-TAB-IND):) 
       TALLYING WS-INSPECT-COUNT
       FOR CHARACTERS BEFORE INITIAL "filename="""

    IF WS-INSPECT-COUNT = 3
    THEN
       SET V-CONTENT-DISP-FILE OF WS-CONTENT-DISP-FLAG TO TRUE
       SET V-TAB-FILE-YES OF WS-TAB-FILE-FLAG(WS-TAB-IND) TO TRUE
    
*>     get length of file name       
       MOVE ZEROES TO WS-INSPECT-COUNT    
       INSPECT WS-INPUT-BUF(39 + WS-TAB-FIELD-LEN(WS-TAB-IND) + 13:) 
          TALLYING WS-INSPECT-COUNT
          FOR CHARACTERS BEFORE INITIAL """"

*>     save length of file name in temp         
       MOVE WS-INSPECT-COUNT 
         TO WS-TMP-FILE-NAME-LEN
          
*>     save file name in temp         
       MOVE WS-INPUT-BUF(39 + WS-TAB-FIELD-LEN(WS-TAB-IND) + 13:WS-INSPECT-COUNT) 
         TO WS-TMP-FILE-NAME

*>     Check file name. Internet Explorer sends a file name with full
*>     file path, but Firefox sends only a file name.
       MOVE ZEROES TO WS-INSPECT-COUNT    
       INSPECT WS-TMP-FILE-NAME 
          TALLYING WS-INSPECT-COUNT
          FOR ALL "\" "/"
       
       IF WS-INSPECT-COUNT = ZEROES
       THEN
*>        this is only a file name without file path
*>        save length of file name          
          MOVE WS-TMP-FILE-NAME-LEN 
            TO WS-TAB-FILE-NAME-LEN(WS-TAB-IND)
*>        save file name          
          MOVE WS-TMP-FILE-NAME
            TO WS-TAB-FILE-NAME(WS-TAB-IND)
       ELSE
*>        this is a file name with full file path, get file name from it
          MOVE ZEROES TO WS-INSPECT-COUNT    
          
          INSPECT FUNCTION REVERSE(WS-TMP-FILE-NAME)
             TALLYING WS-INSPECT-COUNT
             FOR CHARACTERS BEFORE INITIAL "\"
                            BEFORE INITIAL "/"
       
          COMPUTE WS-TMP-FILE-PATH-LEN 
                = FUNCTION LENGTH(WS-TMP-FILE-NAME)
                - WS-INSPECT-COUNT + 1
          END-COMPUTE                             

*>        save length of file name          
          COMPUTE WS-TAB-FILE-NAME-LEN(WS-TAB-IND) 
                = WS-TMP-FILE-NAME-LEN
                - WS-TMP-FILE-PATH-LEN + 1
          END-COMPUTE                             
                
*>        save file name          
          MOVE WS-TMP-FILE-NAME(WS-TMP-FILE-PATH-LEN:WS-TAB-FILE-NAME-LEN(WS-TAB-IND))
            TO WS-TAB-FILE-NAME(WS-TAB-IND)
       END-IF       
    ELSE     
       DISPLAY "Error: filename not found in Content-Disposition" 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF    
    
    .
 CHECK-CONTENT-DISPOSITION-EX.
    EXIT.

*>------------------------------------------------------------------------------
 PARSE-FIELD-VALUE SECTION.
*>------------------------------------------------------------------------------

*>  this must be an empty line
    PERFORM READ-NEXT-LINE   
    IF V-EOL-NO OF WS-EOL-FLAG
    OR WS-INPUT-BUF(1:2) NOT = C-CRLF
    THEN
       DISPLAY "Error: end of line not found" 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

*>  init char counter   
    MOVE ZEROES TO WS-IND-1

    SET V-FIRST-LINE-YES OF WS-FIRST-LINE-FLAG TO TRUE
    MOVE SPACES TO WS-INPUT-BUF-SAVE
    MOVE ZEROES TO WS-INPUT-BUF-SAVE-IND
    
    PERFORM TEST AFTER
      UNTIL V-BOUNDARY-YES     OF WS-BOUNDARY-FLAG
      OR    V-BOUNDARY-EOF-YES OF WS-BOUNDARY-EOF-FLAG
      
*>     read a line
       PERFORM READ-NEXT-LINE   
       IF V-EOF-YES OF WS-EOF-FLAG
       THEN
          DISPLAY "Error: boundary line not found" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF

       PERFORM CHECK-BOUNDARY

       IF V-BOUNDARY-YES     OF WS-BOUNDARY-FLAG
       OR V-BOUNDARY-EOF-YES OF WS-BOUNDARY-EOF-FLAG
       THEN
*>        end of field reached
*>        write last line without CRLF
          IF WS-INPUT-BUF-SAVE-IND > 2
          THEN
             IF WS-IND-1 < C-TAB-MAX-VALUE
             THEN
                MOVE WS-INPUT-BUF-SAVE(1:WS-INPUT-BUF-SAVE-IND - 2) 
                  TO WS-TAB-VALUE(WS-TAB-IND)(WS-IND-1 + 1:)
                COMPUTE WS-IND-1 = WS-IND-1 
                                 + WS-INPUT-BUF-SAVE-IND - 2
                END-COMPUTE
                MOVE WS-IND-1
                  TO WS-TAB-VALUE-LEN(WS-TAB-IND)
             ELSE
                DISPLAY "Error: value is too long" 
                        "<BR>"
                END-DISPLAY
                SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
                EXIT SECTION
             END-IF          
          END-IF
          
          EXIT PERFORM        
       ELSE   
          IF V-FIRST-LINE-NO OF WS-FIRST-LINE-FLAG
          THEN
*>           this was only a CRLF, we have to write it in the internal table
             IF WS-IND-1 < C-TAB-MAX-VALUE
             THEN
                MOVE WS-INPUT-BUF-SAVE(1:WS-INPUT-BUF-SAVE-IND) 
                  TO WS-TAB-VALUE(WS-TAB-IND)(WS-IND-1 + 1:)
                ADD WS-INPUT-BUF-SAVE-IND TO WS-IND-1
                MOVE WS-IND-1
                  TO WS-TAB-VALUE-LEN(WS-TAB-IND)
             ELSE
                DISPLAY "Error: value is too long" 
                        "<BR>"
                END-DISPLAY
                SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
                EXIT SECTION
             END-IF          
          END-IF

*>        save line
          SET V-FIRST-LINE-NO OF WS-FIRST-LINE-FLAG TO TRUE
          MOVE WS-INPUT-BUF     TO WS-INPUT-BUF-SAVE
          MOVE WS-INPUT-BUF-IND TO WS-INPUT-BUF-SAVE-IND
       END-IF
    END-PERFORM
    
    .
 PARSE-FIELD-VALUE-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 PARSE-FILE-UPLOAD SECTION.
*>------------------------------------------------------------------------------

*>  this must be a Content-Type
    PERFORM READ-NEXT-LINE   
    IF V-EOL-NO OF WS-EOL-FLAG
    OR WS-INPUT-BUF(1:14) NOT = "Content-Type: "
    THEN
       DISPLAY "Error: Content-Type not found" 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

*>  save Content-Type as file type   
    MOVE ZEROES TO WS-INSPECT-COUNT    
    INSPECT WS-INPUT-BUF(15:) 
       TALLYING WS-INSPECT-COUNT
       FOR CHARACTERS BEFORE INITIAL C-CRLF
    MOVE WS-INPUT-BUF(15:WS-INSPECT-COUNT) TO WS-TAB-FILE-TYPE(WS-TAB-IND)

*>  if not empty file
    IF WS-TAB-FILE-NAME-LEN(WS-TAB-IND) NOT = ZEROES
    THEN
*>     check file type
       MOVE WS-TAB-FILE-TYPE(WS-TAB-IND) TO WS-CHECK-FILE-TYPE
       IF  NOT V-FILE-TYPE-ALLOWED OF WS-CHECK-FILE-TYPE
       THEN
          DISPLAY "Error: File-Type not allowed" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-IF
      
*>  this must be an empty line
    PERFORM READ-NEXT-LINE   
    IF V-EOL-NO OF WS-EOL-FLAG
    OR WS-INPUT-BUF(1:2) NOT = C-CRLF
    THEN
       DISPLAY "Error: end of line not found" 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

*>  if not empty file
    IF WS-TAB-FILE-NAME-LEN(WS-TAB-IND) NOT = ZEROES
    THEN
*>     create uploaded file
       PERFORM FILE-CREATE
       IF V-ERROR-YES OF WS-ERROR-FLAG
       THEN
          EXIT SECTION
       END-IF
    END-IF
    
*>  init offset    
    MOVE ZEROES TO WS-FILE-OFFSET

    SET V-FIRST-LINE-YES OF WS-FIRST-LINE-FLAG TO TRUE
    MOVE SPACES TO WS-INPUT-BUF-SAVE
    MOVE ZEROES TO WS-INPUT-BUF-SAVE-IND
    
    PERFORM TEST AFTER
      UNTIL V-BOUNDARY-YES     OF WS-BOUNDARY-FLAG
      OR    V-BOUNDARY-EOF-YES OF WS-BOUNDARY-EOF-FLAG
      
*>     read a line
       PERFORM READ-NEXT-LINE   
       IF V-EOF-YES OF WS-EOF-FLAG
       THEN
          DISPLAY "Error: boundary line not found" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
          EXIT PERFORM
       END-IF

       PERFORM CHECK-BOUNDARY

       IF V-BOUNDARY-YES     OF WS-BOUNDARY-FLAG
       OR V-BOUNDARY-EOF-YES OF WS-BOUNDARY-EOF-FLAG
       THEN
*>        end of uploaded file reached
*>        write last line without CRLF
          IF WS-INPUT-BUF-SAVE-IND > 2
          THEN
             MOVE WS-INPUT-BUF-SAVE(1:WS-INPUT-BUF-SAVE-IND - 2) 
               TO WS-FILE-BUF
             COMPUTE WS-FILE-NBYTES = WS-INPUT-BUF-SAVE-IND - 2
             END-COMPUTE
             
             PERFORM FILE-WRITE
             IF V-ERROR-YES OF WS-ERROR-FLAG
             THEN
                EXIT PERFORM
             END-IF
          END-IF
          
          EXIT PERFORM        
       ELSE   
          IF V-FIRST-LINE-NO OF WS-FIRST-LINE-FLAG
          THEN
*>           this was only a CRLF, we have to write it in the file
             MOVE WS-INPUT-BUF-SAVE(1:WS-INPUT-BUF-SAVE-IND) 
               TO WS-FILE-BUF
             MOVE WS-INPUT-BUF-SAVE-IND TO WS-FILE-NBYTES
          
             PERFORM FILE-WRITE
             IF V-ERROR-YES OF WS-ERROR-FLAG
             THEN
                EXIT PERFORM
             END-IF
          ELSE
*>           if not empty file
             IF WS-TAB-FILE-NAME-LEN(WS-TAB-IND) NOT = ZEROES
             THEN
*>              this is the first line, we can check here the file data          
                PERFORM CHECK-FILE-DATA             
                IF V-ERROR-YES OF WS-ERROR-FLAG
                THEN
                   EXIT PERFORM
                END-IF
             END-IF
          END-IF

*>        save line
          SET V-FIRST-LINE-NO OF WS-FIRST-LINE-FLAG TO TRUE
          MOVE WS-INPUT-BUF     TO WS-INPUT-BUF-SAVE
          MOVE WS-INPUT-BUF-IND TO WS-INPUT-BUF-SAVE-IND
       END-IF
    END-PERFORM
    
*>  if not empty file
    IF WS-TAB-FILE-NAME-LEN(WS-TAB-IND) NOT = ZEROES
    THEN
       PERFORM FILE-CLOSE
       IF V-ERROR-YES OF WS-ERROR-FLAG
       THEN
          EXIT SECTION
       END-IF
    END-IF
    
    .
 PARSE-FILE-UPLOAD-EX.
    EXIT.

*>------------------------------------------------------------------------------
 CHECK-FILE-DATA SECTION.
*>------------------------------------------------------------------------------

*>  check uploaded file data
    EVALUATE TRUE
    WHEN V-FILE-TYPE-BMP OF WS-CHECK-FILE-TYPE
       IF WS-INPUT-BUF(1:2) NOT = "BM"
       THEN
          DISPLAY "Error: Image content not BMP" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       END-IF       
      
    WHEN V-FILE-TYPE-GIF OF WS-CHECK-FILE-TYPE
       IF WS-INPUT-BUF(1:3) NOT = "GIF"
       THEN
          DISPLAY "Error: Image content not GIF" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       END-IF       

    WHEN V-FILE-TYPE-JPG OF WS-CHECK-FILE-TYPE
       IF  WS-INPUT-BUF(1:4) NOT = X"FFD8FFE0"
       AND WS-INPUT-BUF(1:4) NOT = X"FFD8FFE1"
       THEN
          DISPLAY "Error: Image content not JPG" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       END-IF       

    WHEN V-FILE-TYPE-PNG OF WS-CHECK-FILE-TYPE
       IF WS-INPUT-BUF(1:4) NOT = X"89504E47"
       THEN
          DISPLAY "Error: Image content not PNG" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       END-IF       

    WHEN V-FILE-TYPE-TIF OF WS-CHECK-FILE-TYPE
       IF  WS-INPUT-BUF(1:3) NOT = X"49492A"
       AND WS-INPUT-BUF(1:3) NOT = X"4D4D2A"
       THEN
          DISPLAY "Error: Image content not TIF" 
                  "<BR>"
          END-DISPLAY
          SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       END-IF       
    
    WHEN OTHER
       DISPLAY "Error: File-Type not allowed" 
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
    END-EVALUATE
    
    .
 CHECK-FILE-DATA-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 FILE-CREATE SECTION.
*>------------------------------------------------------------------------------

    CALL "CBL_CREATE_FILE" 
         USING WS-TAB-FILE-NAME(WS-TAB-IND)
             , 2
             , 0
             , 0
             , WS-FILE-HANDLE
    END-CALL    

    IF RETURN-CODE NOT = ZEROES
    THEN
       DISPLAY "Error: CBL_CREATE_FILE, "
               "FILE: " WS-TAB-FILE-NAME(WS-TAB-IND)       
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
    END-IF

    .
 FILE-CREATE-EX.
    EXIT.

*>------------------------------------------------------------------------------
 FILE-WRITE SECTION.
*>------------------------------------------------------------------------------

    CALL "CBL_WRITE_FILE" 
         USING WS-FILE-HANDLE
       , WS-FILE-OFFSET
       , WS-FILE-NBYTES
       , 0
       , WS-FILE-BUF(1:WS-INPUT-BUF-IND)
    END-CALL             
     
    IF RETURN-CODE NOT = ZEROES
    THEN
       DISPLAY "Error: CBL_WRITE_FILE, "
               "FILE: " WS-TAB-FILE-NAME(WS-TAB-IND)       
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
    END-IF

    ADD  WS-FILE-NBYTES TO WS-FILE-OFFSET
*>  update uploaded file size    
    MOVE WS-FILE-OFFSET TO WS-TAB-FILE-DATA-LEN(WS-TAB-IND)

*>  check max. allowed file size    
    IF C-UPLOAD-FILE-MAX-SIZE < WS-TAB-FILE-DATA-LEN(WS-TAB-IND)
    THEN
       DISPLAY "Error: " WS-TAB-FILE-NAME(WS-TAB-IND) " file size"
               " > " C-UPLOAD-FILE-MAX-SIZE " max. allowed size" "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

    .
 FILE-WRITE-EX.
    EXIT.

*>------------------------------------------------------------------------------
 FILE-CLOSE SECTION.
*>------------------------------------------------------------------------------

    CALL "CBL_CLOSE_FILE"
         USING WS-FILE-HANDLE
    END-CALL         

    IF RETURN-CODE NOT = ZEROES
    THEN
       DISPLAY "Error: CBL_CLOSE_FILE, "
               "FILE: " WS-TAB-FILE-NAME(WS-TAB-IND)       
               "<BR>"
       END-DISPLAY
       SET V-ERROR-YES OF WS-ERROR-FLAG TO TRUE
    END-IF
    
    .
 FILE-CLOSE-EX.
    EXIT.
    
 END PROGRAM cgiupload.
