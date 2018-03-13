/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_HFlowlayout.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_HFlowlayout.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_HFlowlayout.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_HFlowlayout.java
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

//public class JAPI_HFlowlayout implements LayoutManager
public class JAPI_HFlowlayout extends FlowLayout
{

    public static final int LEFT 		= 0;
    public static final int CENTER 		= 1;
    public static final int RIGHT 		= 2;
    public static final int TOP 		= 3;
    public static final int BOTTOM 		= 4;
    public static final int TOPLEFT 	= 5;
    public static final int TOPRIGHT 	= 6;
    public static final int BOTTOMLEFT 	= 7;
    public static final int BOTTOMRIGHT = 8;

    int align=1;
    int orient=3;
    int hgap=5;
    int vgap=5;
	boolean fill=false;
	
    public JAPI_HFlowlayout() 
    {
		this(5, 5);
		setAlignment(TOP);
    }
    public JAPI_HFlowlayout(int align) 
    {
		this(5, 5);
		setAlignment(align);
    }

    public JAPI_HFlowlayout(int hgap, int vgap) 
    {
		this.hgap = hgap;
		this.vgap = vgap;
		setAlignment(align);		
    }

	public void setHgap(int gap)
	{
		this.hgap=gap;
	}
	
	public void setVgap(int gap)
	{
		this.vgap=gap;
	}
	public void setFill(boolean b)
	{
		this.fill=b;
	}

	public void setAlignment(int a)
	{
		switch(a)
		{
			case(TOPLEFT)      : this.align=LEFT; 
								 this.orient=TOP;
								 break;
			case(TOP)          : this.align=CENTER; 
								 this.orient=TOP;
								 break;
			case(TOPRIGHT)     : this.align=RIGHT; 
								 this.orient=TOP;
								 break;
			case(LEFT)         : this.align=LEFT; 
								 this.orient=CENTER;
								 break;
			case(CENTER)       : this.align=CENTER; 
								 this.orient=CENTER;
								 break;
			case(RIGHT)        : this.align=RIGHT; 
								 this.orient=CENTER;
								 break;
			case(BOTTOMLEFT)   : this.align=LEFT; 
								 this.orient=BOTTOM;
								 break;
			case(BOTTOM)       : this.align=CENTER; 
								 this.orient=BOTTOM;
								 break;
			case(BOTTOMRIGHT)  : this.align=RIGHT; 
								 this.orient=BOTTOM;
								 break;
			default            : this.align=CENTER;
								 this.orient=TOP;
		}
	}

	public void setOrientation(int a)
	{
		this.orient=a;
	}

    public void addLayoutComponent(String name, Component comp)  {}

    public void removeLayoutComponent(Component comp)            {}

    public Dimension preferredLayoutSize(Container target) 
    {
		Dimension dim = new Dimension(0, 0);
		int nmembers = target.getComponentCount();

		for (int i = 0 ; i < nmembers ; i++) 
		{
	    	Component m = target.getComponent(i);
	    	if (m.isVisible()) 
	    	{
				Dimension d = m.getPreferredSize();
				dim.height = Math.max(dim.height, d.height);
				if (i > 0) 
				    dim.width += hgap;
				dim.width += d.width;
		    }
		}
		Insets insets = target.getInsets();
		dim.width  += insets.left + insets.right;
		dim.height += insets.top + insets.bottom;
		return dim;
    }

 	public Dimension minimumLayoutSize(Container target) 
 	{
		Dimension dim = new Dimension(0, 0);
		int nmembers = target.getComponentCount();

		for (int i = 0 ; i < nmembers ; i++) 
		{
	    	Component m = target.getComponent(i);
	    	if (m.isVisible()) 
	    	{
				Dimension d = m.getMinimumSize();
				dim.height = Math.max(dim.height, d.height);
				if (i > 0) 
				    dim.width += hgap;
				dim.width += d.width;
		    }
		}
		Insets insets = target.getInsets();
		dim.width += insets.left + insets.right;
		dim.height += insets.top + insets.bottom;
		return dim;
    }

    public void layoutContainer(Container target) 
    {
		Insets insets = target.getInsets();
		int maxheight = target.getSize().height - (insets.top  + insets.bottom);
		int maxwidth  = target.getSize().width  - (insets.left + insets.right );
		int nmembers  = target.getComponentCount();
		int sumx,sumy,starti = 0;
		int height=0,row=0;
			
		int i,x=0,y=0;
		
		if(this.fill)
		{	
			sumx=0;
			for (i = 0 ; i < nmembers ; i++) 
			{
		    	Component m = target.getComponent(i);
		    	if (m.isVisible()) 
		    	{
					Dimension d = m.getPreferredSize();
			    	sumx += d.width + hgap;
				}
			}
			if(sumx>0)
				sumx-=hgap;
		
			if(this.align==LEFT)
				x=insets.left;
			if(this.align==CENTER)
				x=insets.left + (maxwidth - sumx)/2;
			if(this.align==RIGHT)
				x=insets.left + maxwidth - sumx;
				
			for ( i = 0 ; i < nmembers ; i++) 
			{
		    	Component m = target.getComponent(i);
		    	if (m.isVisible()) 
		    	{
					Dimension d = m.getPreferredSize();
			    	m.setBounds(x, insets.top, d.width, maxheight);
			    	x += d.width + hgap;
				}
			}			
		}
		
		else
				//  NOFILL
		{	
			int xpos[] = new int[nmembers];
			int ypos[] = new int[nmembers];
			int ymax[] = new int[nmembers];
			int xmax[] = new int[nmembers];
			
			int rowh=0,roww=0;
			int sumh=0,sumw=0;
			
			starti=0;
			for ( i = 0 ; i < nmembers ; i++) 
			{
		    	Component m = target.getComponent(i);
		    	if (m.isVisible()) 
		    	{
					Dimension d = m.getPreferredSize();
					
					if(roww + d.width <= maxwidth)
					{
						rowh =  Math.max(rowh, d.height);
						xpos[i] = roww;
						ypos[i] = sumh;
						roww += d.width+hgap;
						sumw += d.width+hgap;
					}
					else
					{
						sumh += rowh+vgap;
						for(int k=starti;k<i;k++)
						{
							ymax[k]=rowh;
							xmax[k]=sumw-hgap;
						}
						roww=d.width+hgap;
						rowh=d.height;
						sumw=d.width+hgap;
						xpos[i] = 0;
						ypos[i] = sumh;
						starti=i;
					}
				}
			}
			sumh += rowh;
			for(int k=starti;k<i;k++)
			{
				ymax[k]=rowh;
				xmax[k]=sumw-hgap;
			}
			
			for ( i = 0 ; i < nmembers ; i++) 
			{
				Component m = target.getComponent(i);
				if (m.isVisible()) 
				{
					Dimension d = m.getPreferredSize();
					if(this.orient == TOP)
						y=ypos[i] + insets.top;
					if(this.orient == BOTTOM)
						y=ypos[i] + insets.top + maxheight - sumh + ymax[i] - d.height;
					if(this.orient == CENTER)
						y=ypos[i] + insets.top + maxheight/2 - sumh/2 + ymax[i]/2 - d.height/2;
					if(this.align == LEFT)
						x=xpos[i] + insets.left;
					if(this.align == RIGHT)
						x=xpos[i] + insets.left + maxwidth - xmax[i];
					if(this.align == CENTER)
						x=xpos[i] + insets.left + maxwidth/2 - xmax[i]/2;
						
					m.setBounds(x, y, d.width, d.height);
				}
				
			}
		}
  	}
    
    public String toString() 
    {
		String str = "";
		switch (align) 
		{
	  		case LEFT:    str = ",align=left"; break;
	  		case CENTER:  str = ",align=center"; break;
	  		case RIGHT:   str = ",align=right"; break;
		}
		return getClass().getName() + "[hgap=" + hgap + ",vgap=" + vgap + str + "]";
    }
}
