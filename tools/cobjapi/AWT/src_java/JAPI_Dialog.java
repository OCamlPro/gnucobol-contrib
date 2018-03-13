/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Dialog.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Dialog.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Dialog.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Dialog.java
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

public class JAPI_Dialog extends Dialog
{
	Insets inset;
	boolean resizable=true;

	public JAPI_Dialog(Frame parent,String title)
	{
		super(parent,title,false);
		addNotify();   // WICHTIG (win32 jdk1.1) !!!!
		this.setLayout(new JAPI_Fixlayout());
	}

	public void setResizable(boolean set)
	{
		resizable=set;
		repaint(-1);
	}

	public void paint(Graphics g)
	{
	    if(isResizable()!=resizable)
	    	super.setResizable(resizable);
	}
/*
	public void disable()
	{
		for(int i=0;i<getComponentCount();i++)
			getComponent(i).disable();
	}

	public void enable()
	{
 		for(int i=0;i<getComponentCount();i++)
			getComponent(i).enable();
	}
*/
	public void setEnabled(boolean b)
	{
 		for(int i=0;i<getComponentCount();i++)
			getComponent(i).setEnabled(b);
	}
	public void setInsets(int t, int b, int l, int r)
	{
		inset = new Insets(t,l,b,r);
	}

	public Insets getInsets()
	{
		if(inset != null)
			return(inset);
		else
			return(super.getInsets());
	}

    public void setFont(Font f)
    {
   		super.setFont(f);
		for(int i=0;i<getComponentCount();i++)
//			if(getComponent(i).getPeer() != null)
			if(getComponent(i).isDisplayable())
				getComponent(i).setFont(f);
    }

    public void setBackground(Color c)
    {
    	super.setBackground(c);
 		for(int i=0;i<getComponentCount();i++)
			getComponent(i).setBackground(c);
    }

}
