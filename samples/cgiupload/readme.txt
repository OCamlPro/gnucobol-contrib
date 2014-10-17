CGI file upload demo.

HTML forms without file upload have a content-type 
"application/x-www-form-urlencoded". Processing this content type is
usually simply. 

But if you want to upload a file, then you have to process the 
content-type "multipart/form-data". This program demonstrates how a file
upload is processed. 

The program usage is described in the program header.

Files:

cgiupload.cob          - CGI COBOL program
cygwin_apache_start.sh - start apache under cygwin
cygwin_apache_stop.sh  - stop apache under cygwin
cygwin_compile.sh      - compile the CGI COBOL program under cygwin
readme.txt             - this file
upload1.html           - demo HTML form (empty form)
upload2.html           - demo HTML form (1 text field)
upload3.html           - demo HTML form (1 file)
upload4.html           - demo HTML form (2 file)
upload5.html           - demo HTML form (5 file)
upload6.html           - demo HTML form (1 text field, 1 textarea, 1 file)
upload7.html           - demo HTML form (complex form)
win_compile.bat        - compile the CGI COBOL program under windows 
                         (GnuCOBOL with MS Visual Studio)
			
The CGI Program was tested in these environments:
- 64 bit windows, 64 bit cygwin, GnuCOBOL 2.0, 
  apache web server under cygwin, 
  Firefox 32.0.3, Internet Explorer 11, Google Chrome 38.0.2125.

- 64 bit windows, OpenCOBOL 1.1 32 bit, MS Visual Studio Express 32 bit,
  apache web server under windows, 
  Firefox 32.0.3, Internet Explorer 11. 			
