HTML-CGI-GnuCOBOL Prototype
There was a comment made on a post about just using HTML and Perl(CGI) and GnuCOBOL for web pages.
At a previous job, we used HTML and Perl and GnuCOBOL to display data on a web page. The Perl script 
was the CGI and it really only just did a chomp to the sysout lines to post on the web page. 
So I thought I would try to do the same and then post the project here if I could remember how 
to do it. I knew I did not want to have to use other software like Rust or JavaScript or JASON or
 AJAX of Fetch or SSI.  I did remember that we used Apache. 
It became a big project for me as I have never been a system administrator and there were lots 
of things for me to have perform just to have my Linux (Ubuntu) box act as an HTTP server. And in 
middle of all this, I (sad to say) allowed my Ubuntu box to update to the new Ubuntu 24.04.1 (not 
a good idea).  Well, I had lots of trouble even getting it to boot up, but finally after about a 
week or more, reinstalled and reset my profiles and moved on.  
The first thing I had to do was install Apache2. And then as I googled about Apache, I saw 
that I would have to edit some of the Apache2 configuration files. I will touch base on these 
changes in this document below and try to explain some of the html, CGI, and Cobol. Note: I 
was using Perl at first but it seemed more complicated than I wanted to do as I was having to 
add several Perl modules.  I googled some help in Bash and decided that was the simplest way
to go. So, the CGI is a Bash script. 

I have not incorporated any security features that I know, or much error handling, or even have the 
HTML fields working as would be in a production environment. It is just a Prototype and it does work.

As mentioned, the project here is Linux and using Apache, I have no idea how to do this on windows, 
but I would think the components (html/cgi/gnucobol) should work more or less the same. I do 
use my windows box to access the server via a web browser.  So, I see all the pages on my windows 11 pc. 
 
HTML → CGI → COBOL → CGI → HTML 
 

Process Flow:
   a. User enters/updates data in HTML form
   b. Form submits to CGI script (POST method)
   c. CGI script:
      - Reads POST data
      - Validates account number
      - Calls COBOL program with parameters
      - Receives COBOL output (pipe-delimited)
      - Updates HTML with results
   d. COBOL program:
      - Processes data based on action
      - Updates indexed file
      - Returns updated data and message 
	 
APACHE2 system changes: 
 I have updated the apache2 changes here. They are much easier than the old changes: 

Here are the steps to configure Apache2 for CGI applications:

1. Enable CGI module:
```bash
sudo a2enmod cgi
```

2. Create directory structure:
```bash
sudo mkdir -p /var/www/mkat/zz
sudo mkdir -p /var/www/cgi-bin/zz
```

3. Place files:
- HTML files: `/var/www/mkat/zz/cust01.index.html` and `/var/www/mkat/zz/cust02.index.html`
- CGI script: `/var/www/cgi-bin/zz/cust01.cgi`
- COBOL binary: `/var/www/cust01`
- Data file:   sudo mv testfile1001.dat /var/www/cgi-bin/zz/


4. Set permissions:
```bash
sudo chmod 755 /var/www/cgi-bin/zz/cust01.cgi
sudo chmod 755 /var/www/cust01
sudo chmod 644 /var/www/mkat/zz/*.html
sudo chown www-data:www-data /var/www/cgi-bin/zz/testfile1001.dat
sudo chmod 660 /var/www/cgi-bin/zz/testfile1001.dat

```

5. Create virtual host configuration in `/etc/apache2/sites-available/mkat.conf`:
```apache
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/mkat
    ServerName 10.0.0.78

    <Directory /var/www/mkat>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ScriptAlias /cgi-bin/ /var/www/cgi-bin/
    <Directory "/var/www/cgi-bin">
        AllowOverride None
        Options +ExecCGI -MultiViews
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/mkat_error.log
    CustomLog ${APACHE_LOG_DIR}/mkat_access.log combined
</VirtualHost>
```

6. Enable site and restart Apache:
```bash
sudo a2ensite mkat.conf
sudo systemctl restart apache2
```

Access your application at: http://10.0.0.78/zz/cust01.index.html

			
End Apache2 info. 

FILES: 
	The data file I have for this project is a 1001 record file that was created as a sequential text file 
	from the large randomized data file from the GnuCOBOL sourceforge SVN contributions section for 
	samples: createTestDataFile 
	But I include the file in this project.
	You have to create an index file from the included test file. The program to do that is testfile1001.txt 
	just run that file through the included program: flat2index1001.cbl 
	Add the newly created index file with write permissions to the above mentioned directory. /usr/lib/cgi-bin/zz/ 
	
This is just a prototype and to be used as a guide if useful at all. 
Licensed under the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your 
option) any later version. 

Date: August 13, 2025: 
Updated cust01.cgi it was calling the wrong program.  Fixed to call cust01


	
	
					
							
				

			

			
			
			

					
		

	
		
	
		
