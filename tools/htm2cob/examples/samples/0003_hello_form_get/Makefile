htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0003_hello_form_get

# compile
0003_hello_form_get:	0003_hello_form_get.cob 0003_hello_form_get_param.cpy
	cobc -x -free 0003_hello_form_get.cob -o 0003_hello_form_get
	cp 0003_hello_form_get $(cgibin)/0003_hello_form_get
	cp 0003_hello_form_get_test.html $(htdocs)/0003_hello_form_get_test.html
	
# convert
0003_hello_form_get.cob:	0003_hello_form_get_cob.html
	$(htm2cob) 0003_hello_form_get_cob.html -v
	
clean:
	rm -f 0003_hello_form_get.cob
	rm -f 0003_hello_form_get
	rm -f $(cgibin)/0003_hello_form_get
	rm -f $(htdocs)/0003_hello_form_get_test.html
    