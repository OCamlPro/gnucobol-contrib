
**Problem Statement:**  

Let Cobol software run on the web, interfaced with http-requests as input and producing html-pages as output.

----

Cobol is mainly used in a business environment where architectures use the IPO principle: Input some data (records in a file), process them and output them (print records). Off course, this is a very simplistic view.  

This IPO principle is still found in most modern system architectures and is sometimes synonimized with client-server architecture.  Fact is that input forms got smart as http-requests and printed reports went also intelligent in the from of html-pages. From a Cobol perspective these smart entities are 'foreign' since they come in free format.  
But we want Cobol to interface with these smart entities: and while Cobol is based on fixed length data, it looks like mission impossible to introduce variable-length string manipulation that is needed for interfacing with current software protocols, like http.  

Having the requirement to run Cobol software on the web implies the ability to read a external form, process its data and print some report that is rendered externally. Some compilers have implemented the interface with ACCEPT and DISPLAY (as opposed to READ and WRITE). The references to the external entities are implemented using the long-known CGI interface (http-requests with GET and POST) and generating html-pages from templates.  

----

Which brings us back to the problem statement, that reads: 

    get Cobol software running on the web, 
    interfacing with http-requests as input and
    generating html-pages to be rendered by the (client) browser.
    
and translates into:

	Treat the collection of these inputs as a form (record).
	Separate (presentation) html from the Cobol code.

In order to solve this problem, we'll use a c-library for CGI and a template engine. The implementation effort is reduced to interfacing with these c-libraries. We will see that this is impossible in 100% pure Cobol, but made easy by developing a few wrappers.

**Reference**, quoted from [Acucobol GT reference manual](http://documentation.microfocus.com/help/topic/com.microfocus.eclipse.infocenter.extendACUSuite/GUID-D714BF2A-9F4D-4885-8245-F57F3FE121A6.html?cp=5_0_1_3)  
