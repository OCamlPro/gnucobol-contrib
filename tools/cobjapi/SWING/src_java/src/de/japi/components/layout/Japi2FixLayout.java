package de.japi.components.layout;

import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Insets;
import java.awt.LayoutManager;
import java.awt.Point;
import java.awt.Rectangle;

/**
 * A simple layout to lay-out components at a fixed position. This class is 
 * adapted from the class <code>JAPI_FixLayout</code> in the original JAPI 
 * kernel.
 */
public class Japi2FixLayout implements LayoutManager {
    /**
     * The gap sizes in pixel.
     */
    private int hgap, vgap;
    
    /**
     * Constructs an empty layout and sets the vertical and horizontal gap
     * to 5 pixel.
     */
    public Japi2FixLayout() {
        this.hgap = 5;
        this.vgap = 5;
    }
    
    /**
     * Returns the horizontal gap.
     * 
     * @return the horizontal gap.
     */
    public int getHgap() {
        return hgap;
    }

    /**
     * Returns the vertical gap.
     * 
     * @return the vertical gap.
     */
    public int getVgap() {
        return vgap;
    }

    /**
     * Sets the horizontal gap.
     * 
     * @param hgap the horizontal gap to set.
     */
    public void setHgap(int hgap) {
        this.hgap = hgap;
    }

    /**
     * Sets the vertical gap.
     * 
     * @param vgap the vertical gap to set.
     */
    public void setVgap(int vgap) {
        this.vgap = vgap;
    }

    @Override
    public Dimension preferredLayoutSize(Container target) {
        Insets insets = target.getInsets();
        Dimension dim = new Dimension(0, 0);
        Rectangle size = new Rectangle(0, 0);
        for (int i = 0; i < target.getComponentCount(); i++) {
            Component comp = target.getComponent(i);
            if (comp.isVisible()) {
                Dimension d = comp.getSize();
                Rectangle compSize = new Rectangle(comp.getLocation());
                compSize.setSize(d.width, d.height);
                size = size.union(compSize);
            }
        }
        dim.width += size.width + insets.right + hgap;
        dim.height += size.height + insets.bottom + vgap;
        return dim;
    }
    
    @Override
    public Dimension minimumLayoutSize(Container target) {
        Insets insets = target.getInsets();
        Dimension dim = new Dimension(0, 0);
        Rectangle minBounds = new Rectangle(0, 0);
        for (int i = 0; i < target.getComponentCount(); i++) {
            Component comp = target.getComponent(i);
            if (comp.isVisible()) {
                Dimension d = comp.getMinimumSize();
                Rectangle compMinBounds = new Rectangle(comp.getLocation());
                compMinBounds.setSize(d.width, d.height);
                minBounds = minBounds.union(compMinBounds);
            }
        }
        dim.width += minBounds.width + insets.right + hgap;
        dim.height += minBounds.height + insets.bottom + vgap;
        return dim;
    }

    @Override
    public void layoutContainer(Container target) {
        int ncomponents = target.getComponentCount();
        for (int i = 0; i < ncomponents; i++) {
            Component comp = target.getComponent(i);
            if (comp.isVisible()) {
                Dimension sz = comp.getSize();
                Dimension ps = comp.getPreferredSize();
                Point loc = comp.getLocation();
                if (sz.width < ps.width || sz.height < ps.height) {
                    sz = ps;
                }
                comp.setBounds(loc.x, loc.y, sz.width, sz.height);
            }
        }
    }
    
    @Override
    public void addLayoutComponent(String s, Component comp) { }

    @Override
    public void removeLayoutComponent(Component comp) { }
    
}
