:: 07-sumfields-ssumsqfpd03

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win

set sqpd03=%filedir%\sqpd03
%exedir%\iosqpd03
set sqpd03=

call execsort %takedir%\sort\07-sumfields\ssumsqfpd03_take.prm  ssumsqfpd03
set rtc=%errorlevel%
set sqpd03c=%filedir%\sqpd03_07.srt
%exedir%\iosqpd03c
call checkerr2
set rtc=%errorlevel%
set sqpd03c= 