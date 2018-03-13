package de.japi.calls;

import de.japi.Japi2;
import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import de.japi.components.listeners.AbstractJapi2Listener;
import de.japi.components.listeners.Japi2ComponentListener;
import de.japi.components.listeners.Japi2FocusListener;
import de.japi.components.listeners.Japi2KeyListener;
import de.japi.components.listeners.Japi2MouseListener;
import de.japi.components.listeners.Japi2MouseMotionListener;
import de.japi.components.listeners.Japi2WindowListener;
import java.awt.Component;
import java.awt.Window;
import java.io.IOException;

/**
 * This class contains all JAPI calls which create a listener object.
 */
public class ListenerCalls {
    
    public static void installKeyListener(Japi2Session session, Component c) 
            throws IOException {
        session.log1("KeyListener in {0}", c);
        c.addKeyListener(new Japi2KeyListener(session));
    }
    
    public static void installFocusListener(Japi2Session session, Component c) 
            throws IOException {
        session.log1("FocusListener in {0}", c);
        c.addFocusListener(new Japi2FocusListener(session));
    }
    
    public static void installMouseListener(Japi2Session session, Component c) 
            throws IOException {
        int type = session.readInt();
        session.log1("MouseListener type {0} in {1}", type, c);
        
        AbstractJapi2Listener l;
        if(Japi2.inArray(type, Japi2Constants.J_PRESSED, 
                Japi2Constants.J_RELEASED, 
                Japi2Constants.J_ENTERERD,
                Japi2Constants.J_EXITED, 
                Japi2Constants.J_DOUBLECLICK)) {
            l = new Japi2MouseListener(session, type);
            c.addMouseListener((Japi2MouseListener) l);
        } else if (Japi2.inArray(type, Japi2Constants.J_MOVED, Japi2Constants.J_DRAGGED)) {
            l = new Japi2MouseMotionListener(session, type);
            c.addMouseMotionListener((Japi2MouseMotionListener) l);
        } else {
            throw new UnsupportedOperationException(
                    "No valid MouseListener type given"
            );
        }
        
        int oid = session.addObject(l);
        l.setId(oid);
        session.writeInt(oid);
    }
    
    public static void installComponentListener(Japi2Session session, Component c) 
            throws IOException {
        int type = session.readInt();
        session.log1("ComponentListener type {0} in {1}", type, c);
        
        if((type >= Japi2Constants.J_MOVED) && (type <= Japi2Constants.J_SHOWN)) {
            Japi2ComponentListener l = new Japi2ComponentListener(session, type);
            int oid = session.addObject(l);
            l.setId(oid);
            c.addComponentListener(l);
            session.writeInt(oid);
        } else {
            throw new UnsupportedOperationException(
                    "No valid ComponentListener event type given"
            );
        }
    }
    
    public static void installWindowListener(Japi2Session session, Window w) 
            throws IOException {
        int type = session.readInt();
        session.log1("WindowListener type {0} in {1}", type, w);
        
        if(Japi2.inArray(type, Japi2Constants.J_ACTIVATED, 
                Japi2Constants.J_DEACTIVATED, Japi2Constants.J_OPENED, 
                Japi2Constants.J_CLOSED, Japi2Constants.J_ICONIFIED, 
                Japi2Constants.J_DEICONIFIED, Japi2Constants.J_CLOSING)) {
            Japi2WindowListener l = new Japi2WindowListener(session, type);
            int oid = session.addObject(l);
            l.setId(oid);
            w.addWindowListener(l);
            session.writeInt(oid);
        } else {
            throw new UnsupportedOperationException(
                    "No valid WindowListener event type given"
            );
        }
    }
    
}
