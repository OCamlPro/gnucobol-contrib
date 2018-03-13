/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Textarea.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Textarea.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Textarea.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Textarea.java
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

public class JAPI_Textarea extends TextArea
{

	int w=0,h=0;

	public JAPI_Textarea(int r, int c)
	{
		super(r,c);
	}

	public void setSize(int dw, int dh)
	{
		w = dw>0 ? dw : 0;
		h = dh>0 ? dh : 0;
		super.setSize(w,h);
	}

	public void setRows(int r)
	{
		if((h=getPreferredSize(r,1).height)>0)
			super.setSize(w,h);
	}

	public int getRows()
	{
		int r=0;
		while(getPreferredSize(r,1).height < getSize().height)
			r++;
		return(--r);
	}

	public void setColumns(int c)
	{
		if((w=getPreferredSize(1,c).width)>0)
			super.setSize(w,h);
	}

	public int getColumns()
	{
		int c=0;
		while(getPreferredSize(1,c).width < getSize().width)
			c++;
		return(--c);
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
