htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0011_form_elements

# compile
0011_form_elements:	0011_form_elements.cob 0011_form_elements_param.cpy
	cobc -x -free 0011_form_elements.cob -o 0011_form_elements
	cp 0011_form_elements $(cgibin)/0011_form_elements
	cp 0011_form_elements_test.html $(htdocs)/0011_form_elements_test.html
	
# convert
0011_form_elements.cob:	0011_form_elements_cob.html
	$(htm2cob) 0011_form_elements_cob.html -v
	
clean:
	rm -f 0011_form_elements.cob
	rm -f 0011_form_elements
	rm -f $(cgibin)/0011_form_elements
	rm -f $(htdocs)/0011_form_elements_test.html
    