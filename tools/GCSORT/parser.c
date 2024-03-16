/* A Bison parser, made by GNU Bison 3.5.1.  */
 
/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1





# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 1
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_PARSER_H_INCLUDED
# define YY_YY_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    AND = 258,
    COND = 259,
    ENDREC = 260,
    FNAMES = 261,
    FORMAT = 262,
    INCLUDE = 263,
    INREC = 264,
    NONE = 265,
    OMIT = 266,
    OPTION = 267,
    OR = 268,
    OUTFIL = 269,
    OUTREC = 270,
    SAVE = 271,
    SKIPREC = 272,
    STARTREC = 273,
    STOPAFT = 274,
    SUM = 275,
    XSUM = 276,
    SPLIT = 277,
    SPLITBY = 278,
    VLSCMP = 279,
    VLSHRT = 280,
    Y2PAST = 281,
    MODS = 282,
    BUILD = 283,
    FIELDS = 284,
    OVERLAY = 285,
    GIVE = 286,
    MERGE = 287,
    ORG = 288,
    RECORD = 289,
    SORT = 290,
    JOINKEYS = 291,
    USE = 292,
    COPY = 293,
    TYPE = 294,
    LENGTH = 295,
    DATE1 = 296,
    DATE2 = 297,
    DATE3 = 298,
    DATE4 = 299,
    CHANGE = 300,
    NOMATCH = 301,
    SORTED = 302,
    NOSEQCK = 303,
    UNPAIRED = 304,
    ONLY = 305,
    JOIN = 306,
    JOINREFORMAT = 307,
    FILL = 308,
    FINDREP = 309,
    INFR = 310,
    OUTFR = 311,
    INOUT = 312,
    STARTPOS = 313,
    ENDPOS = 314,
    DO = 315,
    MAXLEN = 316,
    OVERRUN = 317,
    SHIFT = 318,
    DIGIT = 319,
    DIGITBIG = 320,
    CHARTCOND = 321,
    CHARTYPE = 322,
    FILETYPE = 323,
    FORMATTYPE = 324,
    JOINFILE = 325,
    KEY = 326,
    KEYTYPE = 327,
    OCCURFILL = 328,
    OPCOND = 329,
    SUBSTRING = 330,
    ORDER = 331,
    RECTYPEFIX = 332,
    RECTYPEVAR = 333,
    STRING = 334,
    TOKSKIP = 335,
    EXROUT = 336,
    YESNO = 337,
    ERRTRUNC = 338,
    SIGNDIGITBIG = 339
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 24 "parser.y"
 
	int         number;
	long        lnumber;
	long long   llnumber;
	char        *string;
	char        character;
	struct condField_t      *condField;
	struct fieldValue_t     *fieldValue;
	struct SumField_t       *SumField;
    struct changefield_t    *changefield;
    struct findrep_t        *findrep;
    struct findrepfield_t   *findrep_field;

#line 219 "parser.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_H_INCLUDED  */


/* Unqualified %code blocks.  */
#line 37 "parser.y"
 
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#ifdef _MSC_VER
		#include <io.h>
	#else
		#include <stdlib.h> 
		#include <unistd.h>
	#endif
    #include <time.h>
	#include "gcsort.h"
	#include "file.h"
	#include "keyidxrel.h"
	#include "job.h"
	#include "sortfield.h"
	#include "condfield.h"
	#include "fieldvalue.h"
	#include "outrec.h"
	#include "inrec.h"
	#include "outfil.h"
	#include "sumfield.h"
	#include "utils.h"
    #include "gcshare.h"
    #include "datediff.h"
    #include "changefield.h"
    #include "join.h"
    #include "findreplace.h"

	#define  INREC_CASE		1
	#define  OUTREC_CASE	2
    #define  JOIN_CASE      3
    
    /* -->> extern char szMexToken[260];    */

	int yylex    (void);
	void yyerror (char const *);

	struct file_t*		   current_file=NULL;
	struct outfil_t*	   current_outfil=NULL;
	struct condField_t*	   condField=NULL;
    struct inrec_t *       inrec=NULL;
    struct outrec_t *      outrec=NULL;
    struct changefield_t*  current_changefield=NULL;
    struct join_t*         current_join=NULL;
    struct join_t*         F1_join=NULL;
    struct join_t*         F2_join=NULL;
    struct findrep_t*      findrep=NULL;
    struct findrepfield_t* findrep_field=NULL;
    struct findrepfield_t* findrep_field_tmp = NULL;
    struct fieldValue_t*   field_tmp=NULL;
    int    pntChange = 0;  /* 1 = Inrec , 2 = Outrec */

	int nRecCase=0;
	int nTypeFile=0;
	int current_outrec=0;
	int current_inrec=0;
	int current_sortField=0;
    int current_filejoin=0;         /* Join File 1 = F1, 2 = F2  */
    int inrec_overlay=0;
    int outrec_overlay=0;
	int nPosAbsRec=0;
	int nRtc=0;
	int nCountGroupFiles=0;
	char* pszInt;
    int nTmp=0;
    int nSwitchFR=0;
    
    int nDateType=-1;
    int nDateCheck=0;
    int nDateNew=0;
    char szBuf[30];

	extern int nTypeFieldsCmd;
	char szTmp[5];
	int	 nIntTmp;
	int  nTypeFormat;			/* 0= Nothing, 1 = SortFields, 2 = Include/Omit, 3 = SumFields  */
	int  nTypeIncludeOmit;		/* 0= Nothing, 1 = Include, Omit=2                              */
    int  nFieldType = 0;        /* field type used when format is spicified */
	int  nstate_outfil = 0;
    int  nOnly=0;


#line 320 "parser.c"

#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  92
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   526

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  91
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  88
/* YYNRULES -- Number of rules.  */
#define YYNRULES  244
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  548

#define YYUNDEFTOK  2
#define YYMAXUTOK   339


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      86,    87,     2,     2,    85,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    90,     2,
       2,    88,     2,    89,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   227,   227,   228,   230,   231,   232,   233,   234,   235,
     236,   237,   238,   239,   240,   241,   242,   243,   244,   245,
     246,   247,   248,   249,   250,   251,   252,   253,   255,   256,
     257,   262,   262,   279,   279,   296,   312,   323,   332,   341,
     350,   359,   365,   368,   372,   387,   392,   398,   405,   410,
     422,   437,   452,   465,   484,   486,   492,   516,   531,   531,
     538,   546,   546,   555,   565,   565,   592,   593,   597,   601,
     605,   609,   633,   639,   652,   678,   695,   696,   716,   716,
     727,   728,   744,   755,   780,   783,   787,   796,   814,   830,
     844,   856,   868,   883,   898,   916,   933,   957,   973,  1000,
    1018,  1042,  1062,  1071,  1083,  1092,  1116,  1122,  1134,  1136,
    1144,  1216,  1231,  1257,  1302,  1344,  1388,  1432,  1477,  1531,
    1571,  1627,  1647,  1667,  1758,  1849,  1942,  1945,  1948,  1949,
    1970,  1991,  2012,  2034,  2059,  2086,  2097,  2113,  2133,  2177,
    2181,  2189,  2220,  2248,  2263,  2263,  2274,  2274,  2284,  2284,
    2295,  2295,  2305,  2305,  2317,  2317,  2328,  2328,  2338,  2338,
    2349,  2349,  2364,  2364,  2374,  2374,  2388,  2388,  2398,  2398,
    2408,  2408,  2418,  2418,  2428,  2428,  2440,  2440,  2451,  2451,
    2461,  2461,  2472,  2472,  2486,  2486,  2497,  2498,  2501,  2511,
    2528,  2540,  2544,  2550,  2567,  2571,  2577,  2597,  2603,  2623,
    2629,  2631,  2633,  2637,  2643,  2655,  2667,  2683,  2688,  2696,
    2701,  2708,  2717,  2719,  2722,  2726,  2730,  2734,  2738,  2742,
    2746,  2750,  2754,  2761,  2768,  2774,  2781,  2787,  2796,  2796,
    2808,  2814,  2820,  2826,  2832,  2838,  2844,  2851,  2857,  2863,
    2869,  2875,  2881,  2887,  2898
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "\"AND clause\"", "\"COND clause\"",
  "\"ENDREC clause\"", "\"FNAMES clause\"", "\"FORMAT clause\"",
  "\"INCLUDE clause\"", "\"INREC clause\"", "\"NONE clause\"",
  "\"OMIT clause\"", "\"OPTION clause\"", "\"OR clause\"",
  "\"OUTFIL clause\"", "\"OUTREC clause\"", "\"SAVE clause\"",
  "\"SKIP clause\"", "\"STARTREC clause\"", "\"STOPAFT clause\"",
  "\"SUM clause\"", "\"XSUM clause\"", "\"SPLIT clause\"",
  "\"SPLITBY clause\"", "\"VLSCMP clause\"", "\"VLSHRT clause\"",
  "\"Y2PAST clause\"", "\"MODS clause\"", "\"BUILD instruction\"",
  "\"FIELDS instruction\"", "\"OVERLAY instruction\"", "\"GIVE clause\"",
  "\"MERGE clause\"", "\"ORG instruction\"", "\"RECORD instruction\"",
  "\"SORT clause\"", "\"JOINKEYS clause\"", "\"USE clause\"", "\"COPY\"",
  "\"TYPE\"", "\"LENGTH\"", "\"DATE1\"", "\"DATE2\"", "\"DATE3\"",
  "\"DATE4\"", "\"CHANGE\"", "\"NOMATCH\"", "\"SORTED\"", "\"NOSEQCK\"",
  "\"UNPAIRED\"", "\"ONLY\"", "\"JOIN\"", "\"JOINREFORMAT\"", "\"FILL\"",
  "\"FINDREP\"", "\"IN\"", "\"OUT\"", "\"INOUT\"", "\"STARTPOS\"",
  "\"ENDPOS\"", "\"DO\"", "\"MAXLEN\"", "\"OVERRUN\"", "\"SHIFT\"",
  "\"DIGIT\"", "\"DIGITBIG\"", "\"CHARTCOND\"", "\"CHARTYPE\"",
  "\"FILETYPE\"", "\"FORMATTYPE\"", "\"JOINFILE\"", "\"KEY\"",
  "\"KEYTYPE\"", "\"OCCURFILL\"", "\"OPCOND\"", "\"SUBSTRING\"",
  "\"ORDER\"", "\"RECTYPEFIX\"", "\"RECTYPEVAR\"", "\"STRING\"",
  "\"TOKSKIP clause\"", "\"EXROUT clause\"", "\"YESNO clause\"",
  "\"ERRTRUNC clause\"", "\"SIGNDIGITBIG\"", "','", "'('", "')'", "'='",
  "'?'", "':'", "$accept", "beginning", "clause", "useclause", "$@1",
  "giveclause", "$@2", "recordorginstruction", "allkeyfield", "keyfield",
  "fieldtype", "fielddirection", "condition", "fieldvaluecond",
  "fieldvaluerec", "fieldvalueconst", "allsortfield", "sortfield",
  "sortclause", "$@3", "mergeclause", "$@4", "joinkeysclause", "$@5",
  "joinkeysalloptions", "joinkeysoptions", "joinclause", "joinoptions",
  "joinreformatclause", "$@6", "fill_char", "formatclause", "allcondfield",
  "condfieldcond", "datetype", "omitclause", "includeclause",
  "allinoutrec", "inoutrec", "findrep_options_all", "findrep_options",
  "allfieldvaluerec", "inoutfieldvaluerec", "changepair", "changepairdet",
  "changeCmdOpt", "outrecclause", "$@7", "$@8", "$@9", "$@10", "$@11",
  "$@12", "$@13", "$@14", "$@15", "$@16", "$@17", "inrecclause", "$@18",
  "$@19", "$@20", "$@21", "$@22", "$@23", "$@24", "$@25", "$@26",
  "buildclause", "$@27", "allsumfield", "sumfield", "sumclause",
  "tokskipclause", "filesgroup", "fnamesclause", "outfilincludeclause",
  "outfilomitclause", "outfilclause", "startrecclause", "endrecclause",
  "saveclause", "alloption", "option", "optionclause", "$@28",
  "recordoption", "recordclause", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,    44,    40,    41,    61,    63,
      58
};
# endif

#define YYPACT_NINF (-454)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     130,   -37,    -9,    -5,     5,     6,    11,  -454,  -454,     1,
    -454,     8,    22,    92,  -454,    61,    81,   171,   175,   222,
     167,   151,   203,   262,   238,  -454,    24,   306,   130,  -454,
    -454,  -454,  -454,  -454,  -454,    -3,  -454,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,    42,    33,   144,
     -24,   -42,   223,   145,   146,   149,   219,    36,   -42,     0,
     150,   153,   154,   221,  -454,   224,    79,    95,    -2,  -454,
    -454,   -20,    56,   -18,   225,  -454,   226,   228,   233,   230,
     232,  -454,  -454,  -454,   268,  -454,  -454,  -454,  -454,   239,
     234,  -454,  -454,  -454,  -454,   235,   -42,   -42,   184,  -454,
     184,   317,  -454,   236,  -454,   237,  -454,   240,   241,    31,
     -42,   184,   184,   242,   243,  -454,  -454,   244,   247,  -454,
     248,  -454,     0,  -454,   249,  -454,   250,  -454,   251,   252,
      31,    31,  -454,  -454,  -454,  -454,  -454,   303,   261,    -1,
    -454,  -454,   293,   294,  -454,  -454,  -454,   269,    -1,   122,
    -454,  -454,  -454,  -454,   292,   158,   239,   277,    10,   184,
     -42,   -42,    83,    31,  -454,    31,  -454,    31,  -454,  -454,
      31,   256,   255,   257,    99,   265,   258,   267,  -454,  -454,
     264,  -454,   184,   110,   111,   283,   263,   266,  -454,    31,
    -454,    31,  -454,    31,  -454,  -454,    31,   264,   159,    31,
     344,   270,   271,   272,   284,   113,   273,  -454,   289,   274,
     275,   289,   278,  -454,   279,    31,    31,  -454,  -454,   234,
     280,  -454,  -454,   353,   -42,   184,   162,    31,   163,    31,
     168,    31,    31,   264,   302,   -25,   281,   304,   -19,  -454,
     305,  -454,    31,  -454,  -454,  -454,  -454,  -454,   285,   286,
     172,    31,   173,    31,   176,    31,    31,   264,  -454,   177,
     282,   309,   354,   261,    -1,   291,   295,   108,   310,   296,
     290,   297,   -27,    -8,   298,   349,   126,  -454,   181,   182,
     148,   184,  -454,   185,  -454,   186,  -454,   189,   190,   299,
     265,   312,   301,   312,  -454,   307,   308,   311,   264,   314,
     315,  -454,   193,  -454,   194,  -454,   197,   198,  -454,   316,
     313,   377,  -454,  -454,   324,   325,   318,   319,   320,   321,
     322,   326,  -454,   289,   201,     9,   202,    26,  -454,   323,
     327,   338,  -454,  -454,  -454,   328,   329,  -454,  -454,  -454,
    -454,   330,   331,   332,   343,   333,   334,   336,  -454,   337,
     205,   335,  -454,  -454,  -454,  -454,  -454,   137,   339,    -1,
     340,   342,   346,   347,    -1,   310,   341,  -454,    38,  -454,
     345,   351,    45,  -454,   348,   356,  -454,   352,  -454,  -454,
     229,   104,   350,   355,   358,   312,   359,   357,   312,   166,
    -454,  -454,   156,  -454,  -454,   361,  -454,   360,  -454,   364,
     362,   363,   365,  -454,  -454,   -22,   210,   366,  -454,   367,
     211,   369,  -454,   368,   289,  -454,   371,   372,   373,  -454,
    -454,  -454,   374,   375,   330,  -454,   378,   312,  -454,   370,
     376,   379,   380,   381,   382,  -454,   386,   214,   215,   383,
    -454,    -1,    -1,   387,   389,  -454,   388,  -454,   398,  -454,
     385,  -454,   399,  -454,   390,  -454,   391,   114,   401,  -454,
     138,   392,  -454,   393,   166,   402,   410,   411,   412,   396,
     400,   166,   404,  -454,   405,  -454,  -454,  -454,  -454,   403,
    -454,   409,   406,  -454,   407,  -454,  -454,   416,   422,   423,
    -454,   413,  -454,  -454,  -454,  -454,   414,   417,   415,   312,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,   408,   418,
      -1,  -454,  -454,  -454,  -454,  -454,  -454,   424,   425,  -454,
     140,   166,  -454,  -454,  -454,   419,  -454,   421,   428,   426,
    -454,   134,   427,  -454,  -454,  -454,   429,  -454
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,   228,   206,     0,
     211,     0,     0,     0,   202,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   197,     0,     0,     2,    13,
      14,     5,     6,     7,    10,    66,     8,    11,     9,    12,
      15,    19,    18,    22,    20,    30,    21,    23,    27,    25,
      26,    24,    16,    17,    28,    29,     4,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   182,     0,     0,     0,
       0,     0,     0,   160,   164,     0,     0,     0,     0,   203,
      33,     0,     0,     0,     0,    31,    72,     0,     0,     0,
      68,    77,     1,     3,     0,    67,   210,   209,   198,     0,
     201,    45,    83,    46,    82,     0,     0,     0,   104,    84,
     204,     0,   172,     0,   168,     0,   176,     0,   178,     0,
       0,   102,   205,     0,     0,   219,   220,     0,     0,   214,
       0,   229,   212,   150,     0,   146,     0,   154,     0,   156,
       0,     0,   162,   208,   207,    71,    70,   191,     0,    35,
      63,    61,   230,   237,   244,    60,    58,     0,    35,     0,
      73,    78,    81,   184,     0,     0,     0,     0,     0,   105,
       0,     0,     0,     0,   170,     0,   166,     0,   174,   180,
       0,     0,     0,     0,     0,   118,     0,   115,   111,   119,
     183,   108,   103,     0,     0,     0,     0,     0,   213,     0,
     148,     0,   144,     0,   152,   158,     0,   161,     0,     0,
     192,     0,     0,   186,     0,     0,     0,    34,     0,     0,
       0,     0,     0,    32,    76,     0,     0,    69,   200,   199,
       0,    85,    86,    87,     0,   106,     0,     0,     0,     0,
       0,     0,     0,   179,     0,     0,     0,   120,     0,    51,
       0,   116,     0,   216,   215,   218,   217,   221,     0,     0,
       0,     0,     0,     0,     0,     0,     0,   157,   165,     0,
       0,     0,   194,     0,    35,     0,     0,     0,     0,     0,
       0,    54,     0,     0,     0,     0,     0,    74,     0,     0,
       0,   107,   173,     0,   169,     0,   177,     0,     0,     0,
       0,     0,     0,     0,   110,     0,   117,     0,   109,     0,
       0,   151,     0,   147,     0,   155,     0,     0,   163,     0,
     188,   195,   187,    36,     0,     0,     0,     0,     0,     0,
      42,     0,    62,     0,     0,     0,     0,     0,    59,     0,
      76,    80,   185,    48,    46,     0,     0,   171,   167,   175,
     181,     0,   135,     0,     0,   137,     0,     0,   113,     0,
       0,     0,   149,   145,   153,   159,   193,     0,     0,    35,
       0,     0,     0,     0,    35,     0,     0,    55,     0,   231,
       0,     0,     0,   238,     0,     0,    64,     0,    75,    79,
       0,     0,     0,     0,   139,     0,     0,     0,     0,   128,
     114,   112,     0,   223,   222,     0,   190,     0,    39,     0,
       0,     0,     0,    41,    43,     0,     0,     0,   233,     0,
       0,     0,   240,     0,     0,    49,     0,    52,     0,    53,
      93,    92,     0,     0,     0,   136,     0,     0,   138,     0,
       0,     0,     0,     0,     0,   125,   126,     0,     0,     0,
     196,    35,    35,     0,     0,    47,     0,    56,     0,   232,
       0,   235,     0,   239,     0,   242,     0,     0,     0,    50,
       0,     0,   140,     0,   128,     0,     0,     0,     0,     0,
       0,   128,     0,   226,     0,   224,   189,    37,    40,     0,
      44,     0,     0,   236,     0,   243,    65,    95,    97,    99,
     101,    52,    90,    91,    94,    89,     0,     0,     0,     0,
     123,   129,   130,   131,   132,   133,   134,   127,     0,     0,
      35,    57,   234,   241,    96,    98,   100,     0,     0,   141,
       0,   128,   227,   225,    38,     0,   142,     0,     0,     0,
     124,     0,     0,   143,   121,    88,     0,   122
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -454,   395,  -454,  -454,  -454,  -454,  -454,  -158,    49,  -454,
    -287,   -74,    41,   -31,  -244,   -30,  -216,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,   457,  -454,  -454,   -84,  -454,  -454,
     100,   436,   -57,  -454,  -454,  -454,  -454,  -134,  -454,  -453,
    -454,    58,   102,    63,  -454,  -454,  -454,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,
    -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,  -454,
     245,  -454,  -454,  -454,   -85,  -454,  -454,  -454,  -454,  -454,
    -454,  -454,   394,  -454,  -454,  -454,  -454,  -454
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    27,    28,    29,   158,    30,   149,   217,   329,   330,
     104,   457,   346,   430,   189,   431,   280,   281,    31,   221,
      32,   218,    33,   424,    34,    35,    36,    37,    38,   225,
      39,    40,   108,   109,   504,    41,    42,   190,   191,   445,
     446,   353,   356,   393,   394,   539,    43,   263,   201,   261,
     199,   265,   203,   206,   266,   140,   209,   141,    44,   239,
     175,   237,   173,   241,   177,   180,   242,   119,    45,   226,
     212,   213,    46,    47,   100,    48,    49,    50,    51,    52,
      53,    54,   131,   132,    55,    69,   154,    56
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
     223,   302,   160,   345,   110,   284,   207,   208,   147,    60,
     121,   122,     3,   170,   165,    67,    12,   123,   150,   124,
     155,   510,   105,   171,   125,   126,   127,   128,   517,    70,
      71,    72,   214,   215,    63,    64,    65,   334,   129,   236,
     105,   238,   300,   240,   106,   305,   243,   101,   306,   168,
     169,    57,    89,   103,   455,    73,   336,   352,   335,   355,
      66,   301,   106,   192,   107,   260,   151,   262,   156,   264,
     216,    90,   267,   380,    91,   269,   181,   337,   540,    58,
     406,   229,    94,    59,   148,   130,   182,    74,   183,    75,
     384,   288,   289,    61,   381,   184,    76,   231,   185,    68,
     105,   186,   416,   293,   187,   295,    96,   297,   298,   420,
      77,   385,    98,   232,   233,   235,   323,   377,   308,    99,
     188,    78,   106,   417,   120,    79,    97,   312,   456,   314,
     421,   316,   317,   152,   153,     1,     2,     3,     4,     5,
     287,     6,     7,   143,     8,     9,    10,   105,    11,    12,
      13,   352,    14,    15,   355,   497,   498,   499,   500,   145,
      80,    16,    17,   144,    18,    19,    20,    21,   427,   106,
     428,   234,    91,    84,   253,   255,    91,   291,   501,   146,
     428,    22,    23,    24,   247,   326,   327,   170,   429,   248,
     275,   276,   224,   474,   254,   256,   340,   171,   429,   277,
      81,   405,   506,   101,   537,   507,   101,   538,   466,   103,
      25,   408,   103,   101,    82,    26,   413,   101,   102,   103,
     447,   448,   343,   344,   439,   440,   441,   442,   443,   444,
      85,   112,   114,   113,   115,   116,   133,   117,   134,   135,
     137,   136,   138,   166,   252,   228,   268,   252,   252,   292,
     294,    83,    86,   252,   545,   296,   388,   252,   252,   311,
     313,   252,   252,   315,   318,   531,   252,   252,   341,   342,
     252,   252,   347,   348,   252,   252,   349,   350,   252,   252,
     362,   363,   252,   252,   364,   365,   378,   382,   379,   383,
     402,    87,   403,   487,   488,   458,   462,   459,   463,   482,
     484,   483,   485,   343,   425,    88,    92,   118,   111,   139,
     142,   159,   162,   157,   161,    90,   163,   164,    98,   166,
     167,   172,   174,   176,   210,   211,   178,   179,   196,   197,
     193,   194,   195,   219,   220,   200,   202,   204,   205,   222,
     227,   230,   244,   245,   249,   246,   251,   257,   250,   252,
     270,   258,   274,   279,   259,   271,   170,   273,   272,   278,
     282,   283,   534,   285,   286,   290,   299,   303,   304,   307,
     319,   309,   310,   320,   328,   321,   324,   332,   339,   300,
     325,   331,   333,   368,   351,   338,   354,   358,   369,   370,
     376,    24,   357,   360,   361,   366,   359,   392,   367,   397,
     400,   401,    91,   371,   372,   373,   410,   375,   374,   386,
     411,   412,   387,   390,   391,   419,   395,   521,   398,   396,
     423,   399,   404,    93,   414,   409,   415,   407,   451,   432,
     460,   426,   418,   464,   473,   422,   502,   503,   508,   450,
      62,   389,   433,   434,   436,   437,   449,   486,   453,   452,
     454,   489,   469,   435,   461,   465,   467,   468,   475,   470,
     471,   490,   492,   494,   476,   505,   511,   477,   478,   479,
     480,   481,   493,   491,   512,   513,   514,   495,   496,   515,
     524,   509,   516,   518,   519,   455,   525,   526,   535,   536,
     520,   546,    95,   522,   523,   532,   529,   472,   527,   528,
     438,   530,     0,     0,   541,   533,   542,   543,     0,     0,
       0,     0,     0,   544,     0,     0,   547,     0,   322,     0,
       0,     0,     0,     0,     0,     0,   198
};

static const yytype_int16 yycheck[] =
{
     158,   245,    86,   290,    61,   221,   140,   141,    10,     4,
      67,    68,     7,     3,    99,     4,    19,    17,    38,    19,
      38,   474,    64,    13,    24,    25,    26,    27,   481,    28,
      29,    30,    33,    34,    28,    29,    30,    64,    38,   173,
      64,   175,    67,   177,    86,    64,   180,    69,    67,   106,
     107,    88,    28,    75,    76,    54,    64,   301,    85,   303,
      54,    86,    86,   120,    88,   199,    86,   201,    86,   203,
      71,    47,   206,    64,    50,   209,    45,    85,   531,    88,
     367,   166,    85,    88,    86,    85,    55,    86,    57,    88,
      64,   225,   226,    88,    85,    64,    88,    87,    67,    88,
      64,    70,    64,   237,    73,   239,    64,   241,   242,    64,
      88,    85,    79,   170,   171,   172,   274,   333,   252,    86,
      89,    29,    86,    85,    88,    64,    84,   261,   415,   263,
      85,   265,   266,    77,    78,     5,     6,     7,     8,     9,
     224,    11,    12,    64,    14,    15,    16,    64,    18,    19,
      20,   395,    22,    23,   398,    41,    42,    43,    44,    64,
      79,    31,    32,    84,    34,    35,    36,    37,    64,    86,
      66,    88,    50,     6,    64,    64,    50,   234,    64,    84,
      66,    51,    52,    53,    85,    77,    78,     3,    84,    90,
      77,    78,    70,   437,    84,    84,    70,    13,    84,    86,
      29,    64,    64,    69,    64,    67,    69,    67,   424,    75,
      80,   369,    75,    69,    39,    85,   374,    69,    74,    75,
      64,    65,    74,    75,    58,    59,    60,    61,    62,    63,
      79,    86,    86,    88,    88,    86,    86,    88,    88,    86,
      86,    88,    88,    85,    85,    87,    87,    85,    85,    87,
      87,    29,    49,    85,   541,    87,   340,    85,    85,    87,
      87,    85,    85,    87,    87,   509,    85,    85,    87,    87,
      85,    85,    87,    87,    85,    85,    87,    87,    85,    85,
      87,    87,    85,    85,    87,    87,    85,    85,    87,    87,
      85,    29,    87,   451,   452,    85,    85,    87,    87,    85,
      85,    87,    87,    74,    75,    67,     0,    88,    85,    88,
      86,    85,    79,    88,    86,    47,    86,    85,    79,    85,
      85,     4,    86,    86,    21,    64,    86,    86,    81,    81,
      88,    88,    88,    40,    40,    86,    86,    86,    86,    70,
      48,    64,    86,    88,    79,    88,    79,    64,    90,    85,
       6,    88,    68,    64,    88,    85,     3,    85,    87,    86,
      86,    86,   520,    85,    85,    85,    64,    86,    64,    64,
      88,    86,    86,    64,    64,    21,    85,    87,    29,    67,
      85,    85,    85,     6,    85,    87,    85,    79,    64,    64,
      64,    53,    85,    79,    79,    79,    85,    67,    85,    56,
      64,    64,    50,    85,    85,    85,    64,    85,    87,    86,
      64,    64,    85,    85,    85,    64,    85,   491,    85,    87,
      64,    87,    87,    28,   375,    85,    85,    88,    64,    79,
      64,   390,    87,    64,    56,    87,   467,   467,    46,    79,
       4,   341,    87,    85,    85,    88,    85,    64,    85,    87,
      85,    64,    79,   395,    87,    87,    85,    85,    88,    85,
      85,    72,    64,    64,    88,    64,    64,    88,    88,    88,
      88,    85,    87,    85,    64,    64,    64,    87,    87,    83,
      64,    88,    82,    79,    79,    76,    64,    64,    64,    64,
      87,    64,    35,    87,    87,    87,    79,   434,    85,    85,
     398,    86,    -1,    -1,    85,    87,    85,    79,    -1,    -1,
      -1,    -1,    -1,    87,    -1,    -1,    87,    -1,   273,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,   132
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     5,     6,     7,     8,     9,    11,    12,    14,    15,
      16,    18,    19,    20,    22,    23,    31,    32,    34,    35,
      36,    37,    51,    52,    53,    80,    85,    92,    93,    94,
      96,   109,   111,   113,   115,   116,   117,   118,   119,   121,
     122,   126,   127,   137,   149,   159,   163,   164,   166,   167,
     168,   169,   170,   171,   172,   175,   178,    88,    88,    88,
       4,    88,   122,    28,    29,    30,    54,     4,    88,   176,
      28,    29,    30,    54,    86,    88,    88,    88,    29,    64,
      79,    29,    39,    29,     6,    79,    49,    29,    67,    28,
      47,    50,     0,    92,    85,   115,    64,    84,    79,    86,
     165,    69,    74,    75,   101,    64,    86,    88,   123,   124,
     123,    85,    86,    88,    86,    88,    86,    88,    88,   158,
      88,   123,   123,    17,    19,    24,    25,    26,    27,    38,
      85,   173,   174,    86,    88,    86,    88,    86,    88,    88,
     146,   148,    86,    64,    84,    64,    84,    10,    86,    97,
      38,    86,    77,    78,   177,    38,    86,    88,    95,    85,
     118,    86,    79,    86,    85,   165,    85,    85,   123,   123,
       3,    13,     4,   153,    86,   151,    86,   155,    86,    86,
     156,    45,    55,    57,    64,    67,    70,    73,    89,   105,
     128,   129,   123,    88,    88,    88,    81,    81,   173,   141,
      86,   139,    86,   143,    86,    86,   144,   128,   128,   147,
      21,    64,   161,   162,    33,    34,    71,    98,   112,    40,
      40,   110,    70,    98,    70,   120,   160,    48,    87,   165,
      64,    87,   123,   123,    88,   123,   128,   152,   128,   150,
     128,   154,   157,   128,    86,    88,    88,    85,    90,    79,
      90,    79,    85,    64,    84,    64,    84,    64,    88,    88,
     128,   140,   128,   138,   128,   142,   145,   128,    87,   128,
       6,    85,    87,    85,    68,    77,    78,    86,    86,    64,
     107,   108,    86,    86,   107,    85,    85,   118,   128,   128,
      85,   123,    87,   128,    87,   128,    87,   128,   128,    64,
      67,    86,   105,    86,    64,    64,    67,    64,   128,    86,
      86,    87,   128,    87,   128,    87,   128,   128,    87,    88,
      64,    21,   161,    98,    85,    85,    77,    78,    64,    99,
     100,    85,    87,    85,    64,    85,    64,    85,    87,    29,
      70,    87,    87,    74,    75,   101,   103,    87,    87,    87,
      87,    85,   105,   132,    85,   105,   133,    85,    79,    85,
      79,    79,    87,    87,    87,    87,    79,    85,     6,    64,
      64,    85,    85,    85,    87,    85,    64,   107,    85,    87,
      64,    85,    85,    87,    64,    85,    86,    85,   118,   121,
      85,    85,    67,   134,   135,    85,    87,    56,    85,    87,
      64,    64,    85,    87,    87,    64,   101,    88,    98,    85,
      64,    64,    64,    98,    99,    85,    64,    85,    87,    64,
      64,    85,    87,    64,   114,    75,   103,    64,    66,    84,
     104,   106,    79,    87,    85,   132,    85,    88,   133,    58,
      59,    60,    61,    62,    63,   130,   131,    64,    65,    85,
      79,    64,    87,    85,    85,    76,   101,   102,    85,    87,
      64,    87,    85,    87,    64,    87,   107,    85,    85,    79,
      85,    85,   134,    56,   105,    88,    88,    88,    88,    88,
      88,    85,    85,    87,    85,    87,    64,    98,    98,    64,
      72,    85,    64,    87,    64,    87,    87,    41,    42,    43,
      44,    64,   104,   106,   125,    64,    64,    67,    46,    88,
     130,    64,    64,    64,    64,    83,    82,   130,    79,    79,
      87,   102,    87,    87,    64,    64,    64,    85,    85,    79,
      86,   105,    87,    87,    98,    64,    64,    64,    67,   136,
     130,    85,    85,    79,    87,   101,    64,    87
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    91,    92,    92,    93,    93,    93,    93,    93,    93,
      93,    93,    93,    93,    93,    93,    93,    93,    93,    93,
      93,    93,    93,    93,    93,    93,    93,    93,    93,    93,
      93,    95,    94,    97,    96,    98,    98,    98,    98,    98,
      98,    98,    99,    99,   100,   101,   101,   102,   103,   103,
     104,   105,   106,   106,   107,   107,   108,   108,   110,   109,
     109,   112,   111,   111,   114,   113,   115,   115,   116,   116,
     116,   116,   117,   117,   117,   117,   118,   118,   120,   119,
     121,   121,   122,   122,   123,   123,   123,   123,   124,   124,
     124,   124,   124,   124,   124,   125,   125,   125,   125,   125,
     125,   125,   126,   126,   127,   127,   127,   127,   128,   128,
     129,   129,   129,   129,   129,   129,   129,   129,   129,   129,
     129,   129,   129,   129,   129,   129,   130,   130,   131,   131,
     131,   131,   131,   131,   131,   132,   132,   133,   133,   134,
     134,   135,   135,   136,   138,   137,   139,   137,   140,   137,
     141,   137,   142,   137,   143,   137,   144,   137,   145,   137,
     146,   137,   147,   137,   148,   137,   150,   149,   151,   149,
     152,   149,   153,   149,   154,   149,   155,   149,   156,   149,
     157,   149,   158,   149,   160,   159,   161,   161,   162,   162,
     162,   163,   163,   163,   163,   163,   163,   164,   165,   165,
     166,   166,   166,   166,   167,   168,   169,   170,   170,   171,
     171,   172,   173,   173,   174,   174,   174,   174,   174,   174,
     174,   174,   174,   174,   174,   174,   174,   174,   176,   175,
     177,   177,   177,   177,   177,   177,   177,   177,   177,   177,
     177,   177,   177,   177,   178
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     0,     4,     0,     4,     0,     3,     7,     9,     5,
       7,     5,     1,     3,     5,     1,     1,     1,     1,     1,
       2,     2,     1,     1,     1,     3,     5,     7,     0,     6,
       3,     0,     6,     3,     0,    10,     1,     2,     2,     4,
       3,     3,     2,     3,     5,     7,     0,     2,     0,     7,
       0,     3,     3,     3,     1,     3,     3,     3,    13,     9,
       9,     9,     7,     7,     9,     1,     2,     1,     2,     1,
       2,     1,     3,     4,     3,     4,     5,     6,     1,     3,
       3,     1,     5,     4,     5,     1,     2,     3,     1,     1,
       2,    11,    13,     8,    10,     6,     1,     3,     0,     3,
       3,     3,     3,     3,     3,     1,     3,     1,     3,     1,
       3,     5,     6,     2,     0,     7,     0,     6,     0,     7,
       0,     6,     0,     7,     0,     6,     0,     5,     0,     7,
       0,     4,     0,     6,     0,     5,     0,     7,     0,     6,
       0,     7,     0,     6,     0,     7,     0,     6,     0,     5,
       0,     7,     0,     4,     0,     6,     1,     3,     3,     7,
       5,     3,     4,     7,     5,     6,     9,     1,     1,     3,
       5,     3,     1,     2,     3,     3,     1,     3,     3,     3,
       3,     1,     1,     2,     1,     3,     3,     3,     3,     1,
       1,     3,     6,     6,     8,    10,     8,    10,     0,     3,
       1,     5,     7,     6,     9,     7,     8,     1,     5,     7,
       6,     9,     7,     8,     3
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 4:
#line 230 "parser.y"
                       {}
#line 1877 "parser.c"
    break;

  case 5:
#line 231 "parser.y"
                             {}
#line 1883 "parser.c"
    break;

  case 6:
#line 232 "parser.y"
                              {}
#line 1889 "parser.c"
    break;

  case 7:
#line 233 "parser.y"
                         {}
#line 1895 "parser.c"
    break;

  case 8:
#line 234 "parser.y"
                     {}
#line 1901 "parser.c"
    break;

  case 9:
#line 235 "parser.y"
                            {}
#line 1907 "parser.c"
    break;

  case 10:
#line 236 "parser.y"
                            {}
#line 1913 "parser.c"
    break;

  case 11:
#line 237 "parser.y"
                     {}
#line 1919 "parser.c"
    break;

  case 12:
#line 238 "parser.y"
                   {}
#line 1925 "parser.c"
    break;

  case 13:
#line 239 "parser.y"
                    {}
#line 1931 "parser.c"
    break;

  case 14:
#line 240 "parser.y"
                             {}
#line 1937 "parser.c"
    break;

  case 15:
#line 241 "parser.y"
                               {}
#line 1943 "parser.c"
    break;

  case 16:
#line 242 "parser.y"
                                 {}
#line 1949 "parser.c"
    break;

  case 17:
#line 243 "parser.y"
                               {}
#line 1955 "parser.c"
    break;

  case 18:
#line 244 "parser.y"
                                {}
#line 1961 "parser.c"
    break;

  case 19:
#line 245 "parser.y"
                             {}
#line 1967 "parser.c"
    break;

  case 20:
#line 246 "parser.y"
                              {}
#line 1973 "parser.c"
    break;

  case 21:
#line 247 "parser.y"
                            {}
#line 1979 "parser.c"
    break;

  case 22:
#line 248 "parser.y"
                               {}
#line 1985 "parser.c"
    break;

  case 23:
#line 249 "parser.y"
                                {}
#line 1991 "parser.c"
    break;

  case 24:
#line 250 "parser.y"
                               {}
#line 1997 "parser.c"
    break;

  case 25:
#line 251 "parser.y"
                                      {}
#line 2003 "parser.c"
    break;

  case 26:
#line 252 "parser.y"
                                   {}
#line 2009 "parser.c"
    break;

  case 27:
#line 253 "parser.y"
                               {}
#line 2015 "parser.c"
    break;

  case 28:
#line 255 "parser.y"
                             {}
#line 2021 "parser.c"
    break;

  case 29:
#line 256 "parser.y"
                               {}
#line 2027 "parser.c"
    break;

  case 30:
#line 257 "parser.y"
                      {}
#line 2033 "parser.c"
    break;

  case 31:
#line 262 "parser.y"
                     {   
        struct file_t *file=file_constructor((yyvsp[0].string));
        strcpy(szMexToken, "use clause");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 100, ABEND_SKIP);
			YYABORT;
		}
        file_setInputFile(file);
        current_file=file;
        nTypeFile=0;
        free((yyvsp[0].string));
    }
#line 2050 "parser.c"
    break;

  case 32:
#line 273 "parser.y"
                           {
        file_SetInfoForFile(current_file, COB_OPEN_INPUT); /* Input */
        current_file=NULL;
}
#line 2059 "parser.c"
    break;

  case 33:
#line 279 "parser.y"
                 { 
        struct file_t *file=file_constructor((yyvsp[0].string));
        strcpy(szMexToken, " give clause ");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 101, ABEND_SKIP);
			YYABORT;
		}
        file_setOutputFile(file);
        current_file=file;
        nTypeFile=0;
        free((yyvsp[0].string));
}
#line 2076 "parser.c"
    break;

  case 34:
#line 290 "parser.y"
                       {
        file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); /*  Output  */
        current_file=NULL;
}
#line 2085 "parser.c"
    break;

  case 35:
#line 296 "parser.y"
    { 	
        strcpy(szMexToken, " record org instruction "); 
    }
#line 2093 "parser.c"
    break;

  case 36:
#line 312 "parser.y"
                                            {  
        strcpy(szMexToken, " org file type ");
   
        if (current_file!=NULL) {
            nRtc = file_setOrganization(current_file,utils_parseFileOrganization((yyvsp[-1].string)));
            if (nRtc == -1)
                exit(GC_RTC_ERROR);
            nTypeFile = utils_parseFileOrganization((yyvsp[-1].string));
        }
        free((yyvsp[-1].string));
}
#line 2109 "parser.c"
    break;

  case 37:
#line 323 "parser.y"
                                                                     {    
        strcpy(szMexToken, " record type ");
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[-5].string)));
            file_setRecordLength(current_file,(yyvsp[-3].number));
            file_setMaxLength(current_file,(yyvsp[-1].number));
        }
        free((yyvsp[-5].string));
}
#line 2123 "parser.c"
    break;

  case 38:
#line 332 "parser.y"
                                                                             {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[-6].string)));
            file_setRecordLength(current_file,(yyvsp[-4].number));
            file_setMaxLength(current_file,(yyvsp[-2].number));
        }
        free((yyvsp[-6].string));
}
#line 2136 "parser.c"
    break;

  case 39:
#line 341 "parser.y"
                                                           {		
        strcpy(szMexToken, " record type ");
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[-3].string)));
            file_setRecordLength(current_file,(yyvsp[-1].number));
            file_setMaxLength(current_file,(yyvsp[-1].number));
        }
        free((yyvsp[-3].string));
}
#line 2150 "parser.c"
    break;

  case 40:
#line 350 "parser.y"
                                                                   {
        if (current_file!=NULL) {
            file_setFormat(current_file,utils_parseFileFormat((yyvsp[-4].string)));
            file_setRecordLength(current_file,(yyvsp[-2].number));
            file_setMaxLength(current_file,(yyvsp[-2].number));
        }
        free((yyvsp[-4].string));
}
#line 2163 "parser.c"
    break;

  case 41:
#line 359 "parser.y"
                                                       {
}
#line 2170 "parser.c"
    break;

  case 42:
#line 365 "parser.y"
               { 
        strcpy(szMexToken, " key instruction ");
}
#line 2178 "parser.c"
    break;

  case 43:
#line 368 "parser.y"
                               {}
#line 2184 "parser.c"
    break;

  case 44:
#line 372 "parser.y"
                                  {
        if (current_file!=NULL) {
            struct KeyIdx_t *KeyIdx;
            KeyIdx=KeyIdx_constructor((yyvsp[-4].number), (yyvsp[-2].number), utils_parseKeyType((yyvsp[0].string)));
            if (KeyIdx == NULL) {
               utl_abend_terminate(MEMORYALLOC, 102, ABEND_SKIP);
               YYABORT;
            }
            KeyIdx_addDefinition(KeyIdx, current_file);
        }
        free((yyvsp[0].string));
 }
#line 2201 "parser.c"
    break;

  case 45:
#line 387 "parser.y"
                 {
		(yyval.number)=utils_parseFieldType((yyvsp[0].string));
		free((yyvsp[0].string));
}
#line 2210 "parser.c"
    break;

  case 46:
#line 392 "parser.y"
                {
		(yyval.number)=utils_parseFieldType((yyvsp[0].string));
		free((yyvsp[0].string));
}
#line 2219 "parser.c"
    break;

  case 47:
#line 398 "parser.y"
            {
		(yyval.number)=utils_parseSortDirection((yyvsp[0].string));
		free((yyvsp[0].string)); 
}
#line 2228 "parser.c"
    break;

  case 48:
#line 405 "parser.y"
             {
		(yyval.number)=utils_parseCondCondition((yyvsp[0].string));
		free((yyvsp[0].string));
}
#line 2237 "parser.c"
    break;

  case 49:
#line 410 "parser.y"
                {
		(yyval.number)=utils_parseCondCondition((yyvsp[0].string));
		free((yyvsp[0].string));
}
#line 2246 "parser.c"
    break;

  case 50:
#line 422 "parser.y"
                         { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[-1].string), (yyvsp[0].string), TYPE_STRUCT_STD, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
		free((yyvsp[-1].string)); 
		free((yyvsp[0].string)); 
}
#line 2260 "parser.c"
    break;

  case 51:
#line 437 "parser.y"
                        { 
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[-1].string), (yyvsp[0].string), TYPE_STRUCT_STD, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 105, ABEND_SKIP);
			YYABORT;
		}
		free((yyvsp[-1].string)); 
		free((yyvsp[0].string)); 
}
#line 2274 "parser.c"
    break;

  case 52:
#line 452 "parser.y"
            {
		pszInt = (char*) malloc(32);		 
		sprintf(pszInt, "%d", (yyvsp[0].number));
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)"Z", pszInt, TYPE_STRUCT_NEW, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 106, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
}
#line 2289 "parser.c"
    break;

  case 53:
#line 465 "parser.y"
                    {
		char szType[] = "Z";
		pszInt = (char*) malloc(32);		 
		#ifdef	_MSC_VER
			sprintf(pszInt, NUM_FMT_LLD , (yyvsp[0].llnumber));
		#else
			sprintf(pszInt, NUM_FMT_LLD , (yyvsp[0].llnumber));
		#endif
		/*  -->> 20160914 $$=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_STD);    */
		(yyval.fieldValue)=(struct fieldValue_t *) fieldValue_constructor((char*)szType, pszInt, TYPE_STRUCT_NEW, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 107, ABEND_SKIP);
			YYABORT;
		}
		free(pszInt); 
}
#line 2310 "parser.c"
    break;

  case 54:
#line 484 "parser.y"
                {
}
#line 2317 "parser.c"
    break;

  case 55:
#line 486 "parser.y"
                                 {
        
}
#line 2325 "parser.c"
    break;

  case 56:
#line 492 "parser.y"
                                         {
            /* Sort Fields */
        if (current_sortField==1) {
            struct sortField_t *sortField;
            sortField=sortField_constructor((yyvsp[-4].number),(yyvsp[-2].number),0, (yyvsp[0].number));
			if (sortField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 108, ABEND_SKIP);
				YYABORT;
			}
            sortField_addDefinition(sortField);
            nTypeFormat = 1;
        }
            /* JoinKeys */
        if (current_sortField==3) {             
            struct sortField_t *joinField;
            joinField=sortField_constructor((yyvsp[-4].number),(yyvsp[-2].number),0, (yyvsp[0].number));
			if (joinField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 108, ABEND_SKIP);
				YYABORT;
			}
            join_addDefinitionJoin(current_filejoin, joinField);
            nTypeFormat = 1;
        }
}
#line 2354 "parser.c"
    break;

  case 57:
#line 516 "parser.y"
                                                       {
        if (current_sortField==1) {
            struct sortField_t *sortField;
            sortField=sortField_constructor((yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].number));
			if (sortField == NULL) {
                utl_abend_terminate(MEMORYALLOC, 109, ABEND_SKIP);
				YYABORT;
			}
            sortField_addDefinition(sortField);
            /*  -->> nTypeFormat = 1; // Format external token  */
			}
}
#line 2371 "parser.c"
    break;

  case 58:
#line 531 "parser.y"
                      {
        current_sortField=1;
        }
#line 2379 "parser.c"
    break;

  case 59:
#line 533 "parser.y"
                           {
        current_sortField=0;
        job_SetTypeOP('S');		/* for Sort */
        strcpy(szMexToken, " sort clause ");
}
#line 2389 "parser.c"
    break;

  case 60:
#line 538 "parser.y"
                       {
        job_SetTypeOP('C');		/* for Merge    */
        job_SetFieldCopy(1);
        strcpy(szMexToken, " sort clause ");

}
#line 2400 "parser.c"
    break;

  case 61:
#line 546 "parser.y"
                       {
        current_sortField=1;
        strcpy(szMexToken, " merge clause ");
        }
#line 2409 "parser.c"
    break;

  case 62:
#line 549 "parser.y"
                           {
        current_sortField=0;
        /* typeOP = 'M'; // for Merge   */
        job_SetTypeOP('M');
        strcpy(szMexToken, " merge clause ");
}
#line 2420 "parser.c"
    break;

  case 63:
#line 555 "parser.y"
                        {
        job_SetTypeOP('C');
        job_SetFieldCopy(1);
        strcpy(szMexToken, " merge clause ");
}
#line 2430 "parser.c"
    break;

  case 64:
#line 565 "parser.y"
                                                  {
        job_SetTypeOP('J');		/* for Join */
        current_sortField=3;            /* Sort field / Join field for JOIN STATEMENT */
        if (globalJob->join == NULL) {
            struct join_t* pJoin = join_constructor();
            if (pJoin == NULL) {
                utl_abend_terminate(MEMORYALLOC, 509, ABEND_SKIP);
                YYABORT;
            }
            current_join = pJoin;
            join_SetReferenceJob(current_join);     /* Save reference join into job */
        }
        if (memcmp((yyvsp[-3].string),(char*) "F1",2)==0) {
            current_filejoin = 1;
        }
        if (memcmp((yyvsp[-3].string),(char*) "F2",2)==0) {
            current_filejoin = 2;
        }
        }
#line 2454 "parser.c"
    break;

  case 65:
#line 583 "parser.y"
                            {
        current_sortField=0;
        strcpy(szMexToken, " joinkeys clause ");        
        free((yyvsp[-6].string));  /* Verify */
}
#line 2464 "parser.c"
    break;

  case 66:
#line 592 "parser.y"
                      {}
#line 2470 "parser.c"
    break;

  case 67:
#line 593 "parser.y"
                                          {}
#line 2476 "parser.c"
    break;

  case 68:
#line 597 "parser.y"
                  {
		strcpy(szMexToken, " join option sorted  ");
        join_IsSorted(current_filejoin, current_join);
}
#line 2485 "parser.c"
    break;

  case 69:
#line 601 "parser.y"
                             {
		strcpy(szMexToken, " join option noseqck  ");
        join_noSeqCk(current_filejoin, current_join);
}
#line 2494 "parser.c"
    break;

  case 70:
#line 605 "parser.y"
                               {
		strcpy(szMexToken, " join option stop after 1");
        join_stopAfter(current_filejoin, current_join, (yyvsp[0].llnumber));
}
#line 2503 "parser.c"
    break;

  case 71:
#line 609 "parser.y"
                        {
		strcpy(szMexToken, " join option stop after 2");
        join_stopAfter(current_filejoin, current_join, (yyvsp[0].number));
}
#line 2512 "parser.c"
    break;

  case 72:
#line 633 "parser.y"
                      {
        strcpy(szMexToken, " join unpaired clause ");
        join_setUnpaired(1, 'U');
        join_setUnpaired(2, 'U');
        nOnly=0;
}
#line 2523 "parser.c"
    break;

  case 73:
#line 639 "parser.y"
                                 {
        strcpy(szMexToken, " join unpaired clause ");
        if (nOnly  == 0) {
            join_setUnpaired(1, 'U');
            join_setUnpaired(2, 'U');
        }
        if (nOnly  == 1) {
            join_setUnpaired(1, 'O');
            join_setUnpaired(2, 'O');
        }
        nOnly=0;
}
#line 2540 "parser.c"
    break;

  case 74:
#line 652 "parser.y"
                                              {
        strcpy(szMexToken, " join unpaired clause ");
        if (nOnly  == 0) {
            if (memcmp((yyvsp[-1].string),(char*) "F1",2)==0) {
                join_setUnpaired(1, 'U');
                join_setUnpaired(2, 'I');
            }
            if (memcmp((yyvsp[-1].string),(char*) "F2",2)==0) {
                join_setUnpaired(1, 'I');
                join_setUnpaired(2, 'U');
            }
        }
        if (nOnly  == 1) {
            if (memcmp((yyvsp[-1].string),(char*) "F1",2)==0) {
                join_setUnpaired(1, 'O');
                join_setUnpaired(2, 'S');
            }
            if (memcmp((yyvsp[-1].string),(char*) "F2",2)==0) {
                join_setUnpaired(1, 'S');
                join_setUnpaired(2, 'O');
            }
        }
        nOnly=0;
        free((yyvsp[-1].string)); 
}
#line 2570 "parser.c"
    break;

  case 75:
#line 678 "parser.y"
                                                           {          
        current_sortField=0;                                          
        strcpy(szMexToken, " sort clause ");                          
        if (nOnly  == 0) {                                            
            join_setUnpaired(1, 'U');                             
            join_setUnpaired(2, 'U');                             
        }
        if (nOnly  == 1) {
            join_setUnpaired(1, 'O');
            join_setUnpaired(2, 'O');
        }
        nOnly=0;
        free((yyvsp[-3].string)); 
        free((yyvsp[-1].string)); 
}
#line 2590 "parser.c"
    break;

  case 77:
#line 696 "parser.y"
                  {
        /* utils_SetOptionSort("ONLY", NULL, 0); */
		strcpy(szMexToken, " joinoptions ONLY clause ");
        nOnly=1;
}
#line 2600 "parser.c"
    break;

  case 78:
#line 716 "parser.y"
                             {
		strcpy(szMexToken, " joinreformat clause ");
        /*  verify if mandatory current_outrec=1;  */
        nRecCase=JOIN_CASE;
		nPosAbsRec = 0;
}
#line 2611 "parser.c"
    break;

  case 79:
#line 721 "parser.y"
                            {
        current_outrec=0;
        nRecCase=0;
}
#line 2620 "parser.c"
    break;

  case 81:
#line 728 "parser.y"
                              {
        current_outrec=0;
        nRecCase=0;
        strcpy(szMexToken, " join fill clause ");
        /* fill character * */
        join_fillbuff(current_filejoin, current_join, (yyvsp[-1].string), (yyvsp[0].string));
        free((yyvsp[-1].string));
        free((yyvsp[0].string));
}
#line 2634 "parser.c"
    break;

  case 82:
#line 744 "parser.y"
                           {
		strcpy(szMexToken, " format clause ");
        nFieldType = (yyvsp[0].number);    /* save field type */
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[0].number));
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, (yyvsp[0].number));
		if (nTypeFormat == 3)	/* for SumFields    */
			condField_setFormatFieldsTypeAll(nTypeFormat, (yyvsp[0].number));
    }
#line 2649 "parser.c"
    break;

  case 83:
#line 755 "parser.y"
                         {
		strcpy(szMexToken, " format clause substring ");
		if (nTypeFormat == 1)
			condField_setFormatFieldsTypeAll(nTypeFormat, FIELD_TYPE_SUBSTRING);
		if (nTypeFormat == 2)
			condField_setCondFieldsTypeAll(nTypeIncludeOmit, FIELD_TYPE_SUBSTRING);
		if (nTypeFormat == 3)	
			condField_setFormatFieldsTypeAll(nTypeFormat, FIELD_TYPE_SUBSTRING);
    }
#line 2663 "parser.c"
    break;

  case 84:
#line 780 "parser.y"
                  {
		(yyval.condField)=(yyvsp[0].condField);
}
#line 2671 "parser.c"
    break;

  case 85:
#line 783 "parser.y"
                               {
		(yyval.condField)=(yyvsp[-1].condField);
		strcpy(szMexToken, " condition field 01 ");
}
#line 2680 "parser.c"
    break;

  case 86:
#line 787 "parser.y"
                                    {
		condField=condField_constructor_operation(COND_OPERATION_AND, (yyvsp[-2].condField), (yyvsp[0].condField));
		(yyval.condField)=condField;
		strcpy(szMexToken, " condition field 02 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 110, ABEND_SKIP);
			YYABORT;
		}
}
#line 2694 "parser.c"
    break;

  case 87:
#line 796 "parser.y"
                                   {
		condField=condField_constructor_operation(COND_OPERATION_OR, (yyvsp[-2].condField), (yyvsp[0].condField));
		(yyval.condField)=condField;
		strcpy(szMexToken, " condition field 03 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 111, ABEND_SKIP);
			YYABORT;
		}
}
#line 2708 "parser.c"
    break;

  case 88:
#line 814 "parser.y"
                                                                                    {
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield((yyvsp[-12].number),(yyvsp[-10].number),(yyvsp[-8].number),(yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].number));
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 04 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}
#line 2723 "parser.c"
    break;

  case 89:
#line 830 "parser.y"
                                                          {
        nTypeFormat = 2; /* Format external token   */
        condField=condField_constructor_conditionfield((yyvsp[-8].number),(yyvsp[-6].number),0,(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].number),0);
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 05 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 112, ABEND_SKIP);
			YYABORT;
		}
}
#line 2738 "parser.c"
    break;

  case 90:
#line 844 "parser.y"
                                                                      {    
		(yyval.condField)=condField_constructor_condition((yyvsp[-8].number),(yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].fieldValue));
		strcpy(szMexToken, " condition field 06 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 113, ABEND_SKIP);
			YYABORT;
		} 
}
#line 2751 "parser.c"
    break;

  case 91:
#line 856 "parser.y"
                                                                      {
        (yyval.condField)=condField_constructor_condition((yyvsp[-8].number),(yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(yyvsp[0].fieldValue));
        strcpy(szMexToken, " condition field 07 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 114, ABEND_SKIP);
			YYABORT;
		}
}
#line 2764 "parser.c"
    break;

  case 92:
#line 868 "parser.y"
                                                         {    
        /* condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7); */
        condField=condField_constructor_condition((yyvsp[-6].number),(yyvsp[-4].number),nFieldType,(yyvsp[-2].number),(struct fieldValue_t *)(yyvsp[0].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 08 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 115, ABEND_SKIP);
			YYABORT;
		}
}
#line 2780 "parser.c"
    break;

  case 93:
#line 883 "parser.y"
                                                        {    
        /* condField=condField_constructor_condition($1,$3,0,$5,(struct fieldValue_t *)$7); */
        condField=condField_constructor_condition((yyvsp[-6].number),(yyvsp[-4].number),nFieldType,(yyvsp[-2].number),(struct fieldValue_t *)(yyvsp[0].fieldValue)); 
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 09 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 116, ABEND_SKIP);
			YYABORT;
		}
}
#line 2796 "parser.c"
    break;

  case 94:
#line 898 "parser.y"
                                                                {    
        condField=condField_constructor_condition4Date((yyvsp[-8].number),(yyvsp[-6].number),(yyvsp[-4].number),(yyvsp[-2].number),(struct fieldValue_t *)(yyvsp[0].fieldValue));
        nTypeFormat = 2; /* Format external token   */
        (yyval.condField)=condField;
        strcpy(szMexToken, " condition field 10 ");
		if ((yyval.condField) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 141, ABEND_SKIP);
			YYABORT;
		}
}
#line 2811 "parser.c"
    break;

  case 95:
#line 916 "parser.y"
              { 
		nDateType = 1;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        memset(szBuf, 0x00, 30);
        /* current date into string */
        sprintf(szBuf, "%d", nDateCheck);   
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 142, ABEND_SKIP);
			YYABORT;
		}
}
#line 2831 "parser.c"
    break;

  case 96:
#line 933 "parser.y"
                    { 
		nDateType = 1;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* check range */
        if ((yyvsp[0].number) > 366) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub days to date */
        gcDateAddDays(nDateCheck, &nDateNew, (yyvsp[0].number));
        nDateCheck = nDateNew;

        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 142, ABEND_SKIP);
			YYABORT;
		}
}
#line 2859 "parser.c"
    break;

  case 97:
#line 957 "parser.y"
              {             /* Problem ++ to define datetype */
		nDateType = 2;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 100 + (tm.tm_mon + 1);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 143, ABEND_SKIP);
			YYABORT;
		}
}
#line 2878 "parser.c"
    break;

  case 98:
#line 973 "parser.y"
                   {             /* Problem ++ to define datetype */
		nDateType = 2;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 100 + (tm.tm_mon + 1);
        /* check range */
        if ((yyvsp[0].number) > 12) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub months to date */
        /* from YYYYMM  to YYYYMMDD */
        nDateCheck = nDateCheck * 100 + 1 ;
        /* add Month to date*/
        gcDateAddMonths(nDateCheck, &nDateNew, (yyvsp[0].number));
        /* from YYYYMMDD  to YYYYMM */
        nDateCheck = (nDateNew / 100);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 143, ABEND_SKIP);
			YYABORT;
		}
}
#line 2909 "parser.c"
    break;

  case 99:
#line 1000 "parser.y"
              { 
		nDateType = 3;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* Convert date from YYMMAA  to YYDDD */
        gcDate2Ord(nDateCheck, &nDateNew);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateNew);   /* current date into string with format yyyyddd */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 144, ABEND_SKIP);
			YYABORT;
		}
}
#line 2930 "parser.c"
    break;

  case 100:
#line 1018 "parser.y"
                   { 
		nDateType = 3;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Date */
        nDateCheck = (tm.tm_year + 1900) * 10000 + (tm.tm_mon + 1) * 100 + tm.tm_mday;
        /* Convert date from YYMMAA  to YYDDD */
        /* check range */
        if ((yyvsp[0].number) > 366) {
            utl_abend_terminate(0, 142, ABEND_SKIP);
			YYABORT;
        }
        /* Add/Sub days to date */
        gcDateAddDays(nDateCheck, &nDateNew, (yyvsp[0].number));
        gcDate2Ord(nDateNew, &nDateCheck);
        memset(szBuf, 0x00, 30);
        sprintf(szBuf, "%d", nDateCheck);   /* current date into string with format yyyyddd */
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 144, ABEND_SKIP);
			YYABORT;
		}
}
#line 2958 "parser.c"
    break;

  case 101:
#line 1042 "parser.y"
              { 
		nDateType = 4;
        time_t t = time(NULL);
        struct tm tm = *localtime(&t);
        /* Current Datetime */
        memset(szBuf, 0x00, 30);
        /* Problem with timestamp force to Y2T8 8 bytes  CCYYMMAA without time */
        /* TODO timestamp */
        /* sprintf(szBuf, "%0.4d-%0.2d-%0.2d-%0.2d.%0.2d.%0.2d", tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec);  */ /* current datetime into string */
        /* prepare date like CCYYMMDD */
        sprintf(szBuf, "%04d%02d%02d", tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday);  
        (yyval.fieldValue)=fieldValue_constructor( "Y", szBuf, TYPE_STRUCT_STD, FIELD_TYPE_NUMERIC_Y2T);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 145, ABEND_SKIP);
			YYABORT;
		}
}
#line 2980 "parser.c"
    break;

  case 102:
#line 1062 "parser.y"
                              {
        if (nstate_outfil==1)
            condField_addOmitOutfil(current_outfil, (yyvsp[0].condField));
        else 
            condField_addOmit((yyvsp[0].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
#line 2993 "parser.c"
    break;

  case 103:
#line 1071 "parser.y"
                                  {
        if (nstate_outfil==1)
            condField_addOmitOutfil(current_outfil, (yyvsp[0].condField));
        else 
            condField_addOmit((yyvsp[0].condField));
        nTypeIncludeOmit = 2;
        strcpy(szMexToken, " omit clause ");
}
#line 3006 "parser.c"
    break;

  case 104:
#line 1083 "parser.y"
                                 {
        if (nstate_outfil==1)
            condField_addIncludeOutfil(current_outfil, (yyvsp[0].condField));
        else 
            condField_addInclude((yyvsp[0].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
#line 3019 "parser.c"
    break;

  case 105:
#line 1092 "parser.y"
                                     {
        if (nstate_outfil==1)
            condField_addIncludeOutfil(current_outfil, (yyvsp[0].condField));
        else 
            condField_addInclude((yyvsp[0].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
#line 3032 "parser.c"
    break;

  case 106:
#line 1116 "parser.y"
                                                  {
        condField_addInclude((yyvsp[0].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
#line 3042 "parser.c"
    break;

  case 107:
#line 1122 "parser.y"
                                                      {
        condField_addInclude((yyvsp[0].condField));
        nTypeIncludeOmit = 1;
        strcpy(szMexToken, " include clause ");
}
#line 3052 "parser.c"
    break;

  case 108:
#line 1134 "parser.y"
             {	
}
#line 3059 "parser.c"
    break;

  case 109:
#line 1136 "parser.y"
                                              {	}
#line 3065 "parser.c"
    break;

  case 110:
#line 1144 "parser.y"
                      {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range((yyvsp[-2].number),(yyvsp[0].number));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 117, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
                pntChange = 2; 
            }
            else
            {
                /* struct outrec_t * */
                outrec=outrec_constructor_range((yyvsp[-2].number),(yyvsp[0].number));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 118, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
                pntChange = 2; 
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                    /* struct inrec_t * */
                    inrec=inrec_constructor_range((yyvsp[-2].number),(yyvsp[0].number));
                    if (inrec == NULL) {
                        utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                        YYABORT;
                    }
                    nPosAbsRec += inrec->range.length;
                    inrec->nIsOverlay=inrec_overlay;
                    inrec_addDefinition(inrec);
                    /* save pointer CHANGE option */
                    pntChange = 1; 
            }
            break;
        case JOIN_CASE :
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            inrec=inrec_constructor_range_join(current_filejoin, (yyvsp[-2].number),(yyvsp[0].number));
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }
            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
            break;
        default:
            break;
        }
}
#line 3141 "parser.c"
    break;

  case 111:
#line 1216 "parser.y"
           {
        if (nRecCase == 3)
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            inrec=inrec_constructor_range_join(current_filejoin, -99,1);       /* Fix value */
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }
            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
}
#line 3161 "parser.c"
    break;

  case 112:
#line 1231 "parser.y"
                                   {
            strcpy(szMexToken, " join reformat clause ");
            /* struct reformat_t * */
            if (memcmp((yyvsp[-4].string),(char*) "F1",2)==0) {
                current_filejoin = 1;
            }
            if (memcmp((yyvsp[-4].string),(char*) "F2",2)==0) {
                current_filejoin = 2;
            }
            inrec=inrec_constructor_range_join(current_filejoin, (yyvsp[-2].number),(yyvsp[0].number));
            if (inrec == NULL) {
                utl_abend_terminate(MEMORYALLOC, 119, ABEND_SKIP);
                YYABORT;
            }

            nPosAbsRec += inrec->range.length;
            /* inrec->nIsOverlay=inrec_overlay; */
            join_reformat_addDefinition(inrec);
            /* save pointer CHANGE option */
            pntChange = 1; 
            free((yyvsp[-4].string));
}
#line 3188 "parser.c"
    break;

  case 113:
#line 1257 "parser.y"
                                {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_possubstnchar((yyvsp[-3].number), (yyvsp[-1].string), (yyvsp[0].string));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 124, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_possubstnchar((yyvsp[-3].number), (yyvsp[-1].string), (yyvsp[0].string));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 125, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
        free((yyvsp[-1].string)); /* s.m. 202015    */
		free((yyvsp[0].string)); 
}
#line 3233 "parser.c"
    break;

  case 114:
#line 1302 "parser.y"
                                {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range_position((yyvsp[-4].number), (yyvsp[-2].number), (yyvsp[0].number));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 120, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec = outrec->range_position.posAbsRec + outrec->range_position.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_range_position((yyvsp[-4].number), (yyvsp[-2].number), (yyvsp[0].number));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 121, ABEND_SKIP);
                    YYABORT;
                }
                nPosAbsRec = inrec->range_position.posAbsRec + inrec->range_position.length;
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
            break;
       }
}
#line 3274 "parser.c"
    break;

  case 115:
#line 1344 "parser.y"
                {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_subst((yyvsp[0].string));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 122, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_subst((yyvsp[0].string));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 123, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
            break;
        default:
            break;
        }
		free((yyvsp[0].string));
}
#line 3318 "parser.c"
    break;

  case 116:
#line 1388 "parser.y"
                       {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_substnchar((yyvsp[-1].string),(yyvsp[0].string));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 124, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_substnchar((yyvsp[-1].string),(yyvsp[0].string));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 125, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
		free((yyvsp[-1].string)); 
		free((yyvsp[0].string)); 
}
#line 3363 "parser.c"
    break;

  case 117:
#line 1432 "parser.y"
                         {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_padding((yyvsp[-2].number), (yyvsp[0].string), nPosAbsRec);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 126, ABEND_SKIP);
                    YYABORT;
                }
                if ((yyvsp[-2].number) > nPosAbsRec) 
                    nPosAbsRec = (yyvsp[-2].number);
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_padding((yyvsp[-2].number), (yyvsp[0].string), nPosAbsRec);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 127, ABEND_SKIP);
                    YYABORT;
                }
                if ((yyvsp[-2].number) > nPosAbsRec) 
                    nPosAbsRec = (yyvsp[-2].number);		/* - inrec->change_position.fieldValue->generated_length;   */
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
           break;
        default:
            break;
        }
        free((yyvsp[0].string)); 
}
#line 3409 "parser.c"
    break;

  case 118:
#line 1477 "parser.y"
               {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
       /*         struct outrec_t *outrec=outrec_constructor_subst($1); */
                char szType01[3];
                memset(szType01, 0x00, 3);
                szType01[0]='1';
                strcat(szType01, (yyvsp[0].string));
                /* struct outrec_t * */
                outrec=outrec_constructor_subst(szType01);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 128, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
        /*                inrec=inrec_constructor_subst($1);    */
                char szType01[3];
                memset(szType01, 0x00, 3);
                szType01[0]='1';
                strcat(szType01, (yyvsp[0].string));
                inrec=inrec_constructor_subst(szType01);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 129, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
           break;
        default:
            break;
        }
        free((yyvsp[0].string)); /* s.m. 202105    */
}
#line 3463 "parser.c"
    break;

  case 119:
#line 1531 "parser.y"
                    {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * outrec; */
                outrec=outrec_constructor_change((yyvsp[0].fieldValue));
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 130, ABEND_SKIP);
                    YYABORT;
                }
                nPosAbsRec += fieldValue_getGeneratedLength(outrec->change.fieldValue);
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_change((yyvsp[0].fieldValue));
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 131, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
                nPosAbsRec += fieldValue_getGeneratedLength(inrec->change.fieldValue);
            }
            break;
        default:
            break;
        }
	}
#line 3506 "parser.c"
    break;

  case 120:
#line 1571 "parser.y"
                {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_range((yyvsp[-1].number),-1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            else
            {
                /* struct outrec_t * */ 
                outrec=outrec_constructor_range((yyvsp[-1].number),-1);
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_range((yyvsp[-1].number),-1);
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 134, ABEND_SKIP);
                    YYABORT;
                }
                inrec->nIsOverlay=inrec_overlay;
                inrec_addDefinition(inrec);
            }
            break;
        default:
            break;
        }
}
#line 3563 "parser.c"
    break;

  case 121:
#line 1627 "parser.y"
                                                                            { 
        /* define struct for change field */
        
        struct change_t* chg = change_constructor((yyvsp[-8].number));
        change_setNoMatch(chg, (yyvsp[-1].fieldValue));  
        change_setpairs(chg, (yyvsp[-6].changefield));
        /*    int    pntChange = 0 - 1 = Inrec , 2 = Inrec */
         if (pntChange == 1) {       /* InRec */
            inrec_SetChangeCmdOpt(inrec, chg);  /* setting INREC_TYPE_CHANGE_CMDOPT; */
         } else 
             if (pntChange == 2) {       /* OutRec */
                outrec_SetChangeCmdOpt(outrec, chg);  /* setting OUTREC_TYPE_CHANGE_CMDOPT; */
             } else {
                 utl_abend_terminate(100, 234, ABEND_SKIP);
                 YYABORT;
         }
         /* adjust position */
         nPosAbsRec += (yyvsp[-8].number);       /* len output change */
}
#line 3587 "parser.c"
    break;

  case 122:
#line 1647 "parser.y"
                                                                               { 
        /* define struct for change field */       
        struct change_t* chg = change_constructor((yyvsp[-10].number));
        change_setNoMatchPosLen(chg, (yyvsp[-3].number), (yyvsp[-1].number));  
        change_setpairs(chg, (yyvsp[-8].changefield));
        /*    int    pntChange = 0 - 1 = Inrec , 2 = Inrec */
         if (pntChange == 1) {       /* InRec */
            inrec_SetChangeCmdOpt(inrec, chg);  /* setting INREC_TYPE_CHANGE_CMDOPT; */
         } else 
             if (pntChange == 2) {       /* OutRec */
                outrec_SetChangeCmdOpt(outrec, chg);  /* setting OUTREC_TYPE_CHANGE_CMDOPT; */
             } else {
                 utl_abend_terminate(100, 234, ABEND_SKIP);
                 YYABORT;
         }
         /* adjust position */
         nPosAbsRec += (yyvsp[-10].number);       /* len output change */
}
#line 3610 "parser.c"
    break;

  case 123:
#line 1667 "parser.y"
                                                                              {
          switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += 0;   /*  outrec->range.length; */
                outrec_SetFindRepCmdOpt(outrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }                
                else
                    findrep_setType(findrep, FINDREP_TYPE_INOUT);
                findrep_field = findrepfield_constructor((yyvsp[-5].fieldValue), (yyvsp[-1].fieldValue));
                findrep_setpairs(findrep, findrep_field);
                outrec_set_findrep(outrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += 0;   /*  inrec->range.length; */
                inrec_SetFindRepCmdOpt(inrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }                
                else
                    findrep_setType(findrep, FINDREP_TYPE_INOUT);
                findrep_field = findrepfield_constructor((yyvsp[-5].fieldValue), (yyvsp[-1].fieldValue));
                findrep_setpairs(findrep, findrep_field);
                inrec_set_findrep(inrec, findrep);
            }
            else
            {
                /* struct inrec_t * */ 
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += inrec->range.length;
            }
            break;
        default:
            break;
     }  
}
#line 3706 "parser.c"
    break;

  case 124:
#line 1758 "parser.y"
                                                                                         {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += 0;   /*  outrec->range.length; */
                outrec_SetFindRepCmdOpt(outrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor(FINDREP_TYPE_ININOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                    findrep_setType(findrep, FINDREP_TYPE_ININOUT);
                findrepfield_setOutForAll(findrep_field, (yyvsp[-1].fieldValue));
                findrep_setpairs(findrep, findrep_field);
                outrec_set_findrep(outrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += 0;   /*  outrec->range.length; */
                inrec_SetFindRepCmdOpt(inrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor(FINDREP_TYPE_ININOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                    findrep_setType(findrep, FINDREP_TYPE_ININOUT);
                findrepfield_setOutForAll(findrep_field, (yyvsp[-1].fieldValue));
                findrep_setpairs(findrep, findrep_field);
                inrec_set_findrep(inrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += inrec->range.length;
            }
            break;
        default:
            break;
     }  
    }
#line 3802 "parser.c"
    break;

  case 125:
#line 1849 "parser.y"
                                                                {
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP ");
            if (current_outrec==1) {
                /* struct outrec_t * */
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += 0;   /*  outrec->range.length; */
                outrec_SetFindRepCmdOpt(outrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor(FINDREP_TYPE_ININOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                    findrep_setType(findrep, FINDREP_TYPE_ININOUT);
                /* //-->>findrepfield_setOutForAll(findrep_field, $9); */
                findrep_setpairs(findrep, findrep_field);
                outrec_set_findrep(outrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                outrec=outrec_constructor_findrep( );
                if (outrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                if (nstate_outfil==1) {
                    outfil_addoutfilrec(current_outfil, outrec);
                } else {
                    outrec->nIsOverlay=outrec_overlay;
                    outrec_addDefinition(outrec);
                }
                nPosAbsRec += outrec->range.length;
            }
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP ");
            if (current_inrec==1) {
                /* struct inrec_t * */
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += 0;   /*  outrec->range.length; */
                inrec_SetFindRepCmdOpt(inrec);  
               /* inserire la costruzione di findrep */
                if (findrep == NULL) {
                    findrep = findrep_constructor(FINDREP_TYPE_ININOUT);
                    if (findrep == NULL){
                        utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                        YYABORT;
                    }
                }
                else
                    findrep_setType(findrep, FINDREP_TYPE_ININOUT);
                /* //-->>findrepfield_setOutForAll(findrep_field, $9); */
                findrep_setpairs(findrep, findrep_field);
                inrec_set_findrep(inrec, findrep);
            }
            else
            {
                /* struct outrec_t * */ 
                inrec=inrec_constructor_findrep( );
                if (inrec == NULL) {
                    utl_abend_terminate(MEMORYALLOC, 133, ABEND_SKIP);
                    YYABORT;
                }
                inrec_addDefinition(inrec);
                nPosAbsRec += inrec->range.length;
            }
            break;
        default:
            break;
     }  
    }
#line 3898 "parser.c"
    break;

  case 126:
#line 1942 "parser.y"
                      { 
        strcpy(szMexToken, " findrep_options instruction ");
}
#line 3906 "parser.c"
    break;

  case 127:
#line 1945 "parser.y"
                                              {}
#line 3912 "parser.c"
    break;

  case 129:
#line 1949 "parser.y"
                         {
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP STARTPOS ");
            findrep_setStartPos(findrep, (yyvsp[0].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP STARTPOS ");
            findrep_setStartPos(findrep, (yyvsp[0].number));            
            break;
        default:
            break;
        }
    }
#line 3938 "parser.c"
    break;

  case 130:
#line 1970 "parser.y"
                       {
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
              switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP ENDPOS ");
            findrep_setEndPos(findrep, (yyvsp[0].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP ENDPOS ");
            findrep_setEndPos(findrep, (yyvsp[0].number));            
            break;
        default:
            break;
        }
    }
#line 3964 "parser.c"
    break;

  case 131:
#line 1991 "parser.y"
                   {
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
              switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP DO ");
            findrep_setDo(findrep, (yyvsp[0].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP DO ");
            findrep_setDo(findrep, (yyvsp[0].number));            
            break;
        default:
            break;
        }
    }
#line 3990 "parser.c"
    break;

  case 132:
#line 2012 "parser.y"
                       {
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP MAXLEN ");
            findrep_setMaxLen(findrep, (yyvsp[0].number));
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP MAXLEN ");
            findrep_setMaxLen(findrep, (yyvsp[0].number));            
            break;
        default:
            break;
        }
    }
#line 4016 "parser.c"
    break;

  case 133:
#line 2034 "parser.y"
                           {
        nTmp = 1;
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        if (strcasecmp((yyvsp[0].string), "TRUNC") == 0)
            nTmp = 2;
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP OVERRUN ");
            findrep_setOverRun(findrep, nTmp);
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP OVERRUN ");
            findrep_setOverRun(findrep, nTmp);
            break;
        default:
            break;
        }
        free((yyvsp[0].string));
    }
#line 4046 "parser.c"
    break;

  case 134:
#line 2059 "parser.y"
                      {
        nTmp = 1;
        if (findrep == NULL) {
             findrep = findrep_constructor (FINDREP_TYPE_INOUT);
                if (findrep == NULL){
                    utl_abend_terminate(MEMORYALLOC, 132, ABEND_SKIP);
                    YYABORT;
                }
        }
        if (strcasecmp((yyvsp[0].string), "NO") == 0)
            nTmp = 2;    
        switch(nRecCase) {
        case OUTREC_CASE :
            strcpy(szMexToken, " outrec clause FINDREP SHIFT ");
            findrep_setShift(findrep, nTmp);
            break;
        case INREC_CASE :
            strcpy(szMexToken, " inrec clause FINDREP SHIFT ");
            findrep_setShift(findrep, nTmp);
            break;
        default:
            break;
        }
        free((yyvsp[0].string));
    }
#line 4076 "parser.c"
    break;

  case 135:
#line 2086 "parser.y"
                  { 
        strcpy(szMexToken, " allfieldvaluerec instruction ");
        if (findrep_field == NULL) {
            findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
        }
        else
        {
            findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
            findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
        }
}
#line 4092 "parser.c"
    break;

  case 136:
#line 2098 "parser.y"
    {
        strcpy(szMexToken, " allfieldvaluerec instruction 2");
        if (findrep_field == NULL) {
            findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
        }
        else
         {
            findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyval.findrep_field), (struct fieldValue_t*) NULL);
            findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
         }
    }
#line 4108 "parser.c"
    break;

  case 137:
#line 2113 "parser.y"
                  { 
        strcpy(szMexToken, " inoutfieldvaluerec instruction ");
        if (nSwitchFR == 0) {
            field_tmp =(yyvsp[0].fieldValue);
            nSwitchFR = 1;
        }
        else
        {
            if (findrep_field == NULL) {
                findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyvsp[0].fieldValue), (struct fieldValue_t*)field_tmp);
                nSwitchFR = 0;
            }
            else
            {
                findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyvsp[0].fieldValue), (struct fieldValue_t*) field_tmp);
                findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
                nSwitchFR = 0;
            }
        }
}
#line 4133 "parser.c"
    break;

  case 138:
#line 2134 "parser.y"
    {
        strcpy(szMexToken, " inoutfieldvaluerec instruction 2");
        if (nSwitchFR == 0) {
            field_tmp =(yyvsp[-2].fieldValue);
            nSwitchFR = 1;
        }
        else
        {
            if (findrep_field == NULL) {
                findrep_field = findrepfield_constructor((struct fieldValue_t*)(yyvsp[-2].fieldValue), (struct fieldValue_t*)field_tmp);
                nSwitchFR = 0;
            }
            else
            {
                findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)(yyvsp[-2].fieldValue), (struct fieldValue_t*) field_tmp);
                findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
                nSwitchFR = 0;
            }
        }        
        /*
        if (findrep_field == NULL) {
            findrep_field = findrepfield_constructor((struct fieldValue_t*)NULL, (struct fieldValue_t*) $1);
            nSwitchFR = 1;
        }
        else
        {
            if (nSwitchFR == 2) {
                findrep_fields_setin(findrep_field_tmp, $1);
            }
            if (nSwitchFR == 1) {
                findrep_fields_setin(findrep_field, $1);
                nSwitchFR = 2;
            }
            else {
                findrep_field_tmp = findrepfield_constructor((struct fieldValue_t*)NULL, (struct fieldValue_t*) $1);
                findrepfield_t_addQueue(&findrep_field, findrep_field_tmp);
            }
        }
        */
    }
#line 4178 "parser.c"
    break;

  case 139:
#line 2177 "parser.y"
                    { 
        strcpy(szMexToken, " changepairdet instruction ");
        (yyval.changefield)=(yyvsp[0].changefield);
}
#line 4187 "parser.c"
    break;

  case 140:
#line 2181 "parser.y"
                                   {}
#line 4193 "parser.c"
    break;

  case 141:
#line 2189 "parser.y"
                                            { 
		/* $$=changefield_constructor((char*) $2, $5); */
        /* verify      CHARTCOND  vs CHARTYPE */     
        struct fieldValue_t* fv1 = fieldValue_constructor((char*) (yyvsp[-4].string), (yyvsp[-3].string), TYPE_STRUCT_STD, 0);
		if (fv1 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        struct fieldValue_t* fv2 = fieldValue_constructor((char*) (yyvsp[-1].string), (yyvsp[0].string), TYPE_STRUCT_STD, 0);
		if (fv2 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        
        struct changefield_t* pcf = changefield_constructor(fv1, fv2);
		if (pcf == NULL) {
            utl_abend_terminate(MEMORYALLOC, 215, ABEND_SKIP);
			YYABORT;
		}
        if (current_changefield == NULL)
			changefield_t_addQueue(&current_changefield, pcf); 
		else 
			changefield_t_addQueue(&current_changefield, pcf); 
		current_changefield = pcf; 
		free((yyvsp[-4].string)); 
		free((yyvsp[-3].string)); 
        free((yyvsp[-1].string));
		free((yyvsp[0].string)); 
        (yyval.changefield)=pcf;
}
#line 4228 "parser.c"
    break;

  case 142:
#line 2220 "parser.y"
                                             { 
        /* verify      CHARTCOND  vs CHARTYPE */     
        struct fieldValue_t* fv1 = fieldValue_constructor((char*) (yyvsp[-5].string), (yyvsp[-4].string), TYPE_STRUCT_STD, 0);
		if (fv1 == NULL) {
            utl_abend_terminate(MEMORYALLOC, 218, ABEND_SKIP);
			YYABORT;
		}
        struct changefield_t* pcf = changefield_constructorPosLen(fv1, (yyvsp[-2].number), (yyvsp[0].number));
		if (pcf == NULL) {
            utl_abend_terminate(MEMORYALLOC, 215, ABEND_SKIP);
			YYABORT;
		}
        if (current_changefield == NULL)
			changefield_t_addQueue(&current_changefield, pcf); 
		else 
			changefield_t_addQueue(&current_changefield, pcf); 
		current_changefield = pcf; 
		free((yyvsp[-5].string)); 
		free((yyvsp[-4].string)); 
        (yyval.changefield)=pcf;
}
#line 4254 "parser.c"
    break;

  case 143:
#line 2248 "parser.y"
                     { 
        /* $$=changefield_constructor((char*) $2, $5); */
		(yyval.fieldValue)=fieldValue_constructor((char*) (yyvsp[-1].string), (yyvsp[0].string), TYPE_STRUCT_STD, 0);
		if ((yyval.fieldValue) == NULL) {
            utl_abend_terminate(MEMORYALLOC, 104, ABEND_SKIP);
			YYABORT;
		}
		free((yyvsp[-1].string)); 
		free((yyvsp[0].string));         
}
#line 4269 "parser.c"
    break;

  case 144:
#line 2263 "parser.y"
                            {
		strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
#line 4280 "parser.c"
    break;

  case 145:
#line 2268 "parser.y"
                  {
        current_outrec=0;
        nRecCase=0;
}
#line 4289 "parser.c"
    break;

  case 146:
#line 2274 "parser.y"
                        {
        strcpy(szMexToken, " outrec clause ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
#line 4300 "parser.c"
    break;

  case 147:
#line 2279 "parser.y"
                  {
        current_outrec=0;
        nRecCase=0;
}
#line 4309 "parser.c"
    break;

  case 148:
#line 2284 "parser.y"
                           {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
#line 4320 "parser.c"
    break;

  case 149:
#line 2289 "parser.y"
                  {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
#line 4330 "parser.c"
    break;

  case 150:
#line 2295 "parser.y"
                       {
        strcpy(szMexToken, " outrec clause BUILD ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
#line 4341 "parser.c"
    break;

  case 151:
#line 2300 "parser.y"
                  {
        current_outrec=0;
        nRecCase=0;
}
#line 4350 "parser.c"
    break;

  case 152:
#line 2305 "parser.y"
                             {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
#line 4361 "parser.c"
    break;

  case 153:
#line 2310 "parser.y"
                  {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
#line 4372 "parser.c"
    break;

  case 154:
#line 2317 "parser.y"
                         {
        strcpy(szMexToken, " outrec clause Overlay ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        }
#line 4383 "parser.c"
    break;

  case 155:
#line 2322 "parser.y"
                          {
        current_outrec=0;
        nRecCase=0;
        outrec_overlay=1;
        outrec_SetOverlay(outrec, outrec_overlay);
}
#line 4394 "parser.c"
    break;

  case 156:
#line 2328 "parser.y"
                         {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
#line 4405 "parser.c"
    break;

  case 157:
#line 2333 "parser.y"
               {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
#line 4415 "parser.c"
    break;

  case 158:
#line 2338 "parser.y"
                             {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
#line 4426 "parser.c"
    break;

  case 159:
#line 2343 "parser.y"
                  {
        current_outrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
#line 4436 "parser.c"
    break;

  case 160:
#line 2349 "parser.y"
                      {
        strcpy(szMexToken, " outrec clause FINDREP ");
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
}
#line 4447 "parser.c"
    break;

  case 161:
#line 2354 "parser.y"
               {
        current_outrec=0;
        nRecCase=0;
}
#line 4456 "parser.c"
    break;

  case 162:
#line 2364 "parser.y"
                     {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
        strcpy(szMexToken, " outrec clause ");
		nPosAbsRec = 0;
}
#line 4467 "parser.c"
    break;

  case 163:
#line 2369 "parser.y"
                  {
        current_outrec=0;
        nRecCase=0;
}
#line 4476 "parser.c"
    break;

  case 164:
#line 2374 "parser.y"
               {
        current_outrec=1;
        nRecCase=OUTREC_CASE;
		nPosAbsRec = 0;
        strcpy(szMexToken, " outrec clause ");
}
#line 4487 "parser.c"
    break;

  case 165:
#line 2379 "parser.y"
                  {
        current_outrec=0;
        nRecCase=0;
}
#line 4496 "parser.c"
    break;

  case 166:
#line 2388 "parser.y"
                           {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
#line 4507 "parser.c"
    break;

  case 167:
#line 2393 "parser.y"
                  {
        current_inrec=0;
        nRecCase=0;
}
#line 4516 "parser.c"
    break;

  case 168:
#line 2398 "parser.y"
                       {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
#line 4527 "parser.c"
    break;

  case 169:
#line 2403 "parser.y"
                          {
        current_inrec=0;
        nRecCase=0;
}
#line 4536 "parser.c"
    break;

  case 170:
#line 2408 "parser.y"
                          {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
#line 4547 "parser.c"
    break;

  case 171:
#line 2413 "parser.y"
                  {
        current_inrec=0;
        nRecCase=0;
}
#line 4556 "parser.c"
    break;

  case 172:
#line 2418 "parser.y"
                      {
        strcpy(szMexToken, " inrec clause ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
#line 4567 "parser.c"
    break;

  case 173:
#line 2423 "parser.y"
                  {
			current_inrec=0;
			nRecCase=0;
}
#line 4576 "parser.c"
    break;

  case 174:
#line 2428 "parser.y"
                            {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
#line 4587 "parser.c"
    break;

  case 175:
#line 2433 "parser.y"
                  {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
#line 4598 "parser.c"
    break;

  case 176:
#line 2440 "parser.y"
                        {
        strcpy(szMexToken, " inrec clause Overlay");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
        }
#line 4609 "parser.c"
    break;

  case 177:
#line 2445 "parser.y"
                          {
        current_inrec=0;
        nRecCase=0;
        inrec_overlay=1;
        inrec_SetOverlay(inrec, inrec_overlay);
}
#line 4620 "parser.c"
    break;

  case 178:
#line 2451 "parser.y"
                        {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
#line 4631 "parser.c"
    break;

  case 179:
#line 2456 "parser.y"
               {
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
#line 4641 "parser.c"
    break;

  case 180:
#line 2461 "parser.y"
                            {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
#line 4652 "parser.c"
    break;

  case 181:
#line 2466 "parser.y"
                  {
        current_inrec=0;
        nRecCase=0;
		nPosAbsRec = 0;
}
#line 4662 "parser.c"
    break;

  case 182:
#line 2472 "parser.y"
                     {
        strcpy(szMexToken, " inrec clause FINDREP ");
        current_inrec=1;
        nRecCase=INREC_CASE;
		nPosAbsRec = 0;
}
#line 4673 "parser.c"
    break;

  case 183:
#line 2477 "parser.y"
               {
        current_inrec=0;
        nRecCase=0;
}
#line 4682 "parser.c"
    break;

  case 184:
#line 2486 "parser.y"
                   {
        strcpy(szMexToken, " build clause ");
        /* current_inrec=1;         */
        /* nRecCase=INREC_CASE;     */
		nPosAbsRec = 0;
}
#line 4693 "parser.c"
    break;

  case 185:
#line 2491 "parser.y"
                  {
		/*  current_inrec=0;    */
		nRecCase=0;
}
#line 4702 "parser.c"
    break;

  case 186:
#line 2497 "parser.y"
                      {}
#line 4708 "parser.c"
    break;

  case 187:
#line 2498 "parser.y"
                                           {}
#line 4714 "parser.c"
    break;

  case 188:
#line 2501 "parser.y"
                        {
        struct SumField_t *SumField=SumField_constructor((yyvsp[-2].number), (yyvsp[0].number), 0);
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 135, ABEND_SKIP);
			YYABORT;
		}
        nTypeFormat=3;			/* for SumFields Format=    */
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
}
#line 4729 "parser.c"
    break;

  case 189:
#line 2511 "parser.y"
                                             {
			struct SumField_t *SumField1=SumField_constructor((yyvsp[-6].number), (yyvsp[-4].number), 0);
			struct SumField_t *SumField2=SumField_constructor((yyvsp[-2].number), (yyvsp[0].number), 0);
			if (SumField1 == NULL) {
                utl_abend_terminate(MEMORYALLOC, 136, ABEND_SKIP);
				YYABORT;
			}
			if (SumField2 == NULL) {
                utl_abend_terminate(MEMORYALLOC, 140, ABEND_SKIP);
				YYABORT;
			}
			nTypeFormat=3;			/* for SumFields Format=    */
 			SumField_addDefinition(SumField1); 
			nTypeFormat=3;			/* for SumFields Format=    */
 			SumField_addDefinition(SumField2); 
		strcpy(szMexToken, " sum fields clause ");
}
#line 4751 "parser.c"
    break;

  case 190:
#line 2528 "parser.y"
                                     {
        struct SumField_t *SumField=SumField_constructor((yyvsp[-4].number), (yyvsp[-2].number), (yyvsp[0].number));
        if (SumField == NULL) {
            utl_abend_terminate(MEMORYALLOC, 137, ABEND_SKIP);
			YYABORT;
		}
        SumField_addDefinition(SumField); 
        strcpy(szMexToken, " sum fields clause ");
}
#line 4765 "parser.c"
    break;

  case 191:
#line 2540 "parser.y"
                      {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
}
#line 4774 "parser.c"
    break;

  case 192:
#line 2544 "parser.y"
                           {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
        SumField_enableXSUM(); 
        current_file=NULL;
}
#line 4785 "parser.c"
    break;

  case 193:
#line 2550 "parser.y"
                                              {
		SumField_setFunction(1);
        strcpy(szMexToken, " sum fields clause ");
        SumField_enableXSUM(); 
        SumField_enableXSUM(); 
        struct file_t *file=file_constructor((yyvsp[0].string));
        strcpy(szMexToken, " xsum clause ");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 101, ABEND_SKIP);
			YYABORT;
		}
        file_setXSUMFile(file);
        current_file=file;
        nTypeFile=0;
        current_file=NULL;
        free((yyvsp[0].string));        
}
#line 4807 "parser.c"
    break;

  case 194:
#line 2567 "parser.y"
                                     {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
}
#line 4816 "parser.c"
    break;

  case 195:
#line 2571 "parser.y"
                                           {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
        SumField_enableXSUM(); 
        /* Attenction file name for XSUM without FNAMES */
}
#line 4827 "parser.c"
    break;

  case 196:
#line 2577 "parser.y"
                                                             {
        strcpy(szMexToken, " sum fields clause ");
        SumField_setFunction(2);
        SumField_enableXSUM(); 
        struct file_t *file=file_constructor((yyvsp[0].string));
        strcpy(szMexToken, " xsum clause ");
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 101, ABEND_SKIP);
			YYABORT;
		}
        file_setXSUMFile(file);
        current_file=file;
        nTypeFile=0;
       /* file_SetInfoForFile(current_file, COB_OPEN_OUTPUT); */ /*  Output  */
        current_file=NULL;
        free((yyvsp[0].string));        
}
#line 4849 "parser.c"
    break;

  case 197:
#line 2597 "parser.y"
               {
		/*  printf("GCSORT: Warning Token skipped : %s\n",yylval.string);   */
}
#line 4857 "parser.c"
    break;

  case 198:
#line 2603 "parser.y"
                {
        struct file_t *file;
		file=file_constructor((yyvsp[0].string));
        if (file == NULL) {
            utl_abend_terminate(MEMORYALLOC, 138, ABEND_SKIP);
			YYABORT;
		}
		nCountGroupFiles++;
		if (nCountGroupFiles == 1)
			outfil_setOutfilFiles(current_outfil, file);
		else
            file_addQueue(&current_outfil->outfil_File, file);
        file_SetInfoForFile(file, COB_OPEN_OUTPUT); 
        outfil_SetVirtualFile(current_outfil, 0);       /* OUTFIL has file name */
        free((yyvsp[0].string));
        strcpy(szMexToken, " files clause ");
}
#line 4879 "parser.c"
    break;

  case 199:
#line 2623 "parser.y"
                                  {
		strcpy(szMexToken, " group files outfil ");
}
#line 4887 "parser.c"
    break;

  case 200:
#line 2629 "parser.y"
                                         {
}
#line 4894 "parser.c"
    break;

  case 201:
#line 2631 "parser.y"
                                  {
}
#line 4901 "parser.c"
    break;

  case 202:
#line 2633 "parser.y"
                 {
	   utils_SetOptionSort("SPLIT", current_outfil, 0);
       strcpy(szMexToken, " option SPLIT clause ");
}
#line 4910 "parser.c"
    break;

  case 203:
#line 2637 "parser.y"
                         {
	   utils_SetOptionSort("SPLITBY", current_outfil, (yyvsp[0].number));
       strcpy(szMexToken, " option SPLITBY clause ");
}
#line 4919 "parser.c"
    break;

  case 204:
#line 2643 "parser.y"
                                {
        if (nRecCase == JOIN_CASE) {
            if (current_join != NULL)       /* Join */
			    join_IncludeCondField(current_filejoin, current_join, (yyvsp[0].condField));
        }
		if (current_outfil != NULL)
			setOutfilIncludeCondField(current_outfil, (yyvsp[0].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil include clause ");
}
#line 4934 "parser.c"
    break;

  case 205:
#line 2655 "parser.y"
                             {
        if (nRecCase == JOIN_CASE) {
            if (current_join != NULL)       /* Join */
                join_OmitCondField(current_filejoin, current_join, (yyvsp[0].condField));
        }
		if (current_outfil != NULL)
			setOutfilOmitCondField(current_outfil, (yyvsp[0].condField));
		nTypeIncludeOmit = 1;
        strcpy(szMexToken, " outfil omit clause ");
}
#line 4949 "parser.c"
    break;

  case 206:
#line 2667 "parser.y"
              {
		struct outfil_t *outfil=outfil_constructor();
        if (outfil == NULL) {
            utl_abend_terminate(MEMORYALLOC, 139, ABEND_SKIP);
			YYABORT;
		}
		if (current_outfil == NULL)
			outfil_addDefinition(outfil); 
		else 
			outfil_addDefinition(outfil); 
		current_outfil=outfil; 
		nstate_outfil=1;
        strcpy(szMexToken, " outfil clause ");
}
#line 4968 "parser.c"
    break;

  case 207:
#line 2683 "parser.y"
                                {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[0].llnumber));
		strcpy(szMexToken, " start rec clause ");
}
#line 4978 "parser.c"
    break;

  case 208:
#line 2688 "parser.y"
                         {
		if (current_outfil != NULL)
			outfil_SetStartRec(current_outfil, (yyvsp[0].number));
		strcpy(szMexToken, " start rec clause ");
}
#line 4988 "parser.c"
    break;

  case 209:
#line 2696 "parser.y"
                              {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[0].llnumber));
		strcpy(szMexToken, " end rec clause ");
}
#line 4998 "parser.c"
    break;

  case 210:
#line 2701 "parser.y"
                       {
		if (current_outfil != NULL)
			outfil_SetEndRec(current_outfil, (yyvsp[0].number));
		strcpy(szMexToken, " end rec clause ");
}
#line 5008 "parser.c"
    break;

  case 211:
#line 2708 "parser.y"
                 {
		if (current_outfil != NULL)
			outfil_SetSave(current_outfil);
		strcpy(szMexToken, " save clause ");
}
#line 5018 "parser.c"
    break;

  case 212:
#line 2717 "parser.y"
             {}
#line 5024 "parser.c"
    break;

  case 213:
#line 2719 "parser.y"
                        {}
#line 5030 "parser.c"
    break;

  case 214:
#line 2722 "parser.y"
           {
        utils_SetOptionSort("COPY", NULL, 0);
		strcpy(szMexToken, " option copy clause ");
}
#line 5039 "parser.c"
    break;

  case 215:
#line 2726 "parser.y"
                               {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[0].llnumber));
		strcpy(szMexToken, " option skip rec clause ");
}
#line 5048 "parser.c"
    break;

  case 216:
#line 2730 "parser.y"
                        {
        utils_SetOptionSortNum("SKIPREC", (yyvsp[0].number));
		strcpy(szMexToken, " option skip rec clause ");
}
#line 5057 "parser.c"
    break;

  case 217:
#line 2734 "parser.y"
                               {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[0].llnumber));
		strcpy(szMexToken, " option stop after clause ");
}
#line 5066 "parser.c"
    break;

  case 218:
#line 2738 "parser.y"
                        {
        utils_SetOptionSortNum("STOPAFT", (yyvsp[0].number));
		strcpy(szMexToken, " option stop after clause ");
}
#line 5075 "parser.c"
    break;

  case 219:
#line 2742 "parser.y"
             {
        utils_SetOptionSort("VLSCMP", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
#line 5084 "parser.c"
    break;

  case 220:
#line 2746 "parser.y"
             {
        utils_SetOptionSort("VLSHRT", NULL, 0);
		strcpy(szMexToken, " option VLSCMP clause ");
}
#line 5093 "parser.c"
    break;

  case 221:
#line 2750 "parser.y"
                       {
        utils_SetOptionY2Past("Y2PAST", (yyvsp[0].number));
		strcpy(szMexToken, " option y2past clause ");
}
#line 5102 "parser.c"
    break;

  case 222:
#line 2755 "parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[-4].string), (yyvsp[-1].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[-4].string));
        free((yyvsp[-1].string));
}
#line 5113 "parser.c"
    break;

  case 223:
#line 2762 "parser.y"
    {
        utils_SetOptionExRoutine("MODS", (yyvsp[-4].string), (yyvsp[-1].string));
		strcpy(szMexToken, " option MODS E15 clause 1");
        free((yyvsp[-4].string));
        free((yyvsp[-1].string));
}
#line 5124 "parser.c"
    break;

  case 224:
#line 2768 "parser.y"
                                                  {
        utils_SetOptionExRoutine("MODS", (yyvsp[-6].string), (yyvsp[-3].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[-6].string));
        free((yyvsp[-3].string));
}
#line 5135 "parser.c"
    break;

  case 225:
#line 2774 "parser.y"
                                                             {
        utils_SetOptionExRoutine("MODS", (yyvsp[-8].string), (yyvsp[-5].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[-8].string));
        free((yyvsp[-5].string));
        free((yyvsp[-1].string));
}
#line 5147 "parser.c"
    break;

  case 226:
#line 2781 "parser.y"
                                               {
        utils_SetOptionExRoutine("MODS", (yyvsp[-6].string), (yyvsp[-3].string));
		strcpy(szMexToken, " option MODS E15 clause 2");
        free((yyvsp[-6].string));
        free((yyvsp[-3].string));
}
#line 5158 "parser.c"
    break;

  case 227:
#line 2787 "parser.y"
                                                          {
        utils_SetOptionExRoutine("MODS", (yyvsp[-8].string), (yyvsp[-5].string));
		strcpy(szMexToken, " option MODS E15 clause 3");
        free((yyvsp[-8].string));
        free((yyvsp[-5].string));
        free((yyvsp[-1].string));
}
#line 5170 "parser.c"
    break;

  case 228:
#line 2796 "parser.y"
              {
}
#line 5177 "parser.c"
    break;

  case 229:
#line 2797 "parser.y"
            {
}
#line 5184 "parser.c"
    break;

  case 230:
#line 2808 "parser.y"
                 {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[0].string));
}
#line 5194 "parser.c"
    break;

  case 231:
#line 2814 "parser.y"
                                        {
        utils_SetRecordOptionSortType((yyvsp[-4].string));
        utils_SetRecordOptionSortLen((yyvsp[-1].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-4].string));
}
#line 5205 "parser.c"
    break;

  case 232:
#line 2820 "parser.y"
                                                  {
        utils_SetRecordOptionSortType((yyvsp[-6].string));
        utils_SetRecordOptionSortLen((yyvsp[-3].number), (yyvsp[-1].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-6].string));
}
#line 5216 "parser.c"
    break;

  case 233:
#line 2826 "parser.y"
                                            {
        utils_SetRecordOptionSortType((yyvsp[-5].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[-1].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-5].string));
}
#line 5227 "parser.c"
    break;

  case 234:
#line 2832 "parser.y"
                                                            {
        utils_SetRecordOptionSortType((yyvsp[-8].string));
        utils_SetRecordOptionSortLen((yyvsp[-5].number), (yyvsp[-3].number), (yyvsp[-1].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-8].string));
}
#line 5238 "parser.c"
    break;

  case 235:
#line 2838 "parser.y"
                                                  {
        utils_SetRecordOptionSortType((yyvsp[-6].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[-1].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-6].string));
}
#line 5249 "parser.c"
    break;

  case 236:
#line 2844 "parser.y"
                                                       {
        utils_SetRecordOptionSortType((yyvsp[-7].string));
        utils_SetRecordOptionSortLen((yyvsp[-4].number), -1, (yyvsp[-1].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-7].string));
}
#line 5260 "parser.c"
    break;

  case 237:
#line 2851 "parser.y"
                  {
/*        utils_SetOptionSort("COPY", NULL, 0); */
		strcpy(szMexToken, " record option clause ");
        free((yyvsp[0].string));
}
#line 5270 "parser.c"
    break;

  case 238:
#line 2857 "parser.y"
                                       {
        utils_SetRecordOptionSortType((yyvsp[-4].string));
        utils_SetRecordOptionSortLen((yyvsp[-1].number), -1, -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-4].string));
}
#line 5281 "parser.c"
    break;

  case 239:
#line 2863 "parser.y"
                                                  {
        utils_SetRecordOptionSortType((yyvsp[-6].string));
        utils_SetRecordOptionSortLen((yyvsp[-3].number), (yyvsp[-1].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-6].string));
}
#line 5292 "parser.c"
    break;

  case 240:
#line 2869 "parser.y"
                                           {
        utils_SetRecordOptionSortType((yyvsp[-5].string));
        utils_SetRecordOptionSortLen(-1, (yyvsp[-1].number), -1, -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-5].string));
}
#line 5303 "parser.c"
    break;

  case 241:
#line 2875 "parser.y"
                                                            {
        utils_SetRecordOptionSortType((yyvsp[-8].string));
        utils_SetRecordOptionSortLen((yyvsp[-5].number), (yyvsp[-3].number), (yyvsp[-1].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-8].string));
}
#line 5314 "parser.c"
    break;

  case 242:
#line 2881 "parser.y"
                                                  {
        utils_SetRecordOptionSortType((yyvsp[-6].string));
        utils_SetRecordOptionSortLen(-1, -1, (yyvsp[-1].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-6].string));
}
#line 5325 "parser.c"
    break;

  case 243:
#line 2887 "parser.y"
                                                     {
        utils_SetRecordOptionSortType((yyvsp[-7].string));
        utils_SetRecordOptionSortLen((yyvsp[-4].number), -1, (yyvsp[-1].number), -1, -1, -1, -1);
		strcpy(szMexToken, "  record option clause ");
        free((yyvsp[-7].string));
}
#line 5336 "parser.c"
    break;

  case 244:
#line 2898 "parser.y"
                                {
    /*} allrecordoption { */
}
#line 5344 "parser.c"
    break;


#line 5348 "parser.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 2903 "parser.y"

