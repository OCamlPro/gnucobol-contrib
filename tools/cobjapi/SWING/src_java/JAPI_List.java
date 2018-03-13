/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_List.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_List.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_List.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_List.java
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

import java.awt.*;
import java.io.*;

public class JAPI_List extends List
{
	JAPI_Itemlistener itemlist;
	int event_id;
	JAPI_SocketOutputStream actionsock;
	int w=0,h=0;

	public JAPI_List(int rows, int id, JAPI_SocketOutputStream action)
	{
		super(rows,false);
		event_id=id;
		actionsock=action;
	}

	public void setmultiplemode(boolean value)
	{
		super.setMultipleMode(value);
		if(value)
		{
			if(itemlist==null)
				itemlist=new JAPI_Itemlistener(event_id,actionsock);
			this.addItemListener(itemlist);
		}
		else
			this.removeItemListener(itemlist);
	}

	public void setSize(int dw, int dh)
	{
		w = dw>0 ? dw : 0;
		h = dh>0 ? dh : 0;
		super.setSize(w,h);
	}

	public Dimension getPreferredSize()
	{
		Dimension dim = super.getPreferredSize();
		dim.width  = w>0 ? w : dim.width;
		dim.height = h>0 ? h : dim.height;
		return(dim);
	}

	public Dimension getMinimumSize()
	{
		Dimension dim = super.getMinimumSize();
		dim.width  = w>0 ? w : dim.width;
		dim.height = h>0 ? h : dim.height;
		return(dim);
	}

}
