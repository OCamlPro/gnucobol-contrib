# delete old files
rm /srv/www/cgi-bin/cgiupload
rm /srv/www/htdocs/upload1.html
rm /srv/www/htdocs/upload2.html
rm /srv/www/htdocs/upload3.html
rm /srv/www/htdocs/upload4.html
rm /srv/www/htdocs/upload5.html
rm /srv/www/htdocs/upload6.html
rm /srv/www/htdocs/upload7.html
rm cgiupload.exe

# compile
cobc -x -free cgiupload.cob

# copy new files in apache directory
cp cgiupload.exe /srv/www/cgi-bin/cgiupload
cp upload1.html /srv/www/htdocs/upload1.html
cp upload2.html /srv/www/htdocs/upload2.html
cp upload3.html /srv/www/htdocs/upload3.html
cp upload4.html /srv/www/htdocs/upload4.html
cp upload5.html /srv/www/htdocs/upload5.html
cp upload6.html /srv/www/htdocs/upload6.html
cp upload7.html /srv/www/htdocs/upload7.html
