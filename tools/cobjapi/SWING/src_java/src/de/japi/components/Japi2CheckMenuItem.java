package de.japi.components;

import de.japi.components.listeners.Japi2ItemListener;
import javax.swing.JCheckBoxMenuItem;

/**
 * Japie2CheckMenuItem allowes to construct MenuItems in a CheckBox Menu based
 * on JCheckBoxMenuItem. It provides an ItemListener.
 */
public class Japi2CheckMenuItem extends JCheckBoxMenuItem {

     /**
     * Private value to represent an Item Listener.
     */
    private Japi2ItemListener japiListener;

    /**
     * Creats a new CheckBoxMenuItem.
     * @param title 
     */
    public Japi2CheckMenuItem(String title) {
        super(title);
    }
    
    /**
     * Returns the String representation of this component and its values.
     * @return String representation
     */
    @Override
    public String toString() {
        return "CheckMenuItem [title = " + getText() + "]";
    }

    /**
     * Returns the item listener for this component.
     * @return ItemListener
     */
    public Japi2ItemListener getJapiListener() {
        return japiListener;
    }

    /**
     * Sets the item listener for this component to tl.
     * @param tl 
     */
    public void setJapiListener(Japi2ItemListener tl) {
        japiListener = tl;
    }
}
