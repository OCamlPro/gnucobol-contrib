      *> CONFIGURATION SETTINGS: Set these switches before compiling:
      *>
      *> LINEDRAW Set to:
      *>    0   To use spaces (no lines)
      *>    1   To use the line-drawing characterset (PC codepage 437)
      *>    2   To use conventional ASCII characters (+, -, |)
      *>
      *>          OSX USERS - To use the linedrawing characterset,
      *>                      set your 'terminal' font to 'Lucida Console'
      *>
      *> OS       Set to one of the following:
      *>          'CYGWIN'   For a Windows/Cygwin version
      *>          'MINGW'    For a Windows/MinGW version
      *>          'OSX'      For a Macintosh OSX version
      *>          'UNIX'     For a Unix/Linux version
      *>          'WINDOWS'  For a Native Windows version
      *>
      *> SELCHAR  Set to the desired single character to be used as the red
      *>          'feature selected' character on the screen.
      *>          SUGGESTIONS: '>', '*', '=', '+'
      *>
      *> LPP      Set to maximum printable lines per page when the listing
      *>          should be generated for LANDSCAPE orientation (can be over-
      *>          ridden at execution time using the GCXREF_LINES environment
      *>          variable.
      *>
      *> LPPP     Set to maximum printable lines per page when the listing
      *>          should be generated for PORTRAIT orientation (can be over-
      *>          ridden at execution time using the GCXREF_LINES_PORT
      *>          environment variable.
      *>
GC0712 >>DEFINE CONSTANT LINEDRAW   AS 2
GC0712 >>DEFINE CONSTANT OS         AS 'UNIX'
GC0712 >>DEFINE CONSTANT SELCHAR    AS '>'
GC1213 >>DEFINE CONSTANT LPP        AS 50   *> LANDSCAPE (GCXREF_LINES)
GC1213 >>DEFINE CONSTANT LPPP       AS 60   *> PORTRAIT  (GCXREF_LINES_PORT)
      *> --------------------------------------------------------------
      *> Now set these switches to establish initial (default) settings
      *> for the various on-screen options.  Set them to a value of
      *> 0 if they are to be 'OFF' and 1 if they are to be 'ON'
GC1213*> (for F5, 1=ON (Landscape), 2=ON (Portrait))
      *>
GC0712 >>DEFINE CONSTANT F1  AS 0 *> Assume WITH DEBUGGING MODE
GC0712 >>DEFINE CONSTANT F2  AS 0 *> Procedure+Statement Trace
GC0712 >>DEFINE CONSTANT F3  AS 0 *> Make A Library (DLL)
GC0712 >>DEFINE CONSTANT F4  AS 0 *> Execute If Compilation OK
GC1213 >>DEFINE CONSTANT F5  AS 0 *> Listings
GC0712 >>DEFINE CONSTANT F6  AS 1 *> "FUNCTION" Is Optional
GC0712 >>DEFINE CONSTANT F7  AS 1 *> Enable All Warnings
GC0712 >>DEFINE CONSTANT F8  AS 1 *> Source Is Free-Format
GC0712 >>DEFINE CONSTANT F9  AS 1 *> No COMP/BINARY Truncation
GC0712 >>DEFINE CONSTANT F12 AS 4 *> Default config file (1-7):
      *>                             1 = BS2000
      *>                             2 = COBOL85
      *>                             3 = COBOL2002
      *>                             4 = DEFAULT
      *>                             5 = IBM
      *>                             6 = MF (i.e. Microfocus)
      *>                             7 = MVS
