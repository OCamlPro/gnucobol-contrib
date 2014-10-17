# set directories to match your installation
cgibin="/srv/www/cgi-bin"
htdocs="/srv/www/htdocs"

# test if directories exist
if test ! -d "$cgibin"; then
   echo "Please set cgibin correct, currently set to $cgibin"
   exit 1
fi
if test ! -d "$htdocs"; then
   echo "Please set htdocs correct, currently set to $htdocs"
   exit 1
fi

# delete old files (ignoring errors)
rm -f "$cgibin/cgiupload"    2>/dev/null
rm -f "$htdocs/upload1.html" 2>/dev/null
rm -f "$htdocs/upload2.html" 2>/dev/null
rm -f "$htdocs/upload3.html" 2>/dev/null
rm -f "$htdocs/upload4.html" 2>/dev/null
rm -f "$htdocs/upload5.html" 2>/dev/null
rm -f "$htdocs/upload6.html" 2>/dev/null
rm -f "$htdocs/upload7.html" 2>/dev/null
rm -f "cgiupload.exe"        2>/dev/null

# compile
cobc -x -free cgiupload.cob

# copy new files in apache directory
cp cgiupload.exe $cgibin/cgiupload
cp upload1.html $htdocs/upload1.html
cp upload2.html $htdocs/upload2.html
cp upload3.html $htdocs/upload3.html
cp upload4.html $htdocs/upload4.html
cp upload5.html $htdocs/upload5.html
cp upload6.html $htdocs/upload6.html
cp upload7.html $htdocs/upload7.html
