/* config.h.  For Windows  */

/* Use external log functions */
/* #undef EXTERNAL_LOG */

/* Define to 1 if you have the `strupr' function. */
#if defined (_MSC_VER) && _MSC_VER >= 1500
#define HAVE_STRUPR 1
#endif

/* Define to 1 if you have the <unistd.h> header file. */
/* #undef HAVE_UNISTD_H */

/* Debugging log level */
/* #undef LOGLEVEL */

/* Database is Microsoft SQL Server */
#define MSSQL

/* Name of package */
#define PACKAGE "gnu-cobol-sql"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "open-cobol-list@lists.sourceforge.net"

/* Define to the full name of this package. */
#define PACKAGE_NAME "ESQL for GNU Cobol"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "ESQL for GNU Cobol 2.0"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "gnu-cobol-sql"

/* Define to the home page for this package. */
#define PACKAGE_URL "http://www.kiska.net/opencobol/esql"

/* Define to the version of this package. */
#define PACKAGE_VERSION "2.0"

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Use multiple schemas/databases (default) */
/* #undef USE_NOT_USED */

/* Version number of package */
#define VERSION "2.0"

#define LITTLE_ENDIAN

/* Turn on debugging mode */
/* #undef _DEBUG */

