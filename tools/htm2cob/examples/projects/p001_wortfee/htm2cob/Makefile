# for cygwin
# cgibin=/srv/www/cgi-bin
# for linux
cgibin=/var/www/vhosts/wortfee.net/httpdocs/cgi-bin

htm2cob=../../../../source/htm2cob

# SQLCA: SQL Communications Area for Ocesql
COPY=/home/$(USER)/Open-COBOL-ESQL-1.2/copy
SCR=/usr/local/share/gnucobol/copy
OC_OBJ=/home/$(USER)/Open-COBOL-ESQL-1.2/dblib

all:	p001_wortfee_login p001_wortfee_intro p001_wortfee_learn p001_wortfee_glist

# compile
p001_wortfee_login:	p001_wortfee_login.cob p001_wortfee_login_param.cpy PGMOD1.cob
	cobc -m -c PGMOD1.cob -I$(COPY) -I$(SCR)
# for cygwin
#	cobc -x -free p001_wortfee_login.cob PGMOD1.o -o p001_wortfee_login $(OC_OBJ)/ocdb.o $(OC_OBJ)/ocdblog.o $(OC_OBJ)/ocdbutil.o $(OC_OBJ)/ocesql.o $(OC_OBJ)/ocpgsql.o -I$(COPY) -I$(SCR) -locesql -lpq
	cobc -x -free p001_wortfee_login.cob PGMOD1.o -o p001_wortfee_login -I$(COPY) -I$(SCR) -locesql
	cp p001_wortfee_login $(cgibin)/p001_wortfee_login

p001_wortfee_intro:	p001_wortfee_intro.cob p001_wortfee_intro_param.cpy PGMOD2.cob
	cobc -m -c PGMOD2.cob -I$(COPY) -I$(SCR)
# for cygwin
#	cobc -x -free p001_wortfee_intro.cob PGMOD2.o -o p001_wortfee_intro $(OC_OBJ)/ocdb.o $(OC_OBJ)/ocdblog.o $(OC_OBJ)/ocdbutil.o $(OC_OBJ)/ocesql.o $(OC_OBJ)/ocpgsql.o -I$(COPY) -I$(SCR) -locesql -lpq
	cobc -x -free p001_wortfee_intro.cob PGMOD2.o -o p001_wortfee_intro -I$(COPY) -I$(SCR) -locesql
	cp p001_wortfee_intro $(cgibin)/p001_wortfee_intro

p001_wortfee_learn:	p001_wortfee_learn.cob p001_wortfee_learn_param.cpy PGMOD3.cob
	cobc -m -c PGMOD3.cob -I$(COPY) -I$(SCR)
# for cygwin
#	cobc -x -free p001_wortfee_learn.cob PGMOD3.o -o p001_wortfee_learn $(OC_OBJ)/ocdb.o $(OC_OBJ)/ocdblog.o $(OC_OBJ)/ocdbutil.o $(OC_OBJ)/ocesql.o $(OC_OBJ)/ocpgsql.o -I$(COPY) -I$(SCR) -locesql -lpq
	cobc -x -free p001_wortfee_learn.cob PGMOD3.o -o p001_wortfee_learn -I$(COPY) -I$(SCR) -locesql
	cp p001_wortfee_learn $(cgibin)/p001_wortfee_learn

p001_wortfee_glist:	p001_wortfee_glist.cob p001_wortfee_glist_param.cpy PGMOD4.cob
	cobc -m -c PGMOD4.cob -I$(COPY) -I$(SCR)
# for cygwin
#	cobc -x -free p001_wortfee_glist.cob PGMOD4.o -o p001_wortfee_glist $(OC_OBJ)/ocdb.o $(OC_OBJ)/ocdblog.o $(OC_OBJ)/ocdbutil.o $(OC_OBJ)/ocesql.o $(OC_OBJ)/ocpgsql.o -I$(COPY) -I$(SCR) -locesql -lpq
	cobc -x -free p001_wortfee_glist.cob PGMOD4.o -o p001_wortfee_glist -I$(COPY) -I$(SCR) -locesql
	cp p001_wortfee_glist $(cgibin)/p001_wortfee_glist
	
# htm2cob converter
p001_wortfee_login.cob:	p001_wortfee_login_cob.html
	$(htm2cob) p001_wortfee_login_cob.html -v

p001_wortfee_intro.cob:	p001_wortfee_intro_cob.html
	$(htm2cob) p001_wortfee_intro_cob.html -v

p001_wortfee_learn.cob:	p001_wortfee_learn_cob.html
	$(htm2cob) p001_wortfee_learn_cob.html -v

p001_wortfee_glist.cob:	p001_wortfee_glist_cob.html
	$(htm2cob) p001_wortfee_glist_cob.html -v

# SQL precompile
PGMOD1.cob: PGMOD1.cbl
	ocesql PGMOD1.cbl PGMOD1.cob

PGMOD2.cob: PGMOD2.cbl
	ocesql PGMOD2.cbl PGMOD2.cob

PGMOD3.cob: PGMOD3.cbl
	ocesql PGMOD3.cbl PGMOD3.cob

PGMOD4.cob: PGMOD4.cbl
	ocesql PGMOD4.cbl PGMOD4.cob
	
clean:
# login
	rm -f p001_wortfee_login.cob
	rm -f p001_wortfee_login
	rm -f $(cgibin)/p001_wortfee_login
	rm -f PGMOD1.cob
	rm -f PGMOD1.o
# intro   
	rm -f p001_wortfee_intro.cob
	rm -f p001_wortfee_intro
	rm -f $(cgibin)/p001_wortfee_intro
	rm -f PGMOD2.cob
	rm -f PGMOD2.o
# learn   
	rm -f p001_wortfee_learn.cob
	rm -f p001_wortfee_learn
	rm -f $(cgibin)/p001_wortfee_learn
	rm -f PGMOD3.cob
	rm -f PGMOD3.o
# glist   
	rm -f p001_wortfee_glist.cob
	rm -f p001_wortfee_glist
	rm -f $(cgibin)/p001_wortfee_glist
	rm -f PGMOD4.cob
	rm -f PGMOD4.o
    