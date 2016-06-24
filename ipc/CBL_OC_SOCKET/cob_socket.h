
// Der folgende ifdef-Block zeigt die Standardlösung zur Erstellung von Makros, die das Exportieren 
// aus einer DLL vereinfachen. Alle Dateien in dieser DLL wurden mit dem in der Befehlszeile definierten
// Symbol COB_SOCKET_EXPORTS kompiliert. Dieses Symbol sollte für kein Projekt definiert werden, das
// diese DLL verwendet. Auf diese Weise betrachtet jedes andere Projekt, dessen Quellcodedateien diese Datei 
// einbeziehen, COB_SOCKET_API-Funktionen als aus einer DLL importiert, während diese DLL mit diesem 
// Makro definierte Symbole als exportiert betrachtet.


// macros for DLL export
//
#ifdef WIN32
	#ifdef COB_SOCKET_EXPORTS
	#define COB_SOCKET_API __declspec(dllexport)
	#else
	#define COB_SOCKET_API __declspec(dllimport)
	#endif
#endif

// data types
//
#ifdef WIN32
	#define COBSOCK_socket_t	SOCKET	// socket descriptor
	#define COBSOCK_socklen_t	int		// type for length of socket descriptor
#else
	#define COBSOCK_socket_t	int
	#define COBSOCK_socklen_t	socklen_t
#endif


// return values
//
#ifdef WIN32
	#define COBSOCK_SOCKET_ERROR	SOCKET_ERROR	// error at socket action
	#define COBSOCK_INVALID_SOCKET	INVALID_SOCKET	// invalid socket descriptor

	#define COBSOCK_EINVAL			WSAEINVAL
	#define COBSOCK_EADDRINUSE		WSAEADDRINUSE
	#define COBSOCK_ENETUNREACH		WSAENETUNREACH
	#define COBSOCK_ECONNREFUSED	WSAECONNREFUSED
	#define COBSOCK_EISCONN			WSAEISCONN
	#define COBSOCK_EINVAL          WSAEINVAL
#else
	#define COBSOCK_SOCKET_ERROR	-1
	#define COBSOCK_INVALID_SOCKET	-1

	#define COBSOCK_EINVAL			EINVAL
	#define COBSOCK_EADDRINUSE		EADDRINUSE
	#define COBSOCK_ENETUNREACH		ENETUNREACH
	#define COBSOCK_ECONNREFUSED	ECONNREFUSED
	#define COBSOCK_EISCONN			EISCONN
	#define COBSOCK_EINVAL          EINVAL
#endif


// functions
//
#ifdef WIN32
	#define COBSOCK_read(x,y,z)		recv(x,y,z,0)	// read from socket
	#define COBSOCK_write(x,y,z)	send(x,y,z,0)	// write to socket
	#define COBSOCK_close			closesocket		// close socket
	#define snprintf				_snprintf
#else
	#define COBSOCK_read(x,y,z)		read(x,y,z)
	#define COBSOCK_write(x,y,z)	write(x,y,z)
	#define COBSOCK_close			close
#endif

// function header for external call
//
#ifdef WIN32
	extern "C" COB_SOCKET_API int CBL_OC_SOCKET(char* p_code, char* p1, char* p2, char* p3, char* p4, char* p5, char* p6, char* pdummy);
#else
	extern "C" int CBL_OC_SOCKET(char* p_code, char* p1, char* p2, char* p3, char* p4, char* p5, char* p6, char* pdummy);
#endif

// Some pragmas
//
#ifdef WIN32
	#pragma warning(disable:4786)   
#endif