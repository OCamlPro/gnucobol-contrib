This small contribution sends a request to the address "api.coindesk.com" using 
the "curl" tool. The contribution "system2" is used to get the output back. The
output is in JSON format and contains the current bitcoin rate information. This
JSON is parsed and the data is listed on the screen. After 30 seconds the 
request is repeated.

Note: there are many internet servers that provide bitcoin rate, but the JSON 
format is always different. Also, there is no guarantee that a server will work
tomorrow. If this example does not work later, then you have to find another 
server and adjust the program.

Access to all such servers is limited via the HTTP interface. You cannot send a
request that often and sometimes you have to register and use a token 
beforehand. Please check your selected server. If you need more data in a 
shorter time, then you have to use a socket connection.

For this contribution you need a working "curl" tool in the command line. For 
compilation you need the cJSON compiler extension.

Files:

screenshots    - example image
System2_src    - System2 source code
btc-rate.cob   - send request with "curl" and call the JSON parser
makefile       - for compile
parse-json.cob - JSON parser, it parses the response
readme.txt     - this file
system2_cmd.c  - system2_cmd() function, it reads the output in async mode



It was tested with 
- Windows 10 Enterprise; 
- GnuCOBOL 3.2.0 (Jul 28 2023 16:07:51), (MinGW) "13.1.0"
  GMP 6.2.1, libxml2 2.11.4, cJSON 1.7.15, PDCursesMod 4.3.7, BDB 18.1.40
  