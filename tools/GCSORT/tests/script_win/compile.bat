
:::: 
::  -fbinary-size=<value> binary byte size - defines the allocated bytes according to PIC
::  -fbinary-byteorder=<value> binary byte order

:: binary-size:			1--8
:: binary-truncate:		no
:: binary-byteorder:		big-endian
:: 
:: -fbinary-size=1--8
:: -fnotrunc
:: -fbinary-byteorder=big-endian

:: original cobc -x -std=mf  -t ..\listing\%1.lst -I ..\copy -debug -Wall -o ..\bin\%1 ..\src\%1.CBL 

:: ???
cobc -x -t ..\listing\%1.lst -I ..\copy -Wall -fbinary-size=1--8 -fnotrunc -fbinary-byteorder=big-endian -o ..\bin\%1 ..\src\%1.CBL 

:: cobc -x   -t ..\listing\%1.lst -I ..\copy -debug -Wall -o ..\bin\%1 ..\src\%1.CBL 