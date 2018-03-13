/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Alert.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Alert.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Alert.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Alert.java
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

public class JAPI_Alert extends Dialog  implements ActionListener, WindowListener
{
	Button but1,but2,but3;
	int retval=0;

	public JAPI_Alert(Frame parent, String title, String text, int jid)
	throws MalformedURLException
	{
		super(parent, title, false);
		retval=jid;

        this.setLayout(new BorderLayout(15, 15));

        Panel p = new Panel();
        p.setLayout(new FlowLayout(FlowLayout.CENTER, 15, 15));
        JAPI_Graphiclabel gl = new JAPI_Graphiclabel("danger.gif");
	    if(gl!=null)
	        p.add(gl);
		this.add("West",p);

        JAPI_MultiLineLabel label = new JAPI_MultiLineLabel(text, 20, 20, 1);
        this.add("Center", label);

		placeandshow(parent);
	}

	public JAPI_Alert(Frame parent, String title, String text, String b1)
	throws MalformedURLException
	{
		super(parent, title, true);

        this.setLayout(new BorderLayout(15, 15));

        Panel p = new Panel();
        p.setLayout(new FlowLayout(FlowLayout.CENTER, 15, 15));
        JAPI_Graphiclabel gl = new JAPI_Graphiclabel("danger.gif");
	    if(gl!=null)
	        p.add(gl);
		this.add("West",p);

        JAPI_MultiLineLabel label = new JAPI_MultiLineLabel(text, 20, 20, 1);
        this.add("Center", label);

        p = new Panel();
        add("South", p);
        JAPI_VFlowlayout vf=new JAPI_VFlowlayout();
        vf.setFill(true);
        p.setLayout(vf);
	    p.add(new JAPI_Ruler(JAPI_Const.J_HORIZONTAL,JAPI_Const.J_LINEDOWN,0));
        Panel p2 = new Panel();
        p2.setLayout(new FlowLayout(FlowLayout.CENTER, 25, 5));
        p2.add(but1 = new Button(b1));
 		but1.addActionListener(this);
 		addWindowListener(this);
		p.add("South", p2);
		placeandshow(parent);
		but1.requestFocus();
	}


	public JAPI_Alert(Frame parent, String title, String text, String b1, String b2)
	throws MalformedURLException
	{
		super(parent, title, true);

        this.setLayout(new BorderLayout(15, 15));

        Panel p = new Panel();
        p.setLayout(new FlowLayout(FlowLayout.CENTER, 15, 15));
        JAPI_Graphiclabel gl = new JAPI_Graphiclabel("question.gif");
	    if(gl!=null)
	        p.add(gl);
		this.add("West",p);

        JAPI_MultiLineLabel label = new JAPI_MultiLineLabel(text, 20, 20, 1);
        this.add("Center", label);

        p = new Panel();
        add("South", p);
        JAPI_VFlowlayout vf=new JAPI_VFlowlayout();
        vf.setFill(true);
        p.setLayout(vf);
	    p.add(new JAPI_Ruler(JAPI_Const.J_HORIZONTAL,JAPI_Const.J_LINEDOWN,0));
        Panel p1 = new Panel();
        p1.setLayout(new FlowLayout());
        Panel p2 = new Panel();
        p2.setLayout(new GridLayout(1,2,25,5));
        p2.add(but1 = new Button(b1));
 		but1.addActionListener(this);
        p2.add(but2 = new Button(b2));
 		but2.addActionListener(this);
 		addWindowListener(this);
        p1.add(p2);
		p.add(p1);
		but1.requestFocus();

		placeandshow(parent);
		but1.requestFocus();
	}

	public JAPI_Alert(Frame parent, String title, String text, String b1, String b2, String b3)
	throws MalformedURLException
	{
		super(parent, title, true);

        this.setLayout(new BorderLayout(15, 15));

        Panel p = new Panel();
        p.setLayout(new FlowLayout(FlowLayout.CENTER, 15, 15));
        JAPI_Graphiclabel gl = new JAPI_Graphiclabel("question.gif");
	    if(gl!=null)
	        p.add(gl);
		this.add("West",p);

        JAPI_MultiLineLabel label = new JAPI_MultiLineLabel(text, 20, 20, 1);
        this.add("Center", label);

        p = new Panel();
        add("South", p);
        JAPI_VFlowlayout vf=new JAPI_VFlowlayout();
        vf.setFill(true);
        p.setLayout(vf);
	    p.add(new JAPI_Ruler(JAPI_Const.J_HORIZONTAL,JAPI_Const.J_LINEDOWN,0));
        Panel p1 = new Panel();
        p1.setLayout(new FlowLayout());
        Panel p2 = new Panel();
        p2.setLayout(new GridLayout(1,3,25,5));
        p2.add(but1 = new Button(b1));
 		but1.addActionListener(this);
        p2.add(but2 = new Button(b2));
 		but2.addActionListener(this);
        p2.add(but3 = new Button(b3));
 		but3.addActionListener(this);
 		addWindowListener(this);
 		p1.add(p2);
 		p.add(p1);
		but1.requestFocus();

		placeandshow(parent);
	}


	public void placeandshow(Frame f)
	{
		int xpos,ypos;

		this.pack();
		xpos=f.getLocation().x+f.getSize().width/2;
		ypos=f.getLocation().y+f.getSize().height/2;
		xpos -= this.getSize().width/2;
		ypos -= this.getSize().height/2;
		xpos = xpos<0?0:xpos;
		ypos = ypos<0?0:ypos;
		this.setBounds(xpos,ypos,this.getSize().width,this.getSize().height);
		this.setVisible(true);
		this.toFront();
	}

	public void actionPerformed(ActionEvent event)
	{
		retval=0;
		if((but1!=null) && (event.getActionCommand().equals(but1.getLabel())))
			retval=1;
		if((but2!=null) && (event.getActionCommand().equals(but2.getLabel())))
			retval=2;
		if((but3!=null) && (event.getActionCommand().equals(but3.getLabel())))
			retval=3;
		this.dispose();
	}

	public void  windowClosing(WindowEvent e)
	{
		retval=0;
		this.dispose();
	}
	
	public int getChoice()
	{
		return(retval);
	}
	
	public void  windowOpened(WindowEvent e)
	{
	}
	public void  windowClosed(WindowEvent e)
	{}
	public void  windowActivated(WindowEvent e)
	{
		but1.requestFocus();
	}
	public void  windowDeactivated(WindowEvent e)
	{}
	public void  windowIconified(WindowEvent e)
	{}
	public void  windowDeiconified(WindowEvent e)
	{}
}
