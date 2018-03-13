/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Componentlistener.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Componentlistener.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Componentlistener.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Componentlistener.java
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

public class JAPI_Componentlistener implements ComponentListener
{
	JAPI_SocketOutputStream as;
	int id;
	int debuglevel=0;
	int type;

	public JAPI_Componentlistener(int object_id, JAPI_SocketOutputStream action , int t)
	{
		as = action;
		id = object_id;
		type = t;
	}

	public void componentResized(ComponentEvent e)
	{
		if(type==JAPI_Const.J_RESIZED)
		{
			Component c = (Component)e.getSource();
        	if(c instanceof JAPI_Canvas)
        	 	((JAPI_Canvas)c).noticeResize();
			sendid();
		}
	}

    public void componentHidden(ComponentEvent e)
    {
		if(type==JAPI_Const.J_HIDDEN)
			sendid();
	}

    public void componentMoved(ComponentEvent e)
    {
		if(type==JAPI_Const.J_MOVED)
			sendid();
	}

    public void componentShown(ComponentEvent e)
    {
		if(type==JAPI_Const.J_SHOWN)
			sendid();
	}

	public void sendid()
	{
		if(debuglevel > 1) System.out.println("ComponentListener for Object : "+this.id);
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

