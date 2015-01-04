/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI.java
*>
*> Author:       Dr. Merten Joost
*>
*> Date-Written: 2003.02.26
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2003.02.26 This comment is only for History. The latest Version (V1.0.6) of 
*>            JAPI was released on 02/26/2003. Homepage: http://www.japi.de 
*>------------------------------------------------------------------------------
*> 2014.12.24 Laszlo Erdos: 
*>            - GnuCOBOL support for JAPI added.
*>******************************************************************************
*/

import java.io.*;
import java.awt.*;
import java.net.*;

public class JAPI
{

    public static void main(String[] args) throws InterruptedException, MalformedURLException
    {
        ServerSocket listensock=null;
        Socket  clientsock=null;
        Socket  actionsock=null;

        try
        {
            if(args.length==0)
	            listensock=new ServerSocket(JAPI_Calls.JAPI_PORT);
    		else
    			listensock=new ServerSocket((new Integer(args[0])).intValue());
        }catch(IOException e)
        {
			System.out.println("Error : Could not listen at the specified port");
			new JAPI_Alert(new Frame(),"JAPI ERROR","Error : Could not listen at the specified port\nJAPI Port="+JAPI_Calls.JAPI_PORT+"\n"+
			                           "Maybe, there is another application using this port\n"+
			                           "or you have a personal firewall running","Ok");
			System.exit(1);
		}

        while(true)
        {
            try
            {
                clientsock = listensock.accept();
                actionsock = listensock.accept();
            }catch(IOException e) {}

            /* neuen Thread starten */
            new JAPI_Thread(clientsock,actionsock);
        }
    }
}

