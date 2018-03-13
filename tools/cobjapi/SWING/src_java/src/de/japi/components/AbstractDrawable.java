package de.japi.components;

import de.japi.Japi2;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import javax.swing.JComponent;

/**
 * Abstraction for a element which paints itself. <span style="color:red;">Do
 * not use the {@link JComponent#paint(java.awt.Graphics)} method or the
 * {@link JComponent#paintComponents(java.awt.Graphics)}.</span> Use instead
 * this class as super class and implement the required 
 * {@link #draw(java.awt.Graphics2D, int, int)} method. This method is executed
 * in an protected environment and accelerations are applied automatically if
 * turned on (see {@link Japi2#isOptimizationEnabled()}).
 */
public abstract class AbstractDrawable extends JComponent {

    @Override
    public final void paint(Graphics g) {
        super.paint(g);
    }

    @Override
    public final void paintAll(Graphics g) {
        super.paintAll(g);
    }

    @Override
    protected final void paintBorder(Graphics g) {
        super.paintBorder(g);
    }

    @Override
    protected final void paintChildren(Graphics g) {
        super.paintChildren(g);
    }

    @Override
    public final void paintComponents(Graphics g) {
        super.paintComponents(g);
    }
    
    /**
     * Triggers an repaint of the canvas.
     */
    public void triggerRepaint() {
        super.repaint(0, 0, getWidth(), getHeight());
    }

    @Override
    public final void paintComponent(Graphics g) {
        super.paintComponent(g);
        
        // If optimization enabled, turn the anti-alias on
        if (Japi2.getInstance().isOptimizationEnabled()) {
            ((Graphics2D) g).setRenderingHint(
                    RenderingHints.KEY_ANTIALIASING, 
                    RenderingHints.VALUE_ANTIALIAS_ON
            );
            ((Graphics2D) g).setRenderingHint(
                    RenderingHints.KEY_TEXT_ANTIALIASING, 
                    RenderingHints.VALUE_TEXT_ANTIALIAS_ON
            );
        }
        
        // Delegate to abstract method
        try {
            draw((Graphics2D) g, getWidth(), getHeight());
        } catch (Exception ex) {
            Japi2.getInstance().debug("Failed to render component {0} "
                    + "(exception occured)", toString(), ex);
        }
    }
    
    /**
     * The main draw method to draw this component. This method might throw an
     * exception.
     * 
     * @param g the {@link Graphics2D} object to draw on.
     * @param w the width of the component.
     * @param h the height of the component.
     */
    protected abstract void draw(Graphics2D g, int w, int h);
    
}
