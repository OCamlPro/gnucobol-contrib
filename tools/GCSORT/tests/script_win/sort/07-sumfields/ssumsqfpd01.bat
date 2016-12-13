:: 07-sumfields-ssumsqfpd01

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win

set sqpd01=%filedir%\sqpd01
%exedir%\iosqpd01
set sqpd01=

call execsort %takedir%\sort\07-sumfields\ssumsqfpd01_take.prm  ssumsqfpd01
set rtc=%errorlevel%
set sqpd01c=%filedir%\sqpd01_07.srt
%exedir%\iosqpd01c
set rtc=%errorlevel%
call checkerr2
set sqpd01c= 


