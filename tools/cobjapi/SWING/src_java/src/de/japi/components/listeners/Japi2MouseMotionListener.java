package de.japi.components.listeners;

import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
import java.awt.event.WindowListener;

/**
 * JAPI2 wrapper for an {@link MouseMotionListener}.
 */
public class Japi2MouseMotionListener extends AbstractJapi2Listener implements MouseMotionListener {

    /**
     * State values of the mouse pointer.
     */
    private int x, y, button;
    
    /**
     * Creates a new {@link WindowListener} for a specific event type.
     * 
     * <p style="color:red;">
     * Please note that the object id is set to <code>-1</code> by this 
     * constructor. It must be manually set to a valid id (> -1) through 
     * {@link AbstractJapi2Listener#setId(int)}. Otherwise nothing will happen
     * and an error is logged if debugging is enabled.
     * </p>
     * 
     * @param session the session object to operate on.
     * @param type a type argument for the listener to listen on.
     */
    public Japi2MouseMotionListener(Japi2Session session, int type) {
        super(session, -1, type);
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
    
    /**
     * Fills the internal data fields.
     * 
     * @param e Event to grab the data from.
     */
    private void fill(MouseEvent e) {
        x = e.getX();
        y = e.getY();
        button = e.getModifiers();   
    }
    
    @Override
    public void mouseMoved(MouseEvent e) {
        if (isType(Japi2Constants.J_MOVED)) {
            session.log1("Mouse moved event");
            fill(e);
            trigger();
        }
    }
    
    @Override
    public void mouseDragged(MouseEvent e) {
        if (isType(Japi2Constants.J_DRAGGED)) {
            session.log1("Mouse dragged event");
            fill(e);
            trigger();
        }
    }

    @Override
    public String toString() {
        String typeName;
        switch (super.type) {
            case Japi2Constants.J_MOVED:
                typeName = "J_MOVED";
                break;
            case Japi2Constants.J_DRAGGED:
                typeName = "J_DRAGGED";
                break;
            default:
                typeName = "Unknown type!";
        }
        return "MouseMotionListener[for=" + id + ",type=" + typeName + ",x=" 
                + x + ",y=" + y + ",button=" + button + "]";
    }

}
