htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0013_img_upload

# compile
0013_img_upload:	0013_img_upload.cob 0013_img_upload_param.cpy
	cobc -x -free 0013_img_upload.cob -o 0013_img_upload
	cp 0013_img_upload $(cgibin)/0013_img_upload
	cp 0013_img_upload_test.html $(htdocs)/0013_img_upload_test.html
	
# convert
0013_img_upload.cob:	0013_img_upload_cob.html
	$(htm2cob) 0013_img_upload_cob.html -v
	
clean:
	rm -f 0013_img_upload.cob
	rm -f 0013_img_upload
	rm -f $(cgibin)/0013_img_upload
	rm -f $(htdocs)/0013_img_upload_test.html
    