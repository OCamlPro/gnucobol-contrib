package de.japi.components.listeners;

import de.japi.Japi2Session;
import java.awt.event.TextEvent;
import java.awt.event.TextListener;

/**
 * JAPI2 wrapper for an {@link TextListener}.
 */
public class Japi2TextListener extends AbstractJapi2Listener implements TextListener {

    /**
     * Creates a new {@link TextListener} for a specific event type.
     * 
     * @param session the session object to operate on.
     * @param id the id of the object to listen on
     */
    public Japi2TextListener(Japi2Session session, int id) {
        super(session, id);
    }

    @Override
    public void textValueChanged(TextEvent e) {
        trigger();
    }
    
    @Override
    public String toString() {
        return "TextListener[for=" + id + "]";
    }

}
