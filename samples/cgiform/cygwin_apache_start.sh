# Before you start Apache, you have to install cygserver 
# as a Windows Service. Check this file: /bin/cygserver-config.
#
# Important File Locations
# - httpd.conf:
# c:/cygwin/etc/apache2/httpd.conf
#
# - HTML files:
# c:/cygwin/srv/www/htdocs/index.html
# 
# Verifying that Apache is running
# In a browser try the following URL.
# http://localhost
# You should be happy to see a page that says "It Works"
# 
# Issues:
# - Installed as Service but doesn't start.
# 
#   Check that you installed Cygwin for All Users. 
#   Just run Cygwin's setup program again and click "All Users" 
#   and you should be all set. 

# Running Apache2
/usr/sbin/apachectl2 start
