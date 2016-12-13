##:: @echo off
##:: generate file for testsuite

export sqbi01=../files/sqbi01
export sqbi03=../files/sqbi03
export sqfi01=../files/sqfi01
export sqfi03=../files/sqfi03
export sqfl01=../files/sqfl01
export sqpd01=../files/sqpd01
export sqpd03=../files/sqpd03
export sqzd01=../files/sqzd01
export sqzd03=../files/sqzd03
export sqvar1=../files/sqvar1
export ixpa=../ixpa01

../bin/iosqbi01
../bin/iosqbi03
../bin/iosqfi01
../bin/iosqfi03
../bin/iosqfl01
../bin/iosqpd01
../bin/iosqpd03
../bin/iosqzd01
../bin/iosqzd03
../bin/iosqvar1
../bin/ioixpa

export sqbi01=
export sqbi03=
export sqfi01=
export sqfi03=
export sqfl01=
export sqpd01=
export sqpd03=
export sqzd01=
export sqzd03=
export sqvar1=
export ixpa01=