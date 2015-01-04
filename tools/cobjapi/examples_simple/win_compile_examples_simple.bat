:: set directories to match your installation
set examples_simple_dir="C:\oc_projekt\cobjapi\examples_simple"
set src_c_dir="C:\oc_projekt\cobjapi\src_c"
set src_cobol_dir="C:\oc_projekt\cobjapi\src_cobol"

:: test if directories exist
if not exist "%examples_simple_dir%\" (
   echo Please set examples_simple_dir correct, currently set to %examples_simple_dir%
   goto :eof
)
if not exist "%src_c_dir%\" (
   echo Please set src_c_dir correct, currently set to %src_c_dir%
   goto :eof
)
if not exist "%src_cobol_dir%\" (
   echo Please set src_cobol_dir correct, currently set to %src_cobol_dir%
   goto :eof
)

:: delete old files (ignoring errors)
del "%examples_simple_dir%\*.obj"    2>NUL
del "%examples_simple_dir%\*.lib"    2>NUL
del "%examples_simple_dir%\*.exp"    2>NUL
del "%examples_simple_dir%\*.exe"    2>NUL

:: set env. variables
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"

:: set compiler parameters
SET COBCOBJ=cobjapi.obj fileselect.obj imageio.obj japilib.obj
SET COBCLIB=-lWS2_32.Lib

:: change directory
cd %examples_simple_dir%

:: compile the C programs
cobc -c -v %src_c_dir%\fileselect.c
cobc -c -v %src_c_dir%\imageio.c
cobc -c -v %src_c_dir%\japilib.c

:: compile the cobjapi interface
cobc -c -free -v %src_cobol_dir%\cobjapi.cob

:: compile the simple examples
cobc -x -free -v alert.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v borderlayout.cob       %COBCOBJ% %COBCLIB%
cobc -x -free -v borderpanel.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v button.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v canvas.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v checkbox.cob           %COBCOBJ% %COBCLIB%
cobc -x -free -v choice.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v colors.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v colors1.cob            %COBCOBJ% %COBCLIB%
cobc -x -free -v componentlistener.cob  %COBCOBJ% %COBCLIB%
cobc -x -free -v cursor.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v daemon.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v dialog.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v dialogmodal.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v filedialog.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v flowlayout.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v flowsimple.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v focuslistener.cob      %COBCOBJ% %COBCLIB%
cobc -x -free -v font.cob               %COBCOBJ% %COBCLIB%
cobc -x -free -v frame.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v graphic.cob            %COBCOBJ% %COBCLIB%
cobc -x -free -v graphicbutton.cob      %COBCOBJ% %COBCLIB%
cobc -x -free -v graphiclabel.cob       %COBCOBJ% %COBCLIB%
cobc -x -free -v gridlayout.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v image.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v insets.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v keylistener.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v label.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v lines.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v list.cob               %COBCOBJ% %COBCLIB%
cobc -x -free -v listmultiple.cob       %COBCOBJ% %COBCLIB%
cobc -x -free -v menu.cob               %COBCOBJ% %COBCLIB%
cobc -x -free -v mousebuttons.cob       %COBCOBJ% %COBCLIB%
cobc -x -free -v mouselistener.cob      %COBCOBJ% %COBCLIB%
cobc -x -free -v panel.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v popupmenu.cob          %COBCOBJ% %COBCLIB%
cobc -x -free -v print.cob              %COBCOBJ% %COBCLIB%
cobc -x -free -v radiobutton.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v rubberband.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v scaledimage.cob        %COBCOBJ% %COBCLIB%
cobc -x -free -v scrollbar.cob          %COBCOBJ% %COBCLIB%
cobc -x -free -v scrollpane.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v simple.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v simplemenu.cob         %COBCOBJ% %COBCLIB%
cobc -x -free -v textfield.cob          %COBCOBJ% %COBCLIB%
cobc -x -free -v vumeter.cob            %COBCOBJ% %COBCLIB%
cobc -x -free -v window.cob             %COBCOBJ% %COBCLIB%
cobc -x -free -v windowlistener.cob     %COBCOBJ% %COBCLIB%

:eof

pause
