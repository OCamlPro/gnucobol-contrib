htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0018_link_submit

# compile
0018_link_submit:	0018_link_submit.cob 0018_link_submit_param.cpy
	cobc -x -free 0018_link_submit.cob -o 0018_link_submit
	cp 0018_link_submit $(cgibin)/0018_link_submit
	cp 0018_link_submit_test.html $(htdocs)/0018_link_submit_test.html
	
# convert
0018_link_submit.cob:	0018_link_submit_cob.html
	$(htm2cob) 0018_link_submit_cob.html -v
	
clean:
	rm -f 0018_link_submit.cob
	rm -f 0018_link_submit
	rm -f $(cgibin)/0018_link_submit
	rm -f $(htdocs)/0018_link_submit_test.html
    