package de.japi.components;

import java.awt.Dimension;
import javax.swing.JLabel;

/**
 * Japi2Label class to construct a new Lable based on JLabel. JLabel does not
 * react to input events. A JLabel object can dispalay text and image components.
 */
public class Japi2Label extends JLabel {

    int width = 0;
    int height = 0;

    /**
     * Creates a nes Label.
     * @param title 
     */
    public Japi2Label(String title) {
        super(title);
        setHorizontalAlignment(CENTER);
        setVerticalAlignment(CENTER);
    }

     /**
     * Sets the size to the given w and h values or to zero if they are smaler
     * than zero.
     * @param w
     * @param h 
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
        return "Label [title = " + getText() + ", components = " + getComponentCount() + "]";

    }
}
