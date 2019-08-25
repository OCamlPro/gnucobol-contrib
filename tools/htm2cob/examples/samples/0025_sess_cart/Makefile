htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0025_sess_cart_1 0025_sess_cart_2 0025_sess_cart_3 0025_sess_cart_4

# compile
0025_sess_cart_1:	0025_sess_cart_1.cob 0025_sess_cart_1_param.cpy 
	cobc -x -free 0025_sess_cart_1.cob -o 0025_sess_cart_1
	cp 0025_sess_cart_1 $(cgibin)/0025_sess_cart_1
	cp 0025_sess_cart_test.html $(htdocs)/0025_sess_cart_test.html
	cp js/0025_sess_cart.js $(htdocs)/js/0025_sess_cart.js

0025_sess_cart_2:	0025_sess_cart_2.cob 0025_sess_cart_2_param.cpy
	cobc -x -free 0025_sess_cart_2.cob -o 0025_sess_cart_2
	cp 0025_sess_cart_2 $(cgibin)/0025_sess_cart_2

0025_sess_cart_3:	0025_sess_cart_3.cob 0025_sess_cart_3_param.cpy
	cobc -x -free 0025_sess_cart_3.cob -o 0025_sess_cart_3
	cp 0025_sess_cart_3 $(cgibin)/0025_sess_cart_3

0025_sess_cart_4:	0025_sess_cart_4.cob 0025_sess_cart_4_param.cpy
	cobc -x -free 0025_sess_cart_4.cob -o 0025_sess_cart_4
	cp 0025_sess_cart_4 $(cgibin)/0025_sess_cart_4
    
# convert
0025_sess_cart_1.cob:	0025_sess_cart_1_cob.html
	$(htm2cob) 0025_sess_cart_1_cob.html -v

0025_sess_cart_2.cob:	0025_sess_cart_2_cob.html
	$(htm2cob) 0025_sess_cart_2_cob.html -v

0025_sess_cart_3.cob:	0025_sess_cart_3_cob.html
	$(htm2cob) 0025_sess_cart_3_cob.html -v

0025_sess_cart_4.cob:	0025_sess_cart_4_cob.html
	$(htm2cob) 0025_sess_cart_4_cob.html -v
    
clean:
	rm -f 0025_sess_cart_1.cob
	rm -f 0025_sess_cart_1
	rm -f $(cgibin)/0025_sess_cart_1
	rm -f 0025_sess_cart_2.cob
	rm -f 0025_sess_cart_2
	rm -f $(cgibin)/0025_sess_cart_2
	rm -f 0025_sess_cart_3.cob
	rm -f 0025_sess_cart_3
	rm -f $(cgibin)/0025_sess_cart_3
	rm -f 0025_sess_cart_4.cob
	rm -f 0025_sess_cart_4
	rm -f $(cgibin)/0025_sess_cart_4
	rm -f $(htdocs)/0025_sess_cart_test.html
	rm -f $(htdocs)/js/0025_sess_cart.js
    