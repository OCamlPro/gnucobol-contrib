:: set directories to match your installation
set src_java_dir="C:\oc_projekt\cobjapi\src_java"

:: test if directories exist
if not exist "%src_java_dir%\" (
   echo Please set src_java_dir correct, currently set to %src_java_dir%
   goto :eof
)

:: delete old files (ignoring errors)
del "%src_java_dir%\*.class"    2>NUL
del "%src_java_dir%\*.jar"      2>NUL

:: change directory
cd %src_java_dir%

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


:eof

pause
