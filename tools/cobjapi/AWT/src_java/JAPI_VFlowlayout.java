/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_VFlowlayout.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_VFlowlayout.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_VFlowlayout.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_VFlowlayout.java
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

//public class JAPI_VFlowlayout implements LayoutManager
public class JAPI_VFlowlayout extends FlowLayout
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

    int halign = CENTER;
    int valign = TOP;
    int hgap=5;
    int vgap=5;
	boolean fill=false;

    public JAPI_VFlowlayout()
    {
		this(5, 5);
		setAlignment(TOP);
    }
    public JAPI_VFlowlayout(int align)
    {
		this(5, 5);
		setAlignment(align);
    }

    public JAPI_VFlowlayout(int hgap, int vgap)
    {
		this.hgap = hgap;
		this.vgap = vgap;
		setAlignment(TOP);
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
			case(TOPLEFT)      : this.halign=LEFT;
								 this.valign=TOP;
								 break;
			case(TOP)          : this.halign=CENTER;
								 this.valign=TOP;
								 break;
			case(TOPRIGHT)     : this.halign=RIGHT;
								 this.valign=TOP;
								 break;
			case(LEFT)         : this.halign=LEFT;
								 this.valign=CENTER;
								 break;
			case(CENTER)       : this.halign=CENTER;
								 this.valign=CENTER;
								 break;
			case(RIGHT)        : this.halign=RIGHT;
								 this.valign=CENTER;
								 break;
			case(BOTTOMLEFT)   : this.halign=LEFT;
								 this.valign=BOTTOM;
								 break;
			case(BOTTOM)       : this.halign=CENTER;
								 this.valign=BOTTOM;
								 break;
			case(BOTTOMRIGHT)  : this.halign=RIGHT;
								 this.valign=BOTTOM;
								 break;
			default            : this.halign=CENTER;
								 this.valign=TOP;
		}
	}

	public void setOrientation(int a)
	{
		this.valign=a;
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
				dim.width = Math.max(dim.width, d.width);
				if (i > 0)
				    dim.height += vgap;
				dim.height += d.height;
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
				dim.width = Math.max(dim.width, d.width);
				if (i > 0)
				    dim.height += vgap;
				dim.height += d.height;
		    }
		}
		Insets insets = target.getInsets();
		dim.width += insets.left + insets.right + hgap*2;
		dim.height += insets.top + insets.bottom + vgap*2;
		return dim;
    }


    public void layoutContainer(Container target)
    {
		Insets insets = target.getInsets();
		int maxheight = target.getSize().height - (insets.top  + insets.bottom);
		int maxwidth  = target.getSize().width  - (insets.left + insets.right);
		int nmembers  = target.getComponentCount() ;
		int sumx,sumy,starti = 0;
		int height=0,row=0;

		int i,x=0,y=0;

		if(this.fill)
		{
			sumy=0;
			for (i = 0 ; i < nmembers ; i++)
			{
		    	Component m = target.getComponent(i);
		    	if (m.isVisible())
		    	{
					Dimension d = m.getPreferredSize();
			    	sumy += d.height + vgap;
				}
			}
			if(sumy>0)
				sumy-=vgap;

			if(this.valign==TOP)
				y=insets.top;
			if(this.valign==CENTER)
				y=insets.top + (maxheight - sumy)/2;
			if(this.valign==BOTTOM)
				y=insets.top + maxheight - sumy;

			for ( i = 0 ; i < nmembers ; i++)
			{
		    	Component m = target.getComponent(i);
		    	if (m.isVisible())
		    	{
					Dimension d = m.getPreferredSize();
//			    	m.reshape(insets.left, y, maxwidth, d.height);
					m.setBounds(insets.left, y, maxwidth, d.height);
			    	y += d.height + vgap;
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

					if(rowh + d.height <= maxheight)
					{
						roww =  Math.max(roww, d.width);
						xpos[i] = sumw;
						ypos[i] = rowh;
						rowh += d.height+vgap;
						sumh += d.height+vgap;
					}
					else
					{
						sumw += roww+hgap;
						for(int k=starti;k<i;k++)
						{
							ymax[k]=sumh-vgap;
							xmax[k]=roww;
						}
						rowh=d.height+vgap;
						roww=d.width;
						sumh=d.height+vgap;
						ypos[i] = 0;
						xpos[i] = sumw;
						starti=i;
					}
				}
			}
			sumw += roww;
			for(int k=starti;k<i;k++)
			{
				xmax[k]=roww;
				ymax[k]=sumh-vgap;
			}

			for ( i = 0 ; i < nmembers ; i++)
			{
				Component m = target.getComponent(i);
				if (m.isVisible())
				{
					Dimension d = m.getPreferredSize();
					if(this.valign == TOP)
						y=ypos[i] + insets.top;
					if(this.valign == BOTTOM)
						y=ypos[i] + insets.top + maxheight - ymax[i];
					if(this.valign == CENTER)
						y=ypos[i] + insets.top + maxheight/2 - ymax[i]/2;
					if(this.halign == LEFT)
						x=xpos[i] + insets.left;
					if(this.halign == RIGHT)
						x=xpos[i] + insets.left + maxwidth - sumw + xmax[i] - d.width;
					if(this.halign == CENTER)
						x=xpos[i] + insets.left + maxwidth/2 - sumw/2 + xmax[i]/2 - d.width/2;

//					m.reshape(x, y, d.width, d.height);
					m.setBounds(x, y, d.width, d.height);
				}

			}
		}
  	}

    public String toString()
    {
		String str = "";
		switch (halign)
		{
	  		case LEFT:    str = ",halign=left"; break;
	  		case CENTER:  str = ",halign=center"; break;
	  		case RIGHT:   str = ",halign=right"; break;
		}
		return getClass().getName() + "[hgap=" + hgap + ",vgap=" + vgap + str + "]";
    }
}
