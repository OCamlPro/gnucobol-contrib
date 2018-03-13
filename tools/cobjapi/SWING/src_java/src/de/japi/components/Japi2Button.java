package de.japi.components;

import de.japi.components.listeners.Japi2ActionListener;
import java.awt.Dimension;
import javax.swing.JButton;

/**
 * Button class to construct Buttons based on JButton, which inherits 
 * from JButton. It provides an Action Listener.
 */
public class Japi2Button extends JButton {
    
    /**
     * Action Listener to notice when the button is clicked.
     */
    private Japi2ActionListener japiListener;     

    private int width = 0, height = 0;

    /**
     * Creates a new Button.
     * @param title 
     */
    public Japi2Button(String title) {
        super(title);
    }
    
    /**
     * Overrides the setSize Method of JButton. Only if dw/dh is greater than
     * 0 the intern variables width and height are assigned with their values, 
     * otherwise they are assigned to be 0.
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
     * Overrides the getPreferredSize method of JButton. The preferred size is
     * width/height only if they are greater zero, otherwise the width
     * and height values of the super class are taken.
     * @return Dimension
     */
    @Override 
    public Dimension getPreferredSize() {
        Dimension dim = super.getPreferredSize();
        dim.width = width > 0 ? width : dim.width;
        dim.height = height > 0 ? height : dim.height;
        return (dim);
    }

    /**
     * Overrides the getMinimumSize of JButton. The minimum size is 
     * width and height if this values are greater than 0. Otherwise the min
     * size is taken from the super class.
     * @return Dimension
     */
    @Override
    public Dimension getMinimumSize() {
        Dimension dim = super.getMinimumSize();
        dim.width = width > 0 ? width : dim.width;
        dim.height = height > 0 ? height : dim.height;
        return (dim);
    }
    
    /**
     * Returns a string representation of this component and its values.
     * @return String
     */
    @Override
    public String toString() {
        return "Button[title = " + getText() + "]";
    }
   
    /**
     * Returns the action listener for this component.
     * @return Japi2ActionListener
     */
    public Japi2ActionListener getJapiListener() {
        return japiListener;
    }

    /**
     * Setts an action listener for this component.
     * @param tl 
     */
    public void setJapiListener(Japi2ActionListener tl) {
        japiListener = tl;
    } 
}
