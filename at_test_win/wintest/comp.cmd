rmdir /s/q classes
del /q ..\wintest.jar
mkdir classes
cd src
dir /b/s *.java > list

set CP=.

javac -encoding UTF-8 -O -d ..\classes -cp %CP% @list > ..\compile.out 2>&1
del list
cd ..\classes
jar cf ..\..\wintest.jar *
cd ..
pause
