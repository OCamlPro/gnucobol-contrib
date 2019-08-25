htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0036_ajax_hello_1 0036_ajax_hello_2

# compile
0036_ajax_hello_1:	0036_ajax_hello_1.cob 0036_ajax_hello_1_param.cpy
	cobc -x -free 0036_ajax_hello_1.cob -o 0036_ajax_hello_1
	cp 0036_ajax_hello_1 $(cgibin)/0036_ajax_hello_1
	cp 0036_ajax_hello_test.html $(htdocs)/0036_ajax_hello_test.html

0036_ajax_hello_2:	0036_ajax_hello_2.cob 0036_ajax_hello_2_param.cpy
	cobc -x -free 0036_ajax_hello_2.cob -o 0036_ajax_hello_2
	cp 0036_ajax_hello_2 $(cgibin)/0036_ajax_hello_2
	
# convert
0036_ajax_hello_1.cob:	0036_ajax_hello_1_cob.html
	$(htm2cob) 0036_ajax_hello_1_cob.html -v
	
0036_ajax_hello_2.cob:	0036_ajax_hello_2_cob.html
	$(htm2cob) 0036_ajax_hello_2_cob.html -v -m
	
clean:
	rm -f 0036_ajax_hello_1.cob
	rm -f 0036_ajax_hello_1
	rm -f $(cgibin)/0036_ajax_hello_1
	rm -f 0036_ajax_hello_2.cob
	rm -f 0036_ajax_hello_2
	rm -f $(cgibin)/0036_ajax_hello_2
	rm -f $(htdocs)/0036_ajax_hello_test.html
    