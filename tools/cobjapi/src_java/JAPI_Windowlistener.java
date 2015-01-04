/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Windowlistener.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Windowlistener.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Windowlistener.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Windowlistener.java
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
import java.awt.event.*;

public class JAPI_Windowlistener implements WindowListener
{

	JAPI_SocketOutputStream as;
	int id;
	int debuglevel=0;
	int type;

	public JAPI_Windowlistener(int object_id, JAPI_SocketOutputStream action , int t)
	{
		as = action;
		id = object_id;
		type = t;
	}


	public void windowActivated(WindowEvent e)
	{
		if(type==JAPI_Const.J_ACTIVATED)
			sendid();
	}

	public void windowDeactivated(WindowEvent e)
	{
		if(type==JAPI_Const.J_DEACTIVATED)
			sendid();
	}

	public void windowOpened(WindowEvent e)
	{
		if(type==JAPI_Const.J_OPENED)
			sendid();
	}

	public void windowClosed(WindowEvent e)
	{
		if(type==JAPI_Const.J_CLOSED)
			sendid();
	}

	public void windowIconified(WindowEvent e)
	{
		if(type==JAPI_Const.J_ICONIFIED)
			sendid();
	}

	public void windowDeiconified(WindowEvent e)
	{
		if(type==JAPI_Const.J_DEICONIFIED)
			sendid();
	}

	public void windowClosing(WindowEvent e)
	{
		if(type==JAPI_Const.J_CLOSING)
			sendid();
	}


	public void sendid()
	{
		if(debuglevel > 1) System.out.println("WindowListener for Object : "+this.id);
		try
		{
			as.sendInt(id);
		}
		catch(IOException exce) {}
	}

	public void setdebuglevel(int level)
	{
		debuglevel=level;
	}
}