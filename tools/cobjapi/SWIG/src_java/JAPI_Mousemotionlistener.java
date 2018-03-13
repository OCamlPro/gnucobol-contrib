/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Mousemotionlistener.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Mousemotionlistener.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Mousemotionlistener.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Mousemotionlistener.java
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

public class JAPI_Mousemotionlistener implements MouseMotionListener
{
//  Varaibles

	JAPI_SocketOutputStream JAPI_actionstream;
	int JAPI_id;		
	int JAPI_x=0;
	int JAPI_y=0;
	int JAPI_event;
	int debuglevel=0;	
	int button;	
	
	public JAPI_Mousemotionlistener(int object_id, JAPI_SocketOutputStream action , int event) 
	throws IOException
	{
		JAPI_actionstream=action;
		JAPI_id = object_id;		
		JAPI_event=event;
	}

	public int getxpos()
	{
		return(JAPI_x);
	} 

	public int getypos()
	{
		return(JAPI_y);
	} 

	public int getbutton()
	{
		return(button);
	} 

	public void mouseMoved(MouseEvent e)
	{
		if(JAPI_event == JAPI_Const.J_MOVED)
		{
			if(debuglevel > 1) System.out.println("Mouse Event Moved "+this.JAPI_id);		
			JAPI_x = e.getX();
			JAPI_y = e.getY();
			button = e.getModifiers();
			try
			{	
				JAPI_actionstream.sendInt(JAPI_id);
			}	
			catch(IOException exce) {}		
		}
	}

	public void mouseDragged(MouseEvent e)
	{
		if(JAPI_event == JAPI_Const.J_DRAGGED)
		{
			if(debuglevel > 1) System.out.println("Mouse Event Dragged "+this.JAPI_id);		
			JAPI_x = e.getX();
			JAPI_y = e.getY();
			button = e.getModifiers();
			try
			{	
				JAPI_actionstream.sendInt(JAPI_id);
			}	
			catch(IOException exce) {}		
		}
	}
		
	public void setdebuglevel(int level)
	{
		debuglevel=level;
	}
}