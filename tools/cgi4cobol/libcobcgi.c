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
 * libcobcgi.c - COBCGI library intended for GnuCobol
 * Copyright (C) 2016 by Wim Niemans <niemans@pbsolo.nl>
 * [based on ideas gathered from various cgi libraries and template engines]
 */

#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <syslog.h>

#include "libcobcgi.h"

int cgi_DebugLevel    = 0;
int cgi_DebugType     = 1;
int cgi_ConsumeDone   = 0;
int cgi_ConfigureDone = 0;

static struct config     cgi_config;
static struct template   cgi_template;
static struct tokenList *cgiTokenList;
static struct tokenList *tplTokenList;

/*
 *  This software interfaces with GET and POST methods, according to CGI specification.
 *  Also, a simple template engine (reading text files) is present: substitute %%parameter%% by some value.
 *  All input / output is reading from / writing to stdin / stdout.
 *  A basic debugging facility is present.
 *
 *  One may find the resemblance with acuCobol functionality striking.
 *
 *  Tokens. To avoid noise when talking about key-value pairs, name-value pairs and such, the term token is choosen.
 *  A token is simply such 'pair', like ABC=DEF, where ABC is the key/name and DEF is the value.
 *  A token must not have a 'pair' structure, like ..=..; a token might be 'positional'.
 *  The idea is that a token-stream consists of 'positional' tokens and/or 'keyword' tokens.
 */


void cgi_configure()
{
    if (cgi_ConfigureDone) { return; }
    else                       { cgi_ConfigureDone = 1; }

    char *autoHeader   = getenv("CGI_AUTO_HEADER");
    char *stripCr      = getenv("CGI_STRIP_CR");
    char *noCache      = getenv("CGI_NO_CACHE");
    char *clearMissing = getenv("CGI_CLEAR_MISSING_VALUES");
    char *prefix       = getenv("HTML_TEMPLATE_PREFIX");
    char *unknowns     = getenv("HTML_TEMPLATE_UNKNOWNS");
    char *contentType  = getenv("CGI_CONTENT_TYPE");

    if (autoHeader)        cgi_config.autoHeader    = atoi(autoHeader);
    else                   cgi_config.autoHeader    = 1;                    
    if (stripCr)           cgi_config.stripCr       = atoi(stripCr);
    else                   cgi_config.stripCr       = 0;
    if (noCache)           cgi_config.noCache       = atoi(noCache);
    else                   cgi_config.noCache       = 1;
    if (clearMissing)      cgi_config.clearMissing  = atoi(clearMissing);
    else                   cgi_config.clearMissing  = 1;

    if (prefix)            cgi_template.prefix      = prefix;
    else                   cgi_template.prefix      = NULL;
    if (unknowns)          cgi_template.unknowns    = atoi(unknowns);
    else                   cgi_template.unknowns    = 0;
    if (contentType)       cgi_template.contentType = contentType;
    else                   cgi_template.contentType = NULL;
}

/*-----------------------------------------CGI Input Processing ----------------------------*/

/*
 * Read the CGI payload from GET or POST (not both!)
 * and put all found name=value pairs into the static cgiTokenList.
 */
void cgi_consumeCgiPayload()
{
    if (cgi_ConsumeDone) { return; }
    else                     { cgi_ConsumeDone = 1; }

register int   i;
         int   content_length,  tokenCount,   payloadSource = 0;
        char  *request_method, *thisPayload, *tokenStart, *valueStart;
        char  *cobcgi_payload = NULL; 

    request_method = getenv("REQUEST_METHOD");

    if (request_method) {
        /* Depending on the request method, get the CGI payload. */
        if (!strcmp(request_method, "GET") || !strcmp(request_method, "HEAD") ) {
            /* !! Some servers don't provide QUERY_STRING if it's empty.  !! */
            cobcgi_payload = getenv("QUERY_STRING");
            payloadSource = 1;
        } else {
            if (!strcmp(request_method, "POST")) {
                /* strcasecmp() is not supported in Windows-- use strcmpi() instead */
                if ( strcasecmp(getenv("CONTENT_TYPE"), "application/x-www-form-urlencoded")) {
                    cgi_HttpHeader();
                    printf("cobcgi(): Unsupported Content-type.\r\n");
                    exit(1);
                }
                if ( !(content_length = atoi(getenv("CONTENT_LENGTH"))) ) {
                    cgi_HttpHeader();
                    printf("cobcgi(): Content-Length was not sent with the POST request.\r\n");
                    exit(1);
                }
                if ( !(cobcgi_payload = (char *) malloc(content_length + 2)) ) {
                    cgi_HttpHeader();
                    printf("cobcgi(): Out of Memory.\r\n");
                    exit(1);
                }
                if (!fgets(cobcgi_payload, content_length + 1, stdin)) {
                    cgi_HttpHeader();
                    printf("cobcgi(): Cannot access CGI variables from POST.\r\n");
                    exit(1);
                }
                cobcgi_payload[content_length + 2] = '\0';
            } else {
                cgi_HttpHeader();
                printf("cobcgi(): Unknown REQUEST_METHOD '%s'.\r\n", request_method);
                exit(1);
            }
        }
    } else {
        cobcgi_payload = cgi_DebugInput();
    }

	if (!cobcgi_payload || strlen(cobcgi_payload) < 1) return;      /* could be NULL or a pointer to NULL */
    if ( cobcgi_payload[strlen(cobcgi_payload) - 1] == '&') {       /* adjust payload if necessary        */
         cobcgi_payload[strlen(cobcgi_payload) - 1] = '\0';
    }

    cgi_DebugOutput (1, "request method '%s'", request_method);
    cgi_DebugOutput (1, "Received CGI input: %s", cobcgi_payload);

    cgi_addCgiVar("$0", cobcgi_payload);

    /*  First, convert all '+' into spaces. Do NOT decode the strings yet. */
    for (i=0; cobcgi_payload[i]; i++) if (cobcgi_payload[i] == '+') cobcgi_payload[i] = ' ';

    /* Than, split on "&" (or ";") using strsep(), and extract the name=value pairs and add the cgiVar to a tokenList. */
    tokenCount  = 0;
    thisPayload = cobcgi_payload;
    tokenStart  = strsep(&thisPayload, "&;");

    while (thisPayload || tokenStart) {
         valueStart = tokenStart;
         tokenStart = strsep(&valueStart, "="); 
         if (valueStart) cgi_addCgiVar(cgi_DecodeString(tokenStart), cgi_DecodeString(valueStart));
         else          {
                         /* lone text is treated as a positional token, i.e. $0, $1 and on. */
                         char *positionalVar;
                         asprintf(&positionalVar, "$%d", ++tokenCount);
                         cgi_addCgiVar(positionalVar, cgi_DecodeString(tokenStart));
                         free(positionalVar);
                       }
         tokenStart = thisPayload;
         if (tokenStart) tokenStart = strsep(&thisPayload, "&;");
    }
    if (payloadSource != 1) free(cobcgi_payload);
}

/*
 * add a name=value pair to a cgiTokenList; create one if necessary
 */
void cgi_addCgiVar(char *name, char *value)
{
    if (cgiTokenList == 0) {
        cgiTokenList = (struct tokenList *) malloc(sizeof(*cgiTokenList));
        cgiTokenList->tokenCount = 0;
        cgiTokenList->tokens     = 0;
        cgiTokenList->listSeq    = 1;     /* must be fifo */
    }

    cgi_addToken(cgiTokenList, name, value);
}

/*
 * get the value of a named variable from the cgiTokenList
 * @param string name
 * @param int seq; if the named token appears more than once, use seq to count down
 */
const char *cgi_getCgiValue (const char *name, int seqValue)
{
    int seq = seqValue;
    if (cgiTokenList == 0) {
        cgi_consumeCgiPayload();
        cgi_configure();
    }
    
    return cgi_getValue(cgiTokenList, name, seq);
}

/*-----------------------------------------CGI Output Processing ---------------------------*/

void cgi_HttpHeader ()
{
    switch (cgi_config.autoHeader) {
        case 0:
            return;
        case 1:
            if (cgi_template.contentType) printf ("Content-type: %s\r\n", cgi_template.contentType);
            else                          printf ("Content-type: text/html\r\n");
            break;
        case 2:
            printf ("Content-type: text/plain\r\n");
            break;
       default:
            break;
    }

    if (cgi_config.noCache) {
        printf ("Pragma: no-cache\r\n");
        printf ("Cache-Control: no-cache\r\n");
    }

    printf ("\r\n");
    cgi_config.autoHeader = 0;
}

void cgi_Redirect(const char *url)
{
    if (url && strlen(url)) {
        printf ("Content-type: text/html\r\nContent-length: %d\r\n", 77+((int)strlen(url)*2));
        printf ("Status: 302 Temporal Relocation\r\n");
        printf ("Location: %s\r\n\r\n", url);
        printf ("<html>\n<body>\nThe page has been moved to <a href=\"%s\">%s</a>\n</body>\n</html>\n", url, url);
    }
}

/*
 * add a name=value pair to a tplTokenList; create one if necessary
 */
void cgi_addTplVar(char *name, char *value)
{
    if (tplTokenList == 0) {
        tplTokenList = (struct tokenList *) malloc(sizeof(*tplTokenList));
        tplTokenList->tokenCount = 0;
        tplTokenList->tokens     = 0;
        tplTokenList->listSeq    = 2;         /* may be lifo */
    }

    cgi_addToken(tplTokenList, name, value);
}

/*
 * get the value of a named variable from the tplTokenList
 */
const char *cgi_getTplValue (const char *name)
{
    int seq = 0;

    return cgi_getValue(tplTokenList, name, seq);
}

/*
 * Outputs a template from a text file or redirects the browser.
 * @param  string template name: a valid filename or an url.
 *         when the name does not contain a extension, '.html' is added.
 * @return int = 0 
 */

int cgi_renderTpl(const char *tplName)
{
    char *line;
    char *text;
    char *filename;

    cgi_configure();

    if ((int)strnstr(tplName, "://", (size_t) 10) > 4 ) { cgi_Redirect(tplName); return 0; }

    cgi_HttpHeader();

    if (cgi_template.prefix) {
        filename = (char *) malloc(strlen(cgi_template.prefix) + strlen(tplName) + 6);    /* include trailing null (1) and .html (5) */
        strcpy(filename, cgi_template.prefix);
    } else {
        filename = (char *) malloc(strlen(tplName) + 6);                                      /* include trailing null (1) and .html (5) */
        *filename = '\0';
    }
    filename = strcat(filename, tplName);

    if (!strrchr(tplName, '.')) filename = strcat(filename, ".tpl");   /* add .tpl if missing extension */
    cgi_DebugOutput (1, "Template name: %s", filename);

    FILE *fp;
    if ((fp = fopen(filename, "r")) != 0 ) {
       while ((line = cgi_getLine(fp))) {
           text = cgi_Substitute(line);
           puts(text);
       }
       fclose(fp);
    }
    free(filename);
    return 0;
}

/*-----------------------------------------CGI Utilities -----------------------------------*/

/*
 * Adds a simple token to token list
 * @param tokenList: either for cgi (input) or for tpl (output)
 * @param string name
 * @param string value
 */
void cgi_addToken(struct tokenList *thisTokenList, char *name, char *value) {

    struct nameValueToken *token;
    int    nlen, vlen;

    /* get enough memory to store the nameValueToken struct and
     * the name string and the value string */
    nlen = strlen(name) + 1;
    vlen = strlen(value) + 1;
    token = (struct nameValueToken *) malloc(sizeof(*token) + nlen + vlen);
    token->name  = strcpy(token->token, name);
    token->value = strcpy(token->token + nlen, value);
    token->next  = 0;

    /* cgiToken are processed fifo; tplTokens does not matter */
    switch (thisTokenList->listSeq) {
        case 1:
            if (thisTokenList->last != 0) thisTokenList->last->next = token;
            else                          thisTokenList->tokens     = token; 
            thisTokenList->last = token;
            break;
        case 2:
            token->next = thisTokenList->tokens;
            thisTokenList->tokens = token;
            break;
        default:
            cgi_DebugOutput (5, "invalid listSeq %d", thisTokenList->listSeq);
            break;
    }

    thisTokenList->tokenCount++;
    cgi_DebugOutput (5, "add token '%s' with value '%s' to list # %d", name, value, thisTokenList->tokenCount);
}

/*
 * get the value of a named variable from a tokenList
 * @param tokenList: either for cgi (input) or for tpl (output)
 * @param string name
 * @param int seq: if the named token appears more than once, use seq to count down
 */
const char *cgi_getValue (struct tokenList *thisTokenList, const char *name, int seq)
{
    struct nameValueToken *token;

    if (!thisTokenList || !thisTokenList->tokens) return NULL;
    for (token = thisTokenList->tokens; token; token = token->next) {
        if (!strcmp(name, token->name)) {
            seq--;
            if (seq < 1) {
               cgi_DebugOutput (2, "'%s' found as '%s' (%d)", name, token->value, seq + 1);
               if (strlen(token->value) > 0) return token->value;
               else                          return NULL;
            }
        }
    }

    cgi_DebugOutput (2, "'%s' not found", name);
    return NULL;
}
/*
 * read the template file, line by line, kill trailing eol's, return null when eof
 */
char *cgi_getLine (FILE *stream)
{
    char  *lineTpl;

    cgi_template.inBuf[0] = '\0';

    if (!feof (stream))
    {
      if ((lineTpl = fgets (cgi_template.inBuf, _COBCGI_MAX_LINE_TPL + 1, stream)) == NULL) return NULL;

      if (lineTpl[strlen(lineTpl) - 1] == '\n') {
          lineTpl[strlen(lineTpl) - 1] = '\0';
          if (lineTpl[strlen(lineTpl) - 1] == '\r') {
              lineTpl[strlen(lineTpl) - 1] = '\0';
          }
      }
      return lineTpl;
    }
    return NULL;
}

/*
 *  +----------%%-----%%---------------\0
 *  |          |     |
 *  +i,j       +m    +n  
*/
char *cgi_Substitute(char *haystack)
{
register int    i,j,m,n,r = 0; 
         size_t size;
         char  *needle;
const    char  *tokenValue;
const    char  *replacement;

    cgi_template.outBuf[0] = '\0';

    i = j = m = r = 0;                        /* i,j iterates haystack, m,n set needle limits       */
    n = -1;                                   /* while n = -1 means: no (start of) needle found yet */

    while ( haystack[i] != '\0') {
        if ( haystack[j] == '%' && haystack[j + 1] == '%') {
            if (n == -1) {
                m = j; i = i + 2; j = j + 2; n = j;
            } else {                          /* now, set needle and substitute by replacement */
                n = j - 1;
                needle = strndup(haystack + m + 2, (size_t) (n - m - 1)); // : (n - (m + 2)) + 1;
                tokenValue = cgi_getTplValue(needle);
                free(needle);
                if (tokenValue == 0) {
                    if (cgi_template.unknowns == 0) {
                        size = 0;
                        replacement = haystack;
                    } else {
                        size = n + 3 - m;       // (n + 2) - m + 1
                        replacement = haystack + m;
                    }
                } else {
                    replacement = tokenValue;
                    size = strlen(replacement);
                }
                if (_COBCGI_MAX_LINE_OUT <  r + size) { size = _COBCGI_MAX_LINE_OUT - r; }
                strncpy(cgi_template.outBuf + r, replacement, size );
                r = r + size;
                i = j + 2; j = i; n = -1;
            }
        } else {
            if (n == -1) {
                cgi_template.outBuf[r] = haystack[i];           /* copy haystack to outBuf */
                r++;
            }
            i++; j = i;
        }
    } // end of while

    cgi_template.outBuf[r] = '\0';                              /* terminate outBuf with null */
    return cgi_template.outBuf;
}

char *cgi_DecodeString (char *text)
{
    char *cp, *xp;

    for (cp = text, xp = text; *cp; cp++) {
      if (*cp == '%') {
        if (strchr("0123456789ABCDEFabcdef", *(cp + 1)) && strchr("0123456789ABCDEFabcdef", *(cp + 2))) {
          if (islower(*(cp + 1))) *(cp + 1) = toupper(*(cp + 1));
          if (islower(*(cp + 2))) *(cp + 2) = toupper(*(cp + 2));
          *(xp) = (*(cp + 1) >= 'A' ? *(cp + 1) - 'A' + 10 : *(cp + 1) - '0' ) * 16
                + (*(cp + 2) >= 'A' ? *(cp + 2) - 'A' + 10 : *(cp + 2) - '0');
          if (*xp != '\r' || cgi_config.stripCr == 1) { xp++; }
          cp += 2;
        }
      } else  *(xp++) = *cp;
    } // end of for
    memset(xp, 0, cp - xp);
    return text;
}

void cgi_Debug (int level, int where)
{
    if (level > 0) cgi_DebugLevel = level;
    else           cgi_DebugLevel = 0;
    if   (where > 0) {
      if (where < 3) { cgi_DebugType = where;
                       if (where == 2) openlog("libcobcgi", LOG_PID, LOG_USER);
      } else cgi_DebugType = 0;
    }
}

void cgi_DebugOutput (int level, char *format, ...)
{
  va_list args;

  if (level <= cgi_DebugLevel) {

      va_start (args, format);

      switch (cgi_DebugType) {
        case 0:
          cgi_HttpHeader();
          printf ("<pre>");
          vprintf (format, args);
          printf ("</pre><br />\n");
          break;
       case 1:
          vfprintf (stdout, format, args);
          printf ("\n");
          break;
        case 2:
          vsyslog (LOG_DEBUG, format, args);
          break;
      }
      va_end (args);
  }
}
/*
 * get the CgiPayload from the terminal user, max 80 characters per line
 * when no request_method is found
 * also, debugging must be on (level > 0)
 */
char *cgi_DebugInput()
{
    if (cgi_DebugLevel == 0) return NULL;

    int len;
    int length = 0;
    char tmp[81];
    char *cp;
    char *text = NULL;
    printf ("(offline mode: enter name=value pairs on standard input)\n");
    memset (tmp, 0, sizeof(tmp));
    while((cp = fgets (tmp, 80, stdin)) != NULL) {
       if (strlen(tmp)) {
            if (tmp[strlen(tmp) - 1] == '\n') tmp[strlen(tmp) - 1] = '&';
            if (length) {
                length += (int)strlen(tmp);
                len = (length + 1) * sizeof(char);
                if (( text = (char *)realloc ( text, len)) == NULL) return text;
                strcat ( text, tmp);
            } else {
                length = (int)strlen(tmp);
                len = (length + 1) * sizeof(char);
                if (( text = (char *)malloc (len)) == NULL) return NULL;
                memset ( text, 0, len);
                strcpy ( text, tmp);
            }
        }
        memset (tmp, 0, sizeof(tmp));
    }
    return  text;
}
