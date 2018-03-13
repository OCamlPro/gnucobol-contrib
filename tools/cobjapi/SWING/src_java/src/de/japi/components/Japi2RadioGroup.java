package de.japi.components;

import java.awt.Container;
import javax.swing.ButtonGroup;

/**
 * RadioGroup class to construct Button Groups based on ButtonGroup. Unlike 
 * in awt, in swing all groups for buttons are summed up in the ButtonGroup class. 
 */
public class Japi2RadioGroup extends ButtonGroup {
    
    /**
     * Parent of this component.
     */
    Container parent;

    /**
     * Creates a new RadioGroup.
     */
    public Japi2RadioGroup() {
        super();
    }

    /**
     * Sets the parent of the RadioGroup to p.
     * @param p 
     */
    public void setParent(Container p) {
        this.parent = p;
    }

    /**
     * Returns the parent of this component.
     * @return Container as parent of this component
     */
    public Container getParent() {
        return (this.parent);
    }
    
    /**
     * Returns the String representation of this component and its values.
     * @return String representation
     */
    @Override
    public String toString() {
        return "RadioGroup [contains " + getButtonCount() + " buttons]";

    }
}
