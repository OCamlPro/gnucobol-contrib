htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0024_sess_captcha_1 0024_sess_captcha_2

# compile
0024_sess_captcha_1:	0024_sess_captcha_1.cob 0024_sess_captcha_1_param.cpy imgcaptcha.c
	cobc -x -free 0024_sess_captcha_1.cob -o 0024_sess_captcha_1 imgcaptcha.c -lgd -lpng -lz -ljpeg -lfreetype -lm
	cp 0024_sess_captcha_1 $(cgibin)/0024_sess_captcha_1
	cp 0024_sess_captcha_test.html $(htdocs)/0024_sess_captcha_test.html

0024_sess_captcha_2:	0024_sess_captcha_2.cob 0024_sess_captcha_2_param.cpy
	cobc -x -free 0024_sess_captcha_2.cob -o 0024_sess_captcha_2
	cp 0024_sess_captcha_2 $(cgibin)/0024_sess_captcha_2

# convert
0024_sess_captcha_1.cob:	0024_sess_captcha_1_cob.html
	$(htm2cob) 0024_sess_captcha_1_cob.html -v

0024_sess_captcha_2.cob:	0024_sess_captcha_2_cob.html
	$(htm2cob) 0024_sess_captcha_2_cob.html -v

clean:
	rm -f 0024_sess_captcha_1.cob
	rm -f 0024_sess_captcha_1
	rm -f $(cgibin)/0024_sess_captcha_1
	rm -f 0024_sess_captcha_2.cob
	rm -f 0024_sess_captcha_2
	rm -f $(cgibin)/0024_sess_captcha_2
	rm -f $(htdocs)/0024_sess_captcha_test.html
	rm -f $(htdocs)/img/0024_captcha_*.png
    