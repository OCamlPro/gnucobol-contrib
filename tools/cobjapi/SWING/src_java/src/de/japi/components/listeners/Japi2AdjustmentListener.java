package de.japi.components.listeners;

import de.japi.Japi2Session;
import java.awt.event.AdjustmentEvent;
import java.awt.event.AdjustmentListener;

/**
 * JAPI2 wrapper for an {@link AdjustmentListener}.
 */
public class Japi2AdjustmentListener extends AbstractJapi2Listener 
        implements AdjustmentListener {

    /**
     * Creates a new {@link AdjustmentListener} for a specific event type.
     * 
     * @param session the session object to operate on.
     * @param id the id of the object to listen on
     */
    public Japi2AdjustmentListener(Japi2Session session, int id) {
        super(session, id);
    }

    @Override
    public void adjustmentValueChanged(AdjustmentEvent e) {
        trigger();
    }

    @Override
    public String toString() {
        return "AdjustmentListener[for=" + id + "]";
    }

}
