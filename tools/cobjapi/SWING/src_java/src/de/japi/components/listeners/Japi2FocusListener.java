package de.japi.components.listeners;

import de.japi.Japi2Session;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.io.IOException;

/**
 * JAPI2 wrapper for an {@link FocusListener}.
 */
public class Japi2FocusListener extends AbstractJapi2Listener implements FocusListener {

    /**
     * Indicates if the current component holds the focus.
     */
    private boolean hasFocus;
    
    /**
     * Constructs a new JAPI2 focus listener. This constructor will also send
     * the id of the component to listen on to the client as required through 
     * the JAPI documentation on the command stream.
     * 
     * <p>
     * <b>Important:</b> this constructor already adds this listener to the
     * objects map through {@link Japi2Session#addObject(java.lang.Object)}.
     * </p>
     * 
     * @param session the session object to operate on.
     * @throws IOException if an I/O error occurs.
     */
    public Japi2FocusListener(Japi2Session session) throws IOException {
        super(session, -1);
        super.id = session.addObject(this);
        session.writeInt(super.id);
    }

    /**
     * Tests if the component attached with this focus listener has currently
     * the focus.
     * 
     * @return <code>true</code> if the component has the focus and otherwise
     * <code>false</code> is returned.
     */
    public boolean hasFocus() {
        return hasFocus;
    }
    
    @Override
    public void focusGained(FocusEvent e) {
        session.log1("Focus gained; component id '{0}'", id);
        trigger();
        hasFocus = true;
    }

    @Override
    public void focusLost(FocusEvent e) {
        session.log1("Focus lost; component id '{0}'", id);
        trigger();
        hasFocus = false;
    }
    
    @Override
    public String toString() {
        return "FocusListener[for=" + id + ",hasFocus=" + hasFocus + "]";
    }

}
