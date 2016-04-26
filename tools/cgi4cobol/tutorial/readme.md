Read cstring.cbl / cgivalue.cbl along with this mini-tutorial. 

UDF means User Defined Function.

GnuCobol supports intrinsic functions and allows for similar functionality, written in pure Cobol.  
The crux of functions is that they can be used in any statement that uses a sending field; i.e. as in move A to B.  

Concatenate is a intrinsic function and one may code "move concatenate(A, B) to C." A well known application is concatenate(A, X'00') which results in a c-string; i.e. a string delimited by a binary zero, the standard string format in C. Such construct is used when one CALLs a c-routine that uses a string.

Now, such functionality can be written in a Cobol function too. Let's have a look at the UDF cstring.cbl.

The UDF has FUNCTION-ID in stead of PROGRAM-ID and the caller must declare the function in the REPOSITORY paragraph.

Please note the use of ANY LENGTH. In the UDF, the configuration of stringx is inherited from the caller, while stringy has a default configuration. GC assumes a length of 1 for stringy. Off course, that is not what is wanted. Luckily, Cobol has a solution for this, named DYNAMIC LENGTH. Un-luckily, this feature is not yet available in gnuCobol 2.0.

So, in stead of coding "MOVE concatenate(stringx, X'00') TO my-c-string", it is possible now to code, in a conceptual way, "MOVE cstring(stringx) TO my-c-string". This way the implementation detail X'00' is hidden and makes the source more readable.

Taking the concept one step further, in context with a cgi interface, one would like to have access to cgi variables like "MOVE variable_A_from_cgi to my_field_A." in stead of "call 'cgiInterface' using 'fieldA", my_field_A." and string/unstring that retrieved field to the correct format. Remember that the cgi interface delivers free format data.
With a function (look at cgivalue.cbl) one could write "move cgivalue('fieldA') to my_field_A." which is conceptual clear.
In the same time, we can hide the implementation detail 'cgiInterface' within the function.
