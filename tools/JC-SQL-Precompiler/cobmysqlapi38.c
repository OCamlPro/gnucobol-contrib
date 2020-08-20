/*  cob-mysql  Version  3.2                            18/May/2014    */
/*  Copyright (C) sanpontze. All Rights Reserved                      */
/*  cobmysqlapi versions 3.6 - 3.7, copyright. The_Piper, GPL v3      */
/*                                                                    */
/*  cobmysqlapi Version 3.8                                           */
/*  Copyright (c) Vincent Coen, under GPL v3 2017 - 2018              */
/*  Use with library sources from mysql-connector-c via mysql.com and
 *   other source locations                                           */
/**********************************************************************
*   Version 003--Changed to correctly map to COBOL data types.
*                05/07/2009--Marc Rodriguez
*   Version 004--Changed to correctly place NULLs into numeric types.
*                1225978--Sandy Doss
*                07/01/2009--Marc Rodriguez
*   Version 005--Added new MySQL call to fetch entire row selected
*                using "select *".  Also fixed potential bug in
*                MySQL_fetch_row that compares number of passed
*                parameters (inclusive of WS-MYSQL-RESULT) against
*                number of fields returning from MySQL select.
*                1331073--Jim Currey
*                12/16/2009--Pete McThompson
*
*   Version 006--Changes to work together with the precompiler
*                Added commit() and rollback() functions
*                Added read_params()
*                04/18/2012--The_Piper@web.de
*
*   Version 007--Changes to work together with GnuCobol either 1.xx and 2.xx
*                05/18/2014--The_Piper@web.de 20140518
*
*   Version 3.8--Changed version style to n.yy
*                Added mysql_sqlstate to get the ANSI & ODBC standard error codes
*                A value that begins with "00" means “no error.”
*                A value of "HY000" means “general error.”
*                This value is used for those MySQL errors that have not yet
*                 been assigned more-specific SQLSTATE codes.
*                Why? because writing a dup key does not create an error within
*                 SQL-ERR and for SQL_STATE it does (23000) there could be other
*                examples of such:
*                A full list of these codes can be found in :
*                /usr/include/mysql/sql_state.h assuming you have installed
*                mysql-connector-c-6.1.6-src.tar.gz (.rpm or .zip etc)
*                Latest versions will always be available here :
*                03 Jan 2017--Vincent Coen - Applewood Computers {170103}
*                [http://www.applewood.linkpc.net/files/ ]
*
*   Version 3.8A--Updated url here as address has small change
*                [http://www.applewood.linkpc.net/files/ ]
*                v3.8 is corrected.
*
**********************************************************************/

#include        <stdio.h>
#include        <string.h>
#include        <stdarg.h>
#include        <mysql.h>
#include        <libcob.h>
#include        <stdlib.h>                                                             //121609
#include        <syslog.h>                                                             //121609

#define min(a,b) ((a) < (b) ? (a) : (b))

#ifdef cob_c8_t  // for GnuCobol 2.xx  20140518
	#define cob_call_params cobglobptr->cob_call_params
	#define cob_current_module cobglobptr->cob_current_module
	static
	//void *cobglobptr;
	cob_global *cobglobptr;
#endif

//function pointer prototype should not include paramater names                        //121609
//static int (*func)(char *errno, const char *errmsg);                                 //121609
static int (*func)(char *, const char *);                                              //121609

MYSQL            sql, *mysql=&sql;
static int       errout;

static const cob_field_attr MYSQL_FIELD_ATTRIBUTES = {33, 0, 0, 0, NULL};

/******************************************************************************/
int cobapi_read_line(FILE *fp, char *s){
	int z;
	int c;

	for(z=0;;){
		c=fgetc(fp);
		if(c==EOF || c=='\n'){
			s[z]=0;
			break;
		}
		else{
			if(c!='\r'){
				s[z++]=c;
			}
		}
	}
}
/******************************************************************************/
void cobapi_trim(char *s)
{
   int l;

   l=strlen(s)-1;
   for(;;){
      if(l<1) break;
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
void read_params(char progname[10], char host[32], char user[32], char passwd[32], char dbname[32], char port[32], char socket[32])
{
	FILE *fp;
	char zwi[256];
	char zwi2[256];
	int c;
	int z;

	//printf("in read_params\n");
	//printf("in read_params, progname=>%s<\n", progname);
	strcpy(zwi, progname);
	cobapi_trim(zwi);
	sprintf(zwi2, "%s.param", zwi);
	fp=fopen(zwi2, "rb");
	if(fp==NULL){
		printf("Could not read file >%s<, aborting...\n", zwi2);
		exit(5);
	}

	cobapi_read_line(fp, zwi);
	if(strncmp(zwi, "DBHOST=", 7)!=0){
		printf("Invalid param card >%s<, DBHOST= expected. Aborting..\n", zwi);
		exit(6);
	}
	strncpy(host, zwi+7, 32);

	cobapi_read_line(fp, zwi);
	if(strncmp(zwi, "DBUSER=", 7)!=0){
		printf("Invalid param card >%s<, DBUSER= expected. Aborting..\n", zwi);
		exit(6);
	}
	strncpy(user, zwi+7, 32);

	cobapi_read_line(fp, zwi);
	if(strncmp(zwi, "DBPASSWD=", 9)!=0){
		printf("Invalid param card >%s<, DBPASSWD= expected. Aborting..\n", zwi);
		exit(6);
	}
	strncpy(passwd, zwi+9, 32);

	cobapi_read_line(fp, zwi);
	if(strncmp(zwi, "DBNAME=", 7)!=0){
		printf("Invalid param card >%s<, DBNAME= expected. Aborting..\n", zwi);
		exit(6);
	}
	strncpy(dbname, zwi+7, 32);

	cobapi_read_line(fp, zwi);
	if(strncmp(zwi, "DBPORT=", 7)!=0){
		printf("Invalid param card >%s<, DBPORT= expected. Aborting..\n", zwi);
		exit(6);
	}
	strncpy(port, zwi+7, 32);

	cobapi_read_line(fp, zwi);
	if(strncmp(zwi, "DBSOCKET=", 9)!=0){
		printf("Invalid param card >%s<, DBSOCKET= expected. Aborting..\n", zwi);
		exit(6);
	}
	strncpy(socket, zwi+9, 32);

	fclose(fp);
}
/******************************************************************************/
void err_exit(int rc)
{

    char errno[10];

    if( !rc ) return;

    switch(errout){
        case 1:
             fprintf(stderr,"%d\n", mysql_errno(mysql));
             fprintf(stderr,"%s\n", mysql_error(mysql));
             return;
        case 2:
             break;
        case 3:
             sprintf(errno,"%d", mysql_errno(mysql));
             func(errno, mysql_error(mysql));
    }
    return;
}

void move_to_cob(char *cob_dat, const char *dat)
{
    int len = strlen(cob_dat);                      // data length in cob
    if(dat == NULL)
    {
      memset(cob_dat, 0, len);                      // clear with NULL
    }
    else
    {
      memset(cob_dat, ' ', len);                      // clear with spaces
      memcpy(cob_dat, dat, min(len, strlen(dat)));    // data copy
    }
    return;
}

void MySQL_affected_rows(int *no)
{
    *no =  mysql_affected_rows(mysql);
    return;
}


int MySQL_change_user(const char *user, const char *passwd, const char *db)
{
    int rc;
    rc = mysql_change_user(mysql, user, passwd, db);
    err_exit(rc);
    return  rc;
}


void MySQL_close(void)
{
    mysql_close(mysql);
    return;
}


void MySQL_errno(char *errno)
{
    char buf[10];
    sprintf(buf,"%d", mysql_errno(mysql));
    move_to_cob(errno, buf);
    return;
}


void MySQL_error(char *errmsg)
{
    move_to_cob(errmsg, mysql_error(mysql));
    return;
}

/*
 * New routine for getting sqlstate error codes.                                       //170103
 *                                                                                     //170103
 * The sources for these error codes can be found for most Linux installs              //170103
 * at /usr/includes/mysql/sql_state.h having installed the source from                 //170103
 * mysql-connector-c-6.1.6-src or later.                                               //170103
 */

void MySQL_sqlstate(char *sqlstate)                                                    //170103
{                                                                                      //170103
    move_to_cob(sqlstate, mysql_sqlstate(mysql));                                      //170103
    return;                                                                            //170103
}                                                                                      //170103

void MySQL_fetch_field(MYSQL_RES **result, int *pos, char *field)
{

    MYSQL_FIELD *fields;

    fields = mysql_fetch_fields(*result);
    move_to_cob(field, fields[ *pos - 1 ].name);
    return;
}


void MySQL_fetch_fields(MYSQL_RES **result, ...)
{
    int rc, j, colms;
    va_list args;
    MYSQL_FIELD *fields;

    va_start(args, result);
    colms = min(cob_call_params, mysql_num_fields(*result));
    fields = mysql_fetch_fields(*result);

    for(j=0; j<colms; j++){
       move_to_cob(va_arg(args, char *), fields[j].name);
    }
    va_end(args);
    return;
}

int MySQL_fetch_row(MYSQL_RES **result, ...)                                           //050709
{                                                                                      //050709
  MYSQL_ROW res;                                                                       //050709
  int rc, j, maxcols;                                                                  //050709
  res = mysql_fetch_row(*result);                                                      //050709
                                                                                       //050709
  if(res != NULL)                                                                      //050709
  {                                                                                    //050709
    // cob_call_params contains the number of parameters passed.  we subtract 1 to     //121609
    // account for the WS-MYSQL-RESULT.                                                //121609
#ifdef cob_c8_t  // for GnuCobol 2.xx  20140518
    maxcols = min(cob_call_params, mysql_num_fields(*result));
#else
    maxcols = min(cob_call_parameters - 1, mysql_num_fields(*result));                 //121609
#endif
    for(j=0; j<maxcols; j++)                                                           //050709
    {                                                                                  //050709
#ifdef cob_c8_t  // for GnuCobol 2.xx  20140518
      cob_field *cf_from_cobol = cob_current_module->cob_procedure_params[j+1];        //050709
#else
      cob_field *cf_from_cobol = cob_current_module->cob_procedure_parameters[j+1];    //050709
#endif
      if(res[j] == NULL)                                                               //050709
      {                                                                                //050709
      //memset(cf_from_cobol->data, (char)NULL, strlen(cf_from_cobol->data));          //070109
        memset(cf_from_cobol->data, 0, cf_from_cobol->size);                           //070109
      }                                                                                //050709
      else                                                                             //050709
      {                                                                                //050709
        cob_field cf_from_mysql = { strlen( res[j] ),                                  //050709
                                    (unsigned char *) res[j],                          //050709
                                    &MYSQL_FIELD_ATTRIBUTES                            //050709
                                  };                                                   //050709
        cob_move( &cf_from_mysql, cf_from_cobol );                                     //050709
      }                                                                                //050709
    }                                                                                  //050709
    rc = 0;                                                                            //050709
  }                                                                                    //050709
  else                                                                                 //050709
  {                                                                                    //050709
    if(*result!=NULL){ // no double free!!
    	mysql_free_result(*result);                                                    //050709
	 	*result=NULL;
	 }
    rc = -1;                                                                           //050709
  }                                                                                    //050709
  return rc;                                                                           //050709
}                                                                                      //050709


int MySQL_fetch_record(MYSQL_RES **result, ...)                                        //121609
{                                                                                      //121609
  MYSQL_ROW res;                                                                       //121609
  int rc, j, maxcols;                                                                  //121609
  char strError[255];                                                                  //121609
  res = mysql_fetch_row(*result);                                                      //121609
                                                                                       //121609
                                                                                       //121609
  if(res != NULL)                                                                      //121609
  {                                                                                    //121609
    // cob_call_params contains the number of parameters passed.  we subtract 1 to     //121609
    // account for the WS-MYSQL-RESULT.                                                //121609
    if(cob_call_params - 1 != mysql_num_fields(*result))                               //121609
    {                                                                                  //121609
      mysql_free_result(*result);                                                      //121609
      openlog(NULL, LOG_PERROR | LOG_PID | LOG_NDELAY, LOG_DAEMON);                    //121609
      sprintf(strError, "MySQL_fetch_record: fields mismatch. Given %i, expected %i",  //121609
              cob_call_params - 1, mysql_num_fields(*result));                         //121609
      syslog(1, strError);                                                             //121609
      closelog();                                                                      //121609
      exit(0);                                                                         //121609
    }                                                                                  //121609
    maxcols = mysql_num_fields(*result);                                               //121609
    for(j=0; j<maxcols; j++)                                                           //121609
    {                                                                                  //121609
      //cob_field *cf_from_cobol = cob_current_module->cob_procedure_parameters[j+1];  //121609
      cob_field *cf_from_cobol = cob_current_module->cob_procedure_params[j+1];        //121609
      if(res[j] == NULL)                                                               //121609
      {                                                                                //121609
        memset(cf_from_cobol->data, 0, cf_from_cobol->size);                           //121609
      }                                                                                //121609
      else                                                                             //121609
      {                                                                                //121609
        cob_field cf_from_mysql = { strlen( res[j] ),                                  //121609
                                    (unsigned char *) res[j],                          //121609
                                    &MYSQL_FIELD_ATTRIBUTES                            //121609
                                  };                                                   //121609
        cob_move( &cf_from_mysql, cf_from_cobol );                                     //121609
      }                                                                                //121609
    }                                                                                  //121609
    rc = 0;                                                                            //121609
  }                                                                                    //121609
  else                                                                                 //121609
  {                                                                                    //121609
    mysql_free_result(*result);                                                        //121609
    rc = -1;                                                                           //121609
  }                                                                                    //121609
  return rc;                                                                           //121609
}                                                                                      //121609


void MySQL_field_count(char count[9])
{
	int cnt;
   cnt = mysql_field_count(mysql);
	sprintf(count, "%08d", cnt);
	printf("cnt=%d count=>%s<\n", cnt, count);
   return;
}


void MySQL_free_result(MYSQL_RES **result)
{
    mysql_free_result(*result);
    return;
}

void MySQL_get_character_set_info(char *csname)
{
    MY_CHARSET_INFO cs;
    mysql_get_character_set_info(mysql, &cs);
    move_to_cob(csname, cs.name);
    return;
}


int MySQL_init(MYSQL **cid, ...)
{

    int rc,n;
    char *fname;
    va_list args;

#ifdef cob_c8_t // for GnuCobol 2.xx 20140518
	 cobglobptr=cob_get_global_ptr();
#endif

    *cid = mysql;

    rc = mysql_init(&sql) != NULL ? 0 : 1;
    va_start(args, cid);

    if(cob_call_params > 1){
       fname = va_arg(args, char *);
    }
    else {
       fname = "";
    }
    va_end(args);

    if( !strcmp(fname, "stderr") ){
        errout = 1;                               // stderr
    }
    else if( !strcmp(fname,"" ) ){
             errout = 2;                          // default
    }
    else {
       cob_init(0, NULL);
       func = cob_resolve(fname);
       if(func == NULL){
          fprintf(stderr, "%s\n", cob_resolve_error());
          return 1;
       }
       errout = 3;                                 // user function
    }

    err_exit(rc);
    return  rc;
}


int MySQL_list_tables( MYSQL_RES **res)
{
    int rc;
    *res = mysql_list_tables(mysql, NULL);
    rc = *res != NULL ? 0 : 1;
    err_exit(rc);
    return  rc;
}


void MySQL_num_fields(MYSQL_RES **result, int *cols)
{
    *cols = mysql_num_fields(*result);
    return;
}


void MySQL_num_rows(MYSQL_RES **result, int *rows)
{
    *rows = mysql_num_rows(*result);
    return;
}


int MySQL_query(char *query)
{
    int rc;
	 cobapi_trim(query);
	 //printf("mysql_query=>%s<\n", query);
    rc =  mysql_query(mysql, query);
    err_exit(rc);
    return  rc;
}


int MySQL_real_connect(char *host, char *user, char *passwd, char *db, char *xport, char *unix_socket)
{
    int      rc;
    int      port;
    MYSQL    *tmp;
	 char *socket;

	cobapi_trim(host);
	cobapi_trim(user);
	cobapi_trim(passwd);
	cobapi_trim(db);
	port=atoi(xport);
	cobapi_trim(unix_socket);
	if(unix_socket==NULL){
		socket=NULL;
	}
	else{
		if(strcmp(unix_socket, "0")==0 ||
		   strcmp(unix_socket, "null")==0 ||
			strcmp(unix_socket, "NULL")==0){
			socket=NULL;
		}
		else{
			socket=unix_socket;
		}
	}
	//printf("try to connect host=>%s< user=>%s< passwd=>%s< db=>%s< port=%d socket=>%s<\n", host, user, passwd, db, port, socket);
    tmp  =  mysql_real_connect(&sql, host, user, passwd, db, port, socket, 0);
    rc = tmp != NULL ? 0 : 1;
    err_exit(rc);
    return  rc;
}


int MySQL_selectdb(char *dbname)
{
    int rc;
	 cobapi_trim(dbname);
	 //printf("selectdb(%s)\n", dbname);
    rc = mysql_select_db(mysql, dbname);
    err_exit(rc);
    return  rc;
}

int MySQL_commit(void)
{
    int rc;
    rc = mysql_commit(mysql);
    err_exit(rc);
    return  rc;
}

int MySQL_rollback(void)
{
    int rc;
    rc = mysql_rollback(mysql);
    err_exit(rc);
    return  rc;
}


int MySQL_set_character_set(char *charset)
{
    int rc;
    rc = mysql_set_character_set(mysql, charset);
    err_exit(rc);
    return  rc;
}


int MySQL_store_result(MYSQL_RES **result)
{
    int rc;
    *result = mysql_store_result(mysql);
    rc = result != NULL ? 0 : 1;
    err_exit(rc);
    return  rc;
}


int MySQL_use_result(MYSQL_RES **result)
{
    int rc;
    *result = mysql_use_result(mysql);
    rc = result != NULL ? 0 : 1;
    err_exit(rc);
    return  rc;
}
