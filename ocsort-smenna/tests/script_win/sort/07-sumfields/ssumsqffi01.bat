:: 07-sumfields-ssumsqffi01.bat

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win

set sqfi01=%filedir%\sqfi01
%exedir%\iosqfi01
set sqfi01=


call execsort %takedir%\sort\07-sumfields\ssumsqffi01_take.prm  ssumsqffi01
set rtc=%errorlevel%
set sqfi01c=%filedir%\sqfi01_07.srt
%exedir%\iosqfi01c
call checkerr2
set rtc=%errorlevel%
set sqfi01c= 