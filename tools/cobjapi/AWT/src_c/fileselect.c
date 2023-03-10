/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  fileselect.c is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  fileselect.c is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with fileselect.c.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      fileselect.c
*>
*> Purpose:      File selection functions
*>
*> Author:       Dr. Merten Joost
*>
*> Date-Written: 2003.02.26
*>
*> Tectonics:    gcc -c -O2 -Wall fileselect.c
*>
*> Usage:        The function __fileselect will be used in japilib.c.
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added.
*>            - Define _MSC changed to _MSC_VER for MS Visual Studio C++.
*>******************************************************************************
*/
 
#include <stdio.h>
#include <sys/stat.h>
#include <string.h>
#include "japi_p.h"
#include "japi.h"

#ifdef _MSC_VER
	#ifndef WIN32
		#define WIN32
	#endif
#endif

#ifdef WIN32
  #include <io.h>
  #define PATHSEP '\\'
//  #define getcwd _getcwd
#else
//  #include <libgen.h>
  #include <unistd.h>
  #ifndef USEDIRENT
    #include <dirent.h>
  #else
    #include <sys/dir.h>
  #endif
  #define PATHSEP '/'
#endif

extern char* getcwd();
extern int chdir();

static int x=0,y=0,width=250,height=400;



int __isdir(char *name)
{
    struct stat buf;

    stat(name,&buf);

    if(buf.st_mode & S_IFDIR)
        return(1);
    else
        return(0);
}


char* __dirname(char* filename, char* localpath)
{
	char *ptr;

	sprintf(localpath,"%s",filename);
	if(!__isdir(localpath))
	{
		ptr=strrchr(localpath,PATHSEP);
		if(ptr!=NULL)
			*ptr='\0';
		else
			sprintf(localpath,".");
	}
	return(localpath);
}

char* __basename(char* filename, char* localname)
{
	char *ptr;

	if(!__isdir(filename))
	{
		ptr=strrchr(filename,PATHSEP);
		if(ptr!=NULL)
			sprintf(localname,"%s",(char*)(ptr+1));
		else
			*localname='\0';
	}
	else
		*localname='\0';
	return(localname);
}


static int __match(sstring,pattern)
char *sstring,*pattern;
{
	char *st,*pa;
    int lst=0,lpa=0,ist=1,ipa=1;

    st=sstring; while (*st++) lst++; st=sstring; /* Laenge berechnen */
    pa=pattern;while (*pa++) lpa++; pa=pattern;/* Laenge berechnen */
    if (!(lst*lpa)) return(0);     /* Ein String war leer */

    while(1)
	{
		if (*pa == '?')
	   	{
	       	if (ist>lst) return(0);
	       	++ist; ++st; ++ipa; ++pa;
	       	if ((ist>lst) && (ipa>lpa)) return(1);
	       	if (ipa>lpa) return(0);
	       	continue;
	    }
	  	if (*pa == '*')
	    {
	    	if (ipa == lpa) return(1);
	       	++ipa; ++pa;
	       	if (ist > lst) continue;
	       	do
		    {
		    	if (__match(st,pa)) return(1);
		    	++ist; ++st;
		    } while (ist <= lst);
	       	return(0);
	    }
	  	if ((ist > lst) || (!(*st++ == *pa++))) return(0);
	  	++ipa;
	  	if ((++ist > lst) && (ipa > lpa)) return(1);
	}
	return(0);
}

static void __filllist(int list, int filter)
{

#ifdef WIN32
	long struct_ptr;
	struct _finddata_t c_file;
#else
	DIR *dirp;
#ifndef USEDIRENT
    struct dirent *datei;
#else
    struct direct *datei;
#endif
#endif
	char filterpattern[1024];
	char dirname[1024];

	japi_gettext(filter,filterpattern);
	japi_hide(list);
	japi_removeall(list);

#ifdef WIN32
	if( (struct_ptr = _findfirst("*", &c_file )) != -1L )
	{
		do
			if(__isdir(c_file.name))
			{
				sprintf(dirname,"%s/",c_file.name);
				japi_additem(list,dirname);
			}
        while( _findnext( struct_ptr, &c_file ) == 0 );
	    _findclose( struct_ptr );
	}

	if( (struct_ptr = _findfirst(filterpattern, &c_file )) != -1L )
	{
		if(!__isdir(c_file.name)) japi_additem(list,c_file.name);
        while( _findnext( struct_ptr, &c_file ) == 0 )
			if(!__isdir(c_file.name)) japi_additem(list,c_file.name);
	    _findclose( struct_ptr );
	}
#else
    dirp = opendir(".");
	while((datei = readdir(dirp)) != NULL)
	{
		if(__isdir(datei->d_name))
		{
			sprintf(dirname,"%s/",datei->d_name);
			japi_additem(list,dirname);
		}
	}
	closedir(dirp);

    dirp = opendir(".");
	while((datei = readdir(dirp)) != NULL)
	{
		if((!__isdir(datei->d_name))&&(__match(datei->d_name,filterpattern)))
			japi_additem(list,datei->d_name);
	}
	closedir(dirp);
#endif

//	japi_show(list);

	// jdk1.3 Linux does not add a scrollbar if needed, JAVA BUG !!!
	japi_setsize(list,japi_getwidth(list)-1,japi_getheight(list)-1);
	japi_setsize(list,japi_getwidth(list)+1,japi_getheight(list)+1);
	japi_show(list);
}


char* __fileselect(int jframe, char *title, char *filename, char *filter)
{
	int obj,jdialog,jpanel,jpath,jfilelist,jpreselect;
	int jpanel2,jfilename,jfilter,jok,jcancel;
	int idx;
	char mainpath[1024],localpath[1024],localname[1024];

	__dirname(filename,localpath);
	__basename(filename,localname);

	getcwd(mainpath,1024);
	chdir(localpath);
	getcwd(localpath,1024);
	japi_disable(jframe);

	jdialog    = japi_dialog(jframe,title);
	japi_setborderlayout(jdialog);
	japi_setinsets(jdialog,40,10,10,10);
	japi_sethgap(jdialog,10);
	japi_setvgap(jdialog,10);
	jpath      = japi_textfield(jdialog,50);
	japi_setborderpos(jpath,J_TOP);
	jpanel     = japi_panel(jdialog);
	japi_setborderpos(jpanel,J_RIGHT);
	jfilelist  = japi_list(jdialog,20);
	jpreselect = japi_mouselistener(jfilelist,J_RELEASED);

	japi_setborderlayout(jpanel);
	jpanel2  = japi_panel(jpanel);
	japi_setborderpos(jpanel2,J_TOP);

	japi_setflowlayout(jpanel2,J_VERTICAL);
	japi_setflowfill(jpanel2,J_TRUE);
	japi_label(jpanel2,"Filename");
	jfilename= japi_textfield(jpanel2,10);
	japi_label(jpanel2,"Filter");
	jfilter  = japi_textfield(jpanel2,10);

	jpanel2  = japi_panel(jpanel);
	japi_setborderpos(jpanel2,J_BOTTOM);
	japi_setflowlayout(jpanel2,J_VERTICAL);
	japi_setflowfill(jpanel2,J_TRUE);
	jok      = japi_button(jpanel2,"OK");
	jcancel  = japi_button(jpanel2,"Cancel");

	japi_pack(jdialog);

	japi_setsize(jdialog,width,height);
	if(x==0) x=japi_getxpos(jframe)+(japi_getwidth(jframe)-japi_getwidth(jdialog))/2;
	if(y==0) y=japi_getypos(jframe)+(japi_getheight(jframe)-japi_getheight(jdialog))/2;
	x=x>0?x:0;
	y=y>0?y:0;
	japi_setpos(jdialog,x,y);

	japi_settext(jpath,localpath);
	japi_settext(jfilter,filter);
	japi_settext(jfilename,localname);
	__filllist(jfilelist,jfilter);

	japi_show(jdialog);
	obj=0;
	while(1)
	{
		obj=japi_nextaction();

		if(obj == jfilter)
			__filllist(jfilelist,jfilter);

		if(obj == jpreselect)
		{
			idx = japi_getselect(jfilelist);
			if(idx > 0)
			{
				japi_getitem(jfilelist,idx,localname);
				if(!__isdir(localname))
					japi_settext(jfilename,localname);
				else
					japi_settext(jfilename," ");
			}
		}

		if(obj==jfilelist)
		{
			if(__isdir(japi_getitem(jfilelist,japi_getselect(jfilelist),filename)))
			{
				chdir(japi_getitem(jfilelist,japi_getselect(jfilelist),filename));
				getcwd(localpath,1024);
//				sprintf(localname," ");
				japi_settext(jpath,localpath);
//				japi_settext(jfilename,localname);
				__filllist(jfilelist,jfilter);
			}
			else
			{
				japi_getitem(jfilelist,japi_getselect(jfilelist),filename);
				break;
			}
		}

		if(obj==jok)
		{
			japi_gettext(jfilename,localname);
			break;
		}

		if(obj==jpath)
		{
//			chdir(japi_getitem(jfilelist,japi_getselect(jfilelist),filename));
    		chdir(japi_gettext(jpath,localpath));
			getcwd(localpath,1024);
//			sprintf(localname," ");
			japi_settext(jpath,localpath);
//			japi_settext(jfilename,localname);
			__filllist(jfilelist,jfilter);
		}

		if((obj == jcancel)||(obj==jdialog))
		{
			localname[0]='\0';
			localpath[0]='\0';
			break;
		}

	}
	x=japi_getxpos(jdialog);
	y=japi_getypos(jdialog);
	japi_dispose(jdialog);
	japi_enable(jframe);

	chdir(mainpath);
	if((localpath[0]=='\0')&&(localname[0]=='\0'))
		filename[0]='\0';
	else
	{
		sprintf(filename,"%s%c%s",localpath,PATHSEP,localname);
	}
	return(filename);
}
