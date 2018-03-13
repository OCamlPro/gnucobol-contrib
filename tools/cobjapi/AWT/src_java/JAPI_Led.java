/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Led.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Led.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Led.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Led.java
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

public class JAPI_Led extends JAPI_ValueComponent
{

	private Color off;
    private int form;
    private boolean on=false;

    public JAPI_Led (int f, Color c)
    {
		if(f==JAPI_Const.J_RECT)
			super.setSize(20,15);
		else
			super.setSize(15,15);
		this.setForeground(c);
		this.form=f;
    }

    public void setState(boolean b)
    {
	    if(b!=this.on)
	    {
	    	this.on = b;
	        paint(getGraphics());
        }
        value=0;
    	if(this.on) value=255;
    }

    public boolean getState()
    {
		return(on);
	}

	public void setForeground(Color c)
	{
		super.setForeground(c);
 		off=new Color(c.getRed()/3,c.getGreen()/3,c.getBlue()/3);
        paint(getGraphics());
 	}

   	public void update(Graphics g)
	{
		paint(g);
	}

    public void paint(Graphics g)
    {
 		Dimension d = super.getSize();

        if(isShowing())
        	if(form==JAPI_Const.J_RECT)
        	{
        		g.setColor(off);
				g.draw3DRect(0,0,d.width-1,d.height-1,true);
				g.draw3DRect(1,1,d.width-3,d.height-3,true);
        		if (on)
        		    g.setColor(getForeground());
        		else
        		    g.setColor(off);
				g.fillRect(2,2,d.width-4,d.height-4);
  	    	  	g.setColor(Color.black);
  	    	  	g.drawRect(0,0,d.width,d.height);
			}
			else
			{
 				g.setColor(off);
  	    	  	g.fillOval(0,0,d.width-1,d.height-1);
  	    	  	g.setColor(Color.black);
  	    	  	g.drawOval(0,0,d.width-1,d.height-1);

	        	if (on)
	        	    g.setColor(getForeground());
	        	else
	        	    g.setColor(off);

				g.fillOval(2,2,d.width-5,d.height-5);

	       		g.setColor(Color.white);
				g.fillOval(d.width/4,d.height/4,3,3);
		    }
	}
}

