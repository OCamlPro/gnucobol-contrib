package de.japi.components;

import java.awt.Font;
import javax.swing.JMenuBar;

/**
 * MenuBar class to construct a new MenuBar on based on JMenuBar.
 */
public class Japi2MenuBar extends JMenuBar {
   
    /**
    * Creates a new MenuBar.
    */
    public Japi2MenuBar() {
        super();
    }
    
    /**
     * If b is true, all Menus in this menuBar get enabled by this method.
     * @param b 
     */
    @Override
    public void setEnabled(boolean b){
        for(int i = 0; i < getMenuCount(); i++)
            getMenu(i).setEnabled(b);
    }

    /**
     * Sets the font of this component to the default font of JMenu. Also 
     * the same font is applied for all Menus belonging to this MenuBar.
     * @param font 
     */
    @Override
    public void setFont(Font font){
        super.setFont(font);
	for(int i = 0; i < getMenuCount(); i++)
            getMenu(i).setFont(font);
    }
    
    /**
     * Returns the String representation of this component and its values.
     * @return String representation
     */
    @Override
    public String toString() {
        return "MenuBar [" + getName() + "]";
    }
}
