With this small program you can create a cookie string. These can be sent in an
HTTP response from the web server. See more here: https://en.wikipedia.org/wiki/HTTP_cookie

Cookies must contain a special timestamp format. This example shows how you can 
calculate that cookie timestamp.

Sources:
--------
COOKIE.cob      - this module creates a cookie string depending on the linkage
COOKIE-TEST.cob - test program
Makefile        - makefile
readme.txt      - this file

screenshots/cookie-test_01.jpg    - screenshots after a test run

This program was developed and tested using GnuCOBOL 3.0-rc1.0, cygwin (64 bit)
and Windows 10 (64 bit) running on a HP laptop.
