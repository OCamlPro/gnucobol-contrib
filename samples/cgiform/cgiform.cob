*>******************************************************************************
*>  cgiform is free software: you can redistribute it and/or modify it
*>  under the terms of the GNU General Public License as published by the Free
*>  Software Foundation, either version 3 of the License, or (at your option)
*>  any later version.
*>
*>  cgiform is distributed in the hope that it will be useful, but
*>  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
*>  or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU General Public License for more details.
*>
*>  You should have received a copy of the GNU General Public License along
*>  with cgiform.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      cgiform.cob
*>
*> Purpose:      CGI form and file upload example
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.08.21
*>
*> Tectonics:    cobc -x -free cgiform.cob
*>
*>               Compile for Windows with this define "OS=WINDOWS"
*>               (GnuCOBOL with MS Visual Studio): 
*>
*>               cobc -x -free cgiform.cob -D OS=WINDOWS
*>
*> Usage:        Compile this program and copy the runnable code to your web
*>               servers cgi-bin directory. Create a HTML file, and copy it in
*>               the htdocs directory. If you want to upload a file, you
*>               have to use enctype="multipart/form-data" in your HTML form. 
*>
*>               This program processes every field in a HTML form, not only
*>               input type="file". The processed data will be written in an
*>               internal table: COB2CGI-TABLE. The field values will be saved  
*>               in COB2CGI-DATA-VALUE variable. After the parsing you can get 
*>               all values with the COB2CGI-POST function. 
*> 
*>               The uploaded files will be created in your cgi-bin directory.
*>               You can simply change this if you add a file path to the file
*>               at the function "CBL_CREATE_FILE".
*>               
*>               The file type and content will be checked. For this demo
*>               only images (BMP, GIF, JPG, PNG, TIFF) are allowed. See the 
*>               definition COB2CGI-CHECK-FILE-TYPE and the section 
*>               COB2CGI-CHECK-FILE-DATA.
*>
*>               It's very easy to extend or change this program. Please search
*>               for these lines:
*>               ********* begin user defined content *********
*>               ********* end user defined content   *********
*>               Between these lines you can define your variables in 
*>               WORKING-STORAGE section, or you can write your HTML reply in
*>               COB2CGI-MAIN section, or you can write your own section.
*>
*>******************************************************************************
*> Date       Change description 
*> ========== ==================================================================
*> 2015.08.21 First version.
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. cgiform.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION COB2CGI-POST
    FUNCTION COB2CGI-DECODE
    FUNCTION COB2CGI-ENV
    FUNCTION COB2CGI-NUM2HEX
    FUNCTION ALL INTRINSIC.

 DATA DIVISION.

 WORKING-STORAGE SECTION.
*> end of line char 
 78 COB2CGI-LF                         VALUE X"0A".
 78 COB2CGI-CRLF                       VALUE X"0D0A".
 
*> flags                                       
 01 COB2CGI-ERROR-FLAG                 PIC 9.
    88 V-COB2CGI-ERROR-NO              VALUE 0.
    88 V-COB2CGI-ERROR-YES             VALUE 1.
 01 COB2CGI-REQUEST-METHOD-FLAG        PIC 9.
    88 V-COB2CGI-REQUEST-METHOD-GET    VALUE 0.
    88 V-COB2CGI-REQUEST-METHOD-POST   VALUE 1.
 01 COB2CGI-MULTIPART-FLAG             PIC 9.
    88 V-COB2CGI-MULTIPART-NO          VALUE 0.
    88 V-COB2CGI-MULTIPART-YES         VALUE 1.
 01 COB2CGI-POST-FIELD-VALUE-FLAG      PIC 9.
    88 V-COB2CGI-POST-FIELD            VALUE 0.
    88 V-COB2CGI-POST-VALUE            VALUE 1.
 01 COB2CGI-EOF-FLAG                   PIC 9.
    88 V-COB2CGI-EOF-NO                VALUE 0.
    88 V-COB2CGI-EOF-YES               VALUE 1.

*> for environment variables
 01 COB2CGI-ENV-VALUE                  PIC X(256).

*> for GET data in query string
 78 COB2CGI-QUERY-STR-MAX-LEN          VALUE 65536.
 01 COB2CGI-QUERY-STR                  PIC X(COB2CGI-QUERY-STR-MAX-LEN)
                                             VALUE LOW-VALUE.
 01 COB2CGI-QUERY-STR-LEN              PIC 9(9) COMP.
 01 COB2CGI-QUERY-STR-IND              PIC 9(9) COMP.
 
*> for POST data together with UPLOAD file
 78 COB2CGI-CONTENT-MAX-LEN            VALUE 1000000.
 01 COB2CGI-CONTENT-LEN                PIC 9(9) COMP.
                                       
*> counts all received chars           
 01 COB2CGI-CHAR-COUNT                 PIC S9(9) COMP.
                                       
*> for the C function getchar()        
 01 COB2CGI-GETCHAR                    BINARY-INT.

*> !!!this is only for windows, GnuCOBOL with MS Visual Studio!!!
*> we have to switch stdin in binary mode
>>IF OS = "WINDOWS"
 01 COB2CGI-RET                        BINARY-INT.
*> file mode is binary (untranslated) x"8000"
 01 COB2CGI-MODE-BINARY                BINARY-INT VALUE 32768.
>>END-IF
 
*> character conversion                
 01 COB2CGI-CHAR                       PIC X(1).
 01 COB2CGI-CHAR-R REDEFINES COB2CGI-CHAR PIC S9(2) COMP-5.
 
 01 COB2CGI-UTF8-STR                   PIC X(3).
 
*> max field length in the table
 78 COB2CGI-TAB-FIELD-MAX-LEN          VALUE 40.                  
*> max number of lines in the table 
 78 COB2CGI-TAB-MAX-LINE               VALUE 1000.
 01 COB2CGI-TAB-IND                    PIC 9(9) COMP.
*> saved number of lines in the table 
 01 COB2CGI-TAB-NR                     EXTERNAL PIC 9(9) COMP.
*> length of one COB2CGI-TAB-LINE = 161, 
*> therefore the size of table = 161 * COB2CGI-TAB-MAX-LINE
 01 COB2CGI-TABLE-R                    EXTERNAL PIC X(161000).
 01 COB2CGI-TABLE REDEFINES COB2CGI-TABLE-R.
   02 COB2CGI-TAB.
     03 COB2CGI-TAB-LINE               OCCURS 1 TO COB2CGI-TAB-MAX-LINE TIMES.
       *> there are only the name of fields in the internal table,
       *> all values will be saved in the field COB2CGI-DATA-VALUE
       04 COB2CGI-TAB-FIELD            PIC X(40).
       04 COB2CGI-TAB-FIELD-LEN        PIC 9(9) COMP.
       04 COB2CGI-TAB-VALUE-PTR        PIC 9(9) COMP.
       04 COB2CGI-TAB-VALUE-LEN        PIC 9(9) COMP.
       04 COB2CGI-TAB-FILE-FLAG        PIC 9.
          88 V-COB2CGI-TAB-FILE-NO     VALUE 0.
          88 V-COB2CGI-TAB-FILE-YES    VALUE 1.
       04 COB2CGI-TAB-FILE-NAME        PIC X(60).
       04 COB2CGI-TAB-FILE-NAME-LEN    PIC 9(9) COMP.
       04 COB2CGI-TAB-FILE-TYPE        PIC X(40).
       04 COB2CGI-TAB-FILE-DATA-LEN    PIC 9(9) COMP.
       
*> max value length       
 78 COB2CGI-DATA-VALUE-MAX-LEN         VALUE 500000.
*> we can save memory, if we use one field for all values
 01 COB2CGI-DATA-VALUE        EXTERNAL PIC X(COB2CGI-DATA-VALUE-MAX-LEN).

*> indices for cycles
 01 COB2CGI-IND-1                      PIC 9(9) COMP.
 01 COB2CGI-IND-2                      PIC 9(9) COMP.

*> for POST UPLOAD processing --------------------------------------------------

*> flags 
 01 COB2CGI-EOL-FLAG                   PIC 9.
    88 V-COB2CGI-EOL-NO                VALUE 0.
    88 V-COB2CGI-EOL-YES               VALUE 1.
 01 COB2CGI-BOUNDARY-FLAG              PIC 9.
    88 V-COB2CGI-BOUNDARY-NO           VALUE 0.
    88 V-COB2CGI-BOUNDARY-YES          VALUE 1.
 01 COB2CGI-BOUNDARY-EOF-FLAG          PIC 9.
    88 V-COB2CGI-BOUNDARY-EOF-NO       VALUE 0.
    88 V-COB2CGI-BOUNDARY-EOF-YES      VALUE 1.
 01 COB2CGI-CONTENT-DISP-FLAG          PIC 9.
    88 V-COB2CGI-CONTENT-DISP-ERROR    VALUE 0.
    88 V-COB2CGI-CONTENT-DISP-FIELD    VALUE 1.
    88 V-COB2CGI-CONTENT-DISP-FILE     VALUE 2.
 01 COB2CGI-FIRST-LINE-FLAG            PIC 9.
    88 V-COB2CGI-FIRST-LINE-NO         VALUE 0.
    88 V-COB2CGI-FIRST-LINE-YES        VALUE 1.

*> boundary string in CONTENT_TYPE
*> example: "---------------------------5276231769132"
*> this boundary string splits the form fields and uploaded files
 01 COB2CGI-BOUNDARY                   PIC X(256).
 01 COB2CGI-BOUNDARY-LEN               PIC S9(9) COMP.
*> boundary string plus "--", this is the last boundary string 
*> example: "---------------------------5276231769132--"
 01 COB2CGI-BOUNDARY-EOF               PIC X(256).

*> input buffer
 78 COB2CGI-INPUT-BUF-MAX-LEN          VALUE 1024.
 01 COB2CGI-INPUT-BUF                  PIC X(COB2CGI-INPUT-BUF-MAX-LEN).
 01 COB2CGI-INPUT-BUF-IND              PIC S9(09) COMP.
 01 COB2CGI-INPUT-BUF-SAVE             PIC X(COB2CGI-INPUT-BUF-MAX-LEN).
 01 COB2CGI-INPUT-BUF-SAVE-IND         PIC S9(09) COMP.

*> counter for COBOL inspect 
 01 COB2CGI-INSPECT-COUNT              PIC S9(09) COMP.

*> max. uploaded file size                                             
 78 COB2CGI-UPLOAD-FILE-MAX-SIZE       VALUE 300000.
     
*> check uploaded file type
 01 COB2CGI-CHECK-FILE-TYPE            PIC X(40).
    88 V-COB2CGI-FILE-TYPE-TXT         VALUE "text/plain". 
    *> application                        
    88 V-COB2CGI-FILE-TYPE-EXE         VALUE "application/octet-stream".
    88 V-COB2CGI-FILE-TYPE-PDF         VALUE "application/pdf".
    88 V-COB2CGI-FILE-TYPE-ZIP         VALUE "application/zip".
    *> image                              
    88 V-COB2CGI-FILE-TYPE-BMP         VALUE "image/bmp".
    88 V-COB2CGI-FILE-TYPE-GIF         VALUE "image/gif".
    88 V-COB2CGI-FILE-TYPE-JPG         VALUE "image/jpeg".
    88 V-COB2CGI-FILE-TYPE-PNG         VALUE "image/png".
    88 V-COB2CGI-FILE-TYPE-TIF         VALUE "image/tiff".
    *> only images allowed                
    88 V-COB2CGI-FILE-TYPE-ALLOWED     VALUE "image/bmp",  "image/gif"
                                             "image/jpeg", "image/png"
                                             "image/tiff".

*> temp file name                                             
 01 COB2CGI-TMP-FILE-NAME              PIC X(COB2CGI-INPUT-BUF-MAX-LEN).
 01 COB2CGI-TMP-FILE-NAME-LEN          PIC 9(9) COMP.
 01 COB2CGI-TMP-FILE-PATH-LEN          PIC 9(9) COMP.

*> create and write the uploaded file                                             
 01 COB2CGI-FILE-HANDLE                PIC X(4) USAGE COMP-X.
 01 COB2CGI-FILE-OFFSET                PIC X(8) USAGE COMP-X.
 01 COB2CGI-FILE-NBYTES                PIC X(4) USAGE COMP-X.
 01 COB2CGI-FILE-BUF                   PIC X(COB2CGI-INPUT-BUF-MAX-LEN).
 
*> ********* begin user defined content *********
 
 01 FIRSTNAME                 PIC X(40) VALUE "firstname".
 01 LASTNAME                  PIC X(40) VALUE "lastname".

 01 FNAME.
   02 LEN                     PIC 9(9) COMP.
   02 VAL                     PIC X(100).
 01 LNAME.
   02 LEN                     PIC 9(9) COMP.
   02 VAL                     PIC X(100).

*> ********* end user defined content   *********

 PROCEDURE DIVISION.

*>------------------------------------------------------------------------------
 COB2CGI-MAIN SECTION.
*>------------------------------------------------------------------------------

    *> Always send out the Content-type before any other IO
    DISPLAY "Content-Type: text/html; charset=utf-8"
            COB2CGI-LF
    END-DISPLAY

*>  Test cookie
*>  DISPLAY 
*>     "Content-Type: text/html; charset=utf-8"
*>     "Set-Cookie: testcookie=first"
*>     "Set-Cookie: sessionToken=abc123; Expires=Wed, 19 Jun 2015 10:18:14 GMT"
*>     COB2CGI-LF
*>  END-DISPLAY
    
    PERFORM COB2CGI-PROCESS-DATA
    IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
    THEN
       GOBACK
    END-IF

*> ********* begin user defined content *********
    
    DISPLAY "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN""" END-DISPLAY
    DISPLAY "       ""http://www.w3.org/TR/html4/loose.dtd"">" END-DISPLAY
    DISPLAY "<html>" END-DISPLAY
    DISPLAY "<head>" END-DISPLAY
    DISPLAY "<title>Hello GnuCOBOL world!</title>" END-DISPLAY
    DISPLAY "<meta http-equiv=""content-type"" content=""text/html;charset=utf-8"" />" END-DISPLAY
    DISPLAY "<meta http-equiv=""Content-Style-Type"" content=""text/css"" />" END-DISPLAY
    DISPLAY "</head>" END-DISPLAY
    DISPLAY "<body>" END-DISPLAY

    MOVE COB2CGI-POST(FIRSTNAME) TO FNAME
    MOVE COB2CGI-POST(LASTNAME)  TO LNAME

    DISPLAY "<br><br>" END-DISPLAY
    DISPLAY "Hello GnuCOBOL world!" END-DISPLAY

    DISPLAY "<p>" END-DISPLAY
    DISPLAY "First name: " END-DISPLAY

    DISPLAY VAL OF FNAME(1:LEN OF FNAME) END-DISPLAY

    DISPLAY "<br>" END-DISPLAY
    DISPLAY "Last name : " END-DISPLAY

    DISPLAY VAL OF LNAME(1:LEN OF LNAME) END-DISPLAY

    DISPLAY "<br>" END-DISPLAY
    DISPLAY "</p>" END-DISPLAY
    DISPLAY "</body>" END-DISPLAY
    DISPLAY "</html>" END-DISPLAY
    
*> ********* end user defined content   *********

    GOBACK

    .
 COB2CGI-MAIN-EX.
    EXIT.

*> ********* begin user defined content *********

*> here you can write your own sections
    
*> ********* end user defined content   *********
    
*>------------------------------------------------------------------------------
 COB2CGI-PROCESS-DATA SECTION.
*>------------------------------------------------------------------------------

    SET V-COB2CGI-ERROR-NO OF COB2CGI-ERROR-FLAG TO TRUE

*> !!!this is only for windows, GnuCOBOL with MS Visual Studio!!!
*> we have to switch stdin in binary mode
>>IF OS = "WINDOWS"
    PERFORM COB2CGI-SET-BINARY-MODE
    IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
    THEN
       DISPLAY "<BR>Error in SET-BINARY-MODE <BR>" END-DISPLAY
       EXIT SECTION
    END-IF
>>END-IF

    *> check REQUEST_METHOD
    MOVE COB2CGI-ENV("REQUEST_METHOD")
      TO COB2CGI-ENV-VALUE

    IF  COB2CGI-ENV-VALUE NOT = "GET"
    AND COB2CGI-ENV-VALUE NOT = "POST"
    THEN
       DISPLAY "<BR>Error: wrong REQUEST_METHOD: " COB2CGI-ENV-VALUE " <BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

    IF COB2CGI-ENV-VALUE = "GET"
    THEN
       SET V-COB2CGI-REQUEST-METHOD-GET  OF COB2CGI-REQUEST-METHOD-FLAG TO TRUE
       PERFORM COB2CGI-PROCESS-GET
       IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
       THEN
          DISPLAY "<BR>Error in PROCESS-GET <BR>" END-DISPLAY
          EXIT SECTION
       END-IF
    ELSE
       SET V-COB2CGI-REQUEST-METHOD-POST OF COB2CGI-REQUEST-METHOD-FLAG TO TRUE
       PERFORM COB2CGI-PROCESS-POST
       IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
       THEN
          DISPLAY "<BR>Error in PROCESS-POST <BR>" END-DISPLAY
          EXIT SECTION
       END-IF
    END-IF

    .
 COB2CGI-PROCESS-DATA-EX.
    EXIT.

*> !!!this is only for windows, GnuCOBOL with MS Visual Studio!!!
*> we have to switch stdin in binary mode
>>IF OS = "WINDOWS"
*>------------------------------------------------------------------------------
 COB2CGI-SET-BINARY-MODE SECTION.
*>------------------------------------------------------------------------------

    CALL STATIC "_setmode" 
         USING BY VALUE 0
               BY VALUE COB2CGI-MODE-BINARY
         RETURNING COB2CGI-RET 
    END-CALL

    *> if cannot set binary mode, then result = -1
    IF COB2CGI-RET = -1
    THEN
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       DISPLAY "Error: cannot set binary mode" 
               "<BR>"
       END-DISPLAY
    END-IF
    
    .
 COB2CGI-SET-BINARY-MODE-EX.
    EXIT.
>>END-IF
    
*>------------------------------------------------------------------------------
 COB2CGI-PROCESS-GET SECTION.
*>------------------------------------------------------------------------------
    
    *> QUERY_STRING is the URL-encoded information 
    *> that is sent with GET method request.
    MOVE COB2CGI-ENV("QUERY_STRING")
      TO COB2CGI-QUERY-STR
    MOVE FUNCTION STORED-CHAR-LENGTH(COB2CGI-ENV("QUERY_STRING"))
      TO COB2CGI-QUERY-STR-LEN

    *> no data
    IF COB2CGI-QUERY-STR-LEN = ZEROES
    THEN
       EXIT SECTION
    END-IF

    *> check QUERY_STRING data length
    IF COB2CGI-QUERY-STR-LEN > COB2CGI-QUERY-STR-MAX-LEN
    THEN
       DISPLAY "<BR>Error: QUERY_STRING length " COB2CGI-QUERY-STR-LEN
               " greater than " COB2CGI-QUERY-STR-MAX-LEN " max. length <BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF
    
    *> parse GET data
    PERFORM COB2CGI-PARSE-GET-POST
    IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
    THEN
       DISPLAY "<BR>Error in PARSE-GET-POST <BR>" END-DISPLAY
       EXIT SECTION
    END-IF

    .
 COB2CGI-PROCESS-GET-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 COB2CGI-PROCESS-POST SECTION.
*>------------------------------------------------------------------------------

    *> check CONTENT_LENGTH
    MOVE COB2CGI-ENV("CONTENT_LENGTH")
      TO COB2CGI-ENV-VALUE

    MOVE NUMVAL(COB2CGI-ENV-VALUE)
      TO COB2CGI-CONTENT-LEN

    IF COB2CGI-CONTENT-LEN > COB2CGI-CONTENT-MAX-LEN
    THEN
       DISPLAY "<BR>Error: CONTENT_LENGTH " COB2CGI-CONTENT-LEN
               " greater than " COB2CGI-CONTENT-MAX-LEN " max. length <BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

    *> no data
    IF COB2CGI-CONTENT-LEN = ZEROES
    THEN
       EXIT SECTION
    END-IF
    
    *> check CONTENT_TYPE
    MOVE COB2CGI-ENV("CONTENT_TYPE")
      TO COB2CGI-ENV-VALUE

    EVALUATE TRUE  
       *> this is only a POST
       WHEN COB2CGI-ENV-VALUE(1:33) = "application/x-www-form-urlencoded"
          SET V-COB2CGI-MULTIPART-NO OF COB2CGI-MULTIPART-FLAG TO TRUE
   
          *> parse POST data
          PERFORM COB2CGI-PARSE-GET-POST
          IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
          THEN
             DISPLAY "<BR>Error in PARSE-GET-POST <BR>" END-DISPLAY
             EXIT SECTION
          END-IF
    
       *> this is a POST with file UPLOAD
       WHEN COB2CGI-ENV-VALUE(1:29) = "multipart/form-data; boundary"
          SET V-COB2CGI-MULTIPART-YES OF COB2CGI-MULTIPART-FLAG TO TRUE
          *> parse multipart POST data, save UPLOAD
          PERFORM COB2CGI-PARSE-UPLOAD
          IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
          THEN
             DISPLAY "<BR>Error in PARSE-UPLOAD <BR>" END-DISPLAY
             EXIT SECTION
          END-IF
       
       WHEN OTHER
          DISPLAY "<BR>Error: wrong CONTENT_TYPE: " COB2CGI-ENV-VALUE "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
          EXIT SECTION
    END-EVALUATE   

    .
 COB2CGI-PROCESS-POST-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COB2CGI-PARSE-GET-POST SECTION.
*>------------------------------------------------------------------------------

    MOVE ZEROES TO COB2CGI-QUERY-STR-IND
    MOVE ZEROES TO COB2CGI-CHAR-COUNT
    MOVE ZEROES TO COB2CGI-GETCHAR
    SET V-COB2CGI-EOF-NO OF COB2CGI-EOF-FLAG TO TRUE
    
    *> field name comes first
    SET V-COB2CGI-POST-FIELD OF COB2CGI-POST-FIELD-VALUE-FLAG TO TRUE
    MOVE 1 TO COB2CGI-TAB-IND
    MOVE 1 TO COB2CGI-TAB-NR
    INITIALIZE COB2CGI-TAB-LINE(COB2CGI-TAB-IND)
    MOVE 1 TO COB2CGI-IND-1
    MOVE 1 TO COB2CGI-IND-2

    PERFORM UNTIL V-COB2CGI-EOF-YES   OF COB2CGI-EOF-FLAG
            OR    V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
       *> read next char from CGI input stream     
       PERFORM COB2CGI-READ-NEXT-CHAR
       IF V-COB2CGI-EOF-YES OF COB2CGI-EOF-FLAG
       THEN
          EXIT PERFORM
       END-IF

       EVALUATE TRUE
          *> end of field name
          WHEN COB2CGI-CHAR = "="
             SET V-COB2CGI-POST-VALUE OF COB2CGI-POST-FIELD-VALUE-FLAG TO TRUE
             COMPUTE COB2CGI-TAB-FIELD-LEN(COB2CGI-TAB-IND)
                   = COB2CGI-IND-1 - 1
             END-COMPUTE
             MOVE 1 TO COB2CGI-IND-1
             MOVE COB2CGI-IND-2 
               TO COB2CGI-TAB-VALUE-PTR(COB2CGI-TAB-IND)
               
          *> end of value, start a field name     
          WHEN COB2CGI-CHAR = "&"
             SET V-COB2CGI-POST-FIELD OF COB2CGI-POST-FIELD-VALUE-FLAG TO TRUE
             IF COB2CGI-TAB-IND = 1
             THEN
                COMPUTE COB2CGI-TAB-VALUE-LEN(COB2CGI-TAB-IND)
                      = COB2CGI-IND-2 - 1 
                END-COMPUTE 
             ELSE
                COMPUTE COB2CGI-TAB-VALUE-LEN(COB2CGI-TAB-IND)
                      = COB2CGI-IND-2 - COB2CGI-TAB-VALUE-PTR(COB2CGI-TAB-IND) 
                END-COMPUTE 
             END-IF
             
             ADD 1 TO COB2CGI-TAB-IND
             ADD 1 TO COB2CGI-TAB-NR
             
             *> check table limit
             IF COB2CGI-TAB-IND > COB2CGI-TAB-MAX-LINE
             OR COB2CGI-TAB-NR  > COB2CGI-TAB-MAX-LINE
             THEN
                DISPLAY "<BR>Error: DATA-TAB-NR " COB2CGI-TAB-NR
                        " greater than " COB2CGI-TAB-MAX-LINE 
                        " DATA-TAB-MAX-LINE <BR>"
                END-DISPLAY
                SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
                EXIT SECTION
             END-IF
             *> init next line in the table
             INITIALIZE COB2CGI-TAB-LINE(COB2CGI-TAB-IND)
          
          *> UTF8 special char in hexa code
          WHEN COB2CGI-CHAR = "%"
             MOVE COB2CGI-CHAR TO COB2CGI-UTF8-STR(1:1)
             *> read next char from CGI input stream     
             PERFORM COB2CGI-READ-NEXT-CHAR
             IF V-COB2CGI-EOF-YES OF COB2CGI-EOF-FLAG
             THEN
                EXIT PERFORM
             END-IF
             MOVE COB2CGI-CHAR TO COB2CGI-UTF8-STR(2:1)

             *> read next char from CGI input stream     
             PERFORM COB2CGI-READ-NEXT-CHAR
             IF V-COB2CGI-EOF-YES OF COB2CGI-EOF-FLAG
             THEN
                EXIT PERFORM
             END-IF
             MOVE COB2CGI-CHAR TO COB2CGI-UTF8-STR(3:1)

             *> convert UTF8 string
             MOVE COB2CGI-DECODE(COB2CGI-UTF8-STR)
               TO COB2CGI-DATA-VALUE(COB2CGI-IND-2:1)
               
             *> check value limit
             ADD 1 TO COB2CGI-IND-2
             IF COB2CGI-IND-2 > COB2CGI-DATA-VALUE-MAX-LEN
             THEN
                DISPLAY "<BR>Error: DATA-VALUE-LEN " COB2CGI-IND-2
                        " greater than " COB2CGI-DATA-VALUE-MAX-LEN
                        " DATA-VALUE-MAX-LEN <BR>"
                END-DISPLAY
                SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
                EXIT SECTION
             END-IF
      
          *> a SPACE char
          WHEN COB2CGI-CHAR = "+"
             MOVE SPACES
               TO COB2CGI-DATA-VALUE(COB2CGI-IND-2:1)
               
             *> check value limit
             ADD 1 TO COB2CGI-IND-2
             IF COB2CGI-IND-2 > COB2CGI-DATA-VALUE-MAX-LEN
             THEN
                DISPLAY "<BR>Error: DATA-VALUE-LEN " COB2CGI-IND-2
                        " greater than " COB2CGI-DATA-VALUE-MAX-LEN
                        " DATA-VALUE-MAX-LEN <BR>"
                END-DISPLAY
                SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
                EXIT SECTION
             END-IF
          
          *> other chars
          WHEN OTHER
             IF V-COB2CGI-POST-FIELD OF COB2CGI-POST-FIELD-VALUE-FLAG
             THEN
                MOVE COB2CGI-CHAR
                  TO COB2CGI-TAB-FIELD(COB2CGI-TAB-IND)
                                           (COB2CGI-IND-1:1)
                                           
                *> check field limit
                ADD 1 TO COB2CGI-IND-1
                IF COB2CGI-IND-1 > COB2CGI-TAB-FIELD-MAX-LEN
                THEN
                   DISPLAY "<BR>Error: FIELD-LEN " COB2CGI-IND-1
                           " greater than " COB2CGI-TAB-FIELD-MAX-LEN
                           " DATA-TAB-FIELD-MAX-LEN <BR>"
                   END-DISPLAY
                   SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
                   EXIT SECTION
                END-IF
             ELSE
                MOVE COB2CGI-CHAR
                  TO COB2CGI-DATA-VALUE(COB2CGI-IND-2:1)
                  
                *> check value limit
                ADD 1 TO COB2CGI-IND-2
                IF COB2CGI-IND-2 > COB2CGI-DATA-VALUE-MAX-LEN
                THEN
                   DISPLAY "<BR>Error: DATA-VALUE-LEN " COB2CGI-IND-2
                           " greater than " COB2CGI-DATA-VALUE-MAX-LEN
                           " DATA-VALUE-MAX-LEN <BR>"
                   END-DISPLAY
                   SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
                   EXIT SECTION
                END-IF
             END-IF
       END-EVALUATE
    END-PERFORM

    IF COB2CGI-TAB-IND = 1
    THEN
       COMPUTE COB2CGI-TAB-VALUE-LEN(COB2CGI-TAB-IND)
             = COB2CGI-IND-2 - 1 
       END-COMPUTE 
    ELSE
       COMPUTE COB2CGI-TAB-VALUE-LEN(COB2CGI-TAB-IND)
             = COB2CGI-IND-2 - COB2CGI-TAB-VALUE-PTR(COB2CGI-TAB-IND) 
       END-COMPUTE 
    END-IF
    
    .
 COB2CGI-PARSE-GET-POST-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COB2CGI-READ-NEXT-CHAR SECTION.
*>------------------------------------------------------------------------------
    
    ADD 1 TO COB2CGI-CHAR-COUNT

    IF COB2CGI-CHAR-COUNT > COB2CGI-CONTENT-LEN + 1
    THEN
       DISPLAY "<BR>Error: CHAR-COUNT " COB2CGI-CHAR-COUNT
               " greater than " COB2CGI-CONTENT-LEN " CONTENT-LEN <BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF
    
    IF V-COB2CGI-REQUEST-METHOD-GET OF COB2CGI-REQUEST-METHOD-FLAG
    THEN
       *> data with GET
       ADD 1 TO COB2CGI-QUERY-STR-IND

       IF COB2CGI-QUERY-STR-IND > COB2CGI-QUERY-STR-MAX-LEN
       THEN
          DISPLAY "<BR>Error: QUERY-STR-IND " COB2CGI-QUERY-STR-IND
                  " greater than " COB2CGI-QUERY-STR-MAX-LEN 
                  " QUERY-STR-MAX-LEN <BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
       
       IF COB2CGI-QUERY-STR-IND > COB2CGI-QUERY-STR-LEN
       THEN
          SET V-COB2CGI-EOF-YES OF COB2CGI-EOF-FLAG TO TRUE
          EXIT SECTION
       END-IF

       MOVE COB2CGI-QUERY-STR(COB2CGI-QUERY-STR-IND:1)       
         TO COB2CGI-CHAR
    ELSE
       *> data with POST
       CALL STATIC "getchar" RETURNING COB2CGI-GETCHAR END-CALL
   
       IF COB2CGI-GETCHAR < ZEROES
       THEN
          SET V-COB2CGI-EOF-YES OF COB2CGI-EOF-FLAG TO TRUE
          EXIT SECTION
       END-IF
   
       MOVE COB2CGI-GETCHAR TO COB2CGI-CHAR-R
    END-IF

    *> !!!only for test!!!
    *> DISPLAY COB2CGI-CHAR WITH NO ADVANCING END-DISPLAY
       
    .
 COB2CGI-READ-NEXT-CHAR-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COB2CGI-PARSE-UPLOAD SECTION.
*>------------------------------------------------------------------------------
    
    PERFORM COB2CGI-UPL-GET-BOUNDARY
    IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
    THEN
       DISPLAY "<BR>Error in UPL-GET-BOUNDARY <BR>" END-DISPLAY
       EXIT SECTION
    END-IF
    
    *> !!!only for test, display boundary data!!!
    *> DISPLAY "BOUNDARY: " COB2CGI-BOUNDARY "<BR>" END-DISPLAY
    *> DISPLAY "BOUNDARY-LEN: " COB2CGI-BOUNDARY-LEN "<BR>" END-DISPLAY
    *> DISPLAY "BOUNDARY-EOF: " COB2CGI-BOUNDARY-EOF "<BR>" "<BR>"  END-DISPLAY
    
    PERFORM COB2CGI-UPL-READ-POST
    
    *> !!!only for test!!!
    *> success, if boundary EOF string found, without any error    
    *> IF  V-COB2CGI-ERROR-NO OF COB2CGI-ERROR-FLAG
    *> AND V-COB2CGI-BOUNDARY-EOF-YES OF COB2CGI-BOUNDARY-EOF-FLAG    
    *> THEN
    *>    DISPLAY "<BR>" "<BR>" 
    *>            "BOUNDARY-EOF found, CGI post processed successfully"
    *>            "<BR>" "<BR>" 
    *>    END-DISPLAY
    *> END-IF
       
    .
 COB2CGI-PARSE-UPLOAD-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 COB2CGI-UPL-GET-BOUNDARY SECTION.
*>------------------------------------------------------------------------------

    IF COB2CGI-ENV-VALUE(1:30) = "multipart/form-data; boundary="
    THEN
       MOVE COB2CGI-ENV-VALUE(31:) TO COB2CGI-BOUNDARY
       MOVE FUNCTION STORED-CHAR-LENGTH(COB2CGI-BOUNDARY) 
         TO COB2CGI-BOUNDARY-LEN
       
       MOVE SPACES TO COB2CGI-BOUNDARY-EOF
       STRING COB2CGI-BOUNDARY(1:COB2CGI-BOUNDARY-LEN)
              "--"
         INTO COB2CGI-BOUNDARY-EOF
       END-STRING  
    ELSE
       DISPLAY "Error: can not find boundary string: " 
               COB2CGI-ENV-VALUE 
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

    .
 COB2CGI-UPL-GET-BOUNDARY-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 COB2CGI-UPL-READ-POST SECTION.
*>------------------------------------------------------------------------------

    MOVE ZEROES TO COB2CGI-CHAR-COUNT
    MOVE ZEROES TO COB2CGI-GETCHAR
    MOVE 1 TO COB2CGI-IND-2

    *> read a "boundary" line with EOL
    PERFORM COB2CGI-READ-NEXT-LINE   
    IF V-COB2CGI-EOL-YES OF COB2CGI-EOL-FLAG
    THEN
       PERFORM COB2CGI-CHECK-BOUNDARY

       *> this must be a "boundary" line         
       IF V-COB2CGI-BOUNDARY-NO OF COB2CGI-BOUNDARY-FLAG
       THEN
          DISPLAY "Error: boundary line not found" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    ELSE   
       DISPLAY "Error: end of line not found" 
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF
          
    PERFORM UNTIL COB2CGI-CHAR-COUNT > COB2CGI-CONTENT-LEN
            OR    COB2CGI-GETCHAR < ZEROES
            OR    V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
            OR    V-COB2CGI-BOUNDARY-EOF-YES OF COB2CGI-BOUNDARY-EOF-FLAG

       *> read a "Content-Disposition" line with EOL
       PERFORM COB2CGI-READ-NEXT-LINE   
       
       *> this must have an EOL
       IF V-COB2CGI-EOL-YES OF COB2CGI-EOL-FLAG
       THEN
          PERFORM COB2CGI-CHECK-CONTENT-DISP
          IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
          THEN
             EXIT SECTION
          END-IF
       
          *> this must be a "Content-Disposition" line         
          EVALUATE TRUE
          WHEN V-COB2CGI-CONTENT-DISP-FIELD OF COB2CGI-CONTENT-DISP-FLAG
             *> read and save field value                
             PERFORM COB2CGI-PARSE-FIELD-VALUE
       
          WHEN V-COB2CGI-CONTENT-DISP-FILE  OF COB2CGI-CONTENT-DISP-FLAG
             *> read and save the uploaded file                
             PERFORM COB2CGI-PARSE-FILE-UPLOAD
       
          WHEN OTHER
             DISPLAY "Error: Content-Disposition not found" 
                     "<BR>"
             END-DISPLAY
             SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
             EXIT SECTION
          END-EVALUATE
       ELSE   
          DISPLAY "Error: end of line not found" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-PERFORM   
      
    .
 COB2CGI-UPL-READ-POST-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COB2CGI-READ-NEXT-LINE SECTION.
*>------------------------------------------------------------------------------

    MOVE ZEROES    TO COB2CGI-INPUT-BUF-IND
    MOVE LOW-VALUE TO COB2CGI-INPUT-BUF
    
    SET V-COB2CGI-EOL-NO OF COB2CGI-EOL-FLAG TO TRUE
    SET V-COB2CGI-EOF-NO OF COB2CGI-EOF-FLAG TO TRUE

    PERFORM UNTIL COB2CGI-CHAR-COUNT > COB2CGI-CONTENT-LEN
            OR    COB2CGI-INPUT-BUF-IND > COB2CGI-INPUT-BUF-MAX-LEN
            OR    COB2CGI-GETCHAR < ZEROES

       CALL STATIC "getchar" RETURNING COB2CGI-GETCHAR END-CALL

       IF COB2CGI-CHAR-COUNT > COB2CGI-CONTENT-LEN
       OR COB2CGI-GETCHAR < ZEROES
       THEN
          SET V-COB2CGI-EOF-YES OF COB2CGI-EOF-FLAG TO TRUE
          EXIT SECTION
       END-IF
       
       ADD 1 TO COB2CGI-CHAR-COUNT
       ADD 1 TO COB2CGI-INPUT-BUF-IND

       IF COB2CGI-INPUT-BUF-IND <= COB2CGI-INPUT-BUF-MAX-LEN
       THEN
          MOVE COB2CGI-GETCHAR TO COB2CGI-CHAR-R 
          MOVE COB2CGI-CHAR    TO COB2CGI-INPUT-BUF(COB2CGI-INPUT-BUF-IND:1)

          *> !!!only for test!!! 
          *> received chars         
          *> DISPLAY COB2CGI-CHAR WITH NO ADVANCING END-DISPLAY
          *> received chars with num values        
          *> DISPLAY "(" COB2CGI-GETCHAR ")" END-DISPLAY
          *> IF COB2CGI-GETCHAR = 10
          *> THEN
          *>    DISPLAY "<BR>" END-DISPLAY
          *> END-IF
          
          *> check end of line X"0A" or X"0D0A"         
          IF COB2CGI-GETCHAR = 10
          OR COB2CGI-INPUT-BUF-IND = COB2CGI-INPUT-BUF-MAX-LEN
          THEN
             SET V-COB2CGI-EOL-YES OF COB2CGI-EOL-FLAG TO TRUE
             EXIT SECTION 
          END-IF
       ELSE   
          *> input buffer full       
          EXIT SECTION
       END-IF
    END-PERFORM   
    
    .
 COB2CGI-READ-NEXT-LINE-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 COB2CGI-CHECK-BOUNDARY SECTION.
*>------------------------------------------------------------------------------

    SET V-COB2CGI-BOUNDARY-NO     OF COB2CGI-BOUNDARY-FLAG     TO TRUE
    SET V-COB2CGI-BOUNDARY-EOF-NO OF COB2CGI-BOUNDARY-EOF-FLAG TO TRUE
     
    *> search boundary string   
    MOVE ZEROES TO COB2CGI-INSPECT-COUNT
    INSPECT COB2CGI-INPUT-BUF(1:COB2CGI-INPUT-BUF-IND) 
       TALLYING COB2CGI-INSPECT-COUNT
       FOR ALL  COB2CGI-BOUNDARY(1:COB2CGI-BOUNDARY-LEN)    
    
    IF COB2CGI-INSPECT-COUNT > ZEROES
    THEN
       SET V-COB2CGI-BOUNDARY-YES OF COB2CGI-BOUNDARY-FLAG TO TRUE
       
       *> search boundary EOF string   
       MOVE ZEROES TO COB2CGI-INSPECT-COUNT
       INSPECT COB2CGI-INPUT-BUF(1:COB2CGI-INPUT-BUF-IND) 
          TALLYING COB2CGI-INSPECT-COUNT
          FOR ALL  COB2CGI-BOUNDARY-EOF(1:COB2CGI-BOUNDARY-LEN + 2)    
          
       IF COB2CGI-INSPECT-COUNT > ZEROES
       THEN
          SET V-COB2CGI-BOUNDARY-EOF-YES OF COB2CGI-BOUNDARY-EOF-FLAG TO TRUE
       END-IF        
    END-IF
    
    .
 COB2CGI-CHECK-BOUNDARY-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COB2CGI-CHECK-CONTENT-DISP SECTION.
*>------------------------------------------------------------------------------

    SET V-COB2CGI-CONTENT-DISP-ERROR OF COB2CGI-CONTENT-DISP-FLAG TO TRUE

    IF COB2CGI-INPUT-BUF(1:38) NOT = "Content-Disposition: form-data; name="""
    THEN
       EXIT SECTION
    END-IF

    *> for every Content-Disposition there is a line in the internal table    
    ADD 1 TO COB2CGI-TAB-IND  
    MOVE COB2CGI-TAB-IND TO COB2CGI-TAB-NR
    
    IF COB2CGI-TAB-IND > COB2CGI-TAB-MAX-LINE
    THEN
       DISPLAY "Error: internal table full" 
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF  
    
    *> get length of field name       
    MOVE ZEROES TO COB2CGI-INSPECT-COUNT    
    INSPECT COB2CGI-INPUT-BUF(39:) 
       TALLYING COB2CGI-INSPECT-COUNT
       FOR CHARACTERS BEFORE INITIAL """"

    *> save length of field name          
    MOVE COB2CGI-INSPECT-COUNT 
      TO COB2CGI-TAB-FIELD-LEN(COB2CGI-TAB-IND)
       
    *> save field name          
    MOVE COB2CGI-INPUT-BUF(39:COB2CGI-INSPECT-COUNT) 
      TO COB2CGI-TAB-FIELD(COB2CGI-TAB-IND)
    
    *> search number of fields
    MOVE ZEROES TO COB2CGI-INSPECT-COUNT    
    INSPECT COB2CGI-INPUT-BUF(39:) 
       TALLYING COB2CGI-INSPECT-COUNT
       FOR ALL """"
    
    *> this is only one field --> exit section      
    IF COB2CGI-INSPECT-COUNT = 1
    THEN
       SET V-COB2CGI-CONTENT-DISP-FIELD OF COB2CGI-CONTENT-DISP-FLAG TO TRUE
       SET V-COB2CGI-TAB-FILE-NO OF COB2CGI-TAB-FILE-FLAG(COB2CGI-TAB-IND) 
                                                                     TO TRUE
       EXIT SECTION
    END-IF

    *> search file name       
    MOVE ZEROES TO COB2CGI-INSPECT-COUNT    
    INSPECT COB2CGI-INPUT-BUF(39 + COB2CGI-TAB-FIELD-LEN(COB2CGI-TAB-IND):) 
       TALLYING COB2CGI-INSPECT-COUNT
       FOR CHARACTERS BEFORE INITIAL "filename="""

    IF COB2CGI-INSPECT-COUNT = 3
    THEN
       SET V-COB2CGI-CONTENT-DISP-FILE OF COB2CGI-CONTENT-DISP-FLAG TO TRUE
       SET V-COB2CGI-TAB-FILE-YES OF COB2CGI-TAB-FILE-FLAG(COB2CGI-TAB-IND) 
                                                                    TO TRUE
    
       *> get length of file name       
       MOVE ZEROES TO COB2CGI-INSPECT-COUNT    
       INSPECT COB2CGI-INPUT-BUF(39 + COB2CGI-TAB-FIELD-LEN(COB2CGI-TAB-IND) 
                                    + 13:) 
          TALLYING COB2CGI-INSPECT-COUNT
          FOR CHARACTERS BEFORE INITIAL """"

       *> save length of file name in temp         
       MOVE COB2CGI-INSPECT-COUNT 
         TO COB2CGI-TMP-FILE-NAME-LEN
          
       *> save file name in temp         
       MOVE COB2CGI-INPUT-BUF(39 + COB2CGI-TAB-FIELD-LEN(COB2CGI-TAB-IND) 
                                 + 13:COB2CGI-INSPECT-COUNT) 
         TO COB2CGI-TMP-FILE-NAME

       *> Check file name. Internet Explorer sends a file name with full
       *> file path, but Firefox sends only a file name.
       MOVE ZEROES TO COB2CGI-INSPECT-COUNT    
       INSPECT COB2CGI-TMP-FILE-NAME 
          TALLYING COB2CGI-INSPECT-COUNT
          FOR ALL "\" "/"
       
       IF COB2CGI-INSPECT-COUNT = ZEROES
       THEN
          *> this is only a file name without file path
          *> save length of file name          
          MOVE COB2CGI-TMP-FILE-NAME-LEN 
            TO COB2CGI-TAB-FILE-NAME-LEN(COB2CGI-TAB-IND)
          *> save file name          
          MOVE COB2CGI-TMP-FILE-NAME
            TO COB2CGI-TAB-FILE-NAME(COB2CGI-TAB-IND)
       ELSE
          *> this is a file name with full file path, get file name from it
          MOVE ZEROES TO COB2CGI-INSPECT-COUNT    
          
          INSPECT FUNCTION REVERSE(COB2CGI-TMP-FILE-NAME)
             TALLYING COB2CGI-INSPECT-COUNT
             FOR CHARACTERS BEFORE INITIAL "\"
                            BEFORE INITIAL "/"
       
          COMPUTE COB2CGI-TMP-FILE-PATH-LEN 
                = FUNCTION LENGTH(COB2CGI-TMP-FILE-NAME)
                - COB2CGI-INSPECT-COUNT + 1
          END-COMPUTE                             

          *> save length of file name          
          COMPUTE COB2CGI-TAB-FILE-NAME-LEN(COB2CGI-TAB-IND) 
                = COB2CGI-TMP-FILE-NAME-LEN
                - COB2CGI-TMP-FILE-PATH-LEN + 1
          END-COMPUTE                             
                
          *> save file name          
          MOVE COB2CGI-TMP-FILE-NAME(COB2CGI-TMP-FILE-PATH-LEN:
                                     COB2CGI-TAB-FILE-NAME-LEN(COB2CGI-TAB-IND))
            TO COB2CGI-TAB-FILE-NAME(COB2CGI-TAB-IND)
       END-IF       
    ELSE     
       DISPLAY "Error: filename not found in Content-Disposition" 
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF    
    
    .
 COB2CGI-CHECK-CONTENT-DISP-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COB2CGI-PARSE-FIELD-VALUE SECTION.
*>------------------------------------------------------------------------------

    *> this must be an empty line
    PERFORM COB2CGI-READ-NEXT-LINE   
    IF V-COB2CGI-EOL-NO OF COB2CGI-EOL-FLAG
    OR COB2CGI-INPUT-BUF(1:2) NOT = COB2CGI-CRLF
    THEN
       DISPLAY "Error: end of line not found" 
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

    *> init char counter   
    MOVE ZEROES TO COB2CGI-IND-1

    SET V-COB2CGI-FIRST-LINE-YES OF COB2CGI-FIRST-LINE-FLAG TO TRUE
    MOVE SPACES TO COB2CGI-INPUT-BUF-SAVE
    MOVE ZEROES TO COB2CGI-INPUT-BUF-SAVE-IND

    *> set value pointer in the table    
    MOVE COB2CGI-IND-2
      TO COB2CGI-TAB-VALUE-PTR(COB2CGI-TAB-IND)
    
    PERFORM TEST AFTER
      UNTIL V-COB2CGI-BOUNDARY-YES     OF COB2CGI-BOUNDARY-FLAG
      OR    V-COB2CGI-BOUNDARY-EOF-YES OF COB2CGI-BOUNDARY-EOF-FLAG
      
       *> read a line
       PERFORM COB2CGI-READ-NEXT-LINE   
       IF V-COB2CGI-EOF-YES OF COB2CGI-EOF-FLAG
       THEN
          DISPLAY "Error: boundary line not found" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF

       PERFORM COB2CGI-CHECK-BOUNDARY

       IF V-COB2CGI-BOUNDARY-YES     OF COB2CGI-BOUNDARY-FLAG
       OR V-COB2CGI-BOUNDARY-EOF-YES OF COB2CGI-BOUNDARY-EOF-FLAG
       THEN
          *> end of field reached
          *> write last line without CRLF
          IF COB2CGI-INPUT-BUF-SAVE-IND > 2
          THEN
             IF COB2CGI-IND-2 < COB2CGI-DATA-VALUE-MAX-LEN
             THEN
                MOVE COB2CGI-INPUT-BUF-SAVE(1:COB2CGI-INPUT-BUF-SAVE-IND - 2) 
                  TO COB2CGI-DATA-VALUE(COB2CGI-IND-2:)
                COMPUTE COB2CGI-IND-1 = COB2CGI-IND-1 
                                 + COB2CGI-INPUT-BUF-SAVE-IND - 2
                END-COMPUTE
                MOVE COB2CGI-IND-1
                  TO COB2CGI-TAB-VALUE-LEN(COB2CGI-TAB-IND)
                ADD COB2CGI-IND-1 TO COB2CGI-IND-2
             ELSE
                DISPLAY "Error: value is too long" 
                        "<BR>"
                END-DISPLAY
                SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
                EXIT SECTION
             END-IF          
          END-IF
          
          EXIT PERFORM        
       ELSE   
          IF V-COB2CGI-FIRST-LINE-NO OF COB2CGI-FIRST-LINE-FLAG
          THEN
             *> this was only a CRLF, we have to write it in the internal table
             IF COB2CGI-IND-2 < COB2CGI-DATA-VALUE-MAX-LEN
             THEN
                MOVE COB2CGI-INPUT-BUF-SAVE(1:COB2CGI-INPUT-BUF-SAVE-IND) 
                  TO COB2CGI-DATA-VALUE(COB2CGI-IND-2:)
                ADD COB2CGI-INPUT-BUF-SAVE-IND TO COB2CGI-IND-1
                MOVE COB2CGI-IND-1
                  TO COB2CGI-TAB-VALUE-LEN(COB2CGI-TAB-IND)
                ADD COB2CGI-IND-1 TO COB2CGI-IND-2
             ELSE
                DISPLAY "Error: value is too long" 
                        "<BR>"
                END-DISPLAY
                SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
                EXIT SECTION
             END-IF          
          END-IF

          *> save line
          SET V-COB2CGI-FIRST-LINE-NO OF COB2CGI-FIRST-LINE-FLAG TO TRUE
          MOVE COB2CGI-INPUT-BUF     TO COB2CGI-INPUT-BUF-SAVE
          MOVE COB2CGI-INPUT-BUF-IND TO COB2CGI-INPUT-BUF-SAVE-IND
       END-IF
    END-PERFORM
    
    .
 COB2CGI-PARSE-FIELD-VALUE-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 COB2CGI-PARSE-FILE-UPLOAD SECTION.
*>------------------------------------------------------------------------------

    *> this must be a Content-Type
    PERFORM COB2CGI-READ-NEXT-LINE   
    IF V-COB2CGI-EOL-NO OF COB2CGI-EOL-FLAG
    OR COB2CGI-INPUT-BUF(1:14) NOT = "Content-Type: "
    THEN
       DISPLAY "Error: Content-Type not found" 
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

    *> save Content-Type as file type   
    MOVE ZEROES TO COB2CGI-INSPECT-COUNT    
    INSPECT COB2CGI-INPUT-BUF(15:) 
       TALLYING COB2CGI-INSPECT-COUNT
       FOR CHARACTERS BEFORE INITIAL COB2CGI-CRLF
    MOVE COB2CGI-INPUT-BUF(15:COB2CGI-INSPECT-COUNT) 
      TO COB2CGI-TAB-FILE-TYPE(COB2CGI-TAB-IND)

    *> if not empty file
    IF COB2CGI-TAB-FILE-NAME-LEN(COB2CGI-TAB-IND) NOT = ZEROES
    THEN
       *> check file type
       MOVE COB2CGI-TAB-FILE-TYPE(COB2CGI-TAB-IND) TO COB2CGI-CHECK-FILE-TYPE
       IF  NOT V-COB2CGI-FILE-TYPE-ALLOWED OF COB2CGI-CHECK-FILE-TYPE
       THEN
          DISPLAY "Error: File-Type not allowed" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
          EXIT SECTION
       END-IF
    END-IF
      
    *> this must be an empty line
    PERFORM COB2CGI-READ-NEXT-LINE   
    IF V-COB2CGI-EOL-NO OF COB2CGI-EOL-FLAG
    OR COB2CGI-INPUT-BUF(1:2) NOT = COB2CGI-CRLF
    THEN
       DISPLAY "Error: end of line not found" 
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

    *> if not empty file
    IF COB2CGI-TAB-FILE-NAME-LEN(COB2CGI-TAB-IND) NOT = ZEROES
    THEN
       *> create uploaded file
       PERFORM COB2CGI-FILE-CREATE
       IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
       THEN
          EXIT SECTION
       END-IF
    END-IF
    
    *> init offset    
    MOVE ZEROES TO COB2CGI-FILE-OFFSET

    SET V-COB2CGI-FIRST-LINE-YES OF COB2CGI-FIRST-LINE-FLAG TO TRUE
    MOVE SPACES TO COB2CGI-INPUT-BUF-SAVE
    MOVE ZEROES TO COB2CGI-INPUT-BUF-SAVE-IND
    
    PERFORM TEST AFTER
      UNTIL V-COB2CGI-BOUNDARY-YES     OF COB2CGI-BOUNDARY-FLAG
      OR    V-COB2CGI-BOUNDARY-EOF-YES OF COB2CGI-BOUNDARY-EOF-FLAG
      
       *> read a line
       PERFORM COB2CGI-READ-NEXT-LINE   
       IF V-COB2CGI-EOF-YES OF COB2CGI-EOF-FLAG
       THEN
          DISPLAY "Error: boundary line not found" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
          EXIT PERFORM
       END-IF

       PERFORM COB2CGI-CHECK-BOUNDARY

       IF V-COB2CGI-BOUNDARY-YES     OF COB2CGI-BOUNDARY-FLAG
       OR V-COB2CGI-BOUNDARY-EOF-YES OF COB2CGI-BOUNDARY-EOF-FLAG
       THEN
          *> end of uploaded file reached
          *> write last line without CRLF
          IF COB2CGI-INPUT-BUF-SAVE-IND > 2
          THEN
             MOVE COB2CGI-INPUT-BUF-SAVE(1:COB2CGI-INPUT-BUF-SAVE-IND - 2) 
               TO COB2CGI-FILE-BUF
             COMPUTE COB2CGI-FILE-NBYTES = COB2CGI-INPUT-BUF-SAVE-IND - 2
             END-COMPUTE
             
             PERFORM COB2CGI-FILE-WRITE
             IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
             THEN
                EXIT PERFORM
             END-IF
          END-IF
          
          EXIT PERFORM        
       ELSE   
          IF V-COB2CGI-FIRST-LINE-NO OF COB2CGI-FIRST-LINE-FLAG
          THEN
             *> this was only a CRLF, we have to write it in the file
             MOVE COB2CGI-INPUT-BUF-SAVE(1:COB2CGI-INPUT-BUF-SAVE-IND) 
               TO COB2CGI-FILE-BUF
             MOVE COB2CGI-INPUT-BUF-SAVE-IND TO COB2CGI-FILE-NBYTES
          
             PERFORM COB2CGI-FILE-WRITE
             IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
             THEN
                EXIT PERFORM
             END-IF
          ELSE
             *> if not empty file
             IF COB2CGI-TAB-FILE-NAME-LEN(COB2CGI-TAB-IND) NOT = ZEROES
             THEN
                *> this is the first line, we can check here the file data          
                PERFORM COB2CGI-CHECK-FILE-DATA             
                IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
                THEN
                   EXIT PERFORM
                END-IF
             END-IF
          END-IF

          *> save line
          SET V-COB2CGI-FIRST-LINE-NO OF COB2CGI-FIRST-LINE-FLAG TO TRUE
          MOVE COB2CGI-INPUT-BUF     TO COB2CGI-INPUT-BUF-SAVE
          MOVE COB2CGI-INPUT-BUF-IND TO COB2CGI-INPUT-BUF-SAVE-IND
       END-IF
    END-PERFORM
    
    *> if not empty file
    IF COB2CGI-TAB-FILE-NAME-LEN(COB2CGI-TAB-IND) NOT = ZEROES
    THEN
       PERFORM COB2CGI-FILE-CLOSE
       IF V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG
       THEN
          EXIT SECTION
       END-IF
    END-IF
    
    .
 COB2CGI-PARSE-FILE-UPLOAD-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COB2CGI-CHECK-FILE-DATA SECTION.
*>------------------------------------------------------------------------------

    *> check uploaded file data
    EVALUATE TRUE
    WHEN V-COB2CGI-FILE-TYPE-BMP OF COB2CGI-CHECK-FILE-TYPE
       IF COB2CGI-INPUT-BUF(1:2) NOT = "BM"
       THEN
          DISPLAY "Error: Image content not BMP" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       END-IF       
      
    WHEN V-COB2CGI-FILE-TYPE-GIF OF COB2CGI-CHECK-FILE-TYPE
       IF COB2CGI-INPUT-BUF(1:3) NOT = "GIF"
       THEN
          DISPLAY "Error: Image content not GIF" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       END-IF       

    WHEN V-COB2CGI-FILE-TYPE-JPG OF COB2CGI-CHECK-FILE-TYPE
       IF  COB2CGI-INPUT-BUF(1:4) NOT = X"FFD8FFE0"
       AND COB2CGI-INPUT-BUF(1:4) NOT = X"FFD8FFE1"
       THEN
          DISPLAY "Error: Image content not JPG" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       END-IF       

    WHEN V-COB2CGI-FILE-TYPE-PNG OF COB2CGI-CHECK-FILE-TYPE
       IF COB2CGI-INPUT-BUF(1:4) NOT = X"89504E47"
       THEN
          DISPLAY "Error: Image content not PNG" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       END-IF       

    WHEN V-COB2CGI-FILE-TYPE-TIF OF COB2CGI-CHECK-FILE-TYPE
       IF  COB2CGI-INPUT-BUF(1:3) NOT = X"49492A"
       AND COB2CGI-INPUT-BUF(1:3) NOT = X"4D4D2A"
       THEN
          DISPLAY "Error: Image content not TIF" 
                  "<BR>"
          END-DISPLAY
          SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       END-IF       
    
    WHEN OTHER
       DISPLAY "Error: File-Type not allowed" 
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
    END-EVALUATE
    
    .
 COB2CGI-CHECK-FILE-DATA-EX.
    EXIT.
    
*>------------------------------------------------------------------------------
 COB2CGI-FILE-CREATE SECTION.
*>------------------------------------------------------------------------------

    CALL "CBL_CREATE_FILE" 
         USING COB2CGI-TAB-FILE-NAME(COB2CGI-TAB-IND)
             , 2
             , 0
             , 0
             , COB2CGI-FILE-HANDLE
    END-CALL    

    IF RETURN-CODE NOT = ZEROES
    THEN
       DISPLAY "Error: CBL_CREATE_FILE, "
               "FILE: " COB2CGI-TAB-FILE-NAME(COB2CGI-TAB-IND)       
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
    END-IF

    .
 COB2CGI-FILE-CREATE-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COB2CGI-FILE-WRITE SECTION.
*>------------------------------------------------------------------------------

    CALL "CBL_WRITE_FILE" 
         USING COB2CGI-FILE-HANDLE
       , COB2CGI-FILE-OFFSET
       , COB2CGI-FILE-NBYTES
       , 0
       , COB2CGI-FILE-BUF(1:COB2CGI-INPUT-BUF-IND)
    END-CALL             
     
    IF RETURN-CODE NOT = ZEROES
    THEN
       DISPLAY "Error: CBL_WRITE_FILE, "
               "FILE: " COB2CGI-TAB-FILE-NAME(COB2CGI-TAB-IND)       
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
    END-IF

    ADD  COB2CGI-FILE-NBYTES TO COB2CGI-FILE-OFFSET
    *> update uploaded file size    
    MOVE COB2CGI-FILE-OFFSET TO COB2CGI-TAB-FILE-DATA-LEN(COB2CGI-TAB-IND)

    *> check max. allowed file size    
    IF COB2CGI-UPLOAD-FILE-MAX-SIZE < COB2CGI-TAB-FILE-DATA-LEN(COB2CGI-TAB-IND)
    THEN
       DISPLAY "Error: " COB2CGI-TAB-FILE-NAME(COB2CGI-TAB-IND) " file size"
               " > " COB2CGI-UPLOAD-FILE-MAX-SIZE " max. allowed size" "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
       EXIT SECTION
    END-IF

    .
 COB2CGI-FILE-WRITE-EX.
    EXIT.

*>------------------------------------------------------------------------------
 COB2CGI-FILE-CLOSE SECTION.
*>------------------------------------------------------------------------------

    CALL "CBL_CLOSE_FILE"
         USING COB2CGI-FILE-HANDLE
    END-CALL         

    IF RETURN-CODE NOT = ZEROES
    THEN
       DISPLAY "Error: CBL_CLOSE_FILE, "
               "FILE: " COB2CGI-TAB-FILE-NAME(COB2CGI-TAB-IND)       
               "<BR>"
       END-DISPLAY
       SET V-COB2CGI-ERROR-YES OF COB2CGI-ERROR-FLAG TO TRUE
    END-IF
    
    .
 COB2CGI-FILE-CLOSE-EX.
    EXIT.
    
 END PROGRAM cgiform.

 
*>******************************************************************************
*>  COB2CGI-POST.cob is free software: you can redistribute it and/or
*>  modify it under the terms of the GNU Lesser General Public License as
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  COB2CGI-POST.cob is distributed in the hope that it will be useful,
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License
*>  along with COB2CGI-POST.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Function:     COB2CGI-POST.cob
*>
*> Purpose:      Get saved cgi values
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.08.21
*>
*> Usage:        To use this function, simply CALL it as follows:
*>               COB2CGI-POST(<cgi-field-name>)
*>               Fields in COB2CGI-POST linkage:
*>                 <cgi-field-name>  - input
*>                 <cgi-field-value> - output
*>******************************************************************************

 IDENTIFICATION DIVISION.
 FUNCTION-ID. COB2CGI-POST.
 AUTHOR.      Laszlo Erdos.

 ENVIRONMENT DIVISION.
 DATA DIVISION.
 WORKING-STORAGE SECTION.

*> there are only the name of fields in the internal table
 01 COB2CGI-TAB-IND                    PIC 9(9) COMP.
 78 COB2CGI-TAB-MAX-LINE               VALUE 1000.
 01 COB2CGI-TAB-NR            EXTERNAL PIC 9(9) COMP.
 01 COB2CGI-TABLE-R           EXTERNAL PIC X(161000).
 01 COB2CGI-TABLE REDEFINES COB2CGI-TABLE-R.
   02 COB2CGI-DATA-TAB.
     03 COB2CGI-TAB-LINE               OCCURS 1 TO COB2CGI-TAB-MAX-LINE TIMES.
       04 COB2CGI-TAB-FIELD            PIC X(40).
       04 COB2CGI-TAB-FIELD-LEN        PIC 9(9) COMP.
       04 COB2CGI-TAB-VALUE-PTR        PIC 9(9) COMP.
       04 COB2CGI-TAB-VALUE-LEN        PIC 9(9) COMP.
       04 COB2CGI-TAB-FILE-FLAG        PIC 9.
          88 V-COB2CGI-TAB-FILE-NO     VALUE 0.
          88 V-COB2CGI-TAB-FILE-YES    VALUE 1.
       04 COB2CGI-TAB-FILE-NAME        PIC X(60).
       04 COB2CGI-TAB-FILE-NAME-LEN    PIC 9(9) COMP.
       04 COB2CGI-TAB-FILE-TYPE        PIC X(40).
       04 COB2CGI-TAB-FILE-DATA-LEN    PIC 9(9) COMP.

*> we can save memory, if we use one field for all values
 01 COB2CGI-DATA-VALUE        EXTERNAL PIC X(500000).

 01 COB2CGI-IND-1                      PIC 9(9) COMP.

 LINKAGE SECTION.
 01 LNK-CGI-FIELD-NAME                 PIC X(40).
 01 LNK-CGI-FIELD-VALUE.
   02 LEN                              PIC 9(9) COMP.
   02 VAL                              PIC X(500000).

 PROCEDURE DIVISION USING     BY VALUE LNK-CGI-FIELD-NAME
                    RETURNING          LNK-CGI-FIELD-VALUE.

 COB2CGI-POST-MAIN SECTION.

    PERFORM VARYING COB2CGI-IND-1 FROM 1 BY 1
      UNTIL COB2CGI-IND-1 > COB2CGI-TAB-NR
      OR    COB2CGI-IND-1 > COB2CGI-TAB-MAX-LINE

       IF COB2CGI-TAB-FIELD(COB2CGI-IND-1) = LNK-CGI-FIELD-NAME
       THEN
          IF COB2CGI-TAB-VALUE-LEN(COB2CGI-IND-1) = ZEROES
          THEN
             MOVE ZEROES
               TO LEN OF LNK-CGI-FIELD-VALUE
             MOVE SPACES
               TO VAL OF LNK-CGI-FIELD-VALUE
          ELSE
             MOVE COB2CGI-TAB-VALUE-LEN(COB2CGI-IND-1)
               TO LEN OF LNK-CGI-FIELD-VALUE
             MOVE COB2CGI-DATA-VALUE
                  (COB2CGI-TAB-VALUE-PTR(COB2CGI-IND-1):
                   COB2CGI-TAB-VALUE-LEN(COB2CGI-IND-1))
               TO VAL OF LNK-CGI-FIELD-VALUE
          END-IF

          EXIT PERFORM
       END-IF
    END-PERFORM

    IF COB2CGI-IND-1 > COB2CGI-TAB-NR
    OR COB2CGI-IND-1 > COB2CGI-TAB-MAX-LINE
    THEN
       MOVE ZEROES
         TO LEN OF LNK-CGI-FIELD-VALUE
       MOVE SPACES
         TO VAL OF LNK-CGI-FIELD-VALUE
    END-IF

    GOBACK

    .
 COB2CGI-POST-MAIN-EX.
    EXIT.
 END FUNCTION COB2CGI-POST.
 
*>******************************************************************************
*>  COB2CGI-ENV.cob is free software: you can redistribute it and/or
*>  modify it under the terms of the GNU Lesser General Public License as
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  COB2CGI-ENV.cob is distributed in the hope that it will be useful,
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License
*>  along with COB2CGI-ENV.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Function:     COB2CGI-ENV.cob
*>
*> Purpose:      Get cgi environment variables
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.08.21
*>
*> Usage:        To use this function, simply CALL it as follows:
*>               COB2CGI-ENV(<env-name>)
*>               Fields in COB2CGI-ENV linkage:
*>                 <env-name>  - input
*>                 <env-value> - output
*>******************************************************************************

 IDENTIFICATION DIVISION.
 FUNCTION-ID. COB2CGI-ENV.
 AUTHOR.      Laszlo Erdos.

 ENVIRONMENT DIVISION.
 DATA DIVISION.
 WORKING-STORAGE SECTION.

 LINKAGE SECTION.
 01 LNK-ENV-NAME                       PIC X(256).
 01 LNK-ENV-VALUE                      PIC X(256).

 PROCEDURE DIVISION USING     BY VALUE LNK-ENV-NAME
                    RETURNING          LNK-ENV-VALUE.

 COB2CGI-ENV-MAIN SECTION.

    ACCEPT LNK-ENV-VALUE FROM ENVIRONMENT
           LNK-ENV-NAME
    END-ACCEPT

    GOBACK

    .
 COB2CGI-ENV-MAIN-EX.
    EXIT.
 END FUNCTION COB2CGI-ENV.

*>******************************************************************************
*>  COB2CGI-DECODE.cob is free software: you can redistribute it and/or
*>  modify it under the terms of the GNU Lesser General Public License as
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  COB2CGI-DECODE.cob is distributed in the hope that it will be useful,
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License
*>  along with COB2CGI-DECODE.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Function:     COB2CGI-DECODE.cob
*>
*> Purpose:      Decode UTF-8 chars
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.08.21
*>
*> Usage:        To use this function, simply CALL it as follows:
*>               COB2CGI-DECODE(<UTF8-string>)
*>               Fields in COB2CGI-DECODE linkage:
*>                 <UTF8-string>  - input
*>                 <UTF8-value>   - output
*>******************************************************************************

 IDENTIFICATION DIVISION.
 FUNCTION-ID. COB2CGI-DECODE.
 AUTHOR.      Laszlo Erdos.

 ENVIRONMENT DIVISION.
 DATA DIVISION.
 WORKING-STORAGE SECTION.

 01 WS-DECODE-TABLE.
   02 FILLER                           PIC X(4) VALUE "%00" & X"00".
   02 FILLER                           PIC X(4) VALUE "%01" & X"01".
   02 FILLER                           PIC X(4) VALUE "%02" & X"02".
   02 FILLER                           PIC X(4) VALUE "%03" & X"03".
   02 FILLER                           PIC X(4) VALUE "%04" & X"04".
   02 FILLER                           PIC X(4) VALUE "%05" & X"05".
   02 FILLER                           PIC X(4) VALUE "%06" & X"06".
   02 FILLER                           PIC X(4) VALUE "%07" & X"07".
   02 FILLER                           PIC X(4) VALUE "%08" & X"08".
   02 FILLER                           PIC X(4) VALUE "%09" & X"09".
   02 FILLER                           PIC X(4) VALUE "%0A" & X"0A".
   02 FILLER                           PIC X(4) VALUE "%0B" & X"0B".
   02 FILLER                           PIC X(4) VALUE "%0C" & X"0C".
   02 FILLER                           PIC X(4) VALUE "%0D" & X"0D".
   02 FILLER                           PIC X(4) VALUE "%0E" & X"0E".
   02 FILLER                           PIC X(4) VALUE "%0F" & X"0F".

   02 FILLER                           PIC X(4) VALUE "%10" & X"10".
   02 FILLER                           PIC X(4) VALUE "%11" & X"11".
   02 FILLER                           PIC X(4) VALUE "%12" & X"12".
   02 FILLER                           PIC X(4) VALUE "%13" & X"13".
   02 FILLER                           PIC X(4) VALUE "%14" & X"14".
   02 FILLER                           PIC X(4) VALUE "%15" & X"15".
   02 FILLER                           PIC X(4) VALUE "%16" & X"16".
   02 FILLER                           PIC X(4) VALUE "%17" & X"17".
   02 FILLER                           PIC X(4) VALUE "%18" & X"18".
   02 FILLER                           PIC X(4) VALUE "%19" & X"19".
   02 FILLER                           PIC X(4) VALUE "%1A" & X"1A".
   02 FILLER                           PIC X(4) VALUE "%1B" & X"1B".
   02 FILLER                           PIC X(4) VALUE "%1C" & X"1C".
   02 FILLER                           PIC X(4) VALUE "%1D" & X"1D".
   02 FILLER                           PIC X(4) VALUE "%1E" & X"1E".
   02 FILLER                           PIC X(4) VALUE "%1F" & X"1F".

   02 FILLER                           PIC X(4) VALUE "%20" & X"20".
   02 FILLER                           PIC X(4) VALUE "%21" & X"21".
   02 FILLER                           PIC X(4) VALUE "%22" & X"22".
   02 FILLER                           PIC X(4) VALUE "%23" & X"23".
   02 FILLER                           PIC X(4) VALUE "%24" & X"24".
   02 FILLER                           PIC X(4) VALUE "%25" & X"25".
   02 FILLER                           PIC X(4) VALUE "%26" & X"26".
   02 FILLER                           PIC X(4) VALUE "%27" & X"27".
   02 FILLER                           PIC X(4) VALUE "%28" & X"28".
   02 FILLER                           PIC X(4) VALUE "%29" & X"29".
   02 FILLER                           PIC X(4) VALUE "%2A" & X"2A".
   02 FILLER                           PIC X(4) VALUE "%2B" & X"2B".
   02 FILLER                           PIC X(4) VALUE "%2C" & X"2C".
   02 FILLER                           PIC X(4) VALUE "%2D" & X"2D".
   02 FILLER                           PIC X(4) VALUE "%2E" & X"2E".
   02 FILLER                           PIC X(4) VALUE "%2F" & X"2F".

   02 FILLER                           PIC X(4) VALUE "%30" & X"30".
   02 FILLER                           PIC X(4) VALUE "%31" & X"31".
   02 FILLER                           PIC X(4) VALUE "%32" & X"32".
   02 FILLER                           PIC X(4) VALUE "%33" & X"33".
   02 FILLER                           PIC X(4) VALUE "%34" & X"34".
   02 FILLER                           PIC X(4) VALUE "%35" & X"35".
   02 FILLER                           PIC X(4) VALUE "%36" & X"36".
   02 FILLER                           PIC X(4) VALUE "%37" & X"37".
   02 FILLER                           PIC X(4) VALUE "%38" & X"38".
   02 FILLER                           PIC X(4) VALUE "%39" & X"39".
   02 FILLER                           PIC X(4) VALUE "%3A" & X"3A".
   02 FILLER                           PIC X(4) VALUE "%3B" & X"3B".
   02 FILLER                           PIC X(4) VALUE "%3C" & X"3C".
   02 FILLER                           PIC X(4) VALUE "%3D" & X"3D".
   02 FILLER                           PIC X(4) VALUE "%3E" & X"3E".
   02 FILLER                           PIC X(4) VALUE "%3F" & X"3F".

   02 FILLER                           PIC X(4) VALUE "%40" & X"40".
   02 FILLER                           PIC X(4) VALUE "%41" & X"41".
   02 FILLER                           PIC X(4) VALUE "%42" & X"42".
   02 FILLER                           PIC X(4) VALUE "%43" & X"43".
   02 FILLER                           PIC X(4) VALUE "%44" & X"44".
   02 FILLER                           PIC X(4) VALUE "%45" & X"45".
   02 FILLER                           PIC X(4) VALUE "%46" & X"46".
   02 FILLER                           PIC X(4) VALUE "%47" & X"47".
   02 FILLER                           PIC X(4) VALUE "%48" & X"48".
   02 FILLER                           PIC X(4) VALUE "%49" & X"49".
   02 FILLER                           PIC X(4) VALUE "%4A" & X"4A".
   02 FILLER                           PIC X(4) VALUE "%4B" & X"4B".
   02 FILLER                           PIC X(4) VALUE "%4C" & X"4C".
   02 FILLER                           PIC X(4) VALUE "%4D" & X"4D".
   02 FILLER                           PIC X(4) VALUE "%4E" & X"4E".
   02 FILLER                           PIC X(4) VALUE "%4F" & X"4F".

   02 FILLER                           PIC X(4) VALUE "%50" & X"50".
   02 FILLER                           PIC X(4) VALUE "%51" & X"51".
   02 FILLER                           PIC X(4) VALUE "%52" & X"52".
   02 FILLER                           PIC X(4) VALUE "%53" & X"53".
   02 FILLER                           PIC X(4) VALUE "%54" & X"54".
   02 FILLER                           PIC X(4) VALUE "%55" & X"55".
   02 FILLER                           PIC X(4) VALUE "%56" & X"56".
   02 FILLER                           PIC X(4) VALUE "%57" & X"57".
   02 FILLER                           PIC X(4) VALUE "%58" & X"58".
   02 FILLER                           PIC X(4) VALUE "%59" & X"59".
   02 FILLER                           PIC X(4) VALUE "%5A" & X"5A".
   02 FILLER                           PIC X(4) VALUE "%5B" & X"5B".
   02 FILLER                           PIC X(4) VALUE "%5C" & X"5C".
   02 FILLER                           PIC X(4) VALUE "%5D" & X"5D".
   02 FILLER                           PIC X(4) VALUE "%5E" & X"5E".
   02 FILLER                           PIC X(4) VALUE "%5F" & X"5F".

   02 FILLER                           PIC X(4) VALUE "%60" & X"60".
   02 FILLER                           PIC X(4) VALUE "%61" & X"61".
   02 FILLER                           PIC X(4) VALUE "%62" & X"62".
   02 FILLER                           PIC X(4) VALUE "%63" & X"63".
   02 FILLER                           PIC X(4) VALUE "%64" & X"64".
   02 FILLER                           PIC X(4) VALUE "%65" & X"65".
   02 FILLER                           PIC X(4) VALUE "%66" & X"66".
   02 FILLER                           PIC X(4) VALUE "%67" & X"67".
   02 FILLER                           PIC X(4) VALUE "%68" & X"68".
   02 FILLER                           PIC X(4) VALUE "%69" & X"69".
   02 FILLER                           PIC X(4) VALUE "%6A" & X"6A".
   02 FILLER                           PIC X(4) VALUE "%6B" & X"6B".
   02 FILLER                           PIC X(4) VALUE "%6C" & X"6C".
   02 FILLER                           PIC X(4) VALUE "%6D" & X"6D".
   02 FILLER                           PIC X(4) VALUE "%6E" & X"6E".
   02 FILLER                           PIC X(4) VALUE "%6F" & X"6F".

   02 FILLER                           PIC X(4) VALUE "%70" & X"70".
   02 FILLER                           PIC X(4) VALUE "%71" & X"71".
   02 FILLER                           PIC X(4) VALUE "%72" & X"72".
   02 FILLER                           PIC X(4) VALUE "%73" & X"73".
   02 FILLER                           PIC X(4) VALUE "%74" & X"74".
   02 FILLER                           PIC X(4) VALUE "%75" & X"75".
   02 FILLER                           PIC X(4) VALUE "%76" & X"76".
   02 FILLER                           PIC X(4) VALUE "%77" & X"77".
   02 FILLER                           PIC X(4) VALUE "%78" & X"78".
   02 FILLER                           PIC X(4) VALUE "%79" & X"79".
   02 FILLER                           PIC X(4) VALUE "%7A" & X"7A".
   02 FILLER                           PIC X(4) VALUE "%7B" & X"7B".
   02 FILLER                           PIC X(4) VALUE "%7C" & X"7C".
   02 FILLER                           PIC X(4) VALUE "%7D" & X"7D".
   02 FILLER                           PIC X(4) VALUE "%7E" & X"7E".
   02 FILLER                           PIC X(4) VALUE "%7F" & X"7F".

   02 FILLER                           PIC X(4) VALUE "%80" & X"80".
   02 FILLER                           PIC X(4) VALUE "%81" & X"81".
   02 FILLER                           PIC X(4) VALUE "%82" & X"82".
   02 FILLER                           PIC X(4) VALUE "%83" & X"83".
   02 FILLER                           PIC X(4) VALUE "%84" & X"84".
   02 FILLER                           PIC X(4) VALUE "%85" & X"85".
   02 FILLER                           PIC X(4) VALUE "%86" & X"86".
   02 FILLER                           PIC X(4) VALUE "%87" & X"87".
   02 FILLER                           PIC X(4) VALUE "%88" & X"88".
   02 FILLER                           PIC X(4) VALUE "%89" & X"89".
   02 FILLER                           PIC X(4) VALUE "%8A" & X"8A".
   02 FILLER                           PIC X(4) VALUE "%8B" & X"8B".
   02 FILLER                           PIC X(4) VALUE "%8C" & X"8C".
   02 FILLER                           PIC X(4) VALUE "%8D" & X"8D".
   02 FILLER                           PIC X(4) VALUE "%8E" & X"8E".
   02 FILLER                           PIC X(4) VALUE "%8F" & X"8F".

   02 FILLER                           PIC X(4) VALUE "%90" & X"90".
   02 FILLER                           PIC X(4) VALUE "%91" & X"91".
   02 FILLER                           PIC X(4) VALUE "%92" & X"92".
   02 FILLER                           PIC X(4) VALUE "%93" & X"93".
   02 FILLER                           PIC X(4) VALUE "%94" & X"94".
   02 FILLER                           PIC X(4) VALUE "%95" & X"95".
   02 FILLER                           PIC X(4) VALUE "%96" & X"96".
   02 FILLER                           PIC X(4) VALUE "%97" & X"97".
   02 FILLER                           PIC X(4) VALUE "%98" & X"98".
   02 FILLER                           PIC X(4) VALUE "%99" & X"99".
   02 FILLER                           PIC X(4) VALUE "%9A" & X"9A".
   02 FILLER                           PIC X(4) VALUE "%9B" & X"9B".
   02 FILLER                           PIC X(4) VALUE "%9C" & X"9C".
   02 FILLER                           PIC X(4) VALUE "%9D" & X"9D".
   02 FILLER                           PIC X(4) VALUE "%9E" & X"9E".
   02 FILLER                           PIC X(4) VALUE "%9F" & X"9F".

   02 FILLER                           PIC X(4) VALUE "%A0" & X"A0".
   02 FILLER                           PIC X(4) VALUE "%A1" & X"A1".
   02 FILLER                           PIC X(4) VALUE "%A2" & X"A2".
   02 FILLER                           PIC X(4) VALUE "%A3" & X"A3".
   02 FILLER                           PIC X(4) VALUE "%A4" & X"A4".
   02 FILLER                           PIC X(4) VALUE "%A5" & X"A5".
   02 FILLER                           PIC X(4) VALUE "%A6" & X"A6".
   02 FILLER                           PIC X(4) VALUE "%A7" & X"A7".
   02 FILLER                           PIC X(4) VALUE "%A8" & X"A8".
   02 FILLER                           PIC X(4) VALUE "%A9" & X"A9".
   02 FILLER                           PIC X(4) VALUE "%AA" & X"AA".
   02 FILLER                           PIC X(4) VALUE "%AB" & X"AB".
   02 FILLER                           PIC X(4) VALUE "%AC" & X"AC".
   02 FILLER                           PIC X(4) VALUE "%AD" & X"AD".
   02 FILLER                           PIC X(4) VALUE "%AE" & X"AE".
   02 FILLER                           PIC X(4) VALUE "%AF" & X"AF".

   02 FILLER                           PIC X(4) VALUE "%B0" & X"B0".
   02 FILLER                           PIC X(4) VALUE "%B1" & X"B1".
   02 FILLER                           PIC X(4) VALUE "%B2" & X"B2".
   02 FILLER                           PIC X(4) VALUE "%B3" & X"B3".
   02 FILLER                           PIC X(4) VALUE "%B4" & X"B4".
   02 FILLER                           PIC X(4) VALUE "%B5" & X"B5".
   02 FILLER                           PIC X(4) VALUE "%B6" & X"B6".
   02 FILLER                           PIC X(4) VALUE "%B7" & X"B7".
   02 FILLER                           PIC X(4) VALUE "%B8" & X"B8".
   02 FILLER                           PIC X(4) VALUE "%B9" & X"B9".
   02 FILLER                           PIC X(4) VALUE "%BA" & X"BA".
   02 FILLER                           PIC X(4) VALUE "%BB" & X"BB".
   02 FILLER                           PIC X(4) VALUE "%BC" & X"BC".
   02 FILLER                           PIC X(4) VALUE "%BD" & X"BD".
   02 FILLER                           PIC X(4) VALUE "%BE" & X"BE".
   02 FILLER                           PIC X(4) VALUE "%BF" & X"BF".

   02 FILLER                           PIC X(4) VALUE "%C0" & X"C0".
   02 FILLER                           PIC X(4) VALUE "%C1" & X"C1".
   02 FILLER                           PIC X(4) VALUE "%C2" & X"C2".
   02 FILLER                           PIC X(4) VALUE "%C3" & X"C3".
   02 FILLER                           PIC X(4) VALUE "%C4" & X"C4".
   02 FILLER                           PIC X(4) VALUE "%C5" & X"C5".
   02 FILLER                           PIC X(4) VALUE "%C6" & X"C6".
   02 FILLER                           PIC X(4) VALUE "%C7" & X"C7".
   02 FILLER                           PIC X(4) VALUE "%C8" & X"C8".
   02 FILLER                           PIC X(4) VALUE "%C9" & X"C9".
   02 FILLER                           PIC X(4) VALUE "%CA" & X"CA".
   02 FILLER                           PIC X(4) VALUE "%CB" & X"CB".
   02 FILLER                           PIC X(4) VALUE "%CC" & X"CC".
   02 FILLER                           PIC X(4) VALUE "%CD" & X"CD".
   02 FILLER                           PIC X(4) VALUE "%CE" & X"CE".
   02 FILLER                           PIC X(4) VALUE "%CF" & X"CF".

   02 FILLER                           PIC X(4) VALUE "%D0" & X"D0".
   02 FILLER                           PIC X(4) VALUE "%D1" & X"D1".
   02 FILLER                           PIC X(4) VALUE "%D2" & X"D2".
   02 FILLER                           PIC X(4) VALUE "%D3" & X"D3".
   02 FILLER                           PIC X(4) VALUE "%D4" & X"D4".
   02 FILLER                           PIC X(4) VALUE "%D5" & X"D5".
   02 FILLER                           PIC X(4) VALUE "%D6" & X"D6".
   02 FILLER                           PIC X(4) VALUE "%D7" & X"D7".
   02 FILLER                           PIC X(4) VALUE "%D8" & X"D8".
   02 FILLER                           PIC X(4) VALUE "%D9" & X"D9".
   02 FILLER                           PIC X(4) VALUE "%DA" & X"DA".
   02 FILLER                           PIC X(4) VALUE "%DB" & X"DB".
   02 FILLER                           PIC X(4) VALUE "%DC" & X"DC".
   02 FILLER                           PIC X(4) VALUE "%DD" & X"DD".
   02 FILLER                           PIC X(4) VALUE "%DE" & X"DE".
   02 FILLER                           PIC X(4) VALUE "%DF" & X"DF".

   02 FILLER                           PIC X(4) VALUE "%E0" & X"E0".
   02 FILLER                           PIC X(4) VALUE "%E1" & X"E1".
   02 FILLER                           PIC X(4) VALUE "%E2" & X"E2".
   02 FILLER                           PIC X(4) VALUE "%E3" & X"E3".
   02 FILLER                           PIC X(4) VALUE "%E4" & X"E4".
   02 FILLER                           PIC X(4) VALUE "%E5" & X"E5".
   02 FILLER                           PIC X(4) VALUE "%E6" & X"E6".
   02 FILLER                           PIC X(4) VALUE "%E7" & X"E7".
   02 FILLER                           PIC X(4) VALUE "%E8" & X"E8".
   02 FILLER                           PIC X(4) VALUE "%E9" & X"E9".
   02 FILLER                           PIC X(4) VALUE "%EA" & X"EA".
   02 FILLER                           PIC X(4) VALUE "%EB" & X"EB".
   02 FILLER                           PIC X(4) VALUE "%EC" & X"EC".
   02 FILLER                           PIC X(4) VALUE "%ED" & X"ED".
   02 FILLER                           PIC X(4) VALUE "%EE" & X"EE".
   02 FILLER                           PIC X(4) VALUE "%EF" & X"EF".

   02 FILLER                           PIC X(4) VALUE "%F0" & X"F0".
   02 FILLER                           PIC X(4) VALUE "%F1" & X"F1".
   02 FILLER                           PIC X(4) VALUE "%F2" & X"F2".
   02 FILLER                           PIC X(4) VALUE "%F3" & X"F3".
   02 FILLER                           PIC X(4) VALUE "%F4" & X"F4".
   02 FILLER                           PIC X(4) VALUE "%F5" & X"F5".
   02 FILLER                           PIC X(4) VALUE "%F6" & X"F6".
   02 FILLER                           PIC X(4) VALUE "%F7" & X"F7".
   02 FILLER                           PIC X(4) VALUE "%F8" & X"F8".
   02 FILLER                           PIC X(4) VALUE "%F9" & X"F9".
   02 FILLER                           PIC X(4) VALUE "%FA" & X"FA".
   02 FILLER                           PIC X(4) VALUE "%FB" & X"FB".
   02 FILLER                           PIC X(4) VALUE "%FC" & X"FC".
   02 FILLER                           PIC X(4) VALUE "%FD" & X"FD".
   02 FILLER                           PIC X(4) VALUE "%FE" & X"FE".
   02 FILLER                           PIC X(4) VALUE "%FF" & X"FF".

 01 WS-DECODE-TAB REDEFINES WS-DECODE-TABLE.
   02 WS-DECODE-TAB-LINE               OCCURS 1 TO 256 TIMES
                                       ASCENDING KEY IS WS-DECODE-TAB-UTF8-STR
                                       INDEXED BY WS-DECODE-TAB-INDEX.
     03 WS-DECODE-TAB-UTF8-STR         PIC X(3).
     03 WS-DECODE-TAB-UTF8-VAL         PIC X(1).

 LINKAGE SECTION.
 01 LNK-UTF8-STR                       PIC X(3).
 01 LNK-UTF8-VAL                       PIC X(1).

 PROCEDURE DIVISION USING     BY VALUE LNK-UTF8-STR
                    RETURNING          LNK-UTF8-VAL.

 COB2CGI-DECODE-MAIN SECTION.

    SET WS-DECODE-TAB-INDEX TO 1
    SEARCH ALL WS-DECODE-TAB-LINE
       AT END
          *> not found --> gives space back
          MOVE X"20"
            TO LNK-UTF8-VAL

       WHEN WS-DECODE-TAB-UTF8-STR(WS-DECODE-TAB-INDEX) = LNK-UTF8-STR
          MOVE WS-DECODE-TAB-UTF8-VAL(WS-DECODE-TAB-INDEX)
            TO LNK-UTF8-VAL
    END-SEARCH

    GOBACK

    .
 COB2CGI-DECODE-MAIN-EX.
    EXIT.
 END FUNCTION COB2CGI-DECODE.

*>******************************************************************************
*>  COB2CGI-NUM2HEX.cob is free software: you can redistribute it and/or
*>  modify it under the terms of the GNU Lesser General Public License as
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  COB2CGI-NUM2HEX.cob is distributed in the hope that it will be useful,
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License
*>  along with COB2CGI-NUM2HEX.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Function:     COB2CGI-NUM2HEX.cob
*>
*> Purpose:      Convert a number in hexa
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2015.08.21
*>
*> Usage:        To use this function, simply CALL it as follows:
*>               COB2CGI-NUM2HEX(<number>)
*>               Fields in COB2CGI-NUM2HEX linkage:
*>                 <number>      - input
*>                 <hexa string> - output
*>******************************************************************************

 IDENTIFICATION DIVISION.
 FUNCTION-ID. COB2CGI-NUM2HEX.
 AUTHOR.      Laszlo Erdos.

 ENVIRONMENT DIVISION.
 DATA DIVISION.
 WORKING-STORAGE SECTION.

 01 COB2CGI-NUM2HEX-IN                     PIC 9(2) COMP-5.
 01 COB2CGI-NUM2HEX-OUT                    PIC X(2).
 01 COB2CGI-NUM2HEX-QUOTIENT               PIC 9(2) COMP-5.
 01 COB2CGI-NUM2HEX-REMAINDER              PIC 9(2) COMP-5.
 01 COB2CGI-HEX-CHAR                       PIC X(16)
                                           VALUE "0123456789ABCDEF".
 01 COB2CGI-IND-1                          PIC 9(2) COMP-5.

 LINKAGE SECTION.
 01 LNK-NUM-DATA                          PIC X(1).
 01 LNK-NUM-DATA-R REDEFINES LNK-NUM-DATA PIC 9(2) COMP-5.
 01 LNK-HEX-DATA                          PIC X(2).

 PROCEDURE DIVISION USING     BY VALUE LNK-NUM-DATA
                    RETURNING          LNK-HEX-DATA.

 COB2CGI-NUM2HEX-MAIN SECTION.

    INITIALIZE LNK-HEX-DATA

    MOVE LNK-NUM-DATA-R TO COB2CGI-NUM2HEX-IN

    INITIALIZE COB2CGI-NUM2HEX-OUT

    PERFORM VARYING COB2CGI-IND-1 FROM 2 BY -1
            UNTIL   COB2CGI-IND-1 < 1

       DIVIDE COB2CGI-NUM2HEX-IN BY 16
          GIVING    COB2CGI-NUM2HEX-QUOTIENT
          REMAINDER COB2CGI-NUM2HEX-REMAINDER
       END-DIVIDE

       ADD 1 TO COB2CGI-NUM2HEX-REMAINDER

       MOVE COB2CGI-HEX-CHAR(COB2CGI-NUM2HEX-REMAINDER:1)
         TO COB2CGI-NUM2HEX-OUT(COB2CGI-IND-1:1)

       MOVE COB2CGI-NUM2HEX-QUOTIENT
         TO COB2CGI-NUM2HEX-IN
    END-PERFORM

    MOVE COB2CGI-NUM2HEX-OUT  TO LNK-HEX-DATA

    GOBACK

    .
 COB2CGI-NUM2HEX-MAIN-EX.
    EXIT.
 END FUNCTION COB2CGI-NUM2HEX.
