package de.japi.components.layout;

import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Insets;

/**
 * A custom {@link FlowLayout} extension for vertical flow. This class is
 * adapted from the class <code>JAPI_VFlowLayout</code> in the original JAPI
 * kernel.
 */
public class Japi2VerticalFlowLayout extends FlowLayout {

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
    private int hGap, vGap, vAlign, hAlign;
    
    /**
     * Indicator if the layout components should be spread over the entire
     * component's width.
     */
    private boolean fill;

    /**
     * Creates a new instance of the vertical {@link FlowLayout}.
     */
    public Japi2VerticalFlowLayout() {
        this.hGap = 5;
        this.vGap = 5;
        setAlignment(TOP);
        setFill(false);
        setOrientation(TOP);
    }
    
    /**
     * Sets the orientation of the layout.
     * 
     * @param orientation the orientation.
     */
    public final void setOrientation(int orientation) {
        this.vAlign = orientation;
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

    @Override
    public void setHgap(int gap) {
        this.hGap = gap;
    }

    @Override
    public void setVgap(int gap) {
        this.vGap = gap;
    }

    @Override
    public final void setAlignment(int alignment) {
        switch (alignment) {
            case (TOPLEFT):
                this.hAlign = LEFT;
                this.vAlign = TOP;
                break;
            case (TOP):
                this.hAlign = CENTER;
                this.vAlign = TOP;
                break;
            case (TOPRIGHT):
                this.hAlign = RIGHT;
                this.vAlign = TOP;
                break;
            case (LEFT):
                this.hAlign = LEFT;
                this.vAlign = CENTER;
                break;
            case (CENTER):
                this.hAlign = CENTER;
                this.vAlign = CENTER;
                break;
            case (RIGHT):
                this.hAlign = RIGHT;
                this.vAlign = CENTER;
                break;
            case (BOTTOMLEFT):
                this.hAlign = LEFT;
                this.vAlign = BOTTOM;
                break;
            case (BOTTOM):
                this.hAlign = CENTER;
                this.vAlign = BOTTOM;
                break;
            case (BOTTOMRIGHT):
                this.hAlign = RIGHT;
                this.vAlign = BOTTOM;
                break;
            default:
                this.hAlign = CENTER;
                this.vAlign = TOP;
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
                dim.width = Math.max(dim.width, d.width);
                if (i > 0) {
                    dim.height += vGap;
                }
                dim.height += d.height;
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
                dim.width = Math.max(dim.width, d.width);
                if (i > 0) {
                    dim.height += vGap;
                }
                dim.height += d.height;
            }
        }
        Insets insets = target.getInsets();
        dim.width += insets.left + insets.right + hGap * 2;
        dim.height += insets.top + insets.bottom + vGap * 2;
        return dim;
    }

    @Override
    public void layoutContainer(Container target) {
        Insets insets = target.getInsets();
        int maxheight = target.getSize().height - (insets.top + insets.bottom);
        int maxwidth = target.getSize().width - (insets.left + insets.right);
        int nmembers = target.getComponentCount();
        int sumx, sumy, starti = 0;
        int height = 0, row = 0;

        int i, x = 0, y = 0;

        if (this.fill) {
            sumy = 0;
            for (i = 0; i < nmembers; i++) {
                Component m = target.getComponent(i);
                if (m.isVisible()) {
                    Dimension d = m.getPreferredSize();
                    sumy += d.height + vGap;
                }
            }
            if (sumy > 0) {
                sumy -= vGap;
            }

            if (this.vAlign == TOP) {
                y = insets.top;
            }
            if (this.vAlign == CENTER) {
                y = insets.top + (maxheight - sumy) / 2;
            }
            if (this.vAlign == BOTTOM) {
                y = insets.top + maxheight - sumy;
            }

            for (i = 0; i < nmembers; i++) {
                Component m = target.getComponent(i);
                if (m.isVisible()) {
                    Dimension d = m.getPreferredSize();
//			    	m.reshape(insets.left, y, maxwidth, d.height);
                    m.setBounds(insets.left, y, maxwidth, d.height);
                    y += d.height + vGap;
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

                    if (rowh + d.height <= maxheight) {
                        roww = Math.max(roww, d.width);
                        xpos[i] = sumw;
                        ypos[i] = rowh;
                        rowh += d.height + vGap;
                        sumh += d.height + vGap;
                    } else {
                        sumw += roww + hGap;
                        for (int k = starti; k < i; k++) {
                            ymax[k] = sumh - vGap;
                            xmax[k] = roww;
                        }
                        rowh = d.height + vGap;
                        roww = d.width;
                        sumh = d.height + vGap;
                        ypos[i] = 0;
                        xpos[i] = sumw;
                        starti = i;
                    }
                }
            }
            sumw += roww;
            for (int k = starti; k < i; k++) {
                xmax[k] = roww;
                ymax[k] = sumh - vGap;
            }

            for (i = 0; i < nmembers; i++) {
                Component m = target.getComponent(i);
                if (m.isVisible()) {
                    Dimension d = m.getPreferredSize();
                    if (this.vAlign == TOP) {
                        y = ypos[i] + insets.top;
                    }
                    if (this.vAlign == BOTTOM) {
                        y = ypos[i] + insets.top + maxheight - ymax[i];
                    }
                    if (this.vAlign == CENTER) {
                        y = ypos[i] + insets.top + maxheight / 2 - ymax[i] / 2;
                    }
                    if (this.hAlign == LEFT) {
                        x = xpos[i] + insets.left;
                    }
                    if (this.hAlign == RIGHT) {
                        x = xpos[i] + insets.left + maxwidth - sumw + xmax[i] - d.width;
                    }
                    if (this.hAlign == CENTER) {
                        x = xpos[i] + insets.left + maxwidth / 2 - sumw / 2 + xmax[i] / 2 - d.width / 2;
                    }

//					m.reshape(x, y, d.width, d.height);
                    m.setBounds(x, y, d.width, d.height);
                }

            }
        }
    }

    @Override
    public String toString() {
        String str = "";
        switch (hAlign) {
            case LEFT:
                str = ",halign=left";
                break;
            case CENTER:
                str = ",halign=center";
                break;
            case RIGHT:
                str = ",halign=right";
                break;
        }
        return "VFlowLayout[hgap=" + hGap + ",vgap=" + vGap + str + "]";
    }

    @Override
    public void addLayoutComponent(String name, Component comp) { }

    @Override
    public void removeLayoutComponent(Component comp) { }

}
