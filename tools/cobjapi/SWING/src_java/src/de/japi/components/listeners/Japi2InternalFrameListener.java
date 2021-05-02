package de.japi.components.listeners;

import de.japi.Japi2;
import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import javax.swing.event.InternalFrameEvent;
import javax.swing.event.InternalFrameListener;

/**
 * JAPI2 wrapper for an {@link WindowListener}.
 */
public class Japi2InternalFrameListener extends AbstractJapi2Listener implements InternalFrameListener {

    /**
     * Creates a new {@link WindowListener} for a specific event type.
     * 
     * <p style="color:red;">
     * Please note that the object id is set to <code>-1</code> by this 
     * constructor. It must be manually set to a valid id (greater -1) through 
     * {@link AbstractJapi2Listener#setId(int)}. Otherwise nothing will happen
     * and an error is logged if debugging is enabled.
     * </p>
     * 
     * @param session the session object to operate on.
     * @param type a type argument for the listener to listen on.
     */
    public Japi2InternalFrameListener(Japi2Session session, int type) {
        super(session, -1, type);
    }
    
    /**
     * Creates a new {@link WindowListener} for a specific event type.
     * 
     * @param session the session object to operate on.
     * @param id the id of the object to listen on.
     * @param type a type argument for the listener to listen on.
     */
    public Japi2InternalFrameListener(Japi2Session session, int id, int type) {
        super(session, id, type);
    }

    @Override
    public void internalFrameActivated(InternalFrameEvent e) {
        if (isType(Japi2Constants.J_ACTIVATED)) {
            Japi2.getInstance().debug("EVENT=windowActivated");
            trigger();
        }
    }

    @Override
    public void internalFrameDeactivated(InternalFrameEvent e) {
        if (isType(Japi2Constants.J_DEACTIVATED)) {
            Japi2.getInstance().debug("EVENT=windowDeactivated");
            trigger();
        }
    }

    @Override
    public void internalFrameOpened(InternalFrameEvent e) {
        if (isType(Japi2Constants.J_OPENED)) {
            Japi2.getInstance().debug("EVENT=windowOpened");
            trigger();
        }
    }

    @Override
    public void internalFrameClosed(InternalFrameEvent e) {
        if (isType(Japi2Constants.J_CLOSED)) {
            Japi2.getInstance().debug("EVENT=windowClosed");
            trigger();
        }
    }

    @Override
    public void internalFrameIconified(InternalFrameEvent e) {
        if (isType(Japi2Constants.J_ICONIFIED)) {
            Japi2.getInstance().debug("EVENT=windowIconified");
            trigger();
        }
    }

    @Override
    public void internalFrameDeiconified(InternalFrameEvent e) {
        if (isType(Japi2Constants.J_DEICONIFIED)) {
            Japi2.getInstance().debug("EVENT=windowDeiconified");
            trigger();
        }
    }

    @Override
    public void internalFrameClosing(InternalFrameEvent e) {
        if (isType(Japi2Constants.J_CLOSING)) {
            Japi2.getInstance().debug("EVENT=windowClosing");
            trigger();
        }
    }
    
    @Override
    public String toString() {
        return "WindowListener[for=" + id + "]";
    }
}
