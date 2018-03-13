package de.japi.components.layout;

import java.awt.Container;
import java.awt.GridLayout;

/**
 * This class wraps the {@link GridLayout} to provide a workaround for a nasty
 * Swing bug: if a panel with the GridLayout is set twice to the same column
 * or row value the component needs to be revalidated. For good measure the
 * method {@link #updateParent()} is called after every single change on the
 * column or row count so that everything is layed out correctly.
 */
public class Japi2GridLayout extends GridLayout {
    
    /**
     * Parent container of this layout.
     */
    private Container parent;
    
    /**
     * Constructs a new grid layout.
     * 
     * @param rows the number of rows.
     * @param cols the number of columns.
     */
    public Japi2GridLayout(int rows, int cols) {
        super(rows, cols);
    }

    /**
     * Returns the parent component.
     * 
     * @return parent component or <code>null</code>.
     */
    public Container getParent() {
        return parent;
    }

    /**
     * Sets the parent component.
     * 
     * @param parent parent component.
     */
    public void setParent(Container parent) {
        this.parent = parent;
    }
    
    /**
     * Triggers the parent component (if not null) to relayout
     * all its component.
     */
    public void updateParent() {
        if (parent != null) {
            parent.revalidate();
        }
    }

    @Override
    public void setRows(int rows) {
        super.setRows(rows);
        updateParent();
    }

    @Override
    public void setColumns(int cols) {
        super.setColumns(cols);
        updateParent();
    }
    
}
