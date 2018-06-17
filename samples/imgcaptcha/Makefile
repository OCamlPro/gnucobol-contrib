all:	imgcaptcha-test

imgcaptcha-test:	imgcaptcha-test.cob imgcaptcha.c
	cobc -x -free -W imgcaptcha-test.cob imgcaptcha.c -lgd -lpng -lz -ljpeg -lfreetype -lm

clean:
	rm -f imgcaptcha-test
	rm -f captcha*.png
