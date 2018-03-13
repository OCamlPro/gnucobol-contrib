package de.japi.components.listeners;

import de.japi.Japi2Session;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;

/**
 * JAPI2 wrapper for an {@link ItemListener}.
 */
public class Japi2ItemListener extends AbstractJapi2Listener 
        implements ItemListener {

    /**
     * Creates a new {@link ItemListener} for a specific event type.
     * 
     * @param session the session object to operate on.
     * @param id the id of the object to listen on
     */
    public Japi2ItemListener(Japi2Session session, int id) {
        super(session, id);
    }

    @Override
    public void itemStateChanged(ItemEvent e) {
        trigger();
    }
    
    @Override
    public String toString() {
        return "ItemListener[for=" + id + "]";
    }

}
