:: 07-sumfields-ssumsqfbi03.bat

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win

set sqbi03=%filedir%\sqbi03
%exedir%\iosqbi03
set sqbi03=

call execsort %takedir%\sort\07-sumfields\ssumsqfbi03_take.prm  ssumsqfbi03
set rtc=%errorlevel%
set sqbi03c=%filedir%\sqbi03_07.srt
%exedir%\iosqbi03c
call checkerr2
set rtc=%errorlevel%
set sqbi03c= 