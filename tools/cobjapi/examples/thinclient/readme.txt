Thin-Client Example
===================

It is possible that your program and the GUI (JAPI.jar) run on different
computers and communicate via TCP/IP. For this example you need two computers
in a network: One with a Java runtime (GUI client), and the other with the
runnable GnuCOBOL program (server). 

Step 1, check the connection between the computers.
---------------------------------------------------
Get the ip adresses of the two computers with the ifconfig (for linux) or 
ipconfig (for win) commands (Screenshots: client_01.jpg, server_01.jpg).

Check the connection with the ping command between the computers.
(Screenshots: client_02.jpg, server_02.jpg)

Step 2, change the thinclient.cob program.
------------------------------------------
The thinclient.cob program is the same as the choice.cob program, except that 
the J-START function was replaced with J-CONNECT. You can develop your GUI 
GnuCOBOL program locally with J-START, and later run it as a client
server application with J-CONNECT with minimal changes.

In this example you have to change the IP address in the J-CONNECT function.
Write your client's IP address in this line:

    MOVE J-CONNECT("192.168.178.59") TO WS-RET

and compile the thinclient.cob program.

Step 3, copy JAPI.jar onto your client.
---------------------------------------
On the client computer you need only a Java runtime environment and the 
JAPI.jar Java archive file. (Screenshot: client_03.jpg)

Step 4, start JAPI.jar on your client.
--------------------------------------
If you use the J-START function in your program, then the JAPI.jar will be
started automatically on the local computer.

Now start JAPI.jar manually on your client, by typing this command in a 
terminal window:

    java -cp JAPI.jar JAPI 

(Screenshot: client_04.jpg)

Step 5, start the thinclient.exe program.
-----------------------------------------
Start the thinclient.exe program on your server. (Screenshot: server_03.jpg)
On the client the thinclient GUI appears (Screenshot: client_05.jpg)


Next steps
==========
You can extend this scenario in several ways:

- In JAPI.jar you can write a login function, that connects to the server. After
  successfully logging in, the server starts the GnuCOBOL server program. 
  The GnuCOBOL program gets the client IP address as a parameter.
  
- You start the JAPI.jar on your client, and you login on the server via a
  browser (for example via a GnuCOBOL CGI program). After successfully logging 
  in, the server starts the GnuCOBOL server program.   

- If you use JAPI via internet, and not in a closed network, you have to encrypt
  the connection.
