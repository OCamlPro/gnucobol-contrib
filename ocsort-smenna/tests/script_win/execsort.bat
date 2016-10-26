:: exec sort
::@echo off
set RTC=0
call ..\bin\ocsort TAKE %1  1>..\log\%2.log 2>..\log\%2.err
set RTC=%ERRORLEVEL%
if %RTC% == 16    echo %1 .... (FAILED)
if %RTC% == 16    echo %1 .... (FAILED)  >>..\log\test_failed.log
if %RTC% == 0     echo %1 .... (OK)
:: set RTC=0