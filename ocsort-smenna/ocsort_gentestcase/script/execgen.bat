
:: Generator for
::     File output
::     Program Cobol for check data generated
::     File Take params or OCSort
::     Program Cobol for check data sorted by OCSort
::     script for Windows/Linux execution
::
if "%1" == ""  goto lberr
..\bin\ocsort_gentestcase %1
goto lbend
:lberr
Echo  parameter config file not specified
:lbend
