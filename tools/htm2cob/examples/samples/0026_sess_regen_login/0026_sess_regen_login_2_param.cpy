*>******************************************************************************
*>  This file is part of htm2cob.
*>
*>  0026_sess_regen_login_param_2.cpy is free software: you can redistribute it and/or
*>  modify it under the terms of the GNU Lesser General Public License as
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  0026_sess_regen_login_param_2.cpy is distributed in the hope that it will be useful,
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License
*>  along with 0026_sess_regen_login_param_2.cpy.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Copy file:    0026_sess_regen_login_param_2.cpy
*>
*> Purpose:      Parameter for the generated CGI server program
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2017.12.24
*>
*> Usage:        It is important that you set the parameters carefully. 
*>               It is security relevant. Set the right request method, 
*>               and so many fields and memory, what you really need.
*>******************************************************************************

*>------------------------------------------------------------------------------
*> If yes, then error messages will be written in the browser. This is only for
*> testing, never use it in online system! 
 01 HTM2COB-DEBUG-FLAG          GLOBAL PIC 9(1) VALUE 1.
    88 V-HTM2COB-DEBUG-NO              VALUE 0.
    88 V-HTM2COB-DEBUG-YES             VALUE 1.

*>------------------------------------------------------------------------------
*> Request method flag. Usually you need POST, because GET is less secure than
*> POST. With UPLOAD you can allow a file upload. A file upload works only with
*> POST together.
 01 HTM2COB-REQUEST-METHOD-FLAG        PIC 9(1) VALUE 2.
    88 V-HTM2COB-RM-GET                VALUE 0.
    88 V-HTM2COB-RM-POST               VALUE 1.
    88 V-HTM2COB-RM-POST-UPLOAD        VALUE 2.

*>------------------------------------------------------------------------------
*> Max GET data length in query string. This is only for the GET request method
*> relevant. (bytes)
 78 HTM2COB-QUERY-STR-MAX-LEN          VALUE 65536.
*> Max POST data length together with upload file size. (bytes)
 78 HTM2COB-CONTENT-MAX-LEN            VALUE 1000000.
*> Max upload file size. (bytes)
 78 HTM2COB-UPLOAD-FILE-MAX-SIZE       VALUE 600000.

*>------------------------------------------------------------------------------
*> Max number of lines in the internal table. It means the number of fields
*> and the number of upload file names together in a form. These are only the
*> names without values.
 78 HTM2COB-TAB-MAX-LINE        GLOBAL VALUE 1000.
*> Max value length for all field values together. This is only the field values
*> together, without field names, without upload file names, without upload file
*> size. For special chars you need 2 or 3 bytes. (bytes)
 78 HTM2COB-DATA-VALUE-MAX-LEN         VALUE 500000.

*>------------------------------------------------------------------------------
*> File path for the uploaded files. 
 01 HTM2COB-UPLOAD-FILE-PATH           PIC X(1024) VALUE "/tmp/".
*> Allowed file types for image upload.
 01 HTM2COB-IMG-BMP-FLAG               PIC 9(1) VALUE 1.
    88 V-HTM2COB-IMG-BMP-NO            VALUE 0.
    88 V-HTM2COB-IMG-BMP-YES           VALUE 1.
 01 HTM2COB-IMG-GIF-FLAG               PIC 9(1) VALUE 1.
    88 V-HTM2COB-IMG-GIF-NO            VALUE 0.
    88 V-HTM2COB-IMG-GIF-YES           VALUE 1.
 01 HTM2COB-IMG-JPG-FLAG               PIC 9(1) VALUE 1.
    88 V-HTM2COB-IMG-JPG-NO            VALUE 0.
    88 V-HTM2COB-IMG-JPG-YES           VALUE 1.
 01 HTM2COB-IMG-PNG-FLAG               PIC 9(1) VALUE 1.
    88 V-HTM2COB-IMG-PNG-NO            VALUE 0.
    88 V-HTM2COB-IMG-PNG-YES           VALUE 1.
 01 HTM2COB-IMG-TIF-FLAG               PIC 9(1) VALUE 1.
    88 V-HTM2COB-IMG-TIF-NO            VALUE 0.
    88 V-HTM2COB-IMG-TIF-YES           VALUE 1.

*>------------------------------------------------------------------------------
*> If the session-flag is yes, then the hidden session-id will be read and the 
*> session files will be used.
 01 HTM2COB-USE-SESSION-FLAG           PIC 9(1) VALUE 1.
    88 V-HTM2COB-USE-SESSION-NO        VALUE 0.
    88 V-HTM2COB-USE-SESSION-YES       VALUE 1.
*> If the session-cookie-flag is yes, then the session-id will be read from
*> cookies. In this case you have to write first a cookie with the session-id.
*> If this flag is no, then the session-id will be read from HTML forms hidden
*> input field "hidden_session_id".
 01 HTM2COB-USE-SESS-COOKIE-FLAG       PIC 9(1) VALUE 0.
    88 V-HTM2COB-USE-SESS-COOKIE-NO    VALUE 0.
    88 V-HTM2COB-USE-SESS-COOKIE-YES   VALUE 1.
*> If you are using GnuCOBOL with BDB (Berkeley DB) you have to set the
*> environment variable DB_HOME to where your session files are saved.
 01 HTM2COB-DB-HOME             GLOBAL PIC X(1024) VALUE "/tmp".
*> File path for the session file. 
 01 HTM2COB-SESSION-FILE        GLOBAL PIC X(1024) VALUE "/tmp/0026_session.dat".
*> File path for the session variable file. 
 01 HTM2COB-SESSION-VAR-FILE    GLOBAL PIC X(1024) VALUE "/tmp/0026_session_var.dat".
*> Max time after first request. The session will be deleted after this time.
*> 1h = 3600 sec
*> 4h = 14400 sec
 01 HTM2COB-FIRST-REQ-DIFF-SEC         PIC 9(18) VALUE 14400.
*> Max time after last request. The session will be deleted after this time.
*> 15 min = 900 sec
 01 HTM2COB-LAST-REQ-DIFF-SEC          PIC 9(18) VALUE 900.

*>------------------------------------------------------------------------------
*> Max length of the HTM2COB-HTTP-COOKIE field. This has the value from 
*> the HTTP_COOKIE environment variable.
 78 HTM2COB-HTTP-COOKIE-MAX-LEN        VALUE 10000.
*> If it set to "YES", then the section HTM2COB-SET-COOKIE will be used. That 
*> means, you have to implement this section in your HTML file.
>>DEFINE USE-HTM2COB-SET-COOKIE-SECTION AS "NO"

