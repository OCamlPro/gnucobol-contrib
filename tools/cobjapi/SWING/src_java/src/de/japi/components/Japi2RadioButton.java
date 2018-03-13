package de.japi.components;

import de.japi.components.listeners.Japi2ItemListener;
import java.awt.Dimension;
import javax.swing.JRadioButton;

/**
 * RadioButton class to construct Radio Buttons based on JRadioButton, which 
 * inherits from AbstractButton.
 */
public class Japi2RadioButton extends JRadioButton {
  
     /**
     * Private value to represent an Item Listener.
     */
    private Japi2ItemListener japiListener;     

    int w = 0;
    int h = 0;
    
    /**
     * In contrast to the orignial version, the constructor for Japi2RadioButton
     * takes only a titel as an argument. The Button Group to which the Radio
     * Button should belong is set in the showRadioButton-Method in class
     * ConstrucionCalls.java 
     * @param title 
     */
    public Japi2RadioButton(String title) {
        super(title, false);
    }
    
    /**
     * Sets the size to the given dw and dh values or to zero if they are smaler
     * than zero.
     * @param dw
     * @param dh 
     */
    @Override
    public void setSize(int dw, int dh) {
        w = dw > 0 ? dw : 0;
        h = dh > 0 ? dh : 0;
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
        dim.width = w > 0 ? w : dim.width;
        dim.height = h > 0 ? h : dim.height;
        return (dim);
    }
    
    /**
     * Returns the minimum size by overwriting getMinimumSize of JCheckBox.
     * @return minimum Size as Dimension
     */
    @Override
    public Dimension getMinimumSize() {
        Dimension dim = super.getMinimumSize();
        dim.width = w > 0 ? w : dim.width;
        dim.height = h > 0 ? h : dim.height;
        return (dim);
    }
    
    /**
     * Returns the String representation of this component and its values.
     * @return String representation
     */
    @Override
    public String toString() {
        return "RadioButton [title = " + getText() + "]";
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
