@echo off
setlocal

:: set directories to match your installation (only necessary for systems older than WinXP...)
set src_java_dir=%~dp0


:: check if started directly
echo %cmdcmdline% | find /i "%~0" >nul
if errorlevel 1 (
   set interactive=1
) else (
   set interactive=0
)

:: check for javac and jar executable
where /q javac.exe
if errorlevel 1 (
   echo ERROR: javac.exe is missing in PATH
   goto :end
)
where /q jar.exe
if errorlevel 1 (
   echo ERROR: jar.exe is missing in PATH
   goto :end
)

:: test if directories exist
if not exist "%src_java_dir%\" (
   echo ERROR: Please set src_java_dircorrect, currently set to %src_java_dir%
   goto :end
)

:: change directory
pushd "%src_java_dir%"

:: delete old files (ignoring errors)
del *.class    2>NUL
del *.jar      2>NUL


:: create class files
:: Generate all debugging information, including local variables. 
:: By default, only line number and source file information is generated. 
:: javac -g *.java
::
:: Some input files use or override a deprecated API.
:: Recompile with -Xlint:deprecation for details.
:: javac -Xlint:deprecation *.java
::
javac *.java

:: create jar 
jar cvfm JAPI.jar JAPI.mf *.class *.gif


:end
if _%interactive%_==_0_ (
   echo.
   pause
)

endlocal
