package de.japi.components.listeners;

import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import java.awt.event.InputEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

/**
 * JAPI2 wrapper for an {@link MouseListener}.
 */
public class Japi2MouseListener extends AbstractJapi2Listener implements MouseListener {

    /**
     * State values of the mouse pointer.
     */
    private int x, y, button;
    
    /**
     * Constructs a new JAPI specific mouse listener. 
     * 
     * <p style="color:red;">
     * Please note that the object id is set to <code>-1</code> by this 
     * constructor. It must be manually set to a valid id (greater -1) through 
     * {@link AbstractJapi2Listener#setId(int)}. Otherwise nothing will happen
     * and an error is logged if debugging is enabled.
     * </p>
     * @param session the session object to operate on.
     * @param type a type argument for the listener to listen on.
     */
    public Japi2MouseListener(Japi2Session session, int type) {
        super(session, -1, type);
        button = InputEvent.BUTTON1_MASK;
    }
    
    /**
     * Returns the x position of the most recent mouse event.
     * 
     * @return the x position on the screen.
     */
    public int getX() {
        return x;
    }
    
    /**
     * Returns the y position of the most recent mouse event.
     * 
     * @return the y position on the screen.
     */
    public int getY() {
        return y;
    }
    
    /**
     * Returns the pressed button of the most recent mouse event.
     * 
     * @return the pressed button mask.
     */
    public int getButton() {
        return button;
    }
    
    private void fill(MouseEvent e) {
        x = e.getX();
        y = e.getY();
        button = e.getModifiers();   
    }
    
    @Override
    public void mousePressed(MouseEvent e) {
        if (isType(Japi2Constants.J_PRESSED)) {
            session.log1("Mouse pressed event");
            fill(e);
            trigger();
        }
    }

    @Override
    public void mouseReleased(MouseEvent e) {
        if (isType(Japi2Constants.J_RELEASED)) {
            session.log1("Mouse released event");
            fill(e);
            trigger();
        }
    }

    @Override
    public void mouseEntered(MouseEvent e) {
        if (isType(Japi2Constants.J_ENTERERD)) {
            session.log1("Mouse entered event");
            fill(e);
            trigger();
        }
    }

    @Override
    public void mouseExited(MouseEvent e) {
        if (isType(Japi2Constants.J_EXITED)) {
            session.log1("Mouse exited event");
            fill(e);
            trigger();
        }
    }
    
    @Override
    public void mouseClicked(MouseEvent e) {
        if (isType(Japi2Constants.J_DOUBLECLICK) && e.getClickCount() == 2) {
            session.log1("Mouse double click event");
            fill(e);
            trigger();
        }
    }

    @Override
    public String toString() {
        String typeName;
        switch (super.type) {
            case Japi2Constants.J_PRESSED:
                typeName = "J_PRESSED";
                break;
            case Japi2Constants.J_RELEASED:
                typeName = "J_RELEASED";
                break;
            case Japi2Constants.J_ENTERERD:
                typeName = "J_ENTERERD";
                break;    
            case Japi2Constants.J_EXITED:
                typeName = "J_EXITED";
                break;    
            case Japi2Constants.J_DOUBLECLICK:
                typeName = "J_DOUBLECLICK";
                break;    
            default:
                typeName = "Unknown type!";
        }
        return "MouseListener[for=" + id + ",type=" + typeName + ",x=" + x 
                + ",y=" + y + ",button=" + button + "]";
    }

}
