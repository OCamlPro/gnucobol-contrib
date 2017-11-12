:: Batch for running the java test runner
@echo off
setlocal

:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)
:: check for java executable
where /q java
if errorlevel 1 (
   echo ERROR: java is missing in PATH
   goto :end
)

:: check for wintest.jar
set cmd_path=%~dp0

if not exist "%cmd_path%wintest.jar" (
  echo wintest.jar not available yet, start compilation
  call "%cmd_path%wintest\comp.cmd"
  if errorlevel 1 goto :end
)

echo GnuCOBOL TEST SUITE
echo ------------------------------------------------------


set "UNIFY_LISTING=%cmd_path%listings-sed-c.cmd"
set COB_OBJECT_EXT=obj
set COB_EXE_EXT=.exe
set LC_MESSAGES=C

java -cp "%cmd_path%wintest.jar" org.fsf.gnucobol.TESTSUITE testsuite.at



:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal
