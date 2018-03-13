package de.japi.calls;

import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import de.japi.components.layout.Japi2GridLayout;
import de.japi.components.layout.Japi2HorizontalFlowLayout;
import de.japi.components.layout.Japi2VerticalFlowLayout;
import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.FlowLayout;
import java.io.IOException;

/**
 * This class contains all JAPI calls which create a layout manager.
 */
public class LayoutCalls {
    
    public static void createFlowLayout(Japi2Session session, Container c) 
            throws IOException {
        int ori = session.readInt();
        session.log1("FlowLayout (orientation {0}) for object {1}", ori, c);
        FlowLayout fl;
        if (ori == Japi2Constants.J_HORIZONTAL) {
            c.setLayout(fl = new Japi2HorizontalFlowLayout());
        } else { // ori == Japi2Constants.J_VERTICAL
            c.setLayout(fl = new Japi2VerticalFlowLayout());
        }
        session.addObject(fl); // Notice: not needed!
    }
    
    public static void createGridLayout(Japi2Session session, Container c)
            throws IOException {
        int row = session.readInt();
        int col = session.readInt();
        session.log1("GridLayout for object {0} [row={1},col={2}]", c, row, col);
        Japi2GridLayout gl = new Japi2GridLayout(row, col);
        gl.setParent(c);
        session.addObject(gl); // Notice: not needed!
        c.setLayout(gl);
    }

    public static void createBorderLayout(Japi2Session session, Container c) 
            throws IOException {
        session.log1("BorderLayout for object {0}", c);
        BorderLayout bl;
        c.setLayout(bl = new BorderLayout());
        session.addObject(bl); // Notice: not needed!
    }    
    
    public static void createCardLayout(Japi2Session session, Container c)
            throws IOException {
        session.log1("CardLayout not implemented; redirecting to NoLayout");
        createNoLayout(session, c);
    }
    
    public static void createNoLayout(Japi2Session session, Container c)
            throws IOException {
        session.log1("No Layoutmanager for object {0}", c);
        c.setLayout(null);
    }
    
}
