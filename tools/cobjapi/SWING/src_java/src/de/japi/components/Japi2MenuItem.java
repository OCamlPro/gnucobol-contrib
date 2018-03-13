package de.japi.components;

import de.japi.components.listeners.Japi2ActionListener;
import javax.swing.JMenuItem;

/**
 * Japie2MenuItem allowes to construct MenuItems in a Menu based
 * on JMenuItem. It provides an ActionListener.
 */
public class Japi2MenuItem extends JMenuItem{

    /**
     * Private value to represent an Action Listener.
     */
    private Japi2ActionListener japiListener;

    /**
     * Creates a new MenuItem.
     * @param title 
     */
    public Japi2MenuItem(String title) {
        super(title);
    }
    
    /**
     * Returns the String representation of this component and its values.
     * @return String representation
     */
    @Override
    public String toString() {
        return "MenuItem [title = " + getText() + "]";
    }

    /**
     * Returns the action listener for this component.
     * @return ActionListener
     */
    public Japi2ActionListener getJapiListener() {
        return japiListener;
    }

    /**
     * Sets the action listener for this component to al.
     * @param al 
     */
    public void setJapiListener(Japi2ActionListener al) {
        japiListener = al;
    }
}
