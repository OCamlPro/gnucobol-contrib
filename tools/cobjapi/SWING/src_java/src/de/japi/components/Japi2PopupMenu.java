package de.japi.components;

import java.awt.Component;
import javax.swing.JPopupMenu;

/**
 * Simple customization of the {@link JPopupMenu} to store a Japi2 specific
 * element (the GUI element to use in the Japi Call JAPI_SHOWPOPUP as parent
 * element to display the popup menu properly on this element).
 */
public class Japi2PopupMenu extends JPopupMenu {

    /**
     * Parent element to display the popup menu on.
     */
    private Component parent;
    
    /**
     * Constructs a new popup menu.
     * 
     * @param title the title for the popup menu.
     */
    public Japi2PopupMenu(String title) {
        super(title);
    }
    
    /**
     * Returns the Japi2 specific parent element of this popup menu.
     * 
     * @return the parent element.
     */
    public Component getJapi2Parent() {
        return parent;
    }
    
    /**
     * Sets the parent element to display this popup menu later.
     * 
     * @param parent the parent element.
     */
    public void setJapi2Parent(Component parent) {
        this.parent = parent;
    }
    
}
