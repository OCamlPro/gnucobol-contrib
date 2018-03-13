/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Canvas.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Canvas.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Canvas.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Canvas.java
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

// todo:
// Methoden fuer translate + cliprect
// evtl noch mehr

public class JAPI_Canvas extends Canvas
{
	Image screenbuf=null;
	Graphics gc,sgc;
	int w=0,h=0;
	int dx=0,dy=0;
	int cx=0,cy=0,cw=0,ch=0;
//	Font f=Font.DEFAULT;  java2.0
	Font f=new Font("Dialog",Font.PLAIN,12);
	Color c = Color.black;
	boolean xor = false;
	Color xorcolor;
	boolean validBuf=false;

	public JAPI_Canvas (int dw, int dh)
	{
		super();
		w = dw>0 ? dw : 0;
		h = dh>0 ? dh : 0;
		super.setSize(w,h);
		super.setBackground(Color.white);
	}


	public void setSize(int dw, int dh)
	{
		if((dw!=w)||(dh!=h)) validBuf=false;
		w = dw>0 ? dw : 0;
		h = dh>0 ? dh : 0;
		super.setSize(w,h);
	}

	public void setFont(Font f)
	{
		this.f = f;
		if(sgc != null)
			sgc.setFont(f);
		if(gc != null)
			gc.setFont(f);
	}

	public void setForeground(Color c)
	{
		this.c = c;
		if(sgc != null)	sgc.setColor(c);
		if( gc != null)  gc.setColor(c);
	}

	public void setBackground(Color b)
	{
		Dimension d = super.getSize();
		if(sgc != null)
		{
			if((this.cw>0) && (this.ch>0))
 				sgc.clipRect(0,0,d.width,d.height);
			sgc.setColor(b);
			sgc.fillRect(0,0,d.width,d.height);
			sgc.setColor(c);
			if((this.cw>0) && (this.ch>0))
 				sgc.clipRect(this.cx,this.cy,this.cw,this.ch);
		}
		if( gc != null)
		{
			if((this.cw>0) && (this.ch>0))
 				gc.clipRect(0,0,d.width,d.height);
			gc.setColor(b);
			gc.fillRect(0,0,d.width,d.height);
			gc.setColor(c);
			if((this.cw>0) && (this.ch>0))
 				gc.clipRect(this.cx,this.cy,this.cw,this.ch);
		}
	}

	public void setXORMode(Color c)
	{
		this.xor = true;
		this.xorcolor = c;
		sgc.setXORMode(xorcolor);
		gc.setXORMode(xorcolor);
	}

	public void setPaintMode()
	{
		this.xor = false;
		sgc.setPaintMode();
		gc.setPaintMode();
	}

	public void translate(int lx,int ly)
	{
		this.dx += lx;
		this.dy += ly;
		sgc.translate(lx,ly);
		gc.translate(lx,ly);
	}

	public void clipRect(int x,int y, int w, int h)
	{
		this.cx = x;
		this.cy = y;
		this.cw = w;
		this.ch = h;
		sgc.clipRect(x,y,w,h);
		gc.clipRect(x,y,w,h);
	}

	public void addNotify()
	{
		super.addNotify();
		newScreenBuffer();
		gc  = super.getGraphics();
	}

	public void newScreenBuffer()
	{
		if(isVisible())
		{
			Dimension d = super.getSize();
			if(d.width>0 && d.height>0)
			{
				Image newimage = createImage(d.width,d.height);

				/* alten Inhalt sichern */
// is this usefull ?????? YES
				if(screenbuf!=null)
					newimage.getGraphics().drawImage(screenbuf,0,0,this);
				screenbuf = newimage;
				sgc = screenbuf.getGraphics();
				sgc.setFont(this.f);
				sgc.setColor(this.c);
				if((this.cw>0) && (this.ch>0))
 					sgc.clipRect(this.cx,this.cy,this.cw,this.ch);
				sgc.translate(this.dx,this.dy);
				if(xor)
					sgc.setXORMode(xorcolor);
				else
					sgc.setPaintMode();
				paint(gc);
			}
		}
		validBuf=true;
	}

	public Graphics getoffscreenGraphics()
	{
		return(sgc);
	}

	public Graphics getGraphics()
	{
		return(gc);
	}


    /**
      * Overriddent to prevent flickering
     **/
   	public void update(Graphics g)
	{
		paint(g);
	}


	public void paint(Graphics g)
	{
		if(screenbuf != null)
		{
			if(gc!=null)
				gc.dispose();
			gc  = super.getGraphics();
			gc.drawImage(screenbuf,0,0,this);
			gc.setFont(this.f);
			gc.setColor(this.c);
			if((this.cw>0) && (this.ch>0))
				gc.clipRect(this.cx,this.cy,this.cw,this.ch);
			gc.translate(this.dx,this.dy);
			if(xor)
				gc.setXORMode(xorcolor);
			else
				gc.setPaintMode();
		}
		if(g instanceof PrintGraphics)
			g.drawImage(screenbuf,0,0,this);
	}

	public Font getFont()
	{
		return(f);
	}

	public Image getImageCopy()
	{
		return(screenbuf);
	}

	public Image getScaledImageCopy(int sx, int sy, int sw,int sh, int dw, int dh)
	{
		Image img = createImage(dw,dh);
		img.getGraphics().drawImage(screenbuf,0,0,dw,dh,sx,sy,sw,sh,this);
		return(img);
	}

	public Dimension getPreferredSize()
	{
		Dimension dim = super.getPreferredSize();
		dim.width  = w>0 ? w : dim.width;
		dim.height = h>0 ? h : dim.height;
		return(dim);
	}

	public Dimension getMinimumSize()
	{
		Dimension dim = super.getMinimumSize();
		dim.width  = w>0 ? w : dim.width;
		dim.height = h>0 ? h : dim.height;
		return(dim);
	}

	// called from Componentlistener.componentResized()
	public void noticeResize()
	{
		validBuf=false;
		newScreenBuffer();
	}
	
	public boolean waitForNewScreenBuf()
	{
		return(validBuf);
	}
	
}
