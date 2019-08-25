htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0016_js_alert

# compile
0016_js_alert:	0016_js_alert.cob 0016_js_alert_param.cpy
	cobc -x -free 0016_js_alert.cob -o 0016_js_alert
	cp 0016_js_alert $(cgibin)/0016_js_alert
	cp 0016_js_alert_test.html $(htdocs)/0016_js_alert_test.html
	cp js/0016_js_alert.js $(htdocs)/js/0016_js_alert.js
	
# convert
0016_js_alert.cob:	0016_js_alert_cob.html
	$(htm2cob) 0016_js_alert_cob.html -v
	
clean:
	rm -f 0016_js_alert.cob
	rm -f 0016_js_alert
	rm -f $(cgibin)/0016_js_alert
	rm -f $(htdocs)/0016_js_alert_test.html
	rm -f $(htdocs)/js/0016_js_alert.js
    