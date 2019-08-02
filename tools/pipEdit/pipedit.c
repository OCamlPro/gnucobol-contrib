/***************************************************************************
Errors:

cols command - y-position is borked when on (solved??)

X - excluded lines - scrolling is borked

****************************************************************************/


# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <ctype.h>
# include <time.h>
# include <signal.h>

# ifdef __USE_PIPCURSES__
	# include "pipcurses.c"
# else
	# include <ncurses.h>
	# undef KEY_ENTER
	# define KEY_ENTER 13 // overwrite the curses #define with the real value
	# undef KEY_STAB
	# define KEY_STAB 9   // overwrite the curses #define with the real value
	# define KEY_ESCAPE 27
# endif

# ifndef TRUE
   # define TRUE (0==0)
   # define FALSE (0!=0)
# endif

# define MAXLINES 256000
unsigned char *lineptr[MAXLINES];
unsigned char *linecmd[MAXLINES];
unsigned char linetype[MAXLINES];
int linecnt=0;
int current_line=0;
int cursor_x=14;
int cursor_y=3;

int source_changed=FALSE;

# define CUR_CMDLINE   1
# define CUR_MENU      2
# define CUR_LINENBR   3
# define CUR_TEXTAREA  4
int cursor_area=CUR_CMDLINE;

# define SCREEN_EDITOR     0
# define SCREEN_QUESTION   1
int current_screen=SCREEN_EDITOR;
char question[80]="";

char screen_commandline[80];
char screen_errormsg[25]="";
char screen_errormessage[85]="";
int screen_errform=0; // 0 = short errormsg  1 = long errormessage
int screen_topline=4;
int screen_lines=20;
int screen_lastline=0;
int screen_offset_y=0;
int screen_offset_x=0;
int screen_cols=0; // 0 = cols off   1 = cols on
int screen_x=0;
int screen_y=0;
int col_start=1;
int col_end=72;

int write_logfile=FALSE;
char filename[256]="";

int forecolor=COLOR_BLACK;
int backcolor=COLOR_BLACK;

char rfind_needle[256];

unsigned char glo_buff[32768];

# define COLPAIR_NORMAL 1
# define COLPAIR_MENU   2
# define COLPAIR_BLUE   3
# define COLPAIR_YELLOW 4
# define COLPAIR_INSERT 5
# define COLPAIR_ERRMSG 6
# define COLPAIR_FRAME  7
# define COLPAIR_YESNO  8
# define COLPAIR_XCLUD  9

char config_file[256];

/******************************************************************************/
void set_signals(void);
void signal_handler(int signal)
{
	if(signal==SIGINT){
		puts("SIGINT -> ignored...");
		set_signals();
		return;
	}
	if(signal==SIGUSR1){
		puts("SIGUSR1 -> ignored...");
		set_signals();
		return;
	}
	if(signal==SIGUSR2){
		puts("SIGUSR2 -> ignored...");
		set_signals();
		return;
	}
	if(signal==SIGCHLD){
		/* puts("SIGCHLD -> ignored..."); */
		set_signals();
		return;
	}
	fprintf(stderr, "exiting with signal %d.\n", signal);
	exit(signal);
}
/******************************************************************************/
void set_signals(void)
{
	int t;

	return;

	for(t=1; t<31; t++){
		if(t!= 18){
			signal(t, signal_handler);
		}
	}
}
/******************************************************************************/
void expand_to_256_bytes(char *s)
{
	int l;

	l=strlen(s);
	for(;;){
		if(l>255) break;
		strcat(s, " ");
		l++;
	}
}
/******************************************************************************/
/******************************************************************************
 * Retrieves word No. n from string *s and stores it in *ziel. * n starts
 * with 1, not with 0 !!! * Escape-Character is \, strings are delimited
 * by ". 
 */
char *__xpjg_wordptr = NULL;
int __xpjg_wordpos = 0;
void word(char *s, char *ziel, int n)
{
   int anz = 0;
   int t;
   int f = 0;
   int z = 0;
   int start;
   int m = 1;
   int esc = 0;
   int l;

   __xpjg_wordptr = s;

   l = (int)strlen((char *)s);
   for (start = 0; start < l; start++)
      if (s[start] > ' ')
         break;

   for (t = start; t < l; t++) {
      if (s[t] == '\\') {
         if (esc == 0) {
            esc = 1;
            if (anz == n)
               ziel[z++] = '\\';
         }
         else {
            if (anz == n)
               ziel[z++] = '\\';
            esc = 0;
         }
      }
      else {
         if ((s[t] == '"' || s[t] == '\'') && esc == 0)
            m *= -1;
         if (s[t] == ' ' && m == 1)
            f = 0;
         else
            f++;
         if (f == 1)
            anz++;
         if (anz == n && f > 0) {
            ziel[z++] = s[t];
         }
         if (anz > n && f > 0)
            break;
         esc = 0;
      }
   }         /* next t */
   ziel[z] = 0;
   __xpjg_wordpos = t;
   l = strlen((char *)ziel) - 1;   /* Trim trailing spaces */
   for (;;) {
      if (l < 1)
         break;
      if (ziel[l] != ' ')
         break;
      ziel[l] = 0;
      l--;
   }
}

/********************************************************************/
void next_word(unsigned char *ziel)
{
   int anz = 0;
   int t;
   int f = 0;
   int z = 0;
   int m = 1;
   int esc = 0;
   int l;
   char *s;

   s = __xpjg_wordptr;
   if (s == NULL) {
      ziel[0] = 0;
      return;
   }
   l = strlen((char *)s);
   for (t = __xpjg_wordpos; t < l; t++) {
      if (s[t] == '\\') {
         if (esc == 0) {
            esc = 1;
            ziel[z++] = '\\';
         }
         else {
            ziel[z++] = '\\';
            esc = 0;
         }
      }
      else {
         if (s[t] == '"' && esc == 0)
            m *= -1;
         if (s[t] == ' ' && m == 1)
            f = 0;
         else
            f++;
         if (f == 1)
            anz++;
         if (anz > 1 && f > 0)
            break;
         if (f > 0) {
            ziel[z++] = s[t];
         }
         esc = 0;
      }
   }         /* next t */
   ziel[z] = 0;
   if (z == 0) {
      __xpjg_wordptr = NULL;
      __xpjg_wordpos = 0;
   }
   else {
      __xpjg_wordpos = t;
   }
   l = strlen((char *)ziel) - 1;   /* Trim trailing spaces */
   for (;;) {
      if (l < 1)
         break;
      if (ziel[l] != ' ')
         break;
      ziel[l] = 0;
      l--;
   }
}

/********************************************************************/
/*
 * Counts all words in *s and returns the count. 
 */
int words(unsigned char *s)
{
   int anz = 0;
   int t;
   int f = 0;
   int start;
   int m = 1;
   int esc = 0;
   int l;

   l = (int)strlen((char *)s);
   for (start = 0; start < l; start++)
      if (s[start] > ' ')
         break;

   for (t = start; t < l; t++) {
      if (s[t] == '\\') {
         if (esc == 0) {
            esc = 1;
         }
         else {
            esc = 0;
         }
      }
      else {
         if (s[t] == '"' && esc == 0)
            m *= -1;
         if (s[t] == ' ' && m == 1)
            f = 0;
         else
            f++;
         if (f == 1)
            anz++;
         esc = 0;
      }
   }         /* next t */
   return (anz);
}

/******************************************************************************/
void rtrim(char *s)
{
	int l;

	l=strlen(s)-1;
   for(;;){
      if(l<0) break;
      if(s[l]!=' ' && s[l]!='\t') break;
      s[l]=0;
      l--;
   }
}
/******************************************************************************/
void trim(char *s)
{
	int l;

	l=strlen(s)-1;
   for(;;){
      if(l<0) break;
      if(s[l]!=' ' && s[l]!='\t') break;
      s[l]=0;
      l--;
   }
   if(l==0) return;
   for(;;){
      if(s[0]==0) break;
      if(s[0]!=' ' && s[0]!='\t') break;
      memmove(s, s+1, strlen(s));
   }
}
/******************************************************************************/
int do_save(void)
{
	FILE *fp;
	int t;
	char zwi[1024];

	if(source_changed==FALSE){
		return(FALSE);
	}

	fp=fopen(filename, "wb");
	if(fp==NULL){
		strcpy(screen_errormsg, "Save error");
		sprintf(screen_errormessage, "Could not open %s for output.", filename);
		return(FALSE);
	}
	for(t=0; t<linecnt; t++){
		if(linetype[t]=='N'){
			strcpy(glo_buff, lineptr[t]);
			rtrim(glo_buff);
			fprintf(fp, "%s\n", glo_buff);
		}
	}

	strcpy(screen_errormsg, "Save done!");
	sprintf(screen_errormessage, "File %s successfully saved.", filename);

	fclose(fp);

	source_changed=FALSE;

	return(TRUE);
}
/******************************************************************************/
void set_to_space(char *s, int amount)
{
	int t;

	for(t=0; t<amount; t++){
		s[t]=' ';
	}
	s[t]=0;
}
/******************************************************************************/
void write_to_log(char *s)
{
	FILE *fp;
	time_t tsec;
	struct tm *s_tm;

	if(write_logfile==FALSE) return;

   tsec=time(NULL);
   s_tm=localtime(&tsec);
   s_tm->tm_year+=1900;
   s_tm->tm_mon++;

	fp=fopen("logfile.txt", "a+");
	if(fp!=NULL){
      fprintf(fp, "%04d%02d%02d-%02d%02d%02d: %s \n",
		        s_tm->tm_year, s_tm->tm_mon, s_tm->tm_mday,
		        s_tm->tm_hour, s_tm->tm_min, s_tm->tm_sec, s);
		fclose(fp);
	}
	else{
		fprintf(stderr, "Could not open logfile.txt, aborting..\n");
		exit(7);
	}
}
/******************************************************************************/
void ucase(char *s)
{
	int t;
	int c;

	for(t=0;;t++){
		c=s[t];
		if(c==0) break;
		s[t]=toupper(c);
	}
}
/******************************************************************************/
char read_line(FILE *fp, char *s, int len)
{
	int c;
	int z;

	for(z=0;;){
		if(z>=len) break;
		c=fgetc(fp);
		if(c=='\r'){
			// ignore this
		}
		else{
			if(c==EOF || c=='\n'){
				break;
			}
			else{
				s[z++]=c;
			}
		}
	}
	s[z]=0;
	return(c);
}
/******************************************************************************/
void error_exit(char *s)
{
	char zwi[1024];

	endwin();
	puts("");
	sprintf(zwi, "ERROR: %s\n", s);
	write_to_log(zwi);
	fprintf(stderr, "ERROR: %s\n", s);
	exit(99);
}
/******************************************************************************/
void terminate_program(char *s)
{
	char zwi[1024];

	endwin();
	puts("");
	puts(s);
	exit(0);
}
/******************************************************************************/
void draw_screen_editor(void)
{
	char zwi[1024];
	char zwi2[256];
	int t, i;
	int ypos;
	int a;
	int cnt;
	int end;
	char columns[257]="----+-A--1-B--+----2----+----3----+----4----+----5----+----6----+----7--C-+----8----+----9----+----10---+----11---+----12---+----13---+----14---+----15---+----16---+----17---+----18---+----19---+----20---+----21---+----22---+----23---+----24---+----25---+-";

	clear();

	attron(COLPAIR_MENU);

	mvaddstr(0, 2, "File");
	mvaddstr(0, 9, "Edit");
	mvaddstr(0, 16, "Edit_Settings");
	mvaddstr(0, 31, "Menu");
	mvaddstr(0, 37, "Utilities");
	mvaddstr(0, 48, "Compilers");
	mvaddstr(0, 59, "Test");
	mvaddstr(0, 65, "Help");

	attron(COLPAIR_BLUE);

	mvaddstr(1, 0, "--------------------------------------------------------------------------------");


	mvaddstr(2, 2, "Edit");
	mvaddstr(2, 13, filename);
	mvaddstr(2, 61, "Columns");
	sprintf(zwi, "%05d", col_start);
	mvaddstr(2, 69, zwi);
	sprintf(zwi, "%05d", col_end);
	mvaddstr(2, 75, zwi);

	attron(COLPAIR_NORMAL);

	mvaddstr(3, 2, "Command ===>");
	mvaddstr(3, 15, screen_commandline);
	mvaddstr(3, 64, "Scroll  ===>");
	mvaddstr(3, 76, "CSR");

	if(screen_cols==1){
		attron(COLPAIR_YELLOW);
		mvaddstr(4, 2, "=COLS>");
		strncpy(zwi, columns+screen_offset_x, 71);
		mvaddstr(4, 9, zwi);
		attron(COLPAIR_NORMAL);
	}
	/***********************************************************************
	write_to_log("--------------------------------------------------------");
	for(t=0; t<linecnt; t++){
		if(lineptr[i]==NULL){
			sprintf(zwi, "DRAW %d %c (NULL)", t, linetype[t]);
		}
		else{
			sprintf(zwi, "DRAW %d %c >%s<", t, linetype[t], lineptr[t]);
		}
		write_to_log(zwi);
	}
	*************************************************************************/
	end=screen_lines;
	ypos=0;
	a=current_line+screen_offset_y;
	for(t=0; t<screen_lines; t++){
		// sprintf(zwi, "a=%d linecnt=%d", (a-screen_offset_y), (linecnt-1));
		// write_to_log(zwi);
		attron(COLPAIR_NORMAL);
		if(a<linecnt){
			strcpy(zwi2, lineptr[a]);
			expand_to_256_bytes(zwi2);
			if(strcmp(linecmd[a], "      ")==0){
				switch(linetype[a]){
					case 'I':               // inserted line
						attron(COLPAIR_INSERT);
						sprintf(zwi, " '''''' %s", zwi2);
						break;
					case 'M':               // message line
						attron(COLPAIR_INSERT);
						sprintf(zwi, " %s %s", linecmd[a], zwi2);
						break;
					case 'T':               // top/bottom line
						attron(COLPAIR_BLUE);
						sprintf(zwi, " %s %s", linecmd[a], zwi2);
						break;
					case 'E':               // error line
						attron(COLPAIR_ERRMSG);
						sprintf(zwi, " %s %s", linecmd[a], zwi2);
						break;
					case 'X':               // eXcluded lines
						cnt=0;
						for(;;){
							if(linetype[a]!='X') break;
							a++;
							cnt++;
							end++;
						}
						attron(COLPAIR_XCLUD);
						sprintf(zwi2, "%d lines excluded - - - - - - - - - - - ",cnt);
						sprintf(zwi, " %s %s", linecmd[a], zwi2);
						break;
				default:
					attron(COLPAIR_NORMAL);
					sprintf(zwi, " %06d %s", a, zwi2);
				}
				zwi[80]=0;
			}
			else{
				strcpy(glo_buff, linecmd[a]);
				rtrim(glo_buff);
				strcat(glo_buff, "      ");
				glo_buff[6]=0;
				strcpy(linecmd[a], glo_buff);
				sprintf(zwi, " %s %s", linecmd[a], zwi2);
				for(i=1; i<7; i++){
					if(zwi[i]==' '){
						zwi[i]='\'';
					}
				}
			}
			strcat(zwi, "                                                                        ");
			zwi[80]=0;
			screen_lastline=t+4;
		}
		else{
			strcpy(zwi, "                                                                                ");
		}
		if(a==0 || a==(linecnt-1)){
			for(i=1; i<7; i++){
				zwi[i]='*';
			}
		}
		mvaddstr(screen_topline+ypos, 0, zwi);
		ypos++;
		attron(COLPAIR_NORMAL);
		a++;
	}
	sprintf(zwi, "%02d/%02d", cursor_y+1, cursor_x+1);
	mvaddstr(0, 75, zwi);

	if(strlen(screen_errormsg)>0){
		if(screen_errform==0){
			for(;;){
				if(strlen(screen_errormsg)>19) break;
				strcat(screen_errormsg, " ");
			}
			attron(COLPAIR_ERRMSG);
			sprintf(zwi, " %s", screen_errormsg);
			mvaddstr(2, 60, zwi);
			attron(COLPAIR_NORMAL);
		}
		else{
			for(;;){
				if(strlen(screen_errormessage)>79) break;
				strcat(screen_errormessage, " ");
			}
			attron(COLPAIR_ERRMSG);
			mvaddstr(2, 1, screen_errormessage);
			attron(COLPAIR_NORMAL);
		}
	}

	wmove(0, cursor_y, cursor_x);
	refresh();
}
/******************************************************************************/
void draw_screen_question(void)
{
	int len, lenb;
	int a, b;
	int t;
	char zwi[1024];

	cursor_x=0;
	cursor_y=0;

	len=strlen(question)+2;
	a=80-len;
	a/=2;

	lenb=strlen(filename)+4;
	b=80-len;
	b/=2;

	clear();


	attron(COLPAIR_YELLOW);
	mvaddstr(7, b+2, "=>");
	attron(COLPAIR_BLUE);
	mvaddstr(7, b+4, filename);
	attron(COLPAIR_YELLOW);
	mvaddstr(7, b+lenb, "<=");

	attron(COLPAIR_BLUE);
	mvaddstr(8, a+2, question);

	attron(COLPAIR_YESNO);
	mvaddstr(10, a+5, " F1 = Yes ");
	mvaddstr(10, a+20," F12 = No ");

	attron(COLPAIR_FRAME);
	mvaddstr(5, a, "+");
	mvaddstr(12, a, "+");
	for(t=1; t<(len+1);t++){
		mvaddstr(5, t+a, "-");
		mvaddstr(12, t+a, "-");
	}
	mvaddstr(5, t+a, "+");
	mvaddstr(12, t+a, "+");

	for(t=0; t<6; t++){
		mvaddstr(6+t, a, "|");
		mvaddstr(6+t, a+len+1, "|");
	}

	wmove(0, cursor_y, cursor_x);
	refresh();
}
/******************************************************************************/
void draw_screen(void)
{
	switch(current_screen){
		case SCREEN_EDITOR: 
		               draw_screen_editor();
		               break;
		case SCREEN_QUESTION: 
		               draw_screen_question();
		               break;
	}
}
/******************************************************************************/
void do_backup(char *pfname)
{
	char zwi[1024];
	char zwi2[1024];
	char fname[256];
	int t;
	int pos;
	int rc;

	pos=0;

	for(t=0;;t++){
		if(pfname[t]==0) break;
		if(pfname[t]=='/'){
			pos=t+1;
		}
	}

	strcpy(fname, pfname+pos);

	// sprintf(zwi, "fname=>%s<", fname);
	// write_to_log(zwi);

	sprintf(zwi,"mv /tmp/%s.father /tmp/%s.grandfather 2>/dev/null",fname,fname);
	rc=system(zwi);
	sprintf(zwi,"mv /tmp/%s.son /tmp/%s.father 2>/dev/null",fname,fname);
	rc=system(zwi);
	sprintf(zwi,"cp %s /tmp/%s.son 2>/dev/null",pfname,fname);
	rc=system(zwi);
}
/******************************************************************************/
int load_file(char *fname)
{
	int t, i;
	FILE *fp;
	char zwi[1024];
	char zwi2[1024];

	// sprintf(zwi, "load file %s", fname);
	// write_to_log(zwi);

	strcpy(zwi, fname);
	trim(zwi);
	if(strlen(zwi)==0) return(0);

	for(t=0; t<linecnt; t++){
		if(lineptr[t]!=NULL){
			free(lineptr[t]);
			lineptr[t]=NULL;
		}
		if(linecmd[t]!=NULL){
			free(linecmd[t]);
			linecmd[t]=NULL;
		}
		linetype[t]='N';
	}
	linecnt=0;

	strcpy(zwi, "**************************** Top of Data *******************************");
	lineptr[0]=malloc(strlen(zwi)+1);
	strcpy(lineptr[0], zwi);
	linetype[0]='T';
	linecmd[0]=malloc(7);
	strcpy(linecmd[0], "      ");

	do_backup(fname);

	fp=fopen(fname, "rb");
	if(fp==NULL){
		strcpy(screen_errormsg, "File not found.");
		sprintf(screen_errormessage, "File %s not found, not loaded.", filename);
		strcpy(zwi, "************************** Bottom of Data ******************************");
		lineptr[1]=malloc(strlen(zwi)+1);
		strcpy(lineptr[1], zwi);
		linetype[1]='T';
		linecnt=2;
		linecmd[1]=malloc(7);
		strcpy(linecmd[1], "      ");
		return(FALSE);
	}

	for(t=1;;t++){
		if(read_line(fp, zwi, sizeof(zwi))==EOF) break;
		if(strlen(zwi)>255){
			strcpy(screen_errormsg, "Line too long");
			strcpy(screen_errormessage, "A line is longer than 255 characters.");
			sprintf(zwi2, "too long: strlen=%ld", strlen(zwi));
			write_to_log(zwi2);
			sprintf(zwi2, "too long: zwi=>%s<", zwi);
			write_to_log(zwi2);
			for(i=0; i<t; i++){
				free(lineptr[i]);
				lineptr[i]=NULL;
				free(linecmd[i]);
				linecmd[i]=NULL;
			}
			linecnt=0;
			fclose(fp);
			return(FALSE);
		}
		rtrim(zwi);
		lineptr[t]=malloc(strlen(zwi)+1);
		strcpy(lineptr[t], zwi);
		linecmd[t]=malloc(7);
		strcpy(linecmd[t], "      ");
		linetype[t]='N';
	}
	strcpy(zwi, "************************** Bottom of Data ******************************");
	lineptr[t]=malloc(strlen(zwi)+1);
	strcpy(lineptr[t], zwi);
	linetype[t]='T';
	linecmd[t]=malloc(7);
	strcpy(linecmd[t], "      ");
	t++;

	linecnt=t;

	fclose(fp);

	for(t=0; t<linecnt; t++){
	}
	return(TRUE);
}
/******************************************************************************/
int get_keypress(void)
{
	int a;
	int c;
	char zwi[1024];

	c=getch();
	// sprintf(zwi, ":1: c=%d", c);
	// write_to_log(zwi);

	if(c==KEY_END){
		return(KEY_END);
	}

	if(c==KEY_ESCAPE){
		c=getch();
		// sprintf(zwi, ":2: c=%d", c);
		// write_to_log(zwi);
		if(c==79){
			c=getch();
			// sprintf(zwi, ":3: c=%d", c);
			// write_to_log(zwi);
			switch(c){
				case 80: return(KEY_F1);
				case 81: return(KEY_F2);
				case 82: return(KEY_F3);
				case 83: return(KEY_F4);
				case 84: return(KEY_F5);
				case 85: return(KEY_F6);
				case 86: return(KEY_F7);
				case 87: return(KEY_F8);
				case 88: return(KEY_F9);
				case 89: return(KEY_F10);
				case 90: return(KEY_F11);
				case 91: return(KEY_F12);
			}
		}
		if(c==91){
			c=getch();
			// sprintf(zwi, ":3:91: c=%d", c);
			// write_to_log(zwi);
			if(c==49){
				c=getch();
				// sprintf(zwi, ":3:91:49: c=%d", c);
				// write_to_log(zwi);
				if(c==126){
					return(KEY_HOME);
				}
				// sprintf(zwi, "ESC:0:49: c=%d", c);
				// write_to_log(zwi);
				a=getch(); // skip the following 126
				// sprintf(zwi, "ESC:1:49: c=%d", c);
				// write_to_log(zwi);
				return(1000+c);
			}
			// sprintf(zwi, ":2:91: c=%d", c);
			// write_to_log(zwi);
			if(c==50){
				c=getch();
				// sprintf(zwi, ":3:91: c=%d", c);
				// write_to_log(zwi);
				if(c==126){
					return(KEY_IC);
				}
				a=getch(); // skip the following 126
				// sprintf(zwi, ":4:91: c=%d", c);
				// write_to_log(zwi);
				// sprintf(zwi, "ESC:50: c=%d", c);
				// write_to_log(zwi);
				return(1100+c);
			}
			if(c==51){
				a=getch(); // skip the following 126
				return(KEY_DC);
			}
			if(c==52){
				a=getch(); // skip the following 126
				return(KEY_END);
			}
			if(c==53){
				a=getch(); // skip the following 126
				return(KEY_PPAGE);
			}
			if(c==54){
				a=getch(); // skip the following 126
				return(KEY_NPAGE);
			}
			// sprintf(zwi, "ESC: c=%d", c);
			// write_to_log(zwi);
			return(1200+c);
		}
	}
	
	if(c==6){
		return(KEY_HOME);
	}
	if(c==127){
		return(KEY_BACKSPACE);
	}

	return(c);
}
/******************************************************************************/
void delete_one_line(int pos)
{
	int t;

	if(lineptr[pos]!=NULL){
		free(lineptr[pos]);
		lineptr[pos]=NULL;
	}
	if(linecmd[pos]!=NULL){
		free(linecmd[pos]);
		linecmd[pos]=NULL;
	}
	linetype[pos]='N';

	for(t=pos; t<linecnt; t++){
		lineptr[t]=lineptr[t+1];
		linecmd[t]=linecmd[t+1];
		linetype[t]=linetype[t+1];
	}

	linecnt--;
	lineptr[linecnt]=NULL;
	linecmd[linecnt]=NULL;
	linetype[linecnt]='N';
}
/******************************************************************************/
void insert_one_empty_line(int ppos)
{
	int t;
	int pos;

	// pos=ppos+screen_offset_y;
	pos=ppos;

	for(t=linecnt; t>pos; t--){
		lineptr[t]=lineptr[t-1];
		linecmd[t]=linecmd[t-1];
		linetype[t]=linetype[t-1];
	}
	lineptr[pos]=malloc(256);
	set_to_space(lineptr[pos], 255);
	linecmd[pos]=malloc(7);
	strcpy(linecmd[pos], "      ");
	linetype[pos]='I';
	linecnt++;
}
/******************************************************************************/
void remove_empty_insert_lines(int *curpos)
{
	int t, i;
	int f, ff;
	int c;
	char zwi[1024];

	for(t=0; t<linecnt; t++){
		ff=0;
		if(linetype[t]=='I'){
			if(lineptr[t]==NULL){
				delete_one_line(t);
				// sprintf(zwi, "1:DELete line %d", t);
				// write_to_log(zwi);
				ff=1;
				t--;
				*curpos--;
			}
			else{
				f=0;
				for(i=0;;i++){ // is line empty (SPACES) ?
					c=lineptr[t][i];
					if(c==0) break;
					if(c!=' '){
						linetype[t]='N';
						f=1;
					// sprintf(zwi, "Keep line %d", t);
					// write_to_log(zwi);
						ff=1;
						break;
					}
				}
				if(f==0){
					delete_one_line(t);
					// sprintf(zwi, "2:DELete line %d", t);
					// write_to_log(zwi);
					ff=1;
					t--;
				}
			}
		}
		/**********************************************************
		if(ff==1){
		write_to_log("--------------------------------------------------------");
		for(i=0; i<linecnt; i++){
			if(lineptr[i]==NULL){
				sprintf(zwi, "%s %d %c (NULL)", linecmd[i], i, linetype[i]);
			}
			else{
				sprintf(zwi, "%s %d %c >%s<", linecmd[i], i, linetype[i], lineptr[i]);
			}
			write_to_log(zwi);
		}
		}
		****************************************************************/
	}
	for(t=0; t<linecnt; t++){
		if(linetype[t]=='I'){
			linetype[t]='N';
		}
	}
}
/******************************************************************************/
void remove_message_lines(void)
{
	int t, i;
	int f;
	int c;
	char zwi[1024];

	for(t=0; t<linecnt; t++){
		if(linetype[t]=='M'){
			delete_one_line(t);
			t--;
		}
	}
}
/******************************************************************************/
void remove_error_lines(void)
{
	int t, i;
	int f;
	int c;
	char zwi[1024];

	for(t=0; t<linecnt; t++){
		if(linetype[t]=='E'){
			delete_one_line(t);
			t--;
		}
	}
}
/******************************************************************************/
void unexclude_lines(void)
{
	int t, i;
	int f;
	int c;
	char zwi[1024];

	for(t=0; t<linecnt; t++){
		if(linetype[t]=='X'){
			linetype[t]='N';
		}
	}
}
/******************************************************************************/
void do_find(char *s)
{
	char needle[256];
	char orineedle[256];
	char zwi[1024];
	char parm[256];
	int t;
	int pos;
	int f;
	int start;

	word(s, needle, 2);
	strcpy(orineedle, needle);
	ucase(needle);

	word(s, parm, 3);
	ucase(parm);


	start=screen_offset_y+cursor_y-screen_topline+1;

	if(strcmp(parm, "FIRST")==0){
		start=0;
	}
	sprintf(zwi, "start = %d parm=%s", start, parm);
	write_to_log(zwi);

	f=0;
	for(t=start; t<linecnt; t++){
		sprintf(zwi, "t = %d", t);
		write_to_log(zwi);
		if(lineptr[t]!=NULL){
			strcpy(zwi, lineptr[t]);
			ucase(zwi);
			if(strstr(zwi, needle)!=NULL){
				pos=(int)(strstr(zwi, needle)-zwi);
				sprintf(zwi, "pos = %d", pos);
				write_to_log(zwi);
				screen_offset_y=t-1;
				if(screen_offset_y<0){
					screen_offset_y=0;
					cursor_y=6;
				}
				else{
					cursor_y=5;
				}
				cursor_x=8+pos;
				strcpy(rfind_needle, needle);
				f=1;
				break;
			}
		}
	}

	if(f==0){
		strcpy(screen_errormsg, "Not found!");
		sprintf(screen_errormessage, "Text %s not found in file!", orineedle);
	}
	else{
		strcpy(screen_errormsg, "");
		strcpy(screen_errormessage, "");
	}

}
/******************************************************************************/
int do_save_for_macro(char *fname)
{
	int t;
	FILE *fp;
	char zwi[8192];

	fp=fopen(fname, "wb+");
	if(fp==NULL){
		write_to_log("Could not open outfile for macro");
		return(-1);
	}

	for(t=1; t<(linecnt-1); t++){
		sprintf(zwi, "%06d%c%s%s", t, linetype[t], linecmd[t], lineptr[t]);
		rtrim(zwi);
		fprintf(fp, "%s\n", zwi);
	}
	fclose(fp);
	return(0);
}
/******************************************************************************/
int handle_macro(char *s)
{
// check if this string is a macro, and, if yes, call it.

	int t;
	int rc;
	int f;
	int l;
	int pos;
	char zwi[256];
	char line[512];
	char zwi2[256];
	char macfile[256];
	char macname[256];
	char maccmd[256];
	char maccall[256];
	char macpath[256];
	char parfile[256];
	char fname[256];
	char temp[256];
	FILE *fp;

	write_to_log("in handle_macro()");
	strcpy(macpath, "macros");
	// sprintf(macpath, "%s/.pipedit/macros", getenv("HOME"));
	sprintf(zwi, "%s/macros.lst", macpath);
	write_to_log(zwi);

	word(s, macname, 1);
	ucase(macname);

	fp=fopen(zwi, "rb");
	if(fp==NULL){
		write_to_log("Could not open macros.lst");
		return(-1);
	}

	strcpy(parfile, filename);
	pos=-1;
	for(t=0;;t++){
		if(parfile[t]==0) break;
		if(parfile[t]=='.'){
			pos=t;
			break;
		}
	}
	if(pos>0){
		parfile[pos]=0;
		strcat(parfile, ".par");
		sprintf(zwi, "parfile=>%s< pos=%d", parfile, pos);
		write_to_log(zwi);
	}
	f=0;
	for(;;){
		rc=read_line(fp, line, sizeof(line));
		if(rc==EOF) break;
		if(line[0]!='#' &&
		   line[0]!=0){
			word(line, maccmd, 1);
			ucase(maccmd);
			word(line, maccall, 2);
			sprintf(zwi, "compare >%s<->%s<", macname, maccmd);
			write_to_log(zwi);
			if(strcmp(macname, maccmd)==0){
				f=1;
				break;
			}
		}
	}

	if(f==0){  // is not a defined macro
		write_to_log("Could not find macro in macros.lst");
		return(-1);
	}
	strcpy(temp, "/tmp");
	if(getenv("TMP")!=NULL){
		strcpy(temp, getenv("TMP"));
	}
	sprintf(fname, "%s/%s.tmp", temp, filename);
	remove(fname);
	write_to_log(fname);
	do_save_for_macro(fname);

	sprintf(zwi, "Macro found:>%s< maccall=>%s<", line, maccall);
	write_to_log(zwi);
	sprintf(zwi, "%s/%s %s %s %s %s >/tmp/macro.out 2>/tmp/macro.err", 
			macpath, maccall, fname, parfile, filename, config_file);
	write_to_log(zwi);
	write_to_log("Before call macro");

	system(zwi);
	write_to_log("After call macro");

	// finally load the file again....
	for(t=0; t<linecnt; t++){
		if(lineptr[t]!=NULL){
			free(lineptr[t]);
			lineptr[t]=NULL;
		}
		if(linecmd[t]!=NULL){
			free(linecmd[t]);
			linecmd[t]=NULL;
		}
		linetype[t]='N';
	}

	fp=fopen(fname, "rb+");
	if(fp==NULL){
		write_to_log("Could not open infile for macro");
		return(-1);
	}
	strcpy(zwi, "**************************** Top of Data *******************************");
	lineptr[0]=malloc(strlen(zwi)+1);
	strcpy(lineptr[0], zwi);
	linetype[0]='T';
	linecmd[0]=malloc(7);
	strcpy(linecmd[0], "      ");
	for(t=1;;t++){
		rc=read_line(fp, line, sizeof(line));
		if(rc==EOF) break;
		linetype[t]=line[6];
		l=strlen(line+7);
		// sprintf(zwi, "l=%d", l);
		// write_to_log(zwi);
		lineptr[t]=malloc(l+1);
		strcpy(lineptr[t], line+13);
		linecmd[t]=malloc(7);
		strcpy(zwi, line+7);
		zwi[6]=0;
		strcpy(linecmd[t], zwi);
	}
	fclose(fp);
	strcpy(zwi, "************************** Bottom of Data ******************************");
	lineptr[t]=malloc(strlen(zwi)+1);
	strcpy(lineptr[t], zwi);
	linetype[t]='T';
	linecmd[t]=malloc(7);
	strcpy(linecmd[t], "      ");
	linecnt=t+1;
	if(linecnt<0){
		linecnt=0;
	}

	set_to_space(screen_commandline, 80);

	write_to_log("End of handle macro");
	// remove(fname);
	return(1); // cursor at beginning of command line
}
/******************************************************************************/
int process_commandline(void)
{
// process the command line and line commands

	char zwi[1024];
	char orizwi[1024];
	char zwi2[1024];
	char macroname[1024];
	int a;
	int c;
	int f;
	int t, i;
	int rc;
	int curpos; // needed for remove_empty_insert_lines


	strcpy(zwi, screen_commandline);
	trim(zwi); 
	strcpy(orizwi, zwi); 
	word(screen_commandline, zwi, 1);
	ucase(zwi); 
	// sprintf(zwi2, "zwi=>%s< %d", zwi, zwi[0]);
	// write_to_log(zwi2);

	f=0;
	if(strcmp(zwi, "RES")==0 || strcmp(zwi, "RESET")==0){
		strcpy(screen_errormsg, "");
		strcpy(screen_errormessage, "");
		set_to_space(screen_commandline, 80);
		cursor_x=14;
		cursor_y=3;
		screen_errform=0;
		remove_empty_insert_lines(&curpos);
		remove_message_lines();
		remove_error_lines();
		unexclude_lines();
		return(1); // cursor at beginning of command line
	}
	if(strcmp(zwi, "L")==0 || strcmp(zwi, "LOC")==0){
		word(orizwi, zwi2, 2);
		a=atoi(zwi2);
		if(a<1){
			strcpy(screen_errormsg, "Invalid parameter");
			strcpy(screen_errormessage, "Invalid line number for LOC command.");
			return(1); // cursor at beginning of command line
		}
		if(a>(linecnt+1)){
			a=linecnt-1;
		}
		strcpy(screen_errormsg, "");
		strcpy(screen_errormessage, "");
		set_to_space(screen_commandline, 80);
		cursor_x=14;
		cursor_y=3;
		screen_errform=0;
      screen_offset_y=a;
		return(1); // cursor at beginning of command line
	}
	if(f==0 && strcmp(zwi, "COLS")==0){
		set_to_space(screen_commandline, 80);
		switch(screen_cols){
			case 0: screen_cols=1; 
					  screen_lines=19;
					  screen_topline=5;
			        break;
			case 1: screen_cols=0; 
					  screen_lines=20;
					  screen_topline=4;
					  break;
		}
		cursor_x=14;
		cursor_y=3;
		return(1); // cursor at beginning of command line
	}
	if(f==0 && (strcmp(zwi, "CANCEL")==0 || strcmp(zwi, "CAN")==0)){
		if(source_changed==TRUE){
			strcpy(screen_errormsg, "Unsaved changes!");
			sprintf(screen_errormessage, 
			   "File %s was changed and not saved.", filename);
	 		current_screen=SCREEN_QUESTION;
			strcpy(question, "Discard all changes to this file?");
			f=1;
		}
		else{
			endwin();
			puts("Normal termination (CANCEL).");
			exit(0);
		}
	}
	if(f==0 && strcmp(zwi, "SAVE")==0){
		strcpy(screen_errormsg, "File saved.");
		sprintf(screen_errormessage, "File %s saved.", filename);
		set_to_space(screen_commandline, 80);
		cursor_x=14;
		cursor_y=3;
		do_save();
		return(1); // cursor at beginning of command line
		f=1;
	}
	if(f==0 && strcmp(zwi, "SAVE4MACRO")==0){
		strcpy(screen_errormsg, "File 4macro saved.");
		sprintf(screen_errormessage, "File %s 4macro saved.", filename);
		set_to_space(screen_commandline, 80);
		cursor_x=14;
		cursor_y=3;
		sprintf(zwi, "%s.4mac", filename);
		do_save_for_macro(zwi);
		return(1); // cursor at beginning of command line
		f=1;
	}
	if(f==0 && strncmp(zwi, "LOAD ", 5)==0){
		word(orizwi, filename, 2);
		strcpy(screen_errormsg, "File loaded.");
		sprintf(screen_errormessage, "File %s loaded.", filename);
		set_to_space(screen_commandline, 80);
		cursor_x=14;
		cursor_y=3;
		load_file(filename);
		set_to_space(screen_commandline, 80);
		return(1); // cursor at beginning of command line
		f=1;
	}
	// don't ignore the parameters!
	strcpy(zwi, orizwi);
	ucase(zwi);
	if(f==0 && strncmp(zwi, "FIND ", 5)==0 || strncmp(zwi, "F ", 2)==0){
		do_find(orizwi);
		set_to_space(screen_commandline, 80);
		cursor_x=14;
		cursor_area=CUR_TEXTAREA; 
		// return(1); // cursor at beginning of command line
		// return(0); // process RETURN key                
		return(0); // leave cursor where it is
	}
	if(strlen(zwi)==0){ // empty command line, no error...
		f=1;
	}

	rc=0;
	if(f==0){
		rc=handle_macro(zwi);
	}
	if(rc==-1){
		strcpy(screen_errormsg, "Invalid command");
		strcpy(zwi2, screen_commandline);
		trim(zwi2);
		sprintf(screen_errormessage, "%s is not an editor command.", zwi2);
		return(1); // cursor at beginning of command line
	}

	// now process line commands

	for(t=0; t<linecnt; t++){
		if(strcmp(linecmd[t], "      ")!=0){
			strcpy(zwi, linecmd[t]);
			trim(zwi);
			c=toupper(zwi[0]);
			f=0;
			if(c=='='){ // message line..
				f=1;
			}
			if(c=='I'){
				a=atoi(zwi+1);
				if(a==0){
					a=1;
				}
				for(i=0; i<a; i++){
					insert_one_empty_line(t+1);
				}
				cursor_x=8;
				cursor_area=CUR_TEXTAREA; 
				strcpy(linecmd[t], "      ");
				f=1;
			}
			if(c=='D'){
				a=atoi(zwi+1);
				if(a==0){
					a=1;
				}
				for(i=0; i<a; i++){
					delete_one_line(t);
				}
				strcpy(linecmd[t], "      ");
				cursor_y--;
				source_changed=TRUE;
				f=1;
			}
			if(c=='R'){
				a=atoi(zwi+1);
				if(a==0){
					a=1;
				}
				for(i=0; i<a; i++){
					insert_one_empty_line(t+1);
					linetype[t+1]='N';
					strcpy(lineptr[t+1], lineptr[t]);
				}
				strcpy(linecmd[t], "      ");
				source_changed=TRUE;
				f=1;
			}
			if(c=='X'){
				a=atoi(zwi+1);
				if(a==0){
					a=1;
				}
				for(i=0; i<a; i++){
					if((t+i)>linecnt) break;
					linetype[t+i]='X';
				}
				strcpy(linecmd[t], "      ");
				source_changed=FALSE;
				f=1;
			}
			if(f==0){
				strcpy(screen_errormsg, "Invalid line cmd");
				sprintf(screen_errormessage, "Invalid line command %s", zwi);
			}
		}
	}
	return(rc); // 0 = leave cursor where it is
	            // 1 = beginning of command line
}
/******************************************************************************/
#define RETURN_NOTHING 0
#define RETURN_UP    1 
#define RETURN_DOWN  2 
#define RETURN_LEFT  3 
#define RETURN_RIGHT 4 
#define RETURN_HOME  5 
#define RETURN_TAB   6 
#define RETURN_ENTER 7 
int process_input_field(int c, unsigned char *s, int startx, int len)
{
	int t;
	int i;
	int a;
	int rc;
	char zwi[1024];
	int endx;

	// sprintf(zwi, "process_input_field: c=%d", c);
	// write_to_log(zwi);

	endx=startx+len;

		// sprintf(zwi, "c=%d screen_offset_y=%d", c, screen_offset_y);
		// write_to_log(zwi);

		switch(c){
		case KEY_ENTER: 
							// remove_empty_insert_lines();
							rc=process_commandline();
							if(rc==1){
								cursor_x=14;
								cursor_y=3;
								return(0);
							}
							if(rc==2){
								return(0);
							}
							return(RETURN_ENTER);
		               break;
		case KEY_NPAGE: 
		case KEY_F8: 
							strcpy(zwi, screen_commandline);
							trim(zwi);
							ucase(zwi);
							if(strcmp(zwi, "M")==0 ||
							   strcmp(zwi, "MAX")==0){
								strcpy(zwi, "999999");
							}
		               if(isdigit(zwi[0])==0 && 
								zwi[0]!=0 &&
							   zwi[0]!=' '){
								strcpy(screen_errormsg, "Invalid amount");
								sprintf(screen_errormessage, "Invalid scroll amount %s, not numeric.", screen_commandline);
								return(0);
		               }
							else{
								a=atoi(zwi);
								set_to_space(screen_commandline, 80);
								if(a==0){
									if(cursor_y>4){
										a=cursor_y-4;
										if(screen_cols==1) a--;
										cursor_y-=a;
									}
									else{
										a=20;
									}
								}
							}
		               screen_offset_y+=a;
		               if(screen_offset_y>=linecnt){
								screen_offset_y=linecnt-19;
								if(screen_offset_y<0){
									screen_offset_y=0;
								}
							}
							cursor_x=14;
		               break;
		case KEY_PPAGE: 
		case KEY_F7: 
							strcpy(zwi, screen_commandline);
							trim(zwi);
							ucase(zwi);
							if(strcmp(zwi, "M")==0 ||
							   strcmp(zwi, "MAX")==0){
								strcpy(zwi, "999999");
							}
	               	if(isdigit(zwi[0])==0 &&
								zwi[0]!=0 &&
							   zwi[0]!=' '){
								strcpy(screen_errormsg, "Invalid amount");
								strcpy(screen_errormessage, "Invalid scroll amount, not numeric.");
								return(0);
	               	}
							else{
								a=atoi(zwi);
								set_to_space(screen_commandline, 80);
								if(a==0){
									if(cursor_y>4){
										a=cursor_y-4;
										if(screen_cols==1) a--;
										cursor_y-=a;
									}
									else{
										a=20;
									}
								}
							}
		               screen_offset_y-=a;
		               if(screen_offset_y<0){
								screen_offset_y=0;
							}
							cursor_x=14;
		               break;
		case KEY_HOME: c=RETURN_HOME; 
		               break;
		case KEY_BACKSPACE:   
							cursor_x--;
							// printf("cursor_x=%d startx=%d\n", cursor_x, startx);
							if(cursor_x<startx){
							 	cursor_x=startx;
							}
							else{
								for(t=cursor_x-startx; t<len; t++){
									s[t]=s[t+1];
								}
								s[len-1]=' ';
								s[len]=0;
							}
							break;
		case KEY_UP:   c=RETURN_UP;
							break;
		case KEY_RIGHT:cursor_x++; 
							if(cursor_x==endx){
								c=RETURN_RIGHT;
							} 
							break;
		case KEY_LEFT: cursor_x--; 
							if(cursor_x<startx){
							 	cursor_x=startx;
								c=RETURN_LEFT;
							}
							break;
		case KEY_DOWN: c=RETURN_DOWN;
							break;
		case KEY_STAB: c=RETURN_TAB;
							break;
		case KEY_DC:   for(t=cursor_x-startx; t<len; t++){
								s[t]=s[t+1];
							}
							s[len-1]=' ';
							s[len]=0;
							break;
		case KEY_IC:   if(s[len-1]==' '){
								for(t=len-1; t>(cursor_x-startx); t--){
									s[t]=s[t-1];
								}
								s[cursor_x-startx]=' ';
								s[len]=0;
							}
							break;
		default:
			if(isprint(c)){
				// sprintf(zwi, "cursor_x=%d startx=%d", cursor_x, startx);
				// write_to_log(zwi);
				s[cursor_x-startx]=c;
				cursor_x++;
				if(cursor_area==CUR_TEXTAREA){
					source_changed=TRUE;
				}
				if(cursor_x==endx){
					c=RETURN_RIGHT;
				}
			}
		}
		return(c);
}
/******************************************************************************/
int now_handle_input_key_question(int c)
{
	if(c==KEY_F1){
		endwin();
		puts("Normal termination (CANCEL).");
		exit(0);
	}

	if(c==KEY_F12){
		current_screen=SCREEN_EDITOR;
		set_to_space(screen_commandline, 80);
		cursor_x=14;
		cursor_y=3;
	 	cursor_area=CUR_CMDLINE; 
		strcpy(screen_errormsg, "Cancel cancelled");
		sprintf(screen_errormessage, "Cancel command aborted, still unsaved changes.");
	}

	return(0);
}
/******************************************************************************/
int now_handle_input_key_editor(int c)
{
	char zwi[1024];
	char zwi2[1024];
	int a;
	int rc;
	int pos;
	int curpos;
	int t, i;

	// sprintf(zwi, "now_handle_input_key_editor: cursor_area=%d c=%d cursor_x=%d", cursor_area, c, cursor_x);
	// write_to_log(zwi);

	if(c==KEY_F1){
		switch(screen_errform){
			case 0: screen_errform=1;
				     break;
			case 1: screen_errform=0;
				     break;
			default: screen_errform=0;
			        break;
		}
		return(0);
	}

	if(c==KEY_F5){
		sprintf(zwi, "find %s", rfind_needle);
		do_find(zwi);
		return(0);
	}

	if(c==KEY_F3){
		rc=do_save();
		endwin();
		if(rc==TRUE){
			puts("Saved..");
		}
		puts("Normal termination (F3).");
		exit(0);
	}

	if(c==KEY_F1){
		if(screen_errform==0){
			screen_errform=1;
		}
		else{
			screen_errform=0;
		}
		return(0);
	}

	if(cursor_area==CUR_CMDLINE){
		rc=process_input_field(c, screen_commandline, 14, 48);
		switch(rc){
			case RETURN_ENTER: cursor_area=CUR_LINENBR; 
			            cursor_x=1;
							cursor_y=screen_topline;
						   break;
			case RETURN_HOME: cursor_area=CUR_CMDLINE; 
			            cursor_x=14;
							cursor_y=3;
						   break;
			case RETURN_UP: cursor_area=CUR_TEXTAREA; 
						   cursor_y=24;
						   break;
			case RETURN_DOWN: cursor_area=CUR_TEXTAREA; 
							cursor_y+=1;
			            break;
			case RETURN_LEFT: 
							if(cursor_x<8){
								cursor_area=CUR_TEXTAREA; 
								cursor_x=79;
								cursor_y=23;
							}
			            break;
			case RETURN_RIGHT: cursor_area=CUR_LINENBR;
								cursor_x=1;
								cursor_y=screen_topline;
			            break;
			case RETURN_TAB: cursor_area=CUR_LINENBR;
								cursor_x=1;
								cursor_y=screen_topline;
			            break;
		}
		return(0);
	}

	if(cursor_area==CUR_LINENBR){
		pos=cursor_y-screen_topline;
	   //sprintf(zwi, "LINENBR:pos=%d:cursor_y=%d cursor_x=%d screen_offset_y=%d", pos, cursor_y, cursor_x, screen_offset_y);
	   //write_to_log(zwi);
		rc=process_input_field(c, linecmd[pos+screen_offset_y], 1, 6);

	   // sprintf(zwi, "LINENBR:rc=%d:cursor_x=%d", rc, cursor_x);
	   // write_to_log(zwi);

		switch(rc){
			case RETURN_ENTER: cursor_area=CUR_LINENBR; 
							// now we can remove empty lines, finally!
							// remove_empty_insert_lines(); 
			            cursor_x=1;
							cursor_y++;
							if((cursor_y-4)>(linecnt-screen_offset_y-1)){
								cursor_y=3;
								if(cursor_x<14) cursor_x=14;
								if(cursor_x>64) cursor_x=64;
							 	cursor_area=CUR_CMDLINE; 
							}
						   break;
			case RETURN_HOME: cursor_area=CUR_CMDLINE; 
			            cursor_x=14;
							cursor_y=3;
						   break;
			case RETURN_UP: cursor_y--;
						   if(cursor_y==4){
								cursor_area=CUR_CMDLINE; 
							}
						   break;
			case RETURN_DOWN: cursor_y++;
							if(cursor_y>23){
								cursor_y=3;
								if(cursor_x<14) cursor_x=14;
								if(cursor_x>64) cursor_x=64;
							 	cursor_area=CUR_CMDLINE; 
							}
			            break;
			case RETURN_LEFT: cursor_x--;
			            if(cursor_x==8){
								cursor_area=CUR_LINENBR; 
								cursor_x=6;
							}
			            break;
			case RETURN_RIGHT: 
							cursor_x++;
							if(cursor_x>6){
								cursor_area=CUR_TEXTAREA;
								cursor_x=8;
							}
			            break;
			case RETURN_TAB: cursor_area=CUR_TEXTAREA;
								cursor_x=8;
			            break;
		}
		return(0);
	}

	if(cursor_area==CUR_TEXTAREA){
		sprintf(zwi, "screen_offset_y=%d linecnt=%d", screen_offset_y, linecnt);
		write_to_log(zwi);
		if(screen_cols==0){
			a=screen_offset_y+cursor_y-2;
		}
		else{
			a=screen_offset_y+cursor_y-3;
		}
		if(a>=linecnt){
			cursor_y=3;
			if(cursor_x<14) cursor_x=14;
			if(cursor_x>64) cursor_x=64;
			cursor_area=CUR_CMDLINE; 
			return(0);
		}
	   // sprintf(zwi, "key_editor: CUR_TEXTAREA: cursor_y=%d", cursor_y);
	   // write_to_log(zwi);
		pos=cursor_y-screen_topline;
		// sprintf(zwi2, "pos=%d screen_offset_y=%d", pos, screen_offset_y);
		// write_to_log(zwi2);
		curpos=pos+screen_offset_y;
		if(linetype[curpos]=='N' ||
		   linetype[curpos]=='E' ||
		   linetype[curpos]=='I'){
			strcpy(zwi, lineptr[curpos]);
			expand_to_256_bytes(zwi);
			free(lineptr[curpos]);
			lineptr[curpos]=malloc(strlen(zwi)+1);
			strcpy(lineptr[curpos], zwi);
			rc=process_input_field(c, lineptr[curpos], 8, 72);
			strcpy(zwi, lineptr[curpos]);
			rtrim(zwi);
			// sprintf(zwi2, "nach process_input_field: zwi=>%s<", zwi);
			// write_to_log(zwi2);
			free(lineptr[curpos]);
			lineptr[curpos]=malloc(strlen(zwi)+1);
			strcpy(lineptr[curpos], zwi);
		}
		else{
			rc=c;
			switch(c){
				case KEY_UP    :   rc=RETURN_UP; break;
				case KEY_DOWN  :   rc=RETURN_DOWN; break;
				case KEY_LEFT  :   rc=RETURN_LEFT; break;
				case KEY_RIGHT :   rc=RETURN_RIGHT; break;
				case KEY_ENTER :   rc=RETURN_ENTER; break;
				case KEY_STAB  :   rc=RETURN_TAB; break;
				case KEY_HOME  :   rc=RETURN_HOME; break;
			}
		}

	   // sprintf(zwi, "TEXTAREA:rc=%d:cursor_x=%d", rc, cursor_x);
	   // write_to_log(zwi);
		switch(rc){
			case RETURN_ENTER: 
							// cursor_area=CUR_LINENBR; // No, stay in textarea!!
							// now we can remove empty lines, finally!
							remove_empty_insert_lines(&curpos); 
			            cursor_x=8;
							cursor_y++;
							// if((cursor_y-4)>(linecnt-screen_offset_y-1)){
							if(cursor_y>23){
								if(screen_cols==0){
									a=screen_offset_y+23-2;
								}
								else{
									a=screen_offset_y+23-3;
								}
								if(a<linecnt){
									cursor_y--;
									screen_offset_y++;
									// jump to first non space character in line
									strcpy(zwi, lineptr[curpos+1]);
									sprintf(zwi2, "zwi=>%s<", zwi);
									write_to_log(zwi2);
									for(t=0;;t++){
										if(zwi[t]==0) break;
										if(zwi[t]!=' ') break;
									}
									cursor_x=8+t;
								}
								else{
									cursor_y=3;
									if(cursor_x<14) cursor_x=14;
									if(cursor_x>64) cursor_x=64;
							 		cursor_area=CUR_CMDLINE; 
								}
							}
							else{
								// jump to first non space character in line
								strcpy(zwi, lineptr[curpos+1]);
								sprintf(zwi2, "zwi=>%s<", zwi);
								write_to_log(zwi2);
								for(t=0;;t++){
									if(zwi[t]==0) break;
									if(zwi[t]!=' ') break;
								}
								// sprintf(zwi2, "first non blank char at %d", t);
								// write_to_log(zwi2);
								cursor_x=8+t;
							}
						   break;
			case RETURN_HOME: cursor_area=CUR_CMDLINE; 
			            cursor_x=14;
							cursor_y=3;
						   break;
			case RETURN_UP: cursor_y--;
						   if(cursor_y==3){
								cursor_area=CUR_CMDLINE; 
							}
						   break;
			case RETURN_DOWN: cursor_y++;
							// if(cursor_y>screen_lastline){
							if(cursor_y>23){
								cursor_y=3;
								if(cursor_x<14) cursor_x=14;
								if(cursor_x>64) cursor_x=64;
							 	cursor_area=CUR_CMDLINE; 
							}
			            break;
			case RETURN_LEFT: cursor_x--;
			            if(cursor_x<8){
								cursor_area=CUR_LINENBR; 
								cursor_x=6;
							}
			            break;
			case RETURN_RIGHT: cursor_area=CUR_LINENBR;
								cursor_x=1;
								cursor_y++;
								if(cursor_y>screen_lastline){
									cursor_y=3;
									if(cursor_x<14) cursor_x=14;
									if(cursor_x>64) cursor_x=64;
							 		cursor_area=CUR_CMDLINE; 
								}
			               break;
			case RETURN_TAB: cursor_area=CUR_LINENBR;
								cursor_x=1;
								cursor_y++;
								if(cursor_y>screen_lastline){
									cursor_area=CUR_CMDLINE; 
			            		cursor_x=14;
									cursor_y=3;
								}
			               break;
		}
	}
	return(0);
}
/******************************************************************************/
int handle_keypress(void)
{
	int c;
	int i;
	char zwi[1024];

	c=get_keypress();
		/*********************************************************************
		switch(c){
			case KEY_ESCAPE: sprintf(zwi, "KEY_ESCAPE  pressed."); break;
			case KEY_F1: sprintf(zwi, "KEY_F1  pressed."); break;
			case KEY_F2: sprintf(zwi, "KEY_F2  pressed."); break;
			case KEY_F3: sprintf(zwi, "KEY_F3  pressed."); break;
			case KEY_F4: sprintf(zwi, "KEY_F4  pressed."); break;
			case KEY_F5: sprintf(zwi, "KEY_F5  pressed."); break;
			case KEY_F6: sprintf(zwi, "KEY_F6  pressed."); break;
			case KEY_F7: sprintf(zwi, "KEY_F7  pressed."); break;
			case KEY_F8: sprintf(zwi, "KEY_F8  pressed."); break;
			case KEY_F9: sprintf(zwi, "KEY_F9  pressed."); break;
			case KEY_F10: sprintf(zwi, "KEY_F10 pressed."); break;
			case KEY_F11: sprintf(zwi, "KEY_F11 pressed."); break;
			case KEY_F12: sprintf(zwi, "KEY_F12 pressed."); break;
			case KEY_UP: sprintf(zwi, "KEY_UP pressed."); break;
			case KEY_DOWN: sprintf(zwi, "KEY_DOWN pressed."); break;
			case KEY_LEFT: sprintf(zwi, "KEY_LEFT pressed."); break;
			case KEY_RIGHT: sprintf(zwi, "KEY_RIGHT pressed."); break;
			case KEY_HOME: sprintf(zwi, "KEY_HOME pressed."); break;
			case KEY_END: sprintf(zwi, "KEY_END pressed."); break;
			case KEY_STAB: sprintf(zwi, "KEY_STAB pressed."); break;
			case KEY_BACKSPACE: sprintf(zwi, "KEY_BACKSPACE pressed."); break;
			case KEY_IC: sprintf(zwi, "KEY_IC pressed."); break;
			case KEY_DC: sprintf(zwi, "KEY_DC pressed."); break;
			case KEY_PPAGE: sprintf(zwi, "KEY_PPAGE pressed."); break;
			case KEY_NPAGE: sprintf(zwi, "KEY_NPAGE pressed."); break;
			default: sprintf(zwi, "Unknown key >%d<.", c); break;

		}
		write_to_log(zwi);
		*********************************************************************/

	switch(current_screen){
		case SCREEN_EDITOR: 
							now_handle_input_key_editor(c);
		               break;
		case SCREEN_QUESTION: 
		               draw_screen_question();
							now_handle_input_key_question(c);
		               break;
	}

	return(TRUE);
}
/*****************************************************************************/
int main(int argc, char **argv)
{
	int c=0;
	int rc=0;
	int f;
	int t;
	int forecolor=COLOR_GREEN;
	int backcolor=COLOR_BLACK;
	char zwi[1024];
	FILE *fp;

	// find out which config file we have
	sprintf(config_file, "%s/pipedit.cfg", getenv("PWD"));
	fp=fopen(config_file, "rb");
	if(fp==NULL){
		sprintf(config_file, "%s/.pipedit/pipedit.cfg", getenv("HOME"));
		fp=fopen(config_file, "rb");
		if(fp==NULL){
			strcpy(config_file, "<<<NONE>>>");
		}
		else{
			fclose(fp);
		}
	}
	else{
		fclose(fp);
	}

	set_signals();

	for(t=0; t<MAXLINES; t++){
		lineptr[t]=NULL;
		linecmd[t]=NULL;
		linetype[t]=' ';
	}

	for(t=1;t<argc;t++){
		f=0;
		strcpy(zwi, argv[t]);
		if(strcmp(zwi, "-log")==0){
			write_logfile=TRUE;
			f=1;
		}
		if(f==0){
			if(filename[0]==0){
				strcpy(filename, zwi);
			}
			else{
				fprintf(stderr, 
				"pipedit: invalid argument >%s<, aborting...\n", argv[t]);
				exit(1);
			}
		}
	}

	if(strlen(filename)==0){
		fprintf(stderr, "Missing filename, aborting...\n");
		exit(1); 
	} 

	/*************************************
	ptr=getenv("PIPMENSCRIPT");
	if(ptr==NULL){
		strcpy(scriptfile, "pipmenue.men");
	}
	else{
		strcpy(scriptfile, ptr);
	}
	**************************************/

	/************************************
	strcpy(zwi, "                                       ");
	cursor_x=1;
	cursor_y=1;
	for(;;){
		c=getch();
		rc=process_input_field(c, zwi, 1, 20);
		printf(">%s<\n", zwi);
	}
	******************************************/

	load_file(filename);

   initscr();
	cbreak();
	noecho();

	start_color();
	init_pair(COLPAIR_NORMAL, COLOR_GREEN, COLOR_BLACK);
	init_pair(COLPAIR_MENU, COLOR_WHITE, COLOR_BLACK);
	init_pair(COLPAIR_BLUE, COLOR_BLUE, COLOR_BLACK);
	init_pair(COLPAIR_YELLOW, COLOR_YELLOW, COLOR_BLACK);
	init_pair(COLPAIR_INSERT, COLOR_BLACK, COLOR_WHITE);
	init_pair(COLPAIR_ERRMSG, COLOR_RED, COLOR_WHITE);
	init_pair(COLPAIR_FRAME, COLOR_BLUE, COLOR_YELLOW);
	init_pair(COLPAIR_YESNO, COLOR_BLUE, COLOR_WHITE);
	init_pair(COLPAIR_XCLUD, COLOR_BLACK, COLOR_WHITE);

	attron(COLPAIR_NORMAL);

  	clear();

	screen_x=0;
	screen_y=0;

	cursor_area=CUR_CMDLINE;
	set_to_space(screen_commandline, 80);
	for(;;){
		draw_screen();
		if(handle_keypress()==FALSE) break;;
	}

	terminate_program("Normal termination.");

	return(rc);
}

