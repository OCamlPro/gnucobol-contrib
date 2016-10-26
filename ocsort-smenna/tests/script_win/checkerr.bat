if %rtc1% neq 0  echo error sort ....... (ko)  %rtc1%  ERROR
if %rtc2% neq 0  echo error diff file .. (ko)  %rtc2%  ERROR
if %rtc1% equ 0  echo       sort ....... (ok)  %rtc1%
if %rtc2% equ 0  echo       diff file .. (ok)  %rtc2%

if %rtc1% neq 0 echo error >>..\log\ferr.log
if %rtc2% neq 0 echo error >>..\log\ferr.log

