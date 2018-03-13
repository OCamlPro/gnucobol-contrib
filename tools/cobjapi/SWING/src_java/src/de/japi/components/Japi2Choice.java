package de.japi.components;

import de.japi.components.listeners.Japi2ItemListener;
import java.awt.Dimension;
import javax.swing.JComboBox;

/**
 * Jap2Choice class to construct drop-down choice boxes. In swing, the former
 * Choice component is now calles JComboBox.
 */
public class Japi2Choice extends JComboBox {

    /**
     * Private value to represent an Item Listener.
     */
    private Japi2ItemListener japiListener;

    int width = 0, height = 0;

    /**
     * Creates a new ChoiceBox. 
     */
    public Japi2Choice() {
        super();
    }

    /**
     * Sets the size to the given dw and dh values or to zero if they are smaler
     * than zero.
     * @param dw
     * @param dh 
     */
   @Override 
    public void setSize(int dw, int dh) {
        width = dw > 0 ? dw : 0;
        height = dh > 0 ? dh : 0;
        super.setSize(width, height);
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
     * Returns the minimum size by overwriting getMinimumSize of JComboBox.
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
        return "Choice [list elements = " + getItemCount() + "]";
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
     * @param il 
     */
    public void setJapiListener(Japi2ItemListener il) {
        japiListener = il;
    } 
}
