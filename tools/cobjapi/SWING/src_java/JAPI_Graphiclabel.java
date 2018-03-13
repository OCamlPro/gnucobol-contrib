/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Graphiclabel.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Graphiclabel.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Graphiclabel.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Graphiclabel.java
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
import java.net.*;

public class JAPI_Graphiclabel extends Label
{
  	Image picture=null;
 	private Dimension prefSize = new Dimension(0,0);

  	public JAPI_Graphiclabel(String filename, String host, int port)
  	throws MalformedURLException
  	{
        picture = Toolkit.getDefaultToolkit().getImage(new URL("http",host,port,filename));
    	MediaTracker tracker = new MediaTracker(this);
    	tracker.addImage(picture, 0);
 		try {tracker.waitForAll();} catch(InterruptedException e) {}
 		this.setSize(picture.getWidth(this), picture.getHeight(this));
	}

  	// used by JAPI_Alert, JAPI_Error
  	public JAPI_Graphiclabel(String filename)
  	{
        picture = Toolkit.getDefaultToolkit().getImage(getClass().getResource(filename));
     	MediaTracker tracker = new MediaTracker(this);
    	tracker.addImage(picture, 0);
    	try {tracker.waitForID(0);} catch(InterruptedException e) {System.err.println("Error: "+e);}
   		this.setSize(picture.getWidth(this), picture.getHeight(this));
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

  	public void paint(Graphics g)
	{
		// Einmal sollte genuegen, tut es aber manchmal nicht !
		if(isVisible())
		{
			g.drawImage(picture, 0, 0, prefSize.width, prefSize.height, this);
			g.drawImage(picture, 0, 0, prefSize.width, prefSize.height, this);
  		}
	}


}
