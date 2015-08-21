cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	cgiform.exe

# compile
cgiform.exe:	cgiform.cob
	cobc -x -free cgiform.cob -o cgiform.exe
	cp cgiform.exe $(cgibin)/cgiform
	cp cgiform.html $(htdocs)/cgiform.html
	
clean:
	rm cgiform.exe
	rm $(cgibin)/cgiform
	rm $(htdocs)/cgiform.html
    