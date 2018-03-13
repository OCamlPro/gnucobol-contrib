package de.japi.components.listeners;

import de.japi.Japi2;
import de.japi.Japi2Session;

/**
 * Abstract listener class which contains common attributes.
 */
public class AbstractJapi2Listener {
    
    /**
     * The session object, used to send action triggers to the client and 
     * perform logging.
     */
    protected Japi2Session session;
    
    /**
     * The id of the component to which this listener is listening to.
     */
    protected int id;
    
    /**
     * The type argument. See {@link #isType(int)}.
     */
    protected int type;
    
    /**
     * Constructs a new listener object.
     * 
     * @param session the session object.
     * @param id the id of the object which is related to this listener.
     * @param type an optional type argument which can be used together with
     * {@link #isType(int)}.
     */
    public AbstractJapi2Listener(Japi2Session session, int id, int type) {
        if (session == null) {
            throw new NullPointerException(
                    "Session can't be null in AbstractJapi2Listener"
            );
        }
        
        this.session = session;
        this.id = id;
        this.type = type;
    }

    /**
     * Sets the object id of the object on which this listener listens.
     * 
     * @param id of the object.
     */
    public void setId(int id) {
        this.id = id;
    }
    
    /**
     * Constructs a new listener object.
     * 
     * @param session the session object.
     * @param id the id of the object which is related to this listener.
     */
    public AbstractJapi2Listener(Japi2Session session, int id) {
        this(session, id, -1);
    }
    
    /**
     * Triggers the JAPI2 listener and sends the id of the triggering object
     * to the client. Exception handling and debug output is automagically 
     * performed.
     */
    protected void trigger() {
        if (id < 0) {
            Japi2.getInstance().debug("FAILED to trigger listener event ({0}), "
                    + "id not properly set id = {1}", getClass(), id);
            return;
        }
        
        session.log1("Event ({0}) triggered on object with id {1}", 
                toString(), id);

        // Send action via ACTION stream
        try {
            session.writeInt(id, Japi2Session.TargetStream.ACTION);
        } catch (Exception ex) {
            Japi2.getInstance().debug("Failed to trigger action {0}", 
                    toString(), ex);
        }
    }
    
    /**
     * Tests if the given type id <code>type</code> matches with the initial
     * set type id in the constructor.
     * 
     * @param type the type id to check.
     * @return <code>true</code> if no type id was set using the special 
     * constructor or the type is matching. Otherwise <code>false</code> is 
     * returned.
     */
    protected boolean isType(int type) {
        return type == this.type;
    }
    
}
