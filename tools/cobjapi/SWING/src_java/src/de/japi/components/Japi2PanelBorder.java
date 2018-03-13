package de.japi.components;

import de.japi.Japi2Constants;
import java.awt.Color;
import java.awt.Component;
import java.awt.Graphics;
import java.awt.Insets;
import javax.swing.JPanel;
import javax.swing.border.AbstractBorder;

/**
 * A simple custom border implementation to provide the four border types for
 * a {@link JPanel} as defined in the JAPI kernel documentation.
 */
public class Japi2PanelBorder extends AbstractBorder {
    
    /**
     * The base color for the border.
     */
    private final Color color;
    
    /**
     * The type of the border.
     */
    private final int type;

    /**
     * Constructs a new {@link Japi2PanelBorder} instance.
     * 
     * @param color the {@link Color} of the border.
     * @param type the type of the border.
     */
    public Japi2PanelBorder(Color color, int type) {
        this.color = color;
        this.type = type;
    }

    @Override
    public void paintBorder(Component c, Graphics g, int x, int y, int width, 
            int height) {
        super.paintBorder(c, g, x, y, width, height);
        g.setColor(color);
        switch (type) {
            case (Japi2Constants.J_LINEDOWN):
                g.draw3DRect(1, 1, width - 2, height - 2, false);
                g.draw3DRect(2, 2, width - 4, height - 4, true);
                break;
            case (Japi2Constants.J_LINEUP):	
                g.draw3DRect(1, 1, width - 2, height - 2, true);
                g.draw3DRect(2, 2, width - 4, height - 4, false);
                break;
            case (Japi2Constants.J_AREADOWN):
                g.draw3DRect(1, 1, width - 2, height - 2, false);
                break;
            case (Japi2Constants.J_AREAUP):
                g.draw3DRect(1, 1, width - 2, height - 2, true);
        }
    }

    @Override
    public Insets getBorderInsets(Component c) {
        return getBorderInsets(c, new Insets(4, 4, 4, 4));
    }

    @Override
    public Insets getBorderInsets(Component c, Insets insets) {
        insets.left = insets.top = insets.right = insets.bottom = 4;
        return insets;
    }

    @Override
    public boolean isBorderOpaque() {
        return true;
    }
    
}
