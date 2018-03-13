package de.japi.calls;

import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import de.japi.components.AbstractJapi2ValueComponent;
import de.japi.components.Japi2Button;
import de.japi.components.Japi2CheckBox;
import de.japi.components.Japi2CheckMenuItem;
import de.japi.components.Japi2Choice;
import de.japi.components.Japi2Dialog;
import de.japi.components.Japi2Frame;
import de.japi.components.Japi2Label;
import de.japi.components.Japi2Led;
import de.japi.components.Japi2List;
import de.japi.components.Japi2Menu;
import de.japi.components.Japi2MenuBar;
import de.japi.components.Japi2MenuItem;
import de.japi.components.Japi2Meter;
import de.japi.components.Japi2PrintJob;
import de.japi.components.Japi2RadioButton;
import de.japi.components.Japi2RadioGroup;
import de.japi.components.Japi2ScrollPane;
import de.japi.components.Japi2TextArea;
import de.japi.components.Japi2TextField;
import de.japi.components.listeners.Japi2FocusListener;
import de.japi.components.listeners.Japi2KeyListener;
import de.japi.components.listeners.Japi2MouseListener;
import de.japi.components.listeners.Japi2MouseMotionListener;
import java.awt.Adjustable;
import java.awt.Component;
import java.awt.Container;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.Insets;
import java.awt.LayoutManager;
import java.awt.Point;
import java.awt.Toolkit;
import java.awt.event.InputEvent;
import java.io.IOException;
import javax.swing.ButtonGroup;
import javax.swing.DefaultButtonModel;
import javax.swing.JComponent;
import javax.swing.JScrollPane;
import javax.swing.text.JTextComponent;

/**
 * This class contains all JAPI question calls.
 */
public class QuestionCalls {
        
    public static void getChar(Japi2Session session, Japi2KeyListener keyListener) throws IOException {
        session.log2("Get key char from {0}", keyListener);
        session.writeInt(keyListener.getLastCharacter());
    }
    
    public static void getKeyCode(Japi2Session session, Japi2KeyListener keyListener) throws IOException {
        session.log2("Get key code from {0}", keyListener);
        session.writeInt(keyListener.getLastKeyCode());
    }
    
    public static void hasFocus(Japi2Session session, Japi2FocusListener focusListener) throws IOException {
        session.log2("Focus on {0}?", focusListener);
        session.writeBoolean(focusListener.hasFocus());
    }
    
    /*
     * The following overloaded getState-methods get the state of JChekBoxMenuItems, 
     * Japi2CheckBox, Japi2RadioButton and Japi2Led components.
     * This means they return 1 if the the components are checked, otherwise 0.
     */
    
    public static void getState(Japi2Session session, Japi2CheckMenuItem checkBoxMenuItem) throws IOException {
        session.log2("Get state");
        int state = Japi2Constants.J_FALSE;
        if(checkBoxMenuItem.getState()) 
            state = Japi2Constants.J_TRUE;
        session.writeInt(state);
    }
    
    public static void getState(Japi2Session session, Japi2CheckBox checkBox) throws IOException {
        session.log2("Get state");
        int state = Japi2Constants.J_FALSE;
        if(checkBox.isSelected()) 
            state = Japi2Constants.J_TRUE;
        session.writeInt(state);
    }
    
    public static void getState(Japi2Session session, Japi2RadioButton radioButton) throws IOException {
        session.log2("Get state");
        int state = Japi2Constants.J_FALSE;
        if(radioButton.isSelected()) 
            state = Japi2Constants.J_TRUE;
        session.writeInt(state);
    }
    
    public static void getState(Japi2Session session, Japi2Led led) throws IOException {
        session.log2("Get state");
        int state = Japi2Constants.J_FALSE;
        if(led.isOn()) 
            state = Japi2Constants.J_TRUE;
        session.writeInt(state);
    }    
    
    public static void getInsets(Japi2Session session, Container c) throws IOException {
        int pos = session.readInt();
        session.log2("Get insets for position {0}", pos);
        Insets insets = c.getInsets();
        if (c instanceof Japi2Frame) {
            insets = ((Japi2Frame) c).getInsetsReal(); // Due to missing insets
            // in SWING
        }
        session.log2("Insets: " + insets.toString());
        if (pos == Japi2Constants.J_TOP) {
            session.writeInt(insets.top);
        } else if (pos == Japi2Constants.J_LEFT) {
            session.writeInt(insets.left);
        } else if (pos == Japi2Constants.J_RIGHT) {
            session.writeInt(insets.right);
        } else if (pos == Japi2Constants.J_BOTTOM) {
            session.writeInt(insets.bottom);
        } else {
            throw new UnsupportedOperationException(
                    "Insets postion " + pos + " unknwon"
            );
        }
    }
    
    /*
     * Methods to send the dimensions of a component.
     */
    
    public static void getWidth(Japi2Session session, Component c) throws IOException {
        session.log2("Get width of object {0}", c);
        session.writeInt(c.getSize().width);
    }    
    
    public static void getWidth(Japi2Session session, Image i) throws IOException {
        session.log2("Get width of object {0}", i);
        session.writeInt(i.getWidth(null));
    } 
    
    public static void getWidth(Japi2Session session, Japi2PrintJob pj) throws IOException {
        session.log2("Get width of object {0}", pj);
        session.writeInt(pj.getPageDimension().width);
    } 
    
    public static void getHeight(Japi2Session session, Component c) throws IOException {
        session.log2("Get height of object {0}", c);
        session.writeInt(c.getSize().height);
    } 
    
    public static void getHeight(Japi2Session session, Image i) throws IOException {
        session.log2("Get height of object {0}", i);
        session.writeInt(i.getHeight(null));
    } 
    
    public static void getHeight(Japi2Session session, Japi2PrintJob pj) throws IOException {
        session.log2("Get height of object {0}", pj);
        session.writeInt(pj.getPageDimension().height);
    } 
     
    /*
     * The following two methods get the mouseX-Position.
     */
    
    public static void getMouseX(Japi2Session session, Japi2MouseListener mouseListener) throws IOException {
        int xpos = -1;
        session.log2("Get Mouse X position");
        xpos = mouseListener.getX();
        session.writeInt(xpos);
    }
    
    public static void getMouseX(Japi2Session session, Japi2MouseMotionListener mouseMotionListener) throws IOException {
        int xpos = -1;
        session.log2("Get Mouse X position");
        xpos = mouseMotionListener.getX();
        session.writeInt(xpos);
    }
    
    /*
     * The following two methods get the mouseY-Position.
     */
    public static void getMouseY(Japi2Session session, Japi2MouseListener mouseListener) throws IOException {
        int ypos = -1;
        session.log2("Get Mouse Y position");
        ypos = mouseListener.getY();
        session.writeInt(ypos);
    }
    
    public static void getMouseY(Japi2Session session, Japi2MouseMotionListener mouseMotionListener) throws IOException {
        int ypos = -1;
        session.log2("Get Mouse Y position");
        ypos = mouseMotionListener.getY();
        session.writeInt(ypos);
    }
    
    /*
     * The following two methods get the mouse Button.
     */
    
    public static void getMouseButton(Japi2Session session, Japi2MouseListener mouseListener) throws IOException {
        int b = -1;
        session.log2("Get Mouse Button");
        b = mouseListener.getButton();
        if(b == -1) session.writeInt(-1);
        if(b==InputEvent.BUTTON1_MASK) session.writeInt(Japi2Constants.J_LEFT);
        if(b==InputEvent.BUTTON2_MASK) session.writeInt(Japi2Constants.J_CENTER);
        if(b==InputEvent.BUTTON3_MASK) session.writeInt(Japi2Constants.J_RIGHT);
    }

    public static void getMouseButton(Japi2Session session, Japi2MouseMotionListener mouseMotionListener) throws IOException {
        int b = -1;
        session.log2("Get Mouse Button");
        b = mouseMotionListener.getButton();
        if(b == -1) session.writeInt(-1);
        if(b==InputEvent.BUTTON1_MASK) session.writeInt(Japi2Constants.J_LEFT);
        if(b==InputEvent.BUTTON2_MASK) session.writeInt(Japi2Constants.J_CENTER);
        if(b==InputEvent.BUTTON3_MASK) session.writeInt(Japi2Constants.J_RIGHT);
    }
    
    /*
     * The following method returns the selected text in a text component and 
     * in addition it returns the selected Text as a sequence of bytes. 
     */
    public static void getSelText(Japi2Session session, JTextComponent textComp) throws IOException {
        session.log2("Get Selected Text {0}", textComp);
        byte[] buffer = new byte[0];
        if (textComp.getSelectedText() != null) {
            buffer = textComp.getSelectedText().getBytes();
        }
        session.writeInt(buffer.length);
        session.writeBytes(buffer);
    }
    
    /*
     * The following method returns the position of the cursor where text
     * will be inserted. 
     */
    public static void getCurPos(Japi2Session session, JTextComponent textComp) throws IOException {
        session.log2("Get Cursor Position {0}", textComp);
        session.writeInt(textComp.getCaretPosition());
    }
    
    /*
     * The following method calculates the position of a component and sends 
     * back its x value. 
     */
    public static void getXPos(Japi2Session session, Component component) throws IOException {
        Point p = component.getLocation();
        session.log2("Get X Position");
        session.log2("Location at: {0} : {1}", p.x, p.y);
        session.writeInt(p.x);
    }
    
    /*
     * The following method calculates the position of a component and sends 
     * back its y value. 
     */
    public static void getYPos(Japi2Session session, Component component) throws IOException {
        Point p = component.getLocation();
        session.log2("Get Y Position");
        session.log2("Location at: {0} : {1}", p.x, p.y);
        session.writeInt(p.y);
    }
    
    /*
     * The following two methods give back the current value of Adjustable and 
     * ValueComponent objects.
     */
    
    public static void getValue(Japi2Session session, Adjustable adjustable) throws IOException {
        session.log2("Get Value ? {0}", adjustable);
        session.writeInt(adjustable.getValue());
    }
    
    public static void getValue(Japi2Session session, AbstractJapi2ValueComponent valueComponent) throws IOException {
        session.log2("Get Value ? {0}", valueComponent);
        session.writeInt(valueComponent.getValue());
    }
    
    /*
     * This method returns the current height of the viewport of the scrollPane.
     */
    public static void viewHeight(Japi2Session session, Japi2ScrollPane scrollPane) throws IOException {
        session.log2("Get Viewport Height {0}", scrollPane);
        session.writeInt(scrollPane.getViewport().getHeight());
    }
    
    /*
     * This method returns the current width of the viewport of the scrollPane.
     */
    public static void viewWidth(Japi2Session session, JScrollPane scrollPane) throws IOException {
        session.log2("Get Viewport Width {0}", scrollPane);
        session.writeInt(scrollPane.getViewport().getWidth());
    }
    
    /*
     * This methods gets the width of a given String of a Component, Image or 
     * PrintJob. The default font is 12pt Dialog. 
     */
    
    public static void stringWidth(Japi2Session session, Component component) throws IOException {
        String str = session.readLine();
        session.log2("Get String Width in Object {0}, STRING = '{1}'", component, str);
       
        if (component.getFont() == null)
            component.setFont(new Font("Dialog", Font.PLAIN, 12));
            
        session.writeInt(component.getFontMetrics(component.getFont()).stringWidth(str)); 
    }
    
    public static void stringWidth(Japi2Session session, Image image) throws IOException {
        String str = session.readLine();
        session.log2("Get String Width in Object {0}, STRING = '{1}'", image, str);
       
        if (image.getGraphics().getFont() == null)
            image.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
       
        session.writeInt(image.getGraphics().getFontMetrics(image.getGraphics().getFont()).stringWidth(str)); 
    }
    
    public static void stringWidth(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        String str = session.readLine();
        session.log2("Get String Width in Object {0}, STRING = '{1}'", printJob, str);
       
        if (printJob.getGraphics().getFont() == null)
            printJob.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
       
        session.writeInt(printJob.getGraphics().getFontMetrics(printJob.getGraphics().getFont()).stringWidth(str)); 
    }
    
    /*
     * These methods get the height of a font for Components, Images and PrintJobs.
     * If no font is defined, the standard 12pt Dialog font is chosen to 
     * messure the height.
     */
    
    public static void fontHeight(Japi2Session session, Component component) throws IOException {
        session.log2("Get Font Height in Object: {0}", component);
        if (component.getFont() == null)
            component.setFont(new Font("Dialog", Font.PLAIN, 12));
       
        session.writeInt(component.getFontMetrics(component.getFont()).getHeight());
    }
    
    public static void fontHeight(Japi2Session session, Image image) throws IOException {
        session.log2("Get Font Height in Object: {0}", image);
        if (image.getGraphics().getFont() == null)
            image.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
       
        session.writeInt(image.getGraphics().getFontMetrics(image.getGraphics().getFont()).getHeight());
    }
    
    public static void fontHeight(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        session.log2("Get Font Height in Object: {0}", printJob);
        if (printJob.getGraphics().getFont() == null)
            printJob.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
       
        session.writeInt(printJob.getGraphics().getFontMetrics(printJob.getGraphics().getFont()).getHeight());
    }
    
    /*
     * These methods get the ascent of a font for Components, Images and PrintJobs.
     * If no font is defined, the standard 12pt Dialog font is chosen to 
     * messure the ascent. The font ascent is the distance from the font's 
     * baseline to the top of most alphanumeric characters.
     */
    
    public static void fontAscent(Japi2Session session, Component component) throws IOException {
        session.log2("Get Position");
        if (component.getFont() == null)
            component.setFont(new Font("Dialog", Font.PLAIN, 12));
       
        session.writeInt(component.getFontMetrics(component.getFont()).getAscent());
    }
    
    public static void fontAscent(Japi2Session session, Image image) throws IOException {
        session.log2("Get Position");
        if (image.getGraphics().getFont() == null)
            image.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
       
        session.writeInt(image.getGraphics().getFontMetrics(image.getGraphics().getFont()).getAscent());
    }
    
    public static void fontAscent(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        session.log2("Get Position");
        if (printJob.getGraphics().getFont() == null)
            printJob.getGraphics().setFont(new Font("Dialog", Font.PLAIN, 12));
       
        session.writeInt(printJob.getGraphics().getFontMetrics(printJob.getGraphics().getFont()).getAscent());
    }
    
    /*
     * This method gives back the actual width of the content of a container
     * by subtracting the width of left and right border from the total width
     * of the container.
     */
    public static void getInWidth(Japi2Session session, Container container) throws IOException {
        session.log2("Get inset width of Object {0}", container);
        session.writeInt(container.getSize().width - container.getInsets().left - container.getInsets().right);
    }
    
    /*
     * This method gives back the actual height of the content of a container
     * by subtracting the height of top and left border from the total height
     * of the container.
     */
    public static void getInHeight(Japi2Session session, Container container) throws IOException {
        session.log2("Get inset height of Object {0}", container);
        session.writeInt(container.getSize().height - container.getInsets().top - container.getInsets().bottom);
    }
    
    /*
     * These methods return true if a Frame or Dialog is resizable, otherwise
     * false.
     */
    
    public static void isResizable(Japi2Session session, Japi2Frame frame) throws IOException {
        session.log2("Is {0} resizable?", frame);
        session.writeInt(frame.isResizable() ? Japi2Constants.J_TRUE : Japi2Constants.J_FALSE);
    } 
    
    public static void isResizable(Japi2Session session, Japi2Dialog dialog) throws IOException {
        session.log2("Is {0} resizable?", dialog);
        session.writeInt(dialog.isResizable() ? Japi2Constants.J_TRUE : Japi2Constants.J_FALSE);
    } 
    
    /*
     * This method returns the width of the Screen. 
     */ 
    public static void getScreenWidth(Japi2Session session) throws IOException {
        session.log2("Get Screen Width");
        session.writeInt(Toolkit.getDefaultToolkit().getScreenSize().width);
    } 
    
    /*
     * This method returns the height of the Screen. 
     */ 
    public static void getScreenHeight(Japi2Session session) throws IOException {
        session.log2("Get Screen Height");
        session.writeInt(Toolkit.getDefaultToolkit().getScreenSize().height);
    } 
    
    /*
     * These methods return index of the currently slected item in a Japi2List or
     * Japi2ChoiceBox.
     */ 
    public static void getSelect(Japi2Session session, Japi2List list) throws IOException {
        session.log2("Get Selected Index");
        session.writeInt(list.getSelectedIndex());
    } 
    
    public static void getSelect(Japi2Session session, Japi2Choice choice) throws IOException {
        session.log2("Get Selected Index");
        session.writeInt(choice.getSelectedIndex());
    } 
    
    /*
     * This methods returns true if a given index is selected in a Japi2List, 
     * false otherwise.
     */ 
    
    public static void isSelect(Japi2Session session, Japi2List list) throws IOException {
        int index = session.readInt();
        session.log2("Is {0} Selected?", index);
        session.writeInt(list.isSelectedIndex(index) ? Japi2Constants.J_TRUE : Japi2Constants.J_FALSE);
    } 
    
    /*
     * These methods return the rows of a Japi2TextArea, Japi2TextField, or GridLayout.
     */
    
    public static void getRows(Japi2Session session, Japi2TextArea textArea) throws IOException {
        session.log2("Get Rows.");
        session.writeInt(textArea.getRows());
    }
    
    public static void getRows(Japi2Session session, Japi2List list) throws IOException {
        session.log2("Get Rows.");
        session.writeInt(list.getRowCount());
    }
    
    public static void getRows(Japi2Session session, GridLayout layout) throws IOException {
        session.log2("Get Rows.");
        session.writeInt(layout.getRows());
    }
    
    /*
     * These methods return the columns of a Japi2TextArea, Japi2TextField, or GridLayout.
     */
    
    public static void getColumns(Japi2Session session, Japi2TextArea textArea) throws IOException {
        session.log2("Get Columns.");
        session.writeInt(textArea.getColumns());
    }
    
    public static void getColumns(Japi2Session session, Japi2TextField textField) throws IOException {
        session.log2("Get Columns.");
        session.writeInt(textField.getColumns());
    }
    
    public static void getColumns(Japi2Session session, GridLayout layout) throws IOException {
        session.log2("Get Columns.");
        session.writeInt(layout.getColumns());
    }
     
    /*
     * These methods return the item of a List, ChoiceBox, Menu or MenuBar at 
     * the index number.
     */
    
    public static void getItem(Japi2Session session, Japi2List list) throws IOException {
        int number = session.readInt();
        session.log2("Get Item number {0} of {1}", number, list);
        String content = (String) list.getElement(number);
        
        session.writeInt(content.length());
        byte[] buf = content.getBytes();
        session.writeBytes(buf);
    }
    
    public static void getItem(Japi2Session session, Japi2Choice choice) throws IOException {
        int number = session.readInt();
        session.log2("Get Item number {0} of {1}", number, choice);
        String content = (String) choice.getItemAt(number);
        
        session.writeInt(content.length());
        byte[] buf = content.getBytes();
        session.writeBytes(buf);
    }
    
    public static void getItem(Japi2Session session, Japi2Menu menu) throws IOException {
        int number = session.readInt();
        session.log2("Get Item number {0} of {1}", number, menu);
        String content = menu.getItem(number).getText();
        
        session.writeInt(content.length());
        byte[] buf = content.getBytes();
        session.writeBytes(buf);
    }
    
    public static void getItem(Japi2Session session, Japi2MenuBar menuBar) throws IOException {
        int number = session.readInt();
        session.log2("Get Item number {0} of {1}", number, menuBar);
        String content = menuBar.getMenu(number).getText();
        
        session.writeInt(content.length());
        byte[] buf = content.getBytes();
        session.writeBytes(buf);
    }
    
    /*
     * These methods return the number of elements/menus in a List, Menu, 
     * ChoiceBox or MenuBars.
     */
    
    public static void getItemCount(Japi2Session session, Japi2List list) throws IOException {
        session.log2("Get Item count of {0}", list);
        int retVal = list.getRowCount();
        session.writeInt(retVal);
    }
    
    public static void getItemCount(Japi2Session session, Japi2Choice choice) throws IOException {
        session.log2("Get Item count of {0}", choice);
        int retVal = choice.getItemCount();
        session.writeInt(retVal);
    }
    
    public static void getItemCount(Japi2Session session, Japi2Menu menu) throws IOException {
        session.log2("Get Item count of {0}", menu);
        int retVal = menu.getItemCount();
        session.writeInt(retVal);
    }
    
    public static void getItemCount(Japi2Session session, Japi2MenuBar menuBar) throws IOException {
        session.log2("Get Item count of {0}", menuBar);
        int retVal = menuBar.getMenuCount();
        session.writeInt(retVal);
    }
   
    /*
     * This method returns the danger value of a Japi2Meter Object.
     */
    public static void getDanger(Japi2Session session, Japi2Meter meter) throws IOException {
       session.log2("Get Danger? {0}", meter);
       session.writeInt(meter.getDangerValue());
    }
    
    /*
     * This method passes the text of a {@link JTextComponent} object to the
     * {@link writeTextHelper} method. It was designed with the classes
     * {@link Japi2TextArea} and {@link Japi2TextField} in mind.
     */
    public static void getText(Japi2Session session, JTextComponent t) throws IOException {
        session.log2("Get text of JTextComponent {0}", t);
        // t is of class Japi2TextArea or Japi2TextField
        String content = t.getText();
        writeTextHelper(session,content);
    }
    
    /*
     * This method transfers the title of a {@link Japi2Frame} object to the
     * {@link writeTextHelper} method.
     */
    public static void getText(Japi2Session session, Japi2Frame t) throws IOException {
        session.log2("Get title of Japi2Frame {0}", t);
        String content = t.getTitle();
        writeTextHelper(session,content);
    }
    
    /*
     * This method transfers the title of a {@link Japi2Dialog} object to the
     * {@link writeTextHelper} method.
     */
    public static void getText(Japi2Session session, Japi2Dialog d) throws IOException {
        session.log2("Get title of Japi2Dialog {0}", d);
        String content = d.getTitle();
        writeTextHelper(session,content);
    }
    
    /*
     * This method transfers the text of a {@link Japi2Button} object to the
     * {@link writeTextHelper} method.
     */
    public static void getText(Japi2Session session, Japi2Button b) throws IOException {
        session.log2("Get text of Japi2Button {0}", b);
        String content = b.getText();
        writeTextHelper(session,content);
    }
    
    /*
     * This method transfers the text of a {@link Japi2Label} object to the
     * {@link writeTextHelper} method.
     */
    public static void getText(Japi2Session session, Japi2Label l) throws IOException {
        session.log2("Get text of Japi2Label {0}", l);
        String content = l.getText();
        writeTextHelper(session,content);
    }
    
    /*
     * This method transfers the text of a {@link Japi2Menu} object to the
     * {@link writeTextHelper} method.
     */
    public static void getText(Japi2Session session, Japi2Menu m) throws IOException {
        session.log2("Get text of Japi2Menu {0}", m);
        String content = m.getText();
        writeTextHelper(session,content);
    }
    
    /*
     * This method transfers the text of a {@link Japi2MenuItem} object to the
     * {@link writeTextHelper} method.
     */
    public static void getText(Japi2Session session, Japi2MenuItem m) throws IOException {
        session.log2("Get text of Japi2MenuItem {0}", m);
        String content = m.getText();
        writeTextHelper(session,content);
    }
    
    /*
     * This method transfers the text of a {@link Japi2CheckMenuItem} object to the
     * {@link writeTextHelper} method.
     */
    public static void getText(Japi2Session session, Japi2CheckMenuItem c) throws IOException {
        session.log2("Get text of Japi2CheckMenuItem {0}", c);
        String content = c.getText();
        writeTextHelper(session,content);
    }
    
    /*
     * This method writes the length of the content String and its bytes into
     * the session.
     */
    private static void writeTextHelper(Japi2Session session, String content) throws IOException {
        session.log2("Get label or text READY");
        session.writeInt(content.length());
        session.writeBytes(content.getBytes());
    }
    
    /*
     * Writes the length of the text of a {@link JTextComponent} object into the
     * session. This method was designed with the classes {@link Japi2TextArea}
     * and {@link Japi2TextField} in mind.
     */
    public static void getLength(Japi2Session session, JTextComponent t) throws IOException {
        session.log2("Get length");
        session.writeInt(t.getText().length());
    }
    
    /*
     * Writes the length of the title of a {@link Japi2Frame} object into the
     * session.
     */
    public static void getLength(Japi2Session session, Japi2Frame f) throws IOException {
        session.log2("Get length");
        session.writeInt(f.getTitle().length());
    }
    
    /*
     * Writes the length of the text of a {@link Japi2Button} object into the
     * session.
     */
    public static void getLength(Japi2Session session, Japi2Button b) throws IOException {
        session.log2("Get length");
        session.writeInt(b.getText().length());
    }
    
    /*
     * Writes the length of the text of a {@link Japi2Menu} object into the
     * session.
     */
    public static void getLength(Japi2Session session, Japi2Menu m) throws IOException {
        session.log2("Get length");
        session.writeInt(m.getText().length());
    }
    
    /*
     * Writes the length of the text of a {@link Japi2MenuItem} object into the
     * session.
     */
    public static void getLength(Japi2Session session, Japi2MenuItem m) throws IOException {
        session.log2("Get length");
        session.writeInt(m.getText().length());
    }
    
    /*
     * Writes the length of the text of a {@link Japi2CheckMenuItem} object into the
     * session.
     */
    public static void getLength(Japi2Session session, Japi2CheckMenuItem c) throws IOException {
        session.log2("Get length");
        session.writeInt(c.getText().length());
    }
    
    /*
     * Writes the selection start of a {@link JTextComponent} object into the
     * session. This method was designed with the classes {@link Japi2TextArea}
     * and {@link Japi2TextField} in mind.
     */
    public static void getSelectionStart(Japi2Session session, JTextComponent t) throws IOException {
        session.log2("Get selection start of object {0}", t);
        session.writeInt(t.getSelectionStart());
    }
    
    /*
     * Writes the selection end of a {@link JTextComponent} object into the
     * session. This method was designed with the classes {@link Japi2TextArea}
     * and {@link Japi2TextField} in mind. 
     */
    public static void getSelectionEnd(Japi2Session session, JTextComponent t) throws IOException {
        session.log2("Get selection end of object {0}", t);
        session.writeInt(t.getSelectionEnd());
    }
    
    /*
     * Writes the Inset Width of a container object into the session.
     */
    public static void getInsetWidth(Japi2Session session, Container c) throws IOException {
        session.log1("Get Inset width of object {0}", c);
        
        session.writeInt(c.getSize().width - c.getInsets().left - c.getInsets().right);   
    }
    
    /*
     * Writes whether a Component object is visible or not into the session.
     */
    public static void isVisible(Japi2Session session, Component c) throws IOException {
        session.log2("Is visible {0}", c);
        session.writeInt(c.isVisible() ? Japi2Constants.J_TRUE : Japi2Constants.J_FALSE);
    }
    
    /*
     * These methods return the id of the parent of RadioButtons, Components,
     * MenuComponents or RadioGroups.
     */
    
    public static void getParentId(Japi2Session session, Japi2RadioButton radioButton) throws IOException {
        session.log2("Get Parent");
        Object c = ((DefaultButtonModel)radioButton.getModel()).getGroup();
        session.writeInt(session.getIdByObject(c));
    }
    
    public static void getParentId(Japi2Session session, Component component) throws IOException {
        session.log2("Get Parent");
        Object c = component.getParent();
        session.writeInt(session.getIdByObject(c));
    }
    
    public static void getParentId(Japi2Session session, JComponent menuComponent) throws IOException {
        session.log2("Get Parent");
        Object c = menuComponent.getParent();
        session.writeInt(session.getIdByObject(c));
    }
    
    public static void getParentId(Japi2Session session, Japi2RadioGroup radioGroup) throws IOException {
        session.log2("Get Parent");
        Object c = radioGroup.getParent();
        session.writeInt(session.getIdByObject(c));
    }
    
    /*
     * Writes the layout id of a container object back to the stream.
     */
    public static void getLayoutId(Japi2Session session, Container container) throws IOException {
        session.log2("Get Layout Manager of {0}", container);
        LayoutManager layout = container.getLayout();
        if(layout == null) {
            session.writeInt(-1);
        } else {
            session.writeInt(session.getIdByObject(layout));
        }   
    }
    
    /*
     * Returns true if the received value p is parent of the Object, otherwise false.
     */
    public static void isParent(Japi2Session session, Japi2RadioButton radioButton) throws IOException {
        int p = session.readInt();
        session.log2("Is {0} parent of {1}?", p, radioButton);
        if (((DefaultButtonModel)radioButton.getModel()).getGroup() == session.getObjectById(p, ButtonGroup.class)) {
            session.writeInt(Japi2Constants.J_TRUE);     
        } else {
            session.writeInt(Japi2Constants.J_FALSE);     
        }
    }
    
    public static void isParent(Japi2Session session, Component component) throws IOException {
        int p = session.readInt();
        session.log2("Is {0} parent of {1}?", p, component);
        if (component.getParent() == session.getObjectById(p, Component.class)) {
            session.writeInt(Japi2Constants.J_TRUE);     
        } else {
            session.writeInt(Japi2Constants.J_FALSE);     
        }
    }
    
    public static void isParent(Japi2Session session, JComponent menuComponent) throws IOException {
        int p = session.readInt();
        session.log2("Is {0} parent of {1}?", p, menuComponent);
        if (menuComponent.getParent() == session.getObjectById(p, Component.class)) {
            session.writeInt(Japi2Constants.J_TRUE);     
        } else {
            session.writeInt(Japi2Constants.J_FALSE);     
        }
    }
    
    public static void isParent(Japi2Session session, Japi2RadioGroup radioGroup) throws IOException {
        int p = session.readInt();
        session.log2("Is {0} parent of {1}?", p, radioGroup);
        if (radioGroup.getParent() == session.getObjectById(p, Component.class)) {
            session.writeInt(Japi2Constants.J_TRUE);     
        } else {
            session.writeInt(Japi2Constants.J_FALSE);     
        }
    }
    
}