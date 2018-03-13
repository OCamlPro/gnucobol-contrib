/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Adjustmentlistener.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Adjustmentlistener.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Adjustmentlistener.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Adjustmentlistener.java
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

public class JAPI_Adjustmentlistener implements AdjustmentListener 
{
	JAPI_SocketOutputStream JGI_actionstream;
	int JGI_id;		
	int debuglevel=0;	

	public JAPI_Adjustmentlistener(int object_id, JAPI_SocketOutputStream action ) 
	throws IOException
	{
		JGI_actionstream=action;
		JGI_id = object_id;		
	}

	public void adjustmentValueChanged(AdjustmentEvent e)
	{
		if(debuglevel > 1) System.out.println("Adjustment Event in Object : "+this.JGI_id);	
		try
		{	
			JGI_actionstream.sendInt(JGI_id);
		}	
		catch(IOException exce) {}		
	}
	
	public void setdebuglevel(int level)
	{
		debuglevel=level;
	}
}
