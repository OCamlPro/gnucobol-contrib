/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.japi.components;

import de.japi.Japi2Constants;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;

/**
 * Custom made component to display a horizontal or vertical line as
 * seperator.
 */
public class Japi2Ruler extends AbstractDrawable {

    private int w = 0, h = 0, orient = Japi2Constants.J_HORIZONTAL, 
            style = Japi2Constants.J_LINEUP;

    /**
     * Creates a new "ruler".
     * 
     * @param o the orientation (J_HORIZONTAL, J_VERTICAL).
     * @param s the style (J_LINEDOWN, J_LINEUP).
     * @param len the length (in pixel).
     */
    public Japi2Ruler(int o, int s, int len) {
        super();
        orient = o;
        style = s;
        if (orient == Japi2Constants.J_HORIZONTAL) {
            setSize(len, 4);
        } else {
            setSize(4, len);
        }
    }

    @Override
    public void setBounds(int x, int y, int dw, int dh) {
        w = dw > 0 ? dw : 0;
        h = dh > 0 ? dh : 0;
        super.setBounds(x, y, dw, dh);
    }

    @Override
    public final void setSize(int dw, int dh) {
        w = dw > 0 ? dw : 0;
        h = dh > 0 ? dh : 0;
        super.setSize(dw, dh);
    }

    @Override
    public Dimension getPreferredSize() {
        Dimension dim = super.getPreferredSize();
        dim.width = w > 0 ? w : dim.width;
        dim.height = h > 0 ? h : dim.height;
        return (dim);
    }

    @Override
    public Dimension getMinimumSize() {
        Dimension dim = super.getMinimumSize();
        dim.width = w > 0 ? w : dim.width;
        dim.height = h > 0 ? h : dim.height;
        return (dim);
    }
    
    @Override
    protected void draw(Graphics2D g, int w, int h) {
        if (orient == Japi2Constants.J_HORIZONTAL) {
            if (style == Japi2Constants.J_LINEUP) {
                g.setColor(Color.white);
                g.drawLine(0, h / 2 - 1, w, h / 2 - 1);
                g.setColor(Color.darkGray);
                g.drawLine(0, h / 2, w, h / 2);
            } else {
                g.setColor(Color.darkGray);
                g.drawLine(0, h / 2 - 1, w, h / 2 - 1);
                g.setColor(Color.white);
                g.drawLine(0, h / 2, w, h / 2);
            }
        } else //J_VERTICAL
        {
            if (style == Japi2Constants.J_LINEUP) {
                g.setColor(Color.white);
                g.drawLine(w / 2 - 1, 0, w / 2 - 1, h);
                g.setColor(Color.darkGray);
                g.drawLine(w / 2, 0, w / 2, h);
            } else {
                g.setColor(Color.darkGray);
                g.drawLine(w / 2 - 1, 0, w / 2 - 1, h);
                g.setColor(Color.white);
                g.drawLine(w / 2, 0, w / 2, h);
            }
        }
    }

}
