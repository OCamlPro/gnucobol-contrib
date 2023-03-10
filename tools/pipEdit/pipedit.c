/***************************************************************************
Errors:

   DEL command problems with current line and displayed screen

***process_commandline() - using a wrong delimiter does not cause an error

***implement block commands, cc, dd, rr, xx ###JG###

   error at typing at last line of file

****************************************************************************/
/******************************************************************************
 +----------+-------+---------------------------------------------------------+
 | 20210414 | 0.8.6 | Fixed INS/DEL keys, recognized now as changed source    |
 +----------+-------+---------------------------------------------------------+
 | 20200921 | 0.8.5 | line commands c and m + a/b, del all nx/x               |
 +----------+-------+---------------------------------------------------------+
 | 20200520 | 0.8.4 | Bugfix for CC and A/D                                   |
 +----------+-------+---------------------------------------------------------+
 | 20200429 | 0.8.3 | show cursor x/y when pressing left right up down key    |
 +----------+-------+---------------------------------------------------------+
 | 2019nnnn | 0.8.2 | Block commands RR DD XX CC A B                          |
 +----------+-------+---------------------------------------------------------+
 ******************************************************************************/
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <ctype.h>
# include <time.h>
# include <signal.h>

# define SHORTVERSION "pipEdit 0.8.6 2021-04-14"
# define VERSION "pipEdit 0.8.6 - 2021-04-11 - INS/DEL keys change source"

# ifdef __USE_PIPCURSES__
	# include "pipcurses.c"
# else
	#if defined (HAVE_CURSES_H)
	# include <curses.h>
	#elif defined (HAVE_PDCURSES_H)
	# include <pdcurses.h>
	#else
	# include <ncurses.h>
	#endif
	# undef KEY_ENTER
	# define KEY_ENTER 10 // overwrite the curses #define with the real value
	# undef KEY_STAB
	# define KEY_STAB 9   // overwrite the curses #define with the real value
	# define KEY_ESCAPE 27
	# define KEY_F1 KEY_F(1)
	# define KEY_F2 KEY_F(2)
	# define KEY_F3 KEY_F(3)
	# define KEY_F4 KEY_F(4)
	# define KEY_F5 KEY_F(5)
	# define KEY_F6 KEY_F(6)
	# define KEY_F7 KEY_F(7)
	# define KEY_F8 KEY_F(8)
	# define KEY_F9 KEY_F(9)
	# define KEY_F10 KEY_F(10)
	# define KEY_F11 KEY_F(11)
	# define KEY_F12 KEY_F(12)
	# undef KEY_SEND
	# define KEY_SEND 386
# endif

# ifndef TRUE
   # define TRUE (0==0)
   # define FALSE (0!=0)
# endif

// function keys, assigned in *.cfg file
char fkey1[128]="";
char fkey2[128]="";
char fkey3[128]="";
char fkey4[128]="";
char fkey5[128]="";
char fkey6[128]="";
char fkey7[128]="";
char fkey8[128]="";
char fkey9[128]="";
char fkey10[128]="";
char fkey11[128]="";
char fkey12[128]="";
char fkeypgup[128]="";
char fkeypgdown[128]="";

# define MAXLINES 256000
unsigned char *lineptr[MAXLINES];
unsigned char *linecmd[MAXLINES];
unsigned char linetype[MAXLINES];
int real_linenbr[MAXLINES];
int linecnt=0;
int current_line=0;
int cursor_x=14;
int cursor_y=3;

int source_changed=FALSE;

# define MAX_COMMAND_STACK 32
char *command_stack[MAX_COMMAND_STACK];

# define CUR_CMDLINE   1
# define CUR_MENU      2
# define CUR_LINENBR   3
# define CUR_TEXTAREA  4
int cursor_area=CUR_CMDLINE;

# define SCREEN_EDITOR     0
# define SCREEN_QUESTION   1
int current_screen=SCREEN_EDITOR;
char question[80]="";

unsigned char screen_commandline[80];
char screen_errormsg[256]="";
char screen_errormessage[256]="";
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
int restart_from_top=FALSE;
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
# define COLPAIR_CURLIN 10

char config_file[256];
char conf_langfiles[256]=""; // where are language files stored at?
char conf_language[256]="";  // use which language?
char conf_delimiter=',';     // delimiter for command line
char conf_macros[256]="";    // where are macros located

char lang_file[32]="File";
char lang_edit[32]="Edit";
char lang_edit_settings[32]="Edit_settings";
char lang_menu[32]="Menu";
char lang_utilities[32]="Utilities";
char lang_compilers[32]="Compilers";
char lang_test[32]="Test";
char lang_help[32]="Help";
char lang_columns[32]="Columns";
char lang_command[32]="Command";
char lang_top_of_data[32]="Top of Data";
char lang_bottom_of_data[32]="Bottom of data";
/******************************************************************************/
void set_signals(void);
void signal_handler(int signal)
{
	#ifdef SIGINT
	if(signal==SIGINT){
		puts("SIGINT -> ignored...");
		set_signals();
		return;
	}
	#endif
	#ifdef SIGUSR1
	if(signal==SIGUSR1){
		puts("SIGUSR1 -> ignored...");
		set_signals();
		return;
	}
	#endif
	#ifdef SIGUSR2
	if(signal==SIGUSR2){
		puts("SIGUSR2 -> ignored...");
		set_signals();
		return;
	}
	#endif
	#ifdef SIGCHLD
	if(signal==SIGCHLD){
		/* puts("SIGCHLD -> ignored..."); */
		set_signals();
		return;
	}
	#endif
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
void expand_to_nnn_bytes(int nnn, char *s)
{
	int l;

	l=strlen(s);
	for(;;){
		if(l>nnn) break;
		// if(l>256) break;
		strcat(s, "                                        ");
		l+=40;
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
void set_to_space(unsigned char *s, int amount)
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
	int c=0;
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
void add_to_command_stack(char *s)
{
	int t;

	if(command_stack[0]!=NULL){
		free(command_stack[0]);
	}

	for(t=0; t<(MAX_COMMAND_STACK-1); t++){
		command_stack[t]=command_stack[t+1];
	}
	command_stack[MAX_COMMAND_STACK-1]=malloc(strlen(s)+1);
	strcpy(command_stack[MAX_COMMAND_STACK-1], s);
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
void read_config_file(void)
{
	FILE *fp;
	char zwi[256];
	int t;

	fp=fopen(config_file, "rb");
	if(fp==NULL){
		sprintf(zwi, "Could not open config file >%s<, aborting..", config_file);
		write_to_log(zwi);
		fprintf(stderr, "%s\n", zwi);
		exit(5);
	}
	for(;;){
		if(read_line(fp, zwi, sizeof(zwi))==EOF) break;
		if(strncmp(zwi, "language=", 9)==0){
			strcpy(conf_language, zwi+9);
		}
		if(strncmp(zwi, "langfiles=", 10)==0){
			strcpy(conf_langfiles, zwi+10);
		}
		if(strncmp(zwi, "macros=", 7)==0){
			strcpy(conf_macros, zwi+7);
		}
		if(strncmp(zwi, "delimiter=", 10)==0){
			conf_delimiter=zwi[10];
		}
		if(strncmp(zwi, "F1=", 3)==0){ strcpy(fkey1, zwi+3); }
		if(strncmp(zwi, "F2=", 3)==0){ strcpy(fkey2, zwi+3); }
		if(strncmp(zwi, "F3=", 3)==0){ strcpy(fkey3, zwi+3); }
		if(strncmp(zwi, "F4=", 3)==0){ strcpy(fkey4, zwi+3); }
		if(strncmp(zwi, "F5=", 3)==0){ strcpy(fkey5, zwi+3); }
		if(strncmp(zwi, "F6=", 3)==0){ strcpy(fkey6, zwi+3); }
		if(strncmp(zwi, "F7=", 3)==0){ strcpy(fkey7, zwi+3); }
		if(strncmp(zwi, "F8=", 3)==0){ strcpy(fkey8, zwi+3); }
		if(strncmp(zwi, "F9=", 3)==0){ strcpy(fkey9, zwi+3); }
		if(strncmp(zwi, "F10=", 4)==0){ strcpy(fkey10, zwi+4); }
		if(strncmp(zwi, "F11=", 4)==0){ strcpy(fkey11, zwi+4); }
		if(strncmp(zwi, "F12=", 4)==0){ strcpy(fkey12, zwi+4); }
		if(strncmp(zwi, "PGUP=", 5)==0){ strcpy(fkeypgup, zwi+5); }
		if(strncmp(zwi, "PGDOWN=", 7)==0){ strcpy(fkeypgdown, zwi+7); }
		// no error handling of unknown entries, they might be for
		// macros, who might read this cfg file too
	}
	fclose(fp);
	if(strlen(conf_language)==0){
		if(getenv("LANG")==NULL){
			strcpy(conf_language, "en");
		}
		else{
			strcpy(conf_language, getenv("LANG"));
			for(t=0;;t++){
				if(conf_language[t]==0) break;
				if(conf_language[t]=='_'){
					conf_language[t]=0;
					break;
				}
			}
		}
	}
	// printf("langfiles=>%s<\n", conf_langfiles);
	// printf("language=>%s<\n", conf_language);
	// exit(99);
}
/******************************************************************************/
void read_language_stuff(void)
{
	FILE *fp;
	char zwi[256];
	char zwi2[256];
	int t;

	if(strcmp(conf_language, "default")==0){ // okay, use the default values
		return;
	}

	sprintf(zwi, "%s/pipedit.%s", conf_langfiles, conf_language);
	// printf("zwi=>%s< conf_langfiles=>%s<\n", zwi, conf_langfiles);
	// exit(99);

	fp=fopen(zwi, "rb");
	if(fp==NULL){
		sprintf(zwi2, "Could not open language file >%s<, aborting..", zwi);
		write_to_log(zwi2);
		fprintf(stderr, "%s\n", zwi2);
		exit(5);
	}
	for(;;){
		if(read_line(fp, zwi, sizeof(zwi))==EOF) break;
		if(strncmp(zwi, "FILE=", 5)==0){
			strcpy(lang_file, zwi+5);
		}
		if(strncmp(zwi, "EDIT=", 5)==0){
			strcpy(lang_edit, zwi+5);
		}
		if(strncmp(zwi, "EDIT_SETTINGS=", 14)==0){
			strcpy(lang_edit_settings, zwi+14);
		}
		if(strncmp(zwi, "MENU=", 5)==0){
			strcpy(lang_menu, zwi+5);
		}
		if(strncmp(zwi, "UTILITIES=", 10)==0){
			strcpy(lang_utilities, zwi+10);
		}
		if(strncmp(zwi, "COMPILERS=", 10)==0){
			strcpy(lang_compilers, zwi+10);
		}
		if(strncmp(zwi, "TEST=", 5)==0){
			strcpy(lang_test, zwi+5);
		}
		if(strncmp(zwi, "HELP=", 5)==0){
			strcpy(lang_help, zwi+5);
		}
		if(strncmp(zwi, "COLUMNS=", 8)==0){
			strcpy(lang_columns, zwi+8);
		}
		if(strncmp(zwi, "COMMAND=", 8)==0){
			strcpy(lang_command, zwi+8);
		}
		if(strncmp(zwi, "TOP_OF_DATA=", 12)==0){
			strcpy(lang_top_of_data, zwi+12);
		}
		if(strncmp(zwi, "BOTTOM_OF_DATA=", 15)==0){
			strcpy(lang_bottom_of_data, zwi+15);
		}
		// no error handling of unknown entries, they might be for
		// macros, who might read this cfg file too
	}
	fclose(fp);
}
/******************************************************************************/
void draw_screen_editor(void)
{
	int a;
	char zwi[4096+80];
	char zwi2[4096+80];
	int colpairline=-1; // different color for line nbr and line text
	int t, i;
	int ypos;
	int cnt;
	int end;
	int z;
	int zz;
	char columns[4097]="----+-A--1-B--+----2----+----3----+----4----+----5----+----6----+----7--C-+----8----+----9----+----10---+----11---+----12---+----13---+----14---+----15---+----16---+----17---+----18---+----19---+----20---+----21---+----22---+----23---+----24---+----25---+----26---+----27---+----28---+----29---+----30---+----31---+----32---+----33---+----34---+----35---+----36---+----37---+----38---+----39---+----40---+----41---+----42---+----43---+----44---+----45---+----46---+----47---+----48---+----49---+----50";

	for(t=0; t<4096; t++){
		columns[t]=' ';
	}
	for(t=0, z=5, zz=0; t<4096; t++){
		if(columns[t]==' '){
			columns[t]='-';
		}
		z++;
		if(z==10){
			z=0;
			columns[t]='+';
		}
		zz++;
		if(zz==10){
			zz=0;
			columns[t]='*';
			a=t+1;
			a/=10;
			sprintf(zwi, "%d", a);
			for(i=0;;i++){
				if(zwi[i]==0) break;
				columns[t+i]=zwi[i];
			}
		}
	}
	columns[4096]=0;
	columns[6]='A';
	columns[11]='B';
	columns[72]='C';

	clear();

	attron(COLOR_PAIR(COLPAIR_MENU));

	mvaddstr(0, 1, lang_file);
	mvaddstr(0, 8, lang_edit);
	mvaddstr(0, 15, lang_edit_settings);
	mvaddstr(0, 30, lang_menu);
	mvaddstr(0, 36, lang_utilities);
	mvaddstr(0, 47, lang_compilers);
	mvaddstr(0, 58, lang_test);
	mvaddstr(0, 64, lang_help);

	attron(COLOR_PAIR(COLPAIR_BLUE));

	mvaddstr(1, 0, "--------------------------------------------------------------------------------");


	mvaddstr(2, 1, "Edit");
	strcpy(zwi, filename);
	mvaddstr(2, 12, filename);
	if(source_changed==TRUE){
		attron(COLOR_PAIR(COLPAIR_YELLOW));
		mvaddstr(2, 12+strlen(filename)+1, "(changed)");
		attron(COLOR_PAIR(COLPAIR_BLUE));
	}
	mvaddstr(2, 60, lang_columns);
	sprintf(zwi, "%05d", col_start+screen_offset_x);
	mvaddstr(2, 68, zwi);
	sprintf(zwi, "%05d", col_end+screen_offset_x);
	mvaddstr(2, 74, zwi);

	attron(COLOR_PAIR(COLPAIR_NORMAL));

	sprintf(zwi, "%s ===>", lang_command);
	mvaddstr(3, 1, zwi);
	mvaddstr(3, 14, screen_commandline);
	mvaddstr(3, 63, "Scroll  ===>");
	mvaddstr(3, 75, "CSR");

	if(screen_cols==1){
		attron(COLOR_PAIR(COLPAIR_YELLOW));
		mvaddstr(4, 1, "=COLS>");
		strncpy(zwi, columns+screen_offset_x, 72);
		mvaddstr(4, 8, zwi);
		attron(COLOR_PAIR(COLPAIR_NORMAL));
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
	// sprintf(zwi, "current_line=%d screen_offset_y=%d", current_line, screen_offset_y);
	// write_to_log(zwi);
	a=current_line+screen_offset_y;
	for(t=0; t<screen_lines; t++){
		// sprintf(zwi, "t=%d a=%d linecnt=%d cursor_y=%d screen_offset_y=%d screen_topline=%d", t, a, linecnt, cursor_y, screen_offset_y, screen_topline);
		// write_to_log(zwi);
		attron(COLOR_PAIR(COLPAIR_NORMAL));
		if(a<linecnt){
			colpairline=-1;
			strcpy(zwi2, lineptr[a]);
			expand_to_nnn_bytes(screen_offset_x+80, zwi2);
			if(strcmp(linecmd[a], "      ")==0){
				switch(linetype[a]){
					case 'I':               // inserted line
						attron(COLOR_PAIR(COLPAIR_INSERT));
						sprintf(zwi, " '''''' %s", zwi2);
						break;
					case 'M':               // message line
						attron(COLOR_PAIR(COLPAIR_INSERT));
						sprintf(zwi, " %s %s", linecmd[a], zwi2);
						break;
					case 'T':               // top/bottom line
						attron(COLOR_PAIR(COLPAIR_BLUE));
						sprintf(zwi, " %s %s", linecmd[a], zwi2);
						break;
					case 'E':               // error line
						attron(COLOR_PAIR(COLPAIR_ERRMSG));
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
						a--; // we had already at least one line!
						attron(COLOR_PAIR(COLPAIR_XCLUD));
						sprintf(zwi2, "%d lines excluded - - - - - - - - - - - ",cnt);
						write_to_log(zwi2);
						sprintf(zwi, " %s %s", linecmd[a], zwi2);
						break;
				default:
				   if(t==(cursor_y-screen_topline)){
					 	attron(COLOR_PAIR(COLPAIR_CURLIN)); // current line nbr RED
						colpairline=COLPAIR_NORMAL;         // current text normal
					}
					else{
						attron(COLOR_PAIR(COLPAIR_NORMAL));
					}
					sprintf(zwi, " %06d %s", a, zwi2+screen_offset_x);
				}
				zwi[80]=0;
			}
			else{
				strcpy(glo_buff, linecmd[a]);
				rtrim(glo_buff);
				strcat(glo_buff, "      ");
				glo_buff[6]=0;
				strcpy(linecmd[a], glo_buff);
				sprintf(zwi, " %s %s", linecmd[a], zwi2+screen_offset_x);
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
		if(colpairline==-1){
			mvaddstr(screen_topline+ypos, 0, zwi);
		}
		else{
			strcpy(zwi2, zwi);
			zwi2[7]=0;
			mvaddstr(screen_topline+ypos, 0, zwi2);
		 	attron(COLOR_PAIR(colpairline));
			mvaddstr(screen_topline+ypos, 7, zwi+7);
		}
		ypos++;
		attron(COLOR_PAIR(COLPAIR_NORMAL));
		a++;
	}
	sprintf(zwi, "%02d/%02d", cursor_y+1, cursor_x+1);
	mvaddstr(0, 74, zwi);

	if(strlen(screen_errormsg)>0){
		if(screen_errform==0){
			for(;;){
				// if(strlen(screen_errormsg)>19) break;
				if(strlen(screen_errormsg)>24) break;
				strcat(screen_errormsg, " ");
			}
			attron(COLOR_PAIR(COLPAIR_ERRMSG));
			sprintf(zwi, " %s", screen_errormsg);
			mvaddstr(2, 54, zwi);
			attron(COLOR_PAIR(COLPAIR_NORMAL));
		}
		else{
			for(;;){
				if(strlen(screen_errormessage)>79) break;
				strcat(screen_errormessage, " ");
			}
			attron(COLOR_PAIR(COLPAIR_ERRMSG));
			mvaddstr(2, 0, screen_errormessage);
			attron(COLOR_PAIR(COLPAIR_NORMAL));
		}
	}

	// wmove(0, cursor_y, cursor_x);
	# ifdef __USE_PIPCURSES__
		move(cursor_y, cursor_x+1);
	# else
		move(cursor_y, cursor_x);
	# endif
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


	attron(COLOR_PAIR(COLPAIR_YELLOW));
	mvaddstr(7, b+2, "=>");
	attron(COLOR_PAIR(COLPAIR_BLUE));
	mvaddstr(7, b+4, filename);
	attron(COLOR_PAIR(COLPAIR_YELLOW));
	mvaddstr(7, b+lenb, "<=");

	attron(COLOR_PAIR(COLPAIR_BLUE));
	mvaddstr(8, a+2, question);

	attron(COLOR_PAIR(COLPAIR_YESNO));
	mvaddstr(10, a+5, " F1 = Yes ");
	mvaddstr(10, a+20," F12 = No ");

	attron(COLOR_PAIR(COLPAIR_FRAME));
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

	// wmove(0, cursor_y, cursor_x);
	move(cursor_y, cursor_x+1);
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
	int end;

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

	sprintf(zwi, "**************************** %s *******************************", lang_top_of_data);
	lineptr[0]=malloc(strlen(zwi)+1);
	strcpy(lineptr[0], zwi);
	linetype[0]='T';
	linecmd[0]=malloc(7);
	strcpy(linecmd[0], "      ");

	do_backup(fname);

	fp=fopen(fname, "rb");
	if(fp==NULL){
		// strcpy(screen_errormsg, "File not found.");
		// sprintf(screen_errormessage,"File %s not found, not loaded.",filename);
		sprintf(zwi, "************************** %s ******************************", lang_bottom_of_data);
		lineptr[1]=malloc(strlen(zwi)+1);
		strcpy(lineptr[1], zwi);
		linetype[1]='T';
		linecnt=2;
		linecmd[1]=malloc(7);
		strcpy(linecmd[1], "      ");
		end=18;
		if(screen_cols==1) end--;
		for(t=0; t<end; t++){
			insert_one_empty_line(1);
		}
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
	sprintf(zwi, "************************** %s ******************************", lang_bottom_of_data);
	lineptr[t]=malloc(strlen(zwi)+1);
	strcpy(lineptr[t], zwi);
	linetype[t]='T';
	linecmd[t]=malloc(7);
	strcpy(linecmd[t], "      ");
	t++;

	linecnt=t;

	fclose(fp);

	for(t=0; t<linecnt; t++){
		real_linenbr[t]=t;
	}
	return(TRUE);
}
/******************************************************************************/
# ifdef __USE_PIPCURSES__
int get_keypress(void)
{
	int a;
	int c;
	char zwi[1024];

	c=getch();

	// sprintf(zwi, ":1: c=%d", c); write_to_log(zwi);

	if(c==KEY_END){
		return(KEY_END);
	}

	if(c==KEY_ESCAPE){
		c=getch();
		// sprintf(zwi, ":2: c=%d", c); write_to_log(zwi);
		if(c==79){
			c=getch();
			// sprintf(zwi, ":3: c=%d", c); write_to_log(zwi);
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
				// sprintf(zwi, ":4:91: c=%d", c); write_to_log(zwi);
				// sprintf(zwi, "ESC:50: c=%d", c); write_to_log(zwi);
				return(1100+c);
			}
			if(c==51){
				a=getch(); // skip the following 126
				return(KEY_DC);
			}
			if(c==52){
				a=getch(); // skip the following 126
				if(a==52){
					return(KEY_SEND);  // shit + end
				}
				else{
					return(KEY_END);
				}
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
#else
int get_keypress(void)
{
	int a;
	int c;
	char zwi[1024];

	c=getch();

	if(c==13){
		c=10;
	}

	sprintf(zwi, ":1: c=%d", c);
	write_to_log(zwi);

	if(c==KEY_END){
		return(KEY_END);
	}

	if(c==KEY_ESCAPE){
		c=getch();
		sprintf(zwi, ":2: c=%d", c);
		write_to_log(zwi);
		if(c==91){
			c=getch();
			sprintf(zwi, ":3: c=%d", c);
			write_to_log(zwi);
			if(c==53){
				c=KEY_PPAGE;
				sprintf(zwi, ":4: c=%d", c);
				write_to_log(zwi);
				// c=getch(); // get the extra bytes
			}
			if(c==54){
				c=KEY_NPAGE;
				sprintf(zwi, ":4: c=%d", c);
				write_to_log(zwi);
				// c=getch(); // get the extra bytes
			}
			if(c==65){
				c=KEY_UP;
			}
			if(c==66){
				c=KEY_DOWN;
			}
			if(c==67){
				c=KEY_RIGHT;
			}
			if(c==68){
				c=KEY_LEFT;
			}
			if(c==72){
				c=KEY_HOME;
			}
		}
	}

	// if(c==6){
	// 	return(KEY_HOME);
	// }
	if(c==127){
		return(KEY_BACKSPACE);
	}

	return(c);
}
#endif
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
	// char zwi[1024];

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
	int t;

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
	int t;

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
	int t;

	for(t=0; t<linecnt; t++){
		if(linetype[t]=='X'){
			linetype[t]='N';
		}
	}
}
/******************************************************************************/
void exclude_all_lines(void)
{
	int t;

	for(t=0; t<linecnt; t++){
		if(linetype[t]=='N'){
			linetype[t]='X';
		}
	}
}
/******************************************************************************/
void do_right(void)
{
	char zwi[256];
	char zwi2[256];
	int a;

	strcpy(screen_errormsg, ""); // clear msg, show cursur x/y again
	strcpy(zwi, (char*)screen_commandline);
	trim(zwi);
	ucase(zwi);
	if(strcmp(zwi, "M")==0 ||
	   strcmp(zwi, "MAX")==0){
		strcpy(zwi, "4096");
	}

	sprintf(zwi2, "do_right: zwi=>%s<", zwi);
	write_to_log(zwi2);

  	if(isdigit(zwi[0])==0 &&
		zwi[0]!=0 &&
	   zwi[0]!=' '){
		strcpy(screen_errormsg, "Invalid amount");
		strcpy(screen_errormessage, "Invalid scroll amount, not numeric.");
		return;
  	}
	else{
		a=atoi(zwi);
		set_to_space(screen_commandline, 80);
		if(a==0){
			a=70;
		}
	}
   screen_offset_x+=a;
   if(screen_offset_x>4096-72){
		screen_offset_x=4096-72;
	}
	sprintf(zwi, "screen_offset_x=%d", screen_offset_x);
	write_to_log(zwi);

	cursor_x=14;
}
/******************************************************************************/
void do_left(void)
{
	char zwi[256];
	int a;

	strcpy(screen_errormsg, ""); // clear msg, show cursur x/y again
	strcpy(zwi, (char*)screen_commandline);
	trim(zwi);
	ucase(zwi);
	if(strcmp(zwi, "M")==0 ||
	   strcmp(zwi, "MAX")==0){
		strcpy(zwi, "4096");
	}
  	if(isdigit(zwi[0])==0 &&
		zwi[0]!=0 &&
	   zwi[0]!=' '){
		strcpy(screen_errormsg, "Invalid amount");
		strcpy(screen_errormessage, "Invalid scroll amount, not numeric.");
		return;
  	}
	else{
		a=atoi(zwi);
		set_to_space(screen_commandline, 80);
		if(a==0){
			a=70;
		}
	}
   screen_offset_x-=a;
   if(screen_offset_x<0){
		screen_offset_x=0;
	}
	cursor_x=14;
}
/******************************************************************************/
void do_page_up(void)
{
	char zwi[256];
	int a;

	strcpy(screen_errormsg, ""); // clear msg, show cursur x/y again
	strcpy(zwi, (char*)screen_commandline);
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
		return;
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
}
/******************************************************************************/
void do_page_down(void)
{
	char zwi[256];
	int a;

	strcpy(screen_errormsg, ""); // clear msg, show cursur x/y again
	strcpy(zwi, (char*)screen_commandline);
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
}
/******************************************************************************/
void do_find(char *s)
{
	char needle[256];
	char orineedle[256];
	char zwi[1024];
	char zwi2[1024];
	char parm[256];
	int t;
	int pos;
	int f;
	int start;
	int searchit=0;
	int findall=FALSE;


	word(s, needle, 2);
	strcpy(orineedle, needle);
	ucase(needle);

	word(s, parm, 3);
	ucase(parm);
	if(strcmp(parm, "ALL")==0){
		findall=TRUE;
	}

	start=screen_offset_y+cursor_y-screen_topline+1;

	if(strcmp(parm, "FIRST")==0){
		start=0;
	}
	if(restart_from_top==TRUE){
		start=0;
		restart_from_top=FALSE;
	}
	sprintf(zwi, "start = %d parm=%s", start, parm);
	write_to_log(zwi);

	sprintf(zwi2, "findall=%d TRUE=%d", findall, TRUE);
	write_to_log(zwi2);
	f=0;
	pos=-1;
	for(t=start; t<linecnt; t++){
		searchit=0;
		if(lineptr[t]!=NULL){    // we have dataB?
			if(linetype[t]!='T'){ // it's not a title line?
				searchit=1;        // then search in it
			}
		}
		sprintf(zwi, "t = %d searchit=%d", t, searchit);
		write_to_log(zwi);
		if(searchit==1){
			// sprintf(zwi2, "t=%d lineptr[t]=%p", t, lineptr[t]);
			// write_to_log(zwi2);
			strcpy(zwi, (char*)lineptr[t]);
			ucase(zwi);
			if(strstr(zwi, needle)!=NULL){
				if(pos==-1){
					pos=(int)(strstr(zwi, needle)-zwi);
					// sprintf(zwi2, "pos = %d", pos);
					// write_to_log(zwi2);
					// sprintf(zwi2, "zwi=>%s< needle=>%s<", zwi, needle);
					// write_to_log(zwi2);
					screen_offset_y=t-1;
					if(screen_offset_y<0){
						screen_offset_y=0;
						cursor_y=4;
					}
					else{
						cursor_y=5;
					}
					cursor_x=8+pos;
				}
				linetype[t]='N';
				strcpy(rfind_needle, needle);
				f=1;
				if(findall==FALSE){
					strcpy(zwi2, "findall==FALSE, break");
					write_to_log(zwi2);
					break;
				}
			}
		}
	}

	if(f==0){
		strcpy(screen_errormsg, "*Bottom of data reached*");
		sprintf(screen_errormessage, "Chars '%s' not found. Press RFIND key to continue from top.", orineedle);
		restart_from_top=TRUE;
	}
	else{
		sprintf(screen_errormsg, "CHARS '%s' found", orineedle);
		sprintf(screen_errormessage, "Search for CHARS '%s' in columns 1 to 80 was successful.", orineedle);
		// sprintf(zwi, "cursor_y=%d cursor_x=%d", cursor_y, cursor_x);
		// write_to_log(zwi);
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

	fprintf(fp, "msg=\n"); // short message the macro can set
	fprintf(fp, "message=\n"); // long message the macro can set
	fprintf(fp, "cursor_x=0\n"); // cursor X position the macro can set
	fprintf(fp, "cursor_y=0\n"); // cursor Y position the macro can set
	fprintf(fp, "modified=0\n"); // source code modiefied (1) or not (0)
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
	int rc=0;
	int f;
	int l;
	int pos;
	int modified;
	char zwi[256];
	char line[512];
	// char zwi2[256];
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
	strcpy(macpath, conf_macros);
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
			// sprintf(zwi, "compare >%s<->%s<", macname, maccmd);
			// write_to_log(zwi);
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
	if(getenv("TMP")!=NULL){
		strcpy(temp, getenv("TMP"));
	} else {
		strcpy(temp, "/tmp");
	}
	sprintf(fname, "%s/%s.tmp", temp, filename);
	remove(fname);
	write_to_log(fname);
	do_save_for_macro(fname);

	sprintf(zwi, "Macro found:>%s< maccall=>%s<", line, maccall);
	write_to_log(zwi);
	sprintf(zwi, "%s/%s %s %s %s %s >/tmp/macro.out 2>/tmp/macro.err", 
			macpath, maccall, fname, parfile, filename, config_file);
	// write_to_log(zwi);
	// write_to_log("Before call macro");

	rc=system(zwi);
	// write_to_log("After call macro");

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

	sprintf(zwi, "Before reading result >%s<", fname);
	write_to_log(zwi);
	fp=fopen(fname, "rb+");
	if(fp==NULL){
		write_to_log("Could not open infile for macro");
		return(-1);
	}
	rc=read_line(fp, line, sizeof(line)); // ###JG###
	fprintf(stderr, "line(msg)=>%s<\n",line);
	strcpy(screen_errormsg, line+4);
	rc=read_line(fp, line, sizeof(line)); 
	strcpy(screen_errormessage, line+8);
	rc=read_line(fp, line, sizeof(line)); 
	screen_x=atoi(line+9);
	rc=read_line(fp, line, sizeof(line)); 
	screen_y=atoi(line+9);
	rc=read_line(fp, line, sizeof(line)); 

	// now set the correct cursor_area
	cursor_area=CUR_TEXTAREA; 
	if(screen_y=3 && screen_x>=14){
	 	cursor_area=CUR_CMDLINE; 
	}
	if(screen_y>3 && screen_x<8){
	 	cursor_area=CUR_LINENBR; 
	}

	if(source_changed==FALSE){
		modified=atoi(line+9);
		if(modified==0){
			source_changed=FALSE;
		}
		else{
			source_changed=TRUE;
		}
	}

	sprintf(zwi, "**************************** %s *******************************", lang_top_of_data);
	lineptr[0]=malloc(strlen(zwi)+1);
	strcpy((char*)lineptr[0], zwi);
	linetype[0]='T';
	linecmd[0]=malloc(7);
	strcpy((char*)linecmd[0], "      ");
	write_to_log("Before reading first line");
	for(t=1;;t++){
		rc=read_line(fp, line, sizeof(line));
		if(rc==EOF) break;
		// write_to_log("After reading one line");
		linetype[t]=line[6];
		l=strlen(line+7);
		// sprintf(zwi, "l=%d", l);
		// write_to_log(zwi);
		lineptr[t]=malloc(l+1);
		// write_to_log("After reading one line:1");
		if(l>12){
			strcpy((char*)lineptr[t], line+13);
		}
		else{
			strcpy((char*)lineptr[t], "");
		}
		// write_to_log("After reading one line:2");
		linecmd[t]=malloc(7);
		// write_to_log("After reading one line:3");
		if(l>6){
		   strcpy(zwi, line+7);
		}
		else{
			strcpy(zwi, "      ");
		}
		// write_to_log("After reading one line:4");
		zwi[6]=0;
		strcpy((char*)linecmd[t], zwi);
	}
	fclose(fp);
	// write_to_log("After fclose()");
	strcpy(zwi, "************************** Bottom of Data ******************************");
	lineptr[t]=malloc(strlen(zwi)+1);
	strcpy((char*)lineptr[t], zwi);
	linetype[t]='T';
	linecmd[t]=malloc(7);
	strcpy((char*)linecmd[t], "      ");
	linecnt=t+1;
	if(linecnt<0){
		linecnt=0;
	}
	write_to_log("After reading result");

	set_to_space(screen_commandline, 80);

	write_to_log("End of handle macro");
	// remove(fname);
	return(1); // cursor at beginning of command line
}
/******************************************************************************/
int now_really_process_commandline(unsigned char *s)
{
// process the command line and line commands

	char zwi[256];
	char orizwi[256];
	char zwi2[1024];
	char zwi3[1024];
	char macroname[256];
	int a;
	int c, c1;
	int f;
	int t, i;
	int rc;
	int z;
	int cnt;
	int afterbefore, afterbeforeline;
	int startblockcc, endblockcc;
	int startblockrr, endblockrr;
	int startblockdd, endblockdd;
	int startblockxx, endblockxx;
	int copymoveline;
	int curpos; // needed for remove_empty_insert_lines


	sprintf(zwi2, "now_really_process_commandline: delimiter=>%c< s=>%s< ", 
		conf_delimiter, s);
	write_to_log(zwi2);
	write_to_log("===0====");
	strcpy(zwi, (char*)s);
	write_to_log("===1====");
	add_to_command_stack(zwi);
	write_to_log("===2====");
	trim(zwi); 
	write_to_log("===3====");
	strcpy(orizwi, zwi); 
	write_to_log("===4====");
	word((char*)s, zwi, 1);
	write_to_log("===5====");
	ucase(zwi); 
	write_to_log("===6====");
	sprintf(zwi2, "now_really_process_commandline: zwi=>%s< %d", zwi, zwi[0]);
	write_to_log(zwi2);

	f=0;
	if(strcmp(zwi, "UP")==0){
		// get the parameter, the scroll amount, if exists
		word((char*)screen_commandline, zwi2, 2);
		strcpy((char*)screen_commandline, zwi2);
		do_page_up();
		write_to_log("===return 1====");
		return(1); // cursor at beginning of command line
	}
	if(strcmp(zwi, "DOWN")==0){
		// get the parameter, the scroll amount, if exists
		word((char*)screen_commandline, zwi2, 2);
		strcpy((char*)screen_commandline, zwi2);
		do_page_down();
		write_to_log("===return 2====");
		return(1); // cursor at beginning of command line
	}
	if(strcmp(zwi, "LEFT")==0){
		// get the parameter, the scroll amount, if exists
		word((char*)screen_commandline, zwi2, 2);
		strcpy((char*)screen_commandline, zwi2);
		do_left();
		write_to_log("===return 3====");
		return(1); // cursor at beginning of command line
	}
	if(strcmp(zwi, "RIGHT")==0){
		// get the parameter, the scroll amount, if exists
		word((char*)screen_commandline, zwi2, 2);
		strcpy((char*)screen_commandline, zwi2);
		do_right();
		write_to_log("===return 4====");
		return(1); // cursor at beginning of command line
	}
	if(strcmp(zwi, "RETRIEVE")==0){
		do_retrieve();
		write_to_log("===return 5====");
		return(1); // cursor at beginning of command line
	}
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
		write_to_log("===return 6====");
		return(1); // cursor at beginning of command line
	}
	if(strcmp(zwi, "X")==0 || strcmp(zwi, "EXCLUDE")==0){
		word(orizwi, zwi2, 2);
		ucase(zwi2);
		word(orizwi, zwi3, 3);
		if(strcmp(zwi2, "ALL")==0 && zwi3[0]==0){
			strcpy(screen_errormsg, "");
			strcpy(screen_errormessage, "");
			set_to_space(screen_commandline, 80);
			remove_empty_insert_lines(&curpos);
			remove_message_lines();
			remove_error_lines();
			unexclude_lines();
			exclude_all_lines();
			screen_offset_y=0;
		write_to_log("===return 7====");
			return(1); // cursor at beginning of command line
		}
		if(zwi3[0]!=0){
			strcpy(screen_errormsg, "Invalid operand");
			strcpy(screen_errormessage, "An invalid operand was found.");
		write_to_log("===return 8====");
			return(1); // cursor at beginning of command line
		}
		if(zwi2[0]!=0 && zwi3[0]==0){
			strcpy(screen_errormsg, "Missing operand:1");
			strcpy(screen_errormessage, "A valid operand is missing.");
		write_to_log("===return 9====");
			return(1); // cursor at beginning of command line
		}
		strcpy(screen_errormsg, "Missing operand:2");
		strcpy(screen_errormessage, "A valid operand is missing.");
		write_to_log("===return 10====");
		return(1); // cursor at beginning of command line
	}
	if(strcmp(zwi, "L")==0 || strcmp(zwi, "LOC")==0){
		word(orizwi, zwi2, 2);
		a=atoi(zwi2);
		if(a<1){
			strcpy(screen_errormsg, "Invalid parameter");
			strcpy(screen_errormessage, "Invalid line number for LOC command.");
		write_to_log("===return 11====");
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
		write_to_log("===return 12====");
		return(1); // cursor at beginning of command line
	}
	if(f==0 && (strcmp(zwi, "VER")==0 || strcmp(zwi, "VERSION")==0)){
		strcpy(screen_errormsg, SHORTVERSION);
		strcpy(screen_errormessage, VERSION);
		set_to_space(screen_commandline, 80);
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
		write_to_log("===return 13====");
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
		write_to_log("===return 14====");
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
		write_to_log("===return 15====");
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
		write_to_log("===return 16====");
		return(1); // cursor at beginning of command line
		f=1;
	}
	// don't ignore the parameters!
	strcpy(zwi, orizwi);
	ucase(zwi);
	if(f==0 && (strncmp(zwi, "FIND ", 5)==0 || strncmp(zwi, "F ", 2)==0)){
		cursor_x=14;
		cursor_area=CUR_TEXTAREA; 
		do_find(orizwi);
		set_to_space(screen_commandline, 80);
		write_to_log("===return 17====");
		// return(1); // cursor at beginning of command line
		// return(0); // process RETURN key                
		sprintf(zwi, "2:cursor_y=%d cursor_x=%d", cursor_y, cursor_x);
		write_to_log(zwi);
		write_to_log("===return 18====");
		return(2); // leave cursor where it is
	}
	// del all nx or del all x
	if(f==0 && (strncmp(zwi, "DEL ", 4)==0 || strncmp(zwi, "DEL", 3)==0)){
		word(orizwi, zwi2, 2);
		word(orizwi, zwi3, 3);
		ucase(zwi2);
		if(strcmp(zwi2, "ALL")!=0){
			strcpy(screen_errormsg, "Invalid operand");
			sprintf(screen_errormessage, "Operand ALL was expected, but >%s< was found.", zwi2);
			return(1); // cursor at beginning of command line
		}
		ucase(zwi3);
		if(strcmp(zwi3, "X")!=0 && strcmp(zwi3, "NX")!=0){
			strcpy(screen_errormsg, "Invalid operand");
			strcpy(screen_errormessage, "Operand X or NX was expected.");
			sprintf(screen_errormessage, "Operand X or NX was expected, but >%s< was found.", zwi3);
			return(1); // cursor at beginning of command line
		}
		if(strcmp(zwi3, "X")==0){
			cnt=0;
			for(t=0; t<linecnt; t++){
				if(linetype[t]=='X'){
					delete_one_line(t);
					t--;
					source_changed=TRUE;
					cnt++;
				}
			}
		}
		if(strcmp(zwi3, "NX")==0){
			cnt=0;
			for(t=0; t<linecnt; t++){
				if(linetype[t]=='N'){
					delete_one_line(t);
					t--;
					source_changed=TRUE;
					cnt++;
				}
			}
		}
		sprintf(zwi, "DEL:1 cnt=%d current_line=%d linecnt=%d screen_offset_y=%d",
			cnt, current_line, linecnt, screen_offset_y);
		write_to_log(zwi);
		if(cnt>0){
			sprintf(screen_errormsg, "%d lines deleted.", cnt);
			sprintf(screen_errormessage, "%d lines deleted.", cnt);
		}
		else{
			strcpy(screen_errormsg, "No lines deleted.");
			strcpy(screen_errormessage, "No lines deleted.");
		}
		set_to_space(screen_commandline, 80);
		if(current_line>=linecnt){
			current_line=linecnt-1;
		}
		if(current_line<0){
			current_line=0;
		}
		if(screen_offset_y>=linecnt){
			screen_offset_y=linecnt-1;
			for(;;){
				if(screen_offset_y<(linecnt-screen_lines)) break;
				screen_offset_y--;
				if(screen_offset_y<1) break;
			}
		}
		draw_screen_editor();
		sprintf(zwi, "DEL:2 cnt=%d current_line=%d linecnt=%d screen_offset_y=%d",
			cnt, current_line, linecnt, screen_offset_y);
		write_to_log(zwi);
		return(1); // cursor at beginning of command line
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
		strcpy(zwi2, (char*)screen_commandline);
		trim(zwi2);
		sprintf(screen_errormessage, "%s is not an editor command.", zwi2);
		write_to_log("===return 19====");
		return(1); // cursor at beginning of command line
	}

	// now process block commands

	
	write_to_log("Processing block commands  !!!!!!!!!!!!!!!!!!!!!!!!!!");
	afterbefore=-1; // ###JG###
	afterbeforeline=-1;
	copymoveline=-1;
	for(t=0; t<linecnt; t++){
		strcpy(zwi, (char*)linecmd[t]);
		trim(zwi);
		ucase(zwi);
		if(zwi[0]=='A' && zwi[1]==0){
			afterbefore=1;
			afterbeforeline=t;
			// strcpy((char*)linecmd[t], "      ");
		}
		if(zwi[0]=='B' && zwi[1]==0){
			afterbefore=2;
			afterbeforeline=t;
			// strcpy((char*)linecmd[t], "      ");
		}
		if(zwi[0]=='C' && zwi[1]==0){
			copymoveline=1;
		}
		if(zwi[0]=='M' && zwi[1]==0){
			copymoveline=2;
		}
	}

	// copy block
	write_to_log("Looking for CC !!!!!!!!!!!!!!!!!!!!!!!!!!");
	startblockcc=-1;
	endblockcc=-1;
	startblockrr=-1;
	endblockrr=-1;
	startblockdd=-1;
	endblockdd=-1;
	startblockxx=-1;
	endblockxx=-1;
	for(t=0; t<linecnt; t++){
		strcpy(zwi, (char*)linecmd[t]);
		trim(zwi);
		// sprintf(zwi2, "zwi=>%s<", zwi);
		// write_to_log(zwi2);
		if(zwi[0]=='c' && zwi[1]=='c' && zwi[2]==0){
			// write_to_log("CC found!!!!!!!!!!!!!!!!!!!!!!!!!!");
			if(startblockcc==-1){
				startblockcc=t;
			}
			else{
				if(endblockcc==-1){
					endblockcc=t;
				}
				else{
					strcpy(screen_errormsg, "copy/move pending");
					strcpy(zwi2, (char*)screen_commandline);
					trim(zwi2);
					sprintf(screen_errormessage, "copy/move is pending");
		write_to_log("===return 20====");
					return(1); // cursor at beginning of command line
				}
			}
		}
		if(zwi[0]=='r' && zwi[1]=='r' && zwi[2]==0){
			if(startblockrr==-1){
				startblockrr=t;
			}
			else{
				if(endblockrr==-1){
					endblockrr=t;
				}
				else{
					strcpy(screen_errormsg, "Block command imcomplete");
					strcpy(zwi2, (char*)screen_commandline);
					trim(zwi2);
					sprintf(screen_errormessage, "Block command imcomplete");
					write_to_log("===return 20.1====");
					return(1); // cursor at beginning of command line
				}
			}
		}
		if(zwi[0]=='d' && zwi[1]=='d' && zwi[2]==0){
			if(startblockdd==-1){
				startblockdd=t;
			}
			else{
				if(endblockdd==-1){
					endblockdd=t;
				}
				else{
					strcpy(screen_errormsg, "Block command imcomplete");
					strcpy(zwi2, (char*)screen_commandline);
					trim(zwi2);
					sprintf(screen_errormessage, "Block command imcomplete");
					write_to_log("===return 20.1====");
					return(1); // cursor at beginning of command line
				}
			}
		}
		if(zwi[0]=='x' && zwi[1]=='x' && zwi[2]==0){
			if(startblockxx==-1){
				startblockxx=t;
			}
			else{
				if(endblockxx==-1){
					endblockxx=t;
				}
				else{
					strcpy(screen_errormsg, "Block command imcomplete");
					strcpy(zwi2, (char*)screen_commandline);
					trim(zwi2);
					sprintf(screen_errormessage, "Block command imcomplete");
					write_to_log("===return 20.1====");
					return(1); // cursor at beginning of command line
				}
			}
		}
	}
	sprintf(zwi, ">>>startblockcc=%d endblockcc=%d afterbefore=%d", 
		   startblockcc, endblockcc, afterbefore);
	write_to_log(zwi);
	if(startblockcc>-1 && endblockcc>-1 && afterbefore>-1){
		z=0;
		for(i=startblockcc; i<=endblockcc; i++, z++){
			if(afterbefore==1){ // insert after
				insert_one_empty_line(afterbeforeline+1+z);
				linetype[afterbeforeline+1+z]='N';
				sprintf(zwi, "=== afterbeforeline=%d startblockcc=%d", afterbeforeline, startblockcc);
				write_to_log(zwi);
				if(afterbeforeline<startblockcc){
					write_to_log("===cc increment====");
					// increment those because we inserted one line before!!!
					startblockcc++;
					endblockcc++;
					i++;
				}
				free(lineptr[afterbeforeline+1+z]);
				lineptr[afterbeforeline+1+z]=malloc(strlen((char*)lineptr[i])+1);
				strcpy((char*)lineptr[afterbeforeline+1+z], (char*)lineptr[i]);
			}
			else{ // insert before
				insert_one_empty_line(afterbeforeline+z);
				linetype[afterbeforeline+z]='N';
				if(afterbeforeline<startblockcc){
					// increment those because we inserted one line before!!!
					startblockcc++;
					endblockcc++;
					i++;
				}
				free(lineptr[afterbeforeline+z]);
				lineptr[afterbeforeline+z]=malloc(strlen((char*)lineptr[i])+1);
				strcpy((char*)lineptr[afterbeforeline+z], (char*)lineptr[i]);
			}
		}
		strcpy((char*)linecmd[startblockcc], "      ");
		strcpy((char*)linecmd[endblockcc], "      ");
		if(afterbefore==1){
			strcpy((char*)linecmd[afterbeforeline], "      ");
		}
		else{
			strcpy((char*)linecmd[afterbeforeline+z], "      ");
		}
		source_changed=TRUE;
		f=1;
		write_to_log("===return 21====");
		return(0); // process ENTER key
	}
	else{
		sprintf(zwi, "startblockcc=%d endblockcc=%d afterbefore=%d", 
		    startblockcc, endblockcc, afterbefore);
		write_to_log(zwi);
		if((startblockcc>-1||endblockcc>-1||afterbefore>-1) && copymoveline==-1){
			strcpy(screen_errormsg, "copy/move pending");
			strcpy(zwi2, (char*)screen_commandline);
			trim(zwi2);
			sprintf(screen_errormessage, "copy/move is pending");
		write_to_log("===return 22====");
			return(1); // cursor at beginning of command line
		}
	}
	if(startblockrr>-1 && endblockrr>-1){
		z=0;
		for(i=startblockrr; i<=endblockrr; i++, z++){
			insert_one_empty_line(endblockrr+1+z);
			linetype[endblockrr+1+z]='N';
			free(lineptr[endblockrr+1+z]);
			lineptr[endblockrr+1+z]=malloc(strlen((char*)lineptr[i])+1);
			strcpy((char*)lineptr[endblockrr+1+z], (char*)lineptr[i]);
		}
		strcpy((char*)linecmd[startblockrr], "      ");
		strcpy((char*)linecmd[endblockrr], "      ");
		source_changed=TRUE;
		f=1;
		strcpy(screen_errormsg, "");
		strcpy(screen_errormessage, "");
		write_to_log("===return 22.1====");
		return(0); // process ENTER key
	}
	else{
		if(startblockrr>-1 || endblockrr>-1){
			strcpy(screen_errormsg, "Block command incomplete");
			strcpy(zwi2, (char*)screen_commandline);
			trim(zwi2);
			sprintf(screen_errormessage, "Block command incomplete");
			write_to_log("===return 22.2====");
			return(1); // cursor at beginning of command line
		}
	}
	if(startblockdd>-1 && endblockdd>-1){
		for(i=startblockdd; i<=endblockdd; i++){
			delete_one_line(startblockdd);
			if(cursor_y<4){
				cursor_y=4;
				screen_offset_y--;
			}
		}
		strcpy((char*)linecmd[startblockdd], "      ");
		source_changed=TRUE;
		f=1;
		strcpy(screen_errormsg, "");
		strcpy(screen_errormessage, "");
		write_to_log("===return 22.3====");
		return(0); // process ENTER key
	}
	else{
		if(startblockdd>-1 || endblockdd>-1){
			strcpy(screen_errormsg, "Block command incomplete");
			strcpy(zwi2, (char*)screen_commandline);
			trim(zwi2);
			sprintf(screen_errormessage, "Block command incomplete");
			write_to_log("===return 22.2====");
			return(1); // cursor at beginning of command line
		}
	}
	if(startblockxx>-1 && endblockxx>-1){
		for(i=startblockxx; i<=endblockxx; i++){
			cursor_y--;
			if(cursor_y<4){
				cursor_y=4;
				screen_offset_y--;
			}
			linetype[i]='X';
		}
		if(cursor_y<24){
			cursor_y++;
		}
		strcpy((char*)linecmd[startblockxx], "      ");
		strcpy((char*)linecmd[endblockxx], "      ");
		strcpy(screen_errormsg, "");
		strcpy(screen_errormessage, "");
		// source_changed=TRUE; // NOT, its only eXcluded....
		f=1;
		write_to_log("===return 22.4====");
		return(0); // process ENTER key
	}
	else{
		if(startblockxx>-1 || endblockxx>-1){
			strcpy(screen_errormsg, "Block command incomplete");
			strcpy(zwi2, (char*)screen_commandline);
			trim(zwi2);
			sprintf(screen_errormessage, "Block command incomplete");
			write_to_log("===return 22.2====");
			return(1); // cursor at beginning of command line
		}
	}


	// now process line commands

	for(t=0; t<linecnt; t++){
		if(strcmp((char*)linecmd[t], "      ")!=0){
			strcpy(zwi, (char*)linecmd[t]);
			trim(zwi);
			c=toupper(zwi[0]);
			c1=toupper(zwi[1]);
			f=0;
			if(c=='='){ // message line..
				f=1;
			}
			ucase(zwi);
			if(strcmp(zwi, ".A")==0 || strcmp(zwi, ".B")==0){
				f=1; // may be used by macros, so it's okay
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
				strcpy((char*)linecmd[t], "      ");
				f=1;
			}
			if(c=='D' && (c1==0 || isdigit(c1))){
				a=atoi(zwi+1);
				if(a==0){
					a=1;
				}
				for(i=0; i<a; i++){
					delete_one_line(t);
				}
				strcpy((char*)linecmd[t], "      ");
				cursor_y--;
				source_changed=TRUE;
				f=1;
			}
			if(c=='R' && (c1==0 || isdigit(c1))){
				a=atoi(zwi+1);
				if(a==0){
					a=1;
				}
				for(i=0; i<a; i++){
					insert_one_empty_line(t+1);
					linetype[t+1]='N';
					strcpy((char*)lineptr[t+1], (char*)lineptr[t]);
				}
				strcpy((char*)linecmd[t], "      ");
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
				strcpy((char*)linecmd[t], "      ");
				source_changed=FALSE;
				f=1;
			}
			if(c=='C'){ // copy
				sprintf(zwi, "afterbefore=%d", afterbefore);
				write_to_log(zwi);
				if(afterbefore==1){
					if(afterbeforeline>t){ // after current line, okay
						write_to_log("c a after current line");
						strcpy((char*)linecmd[afterbeforeline], "      ");
						insert_one_empty_line(afterbeforeline+1);
						linetype[afterbeforeline+1]='N';
						strcpy((char*)lineptr[afterbeforeline+1], (char*)lineptr[t]);
						strcpy((char*)linecmd[t], "      ");
					}
					else{ // before current line, current line t moves to t+1
						write_to_log("c a before current line");
						strcpy((char*)linecmd[t], "      ");
						strcpy((char*)linecmd[afterbeforeline], "      ");
						insert_one_empty_line(afterbeforeline+1);
						linetype[afterbeforeline+1]='N';
						strcpy((char*)lineptr[afterbeforeline+1],(char*)lineptr[t+1]);
					}
					source_changed=TRUE;
					f=1;
				}
				else{
					if(afterbefore==2){
						if(afterbeforeline>t){ // after current line, okay
							write_to_log("c b after current line");
							strcpy((char*)linecmd[afterbeforeline], "      ");
							insert_one_empty_line(afterbeforeline);
							linetype[afterbeforeline]='N';
							strcpy((char*)lineptr[afterbeforeline], (char*)lineptr[t]);
							strcpy((char*)linecmd[t], "      ");
						}
						else{
							write_to_log("c b before current line");
							insert_one_empty_line(afterbeforeline);
							linetype[afterbeforeline]='N';
							strcpy((char*)lineptr[afterbeforeline], (char*)lineptr[t+1]);
							strcpy((char*)linecmd[t+1], "      ");
							strcpy((char*)linecmd[afterbeforeline-1], "      ");
							strcpy((char*)linecmd[afterbeforeline], "      ");
							strcpy((char*)linecmd[afterbeforeline+1], "      ");
						}
						source_changed=TRUE;
						f=1;
					}
					else{
						strcpy(screen_errormsg, "copy/move is pending");
						sprintf(screen_errormessage, "copy/move is pending");
					}
				}
			}
			if(c=='M'){ // move
				if(afterbefore==1){
					if(afterbeforeline>t){ // after current line, okay
						write_to_log("c a after current line");
						insert_one_empty_line(afterbeforeline+1);
						linetype[afterbeforeline+1]='N';
						strcpy((char*)lineptr[afterbeforeline+1], (char*)lineptr[t]);
						strcpy((char*)linecmd[t], "      ");
						strcpy((char*)linecmd[afterbeforeline], "      ");
						delete_one_line(t);
					}
					else{ // before current line, current line t moves to t+1
						write_to_log("c a before current line");
						strcpy((char*)linecmd[t], "      ");
						strcpy((char*)linecmd[afterbeforeline], "      ");
						insert_one_empty_line(afterbeforeline+1);
						linetype[afterbeforeline+1]='N';
						strcpy((char*)lineptr[afterbeforeline+1],(char*)lineptr[t+1]);
						delete_one_line(t+1);
					}
					source_changed=TRUE;
					f=1;
				}
				else{
					if(afterbefore==2){
						if(afterbeforeline>t){ // after current line, okay
							write_to_log("c b after current line");
							insert_one_empty_line(afterbeforeline);
							linetype[afterbeforeline]='N';
							strcpy((char*)lineptr[afterbeforeline], (char*)lineptr[t]);
							strcpy((char*)linecmd[t], "      ");
							strcpy((char*)linecmd[afterbeforeline+1], "      ");
							delete_one_line(t);
						}
						else{
							write_to_log("c b before current line");
							insert_one_empty_line(afterbeforeline);
							linetype[afterbeforeline]='N';
							strcpy((char*)lineptr[afterbeforeline], (char*)lineptr[t+1]);
							strcpy((char*)linecmd[t+1], "      ");
							strcpy((char*)linecmd[afterbeforeline-1], "      ");
							strcpy((char*)linecmd[afterbeforeline], "      ");
							strcpy((char*)linecmd[afterbeforeline+1], "      ");
							delete_one_line(t+1);
						}
						source_changed=TRUE;
						f=1;
					}
					else{
						strcpy(screen_errormsg, "copy/move is pending");
						sprintf(screen_errormessage, "copy/move is pending");
					}
				}
			}
			if(f==0){
				if(afterbeforeline>0){
					strcpy(screen_errormsg, "copy/move is pending");
					sprintf(screen_errormessage, "copy/move is pending");
				}
				else{
					if(screen_errormsg[0]==0){ // dont overwrite existing error msg
						strcpy(screen_errormsg, "Invalid line cmd");
						sprintf(screen_errormessage,"Invalid line command >%s<", zwi);
					}
				}
			}
			else{
				strcpy(screen_errormsg, "");
				strcpy(screen_errormessage, "");
			}
		}
	}
	write_to_log("===return Ende====");
	return(rc); // 0 = process ENTER key
	            // 1 = beginning of command line
	            // 2 = leave cursor where it is
}
/******************************************************************************/
int process_commandline(void)
{
	unsigned char zwi[256];
	unsigned char cmdline[256];
	int t, i;
	int z;
	int start;
	int rc=0;

	strcpy(cmdline, screen_commandline);
	start=0;

	for(t=0;;t++){
		if(cmdline[t]==0) break;
		if(cmdline[t]==conf_delimiter){
			for(z=0, i=start; i<t; i++){
				zwi[z++]=cmdline[i];
			}
			zwi[z]=0;
			rc=now_really_process_commandline(zwi);
			start=t+1;
			if(rc!=0) break;
		}
	}
	sprintf(zwi, "start=%d, t=%d", start, t);
	write_to_log(zwi);
	if(start<strlen(cmdline)){
		strcpy(zwi, cmdline+start);
		rc=now_really_process_commandline(zwi);
	}
	return(rc);	
}
/******************************************************************************/
int retrievepos=MAX_COMMAND_STACK;
void do_retrieve(void)
{
	// char zwi[256];

	retrievepos--;
	if(retrievepos<0){
		return;
	}
	// sprintf(zwi, "retrievepos=%d", retrievepos);
	// write_to_log(zwi);
	if(command_stack[retrievepos]!=NULL){
		strncpy((char*)screen_commandline, command_stack[retrievepos], 
			sizeof(screen_commandline));
	}

	strcpy(screen_errormsg, "");
	strcpy(screen_errormessage, "");
}
/******************************************************************************/
void do_rfind(void)
{
	char zwi[256];

	sprintf(zwi, "find %s", rfind_needle);
	do_find(zwi);
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
int process_input_field(int c, unsigned char *s, int startx, int len, int offx)
{
	int t;
	int rc;
	char zwi[1024];
	char cmd[256];
	int endx;

	sprintf(zwi, "process_input_field: c=%d startx=%d len=%d offx=%d", 
		c, startx, len, offx);
	write_to_log(zwi);

	endx=startx+len;

	// sprintf(zwi, "1:process_input_field: c=%d screen_offset_y=%d KEY_ENTER=%d", c, screen_offset_y, KEY_ENTER);
	// write_to_log(zwi);

	strcpy(cmd, "");	
	switch(c){
		case KEY_F1:  strcpy(cmd, fkey1); c=0; break;
		case KEY_F2:  strcpy(cmd, fkey2); c=0; break;
		case KEY_F3:  strcpy(cmd, fkey3); c=0; break;
		case KEY_F4:  strcpy(cmd, fkey4); c=0; break;
		case KEY_F5:  strcpy(cmd, fkey5); c=0; break;
		case KEY_F6:  strcpy(cmd, fkey6); c=0; break;
		case KEY_F7:  strcpy(cmd, fkey7); c=0; break;
		case KEY_F8:  strcpy(cmd, fkey8); c=0; break;
		case KEY_F9:  strcpy(cmd, fkey9); c=0; break;
		case KEY_F10:  strcpy(cmd, fkey10); c=0; break;
		case KEY_F11:  strcpy(cmd, fkey11); c=0; break;
		case KEY_F12:  strcpy(cmd, fkey12); c=0; break;
		case KEY_PPAGE:  strcpy(cmd, fkeypgup); c=0; break;
		case KEY_NPAGE:  strcpy(cmd, fkeypgdown); c=0; break;
	}
	if(cmd[0]!=0){
		sprintf(zwi, "cmd=>%s<", cmd);
		write_to_log(zwi);
		ucase(cmd);
		if(strcmp(cmd, "RETRIEVE")==0){ do_retrieve();     return(0); }
		retrievepos=MAX_COMMAND_STACK; // jump back to the top of stack
		if(strcmp(cmd, "UP")==0){       do_page_up();      return(0); }
		if(strcmp(cmd, "DOWN")==0){     do_page_down();    return(0); }
		if(strcmp(cmd, "LEFT")==0){     do_left();         return(0); }
		if(strcmp(cmd, "RIGHT")==0){    do_right();        return(0); }
		if(strcmp(cmd, "RFIND")==0){ 	  do_rfind();        return(0); }
	}
	retrievepos=MAX_COMMAND_STACK; // jump back to the top of stack
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
							sprintf(zwi, "2:process RETURN_ENTER=%d", RETURN_ENTER);
							write_to_log(zwi);
							return(RETURN_ENTER);
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
							source_changed=TRUE;
							break;
		case KEY_IC:   if(s[len-1]==' '){
								for(t=len-1; t>(cursor_x-startx); t--){
									s[t]=s[t-1];
								}
								s[cursor_x-startx]=' ';
								s[len]=0;
							}
							source_changed=TRUE;
							break;
		default:
			if(isprint(c)){
				// sprintf(zwi, "cursor_x=%d startx=%d", cursor_x, startx);
				// write_to_log(zwi);
				s[cursor_x-startx+offx]=c;
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
/* topnbr - line which is displayed on top of screen
 * nbr    - line which is edited on the displayed screen
 */
int calc_linenbr(int topnbr, int nbr)
{
	int t;
	int cnt;
	char zwi[256];
	int z;

	sprintf(zwi, "calc_linenbr: nbr=%d screen_offset_y=%d", nbr,screen_offset_y);
	write_to_log(zwi);
	cnt=0;
	z=0;
	for(t=topnbr;;t++){
		if(linetype[t]=='X'){ // excluded? don't count it, must mark that
			cnt++;             // we have excluded lines
		}
		else{
			if(cnt>0){ // there were excluded lines, count only one!
				z++; // count the "nnn lines excluded" line
				cnt=0;
			}
			z++; // normal line, count it
		}
		if(z>nbr) break;
	}
	if(cnt>0){ // last line was excluded?
		t++;    // count it!
	}

	sprintf(zwi, "calc_linenbr: nbr=%d t=%d", nbr, t);
	write_to_log(zwi);
	return(t);
}
/******************************************************************************/
int now_handle_input_key_editor(int c)
{
	char zwi[5000];
	char zwi2[5000];
	int a;
	int rc;
	int pos=0;
	int curpos;
	int t;

	sprintf(zwi, "1:now_handle_input_key_editor: cursor_area=%d c=%d cursor_x=%d", cursor_area, c, cursor_x);
	write_to_log(zwi);

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

	// if(c==KEY_F5){
	// 	sprintf(zwi, "find %s", rfind_needle);
	// 	do_find(zwi);
	// 	return(0);
	// }

	if(c==KEY_F3){
		rc=do_save();
		endwin();
		if(rc==TRUE){
			puts("Saved..");
		}
		puts("Normal termination (F3).");
		exit(0);
	}

	// sprintf(zwi, "2:now_handle_input_key_editor: cursor_area=%d c=%d cursor_x=%d", cursor_area, c, cursor_x);
	// write_to_log(zwi);
	if(cursor_area==CUR_CMDLINE){
		write_to_log("CUR_CMDLINE: before process_input_field");
		rc=process_input_field(c, screen_commandline, 14, 48, 0);
		// sprintf(zwi, "3:now rc=%d", rc);
		// write_to_log(zwi);
		switch(rc){
			case RETURN_ENTER: cursor_area=CUR_TEXTAREA;
							cursor_y=screen_topline;
							curpos=pos+screen_offset_y;
							// jump to first non space character in line
							if(lineptr[curpos+1]!=NULL){
								strcpy(zwi, (char*)lineptr[curpos+1]);
							}
							else{
								strcpy(zwi, "");
							}
							// sprintf(zwi2, "zwi=>%s<", zwi);
							// write_to_log(zwi2);
							for(t=0;;t++){
								if(zwi[t]==0) break;
								if(zwi[t]!=' ') break;
							}
							cursor_x=8+t;
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
		write_to_log("CUR_LINENBR: before process_input_field");
		rc=process_input_field(c,linecmd[calc_linenbr(screen_offset_y, pos)],
			1, 6, 0);

	   sprintf(zwi, "LINENBR:rc=%d:cursor_x=%d", rc, cursor_x);
	   write_to_log(zwi);

		switch(rc){
			case RETURN_ENTER: cursor_area=CUR_TEXTAREA; 
							// cursor_area=CUR_LINENBR; // No, stay in textarea!!
							// now we can remove empty lines, finally!
							pos=cursor_y-screen_topline;
							// curpos=pos+screen_offset_y;
							curpos=calc_linenbr(screen_offset_y, pos);
							// remove_empty_insert_lines(&curpos); 
			            cursor_x=8;
							cursor_y++;
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
									strcpy(zwi, (char*)lineptr[curpos+1]);
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
								sprintf(zwi2, "curpos=%d linetype=>%c<", 
											curpos, linetype[curpos]);
								write_to_log(zwi2);
								sprintf(zwi2, "curpos+1=%d linetype=>%c<", 
											curpos+1, linetype[curpos+1]);
								write_to_log(zwi2);
		   					if(linetype[curpos+1]=='I'){
									// check the line before the inserted one
									strcpy(zwi, (char*)lineptr[curpos]);
									write_to_log("Inserted line found.");
								}
								else{
									// check the actual line
									strcpy(zwi, (char*)lineptr[curpos+1]);
									sprintf(zwi2, "linetype=>%c< found.", linetype[curpos+1]);
									write_to_log("Inserted line found before.");
								}
								// strcpy(zwi, (char*)lineptr[curpos+1]);
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
		// sprintf(zwi,"screen_offset_y=%d linecnt=%d", screen_offset_y, linecnt);
		// write_to_log(zwi);
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
		// curpos=pos+screen_offset_y; // ###JG###
		curpos=calc_linenbr(screen_offset_y, pos);
		if(linetype[curpos]=='N' ||
		   linetype[curpos]=='E' ||
		   linetype[curpos]=='T' || // ###JG###
		   linetype[curpos]=='I'){
			strcpy(zwi, (char*)lineptr[curpos]);
			expand_to_nnn_bytes(screen_offset_x+80, zwi);
			free(lineptr[curpos]);
			lineptr[curpos]=malloc(strlen(zwi)+1);
			strcpy((char*)lineptr[curpos], zwi);
			rc=process_input_field(c, 
			lineptr[calc_linenbr(screen_offset_y, pos)], 8, 72, screen_offset_x);
			strcpy(zwi, (char*)lineptr[curpos]);
			rtrim(zwi);
			// sprintf(zwi2, "nach process_input_field: zwi=>%s<", zwi);
			// write_to_log(zwi2);
			free(lineptr[curpos]);
			lineptr[curpos]=malloc(strlen(zwi)+1);
			strcpy((char*)lineptr[curpos], zwi);
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
									sprintf(zwi2, "curpos=%d linecnt=%d", curpos, linecnt);
									write_to_log(zwi2);
									if((curpos+1)<linecnt){
										strcpy(zwi, (char*)lineptr[curpos+1]);
										sprintf(zwi2, "zwi=>%s<", zwi);
										write_to_log(zwi2);
										for(t=0;;t++){
											if(zwi[t]==0) break;
											if(zwi[t]!=' ') break;
										}
										cursor_x=8+t;
									}
									else{
										cursor_y=3; // to commandline
										if(cursor_x<14) cursor_x=14;
										if(cursor_x>64) cursor_x=64;
								 		cursor_area=CUR_CMDLINE; 
									}
								}
								else{
									cursor_y=3; // to commandline
									if(cursor_x<14) cursor_x=14;
									if(cursor_x>64) cursor_x=64;
							 		cursor_area=CUR_CMDLINE; 
								}
							}
							else{
								// jump to first non space character in line
								if((curpos+1)<linecnt){
									strcpy(zwi, (char*)lineptr[curpos+1]);
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
								else{
			            		cursor_x=14; // go to commandline
									cursor_y=3;
								}
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
	// char zwi[1024];

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
	// int c=0;
	int rc=0;
	int f;
	int t;
	// int forecolor=COLOR_GREEN;
	// int backcolor=COLOR_BLACK;
	char zwi[1024];
	FILE *fp;
	
	char *config_path;

	for(t=1;t<argc;t++){
		f=0;
		strcpy(zwi, argv[t]);
		if(strcmp(zwi, "-v")==0 || strcmp(zwi, "--version")==0){
			puts(VERSION);
			exit(0);
		}
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

	// find out which config file we have
	config_path = getenv("PIPEDITCFG");
	if(config_path==NULL) {
		config_path=malloc(32);
		strcpy(config_path, "./pipedit.cfg");
	}
	printf("config_path=>%s<\n", config_path);
	sprintf(config_file, "%s", config_path);
	fp=fopen(config_file, "rb");
	if(fp==NULL){
		fprintf(stderr, "pipedit: Could not open config file >%s<, aborting..\n",
			config_file);
		exit(7);
	}
	else{
		fclose(fp);
	}

	read_config_file();

	read_language_stuff();

	set_signals();

	for(t=0; t<MAXLINES; t++){
		lineptr[t]=NULL;
		linecmd[t]=NULL;
		linetype[t]=' ';
	}

	for(t=0; t<MAX_COMMAND_STACK; t++){
		command_stack[t]=NULL;
	}

	if(strlen(filename)==0){
		fprintf(stderr, "Missing filename, aborting...\n");
		exit(1); 
	} 

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
	// raw();
	keypad(stdscr, TRUE); // needed to get the correct keys
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
	init_pair(COLPAIR_CURLIN, COLOR_RED, COLOR_BLACK);

	attron(COLOR_PAIR(COLPAIR_NORMAL));

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

