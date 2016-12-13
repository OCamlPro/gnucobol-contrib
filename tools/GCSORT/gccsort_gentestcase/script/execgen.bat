
:: Generator for
::     File output
::     Program Cobol for check data generated
::     File Take params or GCSORT
::     Program Cobol for check data sorted by GCSORT
::     script for Windows/Linux execution
::
if "%1" == ""  goto lberr
..\bin\gcsort_gentestcase %1
goto lbend
:lberr
Echo  parameter config file not specified
:lbend
