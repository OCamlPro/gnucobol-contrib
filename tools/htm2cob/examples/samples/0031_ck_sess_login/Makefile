htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0031_ck_sess_login_1 0031_ck_sess_login_2 0031_ck_sess_login_3 0031_ck_sess_login_4

# compile
0031_ck_sess_login_1:	0031_ck_sess_login_1.cob 0031_ck_sess_login_1_param.cpy
	cobc -x -free 0031_ck_sess_login_1.cob -o 0031_ck_sess_login_1
	cp 0031_ck_sess_login_1 $(cgibin)/0031_ck_sess_login_1
	cp 0031_ck_sess_login_test.html $(htdocs)/0031_ck_sess_login_test.html

0031_ck_sess_login_2:	0031_ck_sess_login_2.cob 0031_ck_sess_login_2_param.cpy
	cobc -x -free 0031_ck_sess_login_2.cob -o 0031_ck_sess_login_2
	cp 0031_ck_sess_login_2 $(cgibin)/0031_ck_sess_login_2

0031_ck_sess_login_3:	0031_ck_sess_login_3.cob 0031_ck_sess_login_3_param.cpy
	cobc -x -free 0031_ck_sess_login_3.cob -o 0031_ck_sess_login_3
	cp 0031_ck_sess_login_3 $(cgibin)/0031_ck_sess_login_3
	
0031_ck_sess_login_4:	0031_ck_sess_login_4.cob 0031_ck_sess_login_4_param.cpy
	cobc -x -free 0031_ck_sess_login_4.cob -o 0031_ck_sess_login_4
	cp 0031_ck_sess_login_4 $(cgibin)/0031_ck_sess_login_4
	
# convert
0031_ck_sess_login_1.cob:	0031_ck_sess_login_1_cob.html
	$(htm2cob) 0031_ck_sess_login_1_cob.html -v

0031_ck_sess_login_2.cob:	0031_ck_sess_login_2_cob.html
	$(htm2cob) 0031_ck_sess_login_2_cob.html -v

0031_ck_sess_login_3.cob:	0031_ck_sess_login_3_cob.html
	$(htm2cob) 0031_ck_sess_login_3_cob.html -v
	
0031_ck_sess_login_4.cob:	0031_ck_sess_login_4_cob.html
	$(htm2cob) 0031_ck_sess_login_4_cob.html -v
	
clean:
	rm -f 0031_ck_sess_login_1.cob
	rm -f 0031_ck_sess_login_1
	rm -f $(cgibin)/0031_ck_sess_login_1
	rm -f 0031_ck_sess_login_2.cob
	rm -f 0031_ck_sess_login_2
	rm -f $(cgibin)/0031_ck_sess_login_2
	rm -f 0031_ck_sess_login_3.cob
	rm -f 0031_ck_sess_login_3
	rm -f $(cgibin)/0031_ck_sess_login_3
	rm -f 0031_ck_sess_login_4.cob
	rm -f 0031_ck_sess_login_4
	rm -f $(cgibin)/0031_ck_sess_login_4
	rm -f $(htdocs)/0031_ck_sess_login_test.html
    