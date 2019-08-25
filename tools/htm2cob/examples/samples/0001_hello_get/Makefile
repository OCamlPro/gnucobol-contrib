htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0001_hello_get

# compile
0001_hello_get:	0001_hello_get.cob 0001_hello_get_param.cpy
	cobc -x -free 0001_hello_get.cob -o 0001_hello_get
	cp 0001_hello_get $(cgibin)/0001_hello_get
	cp 0001_hello_get_test.html $(htdocs)/0001_hello_get_test.html
	
# convert
0001_hello_get.cob:	0001_hello_get_cob.html
	$(htm2cob) 0001_hello_get_cob.html -v
	
clean:
	rm -f 0001_hello_get.cob
	rm -f 0001_hello_get
	rm -f $(cgibin)/0001_hello_get
	rm -f $(htdocs)/0001_hello_get_test.html
    