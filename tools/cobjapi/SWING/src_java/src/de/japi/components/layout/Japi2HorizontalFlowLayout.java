package de.japi.components.layout;

import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Insets;

/**
 * A custom {@link FlowLayout} extension for horizontal flow. This class is
 * adapted from the class <code>JAPI_HFlowLayout</code> in the original JAPI 
 * kernel.
 */
public class Japi2HorizontalFlowLayout extends FlowLayout {

    /**
     * Alignment keys.
     */
    public static final int LEFT = 0,
            CENTER = 1,
            RIGHT = 2,
            TOP = 3,
            BOTTOM = 4,
            TOPLEFT = 5,
            TOPRIGHT = 6,
            BOTTOMLEFT = 7,
            BOTTOMRIGHT = 8;

    /**
     * Other alignment and gap values.
     */
    private int align, orientation, hGap, vGap;
    
    /**
     * Indicator if the layout components should be spread over the entire
     * component's width.
     */
    private boolean fill;

    /**
     * Constructs a new horizontal {@link FlowLayout}.
     */
    public Japi2HorizontalFlowLayout() {
        this.hGap = 5;
        this.vGap = 5;
        setFill(false);
        setOrientation(TOP);
        setAlignment(TOP);
    }

    /**
     * Sets the fill property.
     * 
     * @param fill if <code>true</code> the layout components are spread over
     * the entire container width. On <code>false</code> the containers are 
     * layed out by their bounds.
     */
    public final void setFill(boolean fill) {
        this.fill = fill;
    }
    
    /**
     * Sets the orientation of the layout.
     * 
     * @param orientation the orientation.
     */
    public final void setOrientation(int orientation) {
        this.orientation = orientation;
    }
    

    @Override
    public final void setHgap(int gap) {
        this.hGap = gap;
    }

    @Override
    public final void setVgap(int gap) {
        this.vGap = gap;
    }

    @Override
    public final void setAlignment(int a) {
        switch (a) {
            case (TOPLEFT):
                this.align = LEFT;
                this.orientation = TOP;
                break;
            case (TOP):
                this.align = CENTER;
                this.orientation = TOP;
                break;
            case (TOPRIGHT):
                this.align = RIGHT;
                this.orientation = TOP;
                break;
            case (LEFT):
                this.align = LEFT;
                this.orientation = CENTER;
                break;
            case (CENTER):
                this.align = CENTER;
                this.orientation = CENTER;
                break;
            case (RIGHT):
                this.align = RIGHT;
                this.orientation = CENTER;
                break;
            case (BOTTOMLEFT):
                this.align = LEFT;
                this.orientation = BOTTOM;
                break;
            case (BOTTOM):
                this.align = CENTER;
                this.orientation = BOTTOM;
                break;
            case (BOTTOMRIGHT):
                this.align = RIGHT;
                this.orientation = BOTTOM;
                break;
            default:
                this.align = CENTER;
                this.orientation = TOP;
        }
    }

    @Override
    public Dimension preferredLayoutSize(Container target) {
        Dimension dim = new Dimension(0, 0);
        int nmembers = target.getComponentCount();

        for (int i = 0; i < nmembers; i++) {
            Component m = target.getComponent(i);
            if (m.isVisible()) {
                Dimension d = m.getPreferredSize();
                dim.height = Math.max(dim.height, d.height);
                if (i > 0) {
                    dim.width += hGap;
                }
                dim.width += d.width;
            }
        }
        Insets insets = target.getInsets();
        dim.width += insets.left + insets.right;
        dim.height += insets.top + insets.bottom;
        return dim;
    }

    @Override
    public Dimension minimumLayoutSize(Container target) {
        Dimension dim = new Dimension(0, 0);
        int nmembers = target.getComponentCount();

        for (int i = 0; i < nmembers; i++) {
            Component m = target.getComponent(i);
            if (m.isVisible()) {
                Dimension d = m.getMinimumSize();
                dim.height = Math.max(dim.height, d.height);
                if (i > 0) {
                    dim.width += hGap;
                }
                dim.width += d.width;
            }
        }
        Insets insets = target.getInsets();
        dim.width += insets.left + insets.right;
        dim.height += insets.top + insets.bottom;
        return dim;
    }

    @Override
    public void layoutContainer(Container target) {
        Insets insets = target.getInsets();
        int maxheight = target.getSize().height - (insets.top + insets.bottom);
        int maxwidth = target.getSize().width - (insets.left + insets.right);
        int nmembers = target.getComponentCount();
        int sumx, /*sumy,*/ starti = 0;
//        int height = 0, row = 0;

        int i, x = 0, y = 0;

        if (this.fill) {
            sumx = 0;
            for (i = 0; i < nmembers; i++) {
                Component m = target.getComponent(i);
                if (m.isVisible()) {
                    Dimension d = m.getPreferredSize();
                    sumx += d.width + hGap;
                }
            }
            if (sumx > 0) {
                sumx -= hGap;
            }

            if (this.align == LEFT) {
                x = insets.left;
            }
            if (this.align == CENTER) {
                x = insets.left + (maxwidth - sumx) / 2;
            }
            if (this.align == RIGHT) {
                x = insets.left + maxwidth - sumx;
            }

            for (i = 0; i < nmembers; i++) {
                Component m = target.getComponent(i);
                if (m.isVisible()) {
                    Dimension d = m.getPreferredSize();
                    m.setBounds(x, insets.top, d.width, maxheight);
                    x += d.width + hGap;
                }
            }
        } else //  NOFILL
                                {
            int xpos[] = new int[nmembers];
            int ypos[] = new int[nmembers];
            int ymax[] = new int[nmembers];
            int xmax[] = new int[nmembers];

            int rowh = 0, roww = 0;
            int sumh = 0, sumw = 0;

            starti = 0;
            for (i = 0; i < nmembers; i++) {
                Component m = target.getComponent(i);
                if (m.isVisible()) {
                    Dimension d = m.getPreferredSize();

                    if (roww + d.width <= maxwidth) {
                        rowh = Math.max(rowh, d.height);
                        xpos[i] = roww;
                        ypos[i] = sumh;
                        roww += d.width + hGap;
                        sumw += d.width + hGap;
                    } else {
                        sumh += rowh + vGap;
                        for (int k = starti; k < i; k++) {
                            ymax[k] = rowh;
                            xmax[k] = sumw - hGap;
                        }
                        roww = d.width + hGap;
                        rowh = d.height;
                        sumw = d.width + hGap;
                        xpos[i] = 0;
                        ypos[i] = sumh;
                        starti = i;
                    }
                }
            }
            sumh += rowh;
            for (int k = starti; k < i; k++) {
                ymax[k] = rowh;
                xmax[k] = sumw - hGap;
            }

            for (i = 0; i < nmembers; i++) {
                Component m = target.getComponent(i);
                if (m.isVisible()) {
                    Dimension d = m.getPreferredSize();
                    if (this.orientation == TOP) {
                        y = ypos[i] + insets.top;
                    }
                    if (this.orientation == BOTTOM) {
                        y = ypos[i] + insets.top + maxheight - sumh + ymax[i] - d.height;
                    }
                    if (this.orientation == CENTER) {
                        y = ypos[i] + insets.top + maxheight / 2 - sumh / 2 + ymax[i] / 2 - d.height / 2;
                    }
                    if (this.align == LEFT) {
                        x = xpos[i] + insets.left;
                    }
                    if (this.align == RIGHT) {
                        x = xpos[i] + insets.left + maxwidth - xmax[i];
                    }
                    if (this.align == CENTER) {
                        x = xpos[i] + insets.left + maxwidth / 2 - xmax[i] / 2;
                    }

                    m.setBounds(x, y, d.width, d.height);
                }

            }
        }
    }

    @Override
    public String toString() {
        String str = "";
        switch (align) {
            case LEFT:
                str = ",align=left";
                break;
            case CENTER:
                str = ",align=center";
                break;
            case RIGHT:
                str = ",align=right";
                break;
        }
        return "HFlowLayout[hgap=" + hGap + ",vgap=" + vGap + str + "]";
    }
    
    @Override
    public void addLayoutComponent(String name, Component comp) { }

    @Override
    public void removeLayoutComponent(Component comp) { }
    
}
