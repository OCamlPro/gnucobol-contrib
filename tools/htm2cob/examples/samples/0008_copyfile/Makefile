htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0008_copyfile

# compile
0008_copyfile:	0008_copyfile.cob 0008_copyfile_param.cpy
	cobc -x -free 0008_copyfile.cob -o 0008_copyfile
	cp 0008_copyfile $(cgibin)/0008_copyfile
	cp 0008_copyfile_test.html $(htdocs)/0008_copyfile_test.html
	
# convert
0008_copyfile.cob:	0008_copyfile_cob.html
	$(htm2cob) 0008_copyfile_cob.html -v
	
clean:
	rm -f 0008_copyfile.cob
	rm -f 0008_copyfile
	rm -f $(cgibin)/0008_copyfile
	rm -f $(htdocs)/0008_copyfile_test.html
    