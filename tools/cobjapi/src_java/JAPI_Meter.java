/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Meter.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Meter.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Meter.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Meter.java
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

public class JAPI_Meter extends JAPI_ValueComponent
{

  	private String title;
	private int danger=80;
    private int oldvalue=0;
  	private int yOffset;
  	private int xCenter;
  	private int yCenter;
  	private int radius;
	private double arc;

  	public JAPI_Meter (String t)
  	{
		super.setSize(100,100);
        setFont(new Font("Dialog", Font.PLAIN, 12));
		this.title   = t;
  	}

  	public void setTitle(String s)
  	{
  		title = s;
  		repaint();
  	}

  	public void setValue(int v)
  	{
		super.setValue(v);
  		if(oldvalue!=value)
    	{
    		Graphics g=getGraphics();
  			drawPointer(g,false);
    		oldvalue=value;
 			drawPointer(g,true);
	    	drawText(g);
  		}
 	}

   	public void setDanger(int m)
   	{
		danger=m;
	}

   	public int getDanger()
   	{
		return(danger);
	}

  	public void paint(Graphics g)
  	{
    	computeKeyValues();
    	drawFrame(g);
    	drawTics(g);
    	drawText(g);
    	drawPointer(g,true);
  	}

  	private void computeKeyValues ()
  	{
    	Dimension d = getSize();
    	xCenter = (int)(d.width / 2);
    	yOffset = (int)(d.height / 4);
    	yCenter = (int)(d.height - yOffset);

	   	radius = (int)(0.7*d.height);
	   	if((int)(0.4*d.width) < radius)
	 		arc = Math.asin((0.4*d.width)/radius);
	 	else
	 		arc = Math.PI/2.0;
  	}

	private void drawFrame(Graphics g)
	{
    	Dimension d = getSize();
		g.setColor(this.getForeground());
		g.drawRect(0,0,d.width-1,d.height-1);
 		g.setColor(getBackground());
		g.draw3DRect(1,1,d.width-3,d.height-3,false);
 		g.draw3DRect(2,2,d.width-5,d.height-5,false);
	}

  	private void drawTics(Graphics g)
  	{
	   	Dimension d = getSize();

        if(danger>min && danger<max)
        {
    		g.setColor(Color.red);
    		int langle = (int)Math.round(2*arc/Math.PI*180*(double)(max - danger)/
                                     (double)(max - min));

    		g.fillArc((int)(0.5*d.width-radius),
				      (int)(0.8*d.height-radius),
				      2*radius,2*radius,
                  	  (int)Math.round(90-arc/Math.PI*180),langle);
     		g.setColor(getBackground());

     		g.fillArc((int)(0.5*d.width-0.97*radius),
				      (int)(0.8*d.height-0.97*radius),
				      (int)(1.94*radius),(int)(1.94*radius),
                  	  (int)Math.round(90-arc/Math.PI*180)-10,langle+20);
        }

  		g.setColor(getForeground());
       	g.setClip((int)(0.5*d.width-Math.sin(arc)*radius),
                   (int)(0.1*d.height),
                   (int)(2*Math.sin(arc)*radius)+1,
             	   (int)(radius-Math.cos(arc)*radius)+1);

		g.drawOval((int)(0.5*d.width-radius),
				   (int)(0.8*d.height-radius),
				   2*radius,2*radius);
                       	g.setClip(0,0,d.width,d.height);
		g.fillOval(d.width/2-5,(int)(0.8*d.height)-5,10,10);

    	// Draw about 20 tick marks
    	double a=arc;
	   	int innerRadius = (int)(radius - (radius / 15));
     	int middleRadius = (int)(radius - (radius / 30));
    	for (int i=0; i<=20; i++, a -= (2*arc)/20)
    	{
      		int x1, x2, y1, y2;

      		x1 = (int)(0.5*d.width - Math.sin(a)*radius);
      		y1 = (int)(0.8*d.height - Math.cos(a)*radius);
     		if (i%5 == 0)
     		{
        		x2 = (int)(0.5*d.width - Math.sin(a)*innerRadius);
        		y2 = (int)(0.8*d.height - Math.cos(a)*innerRadius);
      		}
      		else
      		{
      		    x2 = (int)(0.5*d.width - Math.sin(a)*middleRadius);
        		y2 = (int)(0.8*d.height - Math.cos(a)*middleRadius);
      		}
      		g.drawLine(x1, y1, x2, y2);
    	}

  	}

  	private void drawText(Graphics g)
  	{
    	Dimension d = getSize();

    	int stringWidth = g.getFontMetrics().stringWidth(title);
    	int stringHeight =  g.getFontMetrics().getHeight();

     	g.setColor(getForeground());
    	g.drawString(title, (d.width - stringWidth) / 2,
    						(d.height / 2) + stringHeight);


    	stringWidth = g.getFontMetrics().stringWidth(String.valueOf(min));
    	g.drawString(String.valueOf(min),
    			(int)(0.5*d.width - Math.sin(arc)*0.8*radius  - stringWidth/2),
    			(int)(0.8*d.height - Math.cos(arc)*0.8*radius + stringHeight/2));

    	stringWidth = g.getFontMetrics().stringWidth(String.valueOf((int)(0.5*(max+min))));
    	g.drawString(String.valueOf((int)(0.5*(max+min))),
    			(int)(0.5*d.width - stringWidth/2),
    			(int)(0.8*d.height - 0.8*radius + stringHeight/2));

    	stringWidth = g.getFontMetrics().stringWidth(String.valueOf(max));
    	g.drawString(String.valueOf(max),
    			(int)(0.5*d.width + Math.sin(arc)*0.8*radius  - stringWidth/2),
    			(int)(0.8*d.height - Math.cos(arc)*0.8*radius + stringHeight/2));


 	}

  	private void drawPointer(Graphics g, boolean b)
  	{
	   	Dimension d = getSize();

     	double a = arc-((double)(oldvalue - min)
                  / (double)(max - min))*(2*arc);

      	int x = (int)(0.5*d.width -  Math.sin(a)*radius*0.9);
        int y = (int)(0.8*d.height - Math.cos(a)*radius*0.9);
		if(b)
			if(oldvalue<danger && danger>min)
		    	g.setColor(getForeground());
    		else
    			g.setColor(Color.red);
    	else
    		g.setColor(getBackground());

    	g.drawLine((int)(0.5*d.width),(int)(0.8*d.height),x,y);
    	g.setColor(Color.orange);
		g.fillOval(d.width/2-5,(int)(0.8*d.height)-5,10,10);
  	}
}


