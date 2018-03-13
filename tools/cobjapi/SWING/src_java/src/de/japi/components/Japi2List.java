package de.japi.components;

import de.japi.components.listeners.AbstractJapi2Listener;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.util.List;
import javax.swing.DefaultListModel;
import javax.swing.JList;
import javax.swing.JScrollPane;
import javax.swing.ListSelectionModel;

/**
 * A simple list component. This component already contains scroll bars.
 */
public class Japi2List extends JScrollPane {
    
    /**
     * The list dimensions.
     */
    private int width = 0, height = 0;
    
    /**
     * The list model.
     */
    private final Japi2ListModel model;
    
    /**
     * The internal list component.
     */
    private final JList list;
    
    /**
     * Creates a new List. Multiple mode is initally set to false.
     * 
     * @param rows number of visible elements in the list
     */
    public Japi2List(int rows) {
        super(new JList());
        list = (JList) getViewport().getComponent(0);
        list.setModel(model = new Japi2ListModel());
        list.setVisibleRowCount(rows);
        setMultipleMode(false);
    }
    
    /**
     * The internal list component.
     * 
     * @return the list.
     */
    public JList getList() {
        return list;
    }

    @Override
    public synchronized void addMouseListener(MouseListener l) {
        if (l instanceof AbstractJapi2Listener) {
            list.addMouseListener(l);
        } else {
            super.addMouseListener(l);
        }
    }

    @Override
    public synchronized void addMouseMotionListener(MouseMotionListener l) {
        if (l instanceof AbstractJapi2Listener) {
            list.addMouseMotionListener(l);
        } else {
            super.addMouseMotionListener(l);
        }
    }
    
    /**
     * Attaches an {@link ActionListener} to this list to be compatible to
     * the AWT {@link List}. The {@link ActionListener} is fired, if a list item
     * is double clicked.
     * 
     * @param l the listener.
     */
    public final void setActionListener(final ActionListener l) {
        if (l == null) {
            throw new NullPointerException("Null listener given.");
        }
        
        // Add listener mouse listener to synthesize an action event
        list.addMouseListener(new MouseAdapter() {
            
            @Override
            public void mouseClicked(MouseEvent e) {
                if (e.getClickCount() == 2) {
                    int index = list.locationToIndex(e.getPoint());
                    if (index >= 0) {
                        l.actionPerformed(new ActionEvent(e, 1001, ""));
                    }
                }
            }
        });
        
    }

    /**
     * Makes multiple selections possible if value is set to true.
     * @param value 
     */
    public final void setMultipleMode(boolean value) {
        if (value) {
            list.setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
        } else {
            list.setSelectionMode(ListSelectionModel.SINGLE_INTERVAL_SELECTION);
        }
    }

    /**
     * Adds a new item to the list.
     * 
     * @param title the textual representation of the item to add.
     */
    public void addElement(String title) {
        model.addElement(title);
        model.fireContentsChanged();
    }
    
    /**
     * Triggers a re-render event of the {@link JList}.
     */
    public void update() {
        model.fireContentsChanged();
    }
    
    /**
     * Clears the contents of the list.
     */
    public void clear() {
        model.removeAllElements();
        model.fireContentsChanged();
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
        return "List[entries=" + model.getSize() + "]";
    }
    
    /**
     * A very simple custom list model.
     */
    private class Japi2ListModel extends DefaultListModel<String> {

        /**
         * Updates the list view.
         */
        public void fireContentsChanged() {
            fireContentsChanged(this, 0, -1);
        }

    }

    // Alias methods
    
    public void setSelectedIndex(int item) {
        list.setSelectedIndex(item);
    }

    public void clearSelection() {
        list.clearSelection();
    }

    public void insertElementAt(String item, int pos) {
        model.insertElementAt(item, width);
    }

    public void removeFromList(int index) {
        model.remove(index);
    }

    public void removeElementFromList(String item) {
        model.removeElement(item);
    }

    public int getSelectedIndex() {
        return list.getSelectedIndex();
    }

    public int getRowCount() {
        return model.getSize();
    }

    public boolean isSelectedIndex(int index) {
        return list.isSelectedIndex(index);
    }
    
    public String getElement(int index) {
        return (String) model.getElementAt(index);
    }

}
