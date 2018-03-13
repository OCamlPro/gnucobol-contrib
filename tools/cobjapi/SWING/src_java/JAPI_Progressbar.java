/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Progressbar.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Progressbar.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Progressbar.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Progressbar.java
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

public class JAPI_Progressbar extends JAPI_ValueComponent
{
	private int orient;
	 public JAPI_Progressbar(int o)
    {
        setFont(new Font("Dialog", Font.PLAIN, 12));
		super.setSize(100,20);
		orient=o;
		setForeground(Color.blue);
	//	setBackground(Color.lightGray);
	}

    public void setValue(int v)
    {
		super.setValue(v);
    	repaint();
    }

   	public void paint(Graphics g)
    {
		Dimension d = super.getSize();
		int val;

		g.setColor(Color.gray);
		g.draw3DRect(0,0,d.width-1,d.height-1,false);

 		if(orient==0)
			val=(d.width-4)*(value-min)/(max-min);
		else
			val=(d.height-4)*(value-min)/(max-min);

		g.setColor(getForeground());
		if(orient==0)
	    	g.fillRect(2,2,val,d.height-4);
	    else
	    	g.fillRect(2,d.height-val,d.width-4,val-2);

 		g.setColor(getBackground());
	    g.drawString(Integer.toString(value),
    		d.width/2-g.getFontMetrics(g.getFont()).stringWidth(Integer.toString(value))/2,
    		d.height/2+g.getFontMetrics(g.getFont()).getHeight()/2-1);

		if(orient==0)
	    	g.fillRect(val,2,d.width-4,d.height-4);
    	else
    		g.fillRect(2,2,d.width-4,d.height-2-val);

 		g.setColor(getForeground());
		if(orient==0)
		    g.clipRect(val,0,d.width,d.height);
		else
			g.clipRect(0,0,d.width,d.height-val);
			g.drawString(Integer.toString(value),
    		d.width/2 -g.getFontMetrics(g.getFont()).stringWidth(Integer.toString(value))/2,
    		d.height/2+g.getFontMetrics(g.getFont()).getAscent()/2-1);

//		g.clipRect(0,0,d.width,d.height);
  	}



    public void update(Graphics g)
    {
        paint(g);
    }
}
