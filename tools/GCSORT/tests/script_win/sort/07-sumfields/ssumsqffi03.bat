:: 07-sumfields-ssumsqffi03

set exedir=..\bin
set filedir=..\files
set takedir=..\takefile_win

set sqfi03=%filedir%\sqfi03
%exedir%\iosqfi03
set sqfi03=

call execsort %takedir%\sort\07-sumfields\ssumsqffi03_take.prm  ssumsqffi03
set rtc=%errorlevel%
set sqfi03c=%filedir%\sqfi03_07.srt
%exedir%\iosqfi03c
call checkerr2
set rtc=%errorlevel%
set sqfi03c= 