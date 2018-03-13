package de.japi.components.listeners;

import de.japi.Japi2;
import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;

/**
 * JAPI2 wrapper for an {@link WindowListener}.
 */
public class Japi2WindowListener extends AbstractJapi2Listener implements WindowListener {

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
    public Japi2WindowListener(Japi2Session session, int type) {
        super(session, -1, type);
    }
    
    /**
     * Creates a new {@link WindowListener} for a specific event type.
     * 
     * @param session the session object to operate on.
     * @param id the id of the object to listen on.
     * @param type a type argument for the listener to listen on.
     */
    public Japi2WindowListener(Japi2Session session, int id, int type) {
        super(session, id, type);
    }

    @Override
    public void windowActivated(WindowEvent e) {
        if (isType(Japi2Constants.J_ACTIVATED)) {
            Japi2.getInstance().debug("EVENT=windowActivated");
            trigger();
        }
    }

    @Override
    public void windowDeactivated(WindowEvent e) {
        if (isType(Japi2Constants.J_DEACTIVATED)) {
            Japi2.getInstance().debug("EVENT=windowDeactivated");
            trigger();
        }
    }

    @Override
    public void windowOpened(WindowEvent e) {
        if (isType(Japi2Constants.J_OPENED)) {
            Japi2.getInstance().debug("EVENT=windowOpened");
            trigger();
        }
    }

    @Override
    public void windowClosed(WindowEvent e) {
        if (isType(Japi2Constants.J_CLOSED)) {
            Japi2.getInstance().debug("EVENT=windowClosed");
            trigger();
        }
    }

    @Override
    public void windowIconified(WindowEvent e) {
        if (isType(Japi2Constants.J_ICONIFIED)) {
            Japi2.getInstance().debug("EVENT=windowIconified");
            trigger();
        }
    }

    @Override
    public void windowDeiconified(WindowEvent e) {
        if (isType(Japi2Constants.J_DEICONIFIED)) {
            Japi2.getInstance().debug("EVENT=windowDeiconified");
            trigger();
        }
    }
    
    @Override
    public void windowClosing(WindowEvent e) {
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
