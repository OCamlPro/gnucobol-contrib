/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Frame.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Frame.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Frame.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Frame.java
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
//import javax.swing.*;
import java.io.*;

public class JAPI_Frame extends Frame
{
	Insets inset;
	boolean resizable=true;

	public JAPI_Frame(String title)
	{
		super(title);
		addNotify();   // WICHTIG !!!!
		super.setLayout(new JAPI_Fixlayout());
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

/*	public void disable()
	{
		int i;
		for(i=0;i<getComponentCount();i++)
			getComponent(i).setEnabled(false);
		if(getMenuBar() != null)
			((JAPI_Menubar)getMenuBar()).disable();
	}

	public void enable()
	{
		int i;
 		for(i=0;i<getComponentCount();i++)
			getComponent(i).setEnabled(true);
		if(getMenuBar() != null)
			((JAPI_Menubar)getMenuBar()).enable();
	}
*/
	public void setEnable(boolean b)
	{
		int i;
 		for(i=0;i<getComponentCount();i++)
			getComponent(i).setEnabled(b);
		if(getMenuBar() != null)
			((JAPI_Menubar)getMenuBar()).setEnabled(b);
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

    public void setBackground(Color c)
    {
    	super.setBackground(c);
		int i;
 		for(i=0;i<getComponentCount();i++)
			getComponent(i).setBackground(c);
		// menus haben keine Funktionen zum Setzen der Farben
    }

    public void setFont(Font f)
    {
		int i;
   		super.setFont(f);
		for(i=0;i<getComponentCount();i++)
//			if(getComponent(i).getPeer() != null)
			if(getComponent(i).isDisplayable())
				getComponent(i).setFont(f);
		if(getMenuBar() != null)
			((JAPI_Menubar)getMenuBar()).setFont(f);
   }
}
