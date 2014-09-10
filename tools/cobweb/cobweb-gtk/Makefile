# cobweb-gui early alpha
cobweb-gui: cobweb-gui.cob cobweb-gtk.cob voidcall_gtk.c Makefile
	cobc -m -g -debug cobweb-gtk.cob voidcall_gtk.c `pkg-config --libs gtk+-3.0` -lvte2_90 
	LD_RUN_PATH=. cobc -x -g -debug cobweb-gui.cob cobweb-gtk.so 

cobweb-gui-example-label: cobweb-gui-example-label.cob cobweb-gtk-preamble.cpy cobweb-gtk.cob voidcall_gtk.c Makefile
	cobc -m -g -debug cobweb-gtk.cob voidcall_gtk.c `pkg-config --libs gtk+-3.0` -lvte2_90 
	LD_RUN_PATH=. cobc -x -g -debug cobweb-gui-example-label.cob cobweb-gtk.so 

cobweb-gui-example-entry: cobweb-gui-example-entry.cob cobweb-gtk-preamble.cpy cobweb-gtk.cob voidcall_gtk.c Makefile
	cobc -m -g -debug cobweb-gtk.cob voidcall_gtk.c `pkg-config --libs gtk+-3.0` -lvte2_90 
	LD_RUN_PATH=. cobc -x -g -debug cobweb-gui-example-entry.cob cobweb-gtk.so 

# Create the COBODoc, Dreamhost chokes on the generated <?xml...> line
cobodoc: 
	robodoc --src ./ --doc cobwebgtk --multidoc --rc robocob.rc --css cobodoc.css
	cp cobwebgtk/toc_index.html cobwebgtk/index.html
	sed -i '1d' cobwebgtk/*.html

sync:
	rsync -avzcn --existing --exclude=Makefile . /home/btiffin/wip/contrib/trunk/tools/cobweb/cobweb-gtk/

cobweb-gui.tar.gz: cobweb-gui.cob cobweb-gtk.cob voidcall_gtk.c Makefile
	tar cvzf cobweb-gui.tar.gz -C .. gtk/cobweb-gui.cob gtk/cobweb-gtk.cob gtk/voidcall_gtk.c gtk/Makefile gtk/cobweb-gui-sample-data.txt

broadway: cobweb-gui
	echo 'starting up; browse to http://localhost:8080; when finished, killall broadwayd'
	broadwayd :1 &
	GDK_BACKEND=broadway BROADWAY_DISPLAY=:1 ./cobweb-gui

# for building the periodic table sample
periodic: cobweb-periodic.cob support-cobweb.cob voidcall_gtk.c
	cobc -x -g -debug cobweb-periodic.cob support-cobweb.cob voidcall_gtk.c `pkg-config --libs gtk+-3.0`

# for building up a cobweb instance
cobweb: cobweb.cob support-cobweb.cob voidcalls.c cobweb-rest.cob
	cobc -x -v -debug -C cobweb.cob
	sed -i 's/stdio.h/fcgi_stdio.h/g' cobweb.c
	cobc -x -v -g -debug cobweb.c -lfcgi cobweb-rest.cob `pkg-config --libs gtk+-3.0` support-cobweb.cob voidcalls.c

cobweb-rest.so: cobweb-rest.cob
	cobc cobweb-rest.cob
