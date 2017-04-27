@echo off
echo GnuCOBOL TEST SUITE
echo ------------------------------------------------------

for /F %%i IN ('pwd') do set testpath=%%i

java -cp wintest.jar org.fsf.gnucobol.TESTSUITE testsuite.at

set testpath=
pause
