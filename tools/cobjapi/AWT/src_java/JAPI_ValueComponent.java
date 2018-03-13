/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_ValueComponent.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_ValueComponent.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_ValueComponent.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_ValueComponent.java
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

public class JAPI_ValueComponent extends Canvas
{
	int w=0,h=0;
	int min=0, max=100;
  	int value=0;

    public JAPI_ValueComponent ()
	{}

    public void setValue(int v)
    {
	    this.value = v<min?min:v>max?max:v;
    }

    public int getValue()
    {
	    return(value);
    }

   	public void setMinimum(int m)
   	{
		min=m;
	}

   	public void setMaximum(int m)
   	{
		max=m;
	}

   	public int getMinimum(int m)
   	{
		return(min);
	}

   	public int getMaximum(int m)
   	{
		return(max);
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
		return(getPreferredSize());
	}

}
