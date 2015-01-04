/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Fixlayout.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Fixlayout.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Fixlayout.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Fixlayout.java
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
import java.util.Hashtable;

public class JAPI_Fixlayout implements LayoutManager
{
    private Hashtable hash = new Hashtable();
    int hgap=5;
    int vgap=5;
	Insets oldinsets;
	
    public int getHgap()
    {
		return hgap;
    }
    public int getVgap()
    {
		return vgap;
    }

    public void setHgap(int hgap)
    {
		this.hgap = hgap;
    }
    public void setVgap(int vgap)
    {
		this.vgap = vgap;
    }

    public void addLayoutComponent(String s, Component comp)
    {}

    public void removeLayoutComponent(Component comp)
    {}

    public Dimension preferredLayoutSize(Container target)
    {
        Insets    insets  = target.getInsets();
        Dimension dim     = new Dimension(0,0);
        Rectangle size    = new Rectangle(0,0);

        for (int i = 0 ; i < target.getComponentCount() ; i++)
        {
            Component comp = target.getComponent(i);

            if(comp.isVisible())
            {
		        Dimension d = comp.getSize();
                Rectangle compSize = new Rectangle(comp.getLocation());
   	            compSize.setSize(d.width, d.height);
                size = size.union(compSize);
            }
        }
        dim.width  += size.width + insets.right + hgap;
        dim.height += size.height + insets.bottom + vgap;

        return dim;
    }


    public Dimension minimumLayoutSize(Container target)
    {

        Insets    insets      = target.getInsets();
        Dimension dim         = new Dimension(0,0);
        Rectangle minBounds   = new Rectangle(0,0);

        for (int i = 0 ; i < target.getComponentCount() ; i++)
        {
            Component comp = target.getComponent(i);

            if(comp.isVisible())
            {
                Dimension d = comp.getMinimumSize();
                Rectangle compMinBounds = new Rectangle(comp.getLocation());
  	            compMinBounds.setSize(d.width, d.height);
                minBounds = minBounds.union(compMinBounds);
            }
        }
        dim.width  += minBounds.width  + insets.right + hgap;
        dim.height += minBounds.height + insets.bottom + vgap;

        return dim;
    }


    public void layoutContainer(Container target)
    {
           
       int       ncomponents = target.getComponentCount();
       
       for (int i = 0 ; i < ncomponents ; i++)
       {
            Component comp = target.getComponent(i);

            if(comp.isVisible())
            {
                Dimension sz   = comp.getSize();
				Dimension ps   = comp.getPreferredSize();
                Point     loc  = comp.getLocation();

				if(sz.width < ps.width || sz.height < ps.height)
					sz = ps;
                comp.setBounds(loc.x, loc.y, sz.width, sz.height);
            }
        }
	}

}
