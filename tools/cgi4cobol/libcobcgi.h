/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License, Version 1.0 only
 * (the "License").  You may not use this file except in compliance
 * with the License.
 *
 * You can obtain a copy of the license at license/CDDL_1.LICENSE
 * or at https://opensource.org/licenses/CDDL-1.0
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at license/CDDL.LICENSE.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 *
 * libcobcgi.h - COBCGI library of GnuCobol
 * Copyright (C) 2016 by Wim Niemans <niemans@pbsolo.nl>
 * [based on ideas gathered from various cgi libraries and template engines]
 *
 */

#ifdef __cplusplus 
extern "C" {
#endif

#define _COBCGI_MAX_LINE_TPL 128
#define _COBCGI_MAX_LINE_OUT 512

struct config {
       int autoHeader;                           /* CGI_AUTO_HEADER          : 0 = none, 1 = html, 2 = plain        */
       int stripCr;                              /* CGI_STRIP_CR             : 0 = none, 1 = strip cr from vars     */
       int noCache;                              /* CGI_NO_CACHE             : 0 = insert pragma, 1 = no cache      */
       int clearMissing;                         /* CGI_CLEAR_MISSING_VALUES : 0 = none, 1 = clear tokens not found */
};

struct template {
 const char *prefix;                             /* HTML_TEMPLATE_PREFIX     : path name(s)                         */
       int   unknowns;                           /* HTML_TEMPLATE_UNKNOWNS   : 0 = remove, 1 = leave as is          */
 const char *contentType;                        /* CGI_CONTENT_TYPE         : contentType + optional charset       */
       char   inBuf[_COBCGI_MAX_LINE_TPL + 1];
       char  outBuf[_COBCGI_MAX_LINE_OUT + 1];
};

struct nameValueToken {
    struct nameValueToken *next;
    const char *name;
	const char *value;
          char  token[];
};

struct tokenList {
       int tokenCount;
       int listSeq;                 /* 1 = fifo, 2 = lifo */
	struct nameValueToken *tokens;
    struct nameValueToken *last;    /* needed for fifo only */
};

             void  cgi_configure();                                /* set defaults & get from environment      */
/* ----------------------------------------------------------------- Input ----------------------------------------*/
             void  cgi_consumeCgiPayload();                        /* returns the tokenized form variables.    */
             void  cgi_addCgiVar(char *name, char *value);         /* add the name=value to cgiTokenList       */
extern const char *cgi_getCgiValue(const char *name, int seq);     /* returns a value from a named cgiVariable */
/* ----------------------------------------------------------------- Output ---------------------------------------*/
       const char *cgi_getTplValue(const char *name);              /* returns a value from q named tplVariable */
extern       void  cgi_addTplVar(char *name, char *value);         /* add the name=value to tplTokenList       */
             void  cgi_HttpHeader();                               /* prints a valid Http Header               */
             void  cgi_cgi_Redirect(const char *url);              /* provides a valid redirect for web pages. */
extern       int   cgi_renderTpl(const char *filename);            /* displays the template -file- while       */
                                                                       /*                substituting line-by-line */
/* ----------------------------------------------------------------- Utils ----------------------------------------*/
             void  cgi_addToken(struct tokenList *thisTokenList,   /*                                          */
                                    char *name, char *value);          /* add a name=value pair to a tokenList     */
       const char *cgi_getValue(struct tokenList *thisTokenList,   /*                                          */
                                     const char *name, int seq);       /* returns a value from a named variable    */
             char *cgi_getLine(FILE *stream);                      /* returns the next line of template -file- */
             char *cgi_Substitute(char *haystack);                 /* substitutes %%-tokens in haystack        */
             char *cgi_DecodeString(char *text);                   /* decodes a cgi string %HH                 */
/* ----------------------------------------------------------------- Debug ----------------------------------------*/
extern       void  cgi_Debug(int level, int where);                /* configures debugging features            */
             void  cgi_DebugOutput(int level, char *format, ...);  /* prints debug messages                    */
             char *cgi_DebugInput();                               /* allows for manual input of cgi variables */
/* ----------------------------------------------------------------------------------------------------------------*/

#ifdef __cplusplus
extern }
#endif
