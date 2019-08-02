# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <unistd.h>

char *linetab[128000];
char *errtab[128000][7];
int linecnt=0;

char *pretab[256];
int precnt=0;
char compiler[512];
char output[256];
char options[256];
char listing[256];
char binary[256];
char movebinto[256]="";
char movelstto[256]="";
char removetmp[256]="";
char *posttab[256];
int postcnt=0;

char config_file[256];
char conf_target[256];

/******************************************************************************/
void rtrim(char *s)
{
	for(;;){
		if(s[strlen(s)-1]!=' ') break;
		s[strlen(s)-1]=0;
	}
}
/******************************************************************************/
int read_one_line(FILE *fp, char *line)
{
	int t;
	int c;

	for(t=0; t<512; t++){
		c=fgetc(fp);
		if(c==EOF || c=='\r' || c=='\n') break;
		line[t]=c;
	}
	line[t]=0;

	return(c);
}
/******************************************************************************/
void get_config_entry(char *pentry, char *value)
{
	FILE *fp;
	int rc;
	char line[256];
	char entry[256];

	strcpy(value, "");
	fp=fopen(config_file, "rb");
	if(fp==NULL) return;

	sprintf(entry, "%s=", pentry);

	for(;;){
		rc=read_one_line(fp, line);
		if(rc==EOF) break;
		if(strncmp(line, entry, strlen(entry))==0){
			strcpy(value, line+strlen(entry));
			break;
		}
	}
}
/******************************************************************************/
void read_par_file(char *parfile)
{
	char line[256];
	int rc;
	int f;
	int stage;
	FILE *fp;
	char target[256];

	// fprintf(stderr, "conf_target=>%s<\n", conf_target);

	sprintf(target, "@target=%s", conf_target);
	// fprintf(stderr, "Info: target=>%s<\n", target);

	fp=fopen(parfile, "rb");
	if(fp==NULL){
		return;
	}

	stage=0;

	for(;;){
		rc=read_one_line(fp, line);
		if(rc==EOF) break;
		rtrim(line);
		if(stage==0){
			// fprintf(stderr, "stage=0:line=>%s< target=>%s<\n", line, target);
			if(strcmp(line, target)==0){
				stage=1;
			}
		}
		else{
			// fprintf(stderr, "stage=1:line=>%s<\n", line);
			if(line[0]=='@') break; // another target, done with this one
			if(line[0]!='#'){
				if(line[0]!=0){
					f=0;
					if(strncmp(line, "compiler=", 9)==0){
						strcpy(compiler, line+9);
						f=1;
					}
					if(strncmp(line, "output=", 7)==0){
						strcpy(output, line+7);
						f=1;
					}
					if(strncmp(line, "options=", 8)==0){
						strcpy(options, line+8);
						f=1;
					}
					if(strncmp(line, "listing=", 8)==0){
						strcpy(listing, line+8);
						rtrim(listing);
						if(listing[strlen(listing)-1]=='\r')listing[strlen(listing)-1]=0;
						if(listing[strlen(listing)-1]=='\n')listing[strlen(listing)-1]=0;
						f=1;
					}
					if(strncmp(line, "binary=", 7)==0){
						strcpy(binary, line+7);
						f=1;
					}
					if(strncmp(line, "movebinto=", 10)==0){
						strcpy(movebinto, line+10);
						f=1;
					}
					if(strncmp(line, "movelstto=", 10)==0){
						strcpy(movelstto, line+10);
						f=1;
					}
					if(strncmp(line, "removetmp=", 10)==0){
						strcpy(removetmp, line+10);
						f=1;
					}
					if(strncmp(line, "pre=", 4)==0){
						pretab[precnt]=malloc(strlen(line+4)+1);
						strcpy(pretab[precnt], line+4);
						precnt++;
						f=1;
					}
					if(strncmp(line, "post=", 5)==0){
						posttab[postcnt]=malloc(strlen(line+5)+1);
						strcpy(posttab[postcnt], line+5);
						postcnt++;
						f=1;
					}
				}
				if(f==0){
					fprintf(stderr, "Unknown argument >%s<, aborting macro...\n", line);
					exit(99);
				}
			}
		}
	}
	fclose(fp);
}
/******************************************************************************/
int do_replace(char *s, char *old, char *new)
{
   int t;
   int i;
   int f;
   char zwi[4096];

   if(strcmp(old, new)==0){
      return(0);
   }
   for(t=0;t<(strlen(s)-strlen(old)+1);t++){
      f=1;
      for(i=0; i<strlen(old); i++){
         if(s[t+i]!=old[i]){
            f=0;
            break;
         }
      }
      if(f==1){ // found!!!!
      	strcpy(zwi, s);
      	zwi[t]=0;
      	strcat(zwi, new);
      	strcat(zwi, s+t+strlen(old));
      	strcpy(s, zwi);
      	return(1);
   	}
 	}
	return(0);
}
/******************************************************************************/
int main(int argc, char **argv)
{
	char filename[256];
	char orifilename[256];
	char fname[256];
	char scriptname[256];
	char parfile[256];
	char line[512];
	char zwi[1024];
	char zwi2[1024];
	char lstfile[1024];
	char errfile[256];
	char cobname[256];
	char remname[256];
	char text_error[256];
	char errortype[256];
	FILE *fp, *fplst;
	int a, old_a;
	int curline;
	int t, i;
	int f;
	int ecnt;
	int errcnt;
	int pid;
	int pos;
	int rc;
	int valid_target;

	strcpy(zwi, getenv("LANG"));
	strcpy(text_error, "error:");
	if(strncmp(zwi, "de_DE", 5)==0) strcpy(text_error, "Fehler:");
	if(strncmp(zwi, "en_EN", 5)==0) strcpy(text_error, "error:");

	pid=getpid();

	strcpy(filename, argv[1]);
	// printf("argc=%d\n", argc);
	if(argc<3){
		printf("parfile is missing, macro aborted...\n");
		exit(99);
	}
	strcpy(parfile, argv[2]);
	if(argc<4){
		printf("orignal file name is missing, macro aborted...\n");
		exit(99);
	}
	strcpy(orifilename, argv[3]);
	if(argc<5){
		printf("config file name is missing, macro aborted...\n");
		exit(99);
	}
	strcpy(config_file, argv[4]);

	get_config_entry("target", conf_target); 

	fprintf(stderr, "config_file=>%s<\n", config_file);
	fprintf(stderr, "conf_target=>%s<\n", conf_target);
	// fprintf(stderr, "orifilename=>%s<\n", orifilename);
	read_par_file(parfile);

	// printf("comp: reading file from >%s<\n", filename);
	fp=fopen(filename, "rb");
	if(fp==NULL){
		exit(99);
	}
	for(t=0;;){
		if(read_one_line(fp, line)==EOF) break;
		if(line[6]!='M'){
			linetab[t]=malloc(strlen(line)+1);
			strcpy(linetab[t], line);
			for(i=0; i<7; i++){
				errtab[t][i]=NULL;
			}
			t++;
		}
	}
	linecnt=t;
	fclose(fp);

	// sprintf(fname, "/tmp/comp_%d.cob", getpid()); // GnuCobol
	sprintf(fname, "/tmp/comp_%d.cob", pid);   // Microfocus/Oracle
	sprintf(scriptname, "/tmp/comp_%d.sh", pid);   // Microfocus/Oracle
	// printf("comp: compiling file >%s<\n", fname);
	remove(fname);
	remove(scriptname);
	fp=fopen(fname, "wb");
	for(t=0; t<linecnt; t++){
		// printf("linetab[%d]=>%s<\n", t, linetab[t]);
		strcpy(line, linetab[t]);
		// printf("line=>%s<\n", line);
		fprintf(fp, "%s\n", line+13);
	}
	fclose(fp);

	sprintf(errfile, "%s.err", fname);
	remove(errfile);

	fp=fopen(scriptname, "wb");
	for(t=0; t<precnt; t++){
		fprintf(fp, "%s\n", pretab[t]);
	}

	fprintf(fp, "cd /tmp\n");
	fprintf(fp, "%s %s -o %s %s 2>%s.err\n", compiler, fname, binary, options, fname);
	fprintf(fp, "mv /tmp/%s %s\n", binary, movebinto);
	for(t=0; t<postcnt; t++){
		fprintf(fp, "%s\n", posttab[t]);
	}
	fclose(fp);

	// fprintf(stderr, "compiler=>%s<\n", compiler);
	// fprintf(stderr, "errfile=>%s<\n", errfile);
	sprintf(zwi, "chmod 755 %s; %s", scriptname, scriptname);
	// fprintf(stderr, "system:zwi=>%s<\n", zwi);
	system(zwi);

	// fprintf(stderr, "fopen errfile=>%s<\n", errfile);
	fp=fopen(errfile, "rb");
	errcnt=0;
	ecnt=0;
	old_a=-1;
	valid_target=0;
	for(t=0;;t++){
		if(read_one_line(fp, line)==EOF) break;
		if(strcmp(conf_target, "GNUCOBOL")==0){
			valid_target=1;
			// printf("line=>%s<\n", line);
			for(i=0;;i++){
				if(line[i]==0) break;
				if(line[i]==' ') break;
			}
			i++;
			a=atoi(line+i);
			if(a!=old_a){
				ecnt=0;
			}
			for(;;i++){
				if(line[i]==0) break;
				if(line[i]==' ') break;
			}
			i++;
			strcpy(zwi, line+i);
			for(;;){
				if(strlen(zwi)>80) break;
				strcat(zwi, " ");
			}
			if(strncmp(zwi, text_error, strlen(text_error))==0 && ecnt<7){
				// fprintf(stderr, "a=%d ecnt=%d zwi=>%s<\n", a, ecnt, zwi);
				errtab[a-1][ecnt]=malloc(strlen(zwi)+1);
				strcpy(errtab[a-1][ecnt], zwi);
				ecnt++;
				errcnt++;
				if(f==1){
					t--; // more than one error message for one line
				}
				f=1;
			}
			else{
				f=0; // not another error message
			}
		}
		if(strcmp(conf_target, "MICROFOCUS")==0){
			valid_target=1;
			a=atoi(line);
			if(a>0){
				curline=a;
			}
			if(a!=old_a){
				ecnt=0;
			}
			if(strncmp(line, "* ", 2)==0){
				strcpy(errortype, line+3);
				for(i=0;;i++){
					if(errortype[i]==0) break;
					if(errortype[i]=='*'){
						errortype[i]=0;
						break;
					}
				}
			}
			if(strncmp(line, "** ", 3)==0){
				sprintf(zwi, "%s %s", errortype, line+4);
				errtab[curline-1][0]=malloc(strlen(zwi)+1);
				// fprintf(stderr, "curline=%d zwi=>%s<\n", curline, zwi);
				strcpy(errtab[curline-1][ecnt++], zwi);
				errcnt++;
			}
		}
		if(valid_target==0){
			fprintf(stderr, "Invalid target in *.cfg file >%s<, aborting..\n", 
				conf_target);
			exit(3);
		}
		old_a=a;
	}
	fclose(fp);

	// Handle the *.lst file here, replace the temporary name comp_something
	// by the real name of the source code
	// strcpy(zwi, fname);
	if(strcmp(conf_target, "GNUCOBOL")==0){
		sprintf(zwi, "/tmp/%s", orifilename);
	}
	if(strcmp(conf_target, "MICROFOCUS")==0){
		strcpy(zwi, fname);
	}
	pos=0;
	for(t=0;;t++){
		if(zwi[t]==0) break;
		if(zwi[t]=='.') pos=t;
	}
	zwi[pos]=0;
	strcpy(cobname, listing);
	pos=-1;
	for(t=0;;t++){
		if(cobname[t]==0) break;
		if(cobname[t]=='.') pos=t;
	}
	cobname[t]=0;
	strcat(cobname, ".cob");
	strcat(zwi, ".lst");
	fp=fopen(zwi, "rb");
	fprintf(stderr, "nach fopen:zwi=>%s< fp=%p\n", zwi, fp);
	sprintf(lstfile, "%s%s", movelstto, listing);
	fprintf(stderr, "lstfile=>%s< fp=%p\n", lstfile, fp);
	fplst=fopen(lstfile, "wb");
	if(fplst==NULL){
		fprintf(stderr, 
	"Could not open listing file >%s< for output, macro aborted..\n", lstfile);
		fprintf(fp, "000000M      Could not open listing file >%s< for output, macro aborted..", lstfile);
		exit(33);
	}
	// fprintf(stderr,"fname=>%s< lstfile=>%s< zwi=>%s<\n", fname, lstfile, zwi);
	for(;;){
		rc=read_one_line(fp, line);
		if(rc==EOF) break;
		// fprintf(stderr, "1:line=>%s<\n", line);
		if(strlen(line)>strlen(fname)){
			do_replace(line, fname, orifilename);
		}
		// fprintf(stderr, "2:line=>%s<\n", line);
		fprintf(fplst, "%s\n", line);
	}
	fclose(fp);
	fclose(fplst);
	remove(zwi); // remove the listing from /tmp
	printf("comp: writing file to >%s<\n", filename);
	fp=fopen(filename, "wb");
	if(errcnt==0){
		fprintf(fp, "000000M      * * * No Errors * * *\n");
	}
	else{
		if(errcnt==1){
			fprintf(fp, "000000M      One Error.\n");
		}
		else{
			fprintf(fp, "000000M      %d Errors.\n", errcnt);
		}
	}
	// fprintf(stderr, "macro: linecnt=%d\n", linecnt);
	for(t=0; t<linecnt; t++){
		// fprintf(stderr, "%d) %s\n", t, linetab[t]);
		fprintf(fp, "%s\n", linetab[t]);
		if(errtab[t][0]!=NULL){
			for(i=0;i<7; i++){
				if(errtab[t][i]==NULL) break;
				// fprintf(stderr, "errtab=%p\n", errtab[t][i]);
				fprintf(fp, "000000E      %s\n", errtab[t][i]);
				// fprintf(stderr, "000000E      %s\n", errtab[t][i]);
			}
		}
	}
	fclose(fp);
	// fprintf(stderr, "macro: end of loop, linecnt=%d\n", linecnt);

	remove(errfile);
	remove(fname);
	remove(scriptname);

	fprintf(stderr, "removetmp=>%s<\n", removetmp);

	// now remove all temp files with the given suffixes
	// first, get the filename to remove and remove the suffix
	strcpy(remname, fname);
	pos=-1;
	for(t=0;;t++){
		if(remname[t]==0) break;
		if(remname[t]=='.') pos=t;
	}
	if(pos>-1){
		remname[pos]=0; // suffix is gone.
	}
	// now get the suffixes to remove and concatenate them to remname
	// and finally remove those files
	pos=0;
	for(t=0;;t++){
		if(removetmp[t]==0 || removetmp[t]==' '){
			for(i=0; i<(t-pos); i++){
				zwi[i]=removetmp[pos+i];
			}
			zwi[i]=0;
			pos=t+1;
			fprintf(stderr, "remove >%s%s<\n", remname, zwi);
			sprintf(zwi2, "remove >%s%s<\n", remname, zwi);
			remove(zwi2);
		}
		if(removetmp[t]==0) break;
	}
	return(0);
}

