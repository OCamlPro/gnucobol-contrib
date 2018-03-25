/*  cob-mysql  Version  3.0                            25/Jul/2008   */
/*  Copyright (C) sanpontze. All Rights Reserved                     */
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
**********************************************************************/

#include        <stdio.h>
#include        <string.h>
#include        <stdarg.h>
#include        <mysql.h>
#include        <libcob.h>
#include        <stdlib.h>                                                             //121609
#include        <syslog.h>                                                             //121609

#define min(a,b) ((a) < (b) ? (a) : (b))

//function pointer prototype should not include paramater names                        //121609
//static int (*func)(char *errno, const char *errmsg);                                 //121609
static int (*func)(char *, const char *);                                              //121609

MYSQL            sql, *mysql=&sql;
static int       errout;

static const cob_field_attr MYSQL_FIELD_ATTRIBUTES = {33, 0, 0, 0, NULL};

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
    //maxcols = min(cob_call_params, mysql_num_fields(*result));                       //121609
    maxcols = min(cob_call_params - 1, mysql_num_fields(*result));                     //121609
    for(j=0; j<maxcols; j++)                                                           //050709
    {                                                                                  //050709
      cob_field *cf_from_cobol = cob_current_module->cob_procedure_parameters[j+1];    //050709
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
    mysql_free_result(*result);                                                        //050709
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
      cob_field *cf_from_cobol = cob_current_module->cob_procedure_parameters[j+1];    //121609
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


void MySQL_field_count(int *count)
{
    *count = mysql_field_count(mysql);
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
    rc =  mysql_query(mysql, query);
    err_exit(rc);
    return  rc;
}


int MySQL_real_connect(char *host, char *user, char *passwd, char *db, unsigned int port, char *unix_socket)
{
    int      rc;
    MYSQL    *tmp;

    tmp  =  mysql_real_connect(&sql, host, user, passwd, db, port, unix_socket, 0);
    rc = tmp != NULL ? 0 : 1;
    err_exit(rc);
    return  rc;
}


int MySQL_selectdb(char *dbname)
{
    int rc;
    rc = mysql_select_db(mysql, dbname);
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
