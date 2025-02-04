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
	Here are the directories I had to use for the source, data, programs .... I had to make an new 
	virtual host called mkat, so that is why some directory paths have mkat in there. That will be 
	explained after listing the directories. I created a zz directory to keep things separated: 

		/var/www/mkat/zz/
			this is where the HTML pages go
			cust01.index.html
			cust02.index.html 
		
		/usr/lib/cgi-bin/zz$ 
			this is where the cgi bash script goes and the index.dat data file goes
			cust01.cgi
			testfile1001.dat 
			
		/var/log/apache2 
			this is where apache places the access logs and the error logs (you can find your cobol
			 syserr files here)
			 access.log
			 error.log 
			 
		/var/www 
			this is where the GnuCOBOL program binary goes
			cust01 
			
	You will have to have most permissions on the files set to Read and Execute and the data file
	read and write.
	
	Apache2 system file changes: 
		All of the apache2 files/directories are in: 
		/etc 
			hosts
			127.0.0.1 localhost
			127.0.1.1 mickeyw-Meerkat
			127.0.1.2 mkat		
				the host file is where I added my MeerKat (my Ubuntu box) and mkat 
                                which is where the server looks for html (I think)

		/etc/apache2 
			/etc/apache2/mods-available/
				here is where you enable and add cgi and pl and sh (I added .bin)  
                                under AddHandler in the mime.conf file
				      mime.conf 
						AddHandler cgi-script .cgi .pl .sh .bin

			/etc/apache2/conf-available
				serve-cgi-bin.conf 	
					here I granted and enabled cgi scripts
				    <IfDefine ENABLE_USR_LIB_CGI_BIN>
			                ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
							<Directory "/usr/lib/cgi-bin">
								AllowOverride None
								Options +ExecCGI +Includes -MultiViews +SymLinksIfOwnerMatch
								Require all granted
								SetHandler cgi-script
							</Directory>
					</IfDefine>

			/etc/apache2/sites-available 
				this is where I tell it about mkat 
					        ServerAdmin webmaster@localhost
							DocumentRoot /var/www/html 
				I copied 000-default.conf to mkat.conf and made changes: 
					        ServerAdmin webmaster@localhost
							DocumentRoot /var/www/mkat
							ServerName mkat.example.com

		You have to make changes to apache2 files as Root. so sudo carefully (make copies first)? 
		You also have to restart apache2 after changing the above. The documents I found on google 
		gave me excellent instructions for all the above and more.
		I think that is about all Apache2 changes, but I googled and followed examples from 
			"Install and Configure Apache" and apache.org - documentation how to cgi.htm 
			Apache Tutorial: Dynamic Content with CGI 
			
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

 
	
	
					
							
				

			

			
			
			

					
		

	
		
	
		
