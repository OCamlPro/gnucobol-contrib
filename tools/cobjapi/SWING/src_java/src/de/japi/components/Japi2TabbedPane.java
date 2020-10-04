package de.japi.components;

import de.japi.components.listeners.Japi2ComponentListener;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.Insets;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.border.EmptyBorder;

/**
 * TabbedPane class to contruct a TabbedPane based on JTabbedPane.
 */
public class Japi2TabbedPane extends JTabbedPane {

     /**
     * Private variable to represent a Component Listener.
     */
    private Japi2ComponentListener japiListener;     

    Insets inset;

    /**
     * Creates a new TabbedPane
     * 
     */
    public Japi2TabbedPane() {
        this.setOpaque(false);
    }
   
    /**
     * Enables all components inside the TabbedPane if b is true.
     * @param b 
     */
    @Override
    public void setEnabled(boolean b) {
        for (int i = 0; i < getComponentCount(); i++) {
            getComponent(i).setEnabled(b);
        }
    }

    /**
     * Sets the inset for this tabbedPane.
     * @param insets 
     */
    public void setInsets(Insets insets) {
        super.setBorder(new EmptyBorder(insets));
    }

    /**
     * Sets the font of this component. The font of all components
     * insise the tabbedPane is also set to the Font f.
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
        return "TabbedPane[#children= " + getComponentCount() + "]";
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

//    public static void main(String[] args) {
//        JTabbedPane tp;
//        JFrame frame = new JFrame();
//        frame.setLayout(new GridLayout(1, 1));
//        JPanel panel1 = new JPanel();
//        JPanel panel2 = new JPanel();
//        JPanel panel3 = new JPanel();
//        
//        tp = new JTabbedPane();
//        tp.addTab("Tab 1", panel1);
//        tp.addTab("Tab 2", panel2);
//        tp.addTab("Tab 3", panel3);
//        
//        frame.add(tp);
//        frame.pack();
//        frame.setVisible(true);
//    }
    
}
