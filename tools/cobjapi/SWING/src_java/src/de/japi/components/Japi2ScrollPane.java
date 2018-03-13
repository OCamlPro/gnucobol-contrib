package de.japi.components;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.LayoutManager;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.EmptyBorder;

/**
 * An wrapper for {@link JScrollPane} to provide an interface which can be
 * used by the JAPI2 kernel.
 */
public class Japi2ScrollPane extends JScrollPane {

    /**
     * Internal panel.
     */
    private final JPanel panel;
    
    /**
     * Creates a new JAPI2 specific scroll pane.
     */
    public Japi2ScrollPane() {
        super(new JPanel());
        panel = (JPanel) getViewport().getView();
        panel.setBorder(new EmptyBorder(0, 0, 0, 0));
        panel.setLayout(new BorderLayout(0, 0));
        setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
        setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
    }

    @Override
    public void setLayout(LayoutManager layout) {
        if (panel == null) {
            super.setLayout(layout);
        } else {
            panel.setLayout(layout);
        }
    }
    
    @Override
    public Component add(Component comp) {
        if (panel == null) {
            return super.add(comp);
        } else {
            // To provide a proper behaviour which conforms to the AWT
            // ScrollPane behaviour this line is needed instead of a simple
            // add() method call with only the Component as argument.
            // The main scroll panel has a BorderLayout and the added component
            // is layed out in centered and streched. This will work only if
            // one component is addeded. The next component overwrites the
            // current component
            panel.add(comp, BorderLayout.CENTER);
            return comp;
        }
    }

    @Override
    public void add(Component comp, Object constraints) {
        if (panel == null) {
            super.add(comp, constraints);
        } else {
            panel.add(comp, constraints);
        }
    }

    @Override
    public void setSize(int width, int height) {
        super.setSize(width, height);
        setPreferredSize(new Dimension(width, height));
        setMinimumSize(new Dimension(width, height));
        setMaximumSize(new Dimension(width, height));
    }

    @Override
    public String toString() {
        return "ScrollPane[width=" + getWidth() + ",height=" + getHeight() 
                + ",id=" + hashCode() + "]";
    }
    
}
