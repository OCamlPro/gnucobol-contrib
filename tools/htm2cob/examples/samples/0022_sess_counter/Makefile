htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0022_sess_counter

# compile
0022_sess_counter:	0022_sess_counter.cob 0022_sess_counter_param.cpy
	cobc -x -free 0022_sess_counter.cob -o 0022_sess_counter
	cp 0022_sess_counter $(cgibin)/0022_sess_counter
	cp 0022_sess_counter_test.html $(htdocs)/0022_sess_counter_test.html
	
# convert
0022_sess_counter.cob:	0022_sess_counter_cob.html
	$(htm2cob) 0022_sess_counter_cob.html -v
	
clean:
	rm -f 0022_sess_counter.cob
	rm -f 0022_sess_counter
	rm -f $(cgibin)/0022_sess_counter
	rm -f $(htdocs)/0022_sess_counter_test.html
    