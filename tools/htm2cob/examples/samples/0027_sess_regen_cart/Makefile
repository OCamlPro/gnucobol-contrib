htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0027_sess_regen_cart_1 0027_sess_regen_cart_2 0027_sess_regen_cart_3 0027_sess_regen_cart_4

# compile
0027_sess_regen_cart_1:	0027_sess_regen_cart_1.cob 0027_sess_regen_cart_1_param.cpy 
	cobc -x -free 0027_sess_regen_cart_1.cob -o 0027_sess_regen_cart_1
	cp 0027_sess_regen_cart_1 $(cgibin)/0027_sess_regen_cart_1
	cp 0027_sess_regen_cart_test.html $(htdocs)/0027_sess_regen_cart_test.html
	cp js/0027_sess_cart.js $(htdocs)/js/0027_sess_cart.js

0027_sess_regen_cart_2:	0027_sess_regen_cart_2.cob 0027_sess_regen_cart_2_param.cpy
	cobc -x -free 0027_sess_regen_cart_2.cob -o 0027_sess_regen_cart_2
	cp 0027_sess_regen_cart_2 $(cgibin)/0027_sess_regen_cart_2

0027_sess_regen_cart_3:	0027_sess_regen_cart_3.cob 0027_sess_regen_cart_3_param.cpy
	cobc -x -free 0027_sess_regen_cart_3.cob -o 0027_sess_regen_cart_3
	cp 0027_sess_regen_cart_3 $(cgibin)/0027_sess_regen_cart_3

0027_sess_regen_cart_4:	0027_sess_regen_cart_4.cob 0027_sess_regen_cart_4_param.cpy
	cobc -x -free 0027_sess_regen_cart_4.cob -o 0027_sess_regen_cart_4
	cp 0027_sess_regen_cart_4 $(cgibin)/0027_sess_regen_cart_4
    
# convert
0027_sess_regen_cart_1.cob:	0027_sess_regen_cart_1_cob.html
	$(htm2cob) 0027_sess_regen_cart_1_cob.html -v

0027_sess_regen_cart_2.cob:	0027_sess_regen_cart_2_cob.html
	$(htm2cob) 0027_sess_regen_cart_2_cob.html -v

0027_sess_regen_cart_3.cob:	0027_sess_regen_cart_3_cob.html
	$(htm2cob) 0027_sess_regen_cart_3_cob.html -v

0027_sess_regen_cart_4.cob:	0027_sess_regen_cart_4_cob.html
	$(htm2cob) 0027_sess_regen_cart_4_cob.html -v
    
clean:
	rm -f 0027_sess_regen_cart_1.cob
	rm -f 0027_sess_regen_cart_1
	rm -f $(cgibin)/0027_sess_regen_cart_1
	rm -f 0027_sess_regen_cart_2.cob
	rm -f 0027_sess_regen_cart_2
	rm -f $(cgibin)/0027_sess_regen_cart_2
	rm -f 0027_sess_regen_cart_3.cob
	rm -f 0027_sess_regen_cart_3
	rm -f $(cgibin)/0027_sess_regen_cart_3
	rm -f 0027_sess_regen_cart_4.cob
	rm -f 0027_sess_regen_cart_4
	rm -f $(cgibin)/0027_sess_regen_cart_4
	rm -f $(htdocs)/0027_sess_regen_cart_test.html
	rm -f $(htdocs)/js/0027_sess_cart.js
    