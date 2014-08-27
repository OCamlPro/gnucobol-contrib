# cobweb-gui early alpha
cobweb-gui: cobweb-gui.cob cobweb-gtk.cob voidcall.c Makefile
	cobc -m -g -debug cobweb-gtk.cob voidcall.c `pkg-config --libs gtk+-3.0` -lvte2_90 
	LD_RUN_PATH=. cobc -x -g -debug cobweb-gui.cob cobweb-gtk.so 

# Create the COBODoc, Dreamhost chokes on the generated <?xml...> line
cobodoc: 
	robodoc --src ./ --doc cobwebgtk --multidoc --rc robocob.rc
	sed -i '1d' cobwebgtk/*.html

cobweb-gui.tar.gz: cobweb-gui.cob cobweb-gtk.cob voidcall.c Makefile
	tar cvzf cobweb-gui.tar.gz -C .. gtk/cobweb-gui.cob gtk/cobweb-gtk.cob gtk/voidcall.c gtk/Makefile gtk/cobweb-gui-sample-data.txt

broadway: cobweb-gui
	echo 'starting up; browse to http://localhost:8080; when finished, killall broadwayd'
	broadwayd :1 &
	GDK_BACKEND=broadway BROADWAY_DISPLAY=:1 ./cobweb-gui

# for building the periodic table sample
periodic: cobweb-periodic.cob support-cobweb.cob voidcall.c
	cobc -x -g -debug cobweb-periodic.cob support-cobweb.cob voidcall.c `pkg-config --libs gtk+-3.0`

# for building up a cobweb instance
cobweb: cobweb.cob support-cobweb.cob voidcalls.c cobweb-rest.cob
	cobc -x -v -debug -C cobweb.cob
	sed -i 's/stdio.h/fcgi_stdio.h/g' cobweb.c
	cobc -x -v -g -debug cobweb.c -lfcgi cobweb-rest.cob `pkg-config --libs gtk+-3.0` support-cobweb.cob voidcalls.c

cobweb-rest.so: cobweb-rest.cob
	cobc cobweb-rest.cob

