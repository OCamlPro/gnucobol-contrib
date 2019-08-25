htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0017_more_button

# compile
0017_more_button:	0017_more_button.cob 0017_more_button_param.cpy
	cobc -x -free 0017_more_button.cob -o 0017_more_button
	cp 0017_more_button $(cgibin)/0017_more_button
	cp 0017_more_button_test.html $(htdocs)/0017_more_button_test.html
	cp js/0017_more_button.js $(htdocs)/js/0017_more_button.js
	
# convert
0017_more_button.cob:	0017_more_button_cob.html
	$(htm2cob) 0017_more_button_cob.html -v
	
clean:
	rm -f 0017_more_button.cob
	rm -f 0017_more_button
	rm -f $(cgibin)/0017_more_button
	rm -f $(htdocs)/0017_more_button_test.html
	rm -f $(htdocs)/js/0017_more_button.js
    