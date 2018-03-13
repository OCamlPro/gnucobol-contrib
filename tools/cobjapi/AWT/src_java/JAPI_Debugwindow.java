/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Debugwindow.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Debugwindow.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Debugwindow.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Debugwindow.java
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

public class JAPI_Debugwindow extends Frame implements WindowListener
{
	int level=0;
	int zeilen=0;
	Frame frame;
	TextArea text;

	public JAPI_Debugwindow(int l)
	{
		super("JAPI Debug Window");
		setLayout(new BorderLayout());
		text = new TextArea(25,80);
		add(text,"Center");
		pack();
		setlevel(l);
		addWindowListener(this);
	}

	public void setlevel(int l)
	{
		level = l;
		if(level > 0)
			this.setVisible(true) ;
		else
			this.setVisible(false) ;
	}

	public void println(String s)
	{
		zeilen++;
		text.append(zeilen+": "+s+"\n");
	}

	public void windowClosing(WindowEvent e)
	{
		System.exit(0);
	}
	public void windowOpened(WindowEvent e)
	{	}
	public void windowClosed(WindowEvent e)
	{	}
	public void windowIconified(WindowEvent e)
	{	}
	public void windowDeiconified(WindowEvent e)
	{	}
	public void windowActivated(WindowEvent e)
	{	}
	public void windowDeactivated(WindowEvent e)
	{	}
}
