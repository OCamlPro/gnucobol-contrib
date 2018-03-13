package de.japi.components.listeners;

import de.japi.Japi2Session;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Action listener wrapper to inform the client that a e.g. button click action
 * happened.
 */
public class Japi2ActionListener extends AbstractJapi2Listener 
        implements ActionListener {

    /**
     * Creates a new {@link ActionListener} for a specific event type.
     * 
     * @param session the session object to operate on.
     * @param id the id of the object to listen on
     */
    public Japi2ActionListener(Japi2Session session, int id) {
        super(session, id);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        trigger();
    }

    @Override
    public String toString() {
        return "ActionListener[for=" + id + "]";
    }
    
}
