package de.japi.components.listeners;

import de.japi.Japi2;
import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import de.japi.components.Japi2Canvas;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentListener;

/**
 * JAPI2 wrapper for an {@link ComponentListener}.
 */
public class Japi2ComponentListener extends AbstractJapi2Listener 
        implements ComponentListener {
    
    /**
     * Creates a new {@link ComponentListener} for a specific event type.
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
    public Japi2ComponentListener(Japi2Session session, int type) {
        super(session, -1, type);
    }
    
    /**
     * Creates a new {@link ComponentListener} for a specific event type.
     * 
     * @param session the session object to operate on.
     * @param id the id of the object to listen on.
     * @param type a type argument for the listener to listen on.
     */
    public Japi2ComponentListener(Japi2Session session, int id, int type) {
        super(session, id, type);
    }

    @Override
    public void componentResized(ComponentEvent e) {
        if (isType(Japi2Constants.J_RESIZED)) {
            Japi2.getInstance().debug("Event=Component resized");
            if (e.getSource() instanceof Japi2Canvas) {
                ((Japi2Canvas) e.getSource()).notifyResized();
            }
            trigger();
        }
    }

    @Override
    public void componentHidden(ComponentEvent e) {
        if (isType(Japi2Constants.J_HIDDEN)) {
            trigger();
        }
    }

    @Override
    public void componentMoved(ComponentEvent e) {
        if (isType(Japi2Constants.J_MOVED)) {
            trigger();
        }
    }

    @Override
    public void componentShown(ComponentEvent e) {
        if (isType(Japi2Constants.J_SHOWN)) {
            trigger();
        }
    }

    @Override
    public String toString() {
        return "ComponentListener[for=" + id + "]";
    }

}
