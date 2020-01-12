This is an example project for the HTM2COB tool. It uses almost all features 
of HTM2COB, and additionally PostgreSQL is used as a database. For more 
information please read the HTM2COB PDF documentation. 

There is a live demo for this example: https://wortfee.net


What does it do?
----------------
Wort-Fee (in English Word-Fairy) helps you learn the most commonly used words
in English, German and Hungarian. This service is free of charge and you can
use it as a "guest" without registration with "Guest Login".

After selecting the language and level (number of words), you will be asked a
question in the first selected language and six possible answers in the second
selected language. One of the six answers is correct. The Word-Fairy shows you
immediately whether your answer was correct or not. The correct answers are
counted and you must answer each word correctly at least five times to complete
a level.

The first language you choose should be the one you are learning. The words are
queried in this language. The second language chosen must be a known
language, the possible answers are given in this language. For some words there
are pictures that will help you answer.

If there is no response for more than 15 minutes, you have to log in again. In this
case you lose the previous result. When you have successfully completed a level,
you will be added to the guest list.


Directory structure
-------------------
p001_wortfee                - main directory
p001_wortfee/css            - CSS files
p001_wortfee/DB/PostgreSQL  - PostgreSQL scripts, and CSV input file
p001_wortfee/htm2cob        - inputs for HTM2COB, and PostgreSQL modules
p001_wortfee/html           - pure HTML files
p001_wortfee/img            - images for the site
p001_wortfee/img_wortfee    - images for the words
p001_wortfee/js             - jQuery and javascript
p001_wortfee/screenshots    - screenshots

Every directory has a separate make file.


How to install
--------------
- The provided make files are for cygwin and Debian. For other
  environments you have to do some small changes in the make files. For
  example you have to customize the target directories for your web server.
- You have to create a PostgreSQL database (with UTF8 encoding), and
  the SQL tables. See the file psql_create_table.sql. After it you have to
  import the words from the CSV file into the WF_DICTIONARY table.
- Change the PGUSER.cpy file. Update your DB name and DB user for the
  SQL access.
- Change all *_param.cpy files. Update the values at HTM2COB-DBHOME,
  HTM2COB-SESSION-FILE and HTM2COB-SESSION-VAR-FILE.
- Change the domain name in the section HTM2COB-SET-COOKIE in the
  file p001_wortfee_login_cob.html: MOVE "wortfee.net" TO LNK-DOMAINVALUE.
  
  
Test
----
This program was developed and tested using:
- Windows 10 (64 bit) running on a HP laptop
- cygwin (64 bit)
- GnuCOBOL 3.1-dev.0, built on Aug 17 2019
- Open-COBOL-ESQL-1.2 pre-compiler https://github.com/opensourcecobol/Open-COBOL-ESQL
- psql (PostgreSQL) 10.4
- Firefox 71 (64-Bit)

There is a live demo on a Debian server: https://wortfee.net
- Debian version 8.11
- GnuCOBOL 3.1-dev.0, built on Sep 21 2019
- Open-COBOL-ESQL-1.2 pre-compiler https://github.com/opensourcecobol/Open-COBOL-ESQL
- psql (PostgreSQL) 9.4.25
