package de.japi.components;

import java.awt.Font;
import javax.swing.JMenu;

/**
 * Menu class to construct a new Menu on based on JMenu.
 */
public class Japi2Menu extends JMenu {
    
    /**
     * Creates a new Menu.
     * @param title 
     */
    public Japi2Menu(String title) {
        super(title);
    }
  	
    /**
     * Sets the font of this component to the default font of JMenu. Also 
     * the same font is applied for all MenuItems belonging to this menu.
     * @param font 
     */
    @Override
    public void setFont(Font font){
        super.setFont(font);
        for(int i = 0; i < getItemCount(); i++)
            getItem(i).setFont(font);
    }
    
    /**
     * Returns the String representation of this component and its values.
     * @return String representation
     */
    @Override
    public String toString() {
        return "Menu [title = " + getText() + ", children = " + getItemCount() + "]";
    }
    
}
