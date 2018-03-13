package de.japi.components;

import de.japi.Japi2Constants;
import de.japi.components.layout.Japi2FixLayout;
import de.japi.components.listeners.Japi2ComponentListener;
import java.awt.Color;
import java.awt.Font;
import java.awt.Insets;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

/**
 * Panel class to contruct a Panel based on JPanel.
 */
public class Japi2Panel extends JPanel {

     /**
     * Private variable to represent a Component Listener.
     */
    private Japi2ComponentListener japiListener;     

    Insets inset;

    /**
     * Creates a new Panel.
     */
    public Japi2Panel() {
        this(Japi2Constants.J_NONE);
    }
    
    /**
     * Creates a new Panel, with a FixLayout.
     * 
     * @param type type of the border.
     */
    public Japi2Panel(int type) {
        this.setOpaque(false);
        this.setLayout(new Japi2FixLayout());
        
        // New strategy:
        // in contrast to the original JAPI kernel, the border is implemented
        // as a SWING border and not painted by this component.
        if (type != Japi2Constants.J_NONE) {
            setBorder(new Japi2PanelBorder(getBackground(), type));
        }
    }
   
    /**
     * Enables all components inside the panel if b is true.
     * @param b 
     */
    @Override
    public void setEnabled(boolean b) {
        for (int i = 0; i < getComponentCount(); i++) {
            getComponent(i).setEnabled(b);
        }
    }

    /**
     * Sets the inset for this panel.
     * @param insets 
     */
    public void setInsets(Insets insets) {
        super.setBorder(new EmptyBorder(insets));
    }

    /**
     * Sets the font of this component. The font of all components
     * insise the panel is also set to the Font f.
     * @param f 
     */
    @Override
    public void setFont(Font f) {
        int i;
        super.setFont(f);
        for (i = 0; i < getComponentCount(); i++) {
            if (getComponent(i).isDisplayable()) {
                getComponent(i).setFont(f);
            }
        }
    }

    /**
     * Returns the String representation of this component and its values.
     * @return String representation
     */
    @Override
    public String toString() {
        return "Panel[#children= " + getComponentCount() + "]";
    }

    @Override
    public void setBackground(Color bg) {
        super.setBackground(bg);
        super.setOpaque(bg != null);
    }
    
    /**
     * Returns the component listener for this component.
     * @return ComponentListener
     */
    public Japi2ComponentListener getJapiListener() {
        return japiListener;
    }

    /**
     * Sets the component listener for this component to cl.
     * @param cl 
     */
    public void setJapiListener(Japi2ComponentListener cl) {
        japiListener = cl;
    } 
    
}
