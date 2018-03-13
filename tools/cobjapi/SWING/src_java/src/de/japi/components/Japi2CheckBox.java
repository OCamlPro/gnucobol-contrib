package de.japi.components;

import de.japi.components.listeners.Japi2ItemListener;
import java.awt.Dimension;
import javax.swing.JCheckBox;

/**
 * CheckBox class to construct Check Boxes based on JCheckBox.
 */
public class Japi2CheckBox extends JCheckBox {
    
    /**
     * Private value to represent an Item Listener.
     */
    private Japi2ItemListener japiListener;     

    int width = 0;
    int height = 0;

    /**
     * Creates a new CheckBox.
     * @param title 
     */
    public Japi2CheckBox(String title) {
        super(title);
    }

    /**
     * Sets the size to the given w and h values or to zero if they are smaler
     * than zero.
     * @param w
     * @param h 
     */
    @Override
    public void setSize(int w, int h) {
        width = w > 0 ? w : 0;
        height = h > 0 ? h : 0;

        super.setSize(w, h);
    }

    /**
     * Returns the preferredSize of this component. If width/height values are
     * greater zero they are returned instead of the preferred Size of the 
     * super class.
     * @return the preferred Size as Dimension 
     */
    @Override
    public Dimension getPreferredSize() {
        Dimension dim = super.getPreferredSize();
        dim.width = width > 0 ? width : dim.width;
        dim.height = height > 0 ? height : dim.height;
        return (dim);
    }

    /**
     * Returns the minimum size by overwriting getMinimumSize of JCheckBox.
     * @return minimum Size as Dimension
     */
    @Override
    public Dimension getMinimumSize() {
        Dimension dim = super.getMinimumSize();
        dim.width = width > 0 ? width : dim.width;
        dim.height = height > 0 ? height : dim.height;
        return (dim);
    }

    /**
     * Returns the String representation of this component and its values.
     * @return String representation
     */
    @Override
    public String toString() {
        return "CheckBox [title = " + getText() + "]";
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
