htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0014_img_upload_scale

# compile
0014_img_upload_scale:	0014_img_upload_scale.cob 0014_img_upload_scale_param.cpy imgscale.c
	cobc -x -free 0014_img_upload_scale.cob -o 0014_img_upload_scale imgscale.c -lgd -lpng -lz -ljpeg -lfreetype -lm
	cp 0014_img_upload_scale $(cgibin)/0014_img_upload_scale
	cp 0014_img_upload_scale_test.html $(htdocs)/0014_img_upload_scale_test.html
	
# convert
0014_img_upload_scale.cob:	0014_img_upload_scale_cob.html
	$(htm2cob) 0014_img_upload_scale_cob.html -v
	
clean:
	rm -f 0014_img_upload_scale.cob
	rm -f 0014_img_upload_scale
	rm -f $(cgibin)/0014_img_upload_scale
	rm -f $(htdocs)/0014_img_upload_scale_test.html
    