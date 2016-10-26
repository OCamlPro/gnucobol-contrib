set rtc=%errorlevel%
if %rtc% == 25    echo %1 .... (FAILED)
if %rtc% == 25    echo %1 .... (FAILED)  >>..\log\test_failed.log
if %rtc% == 0     echo %1 .... (OK)