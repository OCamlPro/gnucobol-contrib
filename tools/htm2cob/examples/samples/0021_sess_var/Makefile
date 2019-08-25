htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0021_sess_var

# compile
0021_sess_var:	0021_sess_var.cob 0021_sess_var_param.cpy
	cobc -x -free 0021_sess_var.cob -o 0021_sess_var
	cp 0021_sess_var $(cgibin)/0021_sess_var
	cp 0021_sess_var_test.html $(htdocs)/0021_sess_var_test.html
	
# convert
0021_sess_var.cob:	0021_sess_var_cob.html
	$(htm2cob) 0021_sess_var_cob.html -v
	
clean:
	rm -f 0021_sess_var.cob
	rm -f 0021_sess_var
	rm -f $(cgibin)/0021_sess_var
	rm -f $(htdocs)/0021_sess_var_test.html
    