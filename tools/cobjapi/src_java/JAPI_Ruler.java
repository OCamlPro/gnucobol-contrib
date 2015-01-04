/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Ruler.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Ruler.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Ruler.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Ruler.java
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

public class JAPI_Ruler extends Canvas
{

	int w=0,h=0,orient=JAPI_Const.J_HORIZONTAL,style=JAPI_Const.J_LINEUP;

	public JAPI_Ruler (int o, int s, int len)
	{
		super();
		orient=o;
		style=s;
		if(orient==JAPI_Const.J_HORIZONTAL)
			setSize(len,4);
		else
			setSize(4,len);
	}

	public void setBounds( int x, int y, int dw, int dh)
	{
		w = dw>0 ? dw : 0;
		h = dh>0 ? dh : 0;
		super.setBounds(x,y,dw,dh);
	}

	public void setSize( int dw, int dh)
	{
		w = dw>0 ? dw : 0;
		h = dh>0 ? dh : 0;
		super.setSize(dw,dh);
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

    public void paint(Graphics g)
    {
		if(orient==JAPI_Const.J_HORIZONTAL)
		{
			if(style==JAPI_Const.J_LINEUP)
			{
				g.setColor(Color.white);
	 			g.drawLine(0,h/2-1,w,h/2-1);
				g.setColor(Color.darkGray);
	 			g.drawLine(0,h/2,w,h/2);
			}
			else
			{
				g.setColor(Color.darkGray);
	 			g.drawLine(0,h/2-1,w,h/2-1);
				g.setColor(Color.white);
	 			g.drawLine(0,h/2,w,h/2);
			}
		}
		else  //J_VERTICAL
		{
			if(style==JAPI_Const.J_LINEUP)
			{
				g.setColor(Color.white);
	 			g.drawLine(w/2-1,0,w/2-1,h);
				g.setColor(Color.darkGray);
	 			g.drawLine(w/2,0,w/2,h);
			}
			else
			{
				g.setColor(Color.darkGray);
	 			g.drawLine(w/2-1,0,w/2-1,h);
				g.setColor(Color.white);
	 			g.drawLine(w/2,0,w/2,h);
			}
		}
	}
}
