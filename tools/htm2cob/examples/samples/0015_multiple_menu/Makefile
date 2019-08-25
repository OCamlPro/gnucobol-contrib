htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0015_multiple_menu

# compile
0015_multiple_menu:	0015_multiple_menu.cob 0015_multiple_menu_param.cpy
	cobc -x -free 0015_multiple_menu.cob -o 0015_multiple_menu
	cp 0015_multiple_menu $(cgibin)/0015_multiple_menu
	cp 0015_multiple_menu_test.html $(htdocs)/0015_multiple_menu_test.html
	
# convert
0015_multiple_menu.cob:	0015_multiple_menu_cob.html
	$(htm2cob) 0015_multiple_menu_cob.html -v
	
clean:
	rm -f 0015_multiple_menu.cob
	rm -f 0015_multiple_menu
	rm -f $(cgibin)/0015_multiple_menu
	rm -f $(htdocs)/0015_multiple_menu_test.html
    