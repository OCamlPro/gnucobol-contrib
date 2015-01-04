/*
*>******************************************************************************
*>  This file is part of cobjapi.
*>
*>  JAPI_Errordialog.java is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  JAPI_Errordialog.java is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with JAPI_Errordialog.java.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      JAPI_Errordialog.java
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

public class JAPI_Errordialog extends Dialog implements ActionListener
{
   boolean result;
   JAPI_MultiLineLabel errorlabel1;
   Label errorlabel2;

   public JAPI_Errordialog(Frame owner)
   {
      super(owner, "JAPI Error", true);

      setLayout(new BorderLayout());
      Panel panel = new Panel();
      panel.setLayout(new FlowLayout(FlowLayout.CENTER, 15, 15));
      JAPI_Graphiclabel gl = new JAPI_Graphiclabel("danger.gif");
	  if(gl!=null)
	       panel.add(gl);
	  this.add("West",panel);

      panel = new Panel();
      panel.setLayout(new JAPI_VFlowlayout());
      add("Center", panel);

      //Message
      Panel panel2 = new Panel();
      errorlabel1 = new JAPI_MultiLineLabel("",10,10,1); // Rand 10, CENTER
      panel2.setLayout(new FlowLayout(FlowLayout.CENTER));
      panel2.add(errorlabel1);
      panel.add(panel2);



      //Buttons
      panel = new Panel();
      add("South", panel);
      JAPI_VFlowlayout vf=new JAPI_VFlowlayout();
      vf.setFill(true);
      panel2 = new Panel();
      errorlabel2 = new Label("Do you wish to continue ?"); 
      panel2.setLayout(new FlowLayout(FlowLayout.CENTER));
      panel2.add(errorlabel2);
      panel.add(panel2);
      panel.setLayout(vf);
      panel.add(new JAPI_Ruler(JAPI_Const.J_HORIZONTAL,JAPI_Const.J_LINEDOWN,10));
      panel2 = new Panel();
      panel.add(panel2);
      panel2.setLayout(new FlowLayout(FlowLayout.CENTER,25,5));
      Button button = new Button("  No  ");
      button.addActionListener(this);
      panel2.add(button);
      button = new Button(" Yes ");
      button.addActionListener(this);
      panel2.add(button);
   }

   public void actionPerformed(ActionEvent event)
   {
      result = event.getActionCommand().equals(" Yes ");
      setVisible(false);
   }

   public boolean getResult(String str1)
   {
      errorlabel1.setText(str1);
      pack();
      setVisible(true);
      return result;
   }
}

