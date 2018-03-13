/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_SocketOutputStream.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_SocketOutputStream.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_SocketOutputStream.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_SocketOutputStream.java
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
import java.net.*;

public class JAPI_SocketOutputStream extends DataOutputStream
{
	byte[] sendbuf = new byte[4];
	
	public JAPI_SocketOutputStream(OutputStream outs)
	{
		super(outs);	
	}

	public void sendInt(int i)  throws IOException 
	{
		sendbuf[0] = (byte)(i & 255);
		sendbuf[1] = (byte)((i>>8) & 255);
		sendbuf[2] = (byte)((i>>16) & 255);
		sendbuf[3] = (byte)((i>>24) & 255);
		write(sendbuf);
	}
}
