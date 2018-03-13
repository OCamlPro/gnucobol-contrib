/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_SocketInputStream.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_SocketInputStream.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_SocketInputStream.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_SocketInputStream.java
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

public class JAPI_SocketInputStream extends DataInputStream
{
	InputStream is;
	byte[] recvbuf = new byte[4];


	public JAPI_SocketInputStream(InputStream ins)
	{
		super(ins);
		is = ins;
	}

	public void recv(byte[] b,  int len) throws IOException
	{
		int readn=0,part=0;

		while(len>0)
		{
			part=is.read(b,readn,len);
			    
			if(part>0)
			{
				readn += part;
				len   -= part;
			}
			if(part == -1)
			{
				for(part=0;part<len;part++)
					b[part] = 0;
				return;
			}
			
//			System.err.println("Gelesen "+part);
		}
	}

	public int recvInt()  throws IOException
	{
		int val=0;

		recv(recvbuf,4);

		val =              ((char)recvbuf[3] & 0xff);
		val = (val << 8) | ((char)recvbuf[2] & 0xff);
		val = (val << 8) | ((char)recvbuf[1] & 0xff);
		val = (val << 8) | ((char)recvbuf[0] & 0xff);

		return(val);
	}
	
//  readLine is deprecated: replace with own code
	public String readToLineEnd() throws IOException
	{
		return(readLine());	
	}

}
