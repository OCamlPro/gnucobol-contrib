package de.japi.calls;

import de.japi.Japi2;
import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import de.japi.components.Japi2AlertDialog;
import de.japi.components.Japi2Button;
import de.japi.components.Japi2Canvas;
import de.japi.components.Japi2CheckBox;
import de.japi.components.Japi2CheckMenuItem;
import de.japi.components.Japi2Choice;
import de.japi.components.Japi2Dialog;
import de.japi.components.Japi2Frame;
import de.japi.components.Japi2GraphicButton;
import de.japi.components.Japi2GraphicLabel;
import de.japi.components.Japi2Image;
import de.japi.components.Japi2Label;
import de.japi.components.Japi2Led;
import de.japi.components.Japi2List;
import de.japi.components.Japi2Menu;
import de.japi.components.Japi2MenuBar;
import de.japi.components.Japi2MenuItem;
import de.japi.components.Japi2Meter;
import de.japi.components.Japi2Panel;
import de.japi.components.Japi2TabbedPane;
import de.japi.components.Japi2PopupMenu;
import de.japi.components.Japi2PrintJob;
import de.japi.components.Japi2RadioButton;
import de.japi.components.Japi2RadioGroup;
import de.japi.components.Japi2Ruler;
import de.japi.components.Japi2ScrollPane;
import de.japi.components.Japi2SevenSegment;
import de.japi.components.Japi2Slider;
import de.japi.components.Japi2TextArea;
import de.japi.components.Japi2TextField;
import de.japi.components.Japi2FormattedTextField;
import de.japi.components.listeners.Japi2ActionListener;
import de.japi.components.listeners.Japi2AdjustmentListener;
import de.japi.components.listeners.Japi2ComponentListener;
import de.japi.components.listeners.Japi2ItemListener;
import de.japi.components.listeners.Japi2TextListener;
import de.japi.components.listeners.Japi2WindowListener;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Container;
import java.awt.Image;
import java.awt.MediaTracker;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import javax.swing.ImageIcon;
import javax.swing.JFileChooser;
import javax.swing.JPopupMenu;
import javax.swing.JProgressBar;
import javax.swing.JScrollBar;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JWindow;
import javax.swing.SwingConstants;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

/**
 * This class contains all JAPI calls which construct a GUI object.
 */
public class ConstructionCalls {
    
    /*
     * This method creates a Japi2Frame and adds a Japi2WindowListener to it.
     */
    public static void createJFrame(Japi2Session session) throws IOException {
        // Create the frame
        Japi2Frame frame = new Japi2Frame(session.readLine());
        session.log1("Frame created: {0}", frame);
        int frameId = session.addObject(frame);
        
        // Add window close listener
        frame.addWindowListener(new Japi2WindowListener(
                session, 
                frameId, 
                Japi2Constants.J_CLOSING
        ));
        
        // Write back the id
        session.writeInt(frameId);
    }
    
    /*
     * This method creates a Textarea and adds a Japi2Textlistener to it.
     */
    public static void createTextArea(Japi2Session session, Container cont) throws IOException {
        int row = session.readInt();
        int col = session.readInt();
        
        session.log1("TextArea {0} x {1} in parent object {2}", row, col, cont);
        
        // create GUI-obj
        Japi2TextArea textArea =  new Japi2TextArea(row, col);
        int oid = session.addObject(textArea);
        cont.add(textArea);
        
        // add Textlistener
        Japi2TextListener tl = new Japi2TextListener(
                session,
                oid
        );
        textArea.addTextListener(tl);
        
        // send result
        session.writeInt(oid);
    }
    
    /**
     * This method creates a Textfield and adds an Japi2Actionlistener to it.
     */
    public static void createTextField (Japi2Session session, Container cont) throws IOException {
        int col = session.readInt();
        session.log1("TextField {0} in parent object {1}", col, cont);
        
        // create GUI-obj
        Japi2TextField textField = new Japi2TextField(col);
        int oid = session.addObject(textField);
        cont.add(textField);
        
        // add ActionListener
        Japi2ActionListener al = new Japi2ActionListener(
            session,
            oid
        );
        textField.addActionListener(al);
        
        // send result
        session.writeInt(oid);
    }

    /**
     * This method creates a FormattedTextfield and adds an Japi2Actionlistener to it.
     */
    public static void createFormattedTextField (Japi2Session session, Container cont) throws IOException {
        int col = session.readInt();
        String maskStr = session.readLine();
        String placeHldr = session.readLine();        
        session.log1("FormattedTextField col {0} mask {1} placeHldr {2} in parent object {3}", col, maskStr, placeHldr, cont);
        
        if (placeHldr.isEmpty()) {
           placeHldr = " ";
        }
        
        // create GUI-obj
        Japi2FormattedTextField formattedTextField = new Japi2FormattedTextField(maskStr, placeHldr.charAt(0), col);
        int oid = session.addObject(formattedTextField);
        cont.add(formattedTextField);
        
        // add ActionListener
        Japi2ActionListener al = new Japi2ActionListener(
            session,
            oid
        );
        formattedTextField.addActionListener(al);
        
        // send result
        session.writeInt(oid);
    }
    
    /**
     * This method creates a Filedialog that either opens or writes a file
     * depending on the inputstream.
     */
    public static void createFileDialog (Japi2Session session, Container cont) throws IOException {
        String appath = session.readLine();
        String title = session.readLine();
        String dir = session.readLine();
        
        File setdir = new File(appath + File.separator + dir);
        setdir = new File(setdir.getCanonicalPath());
        
        session.log1("JFileChooser in parent object {0}, directory {1}", cont, setdir);
        
        // A bug? If the file dialog gets a parent (e.g. JFrame) then the
        // save dialog is not displayed and the application hangs.
        
        int index;
        int returnValue;
        JFileChooser f;
        if ((index = title.indexOf("/S")) < 0) {
            // Show open file dialog
            f = new JFileChooser(setdir);
            f.setAcceptAllFileFilterUsed(true);
            f.setMultiSelectionEnabled(false);
            f.setDialogTitle(title);
            returnValue = f.showOpenDialog(null);
        } else {
            f = new JFileChooser(setdir);
            f.setAcceptAllFileFilterUsed(true);
            f.setMultiSelectionEnabled(false);
            title = title.substring(0,index) + title.substring(index+2,title.length());
            f.setDialogTitle(title);
            returnValue = f.showSaveDialog(null);
        }
        
        if (returnValue == JFileChooser.APPROVE_OPTION) {
            String filename = f.getSelectedFile().getAbsolutePath();
            session.log1("File: {0}", filename);
            session.writeInt(filename.length());  
            session.writeBytes(filename.getBytes());
        } else {
            session.writeInt(0);
        }
    }
    
    /*
     * This method creates a JDialog object and adds a Japi2Windowlistener to it.
     */
    public static void createDialog(Japi2Session session, Japi2Frame frame) throws IOException {
        String title = session.readLine();
        
        session.log1("Dialog in parent object {0}", frame);
        Japi2Dialog dialog = new Japi2Dialog(frame, title);
        int oid = session.addObject(dialog);
        dialog.addWindowListener(new Japi2WindowListener(
                session, 
                oid, 
                Japi2Constants.J_CLOSING
        ));
        
        session.writeInt(oid);
    }
    
    /*
     * This method creates a JWindow object.
     */
    public static void createWindow(Japi2Session session, Japi2Frame frame) throws IOException {
        session.log1("Window in parent object {0}", frame);
        JWindow window = new JWindow(frame);
        int oid = session.addObject(window);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a JPopupMenu object.
     */
    public static void showPopMenu(Japi2Session session, Component comp) throws IOException {
        String title = session.readLine();
        session.log1("Popup Menu in parent object {0}", comp);
        Japi2PopupMenu popMenu = new Japi2PopupMenu(title);
        popMenu.setJapi2Parent(comp);
        int oid = session.addObject(popMenu);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a JScrollPane object and adds a Japi2ComponentListener to it.
     */
    public static void createScrollPane(Japi2Session session, Container cont) throws IOException {
        session.log1("Scrollpane in parent object {0}", cont);
        JScrollPane scrollPane = new Japi2ScrollPane();
        int oid = session.addObject(scrollPane);
        cont.add(scrollPane);
        Japi2ComponentListener cl = new Japi2ComponentListener(session, oid, Japi2Constants.J_RESIZED);
        scrollPane.addComponentListener(cl);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a new vertical Scrollbar if a JScrollPane already exists
     * and adds a Japi2AdjustmentListener to it.
     */
    public static void setVScroll(Japi2Session session, JScrollPane pane) throws IOException {
        session.log1("VScroll in parent object {0}", pane);    
        JScrollBar bar = pane.getVerticalScrollBar();
        int oid = session.addObject(bar);
        bar.addAdjustmentListener(new Japi2AdjustmentListener(session, oid));
        session.writeInt(oid);
    }
    
    /*
     * This method creates a new vertical Scrollbar if no JScrollPane already exists
     * and adds a Japi2AdjustmentListener to it.
     */
    public static void createVSlider(Japi2Session session, Container cont) throws IOException {
        session.log1("VScroll in parent object {0}", cont);
        Japi2Slider slider = new Japi2Slider(false);
        cont.add(slider);
        int oid = session.addObject(slider);
        slider.addAdjustmentListener(new Japi2AdjustmentListener(session, oid));
        session.writeInt(oid);
    }
    
    /*
     * This method creates a new horizontal Scrollbar if a JScrollPane already exists
     * and adds a Japi2AdjustmentListener to it.
     */
    public static void setHScroll(Japi2Session session, JScrollPane pane) throws IOException {
        session.log1("HScroll in parent object {0}", pane);    
        JScrollBar bar = pane.getHorizontalScrollBar();
        int oid = session.addObject(bar);
        bar.addAdjustmentListener(new Japi2AdjustmentListener(session, oid));
        session.writeInt(oid);
    }
    
    /*
     * This method creates a new horizontal Scrollbar if no JScrollPane already exists
     * and adds a Japi2AdjustmentListener to it.
     */
    public static void createHSlider(Japi2Session session, Container cont) throws IOException {
        session.log1("HScroll in parent object {0}", cont);
        Japi2Slider slider = new Japi2Slider(true);
        cont.add(slider);
        int oid = session.addObject(slider);
        slider.addAdjustmentListener(new Japi2AdjustmentListener(session, oid));
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Japi2GraphicButton.
     */
    public static void createGraphicButton (Japi2Session session, Container cont) throws IOException {
        String icon = session.readLine();
        session.log1("GraphicButton in parent object {0}, icon = {1}", cont, icon);
        Japi2GraphicButton gb = new Japi2GraphicButton(session, icon);
        int oid = session.addObject(gb);
        // Save object ID of GraphicButton in the GraphicButton object
        gb.setId(oid);
        cont.add(gb);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Japi2GraphicLabel.
     */
    public static void createGraphicLabel(Japi2Session session, Container cont) 
            throws IOException, MalformedURLException, InterruptedException {
        String icon = session.readLine();
        session.log1("GraphicLabel in parent object {0}, icon = {1}", cont, icon);
        Japi2GraphicLabel label = new Japi2GraphicLabel(session, icon);
        cont.add(label);
        int oid = session.addObject(label);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Japi2Ruler object.
     */
    public static void createRuler(Japi2Session session, Container cont) throws IOException {
        int orientation = session.readInt();
        int style = session.readInt();
        int length = session.readInt();
        session.log1("Ruler in parent object {0}", cont);
        Japi2Ruler ruler = new Japi2Ruler(orientation, style, length);
        cont.add(ruler);
        int oid = session.addObject(ruler);
        session.writeInt(oid);
    }
    
    /*
     * This method creates an Image object.
     */
    public static void showImage(Japi2Session session) throws IOException {
        int width = session.readInt();
        int height = session.readInt();
        session.log1("New Image [width={0},height={1}]", width, height);
        Image pic = new Japi2Image(width, height);
        int oid = session.addObject(pic);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a non-blocking Japi2AlertDialog window.
     */
    public static void showMessageBox(Japi2Session session, Japi2Frame frame) throws IOException {
        int n = session.readInt();
        String title = session.readLine();
        String text = session.readString(n);
        
        session.log1("AlertBox in parent object {0}", frame);
        
        Japi2AlertDialog alert = new Japi2AlertDialog(frame, title, text);
        int oid = session.addObject(alert);
        alert.setRetVal(oid);
        
        alert.addWindowListener(new Japi2WindowListener(
                session, oid, Japi2Constants.J_CLOSING
        ));
        session.writeInt(oid, Japi2Session.TargetStream.COMMAND);
    }
    
    // Is a blocking call
    public static void showAlertBox(Japi2Session session, Japi2Frame frame) throws IOException {
        int n = session.readInt();
        String title = session.readLine();
        String btn1 = session.readLine();
        String text = session.readString(n);
        
        session.log1("AlertBox in parent object {0} ({1})", frame, btn1);
        
        Japi2AlertDialog alert = new Japi2AlertDialog(frame, title, text, btn1);
        session.writeInt(alert.getValue());
    }
    
    // Is a blocking call
    public static void showChoiceBox2(Japi2Session session, Japi2Frame frame) throws IOException {
        int n = session.readInt();
        String title = session.readLine();
        String btn1 = session.readLine();
        String btn2 = session.readLine();
        String text = session.readString(n);
        
        session.log1("ChoiceBox with 2 buttons in parent object {0} ({1}, {2})", frame, btn1, btn2);
        
        Japi2AlertDialog alert = new Japi2AlertDialog(frame, title, text, btn1, btn2);
        session.writeInt(alert.getValue());
    }
    
    // Is a blocking call
    public static void showChoiceBox3(Japi2Session session, Japi2Frame frame) throws IOException {
        int n = session.readInt();
        String title = session.readLine();
        String btn1 = session.readLine();
        String btn2 = session.readLine();
        String btn3 = session.readLine();
        String text = session.readString(n);
        
        session.log1("ChoiceBox with 3 buttons in parent object {0} ({1}, {2}, {3})", frame, btn1, btn2, btn3);
        
        Japi2AlertDialog alert = new Japi2AlertDialog(frame, title, text, btn1, btn2, btn3);
        session.writeInt(alert.getValue());
    }
    
    /*
     * This method creats a Canvas, and adds a Component Listener to it.
     */
    public static void createCanvas(Japi2Session session, Container container) throws IOException {
        int width = session.readInt();
        int height = session.readInt();
        
        Japi2Canvas canvas = new Japi2Canvas(width, height);
        int oid = session.addObject(canvas);
        container.add(canvas);
        
        //component listener
        Japi2ComponentListener componentListener = new Japi2ComponentListener(session, oid, Japi2Constants.J_RESIZED);
        session.addObject(componentListener);
        canvas.addComponentListener(componentListener);
        
        session.log1("CANVAS [{0}, {1}] (ID = {2}) in Parent Object {3}", width, height, oid, container);
        session.writeInt(oid);
    }
    
    /*
     * This method creats a Button, and adds an Action Listener to it.
     */
    public static void createButton(Japi2Session session, Container container) throws IOException {
        String title = session.readLine();
        
        Japi2Button button = new Japi2Button(title);
        int oid = session.addObject(button);
        container.add(button);
        
        //action listener
        Japi2ActionListener actionListener = new Japi2ActionListener(session, oid);
        button.setJapiListener(actionListener);
        button.addActionListener(actionListener);
        
        session.log1("BUTTON {0} (ID = {1}) in Parent Object {2}", title, oid, container);
        session.writeInt(oid);
    }
    
    /*
     * The following eight Methods can be used to construct Menus.
     */
    public static void createMenuBar(Japi2Session session, Japi2Frame frame) throws IOException {
        Japi2MenuBar menuBar = new Japi2MenuBar();
        int oid = session.addObject(menuBar);
        frame.setJMenuBar(menuBar);
        
        session.log1("MENUBAR (ID = {0}) in Parent Object {1}", oid, frame);
        session.writeInt(oid);
    }
    
    public static void createMenu(Japi2Session session, Japi2MenuBar menuBar) throws IOException {
        String title = session.readLine();

        Japi2Menu menu = new Japi2Menu(title);
        int oid = session.addObject(menu);
        menuBar.add(menu);
         
        session.log1("MENU {0} (ID = {1}) in Parent Object {2}", title, oid, menuBar);        
        session.writeInt(oid);
    }
    
    public static void createMenu(Japi2Session session, Japi2Menu menu) throws IOException {
        String title = session.readLine();

        Japi2Menu m = new Japi2Menu(title);
        int oid = session.addObject(m);
        menu.add(m);
                
        session.log1("MENU {0} (ID = {1}) in Parent Object {2}", title, oid, menu);
        session.writeInt(oid);
    }
    
    public static void createHelpMenu(Japi2Session session, Japi2MenuBar menuBar) throws IOException {
        String title = session.readLine();

        Japi2Menu menu = new Japi2Menu(title);
        int oid = session.addObject(menu);
        menuBar.add(menu);
        // Ugly: setHelpMenu is not available in SWING, so ignore it!
        //menuBar.setHelpMenu(menu);
        
        session.log1("HELPMENU {0} (ID = {1}) in Parent Object {2}", title, oid, menuBar);
        session.writeInt(oid);
    }
    
    public static void createMenuItem(Japi2Session session, Japi2Menu menu) throws IOException {
        String title = session.readLine();

        Japi2MenuItem menuItem = new Japi2MenuItem(title);
        int oid = session.addObject(menuItem);  
        menu.add(menuItem);
        
        //action listener
        Japi2ActionListener actionListener = new Japi2ActionListener(session, oid);
        menuItem.setJapiListener(actionListener);
        menuItem.addActionListener(actionListener);
        
        session.log1("MENUITEM {0} (ID = {1}) in Parent Object {2}", title, oid, menu);
        session.writeInt(oid);
    }
    
    
    public static void showMenuItem(Japi2Session session, JPopupMenu menu) throws IOException {
        String title = session.readLine();

        Japi2MenuItem menuItem = new Japi2MenuItem(title);
        int oid = session.addObject(menuItem);  
        menu.add(menuItem);
        
        //action listener
        Japi2ActionListener actionListener = new Japi2ActionListener(session, oid);
        menuItem.setJapiListener(actionListener);
        menuItem.addActionListener(actionListener);
        
        session.log1("POPUPMENUITEM {0} (ID = {1}) in Parent Object {2}", title, oid, menu);
        session.writeInt(oid);
    }
    
    public static void createCheckmenuItem(Japi2Session session, Japi2Menu menu) throws IOException {
        String title = session.readLine();

        Japi2CheckMenuItem checkMenuItem = new Japi2CheckMenuItem(title);
        int oid = session.addObject(checkMenuItem);  
        menu.add(checkMenuItem);
        
        //item listener
        Japi2ItemListener itemListener = new Japi2ItemListener(session, oid);
        checkMenuItem.setJapiListener(itemListener);
        checkMenuItem.addItemListener(itemListener);
        
        session.log1("CHECKBOX-MENUITEM {0} (ID = {1}) in Parent Object {2}", title, oid, menu);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Seperator to seperate MenuItems with a horizontal
     * line.
     */
    public static void createSeperator(Japi2Session session, Japi2Menu menu) throws IOException {
        session.log1("Seperator in Parent Object {0}", menu);
        menu.addSeparator();
    }
    
    /*
     * This method creates a Panel, and adds an Item Listener to it.
     */
    public static void createPanel(Japi2Session session, Container container) throws IOException {
        int type = session.readInt();
        
        Japi2Panel panel = new Japi2Panel(type);
        int oid = session.addObject(panel);
        
        if (!(container instanceof JSplitPane)) {
            container.add(panel, BorderLayout.CENTER);
        }
        
        //item listener
        Japi2ComponentListener componentListener = new Japi2ComponentListener(session, oid, Japi2Constants.J_RESIZED);
        panel.setJapiListener(componentListener);
        panel.addComponentListener(componentListener);
        
        session.log1("PANEL type {0} (ID = {1}) in ParentObject {2}", type, oid, container);
        session.writeInt(oid);
    }

    /*
     * This method creates a TabbedPane, and adds an Item Listener to it.
     */
   public static void createTabbedPane(Japi2Session session, Container container) throws IOException {
        Japi2TabbedPane tabbedPane = new Japi2TabbedPane();
        int oid = session.addObject(tabbedPane);
        
        if (!(container instanceof JSplitPane)) {
            container.add(tabbedPane, BorderLayout.CENTER);
        }
        
        //item listener
        Japi2ComponentListener componentListener = new Japi2ComponentListener(session, oid, Japi2Constants.J_RESIZED);
        tabbedPane.setJapiListener(componentListener);
        tabbedPane.addComponentListener(componentListener);
        
        session.log1("TABBEDPANE (ID = {0}) in ParentObject {1}", oid, container);
        session.writeInt(oid);
    }

    /*
     * This method creates a Tab for a TabbedPane, and adds an Item Listener to it.
     */
    public static void createTab(Japi2Session session, Japi2TabbedPane tabbedpane) throws IOException {
        String title = session.readLine();

        Japi2Panel panel = new Japi2Panel();
        int oid = session.addObject(panel);  
        tabbedpane.addTab(title, panel);
        
        //item listener
        Japi2ComponentListener componentListener = new Japi2ComponentListener(session, oid, Japi2Constants.J_RESIZED);
        panel.setJapiListener(componentListener);
        panel.addComponentListener(componentListener);
        
        session.log1("TAB {0} (ID = {1}) in Parent Object {2}", title, oid, tabbedpane);
        session.writeInt(oid);
    }

    /*
     * This method creates a Tab with Icon for a TabbedPane, and adds an Item Listener to it.
     */
    public static void createTabWithIcon(Japi2Session session, Japi2TabbedPane tabbedpane) throws IOException {
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
        
        session.log1("TAB {0} (ID = {1}) in Parent Object {2} icon = {3}", title, oid, tabbedpane, icon);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Label, to display text or image components.
     */
    public static void createLabel(Japi2Session session, Container container) throws IOException {
        String title = session.readLine();
        
        Japi2Label label = new Japi2Label(title);
        int oid = session.addObject(label);
        container.add(label);
 
        session.log1("LABEL {0} (ID = {1}) in Parent Object {2}", title, oid, container);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Check Box, and adds an Item Listener to it.
     */
    public static void createCheckBox(Japi2Session session, Container container) throws IOException {       
        String title = session.readLine();
        
        Japi2CheckBox checkBox = new Japi2CheckBox(title);
        int oid = session.addObject(checkBox);
        container.add(checkBox);

       // item listener
        Japi2ItemListener itemListener = new Japi2ItemListener(session, oid);
        checkBox.setJapiListener(itemListener);
        checkBox.addItemListener(itemListener);
        
        session.log1("CHECKBOX {0} (ID ={1}) in Parent Object {2}", title, oid, container);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Radio Group to hold Radio Buttons. 
     */
    public static void createRadioGroup(Japi2Session session, Container container) throws IOException {       
        Japi2RadioGroup radioGroup = new Japi2RadioGroup();
        int oid = session.addObject(radioGroup);
        radioGroup.setParent(container);
        
        session.log1("RADIOGROUP (ID ={0}) in Parent Object {1}", oid, container);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Radio Button, and adds an ItemListener to it. The
     * RadioButton is added to the Radio Group directly, instead of adding 
     * it in Japi2RadioButton class
     */
    public static void createRadioButton(Japi2Session session, Japi2RadioGroup radioGroup) throws IOException {       
        String title = session.readLine();
        
        Japi2RadioButton radioButton = new Japi2RadioButton(title);
        int oid = session.addObject(radioButton);
        radioGroup.getParent().add(radioButton);
        radioGroup.add(radioButton);

        // item listener
        Japi2ItemListener itemListener = new Japi2ItemListener(session, oid);
        radioButton.setJapiListener(itemListener);
        radioButton.addItemListener(itemListener);
        
        session.log1("RADIOBUTTON {0} (ID ={1}) in Parent Object {2}", title, oid, radioGroup);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a list of elements. The varibale row matches the 
     * number of visible items in this list, not the total number of items.
     */
    public static void createList(final Japi2Session session, Container container) throws IOException {       
        int rows = session.readInt();
        
        // This might be lead to an error since 
        final Japi2List list = new Japi2List(rows);
        final int oid = session.addObject(list);
        container.add(list);
        
        // To stay compatible to the original JAPI kernel the following mouse
        // double click listener is needed. On an AWT List one can attach a
        // simple ActionListener which is fired when a list item is double
        // clicked.
        list.setActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    session.writeInt(oid, Japi2Session.TargetStream.ACTION);
                } catch (Exception ex) {
                    Japi2.getInstance().debug("Can't write list action "
                            + "event: {0}", ex);
                }
            }
        });

        session.log1("LIST (ID ={0}) in Parent Object {1}", oid, container);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Choice field, to choose from a drop-down list.
     */
    public static void createChoice(Japi2Session session, Container container) throws IOException {       
        Japi2Choice choice = new Japi2Choice();
        int oid = session.addObject(choice);
        container.add(choice);

        // item listener
        Japi2ItemListener itemListener = new Japi2ItemListener(session, oid);
        choice.setJapiListener(itemListener);
        choice.addItemListener(itemListener);
        
        session.log1("RADIOBUTTON (ID ={0}) in Parent Object {1}", oid, choice);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Japi2Meter.
     */
    public static void createMeter(Japi2Session session, Container c) 
            throws IOException {
        session.log1("Meter in parent object {0}", c);
        Japi2Meter meter = new Japi2Meter(session.readLine());
        c.add(meter);
        int oid = session.addObject(meter);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Japi2SevenSegment object.
     */
    public static void createSevenSegment(Japi2Session session, Container c) 
            throws IOException {
        int r = session.readByte(), g = session.readByte(), b = session.readByte();
        Color theColor = new Color(r, g, b);
        session.log1("SevenSegment in parent object {0} with color {1} (r={2}, "
                + "g={3}, b={4})", c, theColor, r, g, b);
        Japi2SevenSegment s = new Japi2SevenSegment(theColor);
        c.add(s);
        int oid = session.addObject(s);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a Japi2Led object.
     */
    public static void createLed(Japi2Session session, Container c) 
            throws IOException {
        int form = session.readInt();
        int r = session.readByte(), g = session.readByte(), b = session.readByte();
        Color theColor = new Color(r, g, b);
        session.log1("LED in parent object {0} with color {1} (r={2}, "
                + "g={3}, b={4}) and form {5}", c, theColor, r, g, b, form);
        Japi2Led led = new Japi2Led(theColor, form);
        c.add(led);
        int oid = session.addObject(led);
        session.writeInt(oid);
    }
    
    /*
     * This method creates a JProgressBar object.
     */
    public static void createProgressBar(Japi2Session session, Container c) 
            throws IOException {
        // Create the progress bar
        int orientation = session.readInt();
        session.log1("ProgressBar in parent object {0} with orientation {1}", 
                c, orientation);
        JProgressBar bar;
        if (orientation == Japi2Constants.J_HORIZONTAL) {
            bar = new JProgressBar(SwingConstants.HORIZONTAL);
        } else { // Japi2Constants.J_VERTICAL
            bar = new JProgressBar(SwingConstants.VERTICAL);
        }
        c.add(bar);
        int oid = session.addObject(bar);
        
        // Add change listener to display the value as string in the middle
        // of the progress bar. By default the percent sign is appended, but
        // that is not needed for this type of progress bar
        bar.setStringPainted(true);
        bar.addChangeListener(new ChangeListener() {

            @Override
            public void stateChanged(ChangeEvent e) {
                JProgressBar bar = (JProgressBar) e.getSource();
                bar.setString(String.valueOf(bar.getValue()));
            }
        });
        
        session.writeInt(oid);
    }    
    
    public static void createPrinter(Japi2Session session, Japi2Frame frame) 
            throws IOException {
        session.log1("Printer: {0}", frame);
        try {
            Japi2PrintJob job = new Japi2PrintJob();
            int oid = session.addObject(job);
            session.writeInt(oid);
        } catch (UnsupportedOperationException ex) {
            session.log1("Printer not supported!");
            session.writeInt(-1);
        }
    }
    
    public static void createSplitPane(Japi2Session session, Container c) throws IOException {
        int orient = session.readInt();
        int initPos = session.readInt();
        session.log1("SplitPane in parent object {0} with orientation {1} and "
                + "divider location at {2}", c, orient, initPos);
        
        if (orient != Japi2Constants.J_HORIZONTAL &&
                orient != Japi2Constants.J_VERTICAL) {
            throw new UnsupportedOperationException("SplitPane can only be horizontal or vertical.");
        }
        
        JSplitPane splitPane = new JSplitPane(
                orient == Japi2Constants.J_HORIZONTAL ? 
                        JSplitPane.HORIZONTAL_SPLIT :
                        JSplitPane.VERTICAL_SPLIT
        );
        splitPane.setOneTouchExpandable(false);
        splitPane.setDividerLocation(initPos);
        c.add(splitPane);
        
        int oid = session.addObject(splitPane);
        session.writeInt(oid);
    }
    
}