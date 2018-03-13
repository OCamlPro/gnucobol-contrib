/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Window.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Window.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Window.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Window.java
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
import java.io.*;

public class JAPI_Window extends Window
{
	Insets inset;

	public JAPI_Window(Frame parent)
	{
		super(parent); 
		this.setLayout(new JAPI_Fixlayout());
	}

/*	public void disable()
	{
		int i;
		for(i=0;i<getComponentCount();i++)
			getComponent(i).disable();
	}
     
	public void enable()
	{
		int i;
 		for(i=0;i<getComponentCount();i++)
			getComponent(i).enable();
	}
 */  
	public void setEnabled(boolean b)
	{
		int i;
 		for(i=0;i<getComponentCount();i++)
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
		int i;
   		super.setFont(f);
		for(i=0;i<getComponentCount();i++)
			if(getComponent(i).isDisplayable())
				getComponent(i).setFont(f);
    }    

    public void setBackground(Color c)
    {
    	super.setBackground(c);
		int i;
 		for(i=0;i<getComponentCount();i++)
			getComponent(i).setBackground(c);
		// menus haben keine Funktionen zum Setzen der Farben
    }
}
