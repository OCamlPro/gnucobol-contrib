/*
   Copyright (C) 2014-2020,  Free Software Foundation, Inc.
   Written by Ron Norman

   This file is part of GnuCOBOL.

   The GnuCOBOL gctest program is free software: you can redistribute it
   and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation.

   GnuCOBOL is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with GnuCOBOL.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
     Program:  gctest.c

     Function: This program is used to drive GNUCobol testing
               and create the autotest data as a byproduct
*/

#include <assert.h>
#include <ctype.h>  
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <sys/time.h> 
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h> 
#include <unistd.h>

extern char *optarg;
extern int optind;

static int  incrErr = 0;
static int  bShareMod = 0;
static int  bVerbose = 0;
static int  bNeedsIsam = 0;
static char progexe[100];
static char progname[100];
static char diffProg[32] = "gcdiff";
/*
 * Display program usage information
*/
static void
usage(char *binname)
{
	printf("GnuCOBOL compile a COBOL program, execute & capture output\n");
	printf("to create an autotest.at file named from -p programname\n");
	printf(" \n");
	printf("  %s [options]\n",binname);
	printf("Where [options] are:\n");
	printf("  -p program      The COBOL program to compile and test\n");
	printf("  -C mod.c        A C module used by 'program' to compile\n");
	printf("  -B copybook     Include 'copybook' to autotest file for compile\n");
	printf("  -i inputfile    Define input file for test program\n");
	printf("  -o outputfile   Define Output report file\n");
	printf("  -O LSoutfile    Define LINE SEQUENIAL output file\n");
	printf("  -a              Append to program.at; Default is write\n");
	printf("  -b              Make test code start with blank line\n");
	printf("  -e              test compile only; Expecting errors\n");
	printf("  -E              compile only; ... Expecting errors\n");
	printf("  -fisam          Requires a COBOL compiler with INDEXED file support\n");
	printf("  -f opt          Add '-f opt' to compile command\n");
	printf("  -F opt          Add '-opt' to compile command\n");
	printf("  -g              compile as shared module\n");
	printf("  -M name         use 'name.at' for autotest file name\n");
	printf("  -m              use -std=mf  \n");
	printf("  -I              use -std=ibm \n");
	printf("  -t std          use -std=std; (mf,ibm,2002,2014,85,ibm,mvs,\n");
	printf("                                  acu,bs2000,realia,xopen)\n");
	printf("  -w              Compile with no warnings\n");
	printf("  -S name=value   Environment variable to be set for test\n");
	printf("  -D name=value   Compiler Directing variable is set to value\n");
	printf("  -X name=value   Push environment variable before running 'cobc'\n");
	printf("  -Z filename     File to be captured which is output by compiler\n");
	printf("  -c \"compile command\"  \n");
	printf("  -k \"Test keywords\"  \n");
	printf("  -s \"Test setup name\"  \n");
	printf(" \n");
	printf("Example command:\n");
	printf(" gctest -m -b -k report -s \"Sample REPORT\" -i STUDENT=./student0.inp \\\n");
	printf("           -o REPORT1=./REPORT0.txt -p rwtst0.bat\n");
	fflush(stdout);
}

/*
 * Split out file name specification
 */
static void
getFileName(
	char	*dd,		/* External name for file */
	char	*file,		/* 'filename' */
	char	*given)		/* 'filename' or EXTERNALNAME=filename */
{
	int	i;
	char	*p;
	if((p=strchr(given,'=')) != NULL) {
		memcpy(dd,given,p-given);
		dd[p-given] = 0;
		strcpy(file,p+1);
	} else {
		dd[0] = 0;
		strcpy(file,given);
	}
	return;
}

/*
 * Copy 'fi' thru to 'fo'
 */
static void
copyFile(FILE *fi, FILE *fo, int addBlank, int rmvseq, int showit, char *oldnm, char *newnm, int incrnum, int tabs)
{
	char	buf[4096], wrk[4096], *p;
	int		i,j,k,pos,olen = 0, nlen = 0;
	int		didName = 0;
	int		atBegin = 1;
	int		didProgId = 0;
	int		didEndProg = 0;
	if(fi == NULL)
		return;
	if(ferror(fi))
		return;
	if(feof(fi))
		return;
	memset(buf,0,sizeof(buf));
	if(oldnm) {
		olen = strlen(oldnm);
		nlen = strlen(newnm);
	}
	while(fgets(buf,sizeof(buf),fi) != NULL) {
		for(k=strlen(buf); buf[k-1] == '\r' || buf[k-1] == '\n'; k--);
		buf[k] = 0;
		if(addBlank
		&& atBegin
		&& k < 1) {
			if(bVerbose)
				printf("Note: program already starts with a blank line!\n");
			addBlank = 0;
			incrErr = 0;
		}
		if(addBlank
		&& atBegin) {
			fprintf(fo,"\n");
			addBlank = 0;
		}
		for(j=6; buf[j] == ' '; j++);
		if (!bShareMod) {
			if(memcmp(&buf[j],"PROGRAM-ID.",11) == 0
			&& !didProgId) {
				didProgId = 1;
				if(strstr(buf," INITIAL") != NULL) {
					strcpy(&buf[j],"PROGRAM-ID. prog INITIAL.");
				} else {
					strcpy(&buf[j],"PROGRAM-ID. prog.");
				}
			} else if(buf[6] != '*'
				&& !didEndProg
				&& strstr(buf,"END PROGRAM") != NULL) {
				didEndProg = 1;
				strcpy(buf,"           END PROGRAM prog.");
			}
			if(strstr(buf,"SYSTEM") != NULL
			&& (p=strstr(buf,progexe)) != NULL) {
				memcpy(p,"./prog",6);
			}
			k = 1;
			while(k) {
				k = 0;
				if((p=strstr(buf,progname))!=NULL) {
					i = (int) (p - &buf[0]);
					j = strlen(progname);
					k = 8;
					memcpy(wrk,buf,i);
					if (j > k
					&& buf[i+j] != '\'') {
						memset(&wrk[i],' ',j);
						memcpy(&wrk[i],"prog.cob",k);
						if(buf[i+j] == ':')
							strcpy(&wrk[i+k],&buf[i+j]);
						else
							strcpy(&wrk[i+j],&buf[i+j]);
					} else {
						strcpy(&wrk[i],"prog.cob");
						strcpy(&wrk[i+k],&buf[i+j]);
					}
					strcpy(buf,wrk);
					if(incrnum > 0) {
						for(i=j=0; buf[j] != 0; ) {
							if(buf[j] == ':'
							&& buf[j+1] == ' '
							&& isdigit(buf[j+2])) {
								pos = j;
								k = atoi(&buf[j+2]);
								for(j=j+2; isdigit(buf[j]); j++);
								if(buf[j] == ':') 		/* A line number? */
									i += sprintf(&wrk[i],": %d",k+incrnum);
								else
									i += sprintf(&wrk[i],"%.*s",j-pos,&buf[pos]);	/* Leave as it was */
							} else {
								wrk[i++] = buf[j++];
							}
						}
						wrk[i] = 0;
						strcpy(buf,wrk);
					}
				}
				if((p=strstr(buf,progexe))!=NULL) {
					i = (int) (p - &buf[0]);
					j = strlen(progexe);
					k = 4;
					memcpy(wrk,buf,i);
					if (j > k) {
						memset(&wrk[i],' ',j);
						memcpy(&wrk[i],"prog",k);
						strcpy(&wrk[i+j],&buf[i+j]);
					} else {
						strcpy(&wrk[i],"prog");
						strcpy(&wrk[i+k],&buf[i+j]);
					}
					strcpy(buf,wrk);
				}
			}
		}
		if(rmvseq) {
			for(k=0; k < 7; k++) {
				if(isdigit(buf[k]))
					buf[k] = ' ';
			}
		}
		if(showit)
			printf("%s\n",buf);

		didName = 0;
		if(olen > 0
		&& strlen(buf) < sizeof(wrk)-8) {		/* replace program name */
			for(i=j=0; buf[j] != 0; ) {
				if(memcmp(&buf[j],oldnm,olen) == 0) {
					memcpy(&wrk[i],newnm,nlen);
					didName = 1;
					i += nlen;
					j += olen;
				} else {
					wrk[i++] = buf[j++];
				}
			}
			wrk[i] = 0;
			strcpy(buf,wrk);
		}
		if(incrnum > 0
		&& didName
		&& strlen(buf) < sizeof(wrk)-8) {	/* Increment error line number */
			for(i=j=0; buf[j] != 0; ) {
				if(buf[j] == ':'
				&& buf[j+1] == ' '
				&& isdigit(buf[j+2])) {
					k = atoi(&buf[j+2]);
					for(j=j+2; isdigit(buf[j]); j++);
					i += sprintf(&wrk[i],": %d",k+incrnum);
				} else {
					wrk[i++] = buf[j++];
				}
			}
			wrk[i] = 0;
			strcpy(buf,wrk);
		}

		if(tabs) {
			for(i=j=0; buf[j] != 0; j++) {
				if(buf[j] == '\t') {
					wrk[i++] = ' ';
					while( (i%3) != 0)
						wrk[i++] = ' ';
				} else {
					wrk[i++] = buf[j];
				}
			}
			wrk[i] = 0;
			fprintf(fo,"%s\n",wrk);
		} else {
			fprintf(fo,"%s\n",buf);
		}
		memset(buf,0,sizeof(buf));
		atBegin = 0;
	}
}

/*
 * Build command and replace @f and @F
 */
static char *
makeCommand(
	char	*out,
	char	*cmd,
	char	*progout,
	char	*prog,
	char	*cmod)
{
	int j,k;
	for(j=k=0; cmd[j] != 0; j++) {
		if(memcmp(&cmd[j],"@f",2) == 0) {
			k += sprintf(&out[k],"%s",progout);
			j++;
		} else if(memcmp(&cmd[j],"@F",2) == 0) {
			k += sprintf(&out[k],"%s",prog);
			j++;
		} else if(memcmp(&cmd[j],"@c",2) == 0) {
			if(cmod[0] > ' ')
				k += sprintf(&out[k],"%s",cmod);
			j++;
		} else {
			out[k++] = cmd[j];
		}
	}
	out[k] = 0;
	for(j=k=0; out[j] != 0; j++) {		/* Remove multiple spaces */
		if(out[j] == ' ')
			while(out[j+1] == ' ')
				j++;
		out[k++] = out[j];
	}
	out[k] = 0;
	return out;
}

/*
 * Read thru file, sniff for directives
 */

static void
snifFile(FILE *fi, int *fixedFormat, 
	int look4summary, char *testsummary,
	int look4keyword, char *testkeyword)
{
	char	buf[1024],upr[1024],*p;
	int	i,k;
	if(fi == NULL)
		return;
	if(ferror(fi))
		return;
	if(feof(fi))
		return;
	while(fgets(buf,sizeof(buf),fi) != NULL) {
		for(k=strlen(buf); buf[k-1] == '\r' || buf[k-1] == '\n' || buf[k] == ' '; k--);
		buf[k] = 0;
		for(i=0; i < k; i++)
			upr[i] = toupper(buf[i]);
		upr[i] = 0;
		if(strstr(upr,">>") != NULL
		&& strstr(upr,"SOURCE") != NULL 
		&& strstr(upr,"FORMAT") != NULL ) {
			if( strstr(upr,"FREE") != NULL )
				*fixedFormat = 0;
			if( strstr(upr,"FIXED") != NULL )
				*fixedFormat = 1;
		}
		if(look4summary) {
			if((p = strstr(buf,"SUMMARY:")) != NULL) {
				p = p + 8;
				while(*p == ' ') p++;
				strcpy(testsummary,p);
				look4summary = 0;
			}
		}
		if(look4keyword) {
			if((p = strstr(buf,"KEYWORD:")) != NULL) {
				p = p + 8;
				while(*p == ' ') p++;
				strcpy(testkeyword,p);
				look4keyword = 0;
			}
		}
	}
	fclose(fi);
}

#define dMaxFile 12
/*
 * M A I N L I N E   Starts here
 */
int
main(
	int		argc,
	char	*argv[])
{
	int		opt,i,j,k,compsts,runsts;
	int		getSummary = 1;
	int		getKeyword = 1;
	int		fixedFormat = 1;
	int		bCompileOnly = 0;
	int		bCompileModule = 0;
	int		bCompile = 1;
	int		bWall = 1;
	int		bStdMf = 0;
	int		bStdIBM = 0;
	int		bStd2002 = 0;
	int		bStd2014 = 0;
	int		bStd85 = 0;
	int		bStdDefault = 0;
	int		bAppendAutoTest = 0;
	int		bDoSetup = 0;
	int		preln;
	char	inpdd[48],outdd[48],*p,setdd[48],settestfile[200];
	char	tmp[300],wrk[200],progout[200],cmod[80], cobstd[16], autoname[48];
	char	setup[200],keywords[200],callfh[48];
	char	inptestfile[200],outtestfile[200],compilecmd[256];
	char	outlst[80],errlst[80],compprefx[64];
	char	libs[256],flags[128], exshr[8];
	char	compFiles[dMaxFile][80];
	char	outFiles[dMaxFile][80];
	char	ddFiles[dMaxFile][80];
	char	bookFiles[dMaxFile][80];
	char	setEnv[dMaxFile][80];
	char	setCompEnv[dMaxFile][80];
	char	setDef[dMaxFile][80];
	FILE	*at,*fi;
	int		numComp = 0;
	int		addBlank = 0, numFiles = 0, numBooks = 0, numEnv = 0, numDef = 0, numCenv = 0;

	strcpy(setup,"SAMPLE PROGRAM");
	strcpy(keywords,"report");
	strcpy(outlst,"./stdout.lst");
	strcpy(errlst,"./stderr.lst");
	strcpy(inpdd,"INPUT");
	strcpy(outdd,"OUTPUT");
	memset(inptestfile,0,sizeof(inptestfile));
	memset(outtestfile,0,sizeof(outtestfile));
	memset(progname,0,sizeof(progname));
	memset(progexe,0,sizeof(progexe));
	memset(cmod,0,sizeof(cmod));
	memset(callfh,0,sizeof(callfh));
	memset(libs,0,sizeof(libs));
	memset(flags,0,sizeof(flags));
	memset(autoname,0,sizeof(autoname));
	putenv("SHELL=/bin/sh");
	putenv("COMPILE_MODULE=cobc");
	putenv("COMPILE_ONLY=cobc");
	putenv("COMPILE=cobc");
	putenv("COBC=cobc");
	strcpy(exshr,"-x");
	strcpy(cobstd,"default");
	bStdDefault = 1;
	while ((opt=getopt(argc, argv, "ai:o:O:c:d:hp:B:C:D:X:s:S:k:x:eEgbImwvVM:t:L:l:f:F:Z:")) != EOF) {
		switch(opt) {
		case 'a':
			bAppendAutoTest = 1;
			break;
		case 'v':
			bVerbose = 1;
			break;
		case 'm':
			bStdIBM = bStd2002 = bStd2014 = bStd85 = bStdDefault = bStdMf = 0;
			bStdMf = 1;
			bCompile = 0;
			strcpy(cobstd,"mf");
			break;
		case 'I':
			bStdIBM = bStd2002 = bStd2014 = bStd85 = bStdDefault = bStdMf = 0;
			bStdIBM = 1;
			strcpy(cobstd,"ibm");
			break;
		case 't':
			bStdIBM = bStd2002 = bStd2014 = bStd85 = bStdDefault = bStdMf = 0;
			if (strstr(optarg,"2002")) {
				bStd2002 = 1;
				strcpy(cobstd,"cobol2002");
			} else if (strstr(optarg,"2014")) {
				bStd2014 = 1;
				strcpy(cobstd,"cobol2014");
			} else if (strstr(optarg,"85")) {
				bStd85 = 1;
				strcpy(cobstd,"cobol85");
			} else if (strstr(optarg,"ibm")) {
				bStdIBM = 1;
				strcpy(cobstd,"ibm");
			} else if (strstr(optarg,"mvs")) {
				bStdIBM = 1;
				strcpy(cobstd,"mvs");
			} else if (strstr(optarg,"mf")) {
				bStdMf = 1;
				strcpy(cobstd,"mf");
			} else if (strstr(optarg,"bs2000")) {
				strcpy(cobstd,"bs2000");
			} else if (strstr(optarg,"acu")) {
				strcpy(cobstd,"acu");
			} else if (strstr(optarg,"realia")) {
				strcpy(cobstd,"realia");
			} else if (strstr(optarg,"xopen")) {
				strcpy(cobstd,"xopen");
			} else {
				bStdDefault = 1;
				strcpy(cobstd,"default");
			}
			break;
		case 'w':
			bWall = 0;	/* No warnings */
			bCompile = 0;
			break;
		case 'M':		/* COMPILE subroutine */
			strcpy(autoname,optarg);
			break;
		case 'g':		/* COMPILE subroutine */
			bCompileOnly = 1;
			bCompileModule = 1;
			strcpy(exshr,"");
			bShareMod = 1;
			break;
		case 'e':		/* COMPILE only as errors expected */
			bCompileOnly = 1;
			break;
		case 'E':		/* COMPILE only as errors expected */
			bCompileOnly = 1;
			bStdIBM = bStd2002 = bStd2014 = bStd85 = bStdDefault = bStdMf = 0;
			bStdMf = bStd2002 = 1;
			strcpy(cobstd,"default");
			break;
		case 'i':
			getFileName(inpdd,inptestfile,optarg);
			break;
		case 'o':
			getFileName(outdd,outtestfile,optarg);
			break;
		case 'O':
			if(numFiles < dMaxFile) {
				getFileName(setdd,settestfile,optarg);
				strcpy(outFiles[numFiles],settestfile);
				strcpy(ddFiles[numFiles],setdd);
				if(setdd[0] > ' ') {
					sprintf(wrk,"%s=%s",setdd,settestfile);
					putenv(strdup(wrk));
					unlink(settestfile);
				} else {
					unlink(optarg);
				}
				numFiles++;
			}
			break;
		case 'Z':
			if(numComp < dMaxFile) {
				strcpy(compFiles[numComp],optarg);
				unlink(optarg);
				numComp++;
			}
			break;
		case 'c':
			strcpy(compilecmd,optarg);
			break;
		case 'd':
			strcpy(diffProg,optarg);
			break;
		case 's':
			strcpy(setup,optarg);
			getSummary = 0;
			bDoSetup = 1;
			break;
		case 'S':
			if(numEnv < dMaxFile) {
				strcpy(setEnv[numEnv],optarg);
				putenv(strdup(optarg));
				numEnv++;
			}
			break;
		case 'D':
			if(numDef < dMaxFile) {
				strcpy(setDef[numDef],optarg);
				numDef++;
			}
			break;
		case 'X':
			if(numCenv < dMaxFile) {
				strcpy(setCompEnv[numCenv],optarg);
				numCenv++;
			}
			break;
		case 'x':
			strcpy(callfh,optarg);
			break;
		case 'k':
			strcpy(keywords,optarg);
			getKeyword = 0;
			break;
		case 'p':
			strcpy(progname,optarg);
			strcpy(progexe,optarg);
			if((p=strchr(progexe,'.')) != NULL) 
				*p = 0;
			break;
		case 'C':
			strcpy(cmod,optarg);
			break;
		case 'B':
			if(numBooks < dMaxFile)
				strcpy(bookFiles[numBooks++],optarg);
			break;
		case 'b':
			addBlank = incrErr = 1;
			break;
		case 'L':
			sprintf(&libs[strlen(libs)]," -L%s",optarg);
			break;
		case 'l':
			sprintf(&libs[strlen(libs)]," -l%s",optarg);
			break;
		case 'f':
			if (strcasecmp(optarg,"isam") == 0) {
				bNeedsIsam = 1;
				break;
			}
			sprintf(&flags[strlen(flags)]," -f%s",optarg);
			break;
		case 'F':
			sprintf(&flags[strlen(flags)]," -%s",optarg);
			if(strcmp(optarg,"m")==0) {
				strcpy(exshr,"");
				bShareMod = 1;
			}
			break;
		default:
			printf("Unknown option '%c' \n",opt);
		case 'h':
			usage(argv[0]);
			exit(EXIT_FAILURE);
			break;
		case 'V':
			printf("GnuCOBOL compile a COBOL program, execute & capture output\n");
			printf("%s compiled on %s %s\n",__FILE__,__DATE__,__TIME__);
			exit(EXIT_FAILURE);
			break;
		}
	}

	if(bWall) {
		sprintf(compprefx,"$%s %s -std=%s -debug -Wall",
					bCompileModule?"COMPILE_MODULE":"COMPILE",
					exshr,cobstd);
	} else {
		sprintf(compprefx,"$COBC %s -std=%s -w",exshr,cobstd);
	}
	if(callfh[0] > ' ')
		sprintf(&compprefx[strlen(compprefx)]," -use-extfh=%s",callfh);
	preln = strlen(compprefx);
	sprintf(compilecmd,"%s%s%s -o @f @F @c",compprefx,libs,flags);	/* Collect warnings */
	if(progname[0] <= ' '
	&& optind < argc) {
		strcpy(progname,argv[optind]);
	}
	if(progname[0] <= ' ') {
	        fprintf(stderr, "Missing program name to test;\n");
		usage(argv[0]);
		exit(EXIT_FAILURE);
	}
	strcpy(progout,progname);
	if((p=strrchr(progout,'.') ) != NULL)
		*p = 0;
	sprintf(tmp,"./%s",progout);
	unlink(tmp);
	fi = fopen(progname,"r");
	if(fi == NULL) {
		perror(progname);
		exit(EXIT_FAILURE);
	}
	snifFile(fi,&fixedFormat,getSummary,setup,getKeyword,keywords);
	fi = NULL;
	sprintf(tmp,"%s.at",progout);
	if(autoname[0] > ' ')
		sprintf(tmp,"%s.at",autoname);
	at = fopen(tmp,bAppendAutoTest?"a":"w");
	if(at == NULL) {
		perror(tmp);
		exit(EXIT_FAILURE);
	}
	fprintf(at,"\n");
	if(autoname[0] <= ' '
	|| bDoSetup
	|| !bAppendAutoTest) {
		fprintf(at,"AT_SETUP([%s])\n",setup);
		fprintf(at,"AT_KEYWORDS([%s])\n",keywords);
		fprintf(at,"\n");
		if (bNeedsIsam)
			fprintf(at,"AT_SKIP_IF([test \"$COB_HAS_ISAM\" = \"no\"])\n\n");
	}

	if(inptestfile[0] > ' ') {
		sprintf(tmp,"DD_%s=%s",inpdd,inptestfile);
		putenv(strdup(tmp));
	}
	if(outtestfile[0] > ' ') {
		sprintf(tmp,"DD_%s=%s",outdd,outtestfile);
		putenv(strdup(tmp));
	}
	makeCommand(tmp,compilecmd,progout,progname,cmod);
	unlink(outlst); unlink(errlst);
	for(i=0; i <numCenv; i++) {
		putenv(strdup(setCompEnv[i]));
	}
	for(i=0; i < numDef; i++) {
		sprintf(&tmp[strlen(tmp)]," -D%s",setDef[i]);
	}
	sprintf(&tmp[strlen(tmp)]," 1>%s 2>%s",outlst,errlst);
	compsts = system(tmp);
	if(compsts != 0)
		fprintf(stderr, "Compile of %s failed!\n",progname);
	if(inptestfile[0] > ' '
	&& compsts == 0) {
		fi = fopen(inptestfile,"r");
		if(fi == NULL) {
			perror(inptestfile);
			exit(EXIT_FAILURE);
		}
		fprintf(at,"AT_DATA([inp_data],[");
		copyFile(fi,at,0,0,0,NULL,NULL,0,0);
		fclose(fi);
		fi = NULL;
		fprintf(at,"])\n\n");
	}

	for(i=0; i < numBooks; i++) {
		fprintf(at,"\n");
		fprintf(at,"AT_DATA([./%s], [",bookFiles[i]);
		fi = fopen(bookFiles[i],"r");
		if(fi) {
			copyFile(fi,at,0,0,0,NULL,NULL,0,0);
			fclose(fi);
			fi = NULL;
		}
		fprintf(at,"])\n\n");
	}

	fi = fopen(progname,"r");
	if(fi == NULL) {
		perror(progname);
		exit(EXIT_FAILURE);
	}
	if(bCompileModule) {
		fprintf(at,"AT_DATA([%s], [",progname);
		copyFile(fi,at,addBlank,fixedFormat,0,NULL,NULL,0,0);
	} else {
		fprintf(at,"AT_DATA([prog.cob], [");
		copyFile(fi,at,addBlank,fixedFormat,0,NULL,NULL,0,0);
	}
	fclose(fi);
	fi = NULL;
	fprintf(at,"])\n\n");

	if(cmod[0] > ' ') {
		fi = fopen(cmod,"r");
		if(fi == NULL) {
			perror(cmod);
			exit(EXIT_FAILURE);
		}
		fprintf(at,"AT_DATA([cmod.c], [[");
		copyFile(fi,at,addBlank,0,0,NULL,NULL,0,1);
		fclose(fi);
		fi = NULL;
		fprintf(at,"]])\n\n");
	}

ReDoCompile:
	if(!bCompile) {
		strcpy(wrk,compilecmd);
	} else
	if(memcmp(compilecmd,compprefx,preln) == 0) {
		sprintf(wrk,"$COMPILE -std=%s %s",cobstd,&compilecmd[preln]);
		if(bCompileModule)
			sprintf(wrk,"$COMPILE_MODULE -std=%s -m %s",cobstd,&compilecmd[preln]);
		else if(bCompileOnly && numComp == 0)
			sprintf(wrk,"$COMPILE_ONLY -std=%s %s",cobstd,&compilecmd[preln]);
	} else if(memcmp(compilecmd,"cobc -x",7) == 0) {
		sprintf(wrk,"$COMPILE -std=%s %s",cobstd,&compilecmd[7]);
		if(bCompileModule)
			sprintf(wrk,"$COMPILE_MODULE -std=%s -m %s",cobstd,&compilecmd[7]);
		else if(bCompileOnly && numComp == 0)
			sprintf(wrk,"$COMPILE_ONLY -std=%s %s",cobstd,&compilecmd[7]);
	} else {
		strcpy(wrk,compilecmd);
	}
	if(bCompileModule) {
		makeCommand(tmp,wrk,progexe,progname,cmod[0]>' '?"cmod.c":"");
	} else {
		makeCommand(tmp,wrk,"prog","prog.cob",cmod[0]>' '?"cmod.c":"");
	}
	if((p=strstr(tmp,"-o prog ")) != NULL) {
		memmove(p,p+8,48);
	}
	for(i=0; i < numDef; i++) {
		sprintf(&tmp[strlen(tmp)]," -D%s",setDef[i]);
	}
	fprintf(at,"AT_CHECK([");
	for(i=0; i <numCenv; i++) {
		fprintf(at,"export %s; ",setCompEnv[i]);
	}
	fprintf(at,"%s], [%d], [],",tmp,WEXITSTATUS(compsts));
	if(bCompileOnly)
		fprintf(at,"\n[");
	else
		fprintf(at," [");
	fi = fopen(errlst,"r");
	if(fi) {
		copyFile(fi,at,0,0,1,progname,"prog.cob",incrErr,0);
		fclose(fi);
		fi = NULL;
	}
	fprintf(at,"])\n\n");
	if(bCompileOnly
	&& bStdMf
	&& bStd2002) {
		bStdMf = 0;
		if(bWall) {
			sprintf(compprefx,"$%s %s -std=%s -debug -Wall",
							bCompileModule?"COMPILE_MODULE":"COMPILE",
							exshr,"cobol2002");
		} else {
			putenv("COBC=cobc");
			sprintf(compprefx,"$COBC %s -std=%s -w",exshr,"cobol2002");
		}
		preln = strlen(compprefx);
		sprintf(compilecmd,"%s -o @f @F @c",compprefx);	/* Collect warnings */
		makeCommand(tmp,compilecmd,progout,progname,cmod);
		unlink(outlst); unlink(errlst);
		sprintf(&tmp[strlen(tmp)]," 1>%s 2>%s",outlst,errlst);
		compsts = system(tmp);
		if(compsts != 0)
			printf("Second Compile of %s failed!\n",progname);
		goto ReDoCompile;
	}
	for(i=0; i < numComp; i++) {
		fprintf(at,"\n");
		fprintf(at,"AT_CAPTURE_FILE(./%s)\n\n",compFiles[i]);
		fprintf(at,"AT_DATA([reference], [");
		fi = fopen(compFiles[i],"r");
		if(fi) {
			copyFile(fi,at,0,0,0,NULL,NULL,0,0);
			fclose(fi);
			fi = NULL;
		}
		fprintf(at,"])\n\n");
		fprintf(at,"AT_CHECK([%s -I# reference %s], [0], [], [])\n\n",diffProg,compFiles[i]);
	}
	if(compsts == 0 && !bCompileOnly) {
		sprintf(tmp,"./%s 1>%s 2>%s",progout,outlst,errlst);
		runsts = system(tmp);
		if(runsts != 0) {
			printf("Execution of %s failed! Status: 0x%04X; ",progname, runsts);
			if( WIFEXITED(runsts) ) {
				printf("exit %d\n", WEXITSTATUS(runsts));
			} else if(  !WIFSIGNALED(runsts) ) {
				printf("(neither normal exit nor signaled?)\n");
			} else {
				assert(WIFSIGNALED(runsts));
				const char *core_file = "";
#if defined(WCOREDUMP)
				if( WCOREDUMP(runsts) ) {
					core_file = "(core_file)";
				}
#endif
				printf("exit %d %s\n", WTERMSIG(runsts), core_file);
			}
		}
		fprintf(at,"AT_CHECK([");
		if(inptestfile[0] > ' ') {
			fprintf(at,"export DD_%s=%s\n",inpdd,"./inp_data");
		}
		if(outtestfile[0] > ' ') {
			fprintf(at,"export DD_%s=%s\n",outdd,"./report.txt");
		}
		for(i=0; i < numFiles; i++) {
			if (ddFiles[i][0] > ' ') {
				fprintf(at,"export %s=%s\n",ddFiles[i],outFiles[i]);
			}
		}
		for(i=0; i < numEnv; i++) {
			if (setEnv[i][0] > ' ') {
				fprintf(at,"export %s\n",setEnv[i]);
			}
		}
		fprintf(at,"$COBCRUN_DIRECT ./prog], [%d], ",WEXITSTATUS(runsts));
		fi = fopen(outlst,"r");
		if(fi) {
			fprintf(at,"[");
			copyFile(fi,at,0,0,1,NULL,NULL,0,0);
			fclose(fi);
			fi = NULL;
			fprintf(at,"]");
		}
		fi = fopen(errlst,"r");
		if(fi) {
			fprintf(at,", [");
			copyFile(fi,at,0,0,1,progname,"prog.cob",incrErr,0);
			fclose(fi);
			fi = NULL;
			fprintf(at,"]");
		}
		fprintf(at,")\n\n");

		fi = fopen("gcdiff.conf","r");
		if(fi) {
			fprintf(at,"AT_DATA([gcdiff.conf], [");
			copyFile(fi,at,0,0,0,NULL,NULL,0,0);
			fclose(fi);
			fi = NULL;
			fprintf(at,"])\n\n");
		}

		if(outtestfile[0] > ' ') {
			fprintf(at,"\n");
			fprintf(at,"AT_CAPTURE_FILE(%s)\n\n","./report.txt");
			fprintf(at,"AT_DATA([reference], [");
			fi = fopen(outtestfile,"r");
			if(fi) {
				copyFile(fi,at,0,0,0,NULL,NULL,0,0);
				fclose(fi);
				fi = NULL;
			}
			fprintf(at,"])\n\n");
			fprintf(at,"AT_CHECK([%s reference report.txt], [0])\n\n",diffProg);
		}
		for(i=0; i < numFiles; i++) {
			fprintf(at,"\n");
			fprintf(at,"AT_CAPTURE_FILE(./%s)\n\n",outFiles[i]);
			fprintf(at,"AT_DATA([reference], [");
			fi = fopen(outFiles[i],"r");
			if(fi) {
				copyFile(fi,at,0,0,0,NULL,NULL,0,0);
				fclose(fi);
				fi = NULL;
			}
			fprintf(at,"])\n\n");
			fprintf(at,"AT_CHECK([%s reference %s], [0], [], [])\n\n",diffProg,outFiles[i]);
		}
	}
	if (!bShareMod)
		fprintf(at,"AT_CLEANUP\n\n");
	fclose(at);
	unlink(outlst); unlink(errlst);
	if(!bCompileModule) {
		sprintf(tmp,"./%s",progout);
		unlink(tmp);
	}

	return EXIT_SUCCESS;
}

