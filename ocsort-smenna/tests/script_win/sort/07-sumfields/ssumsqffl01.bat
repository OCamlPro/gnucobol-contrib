:: 07-sumfields-ssumsqffl01.bat

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win

set sqfl01=%filedir%\sqfl01
%exedir%\iosqfl01
set sqfl01=

call execsort %takedir%\sort\07-sumfields\ssumsqffl01_take.prm  ssumsqffl01
set rtc=%errorlevel%
set sqfl01c=%filedir%\sqfl01_07.srt
%exedir%\iosqfl01c
call checkerr2
set rtc=%errorlevel%
set sqfl01c= 