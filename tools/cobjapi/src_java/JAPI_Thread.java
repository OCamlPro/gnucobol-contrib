/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Thread.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Thread.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Thread.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Thread.java
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
*>            - Set Frame to appear centred, regardless of the Monitor 
*>              resolution.
*>            - Set default system look and feel.
*>******************************************************************************
*/

import java.lang.*;
import java.awt.*;
import java.applet.*;
import java.awt.image.*;
import java.awt.event.*;
import java.io.*;
import java.net.*;
import java.math.*;
import javax.swing.*;

public class JAPI_Thread extends Thread
{

    //						S O N S T I G E S
    public static final int MAXOBJECT		=	65536;

    int debug=0;
		String clienthost;
    	int httpport;
    JAPI_Debugwindow debugwindow=null;
    JAPI_Errordialog errordialog=null;
  	JAPI_SocketInputStream in;
    JAPI_SocketOutputStream out,action;

	Object[] o = new Object[MAXOBJECT];;
	int objectcounter=0;
	boolean nextaction = true;

    Socket commandsock, actionsock;

	private int byte2int(byte[] buf, int off)
	{
		int val;

		val =              ((char)buf[off+3] & 0xff);
		val = (val << 8) | ((char)buf[off+2] & 0xff);
		val = (val << 8) | ((char)buf[off+1] & 0xff);
		val = (val << 8) | ((char)buf[off  ] & 0xff);

		return(val);
	}

	public JAPI_Thread(Socket cs, Socket as)
	{
     	commandsock = cs;
     	actionsock = as;
        try
        {
  	    	commandsock.setTcpNoDelay(false);
            actionsock.setTcpNoDelay(true);
        }catch(SocketException e) {}
        this.start();
	}

    public void run()
    {
/*        int debug=0;
		String clienthost;
    	int httpport;
    	JAPI_Debugwindow debugwindow=null;
    	JAPI_Errordialog errordialog=null;
  	    JAPI_SocketInputStream in;
        JAPI_SocketOutputStream out,action;

		Object[] o = new Object[MAXOBJECT];
		int objectcounter=0;
*/
 	    int command=0,cmdgroup,cmdmask,obj=0;
//		boolean nextaction = true;

        try
        {
            in = new JAPI_SocketInputStream(commandsock.getInputStream());
           	out = new JAPI_SocketOutputStream(commandsock.getOutputStream());
           	action = new JAPI_SocketOutputStream(actionsock.getOutputStream());

 			/* magic number for swap test */
			out.sendInt(1234);

			/* Debuglevel und window */
			o[0]=null;
			debug=in.recvInt();
            o[1] = new JAPI_Debugwindow(debug);
            debugwindow = (JAPI_Debugwindow)o[1];
            o[2] = new JAPI_Errordialog(debugwindow);
            errordialog = (JAPI_Errordialog)o[2];
            objectcounter=3;
            if(debug>0) debugwindow.println("Debug Level : "+debug);
            if(debug>0) debugwindow.println("Commandstream connected");
            if(debug>0) debugwindow.println("Actionstream  connected");


			/* Clienthost and HTTP Port */
			clienthost = in.readToLineEnd();
			httpport   = in.recvInt();
 			if(debug>0) debugwindow.println("Display   : "+clienthost);
			if(debug>0) debugwindow.println("HTTP Port : "+httpport);


			/* Command mask */
			cmdmask = ((1<<30)-1)<<10;

			/* Main loop */
            while(nextaction)
            {
                // read a line
                command = in.recvInt();
				if(debug>4) debugwindow.println("JAPI Command : "+command);

				cmdgroup =	command & cmdmask;

				// all JAPI calls have an object arg
	            obj = in.recvInt();
		    	if(debug>4) debugwindow.println("JAPI Object : "+obj);

				if((obj <= 0)||(obj >= objectcounter))
	           	  	if(!errordialog.getResult("Not a valid JAPI Object ID\nID = "+obj))
					{
						nextaction=false;
						continue;
					}

				switch(cmdgroup)
				{
				case(JAPI_Calls.JAPI_GRAPHICS):

					/* Set Foreground  RGB */
	                if (command == JAPI_Calls.JAPI_FOREGROUNDCOLOR)
	              	{
	             		byte[] b = new byte[3];
	             		in.recv(b,3);
	             		int red = (char)b[0] & 0xff;
	             		int gre = (char)b[1] & 0xff;
	             		int blu = (char)b[2] & 0xff;

	 					if(debug>3) debugwindow.println("Set Color in "+o[obj].toString()+" : "+red+" , "+gre+" , "+blu);

				        if(o[obj] instanceof Component)
							((Component)o[obj]).setForeground(new Color(red,gre,blu));
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).setColor(new Color(red,gre,blu));
						else if(o[obj] instanceof PrintJob)
    						((Graphics)o[obj+1]).setColor(new Color(red,gre,blu));
	                  	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_setcolor( ID , ... ) or j_setnamedcolor( ID , ... )\nID = "+o[obj].toString());
	                  	continue;
	                }


	                /* Draw Line */
	                if (command == JAPI_Calls.JAPI_DRAWLINE)
	              	{
	             		byte[] b = new byte[16];
	             		in.recv(b,16);
	               		int x1  = byte2int(b,0);
	               		int y1  = byte2int(b,4);
	               		int x2  = byte2int(b,8);
	               		int y2  = byte2int(b,12);

	 					if(debug>3) debugwindow.println("LINE in "+o[obj].toString()+"  "+x1+":"+y1+" to "+x2+":"+y2);
	 					if(o[obj] instanceof Component)
	 					{
	 						if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawLine(x1,y1,x2,y2);
							((Component)o[obj]).getGraphics().drawLine(x1,y1,x2,y2);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).drawLine(x1,y1,x2,y2);
						else if(o[obj] instanceof PrintJob)
    						((Graphics)o[obj+1]).drawLine(x1,y1,x2,y2+1);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_drawline( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	                /* Draw Polyline */
	                if (command == JAPI_Calls.JAPI_POLYLINE)
	              	{
						int i;
	               		int n   = in.recvInt();
	               		int[] x = new int[n];
	               		int[] y = new int[n];

	               		for(i=0;i<n;i++)
	               	        x[i] = in.recvInt();
	               		for(i=0;i<n;i++)
	               		    y[i] = in.recvInt();

	 					if(debug>3) debugwindow.println("POLYLINE in "+o[obj].toString()+" # Punkte = "+n);
	 					if(o[obj] instanceof Component)
	 					{
	 						if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawPolyline(x,y,n);
							((Component)o[obj]).getGraphics().drawPolyline(x,y,n);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).drawPolyline(x,y,n);
						else if(o[obj] instanceof PrintJob)
    						((Graphics)o[obj+1]).drawPolyline(x,y,n);
    					else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_drawpolyline( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	                /* Draw Polyon */
	                if (command == JAPI_Calls.JAPI_POLYGON)
	              	{
						int i;
	               		int n   = in.recvInt();
	               		int[] x = new int[n];
	               		int[] y = new int[n];

	               		for(i=0;i<n;i++)
	               	        x[i] = in.recvInt();
	               		for(i=0;i<n;i++)
	               		    y[i] = in.recvInt();

	 					if(debug>3) debugwindow.println("POLYGON in "+o[obj].toString()+" # Punkte = "+n);
	 					if(o[obj] instanceof Component)
	 					{
	 						if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawPolygon(x,y,n);
							((Component)o[obj]).getGraphics().drawPolygon(x,y,n);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).drawPolygon(x,y,n);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).drawPolygon(x,y,n);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_drawpolygon( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	                /* Draw filled Polyon */
	                if (command == JAPI_Calls.JAPI_FILLPOLYGON)
	              	{
						int i;
	               		int n   = in.recvInt();
	               		int[] x = new int[n];
	               		int[] y = new int[n];

	               		for(i=0;i<n;i++)
	               	        x[i] = in.recvInt();
	               		for(i=0;i<n;i++)
	               		    y[i] = in.recvInt();

	 					if(debug>3) debugwindow.println("FILL POLYGON in "+o[obj].toString()+" # Punkte = "+n);
	 					if(o[obj] instanceof Component)
	 					{
	 						if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().fillPolygon(x,y,n);
							((Component)o[obj]).getGraphics().fillPolygon(x,y,n);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).fillPolygon(x,y,n);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).fillPolygon(x,y,n);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_fillpolygon( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	               /* Draw Rectangle */
	                if (command == JAPI_Calls.JAPI_DRAWRECT)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();
	               		int width  = in.recvInt();
	               		int height = in.recvInt();

	 					if(debug>3) debugwindow.println("DRAWRECTANGLE in "+o[obj].toString()+"  "+x+"  "+y+"  "+width+"  "+height);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawRect(x,y,width,height);
	 						((Component)o[obj]).getGraphics().drawRect(x,y,width,height);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).drawRect(x,y,width,height);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).drawRect(x,y,width,height);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_drawrect( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }


	                /* Draw Filled Rectangle */
	                if (command == JAPI_Calls.JAPI_FILLRECT)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();
	               		int width  = in.recvInt();
	               		int height = in.recvInt();

	 					if(debug>3) debugwindow.println("DRAW FILLED RECTANGLE in "+o[obj].toString()+"  "+x+"  "+y+"  "+width+"  "+height);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().fillRect(x,y,width,height);
	 						((Component)o[obj]).getGraphics().fillRect(x,y,width,height);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).fillRect(x,y,width,height);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).fillRect(x,y,width,height);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_fillrect( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	                /* Draw round Rect */
	                if (command == JAPI_Calls.JAPI_ROUNDRECT)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();
	               		int width  = in.recvInt();
	               		int height = in.recvInt();
	               		int a   = in.recvInt();
	               		int b   = in.recvInt();

	 					if(debug>3) debugwindow.println("DRAW ROUND RECT in "+o[obj].toString()+"  "+x+"  "+y+"  "+width+"  "+height+"  "+a+"  "+b);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawRoundRect(x,y,width,height,a,b);
	 						((Component)o[obj]).getGraphics().drawRoundRect(x,y,width,height,a,b);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).drawRoundRect(x,y,width,height,a,b);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).drawRoundRect(x,y,width,height,a,b);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_drawroundrect( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	                /* Draw Filled Arc */
	                if (command == JAPI_Calls.JAPI_FILLROUNDRECT)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();
	               		int width  = in.recvInt();
	               		int height = in.recvInt();
	               		int a   = in.recvInt();
	               		int b   = in.recvInt();

	 					if(debug>3) debugwindow.println("DRAW FILLED ROUNDREC in "+o[obj].toString()+"  "+x+"  "+y+"  "+width+"  "+height+"  "+a+"  "+b);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().fillRoundRect(x,y,width,height,a,b);
	 						((Component)o[obj]).getGraphics().fillRoundRect(x,y,width,height,a,b);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).fillRoundRect(x,y,width,height,a,b);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).fillRoundRect(x,y,width,height,a,b);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_fillroundrect( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }


	                /* Draw Oval */
	                if (command == JAPI_Calls.JAPI_DRAWOVAL)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();
	               		int width  = in.recvInt();
	               		int height = in.recvInt();

	 					if(debug>3) debugwindow.println("DRAW OVAL in "+o[obj].toString()+"  "+x+"  "+y+"  "+width+"  "+height);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawOval(x,y,width,height);
	 						((Component)o[obj]).getGraphics().drawOval(x,y,width,height);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).drawOval(x,y,width,height);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).drawOval(x,y,width,height);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_drawoval( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }


	                /* Draw Filled Oval */
	                if (command == JAPI_Calls.JAPI_FILLOVAL)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();
	               		int width  = in.recvInt();
	               		int height = in.recvInt();

	 					if(debug>3) debugwindow.println("DRAW FILLED OVAL in "+o[obj].toString()+"  "+x+"  "+y+"  "+width+"  "+height);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().fillOval(x,y,width,height);
	 						((Component)o[obj]).getGraphics().fillOval(x,y,width,height);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).fillOval(x,y,width,height);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).fillOval(x,y,width,height);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_filloval( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	                /* Draw Arc */
	                if (command == JAPI_Calls.JAPI_DRAWARC)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();
	               		int width  = in.recvInt();
	               		int height = in.recvInt();
	               		int a   = in.recvInt();
	               		int b   = in.recvInt();

	 					if(debug>3) debugwindow.println("DRAW ARC in "+o[obj].toString()+"  "+x+"  "+y+"  "+width+"  "+height+"  "+a+"  "+b);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawArc(x,y,width,height,a,b);
	 						((Component)o[obj]).getGraphics().drawArc(x,y,width,height,a,b);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).drawArc(x,y,width,height,a,b);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).drawArc(x,y,width,height,a,b);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_drawarc( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	                /* Draw Filled Arc */
	                if (command == JAPI_Calls.JAPI_FILLARC)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();
	               		int width  = in.recvInt();
	               		int height = in.recvInt();
	               		int a   = in.recvInt();
	               		int b   = in.recvInt();


	 					if(debug>3) debugwindow.println("DRAW FILLED ARC in "+o[obj].toString()+"  "+x+"  "+y+"  "+width+"  "+height+"  "+a+"  "+b);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().fillArc(x,y,width,height,a,b);
	 						((Component)o[obj]).getGraphics().fillArc(x,y,width,height,a,b);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).fillArc(x,y,width,height,a,b);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).fillArc(x,y,width,height,a,b);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_fillarc( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	                /* Clipping Rectangle */
	                if (command == JAPI_Calls.JAPI_CLIPRECT)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();
	               		int width  = in.recvInt();
	               		int height = in.recvInt();

	 					if(debug>3) debugwindow.println("CLIP RECT in "+o[obj].toString()+"  "+x+"  "+y+"  "+width+"  "+height);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).clipRect(x,y,width,height);
							else
	 						    ((Component)o[obj]).getGraphics().clipRect(x,y,width,height);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).clipRect(x,y,width,height);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).clipRect(x,y,width,height);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_cliprect( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	 	            /* Translate */
	                if (command == JAPI_Calls.JAPI_TRANSLATE)
	              	{
	               		int x   = in.recvInt();
	               		int y   = in.recvInt();

	 					if(debug>3) debugwindow.println("Translate in "+o[obj].toString()+" to Pos "+x+":"+y);
	 					if(o[obj] instanceof Component)
	 					{
							if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).translate(x,y);
							else
		 						((Component)o[obj]).getGraphics().translate(x,y);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).translate(x,y);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).translate(x,y);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_translate( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }

	                /* Draw String */
	                if (command == JAPI_Calls.JAPI_DRAWSTRING)
	              	{
	               		int x    = in.recvInt();
	               		int y    = in.recvInt();
	                 	String s = in.readToLineEnd();

	 					if(debug>3) debugwindow.println("String in "+o[obj].toString()+" at "+x+"  "+y+"  :  "+s);
	 					if(o[obj] instanceof Component)
	 					{
	 						if(o[obj] instanceof JAPI_Canvas)
								((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawString(s,x,y);
							((Component)o[obj]).getGraphics().drawString(s,x,y);
						}
						else if(o[obj] instanceof Image)
    						((Graphics)o[obj+1]).drawString(s,x,y);
						else if(o[obj] instanceof PrintJob)
                             ((Graphics)o[obj+1]).drawString(s,x,y);
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_drawstring( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }

	                if (command == JAPI_Calls.JAPI_SETXOR)
	              	{
	            		int value  = in.recvInt();

	 					if(debug>3) debugwindow.println("Set XOR in "+o[obj].toString()+" to "+value);
	 					if(o[obj] instanceof Component)
	 					{
							if(value!=JAPI_Const.J_FALSE)
							{
	 						    if(o[obj] instanceof JAPI_Canvas)
								    ((JAPI_Canvas)o[obj]).setXORMode(Color.white);
							 	else
							 	    ((Component)o[obj]).getGraphics().setXORMode(Color.white);
							}
			                else
			                {
	 						    if(o[obj] instanceof JAPI_Canvas)
								    ((JAPI_Canvas)o[obj]).setPaintMode();
								else
							    	((Component)o[obj]).getGraphics().setPaintMode();
			                }
						}
						else if(o[obj] instanceof Image)
						{
							if(value!=JAPI_Const.J_FALSE)
   								((Graphics)o[obj+1]).setXORMode(Color.white);
   							else
   								((Graphics)o[obj+1]).setPaintMode();
   						}
						else if(o[obj] instanceof PrintJob)
						{
							if(value!=JAPI_Const.J_FALSE)
   								((Graphics)o[obj+1]).setXORMode(Color.white);
   							else
   								((Graphics)o[obj+1]).setPaintMode();
   						}
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_setxor( ID , ... )\nID = "+o[obj].toString());

	                  	continue;
	                }

	                /* Set Background  RGB */
	                if (command == JAPI_Calls.JAPI_BACKGROUNDCOLOR)
	              	{
	             		int red = in.readUnsignedByte();
	             		int gre = in.readUnsignedByte();
	             		int blu = in.readUnsignedByte();
	 					if(debug>3) debugwindow.println("Set BACKGROUND Color in "+o[obj].toString()+" : "+red+" , "+gre+" , "+blu);


 						if(o[obj] instanceof Component)
 							((Component)o[obj]).setBackground(new Color(red,gre,blu));
// TODO : Background in PrintJob = getcolor; setcolor; fillrect; setcolor;
						else if((o[obj] instanceof Image)||(o[obj] instanceof PrintJob))
						{
							 Dimension d=new Dimension();
							 if(o[obj] instanceof Image)
							 {
								d.width =((Image)o[obj]).getWidth(debugwindow);
   							 	d.height=((Image)o[obj]).getHeight(debugwindow);
						 	 }
   							 if(o[obj] instanceof PrintJob)
							    d=((PrintJob)o[obj]).getPageDimension();

                             Color c=((Graphics)o[obj+1]).getColor();
                             ((Graphics)o[obj+1]).setColor(new Color(red,gre,blu));
                             ((Graphics)o[obj+1]).fillRect(0,0,d.width,d.height);
                             ((Graphics)o[obj+1]).setColor(c);
						}
	                  	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_setcolorbg( ID , ... ) or j_setnamedcolorbg( ID , ... )\nID = "+o[obj].toString());

	                  	continue;
	                }


             	    /* Load Image */
                    if (command == JAPI_Calls.JAPI_LOADIMAGE)
                    {
                 	    String title  = in.readToLineEnd();
   					    if(debug>0) debugwindow.println("LOADIMAGE : "+title+"  (ID = "+objectcounter+")");
debugwindow.println(clienthost+" "+httpport+" "+title);

                 		o[objectcounter] = Toolkit.getDefaultToolkit().getImage(new URL("http",clienthost,httpport,title));
                        MediaTracker mt = new MediaTracker(debugwindow);
                        mt.addImage((Image)o[objectcounter], 0);
                        try { mt.waitForAll(); } catch (InterruptedException e) {}

					    if(((Image)o[objectcounter]).getWidth(debugwindow) < 0)
					        out.sendInt(-1);
					    else
					    {
					    	out.sendInt(objectcounter);
           	  		    	objectcounter+=1;
                  	    }
                 	    continue;
                    }

              	    /* Draw Image */
                    if (command == JAPI_Calls.JAPI_DRAWIMAGE)
                    {
	             		int img = in.recvInt();
	             		int x   = in.recvInt();
	             		int y   = in.recvInt();

   					    if(debug>3) debugwindow.println("DRAWIMAGE : "+img+" in "+o[obj].toString()+" at pos "+x+":"+y);

						if((img <= 0)||(img >= objectcounter))
						{
	           	  			nextaction=errordialog.getResult("Not a valid JAPI Object ID\nID = "+img);
						}
						else
						{
 	 						if(o[obj] instanceof Component)
	 						{
 	 							if(o[obj] instanceof JAPI_Canvas)
									((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawImage(((Image)o[img]),x,y,debugwindow);
								((Component)o[obj]).getGraphics().drawImage(((Image)o[img]),x,y,debugwindow);
							}
							else if(o[obj] instanceof Image)
    							((Graphics)o[obj+1]).drawImage(((Image)o[img]),x,y,debugwindow);
							else if(o[obj] instanceof PrintJob)
    	                         ((Graphics)o[obj+1]).drawImage(((Image)o[img]),x,y,debugwindow);
							else
	           	  				nextaction=errordialog.getResult("No valid Object ID in j_drawimage( ID , ... )\nID = "+o[obj].toString());
                  	    }
                  	    continue;
                    }


              	    /* Draw Scaled Image */
                    if (command == JAPI_Calls.JAPI_DRAWSCALEDIMAGE)
                    {
	             		int img = in.recvInt();
	             		int sx  = in.recvInt();
	             		int sy  = in.recvInt();
	             		int sw  = in.recvInt();
	             		int sh  = in.recvInt();
	             		int dx  = in.recvInt();
	             		int dy  = in.recvInt();
	             		int dw  = in.recvInt();
	             		int dh  = in.recvInt();

   					    if(debug>3) debugwindow.println("DRAWSCALEDIMAGE : "+img+" in "+o[obj].toString()+" from "+sx+":"+sy+":"+sw+":"+sh+"==>"+dx+":"+dy+":"+dw+":"+dh);

						if((img <= 0)||(img >= objectcounter))
	           	  		{
	           	  			nextaction=errordialog.getResult("Not a valid JAPI Object ID\nID = "+img);
						}
						else
						{
 	 						if(o[obj] instanceof Component)
	 						{
 	 							if(o[obj] instanceof JAPI_Canvas)
									((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawImage(((Image)o[img]),dx,dy,dw,dh,sx,sy,sw,sh,((JAPI_Canvas)o[obj]));
								((Component)o[obj]).getGraphics().drawImage(((Image)o[img]),dx,dy,dw,dh,sx,sy,sw,sh,((Component)o[obj]));
							}
							else if(o[obj] instanceof Image)
    							((Graphics)o[obj+1]).drawImage(((Image)o[img]),dx,dy,dw,dh,sx,sy,sw,sh,new Frame());
							else if(o[obj] instanceof PrintJob)
    	                         ((Graphics)o[obj+1]).drawImage(((Image)o[img]),dx,dy,dw,dh,sx,sy,sw,sh,new Frame());
							else
	           	  				nextaction=errordialog.getResult("No valid Object ID in j_drawscaledimage( ID , ... )\nID = "+o[obj].toString());
						}
                   	    continue;
                    }

              	    /* Get Image */
                    if (command == JAPI_Calls.JAPI_GETIMAGE)
                    {
   					    if(debug>3) debugwindow.println("GETIMAGE from Object "+o[obj].toString());

 	 					if(o[obj] instanceof JAPI_Canvas)
	 					{
	 					    o[objectcounter] = (((JAPI_Canvas)o[obj]).getImageCopy());
	 					    out.sendInt(objectcounter);
	 					    objectcounter++;
						}
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_getimage( ID , ... )\nID = "+o[obj].toString());

                   	    continue;
                    }

                 	/* Get Scaled Image */
                    if (command == JAPI_Calls.JAPI_GETSCALEDIMAGE)
                    {
	             		int sx  = in.recvInt();
	             		int sy  = in.recvInt();
	             		int sw  = in.recvInt();
	             		int sh  = in.recvInt();
	             		int dw  = in.recvInt();
	             		int dh  = in.recvInt();

   					    if(debug>3) debugwindow.println("GETSCALEDIMAGE from Object "+o[obj].toString()+" from "+sx+":"+sy+":"+sw+":"+sh+"==>"+dw+":"+dh);

 	 					if(o[obj] instanceof JAPI_Canvas)
	 					{
	 					    o[objectcounter] = (((JAPI_Canvas)o[obj]).getScaledImageCopy(sx,sy,sw,sh,dw,dh));
	 					    out.sendInt(objectcounter);
	 					    objectcounter++;
						}
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_getscaledimage( ID , ... )\nID = "+o[obj].toString());

                   	    continue;
                    }

                    if (command == JAPI_Calls.JAPI_GETIMAGESOURCE)
                    {
						int i,length;
	             		int sx  = in.recvInt();
	             		int sy  = in.recvInt();
	             		int sw  = in.recvInt();
	             		int sh  = in.recvInt();
  						length=sw*sh;

   					    if(debug>3) debugwindow.println("GET IMAGE SOURCE from Object "+o[obj].toString()+" from "+sx+":"+sy+":"+sw+":"+sh);

 	 					if((o[obj] instanceof JAPI_Canvas)||(o[obj] instanceof Image))
 	 					{
 	 					    Image img;
 	 					    PixelGrabber grab;
	 					    if(o[obj] instanceof JAPI_Canvas)
	 					        img = (((JAPI_Canvas)o[obj]).getImageCopy());
	 					    else
	 					    	img = (Image)o[obj];

	 					 	int[] pic = new int[length];
	 					 	byte[] b = new byte[length];
							grab = new PixelGrabber(img,sx,sy,sw,sh,pic,0,sw);
							try{grab.grabPixels();} catch (InterruptedException e) {}

//							for(i=0;i<length;i++)
//							    b[i] = (byte) (((pic[i] & 0xff000000) >> 24) & 0xff);
							for(i=0;i<length;i++)
							    b[i] = (byte) (((pic[i] & 0x00ff0000) >> 16) & 0xff);
							out.write(b, 0, length);
							for(i=0;i<length;i++)
							    b[i] = (byte) (((pic[i] & 0x0000ff00) >> 8) & 0xff);
							out.write(b, 0, length);
							for(i=0;i<length;i++)
							    b[i] = (byte) ((pic[i] & 0x000000ff) & 0xff);
							out.write(b, 0, length);
					}
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_getimagesource( ID , ... )\nID = "+o[obj].toString());
                   	    continue;
                    }

                    if (command == JAPI_Calls.JAPI_DRAWIMAGESOURCE)
                    {
						int i,length;
	             		int sx  = in.recvInt();
	             		int sy  = in.recvInt();
	             		int sw  = in.recvInt();
	             		int sh  = in.recvInt();
						length=sw*sh;

   					    if(debug>3) debugwindow.println("DRAW IMAGE SOURCE in Object "+o[obj].toString()+" at "+sx+":"+sy+":"+sw+":"+sh);

	 					if( (o[obj] instanceof JAPI_Canvas)||
	 						(o[obj] instanceof Image) ||
	 						(o[obj] instanceof PrintJob))
 	 					{
	 					 	int[] pic = new int[length];
	 					 	byte[] b = new byte[length];
							for(i=0;i<length;i++)
							    pic[i] = 0xff;
							in.readFully(b);
							for(i=0;i<length;i++)
							    pic[i] = ((pic[i] << 8) | (b[i]>0?b[i]:256+b[i]));
							in.readFully(b);
							for(i=0;i<length;i++)
							    pic[i] = ((pic[i] << 8) | (b[i]>0?b[i]:256+b[i]));
							in.readFully(b);
							for(i=0;i<length;i++)
							    pic[i] = ((pic[i] << 8) | (b[i]>0?b[i]:256+b[i]));
							MemoryImageSource memimg = new MemoryImageSource(sw,sh,pic,0,sw);
    	 					if(o[obj] instanceof JAPI_Canvas)
	     					{
		    					Image img = ((JAPI_Canvas)o[obj]).createImage(memimg);
			    			    ((JAPI_Canvas)o[obj]).getoffscreenGraphics().drawImage(img,sx,sy,(JAPI_Canvas)o[obj]);
				    		    ((JAPI_Canvas)o[obj]).getGraphics().drawImage(img,sx,sy,(JAPI_Canvas)o[obj]);
							}
							else if(o[obj] instanceof Image)
							{
 		    					Image img = debugwindow.createImage(memimg);
    	                        ((Graphics)o[obj+1]).drawImage(img,sx,sy,debugwindow);
							}
							else if(o[obj] instanceof PrintJob)
							{
 		    					Image img = ((JAPI_Canvas)o[obj]).createImage(memimg);
    	                        ((Graphics)o[obj+1]).drawImage(img,sx,sy,(JAPI_Canvas)o[obj]);
							}
							else
		    				;//	Image img = ((Image)o[obj]).createImage(memimg);
						    pic=null;
						    b=null;
						}
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_drawimagesource( ID , ... )\nID = "+o[obj].toString());

                   	    continue;
                    }

   	 				continue;


				//                            C O M M A N D S


  				case(JAPI_Calls.JAPI_COMMANDS):

		            /* Quit */
		            if (command == JAPI_Calls.JAPI_QUIT)
	    	        {
	  					if(debug>0) debugwindow.println("QUIT");
						nextaction = false;
	                	continue;
                	}

		            /* Kill */
		            if (command == JAPI_Calls.JAPI_KILL)
	    	        {
	  					if(debug>0) debugwindow.println("Bye bye ... ");
						System.exit(0);
                	}

	                if (command == JAPI_Calls.JAPI_DEBUG)
    	          	{
        	      		int level = in.recvInt();
       				    int i;

 						debugwindow.println("Debug Level set to "+level);
 						debug=level;
 						debugwindow.setlevel(level);
 						for(i=0;i<objectcounter;i++)
 						{
 							if(o[i] instanceof JAPI_Actionlistener)
 							    ((JAPI_Actionlistener)o[i]).setdebuglevel(level);
	  						if(o[i] instanceof JAPI_Adjustmentlistener)
 							    ((JAPI_Adjustmentlistener)o[i]).setdebuglevel(level);
  							if(o[i] instanceof JAPI_Componentlistener)
 							    ((JAPI_Componentlistener)o[i]).setdebuglevel(level);
  							if(o[i] instanceof JAPI_Focuslistener)
 							    ((JAPI_Focuslistener)o[i]).setdebuglevel(level);
	  						if(o[i] instanceof JAPI_Itemlistener)
 							    ((JAPI_Itemlistener)o[i]).setdebuglevel(level);
  							if(o[i] instanceof JAPI_Keylistener)
 							    ((JAPI_Keylistener)o[i]).setdebuglevel(level);
  							if(o[i] instanceof JAPI_Mouselistener)
 							    ((JAPI_Mouselistener)o[i]).setdebuglevel(level);
  							if(o[i] instanceof JAPI_Mousemotionlistener)
 						    	((JAPI_Mousemotionlistener)o[i]).setdebuglevel(level);
	  						if(o[i] instanceof JAPI_Textlistener)
 							    ((JAPI_Textlistener)o[i]).setdebuglevel(level);
  							if(o[i] instanceof JAPI_Windowlistener)
 							    ((JAPI_Windowlistener)o[i]).setdebuglevel(level);
 						}
                		continue;
               		}

	                /* Setsize */
	                if (command == JAPI_Calls.JAPI_SETSIZE)
	              	{
	                	int width = in.recvInt();
	                	int height = in.recvInt();
	  					if(debug>2) debugwindow.println("Setsize ["+o[obj].toString()+"] to : " + width +" "+ height);

	                  	if(o[obj] instanceof Component)
	 						((Component)o[obj]).setSize(width,height);
	                  	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_setsize( ID , ... )\nID = "+o[obj].toString());

	                  	if(o[obj] instanceof JAPI_Canvas)
	                  		while(((JAPI_Canvas)o[obj]).waitForNewScreenBuf()==false)
	                  			try{sleep(100);}catch(InterruptedException e){}
	                  	continue;
	 				}

	                /* show */
	                if (command == JAPI_Calls.JAPI_SHOW)
	              	{
	 					if(debug>2) debugwindow.println("SHOW "+o[obj].toString());

	                  	if(o[obj] instanceof Component)
		 					((Component)o[obj]).setVisible(true);
	                  	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_show( ID )\nID = "+o[obj].toString());

	                  	continue;
	 				}


	                /* hide */
	                if (command == JAPI_Calls.JAPI_HIDE)
	              	{
	 					if(debug>2) debugwindow.println("HIDE "+o[obj].toString());

	 					if(o[obj] instanceof Component)
	 						((Component)o[obj]).setVisible(false);
	                  	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_hide( ID )\nID = "+o[obj].toString());

	                  	continue;
	 				}

		            /* add */
	                if (command == JAPI_Calls.JAPI_ADD)
	              	{
	             		int parent = in.recvInt();
	 					if(debug>2) debugwindow.println("ADD "+o[obj].toString()+" to "+o[parent].toString());

	 					if(o[parent] instanceof Container)
	 					{
	 						if(o[obj] instanceof Component)
	 						{
	 							if(((Component)o[obj]).getParent() != null)
		 	 						((Component)o[obj]).getParent().remove((Component)o[obj]);
	 							else
		 							((Container)o[parent]).add((Component)o[obj]);
		           	  		}
	                  		else
							{
	           	  				nextaction=errordialog.getResult("No valid Object ID2 in j_add( ID1, ID2 )\nID2 = "+o[obj].toString());
	           	  			}
						}
	                  	else
	           	  			nextaction=errordialog.getResult("No valid Object ID1 in j_add( ID1, ID2 )\nID1 = "+o[obj].toString());
	                  	continue;
	 				}

		            /* release */
	                if (command == JAPI_Calls.JAPI_RELEASE)
	              	{
	 					if(debug>2) debugwindow.println("RELEASE "+o[obj].toString());

	 					if(o[obj] instanceof Component)
	 					{
	 						if(((Component)o[obj]).getParent() != null)
	 							((Component)o[obj]).getParent().remove((Component)o[obj]);
		           	  	}
	                  	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_release( ID )\nID = "+o[obj].toString());

	                  	continue;
	 				}


		            /* releaseall */
	                if (command == JAPI_Calls.JAPI_RELEASEALL)
	              	{
	 					if(debug>2) debugwindow.println("RELEASE ALL in "+o[obj].toString());

	 					if(o[obj] instanceof Container)
	 					{
							int i=((Container)o[obj]).getComponentCount();
							while(--i >= 0)
								((Container)o[obj]).remove(((Container)o[obj]).getComponent(0));
		           	  	}
	                  	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_releaseall( ID )\nID = "+o[obj].toString());

	                  	continue;
	 				}

	 	            /* dispose */
	                if (command == JAPI_Calls.JAPI_DISPOSE)
	              	{
	 					if(debug>2) debugwindow.println("DISPOSE "+o[obj].toString());

	 					if(o[obj] instanceof Window)
	 						((Window)o[obj]).dispose();
	                  	else if(o[obj] instanceof Component)
	 						((Component)o[obj]).getParent().remove((Component)o[obj]);
	                  	else if(o[obj] instanceof MenuComponent)
	 						((MenuComponent)o[obj]).getParent().remove((MenuComponent)o[obj]);
	                  	else if(o[obj] instanceof PrintJob)
	                  		((PrintJob)o[obj]).end();
						o[obj]=null;

	                  	continue;
	 				}

	                /* pack */
	                if (command == JAPI_Calls.JAPI_PACK)
	              	{
	 					if(debug>2) debugwindow.println("PACK "+o[obj].toString());

	                 	if(o[obj] instanceof Window)
	                 	{
	                 	//  Einmal genuegt manchmal nicht
	                 		((Window)o[obj]).doLayout();
	                  	    ((Window)o[obj]).pack();
	                  	    ((Window)o[obj]).pack();
	                  	}
	                  	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_pack( ID )\nID = "+o[obj].toString());

	                  	continue;
	 				}

	                /* print */
	                if (command == JAPI_Calls.JAPI_PRINT)
	              	{
	 					if(debug>2) debugwindow.println("PRINT "+o[obj].toString());

	                 	if(o[obj] instanceof Component)
	                 	{
							Component c = ((Component)o[obj]);
              				PrintJob pj;

              				while (c!=null && !(c instanceof Frame))
                 				c=c.getParent();

                 			if((pj = c.getToolkit().getPrintJob( (Frame)c , "", null))==null)
                 				continue;
        					Graphics pg = pj.getGraphics();
        					((Component)o[obj]).printAll(pg);
        					pg.dispose();
        					pj.end();
	                  	}
	                  	else if(o[obj] instanceof Image)
	                  	{
              				PrintJob pj;
	                  		Frame f = new Frame();
                 			if((pj = Toolkit.getDefaultToolkit().getPrintJob(debugwindow,"",null))==null)
                 				continue;
        					Graphics pg = pj.getGraphics();
        					pg.drawImage((Image)o[obj],0,0,f);
        					pg.dispose();
        					pj.end();
	                  	}
	                  	else if(o[obj] instanceof PrintJob)
	                  	{
	                  		((Graphics)o[obj+1]).dispose();
	                  		o[obj+1] = ((PrintJob)o[obj]).getGraphics();
//	                  		((PrintJob)o[obj]).end();
						}
						else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_print( ID )\nID = "+o[obj].toString());

	                  	continue;
	 				}

	                /* play Sound File  (ab JDK 1.2) */
	                if (command == JAPI_Calls.JAPI_PLAYSOUNDFILE)
	              	{
	             		String file = in.readToLineEnd();

	 					if(debug>2) debugwindow.println("Play Sound File"+file);

						AudioClip snd = Applet.newAudioClip(new URL("http",clienthost,httpport,file));
						snd.play();

	                  	continue;
	 				}

	                /* load Sound (nur JDK 1.2) */
	                if (command == JAPI_Calls.JAPI_SOUND)
	              	{
	             		String file = in.readToLineEnd();

	 					if(debug>2) debugwindow.println("Load Sound File "+file);

						o[objectcounter] = Applet.newAudioClip(new URL("http",clienthost,httpport,file));
 						out.sendInt(objectcounter);
		          	  	objectcounter++;

	                  	continue;
	 				}

	                /* play Sound  (nur JDK 1.2) */
	                if (command == JAPI_Calls.JAPI_PLAY)
	              	{
	 					if(debug>2) debugwindow.println("Play Sound "+o[obj].toString());

	 					if(o[obj] instanceof AudioClip)
							((AudioClip)o[obj]).play();
	                 	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_play( ID )\nID = "+o[obj].toString());

	                  	continue;
	 				}

	                /* borderpos */
	                if (command == JAPI_Calls.JAPI_BORDERPOS)
	              	{
	             		int pos = in.recvInt();

	 				    if(debug>2) debugwindow.println("set "+o[obj].toString()+" at pos "+pos);

	 					if(o[obj] instanceof Component)
	 						if(((Component)o[obj]).getParent() instanceof Container)
	 						{
								Container p=((Component)o[obj]).getParent();
								p.remove((Component)o[obj]);
	 							switch(pos)
	 							{
	 								case(JAPI_Const.J_TOP)   : p.add((Component)o[obj],"North" ); continue;
	 								case(JAPI_Const.J_BOTTOM): p.add((Component)o[obj],"South" ); continue;
	 								case(JAPI_Const.J_LEFT)  : p.add((Component)o[obj],"West"  ); continue;
	 								case(JAPI_Const.J_RIGHT) : p.add((Component)o[obj],"East"  ); continue;
	 								case(JAPI_Const.J_CENTER): p.add((Component)o[obj],"Center"); continue;
	 								default: nextaction=errordialog.getResult("ERROR : no valid Position in Funktion j_borderpos( int container , int position )");
	                    		}
	                    	}
	                    	else
							{
	           	  				nextaction=errordialog.getResult("No valid Object ID in j_borderpos( ID, ... )\nID = "+o[obj].toString());
	           	  			}
	                  	else
	           	  			nextaction=errordialog.getResult("No valid position in j_borderpos( ID, position )\nposition = "+pos);

	                  	continue;
	 				}

	                /* setHgap */
	                if (command == JAPI_Calls.JAPI_SETHGAP)
	              	{
	             		int gap = in.recvInt();

	 					if(debug>2) debugwindow.println("setHgap "+o[obj].toString()+" to "+gap);

	 					if(o[obj] instanceof Container)
	 					{
	 						if(((Container)o[obj]).getLayout() instanceof FlowLayout)
	 							((FlowLayout)((Container)o[obj]).getLayout()).setHgap(gap);
	                    	else if(((Container)o[obj]).getLayout() instanceof JAPI_Fixlayout)
	  							((JAPI_Fixlayout)((Container)o[obj]).getLayout()).setHgap(gap);
	                    	else if(((Container)o[obj]).getLayout() instanceof GridLayout)
	  							((GridLayout)((Container)o[obj]).getLayout()).setHgap(gap);
	                   	    else if(((Container)o[obj]).getLayout() instanceof BorderLayout)
	  							((BorderLayout)((Container)o[obj]).getLayout()).setHgap(gap);
	                        else
	           	  				nextaction=errordialog.getResult("No Layout Manager in Object ID  j_sethgap( ID, gap )\nID = "+o[obj].toString());
	                 	}
	                 	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_sethgap( ID, ... )\nID = "+o[obj].toString());

	                  	continue;
	 				}

	                /* setVgap */
	                if (command == JAPI_Calls.JAPI_SETVGAP)
	              	{
	             		int gap = in.recvInt();

	 					if(debug>2) debugwindow.println("setVgap "+o[obj].toString()+" to "+gap);

	 					if(o[obj] instanceof Container)
	 					{
	 						if(((Container)o[obj]).getLayout() instanceof FlowLayout)
	  							((FlowLayout)((Container)o[obj]).getLayout()).setVgap(gap);
	                    	else if(((Container)o[obj]).getLayout() instanceof JAPI_Fixlayout)
	  							((JAPI_Fixlayout)((Container)o[obj]).getLayout()).setVgap(gap);
	                    	else if(((Container)o[obj]).getLayout() instanceof GridLayout)
	  							((GridLayout)((Container)o[obj]).getLayout()).setVgap(gap);
	                   	    else if(((Container)o[obj]).getLayout() instanceof BorderLayout)
	  							((BorderLayout)((Container)o[obj]).getLayout()).setVgap(gap);
							else
	           	  				nextaction=errordialog.getResult("No Layout Manager in Object ID  j_setvgap( ID, gap )\nID = "+o[obj].toString());
	                 	}
	                 	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_setvgap( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}


	                /* setInsets */
	                if (command == JAPI_Calls.JAPI_SETINSETS)
	              	{
	             		int t = in.recvInt();
	             		int b = in.recvInt();
	             		int l = in.recvInt();
	             		int r = in.recvInt();

	 					if(debug>2) debugwindow.println("setInsets "+o[obj].toString()+" to "+t+" "+b+" "+l+" "+r+" ");

	 					if(o[obj] instanceof JAPI_Frame)
	 						((JAPI_Frame)o[obj]).setInsets(t,b,l,r);
	 					else if(o[obj] instanceof JAPI_Dialog)
	 						((JAPI_Dialog)o[obj]).setInsets(t,b,l,r);
	 					else if(o[obj] instanceof JAPI_Window)
	 						((JAPI_Window)o[obj]).setInsets(t,b,l,r);
	 					else if(o[obj] instanceof JAPI_Panel)
	 						((JAPI_Panel)o[obj]).setInsets(t,b,l,r);
						else
	           	  			nextaction=errordialog.getResult("No Container Object ID  j_setinsets( ID, gap )\nID = "+o[obj].toString());
     					if(o[obj] instanceof Container)
     						if(((Container)o[obj]).getLayout()!=null)
     							((Container)o[obj]).getLayout().layoutContainer((Container)o[obj]);
	                  	continue;
	 				}

	                /* add item*/
	                if (command == JAPI_Calls.JAPI_ADDITEM)
	              	{
	                  	String title = in.readToLineEnd();

	 					if(debug>0) debugwindow.println("add "+title+" to "+o[obj].toString());

	 					if(o[obj] instanceof JAPI_List)
	 						((JAPI_List)o[obj]).add(title);
	                 	else if(o[obj] instanceof JAPI_Choice)
	 						((JAPI_Choice)o[obj]).add(title);
	                 	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_additem( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}

	               	/* select*/
	                if (command == JAPI_Calls.JAPI_SELECT)
	              	{
	            		int item   = in.recvInt();

	 					if(debug>2) debugwindow.println("select in "+o[obj].toString()+" : "+item);

	 					if(o[obj] instanceof JAPI_List)
	 						((JAPI_List)o[obj]).select(item);
	                 	else if(o[obj] instanceof JAPI_Choice)
	 						((JAPI_Choice)o[obj]).select(item);
	                 	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_select( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}

	               	/* deselect*/
	                if (command == JAPI_Calls.JAPI_DESELECT)
	              	{
	            		int item   = in.recvInt();

	 					if(debug>2) debugwindow.println("select in "+o[obj].toString()+" : "+item);

	 					if(o[obj] instanceof JAPI_List)
	 						((JAPI_List)o[obj]).deselect(item);
	                 	else
	           	  			nextaction=errordialog.getResult("No valid Object ID in j_deselect( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}

	               	/* multiple Mode*/
	                if (command == JAPI_Calls.JAPI_MULTIPLEMODE)
	              	{
	            		int value  = in.recvInt();

	 					if(debug>2) debugwindow.println("set multiple Mode for "+o[obj].toString()+" : "+value);

	 					if(o[obj] instanceof JAPI_List)
	 						((JAPI_List)o[obj]).setmultiplemode(value!=JAPI_Const.J_FALSE);
	                 	else
           	  			    nextaction=errordialog.getResult("No valid Object ID in j_multiplemode( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}

	               	/* insert */
	                if (command == JAPI_Calls.JAPI_INSERT)
	              	{
	 					int pos	    = in.recvInt();
	             		String item = in.readToLineEnd();
	  					if(debug>0) debugwindow.println("insert in "+o[obj].toString()+" : "+item+" at psition "+pos);

	 					if(o[obj] instanceof List)
	 						((List)o[obj]).add(item,pos);
	                 	else if(o[obj] instanceof Choice)
	 						((Choice)o[obj]).insert(item,pos);
	                 	else
           	  			    nextaction=errordialog.getResult("No valid Object ID in j_insert( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}

	               	/* remove */
	                if (command == JAPI_Calls.JAPI_REMOVE)
	              	{
	            		int index   = in.recvInt();
	 					if(debug>0) debugwindow.println("remove in "+o[obj].toString()+" : "+index);

	 					if(o[obj] instanceof List)
	 						((List)o[obj]).remove(index);
	                 	else if(o[obj] instanceof Choice)
	 						((Choice)o[obj]).remove(index);
	                 	else
           	  			    nextaction=errordialog.getResult("No valid Object ID in j_remove( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}

	               	/* remove item*/
	                if (command == JAPI_Calls.JAPI_REMOVEITEM)
	              	{
	            		String item   = in.readToLineEnd();
	 					if(debug>0) debugwindow.println("remove Item in "+o[obj].toString()+" : "+item);

	 					if(o[obj] instanceof List)
	 						((List)o[obj]).remove(item);
	                 	else if(o[obj] instanceof Choice)
	 						((Choice)o[obj]).remove(item);
	                 	else
           	  			    nextaction=errordialog.getResult("No valid Object ID in j_remove( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}

	               	/* removeall */
	                if (command == JAPI_Calls.JAPI_REMOVEALL)
	              	{
	 					if(debug>0) debugwindow.println("remove all in "+o[obj].toString());

	 					if(o[obj] instanceof List)
	 						((List)o[obj]).removeAll();
	                 	else if(o[obj] instanceof Choice)
	 						((Choice)o[obj]).removeAll();
	                 	else
           	  			    nextaction=errordialog.getResult("No valid Object ID in j_removeall( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}

	                /* Set at position */
	                if (command == JAPI_Calls.JAPI_SETPOS)
	              	{
	             		int xpos = in.recvInt();
	             		int ypos = in.recvInt();
	 					if(debug>2) debugwindow.println("set "+o[obj].toString()+" to position " + xpos+","+ypos);

	 					if(o[obj] instanceof Component)
	    					((Component)o[obj]).setLocation(xpos,ypos);
	                 	else
           	  			    nextaction=errordialog.getResult("No valid Object ID in j_setpos( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}

	 				/* Cursor */
	                if (command == JAPI_Calls.JAPI_CURSOR)
	              	{
	             		int value = in.recvInt();
						if(debug>2) debugwindow.println("Set Cursor in "+o[obj].toString()+" to "+value);

						if(o[obj] instanceof Component)
	             			((Component)o[obj]).setCursor(new Cursor(value));
	                  	else
          	  			    nextaction=errordialog.getResult("No valid Object ID in j_cursor( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	                }


	 				/* Set State */
	                if (command == JAPI_Calls.JAPI_SETSTATE)
	              	{
	             		int value = in.recvInt();
						if(debug>2) debugwindow.println("Setstate "+o[obj].toString()+" to "+value);

						if(o[obj] instanceof CheckboxMenuItem)
	             			((CheckboxMenuItem)o[obj]).setState(value!=JAPI_Const.J_FALSE);
	                  	else if(o[obj] instanceof JAPI_Checkbox)
	             			((JAPI_Checkbox)o[obj]).setState(value!=JAPI_Const.J_FALSE);
						else  if(o[obj] instanceof JAPI_Radiobutton)
	             			((JAPI_Radiobutton)o[obj]).setState(value!=JAPI_Const.J_FALSE);
						else  if(o[obj] instanceof JAPI_Led)
	             			((JAPI_Led)o[obj]).setState(value!=JAPI_Const.J_FALSE);
						else
          	  			    nextaction=errordialog.getResult("No valid Object ID in j_setstate( ID, ... )\nID = "+o[obj].toString());
	                  	continue;
	                }

	 				/* Disable */
	                if (command == JAPI_Calls.JAPI_DISABLE)
	              	{
	 					if(debug>2) debugwindow.println("Disable Object "+o[obj].toString());
	  					if(o[obj] instanceof Component)
	               			((Component)o[obj]).setEnabled(false);
						else if(o[obj] instanceof JAPI_Menu)
	               			((JAPI_Menu)o[obj]).setEnabled(false);
	 					else if(o[obj] instanceof MenuItem)
	               			((MenuItem)o[obj]).setEnabled(false);
	 					else if(o[obj] instanceof CheckboxMenuItem)
	             			((CheckboxMenuItem)o[obj]).setEnabled(false);
						else
          	  			    nextaction=errordialog.getResult("No valid Object ID in j_disable( ID )\nID = "+o[obj].toString());

	                 	continue;
	                }

	 				/* Enable */
	                if (command == JAPI_Calls.JAPI_ENABLE)
	              	{
	 					if(debug>2) debugwindow.println("Enable Object "+o[obj].toString());
	  					if(o[obj] instanceof Component)
	               			((Component)o[obj]).setEnabled(true);
						else if(o[obj] instanceof JAPI_Menu)
	               			((JAPI_Menu)o[obj]).setEnabled(true);
	 					else if(o[obj] instanceof MenuItem)
	               			((MenuItem)o[obj]).setEnabled(true);
	 					else if(o[obj] instanceof CheckboxMenuItem)
	             			((CheckboxMenuItem)o[obj]).setEnabled(true);
	                   	else
          	  			    nextaction=errordialog.getResult("No valid Object ID in j_enable( ID )\nID = "+o[obj].toString());
	                 	continue;
	                }


					/* Set Font */
	                if (command == JAPI_Calls.JAPI_SETFONT)
	              	{
						String font;
	                 	int type  = in.recvInt();
	                 	int style = in.recvInt();
	                 	int size  = in.recvInt();

						switch(type)
						{
							case JAPI_Const.J_COURIER   : font = "Monospaced"; break;
							case JAPI_Const.J_HELVETIA  : font = "SansSerif"; break;
							case JAPI_Const.J_TIMES     : font = "Serif"; break;
							case JAPI_Const.J_DIALOGOUT : font = "Dialog"; break;
							case JAPI_Const.J_DIALOGIN  : font = "DialogInput"; break;
							default                     : nextaction=errordialog.getResult("No valid Fonttype in j_setfontname( ID , Fonttype )\nFonttype = "+type);
													      continue;
     					}
	 					if(debug>2) debugwindow.println("SetFont in "+o[obj].toString()+" to "+font.toString());

	 					if(o[obj] instanceof Component)
	               			((Component)o[obj]).setFont(new	Font(font,style,size));
	                  	else if(o[obj] instanceof MenuComponent)
	               			((MenuComponent)o[obj]).setFont(new	Font(font,style,size));
						else if((o[obj] instanceof Image) || (o[obj] instanceof PrintJob))
    						((Graphics)o[obj+1]).setFont(new Font(font,style,size));
	                  	else
         	  			    nextaction=errordialog.getResult("No valid Object ID in j_setfont( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }

	 				/* Set Font Name */
	                if (command == JAPI_Calls.JAPI_SETFONTNAME)
	              	{
						String font;
	                 	int type  = in.recvInt();

						switch(type)
						{
							case JAPI_Const.J_COURIER   : font = "Monospaced"; break;
							case JAPI_Const.J_HELVETIA  : font = "SansSerif"; break;
							case JAPI_Const.J_TIMES     : font = "Serif"; break;
							case JAPI_Const.J_DIALOGOUT : font = "Dialog"; break;
							case JAPI_Const.J_DIALOGIN  : font = "DialogInput"; break;
							default                     : nextaction=errordialog.getResult("No valid Fonttype in j_setfontname( ID , Fonttype )\nFonttype = "+type);
											     		  continue;
	 					}
	 					if(debug>2) debugwindow.println("SetFont in "+o[obj].toString()+" to "+font.toString());

	 					if(o[obj] instanceof Component)
	 					{
	 						if(((Component)o[obj]).getFont()==null)
	 							((Component)o[obj]).setFont(new Font("Dialog",Font.PLAIN,12));
	// java 2.0					((Component)o[obj]).setFont(new Font(Font.DEFAULT));
	               			((Component)o[obj]).setFont(new	Font(font,((Component)o[obj]).getFont().getStyle(),
															 		  ((Component)o[obj]).getFont().getSize()));
	                  	}
	                  	else if(o[obj] instanceof MenuComponent)
	 					{
	 						if(((MenuComponent)o[obj]).getFont()==null)
	 							((MenuComponent)o[obj]).setFont(new Font("Dialog",Font.PLAIN,12));
	// java 2.0					((MenuComponent)o[obj]).setFont(new Font(Font.DEFAULT));
	               			((MenuComponent)o[obj]).setFont(new	Font(font,((MenuComponent)o[obj]).getFont().getStyle(),
															 		 	  ((MenuComponent)o[obj]).getFont().getSize()));
	                  	}
						else if((o[obj] instanceof Image) || (o[obj] instanceof PrintJob))
	 					{
	 						if(((Graphics)o[obj+1]).getFont()==null)
	 							((Graphics)o[obj+1]).setFont(new Font("Dialog",Font.PLAIN,12));
	// java 2.0					((Graphics)o[obj+1]).setFont(new Font(Font.DEFAULT));
	               			((Graphics)o[obj+1]).setFont(new Font(font,((Graphics)o[obj+1]).getFont().getStyle(),
															 		   ((Graphics)o[obj+1]).getFont().getSize()));
	                  	}
	                  	else
         	  			    nextaction=errordialog.getResult("No valid Object ID in j_setfontname( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }



	 				/* Set Font Size */
	                if (command == JAPI_Calls.JAPI_SETFONTSIZE)
	              	{
	                 	int size = in.recvInt();

	 					if(debug>2) debugwindow.println("SetFontSize in "+o[obj].toString()+" to "+size);
	 					if(o[obj] instanceof Component)
	 					{
	 						if(((Component)o[obj]).getFont()==null)
	 							((Component)o[obj]).setFont(new Font("Dialog",Font.PLAIN,12));
	// java 2.0					((Component)o[obj]).setFont(new Font(Font.DEFAULT));
	               			((Component)o[obj]).setFont(new	Font(((Component)o[obj]).getFont().getName(),
														 	 	 ((Component)o[obj]).getFont().getStyle(),size));
	                  	}
	                  	else if(o[obj] instanceof MenuComponent)
	 					{
	 						if(((MenuComponent)o[obj]).getFont()==null)
	 							((MenuComponent)o[obj]).setFont(new Font("Dialog",Font.PLAIN,12));
	// java 2.0					((MenuComponent)o[obj]).setFont(new Font(Font.DEFAULT));
	               			((MenuComponent)o[obj]).setFont(new	Font(((MenuComponent)o[obj]).getFont().getName(),
														 	 	 	 ((MenuComponent)o[obj]).getFont().getStyle(),size));
	                  	}
						else if((o[obj] instanceof Image) || (o[obj] instanceof PrintJob))
	 					{
	 						if(((Graphics)o[obj+1]).getFont()==null)
	 							((Graphics)o[obj+1]).setFont(new Font("Dialog",Font.PLAIN,12));
	// java 2.0					((Graphics)o[obj+1]).setFont(new Font(Font.DEFAULT));
	               			((Graphics)o[obj+1]).setFont(new Font(((Graphics)o[obj+1]).getFont().getName(),
														 	      ((Graphics)o[obj+1]).getFont().getStyle(),size));
	 					}
	                  	else
         	  			    nextaction=errordialog.getResult("No valid Object ID in j_setfontsize( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }


					/* Set Font Style */
	                if (command == JAPI_Calls.JAPI_SETFONTSTYLE)
	              	{
	                 	int style = in.recvInt();

	 					if(debug>2) debugwindow.println("SetFontStyle in "+o[obj].toString()+" to "+style);
	 					if(o[obj] instanceof Component)
	 					{
	 						if(((Component)o[obj]).getFont()==null)
	 							((Component)o[obj]).setFont(new Font("Dialog",Font.PLAIN,12));
	// java 2.0					((Component)o[obj]).setFont(new Font(Font.DEFAULT));
	               			((Component)o[obj]).setFont(new Font(((Component)o[obj]).getFont().getName(),style,
														 	 	 ((Component)o[obj]).getFont().getSize()));
	                  	}
	                  	else if(o[obj] instanceof MenuComponent)
	 					{
	 						if(((MenuComponent)o[obj]).getFont()==null)
	 							((MenuComponent)o[obj]).setFont(new Font("Dialog",Font.PLAIN,12));
	// java 2.0					((MenuComponent)o[obj]).setFont(new Font(Font.DEFAULT));
	               			((MenuComponent)o[obj]).setFont(new Font(((MenuComponent)o[obj]).getFont().getName(),style,
														 	 	 	 ((MenuComponent)o[obj]).getFont().getSize()));
	                  	}
						else if((o[obj] instanceof Image) || (o[obj] instanceof PrintJob))
	 					{
	 						if(((Graphics)o[obj+1]).getFont()==null)
	 							((Graphics)o[obj+1]).setFont(new Font("Dialog",Font.PLAIN,12));
	// java 2.0					((Graphics)o[obj+1]).setFont(new Font(Font.DEFAULT));
	               			((Graphics)o[obj+1]).setFont(new Font(((Graphics)o[obj+1]).getFont().getName(),style,
														 	  	  ((Graphics)o[obj+1]).getFont().getSize()));
	                  	}
	                  	else
         	  			    nextaction=errordialog.getResult("No valid Object ID in j_setfontstyle( ID , ... )\nID = "+o[obj].toString());

	                 	continue;
	                }


	 				/* set Text */
	                if (command == JAPI_Calls.JAPI_SETTEXT)
	              	{
	               		int len = in.recvInt();

	 	              	if(len>0)
	               		{
		              		byte[] buf = new byte[len];
		                 	in.read(buf,0,len);

		       			    String newtext = new String(buf);

		 					if(debug>2) debugwindow.println("Set Text "+o[obj].toString()+" Laenge "+len);

							// Dialog, Popupmenu, Radiobutton, Checkbox ....?
	 		    			if(o[obj] instanceof Frame)
	            	   			((Frame)o[obj]).setTitle(newtext);
	 		    			else if(o[obj] instanceof Dialog)
	            	   			((Dialog)o[obj]).setTitle(newtext);
	 						else if(o[obj] instanceof JAPI_Button)
	               				((JAPI_Button)o[obj]).setLabel(newtext);
	 						else if(o[obj] instanceof JAPI_Label)
	    	           			((JAPI_Label)o[obj]).setText(newtext);
	 						else if(o[obj] instanceof JAPI_Menu)
	            	   			((JAPI_Menu)o[obj]).setLabel(newtext);
	 						else if(o[obj] instanceof MenuItem)
		               			((MenuItem)o[obj]).setLabel(newtext);
		 					else if(o[obj] instanceof CheckboxMenuItem)
	    	         			((CheckboxMenuItem)o[obj]).setLabel(newtext);
	        	          	else if(o[obj] instanceof TextComponent)
		               			((TextComponent)o[obj]).setText(newtext);
		                    else
	         	  			    nextaction=errordialog.getResult("No valid Object ID in j_settext( ID , ... )\nID = "+o[obj].toString());
		          		}
	                 	continue;
	                }

	 				/* set editable */
	                if (command == JAPI_Calls.JAPI_EDITABLE)
	              	{
	               		int val = in.recvInt();

		 				if(debug>2) debugwindow.println(o[obj].toString()+" set editable to "+val);

		 				if(o[obj] instanceof TextComponent)
		               		((TextComponent)o[obj]).setEditable(val!=JAPI_Const.J_FALSE);
		                else
	         	  			nextaction=errordialog.getResult("No valid Object ID in j_editable( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }


	 				/* Set Alignment */
	                if (command == JAPI_Calls.JAPI_SETALIGN)
	              	{
	                 	int align = in.recvInt();

	 					if((align != JAPI_Const.J_LEFT) && (align != JAPI_Const.J_CENTER) && (align != JAPI_Const.J_RIGHT) &&
	 					   (align != JAPI_Const.J_BOTTOM) && (align != JAPI_Const.J_TOP) && (align != JAPI_Const.J_TOPLEFT) &&
	 					   (align != JAPI_Const.J_TOPRIGHT) && (align != JAPI_Const.J_BOTTOMLEFT) && (align != JAPI_Const.J_BOTTOMRIGHT))
		         	  	{
		         	  		nextaction=errordialog.getResult("No valid Alignment in j_setalign( ID , Alignment )\nAlignment = "+align);
	 					}
	 					else
	 					{
	 						if(debug>2) debugwindow.println("Set Alignment in "+o[obj].toString()+" to "+align);
	 						if(o[obj] instanceof JAPI_Label)
	 						{
	 							switch(align)
	 							{
	 							case(JAPI_Const.J_LEFT)   : ((JAPI_Label)o[obj]).setAlignment(Label.LEFT);continue;
	  							case(JAPI_Const.J_RIGHT)  : ((JAPI_Label)o[obj]).setAlignment(Label.RIGHT);continue;
	 							case(JAPI_Const.J_CENTER) : ((JAPI_Label)o[obj]).setAlignment(Label.CENTER);continue;
	 							}
	 						}
	 						else if(o[obj] instanceof Container)
		              		{
		              			if(((Container)o[obj]).getLayout() instanceof FlowLayout)
		              			{
									((FlowLayout)((Container)o[obj]).getLayout()).setAlignment(align);
									((FlowLayout)((Container)o[obj]).getLayout()).layoutContainer((Container)o[obj]);
								}
	 	 						else
		         	  				nextaction=errordialog.getResult("No valid Layout Manager in Object ID,  j_setalign( ID , ... )\nID = "+o[obj].toString());
	  						}
	  						else
		         	  			nextaction=errordialog.getResult("No valid Object ID in  j_setalign( ID , ... )\nID = "+o[obj].toString());
	          	  		}
	                 	continue;
	                }


	 				/* Set/Unset Fill FlowLaoyout */
	                if (command == JAPI_Calls.JAPI_FILLFLOWLAYOUT)
	              	{
	                 	int b   = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Fill FlowLayout "+o[obj].toString()+" to "+ b);
						if(o[obj] instanceof Container)
		              	{
		              		if(((Container)o[obj]).getLayout() instanceof JAPI_VFlowlayout)
		              		{
								((JAPI_VFlowlayout)((Container)o[obj]).getLayout()).setFill(b!=JAPI_Const.J_FALSE);
								((FlowLayout)((Container)o[obj]).getLayout()).layoutContainer((Container)o[obj]);
							}
	 	 					else if(((Container)o[obj]).getLayout() instanceof  JAPI_HFlowlayout)
							{
								((JAPI_HFlowlayout)((Container)o[obj]).getLayout()).setFill(b!=JAPI_Const.J_FALSE);
								((FlowLayout)((Container)o[obj]).getLayout()).layoutContainer((Container)o[obj]);
							}
	 	 					else
		         	  				nextaction=errordialog.getResult("No valid Layout Manager in Object ID,  j_fillflowlayout( ID , ... )\nID = "+o[obj].toString());
	  					}
	  					else
		         	  		nextaction=errordialog.getResult("No valid Object ID in  j_fillflowlayout( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }


					/* insert Text */
	                if (command == JAPI_Calls.JAPI_INSERTTEXT)
	              	{
	              		int pos = in.recvInt();
	              		int len = in.recvInt();

	  					if(debug>2) debugwindow.println("Insert Text in "+obj+" at position "+pos+" Textlength : "+len);
	               		if(len>0)
	               		{
	 	             		byte[] buf = new byte[len];
		                 	in.read(buf,0,len);

		 					if(o[obj] instanceof TextArea)
		               			((TextArea)o[obj]).insert(new String(buf),pos);
		                    else
		         	  			nextaction=errordialog.getResult("No valid Object ID in  j_inserttext( ID , ... )\nID = "+o[obj].toString());
	          		    }
	                 	continue;
	                }


	 				/* replace Text */
	                if (command == JAPI_Calls.JAPI_REPLACETEXT)
	              	{
	              		int start = in.recvInt();
	              		int end = in.recvInt();
	              		int len = in.recvInt();

		 				if(debug>2) debugwindow.println("Replace Text "+obj+" Textlength "+len);
	               		if(len>0)
	               		{
		             		byte[] buf = new byte[len];
		                 	in.read(buf,0,len);

		 					if(o[obj] instanceof TextArea)
		               			((TextArea)o[obj]).replaceRange(new String(buf),start,end);
		                    else
		         	  			nextaction=errordialog.getResult("No valid Object ID in  j_replacetext( ID , ... )\nID = "+o[obj].toString());
		                 	continue;
		                }
	                }

	 				/* replace Text */
	                if (command == JAPI_Calls.JAPI_REPLACETEXT)
	              	{
	              		int start = in.recvInt();
	              		int end = in.recvInt();
	              		int len = in.recvInt();

		 				if(debug>2) debugwindow.println("Replace Text "+obj+" Textlength "+len);
	               		if(len>0)
	               		{
		             		byte[] buf = new byte[len];
		                 	in.read(buf,0,len);

		 					if(o[obj] instanceof TextArea)
		               			((TextArea)o[obj]).replaceRange(new String(buf),start,end);
		                    else
		         	  			nextaction=errordialog.getResult("No valid Object ID in  j_replacetext( ID , ... )\nID = "+o[obj].toString());
		                 	continue;
		                }
	                }


					/* select Text */
	                if (command == JAPI_Calls.JAPI_SELECTTEXT)
	              	{
	              		int start = in.recvInt();
	              		int end = in.recvInt();

		 				if(debug>2) debugwindow.println("Select Text "+obj+" from "+start+" to "+end);
		 				if(o[obj] instanceof TextArea)
		               		((TextArea)o[obj]).select(start,end);
		                else
		         	  		nextaction=errordialog.getResult("No valid Object ID in  j_selecttext( ID , ... )\nID = "+o[obj].toString());
		                 continue;
	                }


					/* append Text */
	                if (command == JAPI_Calls.JAPI_APPENDTEXT)
	              	{
	              		int len = in.recvInt();
		             	byte[] buf = new byte[len];
		                in.read(buf,0,len);

		 				if(debug>2) debugwindow.println("Append Text "+obj+" : "+new String(buf));

	 					if(o[obj] instanceof TextArea)
	               			((TextArea)o[obj]).append(new String(buf));
	                    else
		         	  		nextaction=errordialog.getResult("No valid Object ID in  j_appendtext( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }


	 				/* set Echo Character */
	                if (command == JAPI_Calls.JAPI_SETECHOCHAR)
	              	{
	              		byte echo = in.readByte();

		 				if(debug>2) debugwindow.println("SeT Echo Charakter in "+o[obj].toString()+" to '"+(char)echo+"'");

	 					if(o[obj] instanceof TextField)
	               			((TextField)o[obj]).setEchoChar((char)echo);
	                    else
		         	  		nextaction=errordialog.getResult("No valid Object ID in  j_setechochar( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }



	 				/* set Shortcut */
	                if (command == JAPI_Calls.JAPI_SETSHORTCUT)
	              	{
	              		byte c  = in.readByte();

		 				if(debug>2) debugwindow.println("Set Shortcut Charakter in "+o[obj].toString()+" to '"+(char)c+"'");

	 					if(o[obj] instanceof MenuItem)
	               			((MenuItem)o[obj]).setShortcut(new MenuShortcut((char)c));
	                    else
		         	  		nextaction=errordialog.getResult("No MenuItem ID in j_setechochar( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }


	   				/* Get Cursor Position */
	                if (command == JAPI_Calls.JAPI_SETCURPOS)
	              	{
	              		int pos = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Selection Start "+o[obj].toString());
	 					if(o[obj] instanceof TextComponent)
	 						((TextComponent)o[obj]).setCaretPosition(pos);
	                    else
		         	  		nextaction=errordialog.getResult("No TextComponent ID in j_setcurpos( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }


	  				/* Set Value */
	                if (command == JAPI_Calls.JAPI_SETVALUE)
	              	{
	              		int val = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Value "+o[obj].toString()+" to "+val);
	 					if(o[obj] instanceof Adjustable)
	 						((Adjustable)o[obj]).setValue(val);
	                    else if (o[obj] instanceof JAPI_ValueComponent)
	 						((JAPI_ValueComponent)o[obj]).setValue(val);
	                    else
	                    	nextaction=errordialog.getResult("No Scrollbar ID in j_setvalue( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }

	  				/* Set Unit Increment */
	                if (command == JAPI_Calls.JAPI_SETUNITINC)
	              	{
	              		int val = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Unit Increment to "+val);
	 					if(o[obj] instanceof Adjustable)
	 						((Adjustable)o[obj]).setUnitIncrement(val);
	                    else
		         	  		nextaction=errordialog.getResult("No Scrollbar ID in j_setunitinc( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }

	  				/* Set Block Increment */
	                if (command == JAPI_Calls.JAPI_SETBLOCKINC)
	              	{
	              		int val = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Block Increment to "+val);
	 					if(o[obj] instanceof Adjustable)
	 						((Adjustable)o[obj]).setBlockIncrement(val);
	                    else
		         	  		nextaction=errordialog.getResult("No Scrollbar ID in j_setblockinc( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }

	   				/* Set Minimum */
	                if (command == JAPI_Calls.JAPI_SETMIN)
	              	{
	              		int val = in.recvInt();

	 				 	if(debug>2) debugwindow.println("Set Minimum to "+val);
	 					if(o[obj] instanceof Adjustable)
	 						((Adjustable)o[obj]).setMinimum(val);
	                    else if (o[obj] instanceof JAPI_ValueComponent)
	 						((JAPI_ValueComponent)o[obj]).setMinimum(val);
	                    else
		         	  		nextaction=errordialog.getResult("No Scrollbar ID in j_setmin( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }


	   				/* Set Maximum */
	                if (command == JAPI_Calls.JAPI_SETMAX)
	              	{
	              		int val = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Maximum to "+val);
	 					if(o[obj] instanceof Adjustable)
	 						((Adjustable)o[obj]).setMaximum(val);
	                    else if (o[obj] instanceof JAPI_ValueComponent)
	 						((JAPI_ValueComponent)o[obj]).setMaximum(val);
	                    else
	          	  			debugwindow.println("ERROR : no valid Object for Set Maximum (must be a Scrollbar) ");
	                 	continue;
	                }

	   				/* Set Danger */
	                if (command == JAPI_Calls.JAPI_SETDANGER)
	              	{
	              		int val = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Danger to "+val);
	 					if(o[obj] instanceof JAPI_Meter)
	 						((JAPI_Meter)o[obj]).setDanger(val);
	                    else
	          	  			debugwindow.println("ERROR : no valid Object for SetDanger");
	                 	continue;
	                }

	    			/* Set Visible */
	                if (command == JAPI_Calls.JAPI_SETVISIBLE)
	              	{
	              		int val = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Visible to "+val);
	 					if(o[obj] instanceof Adjustable)
	 						((Adjustable)o[obj]).setVisibleAmount(val);
	                    else
		         	  		nextaction=errordialog.getResult("No Scrollbar ID in j_setvisible( ID , ... )\nID = "+o[obj].toString());
	                 	continue;
	                }


	                /* Get Focus */
	                if (command == JAPI_Calls.JAPI_SETFOCUS)
	              	{
	 					if(debug>2) debugwindow.println("Get Focus");
	 					if(o[obj] instanceof Component)
	 						((Component)o[obj]).requestFocus();
	                  	else
		         	  		nextaction=errordialog.getResult("No Component ID in j_setfocus( ID , ... )\nID = "+o[obj].toString());
	                  	continue;
	 				}


	 				/* Select All */
	                if (command == JAPI_Calls.JAPI_SELECTALL)
	              	{
	 					if(debug>2) debugwindow.println("Select All in "+obj);
	 					if(o[obj] instanceof TextComponent)
	 						((TextComponent)o[obj]).selectAll();
	                    else
		         	  		nextaction=errordialog.getResult("No Text Component ID in j_selectall( ID , ... )\nID = "+o[obj].toString());
	                    continue;
	 				}

					/* Delete Text */
	                if (command == JAPI_Calls.JAPI_DELETE)
	              	{
	              		int start = in.recvInt();
	              		int end   = in.recvInt();

	 					if(debug>2) debugwindow.println("Delete Text in "+obj);
	 					if(o[obj] instanceof TextArea)
	 						((TextArea)o[obj]).replaceRange("",start,end);
	                    else
		         	  		nextaction=errordialog.getResult("No TextArea ID in j_delete( ID , ... )\nID = "+o[obj].toString());
	                    continue;
	 				}

					/* Show Popuop */
	                if (command == JAPI_Calls.JAPI_SHOWPOPUP)
	              	{
	              		int x     = in.recvInt();
	              		int y     = in.recvInt();

	 					if(debug>2) debugwindow.println("Show Popup "+o[obj].toString()+" at "+x+":"+y);
	 					if(o[obj] instanceof PopupMenu)
	 						((PopupMenu)o[obj]).show((Component)(((Menu)o[obj]).getParent()),x,y);
	 		            else
		         	  		nextaction=errordialog.getResult("No Popup ID in j_showpopup( ID , ... )\nID = "+o[obj].toString());
	                    continue;
	 				}

	   				/* Set Resizable */
	                if (command == JAPI_Calls.JAPI_SETRESIZABLE)
	              	{
	              		int val = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Resizable "+o[obj].toString()+" to "+val);
	 					if(o[obj] instanceof JAPI_Frame)
    						((JAPI_Frame)o[obj]).setResizable(val!=JAPI_Const.J_FALSE);
	                    else if(o[obj] instanceof JAPI_Dialog)
	 						((JAPI_Dialog)o[obj]).setResizable(val!=JAPI_Const.J_FALSE);
						else
							nextaction=errordialog.getResult("ERROR : no valid Object for j_setrezisable\nmust be a Frame or Dialog");
	                 	continue;

	                }

	   				/* Set Icon */
	                if (command == JAPI_Calls.JAPI_SETICON)
	              	{
	              		int icon = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Icon "+o[obj].toString()+" to "+o[icon].toString());
	 					if(o[obj] instanceof Frame)
	 						if(o[icon] instanceof Image)
	 						    ((Frame)o[obj]).setIconImage((Image)o[icon]);
		                    else
		                    	nextaction=errordialog.getResult("ERROR : no valid Image for j_seticon(frame,image)");
						else
							nextaction=errordialog.getResult("ERROR : no valid Object for j_seticon(frame,image)\nhas to be a Frame");
	                 	continue;
	                }

	   				/* Set Rows */
	                if (command == JAPI_Calls.JAPI_SETROWS)
	              	{
	              		int val = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Rows to "+val);
	 					if(o[obj] instanceof JAPI_Textarea)
	 						((JAPI_Textarea)o[obj]).setRows(val);
	                    else if(o[obj] instanceof GridLayout)
	 						((GridLayout)o[obj]).setRows(val);
	            		else
							nextaction=errordialog.getResult("ERROR : no valid Object for Set Rows\n(must be a TextArea) ");
	                 	continue;
	                }

	   				/* Set Columns */
	                if (command == JAPI_Calls.JAPI_SETCOLUMNS)
	              	{
	              		int val = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Columns to "+val);
	 					if(o[obj] instanceof TextArea)
	 						((TextArea)o[obj]).setColumns(val);
	                    else if(o[obj] instanceof TextField)
	 						((TextField)o[obj]).setColumns(val);
	          	  		else if(o[obj] instanceof GridLayout)
	 						((GridLayout)o[obj]).setColumns(val);
	                    else
							nextaction=errordialog.getResult("ERROR : no valid Object for Set Columns\n(must be a TextArea/Filed) ");
	                 	continue;
	                }

	   				/* Set Image */
		                if (command == JAPI_Calls.JAPI_SETIMAGE)
		              	{
		              		int image = in.recvInt();

		 					if(debug>2) debugwindow.println("Set Image in "+obj+" to "+image);
		 					if(o[image] instanceof Image)
		 					{
		 						if(o[obj] instanceof JAPI_Graphicbutton)
		 							((JAPI_Graphicbutton)o[obj]).setImage((Image)o[image]);
		                    	else if(o[obj] instanceof JAPI_Graphiclabel)
		 							((JAPI_Graphiclabel)o[obj]).setImage((Image)o[image]);
		          	  			else
									nextaction=errordialog.getResult("ERROR : no valid Object for j_setimage\n(must be a Graphicbutton/Image) ");
		                 		continue;
		                	}
		                	else
								nextaction=errordialog.getResult("ERROR : no valid ImageObject for j_setimage(...,image) ");
						}

   					/* Set Radiogroup */
	                if (command == JAPI_Calls.JAPI_SETRADIOGROUP)
	              	{
	              		int rp = in.recvInt();

	 					if(debug>2) debugwindow.println("Set Radiogroup "+obj+" to "+rp);
	 					if(o[rp] instanceof CheckboxGroup)
	 					{
	 						if(o[obj] instanceof Checkbox)
	 							((Checkbox)o[obj]).setCheckboxGroup((CheckboxGroup)o[rp]);
	          	  			else
								nextaction=errordialog.getResult("ERROR : no valid Object for j_setradiogroup\n(must be a radiobutton) ");
	                 		continue;
	                	}
	                	else
							nextaction=errordialog.getResult("ERROR : no valid Radiogroup for j_setimage(...,radiogroup) ");
					}


					if(command == JAPI_Calls.JAPI_BEEP)
						Toolkit.getDefaultToolkit().beep();

					continue;



			//                        Q U E S T I O N S
  			case(JAPI_Calls.JAPI_QUESTIONS):

				/* Sync */
    	        if (command == JAPI_Calls.JAPI_SYNC)
        	    {
	 				if(debug>2) debugwindow.println("Sync");
    	         	out.sendInt(JAPI_Const.J_TRUE);
        	       	continue;
             	}

 				/* Get State */
                if (command == JAPI_Calls.JAPI_GETSTATE)
              	{
 					if(debug>2) debugwindow.println("Getstate");
					if(o[obj] instanceof CheckboxMenuItem)
             			out.sendInt(((CheckboxMenuItem)o[obj]).getState()?JAPI_Const.J_TRUE:JAPI_Const.J_FALSE);
                  	else if(o[obj] instanceof JAPI_Checkbox)
             			out.sendInt(((JAPI_Checkbox)o[obj]).getState()?JAPI_Const.J_TRUE:JAPI_Const.J_FALSE);
					else if(o[obj] instanceof JAPI_Radiobutton)
             			out.sendInt(((JAPI_Radiobutton)o[obj]).getState()?JAPI_Const.J_TRUE:JAPI_Const.J_FALSE);
					else if(o[obj] instanceof JAPI_Led)
             			out.sendInt(((JAPI_Led)o[obj]).getState()?JAPI_Const.J_TRUE:JAPI_Const.J_FALSE);
					else
                  	{
		         	  	nextaction=errordialog.getResult("No valid Object ID in j_getstate( ID , ... )\nID = "+o[obj].toString());
           	  			out.sendInt(-1);
                  	}
                  	continue;
                }

  				/* Get Select */
                if (command == JAPI_Calls.JAPI_GETSELECT)
              	{
 					if(debug>2) debugwindow.println("Get Selected Index");
					if(o[obj] instanceof JAPI_List)
             			out.sendInt(((JAPI_List)o[obj]).getSelectedIndex());
					else if(o[obj] instanceof JAPI_Choice)
             			out.sendInt(((JAPI_Choice)o[obj]).getSelectedIndex());
					else
                  	{
		         	  	nextaction=errordialog.getResult("No List or Choice ID in j_getselect( ID , ... )\nID = "+o[obj].toString());
          	  			out.sendInt(-1);
                  	}
                  	continue;
                }

  				/* Is Select */
                if (command == JAPI_Calls.JAPI_ISSELECT)
              	{
                	int index = in.recvInt();
 					if(debug>2) debugwindow.println("Is "+index+" Selected ?");

					if(o[obj] instanceof JAPI_List)
             			out.sendInt(((JAPI_List)o[obj]).isIndexSelected(index)?JAPI_Const.J_TRUE:JAPI_Const.J_FALSE);
					else
                  	{
		         	  	nextaction=errordialog.getResult("No List ID in j_isselect( ID , ... )\nID = "+o[obj].toString());
        	  			out.sendInt(-1);
                  	}
                  	continue;
                }

 				/* Get Width */
                if (command == JAPI_Calls.JAPI_GETWIDTH)
              	{
 					if(debug>2) debugwindow.println("Get Width of Object "+o[obj].toString());

					if(o[obj] instanceof Component)
             			out.sendInt(((Component)o[obj]).getSize().width);
					else if(o[obj] instanceof Image)
             			out.sendInt(((Image)o[obj]).getWidth(new Label()));
					else if(o[obj] instanceof PrintJob)
             			out.sendInt(((PrintJob)o[obj]).getPageDimension().width);
					else
                  	{
		         	  	nextaction=errordialog.getResult("No Component or Image ID in j_getwidth( ID , ... )\nID = "+o[obj].toString());
          	  			out.sendInt(-1);
                  	}
                  	continue;
                }

				/* Get Height */
                if (command == JAPI_Calls.JAPI_GETHEIGHT)
              	{
 					if(debug>2) debugwindow.println("Get Height of Object "+o[obj].toString());

					if(o[obj] instanceof Component)
             			out.sendInt(((Component)o[obj]).getSize().height);
					else if(o[obj] instanceof Image)
             			out.sendInt(((Image)o[obj]).getHeight(new Label()));
					else if(o[obj] instanceof PrintJob)
             			out.sendInt(((PrintJob)o[obj]).getPageDimension().height);
					else
                  	{
		         	  	nextaction=errordialog.getResult("No Component or Image ID in j_getheight( ID , ... )\nID = "+o[obj].toString());
          	  			out.sendInt(-1);
                  	}
                  	continue;
                }

 				/* Get Inset Width */
                if (command == JAPI_Calls.JAPI_GETINWIDTH)
              	{
 					if(debug>2) debugwindow.println("Get Inset Width of Object "+o[obj].toString());

					if(o[obj] instanceof Container)
             			out.sendInt(((Container)o[obj]).getSize().width-
             			            ((Container)o[obj]).getInsets().left-
             			            ((Container)o[obj]).getInsets().right);
					else
                  	{
		         	  	nextaction=errordialog.getResult("No Container ID in j_getinwidth( ID , ... )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                  	continue;
                }

				/* Get Inset Height */
                if (command == JAPI_Calls.JAPI_GETINHEIGHT)
              	{
 					if(debug>2) debugwindow.println("Get Inset Height of Object "+o[obj].toString());

					if(o[obj] instanceof Container)
            			out.sendInt(((Container)o[obj]).getSize().height-
             			            ((Container)o[obj]).getInsets().top-
             			            ((Container)o[obj]).getInsets().bottom);
					else
                  	{
		         	  	nextaction=errordialog.getResult("No Container ID in j_getinheight( ID , ... )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                  	continue;
                }

				/* Get Value */
                if (command == JAPI_Calls.JAPI_GETVALUE)
              	{
 					if(debug>2) debugwindow.println("Get Value ? "+o[obj].toString());

					if(o[obj] instanceof Adjustable)
             			out.sendInt(((Adjustable)o[obj]).getValue());
	                else if (o[obj] instanceof JAPI_ValueComponent)
	 					out.sendInt(((JAPI_ValueComponent)o[obj]).getValue());
					else
                  	{
		         	  	nextaction=errordialog.getResult("No Value Component ID in j_getvalue( ID , ... )\nID = "+o[obj].toString());
        	  			out.sendInt(-1);
                  	}
                  	continue;
                }

				/* Get Danger */
                if (command == JAPI_Calls.JAPI_GETDANGER)
              	{
 					if(debug>2) debugwindow.println("Get Danger ? "+o[obj].toString());

					if(o[obj] instanceof JAPI_Meter)
             			out.sendInt(((JAPI_Meter)o[obj]).getDanger());
					else
                  	{
		         	  	nextaction=errordialog.getResult("No Meter Component ID in j_getdanger( ID , ... )\nID = "+o[obj].toString());
        	  			out.sendInt(-1);
                  	}
                  	continue;
                }

 				/* Get Label */
                if (command == JAPI_Calls.JAPI_GETTEXT)
              	{
       			    String inhalt;

// 					if(debug>2) debugwindow.println("Get Label or Text "+o[obj].toString());
 					if(debug>2) debugwindow.println("Get Label or Text ");
 					if(o[obj] instanceof TextComponent)
 						inhalt=((TextComponent)o[obj]).getText();
 					else if(o[obj] instanceof JAPI_Frame)
               			inhalt=((JAPI_Frame)o[obj]).getTitle();
 					else if(o[obj] instanceof JAPI_Dialog)
               			inhalt=((JAPI_Dialog)o[obj]).getTitle();
 					else if(o[obj] instanceof JAPI_Button)
 						inhalt=((JAPI_Button)o[obj]).getLabel();
 					else if(o[obj] instanceof JAPI_Label)
 						inhalt=((JAPI_Label)o[obj]).getText();
 					else if(o[obj] instanceof JAPI_Menu)
               			inhalt=((JAPI_Menu)o[obj]).getLabel();
 					else if(o[obj] instanceof MenuItem)
						inhalt=((MenuItem)o[obj]).getLabel();
  					else if(o[obj] instanceof CheckboxMenuItem)
             			inhalt=((CheckboxMenuItem)o[obj]).getLabel();
                    else
                  	{
		         	  	nextaction=errordialog.getResult("No valid Object ID in j_gettext( ID , ... )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
           		      	continue;
                  	}
                  	if(debug>2) debugwindow.println("Get Label or Text READY");

    				out.sendInt(inhalt.length());
    				byte[] buf = inhalt.getBytes();
              		out.write(buf);
                 	continue;
                }

				/* Get Item */
                if (command == JAPI_Calls.JAPI_GETITEM)
              	{
       				int nr  = in.recvInt();

       			    String inhalt;

 					if(debug>2) debugwindow.println("Get Item Nr:"+nr+" of "+o[obj].toString());
 					if(o[obj] instanceof List)
 						inhalt=((List)o[obj]).getItem(nr);
 	                else if(o[obj] instanceof Choice)
						inhalt=((Choice)o[obj]).getItem(nr);
                    else if(o[obj] instanceof Menu)
 						inhalt=((Menu)o[obj]).getItem(nr).getLabel();
 	                else if(o[obj] instanceof MenuBar)
						inhalt=((MenuBar)o[obj]).getMenu(nr).getLabel();
                    else
                  	{
		         	  	nextaction=errordialog.getResult("No List, Choice, Menu or MenuBar ID in j_getitem( ID , ... )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
           		      	continue;
                  	}
		   			out.sendInt(inhalt.length());
		   			byte[] buf = inhalt.getBytes();
              		out.write(buf);
                	continue;
                }


				/* Get Item Count */
                if (command == JAPI_Calls.JAPI_GETITEMCOUNT)
              	{
       				int retval;

 					if(debug>2) debugwindow.println("Get Item Count of "+o[obj].toString());
 					if(o[obj] instanceof List)
 						retval=((List)o[obj]).getItemCount();
 	                else if(o[obj] instanceof Choice)
						retval=((Choice)o[obj]).getItemCount();
 	                else if(o[obj] instanceof Menu)
						retval=((Menu)o[obj]).getItemCount();
 	                else if(o[obj] instanceof MenuBar)
						retval=((MenuBar)o[obj]).getMenuCount();
                    else
                  	{
		         	  	nextaction=errordialog.getResult("No List, Choice, Menu or MenuBar ID in j_getitemcount( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
           		      	continue;
                  	}

    				out.sendInt(retval);

                 	continue;
                }

				/* Get selected Text */
                if (command == JAPI_Calls.JAPI_GETSELTEXT)
              	{
       			    String inhalt;

 					if(debug>2) debugwindow.println("Get selected Text "+obj);
 					if(o[obj] instanceof TextComponent)
 					{
 						inhalt=((TextComponent)o[obj]).getSelectedText();
   			 			out.sendInt(inhalt.length());
   			 			byte[] buf = inhalt.getBytes();
  	            		out.write(buf);
                	}
                    else
                  	{
		         	  	nextaction=errordialog.getResult("No Text Component ID in j_getseltext( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                 	}
                 	continue;
                }

  				/* Get Length */
                if (command == JAPI_Calls.JAPI_GETLENGTH)
              	{
 					if(debug>2) debugwindow.println("Get Length "+obj);
 					if(o[obj] instanceof TextComponent)
 						out.sendInt(((TextComponent)o[obj]).getText().length());
                    else if(o[obj] instanceof JAPI_Frame)
               			out.sendInt(((JAPI_Frame)o[obj]).getTitle().length());
 					else if(o[obj] instanceof JAPI_Button)
 						out.sendInt(((JAPI_Button)o[obj]).getLabel().length());
 					else if(o[obj] instanceof JAPI_Menu)
               			out.sendInt(((JAPI_Menu)o[obj]).getLabel().length());
 					else if(o[obj] instanceof MenuItem)
						out.sendInt(((MenuItem)o[obj]).getLabel().length());
  					else if(o[obj] instanceof CheckboxMenuItem)
             			out.sendInt(((CheckboxMenuItem)o[obj]).getLabel().length());
                    else
                  	{
		         	  	nextaction=errordialog.getResult("No valid Object ID in j_getlength( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

   				/* Get Selection Start */
                if (command == JAPI_Calls.JAPI_GETSELSTART)
              	{
 					if(debug>2) debugwindow.println("Get Selection Start "+obj);
 					if(o[obj] instanceof TextComponent)
 						out.sendInt(((TextComponent)o[obj]).getSelectionStart());
                    else
                  	{
		         	  	nextaction=errordialog.getResult("No Text Component ID in j_getselstart( ID )\nID = "+o[obj].toString());
        	  			out.sendInt(-1);
                  	}
                 	continue;
                }

   				/* Get Selection End */
                if (command == JAPI_Calls.JAPI_GETSELEND)
              	{
 					if(debug>2) debugwindow.println("Get Selection End "+obj);
 					if(o[obj] instanceof TextComponent)
 						out.sendInt(((TextComponent)o[obj]).getSelectionEnd());
                    else
                  	{
 		         	  	nextaction=errordialog.getResult("No Text Component ID in j_getselend( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}

                 	continue;
                }

   				/* Get Cursor Position */
                if (command == JAPI_Calls.JAPI_GETCURPOS)
              	{
 					if(debug>2) debugwindow.println("Get Cursor Position "+obj);
 					if(o[obj] instanceof TextComponent)
 						out.sendInt(((TextComponent)o[obj]).getCaretPosition());
                    else
                  	{
 		         	  	nextaction=errordialog.getResult("No Text Component ID in j_getcurpos( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

   				/* Get Viewport Height */
                if (command == JAPI_Calls.JAPI_VIEWHEIGHT)
              	{
 					if(debug>2) debugwindow.println("Get Viewport Height "+o[obj].toString());
 					if(o[obj] instanceof ScrollPane)
 						out.sendInt(((ScrollPane)o[obj]).getViewportSize().height);
                    else
                  	{
 		         	  	nextaction=errordialog.getResult("No Scrollpane ID in j_viewheight( ID )\nID = "+o[obj].toString());
        	  			out.sendInt(-1);
                  	}
                 	continue;
                }

     			/* Get Viewport Width */
                if (command == JAPI_Calls.JAPI_VIEWWIDTH)
              	{
 					if(debug>2) debugwindow.println("Get Viewport Width "+o[obj].toString());
 					if(o[obj] instanceof ScrollPane)
 						out.sendInt(((ScrollPane)o[obj]).getViewportSize().width);
                    else
                  	{
 		         	  	nextaction=errordialog.getResult("No Scrollpane ID in j_viewwidth( ID )\nID = "+o[obj].toString());
          	  			out.sendInt(-1);
                   	}
                 	continue;
                }


				/* Get Key Char */
                if (command == JAPI_Calls.JAPI_GETKEYCHAR)
              	{
 				 	if(debug>2) debugwindow.println("Get Keychar from "+o[obj].toString());
 					if(o[obj] instanceof JAPI_Keylistener)
               			((JAPI_Keylistener)o[obj]).getchar();
                   	else
                   	{
 		         	  	nextaction=errordialog.getResult("No Key Listener ID in j_getkeychar( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

   				/* Get Key Code */
                if (command == JAPI_Calls.JAPI_GETKEYCODE)
              	{
 					if(debug>2) debugwindow.println("Get Keycode from "+o[obj].toString());
 					if(o[obj] instanceof JAPI_Keylistener)
               			((JAPI_Keylistener)o[obj]).getcode();
                   	else
                   	{
		         	  	nextaction=errordialog.getResult("No Key Listener ID in j_getkeycode( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

  				/* Has Focus */
                if (command == JAPI_Calls.JAPI_HASFOCUS)
              	{
 					if(debug>2) debugwindow.println("Focus on "+o[obj].toString());
 					if(o[obj] instanceof JAPI_Focuslistener)
               			((JAPI_Focuslistener)o[obj]).hasfocus();
                   	else
                   	{
		         	  	nextaction=errordialog.getResult("No Focus Listener ID in j_hasfocus( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

   				/* Get Mouse X Position */
                if (command == JAPI_Calls.JAPI_GETMOUSEX)
              	{
              		int xpos=-1;
 					if(debug>2) debugwindow.println("Get Mouse X position");
 					if(o[obj] instanceof JAPI_Mouselistener)
               			xpos=((JAPI_Mouselistener)o[obj]).getxpos();
                   	else if(o[obj] instanceof JAPI_Mousemotionlistener)
               			xpos=((JAPI_Mousemotionlistener)o[obj]).getxpos();
                   	else
		         	  	nextaction=errordialog.getResult("No Mouse (Motion) Listener ID in j_getmousex( ID )\nID = "+o[obj].toString());
          	  		out.sendInt(xpos);
                 	continue;
                }

   				/* Get Mouse Y Position */
                if (command == JAPI_Calls.JAPI_GETMOUSEY)
              	{
              		int ypos=-1;
 					if(debug>2) debugwindow.println("Get Mouse Y position");
 					if(o[obj] instanceof JAPI_Mouselistener)
               			ypos=((JAPI_Mouselistener)o[obj]).getypos();
                   	else if(o[obj] instanceof JAPI_Mousemotionlistener)
               			ypos=((JAPI_Mousemotionlistener)o[obj]).getypos();
                   	else
 		         	  	nextaction=errordialog.getResult("No Mouse (Motion) Listener ID in j_getmousey( ID )\nID = "+o[obj].toString());

          	  		out.sendInt(ypos);
                   	continue;
                }

   				/* Get Mouse Button */
                if (command == JAPI_Calls.JAPI_GETMOUSEBUTTON)
              	{
              		int b=-1;
 					if(debug>2) debugwindow.println("Get Mouse Button");
 					if(o[obj] instanceof JAPI_Mouselistener)
               			b=((JAPI_Mouselistener)o[obj]).getbutton();
                   	else if(o[obj] instanceof JAPI_Mousemotionlistener)
               			b=((JAPI_Mousemotionlistener)o[obj]).getbutton();
                   	else
 		         	  	nextaction=errordialog.getResult("No Mouse (Motion) Listener ID in j_getmousey( ID )\nID = "+o[obj].toString());
					if(b==-1) out.sendInt(-1);
					if(b==InputEvent.BUTTON1_MASK) out.sendInt(JAPI_Const.J_LEFT);
					if(b==InputEvent.BUTTON2_MASK) out.sendInt(JAPI_Const.J_CENTER);
					if(b==InputEvent.BUTTON3_MASK) out.sendInt(JAPI_Const.J_RIGHT);
                   	continue;
                }

   				/* Get Window X Position */
                if (command == JAPI_Calls.JAPI_GETXPOS)
              	{
 					if(debug>2) debugwindow.println("Get X Position");
 					if(o[obj] instanceof Component)
 					{
							Point  p = ((Component)o[obj]).getLocation();
                			if(debug>2) debugwindow.println("Location at :"+p.x+":"+p.y);
	              			out.sendInt(p.x);
                	}
                   	else
                   	{
		         	  	nextaction=errordialog.getResult("No Component ID in j_getxpos( ID )\nID = "+o[obj].toString());
        	  			out.sendInt(-1);
                  	}
                 	continue;
                }

   				/* Get Window Y Position */
                if (command == JAPI_Calls.JAPI_GETYPOS)
              	{
 					if(debug>2) debugwindow.println("Get Y Position");
 					if(o[obj] instanceof Component)
 					{
							Point  p = ((Component)o[obj]).getLocation();
                			if(debug>2) debugwindow.println("Location at :"+p.x+":"+p.y);
	              			out.sendInt(p.y);
                	}
                   	else
                   	{
		         	  	nextaction=errordialog.getResult("No Component ID in j_getxpos( ID )\nID = "+o[obj].toString());
          	  			out.sendInt(-1);
                  	}
                 	continue;
                }

     			/* Get Insets */
                if (command == JAPI_Calls.JAPI_GETINSETS)
              	{
	               	int pos   = in.recvInt();
 					if(debug>2) debugwindow.println("Get Insets "+pos);
 					if(o[obj] instanceof Container)
 					{
							Insets i = ((Container)o[obj]).getInsets();
                			if(debug>2) debugwindow.println("Insets :"+i.top+" "+i.bottom+" "+i.top+" "+i.right);
	              			if(pos == JAPI_Const.J_TOP)
	              				out.sendInt(i.top);
	              			if(pos == JAPI_Const.J_BOTTOM)
	              				out.sendInt(i.bottom);
	              			if(pos == JAPI_Const.J_LEFT)
	              				out.sendInt(i.left);
	              			if(pos == JAPI_Const.J_RIGHT)
	              				out.sendInt(i.right);
                	}
                   	else
                   	{
		         	  	nextaction=errordialog.getResult("No Container ID in j_getinsets( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

    			/* Get String Width */
                if (command == JAPI_Calls.JAPI_STRINGWIDTH)
              	{
                	String str = in.readToLineEnd();

 					if(debug>2) debugwindow.println("Get String Width in Object : "+o[obj].toString()+" STRING = '"+str+"'");
					if(o[obj] instanceof Component)
 					{
  	 					if(((Component)o[obj]).getFont()==null)
	 						((Component)o[obj]).setFont(new Font("Dialog",Font.PLAIN,12));
// java 2.0				((Component)o[obj]).setFont(new Font(Font.DEFAULT));
             			out.sendInt(((Component)o[obj]).getFontMetrics(((Component)o[obj]).getFont()).stringWidth(str));
                    }
                    else if((o[obj] instanceof Image) || (o[obj] instanceof PrintJob))
 					{
  	 					if(((Graphics)o[obj+1]).getFont()==null)
	 						((Graphics)o[obj+1]).setFont(new Font("Dialog",Font.PLAIN,12));
// java 2.0				((Graphics)o[obj+1]).setFont(new Font(Font.DEFAULT));
             			out.sendInt(((Graphics)o[obj+1]).getFontMetrics(((Graphics)o[obj+1]).getFont()).stringWidth(str));
                    }
					else
                   	{
		         	  	nextaction=errordialog.getResult("No Component ID in j_getstringwidth( ID , ... )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
            	}

    			/* Get Font Height */
                if (command == JAPI_Calls.JAPI_FONTHEIGHT)
              	{
  					if(debug>2) debugwindow.println("Get Font Height in Object : "+o[obj].toString());
 					if(o[obj] instanceof Component)
 					{
  	 					if(((Component)o[obj]).getFont()==null)
	 						((Component)o[obj]).setFont(new Font("Dialog",Font.PLAIN,12));
// java 2.0				((Component)o[obj]).setFont(new Font(Font.DEFAULT));
             			out.sendInt(((Component)o[obj]).getFontMetrics(((Component)o[obj]).getFont()).getHeight());
                    }
                    else if((o[obj] instanceof Image) || (o[obj] instanceof PrintJob))
 					{
  	 					if(((Graphics)o[obj+1]).getFont()==null)
	 						((Graphics)o[obj+1]).setFont(new Font("Dialog",Font.PLAIN,12));
// java 2.0				((Graphics)o[obj+1]).setFont(new Font(Font.DEFAULT));
             			out.sendInt(((Graphics)o[obj+1]).getFontMetrics(((Graphics)o[obj+1]).getFont()).getHeight());
                    }
                    else
                   	{
		         	  	nextaction=errordialog.getResult("No Component ID in j_fontheight( ID )\nID = "+o[obj].toString());
          	  			out.sendInt(-1);
                 	}
                 	continue;
            	}

    			/* Get Font Ascent */
                if (command == JAPI_Calls.JAPI_FONTASCENT)
              	{
 					if(debug>2) debugwindow.println("Get Position");
 					if(o[obj] instanceof Component)
 					{
  	 					if(((Component)o[obj]).getFont()==null)
	 						((Component)o[obj]).setFont(new Font("Dialog",Font.PLAIN,12));
// java 2.0				((Component)o[obj]).setFont(new Font(Font.DEFAULT));
             			out.sendInt(((Component)o[obj]).getFontMetrics(((Component)o[obj]).getFont()).getAscent());
                    }
                    else if((o[obj] instanceof Image) || (o[obj] instanceof PrintJob))
 					{
  	 					if(((Graphics)o[obj+1]).getFont()==null)
	 						((Graphics)o[obj+1]).setFont(new Font("Dialog",Font.PLAIN,12));
// java 2.0				((Graphics)o[obj+1]).setFont(new Font(Font.DEFAULT));
             			out.sendInt(((Graphics)o[obj+1]).getFontMetrics(((Graphics)o[obj+1]).getFont()).getAscent());
                    }
                    else
                   	{
		         	  	nextaction=errordialog.getResult("No Component ID in j_fontascent( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}

                 	continue;
                }

  				/* Is Resizable */
                if (command == JAPI_Calls.JAPI_ISRESIZABLE)
              	{
 					if(debug>2) debugwindow.println("Is "+o[obj].toString()+" Resizable ?");

					if(o[obj] instanceof Frame)
             			out.sendInt(((Frame)o[obj]).isResizable()?JAPI_Const.J_TRUE:JAPI_Const.J_FALSE);
					else if(o[obj] instanceof Dialog)
             			out.sendInt(((Dialog)o[obj]).isResizable()?JAPI_Const.J_TRUE:JAPI_Const.J_FALSE);
                  	else
                  	{
		         	  	nextaction=errordialog.getResult("No Frame or Dialog  ID in j_isresizable( ID )\nID = "+o[obj].toString());
          	  			out.sendInt(-1);
                  	}
                  	continue;
                }

  				/* GetScreenWidth */
                if (command == JAPI_Calls.JAPI_GETSCREENWIDTH)
              	{
 					if(debug>2) debugwindow.println("Get Screen Width");
					out.sendInt(Toolkit.getDefaultToolkit().getScreenSize().width);
                	continue;
                }

  				/* GetScreenHeight */
                if (command == JAPI_Calls.JAPI_GETSCREENHEIGHT)
              	{
 					if(debug>2) debugwindow.println("Get Screen Height");
					out.sendInt(Toolkit.getDefaultToolkit().getScreenSize().height);
                	continue;
                }

   				/* Get Parent ID*/
                if (command == JAPI_Calls.JAPI_GETPARENTID)
              	{
					Object c=null;
					int i;

 					if(debug>2) debugwindow.println("Get Parent");
 					if(o[obj] instanceof JAPI_Radiobutton)
 						c=((Checkbox)o[obj]).getCheckboxGroup();
 					else if(o[obj] instanceof Component)
 						c=((Component)o[obj]).getParent();
 					else if(o[obj] instanceof MenuComponent)
 						c=((MenuComponent)o[obj]).getParent();
 					else if(o[obj] instanceof JAPI_Radiogroup)
 						c=((JAPI_Radiogroup)o[obj]).getParent();
                   	else
                   	{
		         	  	nextaction=errordialog.getResult("Can't get Parent of "+o[obj].toString());
          	  			out.sendInt(-1);
                  	}
					for(i=0;i<objectcounter;i++)
							if(o[i]==c) break;
	              	if(c==null)
	              		out.sendInt(-1);
	              	else
	              		out.sendInt(i);

                 	continue;
                }

   				/* Is Parent */
                if (command == JAPI_Calls.JAPI_ISPARENT)
              	{
					int p = in.recvInt();

 					if(debug>2) debugwindow.println("Is "+p+" Parent of "+obj);
 					if(o[obj] instanceof JAPI_Radiobutton)
 					{
 						if(((Checkbox)o[obj]).getCheckboxGroup()==o[p])
 							out.sendInt(JAPI_Const.J_TRUE);
					}
 					else if(o[obj] instanceof Component)
 					{
 						if(((Component)o[obj]).getParent()==o[p])
 							out.sendInt(JAPI_Const.J_TRUE);
					}
 					else if(o[obj] instanceof MenuComponent)
 					{
 						if(((MenuComponent)o[obj]).getParent()==o[p])
 							out.sendInt(JAPI_Const.J_TRUE);
					}
 					else if(o[obj] instanceof JAPI_Radiogroup)
 					{
 						if(((JAPI_Radiogroup)o[obj]).getParent()==o[p])
 							out.sendInt(JAPI_Const.J_TRUE);
					}

          	  		out.sendInt(JAPI_Const.J_FALSE);
                 	continue;
                }

   				/* Get Rows */
                if (command == JAPI_Calls.JAPI_GETROWS)
              	{
 					if(debug>2) debugwindow.println("Get Rows "+obj);
 					if(o[obj] instanceof JAPI_Textarea)
 						out.sendInt(((JAPI_Textarea)o[obj]).getRows());
                    else if(o[obj] instanceof List)
 						out.sendInt(((List)o[obj]).getRows());
                    else if(o[obj] instanceof GridLayout)
 						out.sendInt(((GridLayout)o[obj]).getRows());
                    else
                  	{
 		         	  	nextaction=errordialog.getResult("No TextArea Component ID in j_getcurpos( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

   				/* Get Columns */
                if (command == JAPI_Calls.JAPI_GETCOLUMNS)
              	{
 					if(debug>2) debugwindow.println("Get Columns "+obj);
 					if(o[obj] instanceof TextArea)
 						out.sendInt(((TextArea)o[obj]).getColumns());
                    else if(o[obj] instanceof TextField)
 						out.sendInt(((TextField)o[obj]).getColumns());
                    else if(o[obj] instanceof GridLayout)
 						out.sendInt(((GridLayout)o[obj]).getColumns());
                    else
                  	{
 		         	  	nextaction=errordialog.getResult("No TextArea/Filed Component ID in j_getcurpos( ID )\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

   				/* Get Layout ID */
                if (command == JAPI_Calls.JAPI_GETLAYOUTID)
              	{
					LayoutManager layout;
 					if(debug>2) debugwindow.println("Get Layout Manager of "+obj);
 					if(o[obj] instanceof Container)
 					{
						if((layout = ((Container)o[obj]).getLayout())==null)
							out.sendInt(-1);
						else
						{
							int i;
							for(i=0;i<objectcounter && o[i]!=layout;i++);
 							out.sendInt(i);
						}
					}
 				    else
                  	{
 		         	  	nextaction=errordialog.getResult("No Container ID in j_getlayout\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

   				/* Is Visible */
                if (command == JAPI_Calls.JAPI_ISVISIBLE)
              	{
 					if(debug>2) debugwindow.println("Is Visible "+obj);
 					if(o[obj] instanceof Component)
 						out.sendInt(((Component)o[obj]).isVisible()?JAPI_Const.J_TRUE:JAPI_Const.J_FALSE);
					else
                  	{
 		         	  	nextaction=errordialog.getResult("No Component ID in j_isvisible\nID = "+o[obj].toString());
         	  			out.sendInt(-1);
                  	}
                 	continue;
                }

				continue;




                //			             C O N S T R U C T O R S
   				case(JAPI_Calls.JAPI_CONSTRUCTORS): new_Component(command,obj);
													continue;

                //			              L I S T E N E R S
  				case(JAPI_Calls.JAPI_LISTENERS): new_Listener(command,obj);
													continue;

				//		                L A Y O U T M A N A G E R
  				case(JAPI_Calls.JAPI_LAYOUTMANAGER): new_Layoutmanager(command,obj);
													continue;

       		    //                     U N K N O W N   C O M M A N D
			    default:  if(command == 0) // <Cntl>C
			         	      nextaction=false;
  					      else
  					          nextaction=errordialog.getResult("Unknown JAPI Command : "+command);
			}

       	} /* End of Main Loop */

        } catch (IOException e) {;}

 		/* Aufraeumen */
    	for(int i=0; i<objectcounter; i++)
    	{
	 		if(o[i] instanceof Component)
 	 			((Component)o[i]).setVisible(false);
	 		if(o[i] instanceof Window)
 	 			((Window)o[i]).dispose();
    		o[i]=null;
		}
      	try
        {
	   		commandsock.close();
	    } catch (IOException e2) {;}
	    try
	    {
	      	actionsock.close();
	    } catch (IOException e2) {;}
	}

	//                          										L I S T E N E R S
    void new_Listener(int command, int obj) throws IOException
    {
    	int kind;

        switch(command)
		{
        case(JAPI_Calls.JAPI_KEYLISTENER):
            if(debug>0) debugwindow.println("Keylistener (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
            if(o[obj] instanceof Component)
            {
                o[objectcounter] = new JAPI_Keylistener(objectcounter,out,action);
                ((Component)o[obj]).addKeyListener((JAPI_Keylistener)o[objectcounter]);
                objectcounter++;
            }
            else
            {
                  nextaction=errordialog.getResult("No Component ID in j_keylistener( ID )\nID = "+o[obj].toString());
                   out.sendInt(-1);
            }
            break;

        case(JAPI_Calls.JAPI_FOCUSLISTENER):
            if(debug>0) debugwindow.println("Focus Listener (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
            if(o[obj] instanceof Component)
            {
                o[objectcounter] = new JAPI_Focuslistener(objectcounter,out,action);
                   ((Component)o[obj]).addFocusListener((JAPI_Focuslistener)o[objectcounter]);
                objectcounter++;
            }
            else
            {
                nextaction=errordialog.getResult("No Component ID in j_focuslistener( ID )\nID = "+o[obj].toString());
                out.sendInt(-1);
            }
            break;


        case(JAPI_Calls.JAPI_MOUSELISTENER):
            kind = in.recvInt();

            if(debug>0) debugwindow.println("Mouse Listener Type: "+kind+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
            if(o[obj] instanceof Component)
            {
                if((kind>=JAPI_Const.J_PRESSED) && (kind<=JAPI_Const.J_DOUBLECLICK))
                {
                    o[objectcounter] = new JAPI_Mouselistener(objectcounter,action,kind);
                    ((Component)o[obj]).addMouseListener((JAPI_Mouselistener)o[objectcounter]);
                    out.sendInt(objectcounter);
                }
                else if((kind>=JAPI_Const.J_MOVED) && (kind<=JAPI_Const.J_DRAGGED))
                {
                    o[objectcounter] = new JAPI_Mousemotionlistener(objectcounter,action,kind);
                    ((Component)o[obj]).addMouseMotionListener((JAPI_Mousemotionlistener)o[objectcounter]);
                    out.sendInt(objectcounter);
                }
                else
                {
                    nextaction=errordialog.getResult("No valid Mouse Event in j_componentlistener\nID = "+o[obj].toString());
                    out.sendInt(-1);
                }
                objectcounter++;
            }
            else
            {
                nextaction=errordialog.getResult("No Component ID in j_mousepressed( ID )\nID = "+o[obj].toString());
                out.sendInt(-1);
            }
            break;

        case(JAPI_Calls.JAPI_COMPONENTLISTENER):
            kind = in.recvInt();

            if(debug>0) debugwindow.println("Component Listener Type: "+kind+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
            if(o[obj] instanceof Component)
            {
                if((kind>=JAPI_Const.J_MOVED) && (kind<=JAPI_Const.J_SHOWN))
                {
                    o[objectcounter] = new JAPI_Componentlistener(objectcounter,action,kind);
                    ((Component)o[obj]).addComponentListener((JAPI_Componentlistener)o[objectcounter]);
                    out.sendInt(objectcounter);
                }
                else
                {
                     nextaction=errordialog.getResult("No valid Component Event in j_componentlistener\nID = "+o[obj].toString());
                     out.sendInt(-1);
                }
                objectcounter++;
            }
            else
            {
                nextaction=errordialog.getResult("No Component ID in j_componentlistener( ID )\nID = "+o[obj].toString());
                out.sendInt(-1);
            }
            break;

        case(JAPI_Calls.JAPI_WINDOWLISTENER):
            kind = in.recvInt();

            if(debug>0) debugwindow.println("Window Listener Type: "+kind+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
            if(o[obj] instanceof Window)
            {
                if((kind>=JAPI_Const.J_ACTIVATED) && (kind<=JAPI_Const.J_CLOSING))
                {
                    o[objectcounter] = new JAPI_Windowlistener(objectcounter,action,kind);
                    ((Window)o[obj]).addWindowListener((JAPI_Windowlistener)o[objectcounter]);
                    out.sendInt(objectcounter);
                }
                else
                {
                    nextaction=errordialog.getResult("No valid Window Event in j_windowlistener\nID = "+o[obj].toString());
                    out.sendInt(-1);
                }
                objectcounter++;
            }
            else
            {
                nextaction=errordialog.getResult("No Window ID in j_windowlistener( ID )\nID = "+o[obj].toString());
                out.sendInt(-1);
            }
            break;
		}
    }

    //			             C O N S T R U C T O R S

    void new_Component(int command, int obj) throws MalformedURLException, IOException
    {
    	String title;

        switch(command)
        {

           /* Frame */
           case(JAPI_Calls.JAPI_FRAME):
               title = in.readToLineEnd();
               if(debug>0) debugwindow.println("FRAME "+title+" (ID = "+objectcounter+")");

               o[objectcounter] = new JAPI_Frame(title);
               ((Frame)o[objectcounter]).addWindowListener(new JAPI_Windowlistener(objectcounter,action,JAPI_Const.J_CLOSING));
               ((Frame)o[objectcounter]).setSize(400,300);
			   // LE: set Frame to appear centred          
			   ((Frame)o[objectcounter]).setLocationRelativeTo(null);
        	   // LE: set default system look and feel
        	   try {
        	   	UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        	   } catch (Exception e) {}	
			   SwingUtilities.updateComponentTreeUI( ((Frame)o[objectcounter]) );
			   
               out.sendInt(objectcounter);
               objectcounter++;
               break;


           /* Panel */
           case(JAPI_Calls.JAPI_PANEL):
               int type   = in.recvInt();
               if(debug>0) debugwindow.println("PANEL type "+type+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

               if(o[obj] instanceof Container)
               {
                   o[objectcounter] = new JAPI_Panel(type);
                   o[objectcounter+1] = new JAPI_Componentlistener(objectcounter,action,JAPI_Const.J_RESIZED);
                   ((Container)o[obj]).add((Component)o[objectcounter]);
                   ((Container)o[objectcounter]).addComponentListener((JAPI_Componentlistener)o[objectcounter+1]);
                   out.sendInt(objectcounter);
                   objectcounter+=2;
               }
               else
               {
                   nextaction=errordialog.getResult("No Container ID in j_panel( ID )\nID = "+o[obj].toString());
                   out.sendInt(-1);
               }
               break;

                  /* Dialog */
           case(JAPI_Calls.JAPI_DIALOG):
                     title = in.readToLineEnd();
                      if(debug>0) debugwindow.println("DIALOG"+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                      if(o[obj] instanceof Frame)
                     {
                         o[objectcounter] = new JAPI_Dialog((Frame)o[obj],title);
                         o[objectcounter+1] = new JAPI_Windowlistener(objectcounter,action,JAPI_Const.J_CLOSING);
                         ((Dialog)o[objectcounter]).addWindowListener((JAPI_Windowlistener)o[objectcounter+1]);
                         out.sendInt(objectcounter);
                            objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Frame ID in j_dialog( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
               break;

                 /* Window */
           case(JAPI_Calls.JAPI_WINDOW):
                {
                      if(debug>0) debugwindow.println("WINDOW"+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                      if(o[obj] instanceof Frame)
                     {
                         o[objectcounter] = new JAPI_Window((Frame)o[obj]);
                         out.sendInt(objectcounter);
                            objectcounter++;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Frame ID in j_window( ID )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
                }
              break;


                  /* Scrollpane */
           case(JAPI_Calls.JAPI_SCROLLPANE):
                {
                      if(debug>0) debugwindow.println("SCROLLPANE"+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                      if(o[obj] instanceof Container)
                     {
                         o[objectcounter] = new ScrollPane(ScrollPane.SCROLLBARS_AS_NEEDED);
                         o[objectcounter+1] = new JAPI_Componentlistener(objectcounter,action,JAPI_Const.J_RESIZED);
                         ((Container)o[obj]).add((Component)o[objectcounter]);
                          ((Component)o[objectcounter]).addComponentListener((JAPI_Componentlistener)o[objectcounter+1]);
                        out.sendInt(objectcounter);
                            objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_scrollpane( ID )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
                }
              break;


                   /* Horizontal Scroll */
           case(JAPI_Calls.JAPI_HSCROLL):
                {
                       if(debug>0) debugwindow.println("H-SCROLLBAR"+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                      if(o[obj] instanceof Container)
                     {
                        if(o[obj] instanceof ScrollPane)
                            o[objectcounter] = ((ScrollPane)o[obj]).getHAdjustable();
                         else
                         {
                             o[objectcounter] = new Scrollbar(Scrollbar.HORIZONTAL);
                             ((Container)o[obj]).add((Component)o[objectcounter]);
                          }
                          o[objectcounter+1] = new JAPI_Adjustmentlistener(objectcounter,action);
                         ((Adjustable)o[objectcounter]).addAdjustmentListener((JAPI_Adjustmentlistener)o[objectcounter+1]);
                        out.sendInt(objectcounter);
                            objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_hscrollbar( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
                }
              break;

                /* Vertical Scroll */
           case(JAPI_Calls.JAPI_VSCROLL):
                {
                       if(debug>0) debugwindow.println("V-SCROLLBAR"+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                      if(o[obj] instanceof Container)
                     {
                        if(o[obj] instanceof ScrollPane)
                            o[objectcounter] = ((ScrollPane)o[obj]).getVAdjustable();
                         else
                         {
                             o[objectcounter] = new Scrollbar(Scrollbar.VERTICAL);
                             ((Container)o[obj]).add((Component)o[objectcounter]);
                          }
                          o[objectcounter+1] = new JAPI_Adjustmentlistener(objectcounter,action);
                         ((Adjustable)o[objectcounter]).addAdjustmentListener((JAPI_Adjustmentlistener)o[objectcounter+1]);
                        out.sendInt(objectcounter);
                            objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_vscrollbar( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
                }
              break;

                 /* Canvas */
           case(JAPI_Calls.JAPI_CANVAS):
                {
                      int width  = in.recvInt();
                      int height = in.recvInt();

                      if(debug>0) debugwindow.println("CANVAS ["+width+":"+height+"] (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                      if(o[obj] instanceof Container)
                     {
                        o[objectcounter] = new JAPI_Canvas(width,height);
                        o[objectcounter+1] = new JAPI_Componentlistener(objectcounter,action,JAPI_Const.J_RESIZED);
                         ((Container)o[obj]).add((Component)o[objectcounter]);
                          ((Component)o[objectcounter]).addComponentListener((JAPI_Componentlistener)o[objectcounter+1]);
                        out.sendInt(objectcounter);
                            objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_canvas( ID , ... )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                    }
                }
              break;

                  /* Label */
           case(JAPI_Calls.JAPI_LABEL):
                {
                      title = in.readToLineEnd();
                       if(debug>0) debugwindow.println("LABEL "+title+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                      if(o[obj] instanceof Container)
                     {
                         o[objectcounter] = new JAPI_Label(title);
                          ((Container)o[obj]).add((Component)o[objectcounter]);
                        out.sendInt(objectcounter);
                            objectcounter++;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_label( ID , ... )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                    }
                }
              break;

                  /* Graphic Label */
           case(JAPI_Calls.JAPI_GRAPHICLABEL):
                {
                    String icon = in.readToLineEnd();

                       if(debug>0) debugwindow.println("GRAPHIC LABEL Icon:"+icon+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                      if(o[obj] instanceof Container)
                     {
                         o[objectcounter] = new JAPI_Graphiclabel(icon,clienthost,httpport);
                          ((Container)o[obj]).add((Component)o[objectcounter]);
                        out.sendInt(objectcounter);
                            objectcounter++;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_graphiclabel( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
                }
              break;

                  /* Button */
           case(JAPI_Calls.JAPI_BUTTON):
                {
                    title = in.readToLineEnd();
                       if(debug>0) debugwindow.println("Button "+title+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                    if(o[obj] instanceof Container)
                     {
                         o[objectcounter] = new JAPI_Button(title);
                         o[objectcounter+1] = new JAPI_Actionlistener(objectcounter,action);
                         ((Container)o[obj]).add((Component)o[objectcounter]);
 						 ((JAPI_Button)o[objectcounter]).addActionListener((JAPI_Actionlistener)o[objectcounter+1]);
                          out.sendInt(objectcounter);
                             objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_button( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
                }
              break;

                  /* Graphic Button */
        case(JAPI_Calls.JAPI_GRAPHICBUTTON):
                {
                    String icon = in.readToLineEnd();
                       if(debug>0) debugwindow.println("Graphic Button Icon = "+icon+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                    if(o[obj] instanceof Container)
                     {
                         o[objectcounter] = new JAPI_Graphicbutton(icon,clienthost,httpport,objectcounter,action);
                         ((Container)o[obj]).add((Component)o[objectcounter]);
                        out.sendInt(objectcounter);
                             objectcounter++;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_graphicbutton( ID , ... )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                    }
                }
              break;

                /* Checkbox */
           case(JAPI_Calls.JAPI_CHECKBOX):
                {
                    title = in.readToLineEnd();
                       if(debug>0) debugwindow.println("Checkbox "+title+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                    if(o[obj] instanceof Container)
                     {
                         o[objectcounter] = new JAPI_Checkbox(title);
                          o[objectcounter+1] = new JAPI_Itemlistener(objectcounter,action);
                          ((Container)o[obj]).add((Component)o[objectcounter]);
                        ((JAPI_Checkbox)o[objectcounter]).addItemListener((JAPI_Itemlistener)o[objectcounter+1]);
                         out.sendInt(objectcounter);
                             objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_checkbox( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                     }
                 }
              break;

                  /* Radio Button Group */
           case(JAPI_Calls.JAPI_RADIOGROUP):
                {
                      if(debug>0) debugwindow.println("Radiogroup"+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                      if(o[obj] instanceof Container)
                     {
                         o[objectcounter] = new JAPI_Radiogroup();
                         ((JAPI_Radiogroup)o[objectcounter]).setparent((Container)o[obj]);
                         out.sendInt(objectcounter);
                            objectcounter++;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_radiogroup( ID )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
                }
              break;


           case(JAPI_Calls.JAPI_RADIOBUTTON):
                {
                    title = in.readToLineEnd();
                       if(debug>0) debugwindow.println("Radiobutton "+title+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                    if(o[obj] instanceof JAPI_Radiogroup)
                     {
                         o[objectcounter] = new JAPI_Radiobutton(title,(CheckboxGroup)o[obj]);
                           o[objectcounter+1] = new JAPI_Itemlistener(objectcounter,action);
                         ((Container)((JAPI_Radiogroup)o[obj]).getParent()).add((Component)o[objectcounter]);
                        ((JAPI_Radiobutton)o[objectcounter]).addItemListener((JAPI_Itemlistener)o[objectcounter+1]);
                         out.sendInt(objectcounter);
                             objectcounter+=2;
                    }
                      else
                      {
                            nextaction=errordialog.getResult("No Radiogroup ID in j_radiobutton( ID , ... )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                    }
                }
              break;

           case(JAPI_Calls.JAPI_LIST):
                {
                      int rows   = in.recvInt();
                       if(debug>0) debugwindow.println("Listbox "+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                    if(o[obj] instanceof Container)
                     {
                         o[objectcounter] = new JAPI_List(rows,objectcounter,action);
                        o[objectcounter+1] = new JAPI_Actionlistener(objectcounter,action);
                         ((Container)o[obj]).add((Component)o[objectcounter]);
                        ((JAPI_List)o[objectcounter]).addActionListener((JAPI_Actionlistener)o[objectcounter+1]);
                         out.sendInt(objectcounter);
                             objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_list( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
                }
              break;

           case(JAPI_Calls.JAPI_CHOICE):
                {
                       if(debug>0) debugwindow.println("Choice "+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                    if(o[obj] instanceof Container)
                     {
                         o[objectcounter] = new JAPI_Choice();
                         o[objectcounter+1] = new JAPI_Itemlistener(objectcounter,action);
                          ((Container)o[obj]).add((Component)o[objectcounter]);
                        ((JAPI_Choice)o[objectcounter]).addItemListener((JAPI_Itemlistener)o[objectcounter+1]);
                        out.sendInt(objectcounter);
                            objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_choice( ID )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                    }
                }
              break;

           case(JAPI_Calls.JAPI_TEXTAREA):
                {
                      int row    = in.recvInt();
                      int col       = in.recvInt();
                       if(debug>0) debugwindow.println("TEXTAREA "+row+"x"+col+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                    if(o[obj] instanceof Container)
                     {
                        o[objectcounter] = new JAPI_Textarea(row,col);
                        o[objectcounter+1] = new JAPI_Textlistener(objectcounter,action);
                          ((Container)o[obj]).add((Component)o[objectcounter]);
                        ((TextArea)o[objectcounter]).addTextListener((JAPI_Textlistener)o[objectcounter+1]);
                         out.sendInt(objectcounter);
                            objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_textarea( ID , ...)\nID = "+o[obj].toString());
                           out.sendInt(-1);
                    }
                }
              break;

           case(JAPI_Calls.JAPI_TEXTFIELD):
                {
                      int col       = in.recvInt();
                       if(debug>0) debugwindow.println("TEXTFIELD : "+col+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                    if(o[obj] instanceof Container)
                     {
                        o[objectcounter] = new JAPI_Textfield(col);
                         o[objectcounter+1] = new JAPI_Actionlistener(objectcounter,action);
                          ((Container)o[obj]).add((Component)o[objectcounter]);
                        ((TextField)o[objectcounter]).addActionListener((JAPI_Actionlistener)o[objectcounter+1]);
                        out.sendInt(objectcounter);
                             objectcounter+=2;
                     }
                      else
                      {
                            nextaction=errordialog.getResult("No Container ID in j_textfield( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }
                }
              break;

           case(JAPI_Calls.JAPI_MENUBAR):
                  {
                     if(debug>0) debugwindow.println("MENUBAR"+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());

                     if(o[obj] instanceof Frame)
                       {
                           o[objectcounter] = new JAPI_Menubar();
                           ((Frame)o[obj]).setMenuBar((JAPI_Menubar)o[objectcounter]);
                        out.sendInt(objectcounter);
                            objectcounter++;
                      }
                      else
                      {
                            nextaction=errordialog.getResult("No Frame ID in j_menubar( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                      }
                }
              break;


           case(JAPI_Calls.JAPI_MENU):
                  {
                      title = in.readToLineEnd();

                    if(debug>0) debugwindow.println("MENU "+title+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof MenuBar)
                       {
                           o[objectcounter] = new JAPI_Menu(title);
                           ((MenuBar)o[obj]).add((JAPI_Menu)o[objectcounter]);
                         out.sendInt(objectcounter);
                             objectcounter++;
                      }
                      else if(o[obj] instanceof Menu)
                       {
                           o[objectcounter] = new JAPI_Menu(title);
                           ((Menu)o[obj]).add((JAPI_Menu)o[objectcounter]);
                          out.sendInt(objectcounter);
                            objectcounter++;
                      }
                      else
                      {
                            nextaction=errordialog.getResult("No Menu or Menubar ID in j_menu( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                      }
                }
              break;

           case(JAPI_Calls.JAPI_HELPMENU):
                  {
                      title = in.readToLineEnd();

                    if(debug>0) debugwindow.println("HELPMENU "+title+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof MenuBar)
                       {
                           o[objectcounter] = new JAPI_Menu(title);
                           ((MenuBar)o[obj]).add((JAPI_Menu)o[objectcounter]);
                           ((MenuBar)o[obj]).setHelpMenu((JAPI_Menu)o[objectcounter]);
                          out.sendInt(objectcounter);
                             objectcounter++;
                      }
                      else
                      {
                           nextaction=errordialog.getResult("No Menubar ID in j_helpmenu( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                      }
                }
              break;

           case(JAPI_Calls.JAPI_POPMENU):
                {
                      title = in.readToLineEnd();

                     if(debug>0) debugwindow.println("POPUP MENU "+title+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
                     if(o[obj] instanceof Component)
                       {
                         o[objectcounter] = new PopupMenu(title);
                           ((Component)o[obj]).add((PopupMenu)o[objectcounter]);
                         out.sendInt(objectcounter);
                          objectcounter++;
                      }
                      else
                      {
                           nextaction=errordialog.getResult("No Component ID in j_helpmenu( ID , ... )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                      }
                }
              break;

           case(JAPI_Calls.JAPI_MENUITEM):
                  {
                      title = in.readToLineEnd();

                    if(debug>0) debugwindow.println("MENUITEM "+title+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof Menu)
                       {
                           o[objectcounter] = new MenuItem(title);
                          o[objectcounter+1] = new JAPI_Actionlistener(objectcounter,action);
                          ((Menu)o[obj]).add((MenuItem)o[objectcounter]);
                        ((MenuItem)o[objectcounter]).addActionListener((JAPI_Actionlistener)o[objectcounter+1]);
                          out.sendInt(objectcounter);
                             objectcounter+=2;
                      }
                      else
                      {
                           nextaction=errordialog.getResult("No Menu ID in j_menuitem( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                      }
                }
              break;

           case(JAPI_Calls.JAPI_CHECKMENUITEM):
                  {
                      title = in.readToLineEnd();

                    if(debug>0) debugwindow.println("CHECKBOX-MENUITEM "+title+" (ID = "+objectcounter+")  in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof Menu)
                       {
                           o[objectcounter] = new CheckboxMenuItem(title);
                          o[objectcounter+1] = new JAPI_Itemlistener(objectcounter,action);
                          ((Menu)o[obj]).add((MenuItem)o[objectcounter]);
                        ((CheckboxMenuItem)o[objectcounter]).addItemListener((JAPI_Itemlistener)o[objectcounter+1]);
                          out.sendInt(objectcounter);
                             objectcounter+=2;
                     }
                      else
                      {
                           nextaction=errordialog.getResult("No Menu ID in j_checkmenuitem( ID , ... )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                      }

                }
              break;

        case(JAPI_Calls.JAPI_SEPERATOR):
                  {
                     if(debug>0) debugwindow.println("Seperator in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof Menu)
                           ((Menu)o[obj]).addSeparator();
                       else
                           nextaction=errordialog.getResult("No Menu ID in j_seperator( ID )\nID = "+o[obj].toString());


                 }
              break;


        case(JAPI_Calls.JAPI_FILEDIALOG):
                {
                       String Appath = in.readToLineEnd();
                     title = in.readToLineEnd();
                    String dir = in.readToLineEnd();

                      if(debug>0) debugwindow.println("FILEDIALOG in Parent Object "+o[obj].toString()+" Directory : "+dir);
                      if(o[obj] instanceof Container)
                     {
						FileDialog f;
                        File setdir = new File(dir);
                        if(!setdir.isAbsolute())
                             dir = Appath + File.separator + dir;
						if(title.indexOf("/S")<0)
                         	f = new FileDialog(debugwindow,title,FileDialog.LOAD);
                        else
                        {
							int index=title.indexOf("/S");
							title=title.substring(0,index)+
							      title.substring(index+2,title.length());
					     	f = new FileDialog(debugwindow,title,FileDialog.SAVE);
                       	}
                         f.setDirectory(dir);
                          f.setVisible(true);
                         if(f.getFile()==null)
                              out.sendInt(0);
                           else
                        {
                            String filename = f.getDirectory()+f.getFile();
                             if(debug>0) debugwindow.println("File : "+filename);
                             out.sendInt(filename.length());
                             byte[] buf = filename.getBytes();
                              out.write(buf);
                          }
                      }
                      else
                      {
                           nextaction=errordialog.getResult("No Container ID in j_filedialog( ID , ... )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                    }
                }
              break;

           case(JAPI_Calls.JAPI_RULER):
                  {
                        int orient = in.recvInt();
                       int style  = in.recvInt();
                       int len    = in.recvInt();
                    if(debug>0) debugwindow.println("Ruler in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof Container)
                    {
                         o[objectcounter]  = new JAPI_Ruler(orient,style,len);
                         ((Container)o[obj]).add((Component)o[objectcounter]);
                           out.sendInt(objectcounter);
                             objectcounter++;
                      }
                       else
                       {
                           nextaction=errordialog.getResult("No Container ID in j_ruler( ID )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                     }
                 }
              break;

           case(JAPI_Calls.JAPI_MESSAGEBOX):
                {
                       int len = in.recvInt();
                     title = in.readToLineEnd();

                      if(debug>0) debugwindow.println("Messagebox  in Parent Object "+o[obj].toString());

                       if(o[obj] instanceof Frame)
                     {
                          byte[] buf = new byte[len];
                           if(len>0) in.read(buf,0,len);
                         String text = new String(buf);

                         o[objectcounter]  = new JAPI_Alert((Frame)o[obj],title,text,objectcounter);
                         o[objectcounter+1] = new JAPI_Windowlistener(objectcounter,action,JAPI_Const.J_CLOSING);
                         ((JAPI_Alert)o[objectcounter]).addWindowListener((JAPI_Windowlistener)o[objectcounter+1]);
                          out.sendInt(objectcounter);
                          objectcounter+=2;
                    }
                      else
                      {
                           nextaction=errordialog.getResult("No Frame ID in j_alert0( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                       }
                   }
              break;


           case(JAPI_Calls.JAPI_ALERTBOX):
                {
                       int len = in.recvInt();
                     title = in.readToLineEnd();
                     String but1 = in.readToLineEnd();
                    byte[] buf = new byte[len];
                    if(len>0) in.read(buf,0,len);
                        String text = new String(buf);

                      if(debug>0) debugwindow.println("Alertbox in Parent Object "+o[obj].toString()+" ("+but1+")");

                       if(o[obj] instanceof Frame)
                     {
                           JAPI_Alert alert = new JAPI_Alert((Frame)o[obj],title,text,but1);
                           out.sendInt(alert.getChoice());
                    }
                      else
                      {
                           nextaction=errordialog.getResult("No Frame ID in j_alert1( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }

                   }
              break;


        case(JAPI_Calls.JAPI_CHOICEBOX2):
                {
                        int len = in.recvInt();
                     title = in.readToLineEnd();
                     String but1 = in.readToLineEnd();
                     String but2 = in.readToLineEnd();
                    byte[] buf = new byte[len];
                    if(len>0) in.read(buf,0,len);
                        String text = new String(buf);

                      if(debug>0) debugwindow.println("Choicebox2  in Parent Object "+o[obj].toString()+" ("+but1+" , "+but2+")");

                       if(o[obj] instanceof Frame)
                     {
                           JAPI_Alert alert = new JAPI_Alert((Frame)o[obj],title,text,but1,but2);
                           out.sendInt(alert.getChoice());
                    }
                      else
                      {
                           nextaction=errordialog.getResult("No Frame ID in j_alert2( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }

                   }
              break;


           case(JAPI_Calls.JAPI_CHOICEBOX3):
                {
                       int len = in.recvInt();
                     title = in.readToLineEnd();
                     String but1 = in.readToLineEnd();
                     String but2 = in.readToLineEnd();
                     String but3 = in.readToLineEnd();
                    byte[] buf = new byte[len];
                    if(len>0) in.read(buf,0,len);
                        String text = new String(buf);

                      if(debug>0) debugwindow.println("Choicebox3 in Parent Object "+o[obj].toString()+" ("+but1+" , "+but2+" , "+but3+")");

                       if(o[obj] instanceof Frame)
                     {
                           JAPI_Alert alert = new JAPI_Alert((Frame)o[obj],title,text,but1,but2,but3);
                           out.sendInt(alert.getChoice());
                    }
                      else
                      {
                           nextaction=errordialog.getResult("No Frame ID in j_alert3( ID , ... )\nID = "+o[obj].toString());
                            out.sendInt(-1);
                    }

                   }
              break;

           case(JAPI_Calls.JAPI_PRINTER):
                {
                     if(debug>0) debugwindow.println("PRINTER "+o[obj].toString());

                      if((o[objectcounter] =  Toolkit.getDefaultToolkit().getPrintJob((Frame)o[obj],"", null))!=null)
//                      if((o[objectcounter] =  Toolkit.getDefaultToolkit().getPrintJob(new Frame(),"", null))!=null)
                      {
                          o[objectcounter+1] = ((PrintJob)o[objectcounter]).getGraphics();
                          ((Graphics)o[objectcounter+1]).setFont(new Font("Dialog",Font.PLAIN,12));
                         out.sendInt(objectcounter);
                        objectcounter+=2;
                    }
                     else
                             out.sendInt(-1);
                   }
              break;

           case(JAPI_Calls.JAPI_IMAGE):
                {
                      int width  = in.recvInt();
                      int height = in.recvInt();

                     if(debug>0) debugwindow.println("new IMAGE  "+width+":"+height);

//                      o[objectcounter] = ((Component)o[obj]).createImage(width,height);
                      o[objectcounter] = ((Component)debugwindow).createImage(width,height);
                      o[objectcounter+1]  = ((Image)o[objectcounter]).getGraphics();
                      ((Graphics)o[objectcounter+1]).setFont(new Font("Dialog",Font.PLAIN,12));
                      ((Graphics)o[objectcounter+1]).setColor(Color.white);
                      ((Graphics)o[objectcounter+1]).fillRect(0,0,width,height);
                      ((Graphics)o[objectcounter+1]).setColor(Color.black);
                     out.sendInt(objectcounter);
                       objectcounter+=2;
                 }
              break;

           case(JAPI_Calls.JAPI_PROGRESSBAR):
                  {
                       int style  = in.recvInt();
                    if(debug>0) debugwindow.println("Progressbar in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof Container)
                    {
                         o[objectcounter]  = new JAPI_Progressbar(style);
                         ((Container)o[obj]).add((Component)o[objectcounter]);
                           out.sendInt(objectcounter);
                             objectcounter++;
                      }
                       else
                       {
                           nextaction=errordialog.getResult("No Container ID in j_progressbar( ID )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                     }
                 }
              break;

           case(JAPI_Calls.JAPI_LED):
                  {
                       int form   = in.recvInt();
                     int red = in.readUnsignedByte();
                     int gre = in.readUnsignedByte();
                     int blu = in.readUnsignedByte();
                    if(debug>0) debugwindow.println("LED in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof Container)
                    {
                         o[objectcounter]  = new JAPI_Led(form,new Color(red,gre,blu));
                         ((Container)o[obj]).add((Component)o[objectcounter]);
                           out.sendInt(objectcounter);
                             objectcounter++;
                      }
                       else
                       {
                           nextaction=errordialog.getResult("No Container ID in j_led( ID )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                     }
                 }
              break;

           case(JAPI_Calls.JAPI_SEVENSEGMENT):
                  {
                     int red = in.readUnsignedByte();
                     int gre = in.readUnsignedByte();
                     int blu = in.readUnsignedByte();
                    if(debug>0) debugwindow.println("SevenSegment in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof Container)
                    {
                         o[objectcounter]  = new JAPI_Sevensegment(new Color(red,gre,blu));
                         ((Container)o[obj]).add((Component)o[objectcounter]);
                           out.sendInt(objectcounter);
                             objectcounter++;
                      }
                       else
                       {
                           nextaction=errordialog.getResult("No Container ID in j_sevensegment( ID )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                     }
                 }
              break;

           case(JAPI_Calls.JAPI_METER):
                  {
                    title = in.readToLineEnd();
                    if(debug>0) debugwindow.println("Progressbar in Parent Object "+o[obj].toString());
                    if(o[obj] instanceof Container)
                    {
                         o[objectcounter]  = new JAPI_Meter(title);
                         ((Container)o[obj]).add((Component)o[objectcounter]);
                           out.sendInt(objectcounter);
                             objectcounter++;
                      }
                       else
                       {
                           nextaction=errordialog.getResult("No Container ID in j_meter( ID )\nID = "+o[obj].toString());
                           out.sendInt(-1);
                     }
                 }
              break;
        }
    }




    //			                            L A Y O U T M A N A G E R

    void new_Layoutmanager(int command, int obj) throws IOException
    {
    	switch(command)
    	{
                   case(JAPI_Calls.JAPI_FLOWLAYOUT):
                      int orient = in.recvInt();

                     if(debug>0) debugwindow.println("FLOW Layoutmanager for Object "+o[obj].toString());
                    if(o[obj] instanceof Container)
                    {
                        if(orient == JAPI_Const.J_HORIZONTAL)
                        {
                               o[objectcounter] = new JAPI_HFlowlayout();
                              ((Container)o[obj]).setLayout((LayoutManager)o[objectcounter]);
                        }
                           else
                        {
                               o[objectcounter] = new JAPI_VFlowlayout();
                               ((Container)o[obj]).setLayout((LayoutManager)o[objectcounter]);
                        }
                        objectcounter++;
                    }
                       else
                            nextaction=errordialog.getResult("No Container ID in j_flowlayout( ID , ... )\nID = "+o[obj].toString());
 				break;

                case(JAPI_Calls.JAPI_BORDERLAYOUT):
                     if(debug>0) debugwindow.println("BORDER Layoutmanager for Object "+o[obj].toString());
                    if(o[obj] instanceof Container)
                    {
                           o[objectcounter] = new BorderLayout();
                        ((Container)o[obj]).setLayout((LayoutManager)o[objectcounter]);
                        objectcounter++;
                    }
                       else
                            nextaction=errordialog.getResult("No Container ID in j_borderlayout( ID )\nID = "+o[obj].toString());
				break;


                   case(JAPI_Calls.JAPI_GRIDLAYOUT):
                      int row    = in.recvInt();
                      int col    = in.recvInt();

                     if(debug>0) debugwindow.println("Grid Layoutmanager for Object "+o[obj].toString()+" : "+row+"x"+col);
                    if(o[obj] instanceof Container)
                    {
                           o[objectcounter] = new GridLayout(row,col);
                        ((Container)o[obj]).setLayout((LayoutManager)o[objectcounter]);
                        objectcounter++;
                    }
                      else
                            nextaction=errordialog.getResult("No Container ID in j_gridlayout( ID , ... )\nID = "+o[obj].toString());
				break;

                   case(JAPI_Calls.JAPI_NOLAYOUT):
                    if(debug>0) debugwindow.println("No Layoutmanager for Object "+o[obj].toString());
                    if(o[obj] instanceof Container)
                           ((Container)o[obj]).setLayout(null);
                      else
                            nextaction=errordialog.getResult("No Container ID in j_nolayout( ID )\nID = "+o[obj].toString());
				break;
		}
	}
}
