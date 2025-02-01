/*
 * Copyright (C) 2006-2024 Sergey Kashyrin <ska@kiska.net>
 *               2012 enhanced by Doug Vogel <dv11674@gmail.com>
 *               2013 fixes and enhancements by Atilla Akarsular <030ati@gmail.com>
 *               2021 mf-compat by Simon Sobisch <simonsobisch@gnu.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA
 */
#ifdef _DEBUG_MEM
#include <crtdbg.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <errno.h>

#ifdef _MSC_VER
	#pragma warning(disable: 4996)
#endif

#include "config.h"

#ifdef HAVE_UNISTD_H
	#include <unistd.h>
#endif

#include "vcache.h"

static const char HEADER[] = "%s: ESQL for GnuCOBOL/OpenCOBOL Version 3 (2024.11.27) Build " __DATE__ "\n";
/**  Version is present in SQLCA. Current is 03 */

static bool bAPOST = true;		// use apostroph instead of quote
static char Q = '\'';
static const char * sQ = "'";
static bool bStatic = false;	// static call
static bool bSplit = false;
static const char * sSQ = "";
static bool bForceUnknown = false;	// force unknown statements to be EXECUTE IMMEDIATE
static string W_ERR("");	// WHENEVER SQLERROR
static string W_WARN("");	// WHENEVER SQLWARNING
static string W_NOTFOUND("");	// WHENEVER NOT FOUND

static char outfilepath[1024] = "";
static sarray copydir;
static string blanks("                                                                             ");
static const char * sqlca[] = {
	"       01 SQLCA.",
	"           05 SQLSTATE PIC X(5).",
	"              88  SQL-SUCCESS           VALUE '00000'.",
	"              88  SQL-RIGHT-TRUNC       VALUE '01004'.",
	"              88  SQL-NODATA            VALUE '02000'.",
	"              88  SQL-DUPLICATE         VALUE '23000' THRU '23999'.",
	"              88  SQL-MULTIPLE-ROWS     VALUE '21000'.",
	"              88  SQL-NULL-NO-IND       VALUE '22002'.",
	"              88  SQL-INVALID-CURSOR-STATE VALUE '24000'.", 
	"           05 FILLER   PIC X.",
	"           05 SQLVERSN PIC 99 VALUE 03.",
	"           05 SQLCODE  PIC S9(9) COMP-5 VALUE ZERO.",
	"           05 SQLERRM.",
	"               49 SQLERRML PIC S9(4) COMP-5 VALUE ZERO.",
	"               49 SQLERRMC PIC X(486).",
	"           05 SQLERRD OCCURS 6 TIMES PIC S9(9) COMP-5 VALUE ZERO.",
	"           05 FILLER   PIC X(4).",
	"           05 SQL-HCONN USAGE POINTER VALUE NULL."
};
static const char * workst[] = {
	"       77 OCSQL     PIC X(8) VALUE %cOCSQL%c.",
	"       77 OCSQLDIS  PIC X(8) VALUE %cOCSQLDIS%c.",
	"       77 OCSQLPRE  PIC X(8) VALUE %cOCSQLPRE%c.",
	"       77 OCSQLEXE  PIC X(8) VALUE %cOCSQLEXE%c.",
	"       77 OCSQLRBK  PIC X(8) VALUE %cOCSQLRBK%c.",
	"       77 OCSQLCMT  PIC X(8) VALUE %cOCSQLCMT%c.",
	"       77 OCSQLIMM  PIC X(8) VALUE %cOCSQLIMM%c.",
	"       77 OCSQLOCU  PIC X(8) VALUE %cOCSQLOCU%c.",
	"       77 OCSQLCCU  PIC X(8) VALUE %cOCSQLCCU%c.",
	"       77 OCSQLFTC  PIC X(8) VALUE %cOCSQLFTC%c.",
	"       77 OCSQLCAL  PIC X(8) VALUE %cOCSQLCAL%c."
};

static const char * exts[] = {
	"", ".CPY", ".CBL", ".COB", ".cpy", ".cbl", ".cob", NULL
};

class CobPgm
{
private:
	char * name;
	char * outname;
	FILE * fo;
	static char buf[2048];
	clarray src;
	sarray sqlcmd;
	varcache sym;
	bool bSection;
	int maxparmnum;
	string * vvar;
	varholder * upvar;
	varholder * upvar2;
	int varmode;
	bool sqlca_included;
	int tmpvarnum;
	int skiptolevel;
	string groupName;
	int inside_declare;

public:

	CobPgm(char * fname) : src(1000)
	{
		outname = NULL;
		fo = NULL;
		name = new char[strlen(fname)+5];
		strcpy(name, fname);

		FILE * fi = fopen(fname, "r");
		if(fi == NULL) {
			sprintf(buf, "Can't open input file. errno=%d.", errno);
			outfilepath[0] = 0;
			throw buf;
		}
		if(outfilepath[0] == 0) { //output in current dir with <filename>.cob
			outname = new char[strlen(fname)+5];
			strcpy(outname, fname);
			char * in = strrchr(outname, '/');
			char * in2 = strrchr(outname, '\\');
			if(in == NULL || (in2 != NULL && in2 > in)) {
				in = in2;
			}
			if(in != NULL) {
				strcpy(outname, in+1);
			}
			in = strrchr(outname, '.');
			if(in != NULL) *in = 0;
			strcat(outname, ".cob");
			fo = fopen(outname, "w+");
			if(fo == NULL) {
				sprintf(buf, "Can't open output file '%s'. errno=%d.", outname, errno);
				fclose(fi);
				throw buf;
			}
		} else {
			fo = fopen(outfilepath, "w+");
			if(fo == NULL) {
				sprintf(buf, "Can't open output file '%s'. errno=%d.", outfilepath, errno);
				fclose(fi);
				throw buf;
			}
			outname = new char[strlen(outfilepath)+1];
			strcpy(outname, outfilepath);
		}

		int lineno = 0;
		while(NULL != fgets(buf, sizeof buf, fi)) {
			++lineno;
			cobline & l = * new cobline(buf);
			l.lineno = lineno;
			l.line.rtrim();
			l.fname = name;
			src.add(&l);
			if(l.line.length() > 72) {
				l.line.trim(72);
				l.line.rtrim();
			}
			if(l.line.length() < 8 || l.line[6] == '*' || l.line[6] == '/') {
				l.bComment = true;
				continue;
			}
		}
		fclose(fi);

		bSection = true;
		maxparmnum = 2;
		vvar = NULL;
		upvar = NULL;
		upvar2 = NULL;
		varmode = 0;
		sqlca_included = false;
		tmpvarnum = 0;
		skiptolevel = 0;
		inside_declare = 0;
	}

	~CobPgm() {
		delete [] name;
		if(outname != NULL) delete [] outname;	// Well, I know "if" is not necessary :-)
	}

	const char * getName() { return name;}

	void process() {
		try {
			processprep();
			processvars();
			processexec();
			processgenvars();
			processvarstat();
			for(int i = 0; i < src.size(); ++i) {
				cobline * cl = src[i];
				fputs(cl->line, fo);
				fputc('\n', fo);
			}
			fclose(fo);
		} catch(...) {
			if(fo != NULL) fclose(fo);
			if(outname != NULL) {
				unlink(outname);	// try to remove file, ignore errors
			}
			throw;
		}
	}

private:
	void processprep()
	{
		bool WSdone = false;
		bool inProc = false;
		bool inside = false;
		string sql;
		int n = 0;
		while(n < src.size()) {
			cobline & cl = * src[n];
			if(cl.bComment) {
				++n;
				continue;
			}
			if(!inProc && ixFull(cl.line, "PROCEDURE") > 0 && ixFull(cl.line, "DIVISION") > 0) {
				inProc = true;
				++n;
				continue;
			}
			if(!WSdone && ixFull(cl.line, "WORKING-STORAGE") > 0 && ixFull(cl.line, "SECTION") > 0) {
				cl.bSQL = true;
				cl.sqlaction = 1;
				WSdone = true;
				++n;
				continue;
			}
			int isq;
			if(inside) {
				if((isq = ixFull(cl.line, "END-EXEC")) > 0) {
					inside = false;
					sql += cl.line.substr(6, isq - 6);
					isq += 8;
					comment(cl);
					if(isq < cl.line.length() && inProc) {
						cobline * l = new cobline(blanks.substr(0, isq) + cl.line.substr(isq));
						l->lineno = cl.lineno;
						src.insert(n + 1, l);
					}
					process2(cl, sql, n + 1);
				} else {
					int ix = cl.line.indexof("--", 6);
					if(ix > 0) {
						sql += cl.line.substr(6, ix - 6) + "/*" + cl.line.substr(ix + 2) + " */";
					} else {
						sql += cl.line.substr(6);
					}
					comment(cl);
				}
				++n;
				continue;
			}
			int ie = ixFull(cl.line, "EXEC");
			if(ie > 0 && (isq = ixFull(cl.line, "SQL")) > ie) {
				ie = ixFull(cl.line, "END-EXEC");
				if(ie < 0) {
					inside = true;
					sql = cl.line.substr(isq + 3);
					comment(cl);
				} else {
					sql = cl.line.substr(isq + 3, ie - isq - 3);
					comment(cl);
					ie += 8;
					if(ie < cl.line.length() && inProc) {
						cobline * l = new cobline(blanks.substr(0, ie) + cl.line.substr(ie));
						l->lineno = cl.lineno;
						src.insert(n + 1, l);
					}
					process2(cl, sql, n + 1);
				}
				++n;
				continue;
			}
			++n;
		}
	}

	void process2(cobline & cl, string & sql, int lineno)
	{
		sql.trim();
		sql.deblank();
		string sqlu(sql);
		sqlu.toupper();
		if(sqlu.starts("BEGIN DECLARE SECTION")) {
			if(inside_declare == 0) {
				cl.bSQL = true;
				cl.sqlaction = 2;	// start mark
			}
			++inside_declare;
			return;
		}
		if(sqlu.starts("END DECLARE SECTION")) {
			if(inside_declare > 0) {
				--inside_declare;
			}
			if(inside_declare == 0) {
				cl.bSQL = true;
				cl.sqlaction = 3;	// end mark
			}
			return;
		}
		if(sqlu == "INCLUDE SQLCA") {
			if(!sqlca_included) {
				for(int i = sizeof(sqlca)/sizeof(sqlca[0]) - 1; i >= 0; --i) {
					cobline * l2 = new cobline(sqlca[i]);
					l2->lineno = cl.lineno;
					src.insert(lineno, l2);
				}
				sqlca_included = true;
			}
			return;
		}
		if(sqlu.starts("INCLUDE ")) {
			sql = sql.substr(8);
			if(sql.starts("\"") || sql.starts("'")) {
				sql = sql.substr(1, sql.length() - 2);
			}
			if(sql == "SQLSTATE") {
				return;	// We are not including custom SQLSTATE - we have it in SQLCA
			}

			for(int i = 0; i < copydir.size(); ++i) {
				string dn(copydir[i]);
				dn += "/";
				dn += sql;
				for(int n = 0; exts[n] != NULL; ++n) {
					string * fn = new string(dn);	// will leave memory leak ... forget about GC
					*fn += exts[n];
					FILE * r = fopen(*fn, "r");
					if(r != NULL) {
						if(inside_declare == 0) {
							cobline * l = new cobline("      * implicit begin declare section");
							l->lineno = 0;
							l->fname = (char *)(const char *)*fn;
							src.insert(lineno, l);
							++lineno;
							l->bSQL = true;
							l->sqlaction = 2;	// start mark
						}
						int lno = 0;
						while(NULL != fgets(buf, sizeof buf, r)) {
							cobline * l = new cobline(buf);
							l->lineno = ++lno;
							l->line.rtrim();
							l->fname = (char *)(const char *)*fn;
							src.insert(lineno, l);
							++lineno;
							if(l->line.length() > 72) {
								l->line.trim(72);
								l->line.rtrim();
							}
							if(l->line.length() < 8 || l->line[6] == '*' || l->line[6] == '/') {
								l->bComment = true;
								continue;
							}
						}
						fclose(r);
						if(inside_declare == 0) {
							cobline * l = new cobline("      * implicit end declare section");
							l->lineno = ++lno;
							l->fname = (char *)(const char *)*fn;
							src.insert(lineno, l);
							++lineno;
							l->bSQL = true;
							l->sqlaction = 3;	// end mark
						}
						return;	// don't delete "fn" - there was a lot of references to this string
					}
					delete fn;
				}
			}
			sprintf(buf, "line %d of %s: SQL COPYBOOK NOT FOUND: %s", cl.lineno, cl.fname, (const char *)sql);
			throw buf;
		}
		if(sqlu.starts("VAR ")) {
			cl.sql = new string(sql);
			cl.bSQL = true;
			cl.sqlaction = 4;	// variable description
			return;
		}
		if(sqlu.starts("AT :")) {
			int ix = sql.indexof(' ', 4);
			if(ix > 0) {
				cl.conname = new string(sql.substr(4, ix - 4));
				sql = sql.substr(ix + 1);
				sqlu = sqlu.substr(ix + 1);
			}
		}
		if(sqlu.starts("SELECT ")) {
			cl.sqlnum = sqlcmd.add(sql);
			cl.sqlaction = 5;
		} else if(sqlu.starts("UPDATE ")) {
			cl.sqlnum = sqlcmd.add(sql);
			cl.sqlaction = 6;
		} else if(sqlu.starts("INSERT ")) {
			cl.sqlnum = sqlcmd.add(sql);
			cl.sqlaction = 7;
		} else if(sqlu.starts("DELETE ")) {
			cl.sqlnum = sqlcmd.add(sql);
			cl.sqlaction = 8;
		} else if(sqlu.starts("COMMIT")) {
			cl.sqlaction = 9;
		} else if(sqlu.starts("ROLLBACK")) {
			cl.sqlaction = 10;
		} else if(sqlu.starts("EXECUTE IMMEDIATE")) {
			cl.sqlaction = 11;
		} else if(sqlu.starts("DECLARE ")) {
			sqlu = sqlu.substr(8);
			sql = sql.substr(8);
			int x = sql.indexof(' ');
			if(x < 0) {
				sprintf(buf, "line %d of %s: Incorrect SQL DECLARE: %s", cl.lineno, cl.fname, (const char *)sql);
				throw buf;
			}
			string svar = sqlu.substr(0, x);
			sqlu = sqlu.substr(x + 1);
			sql = sql.substr(x + 1);
			if(sqlu.starts("CURSOR")) {
				bool bDyn = false;
				bool bWH = false;
				varholder* vd = NULL;
				x = sqlu.indexof("SELECT ");
				if(x < 0) {
					x = sqlu.indexof(" FOR ");
					if(x < 0) {
						sprintf(buf, "line %d of %s: Incorrect SQL DECLARE: %s", cl.lineno, cl.fname, (const char*)sql);
						throw buf;
					}
					string dvar = sqlu.substr(x + 5);
					if(dvar.indexof(" ") >= 0) {
						sprintf(buf, "line %d of %s: Incorrect SQL DECLARE: %s", cl.lineno, cl.fname, (const char*)sql);
						throw buf;
					}
					bDyn = true;
					vd = new varholder(dvar);
					vd->type = 'Y';
					sym.put(vd);
					++x;
				}
				int opt = sqlu.indexof(" WITH HOLD ");
				if(opt > 0 && opt < x) {
					bWH = true;
				}
				sql = sql.substr(x);
				sqlu = sqlu.substr(x);
				x = sqlu.indexof(" FOR UPDATE OF ");
				while(x > 0) {
					if(sqlu.indexof(' ', x + 15) >= 0) {
						x = sqlu.indexof(" FOR UPDATE OF ", x + 10);
						continue;
					}
					sql = sql.substr(0, x);
					sqlu = sqlu.substr(0, x);
					break;
				}
				sql = "*CUR*" + svar + ' ' + sql;
				cl.sqlnum = sqlcmd.add(sql);
				varholder * v = new varholder(svar);
				v->type = bDyn ? (bWH ? 'd' : 'D') : (bWH ? 'c' : 'C');
				v->size = cl.sqlnum;
				if(vd != NULL) {
					vd->size = cl.sqlnum;
					vd->over = v;
				}
				sym.put(v);
			} // else ignoring
			cl.sqlaction = 12;
		} else if(sqlu.starts("OPEN ")) {
			cl.sqlaction = 13;
		} else if(sqlu.starts("FETCH ")) {
			cl.sqlaction = 14;
		} else if(sqlu.starts("CLOSE ")) {
			cl.sqlaction = 15;
		} else if(sqlu.starts("CONNECT ")) {
			cl.sqlaction = 16;
		} else if(sqlu.starts("DISCONNECT ") || sqlu == "DISCONNECT") {
			cl.sqlaction = 16;
		} else if(sqlu.starts("WHENEVER ")) {
			cl.sqlaction = 17;
		} else if(sqlu.starts("INVOKE ")) {
			cl.sqlaction = 12;
		} else if(sqlu.starts("CALL ")) {
			cl.sqlnum = sqlcmd.add(sql);
			cl.sqlaction = 18;
		} else if(sqlu.starts("PREPARE ")) {
			cl.sqlaction = 19;
		} else if(bForceUnknown) {
			cl.sqlnum = sqlcmd.add(sql);
			cl.sqlaction = 20;
		} else {
			sprintf(buf, "line %d of %s: unsupported SQL: %s", cl.lineno, cl.fname, (const char *)sql);
			throw buf;
		}
		int ct = 0;
		for(int i = 0; i < sql.length(); ++i) {
			if(sql[i] == ':') ++ct;
		}
		if(ct > maxparmnum) maxparmnum = ct;
		cl.sql = new string(sql);
		cl.bSQL = true;
	}

	void processvars()
	{
		bool inside = false;
		int n = 0;
		while(n < src.size()) {
			cobline & cl = * src[n];
			++n;
			if(inside) {
				if(cl.bSQL) {
					cl.bSQL = false;
					if(cl.sqlaction == 3) {
						inside = false;
						continue;
					}
					if(cl.sqlaction != 12) {
						processvar(cl, n);
					}
				} else {
					if(cl.bComment) {
						continue;
					}
					processv(cl, n);
				}
				continue;
			}
			if(!cl.bSQL) {
				continue;
			}
			if(cl.sqlaction == 2) {
				cl.bSQL = false;
				inside = true;
				continue;
			}
		}
	}

	void processgenvars()
	{
		sarray gen;
		sarray gnames;
		for(varholder * v = sym.getFirstHolder(); v != NULL; v = sym.getNextHolder()) {
			if(v->type != 'O') continue;
			if(!v->inuse) continue;
			varholder * h = v->over;
			if(gnames.contains(h->name)) continue;
			gnames.add(h->name);
			if(h->type == '3') {
				int nd = h->size + h->size - 1 - h->precision;
				if(nd == 0) {
					sprintf(buf, "           05 %s  PIC SV9(%d) COMP-3.", (const char *) h->name, h->precision);
				} else {
					if(h->precision == 0) {
						sprintf(buf, "           05 %s  PIC S9(%d) COMP-3.", (const char *) h->name, nd);
					} else {
						sprintf(buf, "           05 %s  PIC S9(%d)V9(%d) COMP-3.", (const char *) h->name, nd, h->precision);
					}
				}
				gen.add(buf);
				continue;
			}
			if(h->type != 'I') throw "Internal Error: processgenvars()";
			int sz = 4;
			if(h->size == 4) sz = 9;
			else if(h->size == 8) sz = 15;
			sprintf(buf, "           05 %s  PIC S9(%d) COMP-5.", (const char *) h->name, sz);
			gen.add(buf);
		}
		if(gen.size() == 0) return;
		gen.sort();
		int n = 0;
		while(n < src.size()) {
			cobline & cl = * src[n];
			++n;
			if(!cl.bSQL) {
				continue;
			}
			if(cl.sqlaction == 1) {
				break;
			}
		}
		addln(n++, "      *******          PRECOMPILER-GENERATED VARIABLES               *******");
		addln(n++, "       01 SQLV-GEN-VARS.");
		for(int i = 0; i < gen.size(); ++i) {
			addln(n++, gen[i]);
		}
		addln(n++, "      *******       END OF PRECOMPILER-GENERATED VARIABLES           *******");
		addln(n++, "      **********************************************************************");
	}

	void processvarstat()
	{
		sarray a;
		for(varholder * v = sym.getFirstHolder(); v != NULL; v = sym.getNextHolder()) {
			if(v->name.starts("SQL-VAR-")) continue;
			strcpy(buf, "      *  ");
			strcat(buf, (const char *) v->name);
			strcat(buf, " ");
			while(strlen(buf) < 30) strcat(buf, " ");
			if(v->inuse) {
				strcat(buf, "    IN USE ");
				if(v->type == 'O') {
					strcat(buf, "THROUGH TEMP VAR ");
					v = v->over;
					strcat(buf, (const char *) v->name);
					strcat(buf, " ");
				}
				strcat(buf, getType(*v));
			} else {
				strcat(buf, "NOT IN USE");
			}
			a.add(buf);
		}
		if(a.size() == 0) return;

		cobline * l = new cobline("      **********************************************************************");
		src.add(l);
		sprintf(buf, HEADER, "      *  ");
		l = new cobline(buf);
		src.add(l);
		l = new cobline("      *******               EMBEDDED SQL VARIABLES USAGE             *******");
		src.add(l);
		a.sort();
		for(int i = 0; i < a.size(); ++i) {
			l = new cobline(a[i]);
			src.add(l);
		}
		l = new cobline("      **********************************************************************");
		src.add(l);
	}

	const char * getType(varholder & v) {
		static char bb[64];
		string s;
		int nd;
		switch(v.type) {
		case 'O':
			return "OVERRIDEN";
		case 'c':
			return "CURSOR WITH HOLD";
		case 'C':
			return "CURSOR";
		case 'd':
			return "DYNAMIC CURSOR WITH HOLD";
		case 'D':
			return "DYNAMIC CURSOR";
		case 'Y':
			return "DYNAMIC STATEMENT";
		case 'F':
			return "DOUBLE FLOAT";
		case 'i':
			return "INDICATOR";
		case '3':
			nd = v.size + v.size - 1;
			sprintf(bb, "DECIMAL(%d,%d)", nd, v.precision);
			return bb;
		case 'I':
			sprintf(bb, "INTEGER(%d BYTES)", v.size);
			return bb;
		case 'X':
			sprintf(bb, "CHAR(%d)", v.size);
			return bb;
		case 'B':
			sprintf(bb, "BINARY(%d)", v.size);
			return bb;
		case 'V':
			sprintf(bb, "VARCHAR(%d)", v.size);
			return bb;
		case 'v':
			sprintf(bb, "VARBINARY(%d)", v.size);
			return bb;
		case 'L':
			sprintf(bb, "LONGVARCHAR(%d)", v.size);
			return bb;
		case 'l':
			sprintf(bb, "LONGVARBINARY(%d)", v.size);
			return bb;
		}
		return "UNKNOWN";
	}

	void processexec()
	{
		int n = 0;
		while(n < src.size()) {
			cobline & cl = * src[n];
			++n;
			if(!cl.bSQL) {
				continue;
			}
			switch(cl.sqlaction) {
				case 1:
					cl.bSQL = false;
					processWORKINGSTORAGE(n);
					{
						cobline & cl2 = * src[n-1];
						cl2.bSQL = true;
						cl2.sqlaction = 1;
					}
					break;
				case 4:
					processvar(cl, n);
					break;
				case 5:
					processSEL(cl, n);
					break;
				case 6:
				case 7:
				case 8:
					processINSUPDEL(cl, n);
					break;
				case 9:
					processCOMMIT(cl, n);
					break;
				case 10:
					processROLLBACK(cl, n);
					break;
				case 11:
					processEXECUTEIMMED(cl, n);
					break;
				case 12:
					break;
				case 13:
					processOPENCURSOR(cl, n);
					break;
				case 14:
					processFETCH(cl, n);
					break;
				case 15:
					processCLOSECURSOR(cl, n);
					break;
				case 16:
					processCONNECT(cl, n);
					break;
				case 17:
					processWHENEVER(cl, n);
					break;
				case 18:
					processCALL(cl, n);
					break;
				case 19:
					processPREPARE(cl, n);
					break;
				case 20:
					processUNKNOWN(cl, n);
					break;
				default:
					throw "Internal Error: processexec";
			}
		}
	}

	int indexEndVar(string & sql, int ix) const {
		static const char * delim = " ,)'\"<>!=;\t";
		for(int ie = ix + 1; ie < sql.length(); ++ie) {
			char c = sql[ie];
			for(const char * p = delim; *p != 0; ++p) {
				if(c == *p) {
					return ie;
				}
			}
		}
		return sql.length();
	}

	void processWORKINGSTORAGE(int & lineno)
	{
		addln(lineno++, "      **********************************************************************");
		addln(lineno++, "      *******                EMBEDDED SQL VARIABLES                  *******");
		if(!sqlca_included) {
			for(int i = 0; i < sizeof(sqlca)/sizeof(sqlca[0]); ++i) {
				addln(lineno++, sqlca[i]);
			}
		}
		if(!bStatic) {
			for(int i = 0; i < sizeof(workst)/sizeof(workst[0]); ++i) {
				sprintf(buf, workst[i], Q, Q);
				addln(lineno++, buf);
			}
		}
		addln(lineno++, "       01 SQLV.");
		sprintf(buf, "           05 SQL-ARRSZ  PIC S9(9) COMP-5 VALUE %d.", maxparmnum);
		addln(lineno++, buf);
		addln(lineno++, "           05 SQL-COUNT  PIC S9(9) COMP-5 VALUE ZERO.");
		sprintf(buf, "           05 SQL-ADDR   POINTER OCCURS %d TIMES VALUE NULL.", maxparmnum);
		addln(lineno++, buf);
		sprintf(buf, "           05 SQL-LEN    PIC S9(9) COMP-5 OCCURS %d TIMES VALUE ZERO.", maxparmnum);
		addln(lineno++, buf);
		sprintf(buf, "           05 SQL-TYPE   PIC X OCCURS %d TIMES.", maxparmnum);
		addln(lineno++, buf);
		sprintf(buf, "           05 SQL-PREC   PIC X OCCURS %d TIMES.", maxparmnum);
		addln(lineno++, buf);
		addln(lineno++, "      **********************************************************************");
		for(int i = 0; i < sqlcmd.size(); ++i) {
			string sql = (string)sqlcmd[i];
			string cname;
			if(sql.starts("*CUR*")) {
				int x = sql.indexof(' ');
				cname = sql.substr(5, x - 5);
				sql = sql.substr(x + 1);
			}
			string sqlu(sql);
			sqlu.toupper();
			if(sqlu.starts("FOR ")) {
				sprintf(buf, "       01 SQL-STMT-%d.", i);
				addln(lineno++, buf);
				addln(lineno++, "           05 SQL-IPTR   POINTER VALUE NULL.");
				sprintf(buf, "           05 SQL-PREP   PIC X VALUE %cN%c.", Q, Q);
				addln(lineno++, buf);
				sprintf(buf, "           05 SQL-OPT    PIC X VALUE %cC%c.", Q, Q);
				addln(lineno++, buf);
				addln(lineno++, "           05 SQL-PARMS  PIC S9(4) COMP-5 VALUE 0.");
				addln(lineno++, "           05 SQL-STMLEN PIC S9(4) COMP-5 VALUE 0.");
				addln(lineno++, "           05 FILLER     PIC X.");
				addln(lineno++, "           05 SQL-VTYPE  PIC X VALUE SPACE.");
				addln(lineno++, "           05 SQL-VADDR  POINTER VALUE NULL.");
				sprintf(buf, "           05 SQL-CNAME  PIC X(%d) VALUE %c%s%c.", cname.length(), Q, (const char *) cname, Q);
				cname = buf;
				processfmt(lineno, cname);
				addln(lineno++, "           05 FILLER     PIC X VALUE LOW-VALUE.");
				addln(lineno++, "      **********************************************************************");
				continue;
			}
			if(sqlu.starts("SELECT ")) {
				int ix = sqlu.indexof(" INTO ");
				if(ix > 0) {
					int iy = sqlu.indexof(" FROM ");
					if(iy < ix) {
						iy = sqlu.indexof(" WHERE ");
					}
					if(iy < ix) iy = sql.length();
					string sqlf(sql.substr(ix+6, iy - ix - 6));
					sql = sql.substr(0, ix) + sql.substr(iy);
					sqlf += " *";
					sqlf += sql;
					strcpy(sqlcmd[i], (const char *) sqlf);
				}
			}
			// suppress values in constants to avoid ':'
			sqlu = sql;
			sqlu.toupper();
			bool bQ = false;
			for(int k = 0; k < sqlu.length(); ++k) {
				if(sqlu[k] == '\'') {
					bQ = !bQ;
					continue;
				}
				if(bQ) {
					sqlu[k] = ' ';
				}
			}
			// Replace variables by '?'
			int parmnum = 0;
			for(int ix = sqlu.indexof(':'); ix >= 0; ix = sqlu.indexof(':')) {
				int ib = indexEndVar(sqlu, ix);
				string varn = sqlu.substr(ix+1, ib - ix - 1);
				sql = sql.substr(0, ix) + '?' + sql.substr(ib);
				sqlu = sqlu.substr(0, ix) + '?' + sqlu.substr(ib);
				++parmnum;
				if(varn.indexof(':') > 0) ++parmnum;
			}
			if(sqlu.starts("CALL ")) {
				if(sqlu[5] == '?') {
					int ix = sqlu.indexof('=');
					if(ix > 0) {
						sqlu = '{' + sqlu.substr(5, ix - 4) + " CALL " + sqlu.substr(ix + 1) + '}';
						sql = '{' + sql.substr(5, ix - 4) + " CALL " + sql.substr(ix + 1) + '}';
					}
				} else {
					sqlu = '{' + sqlu + '}';
					sql = '{' + sql + '}';
				}
				for(int ix = sqlu.indexof('?'); ix >= 0; ix = sqlu.indexof('?', ix + 1)) {
					string s = sqlu.substr(ix + 1);
					if(s.starts(" OUTPUT")) {
						sqlu = sqlu.substr(0, ix + 1) + sqlu.substr(ix + 8);
						sql = sql.substr(0, ix + 1) + sql.substr(ix + 8);
					} else if(s.starts(" OUT")) {
						sqlu = sqlu.substr(0, ix + 1) + sqlu.substr(ix + 5);
						sql = sql.substr(0, ix + 1) + sql.substr(ix + 5);
					} else if(s.starts(" INOUT")) {
						sqlu = sqlu.substr(0, ix + 1) + sqlu.substr(ix + 7);
						sql = sql.substr(0, ix + 1) + sql.substr(ix + 7);
					} else if(s.starts(" IN")) {
						sqlu = sqlu.substr(0, ix + 1) + sqlu.substr(ix + 4);
						sql = sql.substr(0, ix + 1) + sql.substr(ix + 4);
					}
				}
			}
			sprintf(buf, "       01 SQL-STMT-%d.", i);
			addln(lineno++, buf);
			addln(lineno++, "           05 SQL-IPTR   POINTER VALUE NULL.");
			sprintf(buf, "           05 SQL-PREP   PIC X VALUE %cN%c.", Q, Q);
			addln(lineno++, buf);
			if(cname.length() != 0) {
				sprintf(buf, "           05 SQL-OPT    PIC X VALUE %cC%c.", Q, Q);
				addln(lineno++, buf);
			} else {
				addln(lineno++, "           05 SQL-OPT    PIC X VALUE SPACE.");
			}
			sprintf(buf, "           05 SQL-PARMS  PIC S9(4) COMP-5 VALUE %d.", parmnum);
			addln(lineno++, buf);
			sprintf(buf, "           05 SQL-STMLEN PIC S9(4) COMP-5 VALUE %d.", sql.length());
			addln(lineno++, buf);
			if(bSplit && sql.length() > 160) {
				string fl("           05 SQL-STMT   PIC X(");
				bool bProcess = true;
				while(bProcess) {
					string sql1;
					if(sql.length() > 160) {
						sql1 = sql.substr(0, 160);
						sql = sql.substr(160);
					} else {
						sql1 = sql;
						bProcess = false;
					}
					fl += sql1.length();
					fl += ") VALUE ";
					fl += Q;
					for(int k = 0; k < sql1.length(); ++k) {
						if(sql1[k] == Q) {
							sql1 = sql1.substr(0, k) + Q + sql1.substr(k);
							++k;
						}
					}
					fl += sql1;
					fl += Q;
					fl += '.';
					processfmt(lineno, fl);
					fl = "           05 FILLER     PIC X(";
				}
			} else {
				string fl("           05 SQL-STMT   PIC X(");
				fl += sql.length();
				fl += ") VALUE ";
				fl += Q;
				for(int k = 0; k < sql.length(); ++k) {
					if(sql[k] == Q) {
						sql = sql.substr(0, k) + Q + sql.substr(k);
						++k;
					}
				}
				fl += sql;
				fl += Q;
				fl += '.';
				processfmt(lineno, fl);
			}
			if(cname.length() != 0) {
				sprintf(buf, "           05 SQL-CNAME  PIC X(%d) VALUE %c%s%c.", cname.length(), Q, (const char*)cname, Q);
				cname = buf;
				processfmt(lineno, cname);
				addln(lineno++, "           05 FILLER     PIC X VALUE LOW-VALUE.");
			}
			addln(lineno++, "      **********************************************************************");
		}
	}

	// format back into fixed cobol positions (1-6,7,8-72)
	void processfmt(int & lineno, string & line)
	{
		bool bQQ = false;
		for(; ; ) {
			int x = line.length();
			if(x <= 72) {
				addln(lineno++, line);
				return;
			}
			// check for unpaired quote
			int spos = 7;
			bool bQ = bQQ;
			bQQ = false;
			while((spos = line.indexof(Q, spos)) >= 0) {
				if(spos >= 72) {
					break;
				}
				++spos;
				bQ = !bQ;
			}
			string s = line.substr(72);
			line = line.substr(0, 72);
			if(!bQ) {
				if(s[0] == Q && line[71] == Q) {
					s = Q + s;
					bQQ = true;
				} else if(s[0] == ' ' || line[71] == ' ') {
					s = Q + (' ' + s);
				}
			} else {
				s = Q + s;
			}
			addln(lineno++, line);
			if(s == ".") {
				line = "           ";
				line += s;
			} else {
				line = "      -    ";
				line += s;
			}
		}
	}

	void addln(int nl, const char * v)
	{
		cobline * l = new cobline(v);
		src.insert(nl, l);
	}

	int countX()
	{
		int ctX = 0;
		for(int x = 0; x < vvar->length(); ++x) {
			if((*vvar)[x] == 'X') {
				++ctX;
				continue;
			}
			if((*vvar)[x] == '(' && ctX > 0) {
				int iv = vvar->indexof(')', x);
				if(iv < 0) {
					return -1;
				}
				int rct = atoi(vvar->substr(x + 1, iv - x - 1));
				ctX += rct - 1;
				x = iv;
				continue;
			}
			if((*vvar)[x] == ' ' || (*vvar)[x] == '.') {
				break;
			}
			return -1;
		}
		return ctX;
	}

	bool countprec(const char * pic, int & p1, int & p2)
	{
		int ct9 = 0;
		int ctb9 = -1;
		bool wasdot = false;
		for(const char * p = pic; *p != 0 && *p != ' '; ++p) {
			if(*p == 'S' || *p == '+' || *p == '-' || *p == ',') {
				continue;
			}
			if(*p == '9' || *p == 'Z') {
				++ct9;
				continue;
			}
			if(*p == 'V' || *p == '.') {
				if(wasdot) break;
				wasdot = true;
				ctb9 = ct9;
				ct9 = 0;
				continue;
			}
			if(*p == '(' && ct9 > 0) {
				const char * q = strchr(p, ')');
				if(q == NULL || (q - p) > 5 || (q - p) < 2) {
					return false;
				}
				char cn[6];
				memcpy(cn, p+1, q-p-1);
				cn[q-p-1] = 0;
				int rct = atoi(cn);
				ct9 += rct - 1;
				p = q;
				continue;
			}
			return false;
		}
		if(ctb9 < 0) {
			if(ct9 == 0) return false;
			ctb9 = ct9;
			ct9 = 0;
		}
		p1 = ctb9;
		p2 = ct9;
		return true;
	}

	void processv(cobline & cl, int & lineno)
	{
		if(vvar != NULL) {
			(*vvar) += cl.line.substr(6);
		} else {
			vvar = & cl.line.substr(7);
		}
		if(vvar->length() == 0 || (*vvar)[vvar->length()-1] != '.') {
			return;
		}
		vvar->trim();
		vvar->deblank();
		vvar->toupper();
		string varline("       ");
		varline += *vvar;
		int isp = vvar->indexof(' ');
		if(isp < 0) {
			fprintf(stderr, "WARNING: line %d of %s: unknown construction in DECLARE SECTION: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
			string ss("      * UNKNOWN ");
			ss += *vvar;
			addln(lineno++, ss);
			return;
		}
		int level = atoi(vvar->substr(0, isp));
		if(level == 88) { // ignore
			vvar = NULL;
			return;
		}
		if(skiptolevel != 0) {
			if(level > skiptolevel) {
				vvar = NULL;
				return;
			}
			skiptolevel = 0;
		}
		/*  determine what level we are at. If the level is 01 then this could be a structure and the 
		 *  name might be used for qulaification. 
		 *  if at level 49 the we will ignore these fields for adding to the table a second time
		 *  all other levels get added a second time to the tbale later
		 */
		int isGroup = 0;
		if (level == 1) {
			isGroup = 1;
		} else if (level == 49) {
			isGroup = 2;
		}
		int iv = vvar->indexof(' ', isp + 1);
		if(iv < 0) {
			iv = vvar->indexof('.', isp + 1);
		} else {
			if(isGroup == 1) {
				isGroup = 2;
			}
		}
		string svar = vvar->substr(isp + 1, iv - isp - 1);
		//  if this is level 1 then save variable name to be used for qualification
		if(isGroup == 1) {
			groupName = svar;
		}
		*vvar = vvar->substr(iv);
		vvar->trim();
		if(vvar->indexof("OCCURS") >= 0) {
			// We don't support arrays so far :-(
			addln(lineno++, "      * Arrays are not supported");
			vvar = NULL;
			upvar = NULL;
			skiptolevel = level;
			return;
		}
		if(vvar->starts("REDEFINES ")) {
			*vvar = vvar->substr(10);
			int x = vvar->indexof(' ');
			if(x < 0) {
				x = vvar->length() - 1;
			}
			*vvar = vvar->substr(x);
			vvar->trim();
		}
		varholder * v = new varholder(svar);
		// when we do a sym.put(v) we will need to create a second entry with groupName.svar as the name 
		// all other attibutes will be the same 
		if(*vvar == ".") {
			v->type = 'S';
			v->size = 0;
			upvar = v;
			varmode = 0;
			sym.put(v);
			if(isGroup == 0) {
				v = new varholder(groupName + "." + svar);
				v->type = 'S';
				v->size = 0;
				upvar2 = v;
				sym.put(v);
			}
			vvar = NULL;
			return;
		}
		int fpsz = 8;
		iv = vvar->indexof("COMP-2");
		if(iv < 0) {
			iv = vvar->indexof("COMPUTATIONAL-2");
		}
		if(iv < 0) {
			fpsz = 4;
			iv = vvar->indexof("COMP-1");
		}
		if(iv < 0) {
			iv = vvar->indexof("COMPUTATIONAL-1");
		}
		if(iv >= 0) {
			v->type = 'F';
			v->size = fpsz;
			sym.put(v);
			if(isGroup == 0) {
				v = new varholder(groupName + "." + svar);
				v->type = 'F';
				v->size = 8;
				sym.put(v);
			}
			vvar = NULL;
			upvar = NULL;
			return;
		}
		int ivl = 4;
		iv = vvar->indexof("PIC ");
		if(iv < 0) {
			ivl = 8;
			iv = vvar->indexof("PICTURE ");
		}
		if(iv < 0) {
			fprintf(stderr, "WARNING: line %d of %s: unknown construction in DECLARE SECTION: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
			sprintf(buf, "      * Incorrect/Unsupported %s", (const char *)svar);
			addln(lineno++, buf);
			vvar = NULL;
			upvar = NULL;
			delete v;
			return;
		}
		*vvar = vvar->substr(iv + ivl);

		iv = vvar->indexof("COMP-3");
		if(iv < 0) {
			iv = vvar->indexof("COMPUTATIONAL-3");
		}
		if(iv >= 0) {
			upvar = NULL;
			int ctd, ctv;
			bool unhandled = ((*vvar)[0] != 'S');
			bool valid = countprec((const char *) *vvar, ctd, ctv);
			if(!valid) {
				fprintf(stderr, "WARNING: line %d of %s: unsupported type: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
				sprintf(buf, "      * Incorrect/Unsupported %s", (const char *)svar);
				addln(lineno++, buf);
				vvar = NULL;
				delete v;
				return;
			}
			if(((ctd + ctv) & 1) == 0) {
				unhandled = true;
			}
			if(unhandled) {
				sprintf(buf, "SQL-VAR-%04d", ++tmpvarnum);
				varholder * h = new varholder(buf);
				v->type = 'O';
				v->over = h;
				sym.put(v);
				if(isGroup == 0) {
					varholder * v = new varholder(groupName + "." + svar);
					v->type = 'O';
					v->over = h;
					sym.put(v);
				}
				v = h;
			} else if(isGroup == 0) {
				varholder * v = new varholder(groupName + "." + svar);
				v->type = '3';
				v->precision = ctv;
				v->size = (ctd+ctv+2)/2;
				sym.put(v);
			}
			v->type = '3';
			v->precision = ctv;
			v->size = (ctd+ctv+2)/2;
			sym.put(v);
			vvar = NULL;
			return;
		}

		iv = vvar->indexof("COMP-X");
		if(iv < 0) {
			iv = vvar->indexof("COMPUTATIONAL-X");
		}
		if(iv >= 0) {
			int ctX = countX();
			if(ctX < 0) {
				fprintf(stderr, "WARNING: line %d of %s: unsupported type in DECLARE SECTION: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
				sprintf(buf, "      * Incorrect/Unsupported %s", (const char *)svar);
				addln(lineno++, buf);
				upvar = NULL;
				vvar = NULL;
				delete v;
				return;
			}
			upvar = NULL;
			sprintf(buf, "SQL-VAR-%04d", ++tmpvarnum);
			varholder * h = new varholder(buf);
			v->type = 'O';
			v->over = h;
			sym.put(v);
			if(isGroup == 0) {
				varholder * v = new varholder(groupName + "." + svar);
				v->type = 'O';
				v->over = h;
				sym.put(v);
			}
			v = h;
			v->type = 'I';
			if(ctX < 3) {
				v->size = 2;
			} else if(ctX < 5) {
				v->size = 4;
			} else {
				v->size = 8;
			}
			sym.put(v);
			vvar = NULL;
			return;
			/*
			fprintf(stderr, "WARNING: line %d of %s: COMP-X is unsupported: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
			sprintf(buf, "      * Incorrect/Unsupported %s", (const char *)svar);
			addln(lineno++, buf);
			vvar = NULL;
			delete v;
			return;
			*/
		}

		iv = vvar->indexof("COMP");
		if(iv < 0) {
			iv = vvar->indexof("BINARY");
		}
		if(iv >= 0) {
			bool unhandled = false;
#if !defined(WORDS_BIGENDIAN) || defined(LITTLE_ENDIAN)
			if(vvar->indexof("COMP-5") < 0) {
				if(level == 49) {
					int ix = cl.line.indexof(" COMP");
					if(ix >= 0) {
						string sc = cl.line.substr(ix);
						cl.line = cl.line.substr(0, ix);
						sc.trim();
						ix = sc.indexof("COMPUTATIONAL-4");
						if(ix >= 0) {
							sc = "           COMP-5" + sc.substr(ix+15);
							addln(lineno++, sc);
						} else {
							ix = sc.indexof("COMP-4");
							if(ix >= 0) {
								sc = "           COMP-5" + sc.substr(ix+6);
								addln(lineno++, sc);
							} else {
								ix = sc.indexof("COMPUTATIONAL");
								if(ix >= 0) {
									sc = "           COMP-5" + sc.substr(ix+13);
									addln(lineno++, sc);
								} else {
									ix = sc.indexof("COMP");
									if(ix >= 0) {
										sc = "           COMP-5" + sc.substr(ix+4);
										addln(lineno++, sc);
									} else {
										unhandled = true;
										sc = "           " + sc;
										addln(lineno++, sc);
										fprintf(stderr, "WARNING: line %d of %s: unsupported %s at level 49\n", cl.lineno, cl.fname, (const char *)svar);
										sprintf(buf, "      * Incorrect/Unsupported %s at level 49", (const char *)svar);
										addln(lineno++, buf);
									}
								}
							}
						}
					} else {
						unhandled = true;
						fprintf(stderr, "WARNING: line %d of %s: unsupported %s at level 49\n", cl.lineno, cl.fname, (const char *)svar);
						sprintf(buf, "      * Incorrect/Unsupported %s at level 49", (const char *)svar);
						addln(lineno++, buf);
					}
				} else {
					unhandled = true;
				}
			}
#endif
			int ctd, ctv;
			bool valid = countprec((const char *) *vvar, ctd, ctv);
			if(!valid) {
				fprintf(stderr, "WARNING: line %d of %s: unsupported type: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
				sprintf(buf, "      * Incorrect/Unsupported %s", (const char *)svar);
				addln(lineno++, buf);
				delete v;
				vvar = NULL;
				upvar = NULL;
				return;
			}
			if(ctv > 0) {
				unhandled = true;
			}
			if(unhandled) {
				upvar = NULL;
				sprintf(buf, "SQL-VAR-%04d", ++tmpvarnum);
				varholder * h = new varholder(buf);
				v->type = 'O';
				v->over = h;
				sym.put(v);
				if(isGroup == 0) {
					varholder * v = new varholder(groupName + "." + svar);
					v->type = 'O';
					v->over = h;
					sym.put(v);
				}
				v = h;
				if(ctv > 0) {
					v->type = '3';
					v->precision = ctv;
					v->size = (ctd+ctv+2)/2;
					sym.put(v);
					vvar = NULL;
					return;
				}
			} else {
				if(isGroup == 0) {
					varholder * v = new varholder(groupName + "." + svar);
					v->type = 'I';
					if(ctd < 5) {
						v->size = 2;
					} else if(ctd < 10) {
						v->size = 4;
					} else {
						v->size = 8;
					}
					sym.put(v);
				}
			}
			v->type = 'I';
			if(ctd < 5) {
				v->size = 2;
			} else if(ctd < 10) {
				v->size = 4;
			} else {
				v->size = 8;
			}
			sym.put(v);
			vvar = NULL;
			if(upvar != NULL) {
				if(varmode != 0 || v->size == 8) {
					upvar = NULL;
					varmode = 0;
				} else {
					varmode = v->size;
				}
			}
			return;
		}

		if((*vvar)[0] != 'X') {
			upvar = NULL;
			int ctd, ctv;
			bool valid = countprec((const char *) *vvar, ctd, ctv);
			if(!valid) {
				fprintf(stderr, "WARNING: line %d of %s: unsupported type: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
				sprintf(buf, "      * Incorrect/Unsupported %s", (const char *)svar);
				addln(lineno++, buf);
				vvar = NULL;
				delete v;
				return;
			}
			sprintf(buf, "SQL-VAR-%04d", ++tmpvarnum);
			varholder * h = new varholder(buf);
			v->type = 'O';
			v->over = h;
			sym.put(v);
			if(isGroup == 0) {
				varholder * v = new varholder(groupName + "." + svar);
				v->type = 'O';
				v->over = h;
				sym.put(v);
			}
			v = h;
			v->type = '3';
			v->precision = ctv;
			v->size = (ctd+ctv+2)/2;
			sym.put(v);
			vvar = NULL;
			return;
		}

		int ctX = countX();
		if(ctX < 0) {
			fprintf(stderr, "WARNING: line %d of %s: unsupported type in DECLARE SECTION: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
			sprintf(buf, "      * Incorrect/Unsupported %s", (const char *)svar);
			addln(lineno++, buf);
			upvar = NULL;
			vvar = NULL;
			delete v;
			return;
		}
		/*
		for(int x = 0; x < vvar->length(); ++x) {
			if((*vvar)[x] == 'X') {
				++ctX;
				continue;
			}
			if((*vvar)[x] == '(' && ctX > 0) {
				iv = vvar->indexof(')');
				if(iv < 0) {
					fprintf(stderr, "WARNING: line %d of %s: incorrect PIC: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
					sprintf(buf, "      * Incorrect/Unsupported %s", (const char *)svar);
					addln(lineno++, buf);
					upvar = NULL;
					vvar = NULL;
					delete v;
					return;
				}
				int rct = atoi(vvar->substr(x + 1, iv - x - 1));
				ctX += rct - 1;
				x = iv;
				continue;
			}
			if((*vvar)[x] == ' ' || (*vvar)[x] == '.') {
				break;
			}
			fprintf(stderr, "WARNING: line %d of %s: unsupported type in DECLARE SECTION: %s\n", cl.lineno, cl.fname, (const char *)*vvar);
			sprintf(buf, "      * Incorrect/Unsupported %s", (const char *)svar);
			addln(lineno++, buf);
			upvar = NULL;
			vvar = NULL;
			delete v;
			return;
		}
		*/
		v->type = 'X';
		v->size = ctX;
		sym.put(v);
		if(isGroup == 0) {
			varholder * v = new varholder(groupName + "." + svar);
			v->type = 'X';
			v->size = ctX;
			sym.put(v);
		}
		if(varmode != 0 && upvar != NULL) {
			if(varmode == 2) {
				upvar->type = 'V';
				if(upvar2) upvar2->type = 'V';
			} else {
				upvar->type = 'L';
				if(upvar2) upvar2->type = 'L';
			}
			upvar->size = v->size;
			if(upvar2) upvar2->size = v->size;
			sprintf(buf, "      * %s is accepted as VARCHAR(%d)", (const char *)upvar->name, v->size);
			addln(lineno++, buf);
			varmode = 0;
		}
		upvar = NULL;
		vvar = NULL;
	}

	void processvar(cobline & cl, int & lineno)
	{
		string var = cl.sql->substr(4);
		var.toupper();
		int iv = var.indexof(' ');
		if(iv < 0) {
			sprintf(buf, "line %d of %s: unknown VAR construction in DECLARE SECTION: %s", cl.lineno, cl.fname, (const char *)var);
			throw buf;
		}
		string svar = var.substr(0, iv);
		var = var.substr(iv + 1);
		if(var.starts("IS ")) var = var.substr(3);
		if(!var.starts("RAW") && !var.starts("BINARY") && !var.starts("LONG") &&
			!var.starts("VARRAW") && !var.starts("VARBINARY"))
		{
			sprintf(buf, "line %d of %s: unsupported VAR construction in DECLARE SECTION: %s", cl.lineno, cl.fname, (const char *)var);
			throw buf;
		}
		varholder * v = sym[svar];
		if(v == NULL) {
			sprintf(buf, "line %d of %s: VAR variable not found: %s", cl.lineno, cl.fname, (const char *)svar);
			throw buf;
		}
		if(v->type != 'S' && var.starts("LONG") && !var.starts("LONG RAW") && !var.starts("LONG VARRAW") && !var.starts("LONG BINARY") && !var.starts("LONG VARBINARY")) {
			sprintf(buf, "      * %s accepted as LONG CHAR/VARCHAR(%d)", (const char *)v->name, v->size);
			addln(lineno++, buf);
		} else if(v->type == 'X') {
			v->type = 'B';
			sprintf(buf, "      * %s is accepted as BINARY(%d)", (const char *)v->name, v->size);
			addln(lineno++, buf);
		} else if(v->type == 'V') {
			v->type = 'v';
			sprintf(buf, "      * %s is accepted as VARBINARY(%d)", (const char *)v->name, v->size);
			addln(lineno++, buf);
		} else if(v->type == 'L') {
			v->type = 'l';
			sprintf(buf, "      * %s is accepted as LONG VARBINARY(%d)", (const char *)v->name, v->size);
			addln(lineno++, buf);
		} else {
			sprintf(buf, "line %d of %s: VAR incompatible variable type: %s", cl.lineno, cl.fname, (const char *)svar);
			throw buf;
		}
	}

	void removeInQ(string & sql, const char * p) {
		sql = "";
		bool bQ = false;
		while(*p != 0) {
			if(*p == '\'') {
				bQ = !bQ;
				sql += *p++;
				continue;
			}
			if(!bQ) {
				sql += *p;
			}
			++p;
		}
		sql.toupper();
	}

	void processINSUPDEL(cobline & cl, int & lineno)
	{
		string sql;
		removeInQ(sql, (const char *)(*cl.sql));
		sarray moves;
		int parmnum = 0;
		int iv = 0;
		const char * shift = "              ";

		// Check for indicator variables
		bool bWasInd = false;
		string sqltest(sql);
		for(int ix = sqltest.indexof(':'); ix >= 0; ix = sqltest.indexof(':')) {
			int ib = indexEndVar(sqltest, ix);
			string svar = sqltest.substr(ix + 1, ib - ix - 1);
			ix = svar.indexof(':');
			if(ix > 0) {
				bWasInd = true;
				shift = "          ";
				break;
			}
			sqltest = sqltest.substr(ib);
		}

		if(cl.conname != NULL) {
			varholder * vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}

		if(bWasInd) {
			sprintf(buf, "           MOVE %cA%c TO SQL-PREP OF SQL-STMT-%d", Q, Q, cl.sqlnum);
			addln(lineno++, buf);
		} else {
			sprintf(buf, "           IF SQL-PREP OF SQL-STMT-%d = %cN%c", cl.sqlnum, Q, Q);
			addln(lineno++, buf);
		}

		for(int ix = sql.indexof(':'); ix >= 0; ix = sql.indexof(':')) {
			int ib = indexEndVar(sql, ix);
			string svar = sql.substr(ix + 1, ib - ix - 1);
			svar.toupper();
			varholder * vi = NULL;
			ix = svar.indexof(':');
			if(ix > 0) {
				string ivar = svar.substr(ix+1);
				svar = svar.substr(0, ix);
				vi = sym[ivar];
				if(vi == NULL) {
					sprintf(buf, "line %d of %s: indicator variable not found: %s", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				if(vi->type == 'O' && vi->over->type == 'I' && vi->over->size == 2) {
					vi->inuse = true;
					iv = vi->name.indexof('.');
					if(iv > 0) {
						sprintf(buf, "           MOVE %s", (const char *)vi->name.substr(iv + 1));
						moves.add(buf);
						sprintf(buf, "             OF %s", (const char *) vi->name.substr(0,iv));
						moves.add(buf);
						sprintf(buf, "             TO %s    ", (const char *)vi->over->name);
					} else {
						sprintf(buf, "           MOVE %s", (const char *)vi->name);
						moves.add(buf);
						sprintf(buf, "             TO %s", (const char *)vi->over->name);
					}
					moves.add(buf);
					vi = vi->over;
				}
				if(vi->type != 'I' || vi->size != 2) {
					sprintf(buf, "line %d of %s: indicator variable %s must be S9(4) COMP-5", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				vi->inuse = true;
			}
			varholder * v = sym[svar];
			if(v == NULL) {
				sprintf(buf, "line %d of %s: variable not found: %s", cl.lineno, cl.fname, (const char *)svar);
				throw buf;
			}
			sql = sql.substr(ib);
			++parmnum;
			v->inuse = true;
			if(v->type == 'O') {
				varholder * h = v->over;
				h->inuse = true;
				// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
				// will need to be put on two lines
				iv = v->name.indexof('.');
				if(iv > 0) {
					sprintf(buf, "           MOVE %s", (const char *)v->name.substr(iv + 1));
					moves.add(buf);
					sprintf(buf, "             OF %s", (const char *) v->name.substr(0,iv));
					moves.add(buf);
					sprintf(buf, "             TO %s    ", (const char *)h->name);
				} else {
					sprintf(buf, "           MOVE %s", (const char *)v->name);
					moves.add(buf);
					sprintf(buf, "             TO %s", (const char *)h->name);
				}
				moves.add(buf);
				v = h;
			}
			// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that
			// will need to be put on two lines
			iv = v->name.indexof('.');
			if(iv > 0) {
				sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
				addln(lineno++, buf);
				sprintf(buf, "%s  %s", shift, (const char *)v->name.substr(iv + 1));
				addln(lineno++, buf);
				sprintf(buf, "%s   OF %s", shift, (const char *)v->name.substr(0,iv));
			} else {
				sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
				addln(lineno++, buf);
				sprintf(buf, "%s   %s", shift, (const char *)v->name);
			}
			addln(lineno++, buf);
			sprintf(buf, "%s MOVE %c%c%c TO SQL-TYPE(%d)", shift, Q, v->type, Q, parmnum);
			addln(lineno++, buf);
			sprintf(buf, "%s MOVE %d TO SQL-LEN(%d)", shift, v->size, parmnum);
			addln(lineno++, buf);
			if(v->type == '3') {
				char i1 = (char)(v->precision/16);
				char i2 = (char)(v->precision % 16);
				if(i1 < 10) i1 += '0';
				else i1 = (char)(i1 + 'A' - 10);
				if(i2 < 10) i2 += '0';
				else i2 = (char)(i2 + 'A' - 10);
				sprintf(buf, "%s MOVE X'%c%c' TO SQL-PREC(%d)", shift, i1, i2, parmnum);
				addln(lineno++, buf);
			}
			if(vi != NULL) {
				++parmnum;
				bWasInd = true;
				// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
				// will need to be put on two lines
				iv = vi->name.indexof('.');
				if(iv > 0) {
					sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
					addln(lineno++, buf);
					sprintf(buf, "%s  %s", shift, (const char *)vi->name.substr(iv + 1));
					addln(lineno++, buf);
					sprintf(buf, "%s   OF %s ", shift, (const char *)vi->name.substr(0,iv));
				} else {
					sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
					addln(lineno++, buf);
					sprintf(buf, "%s   %s", shift, (const char *)vi->name);
				}
				addln(lineno++, buf);
				sprintf(buf, "%s MOVE %ci%c TO SQL-TYPE(%d)", shift, Q, Q, parmnum);
				addln(lineno++, buf);
			}
		}
		sprintf(buf, "%s MOVE %d TO SQL-COUNT", shift, parmnum);
		addln(lineno++, buf);
		sprintf(buf, "%s CALL %sOCSQLPRE%s USING SQLV", shift, sSQ, sSQ);
		addln(lineno++, buf);
		sprintf(buf, "%s                     SQL-STMT-%d", shift, cl.sqlnum);
		addln(lineno++, buf);
		sprintf(buf, "%s                     SQLCA", shift);
		addln(lineno++, buf);
		sprintf(buf, "%s SET SQL-HCONN OF SQLCA TO NULL", shift);
		addln(lineno++, buf);
		doWHENEVER(lineno);
		if(!bWasInd) {
			addln(lineno++, "           END-IF");
		}
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}
		for(int i = 0; i < moves.size(); ++i) {
			addln(lineno++, moves[i]);
		}
		sprintf(buf, "           CALL %sOCSQLEXE%s USING SQL-STMT-%d", sSQ, sSQ, cl.sqlnum);
		addln(lineno++, buf);
		addln(lineno++, "                               SQLCA");
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	void processCALL(cobline & cl, int & lineno)
	{
		int iv = 0;
		string sql;
		removeInQ(sql, sqlcmd[cl.sqlnum]);
		const char * shift = "          ";
		string sqlu = sql;
		sqlu.toupper();

		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}

		sarray movesin;
		sarray movesout;
		int parmnum = 0;
		bool b_ret = (sql[5] == ':');
		for(int ix = sql.indexof(':'); ix >= 0; ix = sql.indexof(':')) {
			int ib = indexEndVar(sql, ix);
			string svar = sql.substr(ix + 1, ib - ix - 1);
			svar.toupper();
			sql = sql.substr(ib);
			sqlu = sqlu.substr(ib);
			bool b_inout = false;
			bool b_out = false;
			if(sqlu.starts(" OUTPUT")) {
				b_out = true;
			} else if(sqlu.starts(" OUT")) {
				b_out = true;
			} else if(sqlu.starts(" INOUT")) {
				b_inout = true;
			}
			if(parmnum == 0 && b_ret) {
				b_out = true;
			}
			varholder * vi = NULL;
			ix = svar.indexof(':');
			if(ix > 0) {
				string ivar = svar.substr(ix+1);
				svar = svar.substr(0, ix);
				vi = sym[ivar];
				if(vi == NULL) {
					sprintf(buf, "line %d of %s: indicator variable not found: %s", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				if(vi->type == 'O' && vi->over->type == 'I' && vi->over->size == 2) {
					vi->inuse = true;
					iv = vi->name.indexof('.');
					if(iv > 0) {
						if(!b_out) {
							sprintf(buf, "           MOVE %s OF %s", (const char *)vi->name.substr(iv + 1), (const char *)vi->name.substr(0,iv) );
							movesin.add(buf);
							sprintf(buf, "             TO %s ", (const char *)vi->over->name);
							movesin.add(buf);
						}
						if(b_out || b_inout) {
							sprintf(buf, "           MOVE %s", (const char *)vi->over->name);
							movesout.add(buf);
							sprintf(buf, "             TO %s    ", (const char *)vi->name.substr(iv + 1));
							movesout.add(buf);
							sprintf(buf, "             OF %s", (const char *) vi->name.substr(0,iv));
							movesout.add(buf);
						}
					} else {
						if(!b_out) {
							sprintf(buf, "           MOVE %s TO %s", (const char *)vi->name, (const char *)vi->over->name);
							movesin.add(buf);
						}
						if(b_out || b_inout) {
							sprintf(buf, "           MOVE %s", (const char *)vi->over->name);
							movesout.add(buf);
							sprintf(buf, "             TO %s", (const char *)vi->name);
							movesout.add(buf);
						}
					}
					vi = vi->over;
				}
				if(vi->type != 'I' || vi->size != 2) {
					sprintf(buf, "line %d of %s: indicator variable %s must be S9(4) COMP-5", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				vi->inuse = true;
			}
			varholder * v = sym[svar];
			if(v == NULL) {
				sprintf(buf, "line %d of %s: variable not found: %s", cl.lineno, cl.fname, (const char *)svar);
				throw buf;
			}
			++parmnum;
			v->inuse = true;
			if(v->type == 'O') {
				varholder * h = v->over;
				h->inuse = true;
				if(!b_out) {
					// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
					// will need to be put on two lines
					iv = v->name.indexof('.');
					if(iv > 0) {
						sprintf(buf, "           MOVE %s OF %s", (const char *)v->name.substr(iv + 1), (const char *)v->name.substr(0,iv) );
						movesin.add(buf);
						sprintf(buf, "             TO %s ", (const char *)h->name);
					} else {
						sprintf(buf, "           MOVE %s TO %s", (const char *)v->name, (const char *)h->name);
					}
					movesin.add(buf);
				}
				if(b_out || b_inout) {
					iv = v->name.indexof('.');
					if(iv > 0) {
						sprintf(buf, "           MOVE %s", (const char *)h->name);
						movesout.add(buf);
						sprintf(buf, "             TO %s OF %s", (const char *)v->name.substr(iv + 1), (const char *)v->name.substr(0,iv) );
					} else {
						sprintf(buf, "           MOVE %s TO %s", (const char *)h->name, (const char *)v->name);
					}
					movesout.add(buf);
				}
				v = h;
			}
			// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
			// will need to be put on two lines
			iv = v->name.indexof('.');
			if(iv > 0) {
				sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
				addln(lineno++, buf);
				sprintf(buf, "%s  %s", shift, (const char *)v->name.substr(iv + 1));
				addln(lineno++, buf);
				sprintf(buf, "%s   OF %s ", shift, (const char *)v->name.substr(0,iv));
			} else {
				sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
				addln(lineno++, buf);
				sprintf(buf, "%s   %s", shift, (const char *)v->name);
			}
			addln(lineno++, buf);
			sprintf(buf, "%s MOVE %c%c%c TO SQL-TYPE(%d)", shift, Q, v->type, Q, parmnum);
			addln(lineno++, buf);
			sprintf(buf, "%s MOVE %d TO SQL-LEN(%d)", shift, v->size, parmnum);
			addln(lineno++, buf);
			if(v->type == '3') {
				unsigned char i1 = (char)(v->precision/16);
				unsigned char i2 = (char)(v->precision % 16);
				// HACK for passing "out" 0x80 or "inout" 0xC0 in hight byte.
				if(b_out) {
					i1 |= (char) 0x8;
				} else if(b_inout) {
					i1 |= (char) 0xC;
				} else {
					i1 |= (char) 0x4;
				}
				if(i1 < 10) i1 += '0';
				else i1 = (char)(i1 + 'A' - 10);
				if(i2 < 10) i2 += '0';
				else i2 = (char)(i2 + 'A' - 10);
				sprintf(buf, "%s MOVE X'%c%c' TO SQL-PREC(%d)", shift, i1, i2, parmnum);
				addln(lineno++, buf);
			} else {
				// HACK for passing "out" 0x80 or "inout" 0xC0 in hight byte.
				if(b_out) {
					sprintf(buf, "%s MOVE X'80' TO SQL-PREC(%d)", shift, parmnum);
				} else if(b_inout) {
					sprintf(buf, "%s MOVE X'C0' TO SQL-PREC(%d)", shift, parmnum);
				} else {
					sprintf(buf, "%s MOVE X'40' TO SQL-PREC(%d)", shift, parmnum);
				}
				addln(lineno++, buf);
			}
			if(vi != NULL) {
				++parmnum;
				// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
				// will need to be put on two lines
				iv = vi->name.indexof('.');
				if(iv > 0) {
					sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
					addln(lineno++, buf);
					sprintf(buf, "%s  %s", shift, (const char *)vi->name.substr(iv + 1));
					addln(lineno++, buf);
					sprintf(buf, "%s   OF %s ", shift, (const char *)vi->name.substr(0,iv));
				} else {
					sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
					addln(lineno++, buf);
					sprintf(buf, "%s   %s", shift, (const char *)vi->name);
				}
				addln(lineno++, buf);
				sprintf(buf, "%s MOVE %ci%c TO SQL-TYPE(%d)", shift, Q, Q, parmnum);
				addln(lineno++, buf);
			}
		}
		sprintf(buf, "%s MOVE %d TO SQL-COUNT", shift, parmnum);
		addln(lineno++, buf);
		for(int i = 0; i < movesin.size(); ++i) {
			addln(lineno++, movesin[i]);
		}
		sprintf(buf, "%s CALL %sOCSQLCAL%s USING SQLV", shift, sSQ, sSQ);
		addln(lineno++, buf);
		sprintf(buf, "%s                     SQL-STMT-%d", shift, cl.sqlnum);
		addln(lineno++, buf);
		sprintf(buf, "%s                     SQLCA", shift);
		addln(lineno++, buf);
		if(movesout.size() > 0) {
			addln(lineno++, "           IF SQLCODE = 0");
			for(int i = 0; i < movesout.size(); ++i) {
				addln(lineno++, movesout[i]);
			}
			addln(lineno++, "           END-IF");
		}
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	void processSEL(cobline & cl, int & lineno)
	{
		int iv = 0;
		string sql;
		removeInQ(sql, sqlcmd[cl.sqlnum]);
		const char * shift = "              ";

		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}

		// Check for indicator variables
		bool bWasInd = false;
		string sqltest(sql);
		int iix = sqltest.indexof(" *SELECT ");
		if(iix > 0) {
			sqltest = sqltest.substr(iix);
		}
		for(int ix = sqltest.indexof(':'); ix >= 0; ix = sqltest.indexof(':')) {
			int ib = indexEndVar(sqltest, ix);
			string svar = sqltest.substr(ix + 1, ib - ix - 1);
			ix = svar.indexof(':');
			if(ix > 0) {
				bWasInd = true;
				shift = "          ";
				break;
			}
			sqltest = sqltest.substr(ib);
		}

		if(bWasInd) {
			sprintf(buf, "           MOVE %cA%c TO SQL-PREP OF SQL-STMT-%d", Q, Q, cl.sqlnum);
			addln(lineno++, buf);
		} else {
			sprintf(buf, "           IF SQL-PREP OF SQL-STMT-%d = %cN%c", cl.sqlnum, Q, Q);
			addln(lineno++, buf);
		}

		sarray movesin;
		sarray movesout;
		int parmnum = 0;
		bool b_in = false;
		for(int ix = sql.indexof(':'); ix >= 0; ix = sql.indexof(':')) {
			int ib = indexEndVar(sql, ix);
			string svar = sql.substr(ix + 1, ib - ix - 1);
			svar.toupper();
			sql = sql.substr(ib);
			varholder * vi = NULL;
			ix = svar.indexof(':');
			if(ix > 0) {
				string ivar = svar.substr(ix+1);
				svar = svar.substr(0, ix);
				vi = sym[ivar];
				if(vi == NULL) {
					sprintf(buf, "line %d of %s: indicator variable not found: %s", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				if(vi->type == 'O' && vi->over->type == 'I' && vi->over->size == 2) {
					bool in = (sql.indexof(" *SELECT ") >= 0);
					vi->inuse = true;
					iv = vi->name.indexof('.');
					if(iv > 0) {
						if(in) {
							sprintf(buf, "           MOVE %s OF %s", (const char *)vi->name.substr(iv + 1), (const char *)vi->name.substr(0,iv) );
							movesin.add(buf);
							sprintf(buf, "             TO %s ", (const char *)vi->over->name);
							movesin.add(buf);
						} else {
							sprintf(buf, "           MOVE %s", (const char *)vi->over->name);
							movesout.add(buf);
							sprintf(buf, "             TO %s    ", (const char *)vi->name.substr(iv + 1));
							movesout.add(buf);
							sprintf(buf, "             OF %s", (const char *) vi->name.substr(0,iv));
							movesout.add(buf);
						}
					} else {
						if(in) {
							sprintf(buf, "           MOVE %s TO %s", (const char *)vi->name, (const char *)vi->over->name);
							movesin.add(buf);
						} else {
							sprintf(buf, "           MOVE %s", (const char *)vi->over->name);
							movesout.add(buf);
							sprintf(buf, "             TO %s", (const char *)vi->name);
							movesout.add(buf);
						}
					}
					vi = vi->over;
				}
				if(vi->type != 'I' || vi->size != 2) {
					sprintf(buf, "line %d of %s: indicator variable %s must be S9(4) COMP-5", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				vi->inuse = true;
			}
			varholder * v = sym[svar];
			if(v == NULL) {
				sprintf(buf, "line %d of %s: variable not found: %s", cl.lineno, cl.fname, (const char *)svar);
				throw buf;
			}
			++parmnum;
			v->inuse = true;
			if(v->type == 'O') {
				varholder * h = v->over;
				h->inuse = true;
				if(!b_in) {
					b_in = !(sql.indexof(" *SELECT ") >= 0);
				}
				if(b_in) {
					// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
					// will need to be put on two lines
					iv = v->name.indexof('.');
					if(iv > 0) {
						sprintf(buf, "           MOVE %s OF %s", (const char *)v->name.substr(iv + 1), (const char *)v->name.substr(0,iv) );
						movesin.add(buf);
						sprintf(buf, "             TO %s ", (const char *)h->name);
					} else {
						sprintf(buf, "           MOVE %s TO %s", (const char *)v->name, (const char *)h->name);
					}
					movesin.add(buf);
				} else {
					iv = v->name.indexof('.');
					if(iv > 0) {
						sprintf(buf, "             MOVE %s", (const char *)h->name);
						movesout.add(buf);
						sprintf(buf, "               TO %s OF %s", (const char *)v->name.substr(iv + 1), (const char *)v->name.substr(0,iv) );
					} else {
						sprintf(buf, "             MOVE %s TO %s", (const char *)h->name, (const char *)v->name);
					}
					movesout.add(buf);
				}
				v = h;
			}
			// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
			// will need to be put on two lines
			iv = v->name.indexof('.');
			if(iv > 0) {
				sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
				addln(lineno++, buf);
				sprintf(buf, "%s  %s", shift, (const char *)v->name.substr(iv + 1));
				addln(lineno++, buf);
				sprintf(buf, "%s   OF %s ", shift, (const char *)v->name.substr(0,iv));
			} else {
				sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
				addln(lineno++, buf);
				sprintf(buf, "%s   %s", shift, (const char *)v->name);
			}
			addln(lineno++, buf);
			sprintf(buf, "%s MOVE %c%c%c TO SQL-TYPE(%d)", shift, Q, v->type, Q, parmnum);
			addln(lineno++, buf);
			sprintf(buf, "%s MOVE %d TO SQL-LEN(%d)", shift, v->size, parmnum);
			addln(lineno++, buf);
			if(v->type == '3') {
				char i1 = (char)(v->precision/16);
				char i2 = (char)(v->precision % 16);
				if(i1 < 10) i1 += '0';
				else i1 = (char)(i1 + 'A' - 10);
				if(i2 < 10) i2 += '0';
				else i2 = (char)(i2 + 'A' - 10);
				sprintf(buf, "%s MOVE X'%c%c' TO SQL-PREC(%d)", shift, i1, i2, parmnum);
				addln(lineno++, buf);
			}
			if(vi != NULL) {
				++parmnum;
				// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
				// will need to be put on two lines
				iv = vi->name.indexof('.');
				if(iv > 0) {
					sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
					addln(lineno++, buf);
					sprintf(buf, "%s  %s", shift, (const char *)vi->name.substr(iv + 1));
					addln(lineno++, buf);
					sprintf(buf, "%s   OF %s ", shift, (const char *)vi->name.substr(0,iv));
				} else {
					sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
					addln(lineno++, buf);
					sprintf(buf, "%s   %s", shift, (const char *)vi->name);
				}
				addln(lineno++, buf);
				sprintf(buf, "%s MOVE %ci%c TO SQL-TYPE(%d)", shift, Q, Q, parmnum);
				addln(lineno++, buf);
			}
		}
		sprintf(buf, "%s MOVE %d TO SQL-COUNT", shift, parmnum);
		addln(lineno++, buf);
		sprintf(buf, "%s CALL %sOCSQLPRE%s USING SQLV", shift, sSQ, sSQ);
		addln(lineno++, buf);
		sprintf(buf, "%s                     SQL-STMT-%d", shift, cl.sqlnum);
		addln(lineno++, buf);
		sprintf(buf, "%s                     SQLCA", shift);
		addln(lineno++, buf);
		sprintf(buf, "%s SET SQL-HCONN OF SQLCA TO NULL", shift);
		addln(lineno++, buf);
		doWHENEVER(lineno);
		if(!bWasInd) {
			addln(lineno++, "           END-IF");
		}
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}
		for(int i = 0; i < movesin.size(); ++i) {
			addln(lineno++, movesin[i]);
		}
		sprintf(buf, "           CALL %sOCSQLEXE%s USING SQL-STMT-%d", sSQ, sSQ, cl.sqlnum);
		addln(lineno++, buf);
		addln(lineno++, "                               SQLCA");
		if(movesout.size() > 0) {
			addln(lineno++, "           IF SQLCODE = 0");
			for(int i = 0; i < movesout.size(); ++i) {
				addln(lineno++, movesout[i]);
			}
			addln(lineno++, "           END-IF");
		}
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	void processCOMMIT(cobline & cl, int & lineno)
	{
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}

		sprintf(buf, "           CALL %sOCSQLCMT%s USING SQLCA END-CALL", sSQ, sSQ);
		addln(lineno++, buf);
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
		string sqlu(*cl.sql);
		sqlu.toupper();
		if(ixFull(sqlu, "RELEASE") > 0) {
			if(cl.conname != NULL) {
				varholder* vi = sym[*cl.conname];
				addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
				sprintf(buf, "               %s", (const char*)vi->name);
				addln(lineno++, buf);
			}
			sprintf(buf, "           CALL %sOCSQLDIS%s USING SQLCA END-CALL", sSQ, sSQ);
			addln(lineno++, buf);
			if(cl.conname != NULL) {
				addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
			}
			doWHENEVER(lineno);
		}
	}

	void processROLLBACK(cobline & cl, int & lineno)
	{
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}

		sprintf(buf, "           CALL %sOCSQLRBK%s USING SQLCA END-CALL", sSQ, sSQ);
		addln(lineno++, buf);
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
		string sqlu(*cl.sql);
		sqlu.toupper();
		if(ixFull(sqlu, "RELEASE") > 0) {
			if(cl.conname != NULL) {
				varholder* vi = sym[*cl.conname];
				addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
				sprintf(buf, "               %s", (const char*)vi->name);
				addln(lineno++, buf);
			}
			sprintf(buf, "           CALL %sOCSQLDIS%s USING SQLCA END-CALL", sSQ, sSQ);
			addln(lineno++, buf);
			if(cl.conname != NULL) {
				addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
			}
			doWHENEVER(lineno);
		}
	}

	void doWHENEVER(int & lineno)
	{
		if(W_ERR.length() > 0) {
			addln(lineno++, "           IF SQLCODE OF SQLCA < 0");
			sprintf(buf, "               %s", (const char *) W_ERR);
			string fl(buf);
			processfmt(lineno, fl);
			addln(lineno++, "           END-IF");
		}
		if(W_WARN.length() > 0) {
			addln(lineno++, "           IF SQLCODE OF SQLCA > 0 AND SQLCODE OF SQLCA NOT = 100");
			sprintf(buf, "               %s", (const char *) W_WARN);
			string fl(buf);
			processfmt(lineno, fl);
			addln(lineno++, "           END-IF");
		}
		if(W_NOTFOUND.length() > 0) {
			addln(lineno++, "           IF SQLCODE OF SQLCA = 100");
			sprintf(buf, "               %s", (const char *) W_NOTFOUND);
			string fl(buf);
			processfmt(lineno, fl);
			addln(lineno++, "           END-IF");
		}
	}

	void processWHENEVER(cobline & cl, int & lineno)
	{
		string sqlu(*cl.sql);
		sqlu.toupper();
		sqlu = sqlu.substr(9);
		int ix = 9;
		string * cond;
		if(sqlu.starts("SQLERROR ")) {
			sqlu = sqlu.substr(9);
			ix += 9;
			cond = &W_ERR;
		} else if(sqlu.starts("SQLWARNING ")) {
			sqlu = sqlu.substr(11);
			ix += 11;
			cond = &W_WARN;
		} else if(sqlu.starts("NOTFOUND ")) {
			sqlu = sqlu.substr(9);
			ix += 9;
			cond = &W_NOTFOUND;
		} else if(sqlu.starts("NOT FOUND ")) {
			sqlu = sqlu.substr(10);
			ix += 10;
			cond = &W_NOTFOUND;
		} else {
			sprintf(buf, "line %d of %s: incorrect SQL : %s", cl.lineno, cl.fname, (const char *)*cl.sql);
			throw buf;
		}
		if(sqlu.starts("CONTINUE")) {
			*cond = "";
			return;
		}
		if(sqlu.starts("STOP")) {
			*cond = "STOP RUN";
			return;
		}
		if(sqlu.starts("GOTO ")) {
			*cond = "GO TO " + cl.sql->substr(ix + 5);
			return;
		}
		if(sqlu.starts("GO TO ")) {
			*cond = cl.sql->substr(ix);
			return;
		}
		if(sqlu.starts("DO ")) {
			sqlu = sqlu.substr(3);
			ix += 3;
		}
		if(sqlu.starts("CALL ")) {
			*cond = cl.sql->substr(ix);
			return;
		}
		if(sqlu.starts("PERFORM ")) {
			*cond = cl.sql->substr(ix);
			return;
		}
		sprintf(buf, "line %d of %s: incorrect SQL : %s", cl.lineno, cl.fname, (const char *)*cl.sql);
		throw buf;
	}

	void processEXECUTEIMMED(cobline & cl, int & lineno)
	{
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}

		string & sql = *cl.sql;
		int ix = sql.indexof(':');
		if(ix < 0) {
			sprintf(buf, "line %d of %s: incorrect SQL : %s", cl.lineno, cl.fname, (const char *)sql);
			throw buf;
		}
		int ib = sql.indexof(' ', ix);
		int ibr = sql.indexof(')', ix);
		int ic = sql.indexof(',', ix);
		if(ib < 0 || (ic >= 0 && ib > ic)) ib = ic;
		if(ib < 0 || (ibr >= 0 && ib > ibr)) ib = ibr;
		if(ib < 0) ib = sql.length();
		string svar = sql.substr(ix + 1, ib - ix - 1);
		svar.toupper();
		varholder * v = sym[svar];
		if(v == NULL) {
			sprintf(buf, "line %d of %s: variable not found: %s", cl.lineno, cl.fname, (const char *)svar);
			throw buf;
		}
		if(v->type != 'X') {
			sprintf(buf, "line %d of %s: incorrect variable datatype: %s", cl.lineno, cl.fname, (const char *)svar);
			throw buf;
		}
		v->inuse = true;
		sprintf(buf, "           MOVE %d TO SQL-LEN(1)", v->size);
		addln(lineno++, buf);
		sprintf(buf, "           CALL %sOCSQLIMM%s USING %s", sSQ, sSQ, (const char *)svar);
		addln(lineno++, buf);
		addln(lineno++, "                               SQL-LEN(1)");
		addln(lineno++, "                               SQLCA");
		addln(lineno++, "           END-CALL");
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	void processUNKNOWN(cobline & cl, int & lineno)
	{
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}

		sprintf(buf, "           MOVE %d TO SQL-LEN(1)", (int)strlen(sqlcmd[cl.sqlnum]));
		addln(lineno++, buf);
		sprintf(buf, "           CALL %sOCSQLIMM%s USING SQL-STMT-%d", sSQ, sSQ, cl.sqlnum);
		addln(lineno++, buf);
		addln(lineno++, "                               SQL-LEN(1)");
		addln(lineno++, "                               SQLCA");
		addln(lineno++, "           END-CALL");
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	void processPREPARE(cobline& cl, int& lineno)
	{
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}

		string sql = cl.sql->substr(8);
		sql.toupper();
		int x = sql.indexof(" FROM ");
		if(x <= 0) {
			sprintf(buf, "line %d of %s: Incorrect PREPARE %s", cl.lineno, cl.fname, (const char*)sql);
			throw buf;
		}
		string hvar = sql.substr(x + 6);
		if(hvar.starts(":")) hvar = hvar.substr(1);
		sql = sql.substr(0, x);
		varholder* vd = sym[sql];
		if(vd == NULL || vd->type != 'Y') {
			sprintf(buf, "line %d of %s: Dynamic Statement not found: %s", cl.lineno, cl.fname, (const char*)sql);
			throw buf;
		}
		varholder* vc = vd->over;
		vd->inuse = true;
		varholder* v = sym[hvar];
		if(v == NULL) {
			sprintf(buf, "line %d of %s: Host Variable not found: %s", cl.lineno, cl.fname, (const char*)hvar);
			throw buf;
		}
		if(v->type != 'X' && v->type != 'L' && v->type != 'V') {
			sprintf(buf, "line %d of %s: Unsupported Host Variable Type: %s", cl.lineno, cl.fname, (const char*)hvar);
			throw buf;
		}

		int sqlnum = vd->size;
		sprintf(buf, "           MOVE %c%c%c TO SQL-OPT OF SQL-STMT-%d", Q, vc->type, Q, sqlnum);
		addln(lineno++, buf);
		if(v->type == 'X') {
			sprintf(buf, "           MOVE %d TO SQL-STMLEN OF SQL-STMT-%d", v->size, sqlnum);
			addln(lineno++, buf);
		}
		sprintf(buf, "           MOVE %c%c%c TO SQL-VTYPE OF SQL-STMT-%d", Q, v->type, Q, sqlnum);
		addln(lineno++, buf);
		sprintf(buf, "           MOVE %cA%c TO SQL-PREP OF SQL-STMT-%d", Q, Q, sqlnum);
		addln(lineno++, buf);
		sprintf(buf, "           SET SQL-VADDR OF SQL-STMT-%d", sqlnum);
		addln(lineno++, buf);
		sprintf(buf, "             TO ADDRESS OF %s", (const char*)hvar);
		addln(lineno++, buf);
		addln(lineno++, "           MOVE 0 TO SQL-COUNT");
		sprintf(buf, "           CALL %sOCSQLPRE%s USING SQLV", sSQ, sSQ);
		addln(lineno++, buf);
		sprintf(buf, "                                   SQL-STMT-%d", sqlnum);
		addln(lineno++, buf);
		sprintf(buf, "                                   SQLCA");
		addln(lineno++, buf);
		addln(lineno++, "           END-CALL");
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	void processOPENCURSOR(cobline & cl, int & lineno)
	{
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}

		int iv = 0;
		string sql = cl.sql->substr(5);
		int x = sql.indexof(' ');
		if(x > 0) sql = sql.substr(0, x);
		sql.toupper();
		sarray moves;
		varholder * v = sym[sql];
		if(v == NULL || (v->type != 'C' && v->type != 'c' && v->type != 'D' && v->type != 'd')) {
			sprintf(buf, "line %d of %s: Cursor not found: %s", cl.lineno, cl.fname, (const char *)sql);
			throw buf;
		}
		int sqlnum = v->size;
		if(v->type == 'D' || v->type == 'd') {
			sprintf(buf, "           CALL %sOCSQLOCU%s USING SQL-STMT-%d", sSQ, sSQ, sqlnum);
			addln(lineno++, buf);
			addln(lineno++, "                               SQLCA");
			addln(lineno++, "           END-CALL");
			if(cl.conname != NULL) {
				addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
			}
			doWHENEVER(lineno);
			return;
		}
		bool bWH = (v->type == 'c');
		v->inuse = true;
		removeInQ(sql, sqlcmd[sqlnum]);
		const char * shift = "              ";

		// Check for indicator variables
		bool bWasInd = false;
		string sqltest(sql);
		for(int ix = sqltest.indexof(':'); ix >= 0; ix = sqltest.indexof(':')) {
			int ib = indexEndVar(sqltest, ix);
			string svar = sqltest.substr(ix + 1, ib - ix - 1);
			ix = svar.indexof(':');
			if(ix > 0) {
				bWasInd = true;
				shift = "          ";
				break;
			}
			sqltest = sqltest.substr(ib);
		}

		if(bWasInd) {
			sprintf(buf, "           MOVE %cA%c TO SQL-PREP OF SQL-STMT-%d", Q, Q, sqlnum);
			addln(lineno++, buf);
		} else {
			sprintf(buf, "           IF SQL-PREP OF SQL-STMT-%d = %cN%c", sqlnum, Q, Q);
			addln(lineno++, buf);
		}

		int parmnum = 0;
		for(int ix = sql.indexof(':'); ix >= 0; ix = sql.indexof(':')) {
			int ib = indexEndVar(sql, ix);
			string svar = sql.substr(ix + 1, ib - ix - 1);
			varholder * vi = NULL;
			ix = svar.indexof(':');
			if(ix > 0) {
				string ivar = svar.substr(ix+1);
				svar = svar.substr(0, ix);
				vi = sym[ivar];
				if(vi == NULL) {
					sprintf(buf, "line %d of %s: indicator variable not found: %s", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				if(vi->type == 'O' && vi->over->type == 'I' && vi->over->size == 2) {
					vi->inuse = true;
					iv = vi->name.indexof('.');
					if(iv > 0) {
						sprintf(buf, "           MOVE %s", (const char *)vi->name.substr(iv + 1));
						moves.add(buf);
						sprintf(buf, "             OF %s", (const char *) vi->name.substr(0,iv));
						moves.add(buf);
						sprintf(buf, "             TO %s    ", (const char *)vi->over->name);
					} else {
						sprintf(buf, "           MOVE %s", (const char *)vi->name);
						moves.add(buf);
						sprintf(buf, "             TO %s", (const char *)vi->over->name);
					}
					moves.add(buf);
					vi = vi->over;
				}
				if(vi->type != 'I' || vi->size != 2) {
					sprintf(buf, "line %d of %s: indicator variable %s must be S9(4) COMP-5", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				vi->inuse = true;
			}
			v = sym[svar];
			if(v == NULL) {
				sprintf(buf, "line %d of %s: variable not found: %s", cl.lineno, cl.fname, (const char *)svar);
				throw buf;
			}
			sql = sql.substr(ib);
			++parmnum;
			v->inuse = true;
			if(v->type == 'O') {
				varholder * h = v->over;
				h->inuse = true;
				// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
				// will need to be put on two lines
				iv = v->name.indexof('.');
				if(iv > 0) {
					sprintf(buf, "           MOVE %s OF %s", (const char *)v->name.substr(iv + 1), (const char *)v->name.substr(0,iv) );
					moves.add(buf);
					sprintf(buf, "             TO %s", (const char *)h->name);
				} else {
					sprintf(buf, "           MOVE %s TO %s", (const char *)v->name, (const char *)h->name);
				}
				moves.add(buf);
				v = h;
			}
			// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
			// will need to be put on two lines
			iv = v->name.indexof('.');
			if(iv > 0) {
				sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
				addln(lineno++, buf);
				sprintf(buf, "%s  %s", shift, (const char *)v->name.substr(iv + 1));
				addln(lineno++, buf);
				sprintf(buf, "%s   OF %s ", shift, (const char *)v->name.substr(0,iv));
			} else {
				sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
				addln(lineno++, buf);
				sprintf(buf, "%s   %s", shift, (const char *)v->name);
			}
			addln(lineno++, buf);
			sprintf(buf, "%s MOVE %c%c%c TO SQL-TYPE(%d)", shift, Q, v->type, Q, parmnum);
			addln(lineno++, buf);
			sprintf(buf, "%s MOVE %d TO SQL-LEN(%d)", shift, v->size, parmnum);
			addln(lineno++, buf);
			if(v->type == '3') {
				char i1 = (char)(v->precision/16);
				char i2 = (char)(v->precision % 16);
				if(i1 < 10) i1 += '0';
				else i1 = (char)(i1 + 'A' - 10);
				if(i2 < 10) i2 += '0';
				else i2 = (char)(i2 + 'A' - 10);
				sprintf(buf, "%s MOVE X'%c%c' TO SQL-PREC(%d)", shift, i1, i2, parmnum);
				addln(lineno++, buf);
			}
			if(vi != NULL) {
				++parmnum;
				// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
				// will need to be put on two lines
				iv = vi->name.indexof('.');
				if(iv > 0) {
					sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
					addln(lineno++, buf);
					sprintf(buf, "%s  %s", shift, (const char *)vi->name.substr(iv + 1));
					addln(lineno++, buf);
					sprintf(buf, "%s   OF %s ", shift, (const char *)vi->name.substr(0,iv));
				} else {
					sprintf(buf, "%s SET SQL-ADDR(%d) TO ADDRESS OF", shift, parmnum);
					addln(lineno++, buf);
					sprintf(buf, "%s   %s", shift, (const char *)vi->name);
				}
				addln(lineno++, buf);
				sprintf(buf, "%s MOVE %ci%c TO SQL-TYPE(%d)", shift, Q, Q, parmnum);
				addln(lineno++, buf);
			}
		}
		if(bWH) {
			sprintf(buf, "%s MOVE 'H' TO SQL-OPT OF SQL-STMT-%d", shift, sqlnum);
			addln(lineno++, buf);
		}
		sprintf(buf, "%s MOVE %d TO SQL-COUNT", shift, parmnum);
		addln(lineno++, buf);
		sprintf(buf, "%s CALL %sOCSQLPRE%s USING SQLV", shift, sSQ, sSQ);
		addln(lineno++, buf);
		sprintf(buf, "%s                     SQL-STMT-%d", shift, sqlnum);
		addln(lineno++, buf);
		sprintf(buf, "%s                     SQLCA", shift);
		addln(lineno++, buf);
		if(cl.conname != NULL) {
			sprintf(buf, "%s SET SQL-HCONN OF SQLCA TO NULL", shift);
			addln(lineno++, buf);
		}
		doWHENEVER(lineno);
		if(!bWasInd) {
			addln(lineno++, "           END-IF");
		}
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}
		for(int i = 0; i < moves.size(); ++i) {
			addln(lineno++, moves[i]);
		}
		sprintf(buf, "           CALL %sOCSQLOCU%s USING SQL-STMT-%d", sSQ, sSQ, sqlnum);
		addln(lineno++, buf);
		addln(lineno++, "                               SQLCA");
		addln(lineno++, "           END-CALL");
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	void processFETCH(cobline & cl, int & lineno)
	{
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}
		string sql = cl.sql->substr(6);
		int x = sql.indexof(' ');
		string cname;
		int iv = 0;
		if(x > 0) {
			cname = sql.substr(0, x);
			sql = sql.substr(x + 1);
		} else {
			cname = sql;
			sql = "";
		}
		cname.toupper();
		varholder * v = sym[cname];
		if(v == NULL || (v->type != 'C' && v->type != 'c' && v->type != 'D' && v->type != 'd')) {
			sprintf(buf, "line %d of %s: Cursor not found: %s", cl.lineno, cl.fname, (const char *)sql);
			throw buf;
		}
		v->inuse = true;
		int sqlnum = v->size;
		sarray moves;
		int parmnum = 0;
		for(int ix = sql.indexof(':'); ix >= 0; ix = sql.indexof(':')) {
			int ib = indexEndVar(sql, ix);
			string svar = sql.substr(ix + 1, ib - ix - 1);
			varholder * vi = NULL;
			ix = svar.indexof(':');
			if(ix > 0) {
				string ivar = svar.substr(ix+1);
				svar = svar.substr(0, ix);
				vi = sym[ivar];
				if(vi == NULL) {
					sprintf(buf, "line %d of %s: indicator variable not found: %s", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				if(vi->type == 'O' && vi->over->type == 'I' && vi->over->size == 2) {
					vi->inuse = true;
					iv = vi->name.indexof('.');
					if(iv > 0) {
						sprintf(buf, "           MOVE %s", (const char *)vi->over->name);
						moves.add(buf);
						sprintf(buf, "             TO %s    ", (const char *)vi->name.substr(iv + 1));
						moves.add(buf);
						sprintf(buf, "             OF %s", (const char *) vi->name.substr(0,iv));
					} else {
						sprintf(buf, "           MOVE %s", (const char *)vi->over->name);
						moves.add(buf);
						sprintf(buf, "             TO %s", (const char *)vi->name);
					}
					moves.add(buf);
					vi = vi->over;
				}
				if(vi->type != 'I' || vi->size != 2) {
					sprintf(buf, "line %d of %s: indicator variable %s must be S9(4) COMP-5", cl.lineno, cl.fname, (const char *)ivar);
					throw buf;
				}
				vi->inuse = true;
			}
			v = sym[svar];
			if(v == NULL) {
				sprintf(buf, "line %d of %s: variable not found: %s", cl.lineno, cl.fname, (const char *)svar);
				throw buf;
			}
			sql = sql.substr(ib);
			++parmnum;
			v->inuse = true;
			if(v->type == 'O') {
				varholder * h = v->over;
				h->inuse = true;
				// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
				// will need to be put on two lines
				iv = v->name.indexof('.');
				if(iv > 0) {
					sprintf(buf, "             MOVE %s ", (const char *)h->name);
					moves.add(buf);
					sprintf(buf, "             TO %s OF %s", (const char *)v->name.substr(iv + 1), (const char *)v->name.substr(0,iv) );
				} else {
					sprintf(buf, "             MOVE %s TO %s", (const char *)h->name, (const char *)v->name);
				}
				moves.add(buf);
				v = h;
			}
			// look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
			// will need to be put on two lines
			iv = v->name.indexof('.');
			if(iv > 0) {
				sprintf(buf, "           SET SQL-ADDR(%d) TO ADDRESS OF", parmnum);
				addln(lineno++, buf);
				sprintf(buf, "             %s", (const char *)v->name.substr(iv + 1));
				addln(lineno++, buf);
				sprintf(buf, "             OF %s", (const char *)v->name.substr(0,iv));
			} else {
				sprintf(buf, "           SET SQL-ADDR(%d) TO ADDRESS OF", parmnum);
				addln(lineno++, buf);
				sprintf(buf, "             %s", (const char *)v->name);
			}
			addln(lineno++, buf);
			sprintf(buf, "           MOVE %c%c%c TO SQL-TYPE(%d)", Q, v->type, Q, parmnum);
			addln(lineno++, buf);
			sprintf(buf, "           MOVE %d TO SQL-LEN(%d)", v->size, parmnum);
			addln(lineno++, buf);
			if(v->type == '3') {
				char i1 = (char)(v->precision/16);
				char i2 = (char)(v->precision % 16);
				if(i1 < 10) i1 += '0';
				else i1 = (char)(i1 + 'A' - 10);
				if(i2 < 10) i2 += '0';
				else i2 = (char)(i2 + 'A' - 10);
				sprintf(buf, "               MOVE X'%c%c' TO SQL-PREC(%d)", i1, i2, parmnum);
				addln(lineno++, buf);
			}
			if(vi != NULL) {
				++parmnum;
				//  look for a . in the variable name, if one is found the we need to replace it with ' OF ' and that will
				//  will need to be put on two lines
				iv = vi->name.indexof(".");
				if(iv > 0) {
					sprintf(buf, "           SET SQL-ADDR(%d) TO ADDRESS OF", parmnum);
					addln(lineno++, buf);
					sprintf(buf, "             %s", (const char *)vi->name.substr(iv + 1));
					addln(lineno++, buf);
					sprintf(buf, "             OF %s", (const char *)vi->name.substr(0,iv));
				} else {
					sprintf(buf, "           SET SQL-ADDR(%d) TO ADDRESS OF", parmnum);
					addln(lineno++, buf);
					sprintf(buf, "             %s", (const char *)vi->name);
				}
				addln(lineno++, buf);
				sprintf(buf, "           MOVE %ci%c TO SQL-TYPE(%d)", Q, Q, parmnum);
				addln(lineno++, buf);
			}
		}
		sprintf(buf, "           MOVE %d TO SQL-COUNT", parmnum);
		addln(lineno++, buf);
		sprintf(buf, "           CALL %sOCSQLFTC%s USING SQLV", sSQ, sSQ);
		addln(lineno++, buf);
		sprintf(buf, "                               SQL-STMT-%d", sqlnum);
		addln(lineno++, buf);
		addln(lineno++, "                               SQLCA");
		if(moves.size() > 0) {
			addln(lineno++, "           IF SQLCODE = 0");
			for(int i = 0; i < moves.size(); ++i) {
				addln(lineno++, moves[i]);
			}
			addln(lineno++, "           END-IF");
		}
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	void processCLOSECURSOR(cobline & cl, int & lineno)
	{
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}
		string sql = cl.sql->substr(6);
		int x = sql.indexof(' ');
		if(x > 0) sql = sql.substr(0, x);
		sql.toupper();
		varholder * v = sym[sql];
		if(v == NULL || (v->type != 'C' && v->type != 'c' && v->type != 'D' && v->type != 'd')) {
			sprintf(buf, "line %d of %s: Cursor not found: %s", cl.lineno, cl.fname, (const char *)sql);
			throw buf;
		}
		v->inuse = true;
		int sqlnum = v->size;
		sql = (string)sqlcmd[sqlnum];
		sprintf(buf, "           CALL %sOCSQLCCU%s USING SQL-STMT-%d", sSQ, sSQ, sqlnum);
		addln(lineno++, buf);
		addln(lineno++, "                               SQLCA");
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	void processCONNECT(cobline & cl, int & lineno)
	{
		if(cl.conname != NULL) {
			varholder* vi = sym[*cl.conname];
			if(vi == NULL) {
				sprintf(buf, "line %d of %s: connection variable not found: %s", cl.lineno, cl.fname, (const char*)*cl.conname);
				throw buf;
			}
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO ADDRESS OF");
			sprintf(buf, "               %s", (const char*)vi->name);
			addln(lineno++, buf);
		}
		string & sql = *cl.sql;
		string sqlu(sql);
		sqlu.toupper();
		int ix = sql.indexof(':');
		if(ix < 0 || sqlu.starts("DISCONNECT")) {
			if(ixFull(sqlu, "RESET") > 0 || sqlu.starts("DISCONNECT")) {
				sprintf(buf, "           CALL %sOCSQLDIS%s USING SQLCA END-CALL", sSQ, sSQ);
				addln(lineno++, buf);
				if(cl.conname != NULL) {
					addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
				}
				doWHENEVER(lineno);
				return;
			}
			sprintf(buf, "line %d of %s: incorrect SQL : %s", cl.lineno, cl.fname, (const char *)sql);
			throw buf;
		}
		int ib = sql.indexof(' ', ix);
		int ic = sql.indexof(',', ix);
		if(ib < 0) ib = ic;
		if(ib < 0) ib = sql.length();
		if(ic > 0 && ic < ib) ib = ic;
		string svar = sql.substr(ix + 1, ib - ix - 1);
		svar.toupper();
		varholder * v = sym[svar];
		if(v == NULL) {
			sprintf(buf, "line %d of %s: variable not found: %s", cl.lineno, cl.fname, (const char *)svar);
			throw buf;
		}
		if(v->type != 'X') {
			sprintf(buf, "line %d of %s: incorrect variable datatype: %s", cl.lineno, cl.fname, (const char *)svar);
			throw buf;
		}
		v->inuse = true;
		sprintf(buf, "           MOVE %d TO SQL-LEN(1)", v->size);
		addln(lineno++, buf);
		sprintf(buf, "           CALL %sOCSQL%s    USING %s", sSQ, sSQ, (const char *)svar);
		addln(lineno++, buf);
		addln(lineno++, "                               SQL-LEN(1)");
		addln(lineno++, "                               SQLCA");
		addln(lineno++, "           END-CALL");
		if(cl.conname != NULL) {
			addln(lineno++, "           SET SQL-HCONN OF SQLCA TO NULL");
		}
		doWHENEVER(lineno);
	}

	static int ixFull(string & s, const char * s1) {
		return ixFull(s, s1, 0);
	}

	static int ixFull(string & s, const char * s1, int offset)
	{
		int i = s.indexof(s1, offset);
		for(; i >= 0; i = s.indexof(s1, i + 1)) {
			if(i < 7) {
				continue;
			}
			if(i > 0 && s[i - 1] != ' ' && s[i - 1] != ':' && s[i - 1] != ',' && s[i - 1] != ')') {
				continue;
			}
			int e = i + (int) strlen(s1);
			if(e >= s.length() || s[e] == ' ' || s[e] == '.' || s[e] == ',' || s[e] == '(' || s[e] == ':') {
				break;
			}
		}
		return i;
	}

	static void comment(cobline & cl) {
		cl.line[6] = '*';
		cl.bComment = true;
	}
};

char CobPgm::buf[2048];

static int nstart;
static void usage(char * pg) {
	fprintf(stderr, "Usage: %s [-Q] [-F] [-S] [-static] [-I <copybook-directory> [| -I <copybook-directory>]] [-o <output-file>] <filename> ...\n", pg);
	fprintf(stderr, "       -Q        Use double quotes\n");
	fprintf(stderr, "       -F        Force unknown SQL statements to be accepted as \"execute immediate\"\n");
	fprintf(stderr, "       -S        Split long alphanumeric into 160-bytes chunks\n");
	fprintf(stderr, "       -static   Use static calls to OCSQL library\n");
}

int main(int argsLength, char ** args)
{
#ifdef _DEBUG_MEM
	int tmpFlag = _CrtSetDbgFlag(_CRTDBG_REPORT_FLAG);	// Get current flag
	tmpFlag |= _CRTDBG_LEAK_CHECK_DF | _CRTDBG_CHECK_ALWAYS_DF;
	_CrtSetDbgFlag(tmpFlag);
#endif

	fprintf(stdout, HEADER, *args);
	copydir.add(".");
	for(nstart = 1; nstart < argsLength; ++nstart) {
		if(0 == strcmp(args[nstart], "-I")) {
			++nstart;
			if(nstart == argsLength) {
				usage(*args);
				return 16;
			}
			struct stat st;
			char copypathbuf[1024]; //backslash or slash at the end should be allowed, function stat does not like this
			strncpy(copypathbuf, args[nstart], sizeof(copypathbuf));
			copypathbuf[sizeof(copypathbuf) - 1] = 0;
			if(copypathbuf[strlen(copypathbuf) - 1] == '\\' || copypathbuf[strlen(copypathbuf) - 1] == '/') {
				copypathbuf[strlen(copypathbuf) - 1] = 0;
			}
			if(stat(copypathbuf, &st) != 0 || (st.st_mode & S_IFDIR) == 0) {
				fprintf(stderr, "Wrong directory: '%s'\n", copypathbuf);
				usage(*args);
				return 16;
			}
			copydir.add(copypathbuf);
			continue;
		}
		if(0 == strcmp(args[nstart], "-o")) {
			++nstart;
			if(nstart == argsLength) {
				usage(*args);
				return 16;
			}
			strncpy(outfilepath, args[nstart], sizeof(outfilepath));
			outfilepath[sizeof(outfilepath) - 1] = 0;
			continue;
		}
		if(0 == strcmp(args[nstart], "-Q")) {
			bAPOST = false;
			Q = '"';
			sQ = "\"";
			if(*sSQ != 0) sSQ = sQ;
			continue;
		}
		if(0 == strcmp(args[nstart], "-static")) {
			bStatic = true;
			sSQ = sQ;
			continue;
		}
		if(0 == strcmp(args[nstart], "-F")) {
			bForceUnknown = true;
			continue;
		}
		if(0 == strcmp(args[nstart], "-S")) {
			bSplit = true;
			continue;
		}
		if(0 == strcmp(args[nstart], "-free")) {
			fprintf(stderr, "%s: Free format is not implemented yet.\n", *args);
			return 16;
		}
		break;
	}
	if(nstart == argsLength) {
		usage(*args);
		return 16;
	}

	int rc = 0;
	for(int i = nstart; i < argsLength; ++i) {
		try {
			CobPgm * pg = new CobPgm(args[nstart]);
			pg->process();
			delete pg;
			string::cleargc();
		} catch(const char * s) {
			if(rc < 8) rc = 8;
			fprintf(stderr, "%s: ERROR compiling program '%s': %s\n", args[0], args[i], s);
		} catch(...) {
			fprintf(stderr, "%s: ERROR compiling program '%s'. errno=%d\n", args[0], args[i], errno);
			rc = 16;
		}
	}
	return rc;
}

static const char * copyr = "Copyright (C) 2006-2021 Sergey Kashyrin <ska@kiska.net>";
