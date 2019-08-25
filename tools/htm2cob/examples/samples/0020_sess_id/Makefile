htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0020_sess_id

# compile
0020_sess_id:	0020_sess_id.cob 0020_sess_id_param.cpy
	cobc -x -free 0020_sess_id.cob -o 0020_sess_id
	cp 0020_sess_id $(cgibin)/0020_sess_id
	cp 0020_sess_id_test.html $(htdocs)/0020_sess_id_test.html
	
# convert
0020_sess_id.cob:	0020_sess_id_cob.html
	$(htm2cob) 0020_sess_id_cob.html -v
	
clean:
	rm -f 0020_sess_id.cob
	rm -f 0020_sess_id
	rm -f $(cgibin)/0020_sess_id
	rm -f $(htdocs)/0020_sess_id_test.html
    