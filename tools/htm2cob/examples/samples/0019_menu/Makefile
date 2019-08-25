htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0019_menu_1 0019_menu_2 0019_menu_3 0019_submenu_21 0019_submenu_22 0019_submenu_23

# compile
0019_menu_1:	0019_menu_1.cob 0019_menu_1_param.cpy
	cobc -x -free 0019_menu_1.cob -o 0019_menu_1
	cp 0019_menu_1 $(cgibin)/0019_menu_1
	cp 0019_menu_test.html $(htdocs)/0019_menu_test.html
	cp css/0019_menu.css $(htdocs)/css/0019_menu.css

0019_menu_2:	0019_menu_2.cob 0019_menu_2_param.cpy
	cobc -x -free 0019_menu_2.cob -o 0019_menu_2
	cp 0019_menu_2 $(cgibin)/0019_menu_2

0019_menu_3:	0019_menu_3.cob 0019_menu_3_param.cpy
	cobc -x -free 0019_menu_3.cob -o 0019_menu_3
	cp 0019_menu_3 $(cgibin)/0019_menu_3

0019_submenu_21:	0019_submenu_21.cob 0019_submenu_21_param.cpy
	cobc -x -free 0019_submenu_21.cob -o 0019_submenu_21
	cp 0019_submenu_21 $(cgibin)/0019_submenu_21
	
0019_submenu_22:	0019_submenu_22.cob 0019_submenu_22_param.cpy
	cobc -x -free 0019_submenu_22.cob -o 0019_submenu_22
	cp 0019_submenu_22 $(cgibin)/0019_submenu_22
	
0019_submenu_23:	0019_submenu_23.cob 0019_submenu_23_param.cpy
	cobc -x -free 0019_submenu_23.cob -o 0019_submenu_23
	cp 0019_submenu_23 $(cgibin)/0019_submenu_23
	
# convert
0019_menu_1.cob:	0019_menu_1_cob.html
	$(htm2cob) 0019_menu_1_cob.html -v

0019_menu_2.cob:	0019_menu_2_cob.html
	$(htm2cob) 0019_menu_2_cob.html -v

0019_menu_3.cob:	0019_menu_3_cob.html
	$(htm2cob) 0019_menu_3_cob.html -v

0019_submenu_21.cob:	0019_submenu_21_cob.html
	$(htm2cob) 0019_submenu_21_cob.html -v
	
0019_submenu_22.cob:	0019_submenu_22_cob.html
	$(htm2cob) 0019_submenu_22_cob.html -v
	
0019_submenu_23.cob:	0019_submenu_23_cob.html
	$(htm2cob) 0019_submenu_23_cob.html -v
	
clean:
	rm -f 0019_menu_1.cob
	rm -f 0019_menu_1
	rm -f $(cgibin)/0019_menu_1
	rm -f 0019_menu_2.cob
	rm -f 0019_menu_2
	rm -f $(cgibin)/0019_menu_2
	rm -f 0019_menu_3.cob
	rm -f 0019_menu_3
	rm -f $(cgibin)/0019_menu_3
	rm -f 0019_submenu_21.cob
	rm -f 0019_submenu_21
	rm -f $(cgibin)/0019_submenu_21
	rm -f 0019_submenu_22.cob
	rm -f 0019_submenu_22
	rm -f $(cgibin)/0019_submenu_22
	rm -f 0019_submenu_23.cob
	rm -f 0019_submenu_23
	rm -f $(cgibin)/0019_submenu_23
	rm -f $(htdocs)/0019_menu_test.html
	rm -f $(htdocs)/css/0019_menu.css
    