/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Sevensegment.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Sevensegment.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Sevensegment.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Sevensegment.java
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
import java.awt.event.*;
import java.io.*;
import java.util.*;


public class JAPI_Sevensegment extends JAPI_ValueComponent
{
	private Color fg[];
   	private int code[][]={	{1,1,0,1,1,1,1},
    						{0,0,0,1,0,0,1},
					    	{1,0,1,1,1,1,0},
					    	{1,0,1,1,0,1,1},
					    	{0,1,1,1,0,0,1},
					    	{1,1,1,0,0,1,1},
					    	{1,1,1,0,1,1,1},
					    	{1,0,0,1,0,0,1},
					    	{1,1,1,1,1,1,1},
					    	{1,1,1,1,0,1,1},
					    	{1,1,1,1,1,0,1},
					    	{0,1,1,0,1,1,1},
					    	{1,1,0,0,1,1,0},
					    	{0,0,1,1,1,1,1},
					    	{1,1,1,0,1,1,0},
					    	{1,1,1,0,1,0,0}};


  	public JAPI_Sevensegment(Color c)
  	{
		super.setSize(20,40);
	   	fg = new Color[2];
	   	super.setBackground(Color.black);
    	this.setForeground(c);
  	}

	public void setForeground(Color c)
	{
		super.setForeground(c);
	    fg[1] = c;
	    fg[0] = new Color((9*getBackground().getRed()+c.getRed())/10,
	    				  (9*getBackground().getGreen()+c.getGreen())/10,
	    				  (9*getBackground().getBlue()+c.getBlue())/10);
	}

	public void setBackground(Color c)
	{
		super.setBackground(c);
	    fg[0] = new Color((9*getBackground().getRed()+fg[1].getRed())/10,
	    				  (9*getBackground().getGreen()+fg[1].getGreen())/10,
	    				  (9*getBackground().getBlue()+fg[1].getBlue())/10);
	}

  	public void setValue(int e)
  	{
  		e=e%16;
  		if(e!=value)
  		{
  			super.setValue(e);
  			repaint();
		}
  	}

  	public void paint(Graphics g)
  	{
  		double pwgt=0.12;
 		Dimension d = super.getSize();
		int wgt= (int)(pwgt*(d.height/2)<pwgt*d.width ? pwgt*(d.height/2) : pwgt*d.width);
		int border = wgt;
		int lsep = wgt/10+2;
     	int sw = d.width-(border+border);
    	int sh = d.height-(border+border);
      	int hlen = sw-wgt;
       	int vlen = (sh-wgt)/2;

      	/* horizontal */
	    Polygon p = new Polygon();

	    p.addPoint(border+wgt/2+lsep,border+wgt/2+1);
	    p.addPoint(border+wgt+lsep,border);
	    p.addPoint(border+hlen-lsep,border);
	    p.addPoint(border+hlen+wgt/2-lsep,border+wgt/2+1);
	    p.addPoint(border+hlen-lsep,border+wgt+1);
	    p.addPoint(border+wgt+lsep,border+wgt+1);

	    g.setColor(fg[code[value][0]]);
	    g.fillPolygon(p);

	    g.setColor(fg[code[value][2]]);
	    p.translate(0,vlen-1);
	    g.fillPolygon(p);

	    g.setColor(fg[code[value][5]]);
	    p.translate(0,vlen-1);
	    g.fillPolygon(p);

      	/* vertical */
    	p = new Polygon();

	    p.addPoint(border+wgt/2+1,border+wgt/2+lsep);
    	p.addPoint(border,border+wgt+lsep);
    	p.addPoint(border,border+vlen-lsep);
    	p.addPoint(border+wgt/2+1,border+vlen+wgt/2-lsep);
    	p.addPoint(border+wgt+1,border+vlen-lsep);
    	p.addPoint(border+wgt+1,border+wgt+lsep);

    	g.setColor(fg[code[value][1]]);
    	g.fillPolygon(p);

    	g.setColor(fg[code[value][3]]);
    	p.translate(hlen-1,0);
    	g.fillPolygon(p);

    	g.setColor(fg[code[value][6]]);
    	p.translate(0,vlen-1);
    	g.fillPolygon(p);

    	g.setColor(fg[code[value][4]]);
    	p.translate(-(hlen-1),0);
    	g.fillPolygon(p);
  }
}


