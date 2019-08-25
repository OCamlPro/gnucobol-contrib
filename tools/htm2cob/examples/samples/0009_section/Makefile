htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0009_section

# compile
0009_section:	0009_section.cob 0009_section_param.cpy
	cobc -x -free 0009_section.cob -o 0009_section
	cp 0009_section $(cgibin)/0009_section
	cp 0009_section_test.html $(htdocs)/0009_section_test.html
	
# convert
0009_section.cob:	0009_section_cob.html
	$(htm2cob) 0009_section_cob.html -v
	
clean:
	rm -f 0009_section.cob
	rm -f 0009_section
	rm -f $(cgibin)/0009_section
	rm -f $(htdocs)/0009_section_test.html
    