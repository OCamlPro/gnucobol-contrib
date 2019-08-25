htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0007_variables

# compile
0007_variables:	0007_variables.cob 0007_variables_param.cpy
	cobc -x -free 0007_variables.cob -o 0007_variables
	cp 0007_variables $(cgibin)/0007_variables
	cp 0007_variables_test.html $(htdocs)/0007_variables_test.html
	
# convert
0007_variables.cob:	0007_variables_cob.html
	$(htm2cob) 0007_variables_cob.html -v
	
clean:
	rm -f 0007_variables.cob
	rm -f 0007_variables
	rm -f $(cgibin)/0007_variables
	rm -f $(htdocs)/0007_variables_test.html
    