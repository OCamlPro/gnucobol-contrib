/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Graphicbutton.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Graphicbutton.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Graphicbutton.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Graphicbutton.java
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
import java.net.*;

public class JAPI_Graphicbutton extends Canvas
{
  	// Charakteristische Groessen des Buttons
  	private boolean pressed;
  	private boolean mousein;

   	private Image picture;  // Bild des Buttons
   	private Color bgc = new Color(0);
   	private Dimension prefSize = new Dimension(0,0);

	private JAPI_SocketOutputStream JAPI_actionstream;
	private int JAPI_id;

  	public JAPI_Graphicbutton(String filename, String host, int port, int id, JAPI_SocketOutputStream action)
  	throws MalformedURLException
  	{
    	pressed = false;
     	mousein = false;

        picture = Toolkit.getDefaultToolkit().getImage(new URL("http",host,port,filename));

    	MediaTracker tracker = new MediaTracker(this);
    	tracker.addImage(picture, 0);
    	try {tracker.waitForID(0);} catch(InterruptedException e) {System.err.println("Error: "+e);}

	    prefSize.width  = picture.getWidth(this) + 6;
     	prefSize.height = picture.getHeight(this)+ 6;

  		this.setSize( prefSize.width, prefSize.height);

 		JAPI_actionstream = action;
 		JAPI_id = id;

        bgc = Color.lightGray;
		enableEvents(AWTEvent.MOUSE_EVENT_MASK);   	
	} 

	public void setImage(Image img)
	{
		picture=img;
        paint(getGraphics());
	}

	public void setSize(int width, int height)
	{
    	prefSize = new Dimension(width, height);
 		super.setSize(prefSize.width, prefSize.height);
	}

	public Dimension getPreferredSize()
	{
    	return prefSize;
  	}

  	public Dimension getMinimumSize()
  	{
    	return prefSize;
  	}

 	public void setEnabled(boolean b)
	{
		bgc=Color.lightGray;
        super.setEnabled(b);
        paint(getGraphics());
	}

 	public void paint(Graphics g)
  	{
        g.setColor(bgc);

   		// Ist Button gedrueckt und Maus im Button
    	if (pressed && mousein)
		{
  		   	g.draw3DRect(0, 0, prefSize.width, prefSize.height, false);
      		g.fill3DRect(1, 1, prefSize.width-1, prefSize.height-1, false);
      		g.drawImage(picture, 4, 4, prefSize.width-6, prefSize.height-6, this);
    	}
		else
		{
    		g.draw3DRect(0, 0, prefSize.width, prefSize.height, true);
      		g.fill3DRect(1, 1, prefSize.width-1, prefSize.height-1, true);
      		g.drawImage(picture, 3, 3, prefSize.width-6, prefSize.height-6, this);
 		}
   	}


	protected void processMouseEvent(MouseEvent event) 
	{
		super.processMouseEvent(event); 
		switch (event.getID()) 
		{
		case MouseEvent.MOUSE_ENTERED:	mousein = true;    // Maus innerhalb des Buttons
										break;
		case MouseEvent.MOUSE_EXITED:	mousein = false;    // Maus innerhalb des Buttons
										break;
		case MouseEvent.MOUSE_PRESSED: 	pressed = true;    // Button gedrueckt
										break;
		case MouseEvent.MOUSE_RELEASED: pressed = true;    // Button gedrueckt
									   	if (pressed)
										{
									 		try
											{
												JAPI_actionstream.sendInt(JAPI_id);
											}catch(IOException exce) {}
									  	    pressed = false; // Button nicht mehr gedrueckt
										}
										break;
		}
	    repaint();         // Button neu zeichnen

	}


}



