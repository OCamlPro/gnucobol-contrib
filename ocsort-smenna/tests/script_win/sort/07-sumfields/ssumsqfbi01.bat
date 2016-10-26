:: 07-sumfields-ssumsqfbi01.bat

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win

set sqbi01=%filedir%\sqbi01
%exedir%\iosqbi01
set sqbi01=


call execsort %takedir%\sort\07-sumfields\ssumsqfbi01_take.prm  ssumsqfbi01
set rtc=%errorlevel%
set sqbi01c=%filedir%\sqbi01_07.srt
%exedir%\iosqbi01c
call checkerr2
set rtc=%errorlevel%
set sqbi01c= 