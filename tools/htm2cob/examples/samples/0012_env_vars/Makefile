htm2cob=../../../source/htm2cob
cgibin=/srv/www/cgi-bin
htdocs=/srv/www/htdocs

all:	0012_env_vars

# compile
0012_env_vars:	0012_env_vars.cob 0012_env_vars_param.cpy
	cobc -x -free 0012_env_vars.cob -o 0012_env_vars
	cp 0012_env_vars $(cgibin)/0012_env_vars
	cp 0012_env_vars_test.html $(htdocs)/0012_env_vars_test.html
	
# convert
0012_env_vars.cob:	0012_env_vars_cob.html
	$(htm2cob) 0012_env_vars_cob.html -v
	
clean:
	rm -f 0012_env_vars.cob
	rm -f 0012_env_vars
	rm -f $(cgibin)/0012_env_vars
	rm -f $(htdocs)/0012_env_vars_test.html
    