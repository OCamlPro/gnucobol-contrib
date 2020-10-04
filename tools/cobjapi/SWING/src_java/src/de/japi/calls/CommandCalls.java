package de.japi.calls;

import de.japi.Japi2;
import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import de.japi.components.AbstractJapi2ValueComponent;
import de.japi.components.Japi2Button;
import de.japi.components.Japi2Canvas;
import de.japi.components.Japi2CheckBox;
import de.japi.components.Japi2CheckMenuItem;
import de.japi.components.Japi2Choice;
import de.japi.components.Japi2Dialog;
import de.japi.components.Japi2Frame;
import de.japi.components.Japi2GraphicButton;
import de.japi.components.Japi2GraphicLabel;
import de.japi.components.Japi2Label;
import de.japi.components.Japi2Led;
import de.japi.components.Japi2List;
import de.japi.components.Japi2Menu;
import de.japi.components.Japi2MenuItem;
import de.japi.components.Japi2Meter;
import de.japi.components.Japi2Panel;
import de.japi.components.Japi2TabbedPane;
import de.japi.components.Japi2PopupMenu;
import de.japi.components.Japi2PrintJob;
import de.japi.components.Japi2RadioButton;
import de.japi.components.Japi2TextArea;
import de.japi.components.Japi2TextField;
import de.japi.components.Japi2FormattedTextField;
import de.japi.components.Japi2Tree;
import de.japi.components.Japi2Window;
import de.japi.components.layout.Japi2FixLayout;
import de.japi.components.layout.Japi2GridLayout;
import de.japi.components.layout.Japi2HorizontalFlowLayout;
import de.japi.components.layout.Japi2VerticalFlowLayout;
import de.japi.components.listeners.Japi2ComponentListener;
import java.applet.Applet;
import java.applet.AudioClip;
import java.awt.Adjustable;
import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Container;
import java.awt.Cursor;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.Insets;
import java.awt.LayoutManager;
import java.awt.MenuComponent;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.Window;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.URL;
import java.util.Arrays;
import javax.swing.ButtonGroup;
import javax.swing.ImageIcon;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JComponent;
import javax.swing.JPopupMenu;
import javax.swing.JProgressBar;
import javax.swing.JSplitPane;
import javax.swing.KeyStroke;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;
import javax.swing.text.JTextComponent;
import javax.swing.tree.DefaultMutableTreeNode;

/**
 * This class contains all JAPI calls which are commands,i.e. any kind of set 
 * calls and execution calls.
 */
public class CommandCalls {
    
    /*
     * The following four methods are responsible to access the Java Printing
     * API.
     */
    
    public static void print(Japi2Session s, Japi2Canvas i) throws IOException {
        // (Try to) Create a new job
        Japi2PrintJob job;
        try {
            job = new Japi2PrintJob();
        } catch (IllegalStateException ex) {
            return; // User cancelled
        }
        
        // Draw the given image
        Graphics g = job.getGraphics();
        g.drawImage(i.getImage(), 0, 0, null);
        g.dispose();
        job.end();
    }
    
    public static void print(Japi2Session s, Image i) throws IOException {
        // (Try to) Create a new job
        Japi2PrintJob job;
        try {
            job = new Japi2PrintJob();
        } catch (IllegalStateException ex) {
            return; // User cancelled
        }
        
        // Draw the given image
        Graphics g = job.getGraphics();
        g.drawImage(i, 0, 0, null);
        g.dispose();
        job.end();
    }
    
    public static void print(Japi2Session s, Japi2PrintJob j) throws IOException {
        j.newPage();
    }

    // Instead of painting the component onto the printing canvas, take a 
    // screenshot. This might be not the best way, but it works the same
    // way as the original JAPI kernel worked.
    public static void print(Japi2Session s, Component c) throws IOException {
        // Find parent component (window)
        while (c.getParent() != null) {
            c = c.getParent();
        }
        
        // Create a screenshot
        BufferedImage buf = null;
        try {
            Robot r = new Robot();
            buf = r.createScreenCapture(c.getBounds());
        } catch (Exception ex) {
            Japi2.getInstance().debug("Failed to create a screenshot.", ex);
            return;
        }
        
        // (Try to) Create a new job
        Japi2PrintJob job;
        try {
            job = new Japi2PrintJob();
        } catch (IllegalStateException ex) {
            return; // User cancelled
        }
        
        // Draw the given image
        Graphics g = job.getGraphics();
        g.drawImage(buf, 0, 0, null);
        g.dispose();
        job.end();
    }
    
    public static void setEchoChar(Japi2Session s, Japi2TextField t) throws IOException {
        char c = (char) s.readByte();
        s.log2("Set echo char to {0} for {1}", c, t);
        t.setEchoChar(c);
    }

    /**
     * These methods set the Insets (borders of a container) of an object.
     * @param s
     * @param f
     * @throws IOException 
     */
    public static void setInsets(Japi2Session s, Japi2Frame f) throws IOException {
        Insets newInsets = new Insets(
                s.readInt(),
                s.readInt(),
                s.readInt(),
                s.readInt()
        );
        s.log2("Set insets to {0} for {1}", newInsets, f);
        f.setInsets(newInsets);
    }
    
    public static void setInsets(Japi2Session s, Japi2Dialog d) throws IOException {
        Insets newInsets = new Insets(
                s.readInt(),
                s.readInt(),
                s.readInt(),
                s.readInt()
        );
        s.log2("Set insets to {0} for {1}", newInsets, d);
        // Uggly: SWING does not support Insets any more. Instead a border
        // is used to create the margin. An existing border will be removed
        // and replaced by this empty insets border
        ((JComponent) d.getContentPane()).setBorder(new EmptyBorder(newInsets));
    }
    
    public static void setInsets(Japi2Session s, Japi2Window w) throws IOException {
        Insets newInsets = new Insets(
                s.readInt(),
                s.readInt(),
                s.readInt(),
                s.readInt()
        );
        s.log2("Set insets to {0} for {1}", newInsets, w);
        w.setInsets(newInsets);
    }
    
    public static void setInsets(Japi2Session s, Japi2Panel p) throws IOException {
        Insets newInsets = new Insets(
                s.readInt(),
                s.readInt(),
                s.readInt(),
                s.readInt()
        );
        s.log2("Set insets to {0} for {1}", newInsets, p);
        p.setInsets(newInsets);
    }

    public static void setInsets(Japi2Session s, Japi2TabbedPane p) throws IOException {
        Insets newInsets = new Insets(
                s.readInt(),
                s.readInt(),
                s.readInt(),
                s.readInt()
        );
        s.log2("Set insets to {0} for {1}", newInsets, p);
        p.setInsets(newInsets);
    }
    
    public static void setValue(Japi2Session s, Adjustable c) 
            throws IOException {
        c.setValue(s.readInt());
        s.log2("Set value to {0} for {1}", c.getValue(), c);
    }
    
    public static void setValue(Japi2Session s, AbstractJapi2ValueComponent c) 
            throws IOException {
        c.setValue(s.readInt());
        s.log2("Set value to {0} for {1}", c.getValue(), c);
    }
    
    public static void setValue(Japi2Session s, JProgressBar c) 
            throws IOException {
        c.setValue(s.readInt());
        s.log2("Set value to {0} for {1}", c.getValue(), c);
    }
    
    /*
     * Sets the danger zone of a Japi2Meter to the read value.
     */
    public static void setDanger(Japi2Session s, Japi2Meter c) throws IOException {
        c.setDangerValue(s.readInt());
        s.log2("Set danger to {0}", c.getDangerValue());
    }
    
    public static void setMax(Japi2Session s, Adjustable c) throws IOException {
        c.setMaximum(s.readInt());
        s.log2("Set maximum to {0}", c.getMaximum());
    }
    
    public static void setMax(Japi2Session s, AbstractJapi2ValueComponent c) 
            throws IOException {
        c.setMax(s.readInt());
        s.log2("Set maximum to {0}", c.getMax());
    }
    
    public static void setMax(Japi2Session s, JProgressBar c) 
            throws IOException {
        c.setMaximum(s.readInt());
        s.log2("Set maximum to {0}", c.getMaximum());
    }
    
    
    public static void setMin(Japi2Session s, Adjustable c) throws IOException {
        c.setMinimum(s.readInt());
        s.log2("Set minimum to {0}", c.getMinimum());
    }
    
    public static void setMin(Japi2Session s, AbstractJapi2ValueComponent c) 
            throws IOException {
        c.setMin(s.readInt());
        s.log2("Set minimum to {0}", c.getMin());
    }
    
    public static void setMin(Japi2Session s, JProgressBar c) 
            throws IOException {
        c.setMinimum(s.readInt());
        s.log2("Set minimum to {0}", c.getMinimum());
    }
    
    public static void setBorderLayoutConstraint(Japi2Session session, 
            Component c) throws IOException {
        int constraint = session.readInt();
        session.log2("BorderLayout position {0} for {1}", constraint, c);
        
        if (c.getParent() instanceof Container) {
            Container cont = c.getParent();
            cont.remove(c);
            switch (constraint) {
                case Japi2Constants.J_TOP:
                    cont.add(c, BorderLayout.NORTH);
                    break;
                case Japi2Constants.J_BOTTOM:
                    cont.add(c, BorderLayout.SOUTH);
                    break;
                case Japi2Constants.J_LEFT:
                    cont.add(c, BorderLayout.WEST);
                    break;
                case Japi2Constants.J_RIGHT:
                    cont.add(c, BorderLayout.EAST);
                    break;
                case Japi2Constants.J_CENTER:
                    cont.add(c, BorderLayout.CENTER);
                    break;
                default:
                    throw new UnsupportedOperationException(
                            "No valid BorderLayout position in j_borderpos"
                    );
            }
        }
        
    }
    
    /*
     *  Sets the horizontal gap in the LayoutManager of a Container object.
     */
    
    public static void setHGap(Japi2Session session, Container c) 
            throws IOException, UnsupportedOperationException {
        int gap = session.readInt();
        session.log2("Set HGAP to {0}, component {1}", gap, c);
        LayoutManager mgr = c.getLayout();
        session.log2("Layout manager (b4) {0}", mgr);
        
        // Apply gap
        if (mgr instanceof FlowLayout) {
            ((FlowLayout) mgr).setHgap(gap);
        } else if (mgr instanceof Japi2FixLayout) {
            ((Japi2FixLayout) mgr).setHgap(gap);
        } else if (mgr instanceof GridLayout) {
            ((GridLayout) mgr).setHgap(gap);
        } else if (mgr instanceof BorderLayout) {
            // Uggly workaround, but a simple 
            // ((BorderLayout) mgr).setVgap(gap); will not do the job!
            BorderLayout m = (BorderLayout) mgr;
            c.setLayout(new BorderLayout(gap, m.getVgap()));
        } else {
            throw new UnsupportedOperationException(
                    "No LayoutManager in j_sethgap of object " + c.toString()
            );
        }
        
        session.log2("Layout manager (a8) {0}", mgr);
        c.invalidate();
        c.revalidate();
        c.repaint();
    }
    
    /*
     *  Sets the vertical gap in the LayoutManager of a Container object.
     */
    
    public static void setVGap(Japi2Session session, Container c) 
            throws IOException, UnsupportedOperationException {
        int gap = session.readInt();
        session.log2("Set VGAP to {0}, component {1}", gap, c);
        LayoutManager mgr = c.getLayout();
        session.log2("Layout manager (b4) {0}", mgr);
        
        // Apply gap
        if (mgr instanceof FlowLayout) {
            ((FlowLayout) mgr).setVgap(gap);
        } else if (mgr instanceof Japi2FixLayout) {
            ((Japi2FixLayout) mgr).setVgap(gap);
        } else if (mgr instanceof GridLayout) {
            ((GridLayout) mgr).setVgap(gap);
        } else if (mgr instanceof BorderLayout) {
            // TODO: uggly workaround, but a simple 
            // ((BorderLayout) mgr).setVgap(gap); will not do the job!
            BorderLayout m = (BorderLayout) mgr;
            c.setLayout(new BorderLayout(m.getHgap(), gap));
        } else {
            throw new UnsupportedOperationException(
                    "No LayoutManager in j_setvgap of object " + c.toString()
            );
        }
        
        session.log2("Layout manager (a8) {0}", mgr);
        c.invalidate();
        c.revalidate();
        c.repaint();
    }
    
    public static void debug(Japi2Session session) throws IOException {
        int level = session.readInt();
        Japi2.getInstance().debug("Setting debug level to {0}", level);
        session.getDebugWindow().setLevel(level);
    }
    
    public static void show(Japi2Session session, Component c) {
        session.log2("Show {0}", c);
        c.setVisible(true);
        
        // If a JList is made visible, re-render also the list entries
        if (c instanceof Japi2List) {
            ((Japi2List) c).update();
        }
    }
    
    public static void showPopUp(Japi2Session session, JPopupMenu m)
            throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        session.log2("Show Popup in {0} at position {1}:{2}", m, x, y);
        if (m instanceof Japi2PopupMenu) {
            m.show(((Japi2PopupMenu) m).getJapi2Parent(), x, y);
        } else {
            m.show(m.getParent(), x, y);
        }
    }
    
    public static void dispose(Japi2Session session, Window w) {
        session.log2("Dispose window ({0})", w);
        w.dispose();
    }
    
    public static void dispose(Japi2Session session, Component c) {
        session.log2("Dispose component aka. remove it from its parent ({0})", c);
        c.getParent().remove(c);
    }
    
    
    public static void dispose(Japi2Session session, JComponent mc) {
        session.log2("Dispose menu component aka. remove it from its "
                + "parent ({0})", mc);
        mc.getParent().remove(mc);
    }
    
    public static void dispose(Japi2Session session, Japi2PrintJob pj) {
        session.log2("Dispose print job aka. quit ({0})", pj);
        pj.end();
        session.deleteObject(pj);
    }
    
    public static void quit(Japi2Session session) throws IOException {
        session.log1("Client requested to quit session");
        session.exit();
    }
    
    /*
     * This method sets the position of a component to a given x and y position,
     * by using setLocation. 
     * Extracted from setLocation(int x, int y) Specification:
     * Moves this component to a new location. The top-left corner of the new 
     * location is specified by the x and y parameters in the coordinate space 
     * of this component's parent. This method changes layout-related information, 
     * and therefore, invalidates the component hierarchy.
     */
    
    public static void setPos(Japi2Session session, Component c) throws IOException {
        int xPos = session.readInt();
        int yPos = session.readInt();
        session.log2("Set {0} to position {1}, {2}", c, xPos , yPos);
        c.setLocation(xPos, yPos);
    }
    
    /*
     * These methods set the size of a component to a given width and height. The 
     * order of the methods is important because Japi2Canvas is also a 
     * component.
     */
    
    public static void setSize(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int width = session.readInt();
        int height = session.readInt();

        session.log2("Setsize {0} to: {1} x {2}", canvas, width, height);
        canvas.setSize(width, height);   

        while(canvas.waitForNewScreenBuf() == false) {
            try {
                Thread.sleep(100);
            } catch(InterruptedException e) {
                session.log2("Thread was interrupted");
            }
        }   
    }
     
    public static void setSize(Japi2Session session, Component component) throws IOException {
        int width = session.readInt();
        int height = session.readInt();

        session.log2("Setsize {0} to: {1} x {2}", component, width, height);
        component.setSize(width, height);   
    }
    
    /*
     * The following overloaded setState-methods set the state of JChekBoxMenuItems, 
     * Japi2ChekBox, Japi2RadioButton and Japi2Led components.
     * This means they set the components to selected if value is true, otherwise
     * the state is set to false.
     */
    
    public static void setState(Japi2Session session, Japi2CheckMenuItem checkBoxMenuItem) throws IOException {
        int value = session.readInt();
        session.log2("Setstate {0} to {1}", checkBoxMenuItem, value);
        checkBoxMenuItem.setSelected(value!=Japi2Constants.J_FALSE);   
    }
    
    public static void setState(Japi2Session session, Japi2CheckBox checkBox) throws IOException {
        int value = session.readInt();
        session.log2("Setstate {0} to {1}", checkBox, value);
        checkBox.setSelected(value!=Japi2Constants.J_FALSE);  
    }
    
    public static void setState(Japi2Session session, Japi2RadioButton radioButton) throws IOException {
        int value = session.readInt();
        session.log2("Setstate {0} to {1}", radioButton, value);
        radioButton.setSelected(value!=Japi2Constants.J_FALSE);  
    }
    
    public static void setState(Japi2Session session, Japi2Led led) throws IOException {
        int value = session.readInt();
        session.log2("Setstate {0} to {1}", led, value);
        led.setOn(value!=Japi2Constants.J_FALSE);  
    }
    
    /*
     * The following four methods enable Components, Menus, MenuItems and 
     * CheckBoxMenuItems.
     */
    
    public static void enable(Japi2Session session, Component component) throws IOException {
        session.log2("Enable Object {0}", component);
        component.setEnabled(true);  
    }
    
    public static void enable(Japi2Session session, Japi2Menu menu) throws IOException {
        session.log2("Enable Object {0}", menu);
        menu.setEnabled(true);  
    }
    
    public static void enable(Japi2Session session, Japi2MenuItem menuItem) throws IOException {
        session.log2("Enable Object {0}", menuItem);
        menuItem.setEnabled(true);  
    }
    
    public static void enable(Japi2Session session, JCheckBoxMenuItem checkBoxMenuItem) throws IOException {
        session.log2("Enable Object {0}", checkBoxMenuItem);
        checkBoxMenuItem.setEnabled(true);  
    }
    
    /*
     * The following four methods disable Components, Menus, MenuItems and 
     * CheckBoxMenuItems.
     */
    
    public static void disable(Japi2Session session, Component component) throws IOException {
        session.log2("Disable Object {0}", component);
        component.setEnabled(false);  
    }
    
    public static void disable(Japi2Session session, Japi2Menu menu) throws IOException {
        session.log2("Disable Object {0}", menu);
        menu.setEnabled(false);  
    }
    
    public static void disable(Japi2Session session, Japi2MenuItem menuItem) throws IOException {
        session.log2("Disable Object {0}", menuItem);
        menuItem.setEnabled(false);  
    }
    
    public static void disable(Japi2Session session, JCheckBoxMenuItem checkBoxMenuItem) throws IOException {
        session.log2("Disable Object {0}", checkBoxMenuItem);
        checkBoxMenuItem.setEnabled(false);  
    }
    
    /*
     * This method causes this Window to be sized to fit the preferred size 
     * and layouts of its subcomponents. 
     */
    
    public static void pack(Japi2Session session, Window window) throws IOException {
        session.log2("Pack {0}", window);
        window.pack();
    }
    
    /*
     * These methods add an item to a list or a choiceBox/comoboBox.
     */
    
    public static void addItem(Japi2Session session, Japi2List list) throws IOException {
        String title = session.readLine();
        session.log2("add {0} to {1}", title, list);
        list.addElement(title);
    }
    
    public static void addItem(Japi2Session session, Japi2Choice choice) throws IOException {
        String title = session.readLine();
        session.log2("add {0} to {1}", title, choice);
        choice.addItem(title);
    }    

    /*
     * This method creates a Tab for a TabbedPane, and adds an Item Listener to it.
     */
    public static void addTab(Japi2Session session, Japi2TabbedPane tabbedpane) throws IOException {
        String title = session.readLine();

        Japi2Panel panel = new Japi2Panel();
        int oid = session.addObject(panel);  
        tabbedpane.addTab(title, panel);
        
        //item listener
        Japi2ComponentListener componentListener = new Japi2ComponentListener(session, oid, Japi2Constants.J_RESIZED);
        panel.setJapiListener(componentListener);
        panel.addComponentListener(componentListener);
        
        session.log2("TAB {0} (ID = {1}) in Parent Object {2}", title, oid, tabbedpane);
        session.writeInt(oid);
    }

    /*
     * This method creates a Tab with Icon for a TabbedPane, and adds an Item Listener to it.
     */
    public static void addTabWithIcon(Japi2Session session, Japi2TabbedPane tabbedpane) throws IOException {
        String title = session.readLine();
        String filename = session.readLine();

        // Load the image
        Image picture = Toolkit.getDefaultToolkit().getImage(new URL(
                "http",
                session.getResourceHost(),
                session.getResourcePort(),
                filename)
        );
        ImageIcon icon = new ImageIcon(picture);
        
        Japi2Panel panel = new Japi2Panel();
        int oid = session.addObject(panel);  
        tabbedpane.addTab(title, icon, panel);
        
        //item listener
        Japi2ComponentListener componentListener = new Japi2ComponentListener(session, oid, Japi2Constants.J_RESIZED);
        panel.setJapiListener(componentListener);
        panel.addComponentListener(componentListener);
        
        session.log2("TAB {0} (ID = {1}) in Parent Object {2} icon = {3}", title, oid, tabbedpane, icon);
        session.writeInt(oid);
    }

    /*
     * This method adds a node to an other node.
     */
    public static void addNode(Japi2Session session, DefaultMutableTreeNode parentNode) throws IOException {
        int node = session.readInt();

        DefaultMutableTreeNode childNode = session.getObjectById(node, DefaultMutableTreeNode.class);
        session.log2("Parent Node {0}, Child Node {1}", parentNode, childNode);
        parentNode.add(childNode);
    }

    /*
     * This method enable double click action on a tree.
     */
    public static void enableDoubleClick(Japi2Session session, Japi2Tree tree) throws IOException {
        session.log2("enableDoubleClick, tree {0}", tree);
        tree.enableDoubleClickAction();
    }

    /*
     * This method disable double click action on a tree.
     */
    public static void disableDoubleClick(Japi2Session session, Japi2Tree tree) throws IOException {
        session.log2("enableDoubleClick, tree {0}", tree);
        tree.disableDoubleClickAction();
    }
    
    /*
     * These methods select an item in a list or a choiceBox/comoboBox.
     */
    
    public static void select(Japi2Session session, Japi2List list) throws IOException {
        int item = session.readInt();
        session.log2("select in {0}: {1}", list, item);
        list.setSelectedIndex(item);
    }
    
    public static void select(Japi2Session session, Japi2Choice choice) throws IOException {
        int item = session.readInt();
        session.log2("select in {0}: {1}", choice, item);
        choice.setSelectedIndex(item);
    }
    
    /*
     * The following methods allow to read a text of arbitrary length and set it 
     * as title/text to the components Frame, Dialog, Button, Label, Menu, MenuItem,
     * CheckBoxMenuItem und TextComponent.
     */
    
    public static void setText(Japi2Session session, Japi2Frame frame) throws IOException {
        int length = session.readInt();
        
        if(length > 0) {
            byte[] buffer = new byte[length];
            session.read(buffer, length);
            String text = new String(buffer);
            
            session.log2("Set Text {0} length {1}", frame, length);
            frame.setTitle(text);
        }       
    }
    
    public static void setText(Japi2Session session, Japi2Dialog dialog) throws IOException {
        int length = session.readInt();
        
        if(length > 0) {
            byte[] buffer = new byte[length];
            session.read(buffer, length);
            String text = new String(buffer);
            
            session.log2("Set Text {0} length {1}", dialog, length);
            dialog.setTitle(text);
        }       
    }
    
    public static void setText(Japi2Session session, Japi2Button button) throws IOException {
        int length = session.readInt();
        
        if(length > 0) {
            byte[] buffer = new byte[length];
            session.read(buffer, length);
            String text = new String(buffer);
            
            session.log2("Set Text {0} length {1}", button, length);
            button.setText(text);
        }       
    }
    
    public static void setText(Japi2Session session, Japi2Label label) throws IOException {
        int length = session.readInt();
        
        if(length > 0) {
            byte[] buffer = new byte[length];
            session.read(buffer, length);
            String text = new String(buffer);
            
            session.log2("Set Text {0} length {1}", label, length);
            label.setText(text);
        }       
    }
    
    public static void setText(Japi2Session session, Japi2Menu menu) throws IOException {
        int length = session.readInt();
        
        if(length > 0) {
            byte[] buffer = new byte[length];
            session.read(buffer, length);
            String text = new String(buffer);
            
            session.log2("Set Text {0} length {1}", menu, length);
            menu.setText(text);
        }       
    }
    
    public static void setText(Japi2Session session, Japi2MenuItem menuItem) throws IOException {
        int length = session.readInt();
        
        if(length > 0) {
            byte[] buffer = new byte[length];
            session.read(buffer, length);
            String text = new String(buffer);
            
            session.log2("Set Text {0} length {1}", menuItem, length);
            menuItem.setText(text);
        }       
    }
    
    public static void setText(Japi2Session session, Japi2CheckMenuItem checkMenuItem) throws IOException {
        int length = session.readInt();
        
        if(length > 0) {
            byte[] buffer = new byte[length];
            session.read(buffer, length);
            String text = new String(buffer);
            
            session.log2("Set Text {0} length {1}", checkMenuItem, length);
            checkMenuItem.setText(text);
        }       
    }
    
    public static void setText(Japi2Session session, JTextComponent textComponent) throws IOException {
        int length = session.readInt();
        
        if(length > 0) {
            byte[] buffer = new byte[length];
            session.read(buffer, length);
            String text = new String(buffer);
            
            session.log2("Set Text {0} length {1}", textComponent, length);
            textComponent.setText(text);
        }       
    }
    
    /*
     * This method sets the cursor image to the specific cursor. 
     */
    
    public static void cursor(Japi2Session session, Component component) throws IOException {
        int value = session.readInt();
        session.log2("Set cursor in {0} to {1}", component, value);
        component.setCursor(new Cursor(value));      
    }
    
    /*
     * This method hides a Component by setting it invisible. 
     */
    
    public static void hide(Japi2Session session, Component component) throws IOException {
        session.log2("HIDE {0}", component);
        component.setVisible(false);      
    }
    
    /*
     * This methods requests to focus for this component.
     */
    
    public static void setFocus(Japi2Session session, Component component) throws IOException {
        session.log2("Set Focus");
        component.requestFocus();
    }
    
    /*
     * This method sets shortcuts for menuItems, so that they can be accessed
     * via keybord inputs.
     */
    
    public static void setShortCut(Japi2Session session, Japi2MenuItem menuItem) throws IOException {
        byte c = (byte) session.readByte();
        session.log2("Set Shortcut Character in {0} to {1}", menuItem, (char)c);
        menuItem.setAccelerator(KeyStroke.getKeyStroke((char)c));      
    }
    
    /*
     * This method sets the unit value increment for the component adjustable.
     */
    
    public static void setUnitInc(Japi2Session session, Adjustable adjustable) throws IOException {
        int value = session.readInt();
        session.log2("Set Unit Increment to {0}", value);
        adjustable.setUnitIncrement(value);      
    }
    
    /*
     * This method sets the block value increment for the component adjustable.
     */
    
    public static void setBlockInc(Japi2Session session, Adjustable adjustable) throws IOException {
        int value = session.readInt();
        session.log2("Set Block Increment to {0}", value);
        adjustable.setBlockIncrement(value);      
    }
    
    /*
     * This method sets the length of the adjustable object to value.
     */
    
    public static void setVisible(Japi2Session session, Adjustable adjustable) throws IOException {
        int value = session.readInt();
        session.log2("Set visible to {0}", value);
        adjustable.setVisibleAmount(value);      
    }
    
    /*
     * This method sets multiplemode for list, so it is possible to select
     * multiple list elements.
     */
    
    public static void multipleMode(Japi2Session session, Japi2List list) throws IOException {
        int value = session.readInt();
        session.log2("Set multiple Mode for {0}: {1}", list, value);
        list.setMultipleMode(value!= Japi2Constants.J_FALSE);
    }
   
    /*
     * This method selects the entire text in a text component.
     */
    
    public static void selectAll(Japi2Session session, JTextComponent textComp) throws IOException {
        session.log2("Select all in {0}", textComp);
        textComp.selectAll();
    }
    
    /*
     *  This method deselects all selected items in a Japi2List. This is different
     *  to AWT.
     */
    
    public static void deselect(Japi2Session session, Japi2List list) throws IOException {
        int item = session.readInt();
        session.log2("Select in {0}: {1}", list, item);
        
        // Instead of list.clearSelection();
        // do this:
        int[] sels = list.getList().getSelectedIndices();
        int[] newSel = new int[0];
        for (int sel : sels) {
            if (sel != item) {
                newSel = Arrays.copyOf(newSel, newSel.length + 1);
                newSel[newSel.length - 1] = sel;
            }
        }
        list.getList().setSelectedIndices(newSel);
    }
    
    /*
     *  These methods set the Font of Components, MenuComponents, Images and
     *  PrintJobs to the given type, style and size.
     */
    
    public static void setFont(Japi2Session session, Component component) throws IOException {
        int type = session.readInt();
        int style = session.readInt();
        int size = session.readInt();
        String font;
        
        switch (type) {
            case Japi2Constants.J_COURIER:
                font = "Monospaced";
                break;
            case Japi2Constants.J_HELVETIA:
                font = "SansSerif";
                break;
            case Japi2Constants.J_TIMES:
                font = "Serif";
                break;
            case Japi2Constants.J_DIALOGOUT:
                font = "Dialog";
                break;
            case Japi2Constants.J_DIALOGIN:
                font = "DialogInput";
                break;
            default :
                font = "Dialog";
                break;      
        }
        session.log2("Set Font in {0} to {1}", component, font);
        component.setFont(new Font(font, style, size));
    }
    
    public static void setFont(Japi2Session session, JComponent menuComponent) throws IOException {
        int type = session.readInt();
        int style = session.readInt();
        int size = session.readInt();
        String font;
        
        switch (type) {
            case Japi2Constants.J_COURIER:
                font = "Monospaced";
                break;
            case Japi2Constants.J_HELVETIA:
                font = "SansSerif";
                break;
            case Japi2Constants.J_TIMES:
                font = "Serif";
                break;
            case Japi2Constants.J_DIALOGOUT:
                font = "Dialog";
                break;
            case Japi2Constants.J_DIALOGIN:
                font = "DialogInput";
                break;
            default :
                font = "Dialog";
                break;      
        }
        session.log2("Set Font in {0} to {1}", menuComponent, font);
        menuComponent.setFont(new Font(font, style, size));
    }
    
    public static void setFont(Japi2Session session, Image image) throws IOException {
        int type = session.readInt();
        int style = session.readInt();
        int size = session.readInt();
        String font;
        
        switch (type) {
            case Japi2Constants.J_COURIER:
                font = "Monospaced";
                break;
            case Japi2Constants.J_HELVETIA:
                font = "SansSerif";
                break;
            case Japi2Constants.J_TIMES:
                font = "Serif";
                break;
            case Japi2Constants.J_DIALOGOUT:
                font = "Dialog";
                break;
            case Japi2Constants.J_DIALOGIN:
                font = "DialogInput";
                break;
            default :
                font = "Dialog";
                break;      
        }
        session.log2("Set Font in {0} to {1}", image, font);
        image.getGraphics().setFont(new Font(font, style, size));
    }
    
    
    public static void setFont(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int type = session.readInt();
        int style = session.readInt();
        int size = session.readInt();
        String font;
        
        switch (type) {
            case Japi2Constants.J_COURIER:
                font = "Monospaced";
                break;
            case Japi2Constants.J_HELVETIA:
                font = "SansSerif";
                break;
            case Japi2Constants.J_TIMES:
                font = "Serif";
                break;
            case Japi2Constants.J_DIALOGOUT:
                font = "Dialog";
                break;
            case Japi2Constants.J_DIALOGIN:
                font = "DialogInput";
                break;
            default :
                font = "Dialog";
                break;      
        }
        session.log2("Set Font in {0} to {1}", printJob, font);
        printJob.getGraphics().setFont(new Font(font, style, size));
    }
    
    /*
     *  These methods set the font name of Components, MenuComponents, Images and
     *  PrintJobs to the given type, style and size.
     */
    
    public static void setFontName(Japi2Session session, Component component) throws IOException {
        int type = session.readInt();
        String font;
        
        switch (type) {
            case Japi2Constants.J_COURIER:
                font = "Monospaced";
                break;
            case Japi2Constants.J_HELVETIA:
                font = "SansSerif";
                break;
            case Japi2Constants.J_TIMES:
                font = "Serif";
                break;
            case Japi2Constants.J_DIALOGOUT:
                font = "Dialog";
                break;
            case Japi2Constants.J_DIALOGIN:
                font = "DialogInput";
                break;
            default :
                font = "Dialog";
                break;      
        }
        session.log2("Set Font name in {0} to {1}", component, font);
        if(component.getFont()== null) 
            component.setFont(new Font("Dialog", Font.PLAIN, 12));
        
        component.setFont(new Font(font, component.getFont().getStyle(), component.getFont().getSize()));
    }
    
    public static void setFontName(Japi2Session session, JComponent menuComponent) throws IOException {
        int type = session.readInt();
        String font;
        
        switch (type) {
            case Japi2Constants.J_COURIER:
                font = "Monospaced";
                break;
            case Japi2Constants.J_HELVETIA:
                font = "SansSerif";
                break;
            case Japi2Constants.J_TIMES:
                font = "Serif";
                break;
            case Japi2Constants.J_DIALOGOUT:
                font = "Dialog";
                break;
            case Japi2Constants.J_DIALOGIN:
                font = "DialogInput";
                break;
            default :
                font = "Dialog";
                break;      
        }
        session.log2("Set Font name in {0} to {1}", menuComponent, font);
        if(menuComponent.getFont()== null) 
            menuComponent.setFont(new Font("Dialog", Font.PLAIN, 12));
        
        menuComponent.setFont(new Font(font, menuComponent.getFont().getStyle(), menuComponent.getFont().getSize()));
    }
    
    public static void setFontName(Japi2Session session, Image image) throws IOException {
        int type = session.readInt();
        String font;
        
        switch (type) {
            case Japi2Constants.J_COURIER:
                font = "Monospaced";
                break;
            case Japi2Constants.J_HELVETIA:
                font = "SansSerif";
                break;
            case Japi2Constants.J_TIMES:
                font = "Serif";
                break;
            case Japi2Constants.J_DIALOGOUT:
                font = "Dialog";
                break;
            case Japi2Constants.J_DIALOGIN:
                font = "DialogInput";
                break;
            default :
                font = "Dialog";
                break;      
        }
        session.log2("Set Font name in {0} to {1}", image, font);
        if(image.getGraphics().getFont()== null) 
            image.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
        
        image.getGraphics().setFont(new Font(font, image.getGraphics().getFont().getStyle(), image.getGraphics().getFont().getSize()));
    }
    
    public static void setFontName(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int type = session.readInt();
        String font;
        
        switch (type) {
            case Japi2Constants.J_COURIER:
                font = "Monospaced";
                break;
            case Japi2Constants.J_HELVETIA:
                font = "SansSerif";
                break;
            case Japi2Constants.J_TIMES:
                font = "Serif";
                break;
            case Japi2Constants.J_DIALOGOUT:
                font = "Dialog";
                break;
            case Japi2Constants.J_DIALOGIN:
                font = "DialogInput";
                break;
            default :
                font = "Dialog";
                break;      
        }
        session.log2("Set Font name in {0} to {1}", printJob, font);
        if(printJob.getGraphics().getFont()== null) 
            printJob.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
        
        printJob.getGraphics().setFont(new Font(font, printJob.getGraphics().getFont().getStyle(), printJob.getGraphics().getFont().getSize()));
    }
    
    /*
     * These methods set the font style of texts in Components, MenuComponents, 
     * Images or Japi2PrintJobs to to the specified style or if no size is given
     * to 12pt Dialog.
     */
    
    public static void setFontStyle(Japi2Session session, Component component) throws IOException {
        int style = session.readInt();
        session.log2("Set Font style in {0} to {1}", component, style);
        if(component.getFont()== null) 
            component.setFont(new Font("Dialog", Font.PLAIN, 12));
        
        component.setFont(new Font(component.getFont().getName(), style, component.getFont().getSize()));
    }
    
    public static void setFontStyle(Japi2Session session, MenuComponent menuComponent) throws IOException {
        int style = session.readInt();
        session.log2("Set Font style in {0} to {1}", menuComponent, style);
        if(menuComponent.getFont()== null) 
            menuComponent.setFont(new Font("Dialog", Font.PLAIN, 12));
        
        menuComponent.setFont(new Font(menuComponent.getFont().getName(), style, menuComponent.getFont().getSize()));
    }
    
    public static void setFontStyle(Japi2Session session, Image image) throws IOException {
        int style = session.readInt();
        session.log2("Set Font style in {0} to {1}", image, style);
        if(image.getGraphics().getFont()== null) 
            image.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
        
        image.getGraphics().setFont(new Font(image.getGraphics().getFont().getName(), style, image.getGraphics().getFont().getSize()));
    }
    
    public static void setFontStyle(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int style = session.readInt();
        session.log2("Set Font style in {0} to {1}", printJob, style);
        if(printJob.getGraphics().getFont()== null) 
            printJob.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
        
        printJob.getGraphics().setFont(new Font(printJob.getGraphics().getFont().getName(), style, printJob.getGraphics().getFont().getSize()));
    }   
    
    /*
     * These methods set the font size of texts in Components, MenuComponents, 
     * Images or Japi2PrintJobs to to the specified style or if no size is given
     * to 12pt Dialog.
     */
    
    public static void setFontSize(Japi2Session session, Component component) throws IOException {
        int size = session.readInt();
        session.log2("Set Font size in {0} to {1}", component, size);
        if(component.getFont()== null) 
            component.setFont(new Font("Dialog", Font.PLAIN, 12));
        
        component.setFont(new Font(component.getFont().getName(), component.getFont().getStyle(),size));
    }
    
    public static void setFontSize(Japi2Session session, JComponent menuComponent) throws IOException {
        int size = session.readInt();
        session.log2("Set Font size in {0} to {1}", menuComponent, size);
        if(menuComponent.getFont()== null) 
            menuComponent.setFont(new Font("Dialog", Font.PLAIN, 12));
        
        menuComponent.setFont(new Font(menuComponent.getFont().getName(), menuComponent.getFont().getStyle(),size));
    }
     
    public static void setFontSize(Japi2Session session, Image image) throws IOException {
        int size = session.readInt();
        session.log2("Set Font size in {0} to {1}", image, size);
        if(image.getGraphics().getFont()== null) 
            image.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
        
        image.getGraphics().setFont(new Font(image.getGraphics().getFont().getName(), image.getGraphics().getFont().getStyle(),size));
    }
     
    public static void setFontSize(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int size = session.readInt();
        session.log2("Set Font size in {0} to {1}", printJob, size);
        if(printJob.getGraphics().getFont()== null) 
            printJob.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
        
        printJob.getGraphics().setFont(new Font(printJob.getGraphics().getFont().getName(), printJob.getGraphics().getFont().getStyle(),size));
    }
    
    /*
     * These methods set whether a frame or dialog is resizable by the user.
     */
    
    public static void setResizable(Japi2Session session, Japi2Frame frame) throws IOException {
        int value = session.readInt();
        session.log2("Set Resizable {0} to {1}", frame, value);
        frame.setResizable(value != Japi2Constants.J_FALSE);
    }
    
    public static void setResizable(Japi2Session session, Japi2Dialog dialog) throws IOException {
        int value = session.readInt();
        session.log2("Set Resizable {0} to {1}", dialog, value);
        dialog.setResizable(value != Japi2Constants.J_FALSE);
    }
    
    /*
     * This method selects the text in a Japi2TextArea form start to end.
     */
    
    public static void selectText(Japi2Session session, Japi2TextArea textArea) throws IOException {
        int start = session.readInt();
        int end = session.readInt();

        session.log2("Select Text {0} from {1} to {2}", textArea, start, end);
        textArea.select(start, end);
    } 
    
    /*
     * These methods set the number of rows for a Japi2TextArea or a GridLayout.
     */
    
    public static void setRows(Japi2Session session, Japi2TextArea textArea) throws IOException {
        int val = session.readInt();
        session.log2("Set Rows to {0}", val);
        textArea.setRows(val);
    }
     
    public static void setRows(Japi2Session session, GridLayout layout) throws IOException {
        int val = session.readInt();
        session.log2("Set Rows to {0}", val);
        layout.setRows(val);
    }
    
    /*
     * These methods set the number of columns for a Japi2TextArea or a GridLayout.
     */
    
    public static void setColumns(Japi2Session session, Japi2TextArea textArea) throws IOException {
        int val = session.readInt();
        session.log2("Set Columns to {0}", val);
        textArea.setColumns(val);
    }
    
    public static void setColumns(Japi2Session session, Japi2TextField textArea) throws IOException {
        int val = session.readInt();
        session.log2("Set Columns to {0}", val);
        textArea.setColumns(val);
    }
     
    public static void setColumns(Japi2Session session, Japi2FormattedTextField textArea) throws IOException {
        int val = session.readInt();
        session.log2("Set Columns to {0}", val);
        textArea.setColumns(val);
    }

    public static void setColumns(Japi2Session session, GridLayout layout) throws IOException {
        int val = session.readInt();
        if (layout.getColumns() == val) {
            return; // Nothing to do
        }
        session.log2("Set Columns to {0}", val);
        layout.setColumns(val);
    }
    
    /*
     * Sets the image for the Japi2GraphicButton or Japi2GraphicLabel.
     */
    
    public static void setImage(Japi2Session session, Japi2GraphicButton b)
            throws IOException {
        int imgNo = session.readInt();
        session.log2("Set Image in {0} to {1}", b, imgNo);
        Image img = session.getObjectById(imgNo, Image.class);
        b.setImage(img);
    }
    
    public static void setImage(Japi2Session session, Japi2GraphicLabel l)
            throws IOException {
        int imgNo = session.readInt();
        session.log2("Set Image in {0} to {1}", l, imgNo);
        Image img = session.getObjectById(imgNo, Image.class);
        l.setImage(img);
    }
    
    /*
     * Deletes a text from start to end inside a Japi2TextArea.
     */
    
    public static void delete(Japi2Session session, Japi2TextArea textArea) throws IOException {
        int start = session.readInt();
        int end = session.readInt();
        session.log2("Delete Text in {0}", textArea);
        textArea.replaceRange("", start, end);
    }
    
    /*
     * Inserts a text at given length and position into a Japi2TextArea.
     */
    
    public static void insertText(Japi2Session session, Japi2TextArea textArea) throws IOException {
        int pos = session.readInt();
        int len = session.readInt();
        session.log2("Insert Text in {0} at Position {1}, textlength = {2} ", textArea, pos, len);

        if (len > 0) {
            byte[] buf = new byte[len];
            session.read(buf, len);
            textArea.insert(new String(buf), pos);
        }
    }
    
    /*
     * This method sets the position at which the selection starts.
     */
    
    public static void setCurPos(Japi2Session session, JTextComponent textComponent) throws IOException {
        int pos = session.readInt();
        session.log2("Set Selection Start {0}", textComponent);
        textComponent.setCaretPosition(pos);
    }
   
    /*
     * Inserts an item at a given index into a list or ChoiceBox. Similar to 
     * additem, but element is inserted at index pos instead of attaching it 
     * to the end of the list or choiceBox.
     */
    
    public static void insert(Japi2Session session, Japi2List list) throws IOException {
        int pos = session.readInt();
        String item = session.readLine();
        session.log2("Insert in {0}: {1} at position {2}", list, item, pos);
        list.insertElementAt(item, pos);    
    }
    
    public static void insert(Japi2Session session, Japi2Choice choice) throws IOException {
        int pos = session.readInt();
        String item = session.readLine();
        session.log2("Insert in {0}: {1} at position {2}", choice, item, pos);
        choice.insertItemAt(item, pos);    
    }
    
    /*
     * These methods remove the element at the position index from a List or ChoiceBox.
     */
    
    public static void remove(Japi2Session session, Japi2List list) throws IOException {
        int index = session.readInt();
        session.log2("Remove in {0}: {1}", list, index);
        list.removeFromList(index);    
    }
    
    public static void remove(Japi2Session session, Japi2Choice choice) throws IOException {
        int index = session.readInt();
        session.log2("Remove in {0}: {1}", choice, index);
        choice.remove(index);    
    }
    
    /*
     * These methods remove all elements from a List or ChoiceBox.
     */
    
    public static void removeAll(Japi2Session session, Japi2List list) throws IOException {
        session.log2("Removes all elements in {0}", list);
        list.clear();
    }
    
    public static void removeAll(Japi2Session session, Japi2Choice choice) throws IOException {
        session.log2("Removes all elements in {0}", choice);
        choice.removeAll();    
    }
    
    /*
     * Replaces a text in a TextArea from start to end with the text read 
     * into the array buf.
     */
    
    public static void replaceText(Japi2Session session, Japi2TextArea textArea) throws IOException {
        int start = session.readInt();
        int end = session.readInt();
        int len = session.readInt();
        session.log2("Replace text {0} textlength = {1}", textArea, len);
        if(len > 0) {
            byte[] buf = new byte[len];
            session.read(buf, len);
            textArea.replaceRange(new String(buf), start, end);
        }
    }
    
    /*
     * Loads a new Audio clip and adds it to the session.
     */
    
    public static void sound(Japi2Session session) throws IOException {
        String file = session.readLine();
        session.log2("Load Sound File {0}", file);
        AudioClip sound = Applet.newAudioClip(new URL(
                "http", 
                session.getResourceHost(), 
                session.getResourcePort(), 
                file
        ));
        session.writeInt(session.addObject(sound));
    }
    
    /*
     * Plays the sound of the given AudioClip.
     */
    
    public static void play(Japi2Session session, AudioClip audioClip) throws IOException {
        session.log2("Play Sound {0}", audioClip);
        audioClip.play();
    }
    
     /*
      * Sets a previously loaded Image as an Icon for a Frame. 
      */
    
    public static void setIcon(Japi2Session session, Japi2Frame frame) throws IOException {
        int icon = session.readInt();
        Image image = session.getObjectById(icon, Image.class);
        session.log2("Set Icon {0} to {1}", frame, image);
        frame.setIconImage(image);    
    }
    
    /*
     * Sets a text component to editable or to not edidtable.
     */
    
    public static void editable(Japi2Session session, JTextComponent textComp) throws IOException {
        int val = session.readInt();
        session.log2("{0} set editable {1}", textComp, val);
        textComp.setEditable(val != Japi2Constants.J_FALSE);
    }
    
    /*
     * Plays the sound from the audioclip file.
     */
    
    public static void playSoundFile(Japi2Session session) throws IOException {
        String file = session.readLine();
        session.log2("Play sound file {0}", file);
        AudioClip snd = Applet.newAudioClip(new URL(
                "http", 
                session.getResourceHost(), 
                session.getResourcePort(), 
                file
        ));
        snd.play();
    }
    
    /*
     * Adds a component to the parent at id par.
     */
    
    public static void add(Japi2Session session, Component component) throws IOException {
        int parent = session.readInt();
        Container par = session.getObjectById(parent, Container.class);
        session.log2("ADD {0} to {1}", component, par);
        if(par instanceof Container) {
            if(component.getParent() != null) {
               component.getParent().remove(component);
            }else {
                par.add(component);
            }
        }
    }
    
    /*
     * Removes a component from its parent Object.
     */
    
    public static void release(Japi2Session session, Component component) throws IOException {
        session.log2("RELEASE {0}", component);
        if(component.getParent() != null) {
            component.getParent().remove(component);   
        }
    }
    
    /*
     * Removes all components from a container.
     */
    
    public static void releaseAll(Japi2Session session, Container container) throws IOException {
        session.log2("RELEASE ALL in {0}", container);
        int i = container.getComponentCount();
        while(--i >= 0) {
           container.remove(container.getComponent(0));
        }
    }
    
    /*
     * Sets the group of a checkBox to rp.
     */
    
    public static void setRadioGroup(Japi2Session session, Japi2CheckBox checkBox) throws IOException {
        int rp = session.readInt();
        session.log2("Set Radio Group {0} to {1}", checkBox, rp);
        ButtonGroup group = session.getObjectById(rp, ButtonGroup.class);
        if(group instanceof ButtonGroup) {
            checkBox.getModel().setGroup(group); 
        }
    }
    
    /*
     * Removes the given string from a List or ChoiceBox.
     */
    
    public static void removeItem(Japi2Session session, Japi2List list) throws IOException {
        String item = session.readLine();
        session.log2("Remove Item in {0}: {1}", list, item);
        list.removeElementFromList(item);
    }
    
    public static void removeItem(Japi2Session session, Japi2Choice choice) throws IOException {
        String item = session.readLine();
        session.log2("Remove Item in {0}: {1}", choice, item);
        choice.removeItem(item);
    }
    
   /*
    * Appends a text read into a byte array in a TextArea.
    */
    
    public static void appendText(Japi2Session session, Japi2TextArea textArea) throws IOException {
        int len = session.readInt();
        byte[] buf = new byte[len];
        session.read(buf, len);
        session.log2("Append Text {0}: {1}", textArea, new String(buf));
        textArea.append(new String(buf));
    }
    
    /*
     * Methods to set the alignment of Text inside a Label or Container, to right,
     * left or center.
     */
    
    public static void setAlign(Japi2Session session, Japi2Label label) throws IOException {
        int align = session.readInt();
        
        if (
                (align != Japi2Constants.J_LEFT) && 
                (align != Japi2Constants.J_CENTER) && 
                (align != Japi2Constants.J_RIGHT) && 
                (align != Japi2Constants.J_BOTTOM) && 
                (align != Japi2Constants.J_TOP) && 
                (align != Japi2Constants.J_TOPLEFT) && 
                (align != Japi2Constants.J_TOPRIGHT) && 
                (align != Japi2Constants.J_BOTTOMLEFT) && 
                (align != Japi2Constants.J_BOTTOMRIGHT)
            ) {
            Japi2.getInstance().debug("No valid Alignment in j_setalign(ID, Alignment). Alignment = {0})", align);
        } else {
            session.log2("Set Alignment in  {0} to {1}", label, align);
            switch (align) {
                case (Japi2Constants.J_LEFT):
                    label.setHorizontalAlignment(SwingConstants.LEFT);
                    break;
                case (Japi2Constants.J_RIGHT):
                    label.setHorizontalAlignment(SwingConstants.RIGHT);
                    break;
                case (Japi2Constants.J_CENTER):
                    label.setHorizontalAlignment(SwingConstants.CENTER);
                    break;
            }
        }
    }
    
    public static void setAlign(Japi2Session session, Container container) throws IOException {
        int align = session.readInt();
        
        if (
                (align != Japi2Constants.J_LEFT) && 
                (align != Japi2Constants.J_CENTER) && 
                (align != Japi2Constants.J_RIGHT) && 
                (align != Japi2Constants.J_BOTTOM) && 
                (align != Japi2Constants.J_TOP) && 
                (align != Japi2Constants.J_TOPLEFT) && 
                (align != Japi2Constants.J_TOPRIGHT) && 
                (align != Japi2Constants.J_BOTTOMLEFT) && 
                (align != Japi2Constants.J_BOTTOMRIGHT)
            ) {
            Japi2.getInstance().debug("No valid Alignment in j_setalign(ID, Alignment). Alignment = {0})", align);
        } else {
            session.log2("Set Alignment in  {0} to {1}", container, align);
            if(container.getLayout() instanceof FlowLayout) {
                ((FlowLayout)container.getLayout()).setAlignment(align);
                container.revalidate();
            } else {
                Japi2.getInstance().debug("No valid Layout Manager in Object ID, j_setalign(ID, ... ). ID = {0})", container);
            }
        }
    }
   
    
    /*
     * Fills the the layout of a container if it is an instance of a vertical
     * or horizontal FlowLayout.
     */
    
    public static void fillFlowLayout(Japi2Session session, Container container) throws IOException {
        int b = session.readInt();
        session.log2("Set Fill Flowlayout {0} to {1}", container, b);
        if(container.getLayout() instanceof Japi2VerticalFlowLayout) {
           ((Japi2VerticalFlowLayout)container.getLayout()).setFill(b != Japi2Constants.J_FALSE);
           container.revalidate();
        } else if(container.getLayout() instanceof Japi2HorizontalFlowLayout) {
           ((Japi2HorizontalFlowLayout)container.getLayout()).setFill(b != Japi2Constants.J_FALSE);
           container.revalidate();
        } else {
            throw new UnsupportedOperationException(
                    "No valid Layout Manager in Object ID, j_fillflowlayout(ID, ... )."
            );
        }
    } 
    
    /*
     * Methods for the split pane component.
     */
    
    public static void setLeftSplitPaneComponent(Japi2Session session, JSplitPane sp) throws IOException {
        int argId = session.readInt();
        session.log2("Set as left split pane component: {0} for {1}", argId, sp);
        Component c = session.getObjectById(argId, Container.class);
        sp.setLeftComponent(c);
    }
    
    public static void setRightSplitPaneComponent(Japi2Session session, JSplitPane sp) throws IOException {
        int argId = session.readInt();
        session.log2("Set as right split pane component: {0} for {1}", argId, sp);
        Component c = session.getObjectById(argId, Container.class);
        sp.setRightComponent(c);
    }
    
}  
