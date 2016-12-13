:: @echo off
:: generate file for testsuite

SET sqbi01=..\files\sqbi01
SET sqbi03=..\files\sqbi03
SET sqfi01=..\files\sqfi01
SET sqfi03=..\files\sqfi03
SET sqfl01=..\files\sqfl01
SET sqpd01=..\files\sqpd01
SET sqpd03=..\files\sqpd03
SET sqzd01=..\files\sqzd01
SET sqzd03=..\files\sqzd03
SET sqvar1=..\files\sqvar1
SET ixpa=..\ixpa01

call ..\bin\iosqbi01
call ..\bin\iosqbi03
call ..\bin\iosqfi01
call ..\bin\iosqfi03
call ..\bin\iosqfl01
call ..\bin\iosqpd01
call ..\bin\iosqpd03
call ..\bin\iosqzd01
call ..\bin\iosqzd03
call ..\bin\iosqvar1
call ..\bin\ioixpa

SET sqbi01=
SET sqbi03=
SET sqfi01=
SET sqfi03=
SET sqfl01=
SET sqpd01=
SET sqpd03=
SET sqzd01=
SET sqzd03=
SET sqvar1=
SET ixpa01=