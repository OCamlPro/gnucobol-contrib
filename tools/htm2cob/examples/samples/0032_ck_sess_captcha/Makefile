htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0032_ck_sess_captcha_1 0032_ck_sess_captcha_2 0032_ck_sess_captcha_3

# compile
0032_ck_sess_captcha_1:	0032_ck_sess_captcha_1.cob 0032_ck_sess_captcha_1_param.cpy
	cobc -x -free 0032_ck_sess_captcha_1.cob -o 0032_ck_sess_captcha_1
	cp 0032_ck_sess_captcha_1 $(cgibin)/0032_ck_sess_captcha_1
	cp 0032_ck_sess_captcha_test.html $(htdocs)/0032_ck_sess_captcha_test.html

0032_ck_sess_captcha_2:	0032_ck_sess_captcha_2.cob 0032_ck_sess_captcha_2_param.cpy imgcaptcha.c
	cobc -x -free 0032_ck_sess_captcha_2.cob -o 0032_ck_sess_captcha_2 imgcaptcha.c -lgd -lpng -lz -ljpeg -lfreetype -lm
	cp 0032_ck_sess_captcha_2 $(cgibin)/0032_ck_sess_captcha_2

0032_ck_sess_captcha_3:	0032_ck_sess_captcha_3.cob 0032_ck_sess_captcha_3_param.cpy
	cobc -x -free 0032_ck_sess_captcha_3.cob -o 0032_ck_sess_captcha_3
	cp 0032_ck_sess_captcha_3 $(cgibin)/0032_ck_sess_captcha_3

# convert
0032_ck_sess_captcha_1.cob:	0032_ck_sess_captcha_1_cob.html
	$(htm2cob) 0032_ck_sess_captcha_1_cob.html -v

0032_ck_sess_captcha_2.cob:	0032_ck_sess_captcha_2_cob.html
	$(htm2cob) 0032_ck_sess_captcha_2_cob.html -v

0032_ck_sess_captcha_3.cob:	0032_ck_sess_captcha_3_cob.html
	$(htm2cob) 0032_ck_sess_captcha_3_cob.html -v

clean:
	rm -f 0032_ck_sess_captcha_1.cob
	rm -f 0032_ck_sess_captcha_1
	rm -f $(cgibin)/0032_ck_sess_captcha_1
	rm -f 0032_ck_sess_captcha_2.cob
	rm -f 0032_ck_sess_captcha_2
	rm -f $(cgibin)/0032_ck_sess_captcha_2
	rm -f 0032_ck_sess_captcha_3.cob
	rm -f 0032_ck_sess_captcha_3
	rm -f $(cgibin)/0032_ck_sess_captcha_3
	rm -f $(htdocs)/0032_ck_sess_captcha_test.html
	rm -f $(htdocs)/img/0032_captcha_*.png
    