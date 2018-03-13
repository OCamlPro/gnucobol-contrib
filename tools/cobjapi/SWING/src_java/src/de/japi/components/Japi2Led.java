package de.japi.components;

import de.japi.Japi2;
import de.japi.Japi2Constants;
import java.awt.Color;
import java.awt.Graphics2D;

/**
 * A LED component for SWING. 
 */
public class Japi2Led extends AbstractJapi2ValueComponent {

    /**
     * The form of the led (either round or rect)
     */
    private final int ledForm;
    
    /**
     * The color of the led if it is turned off.
     */
    private Color ledColorOff;
    
    public Japi2Led(Color ledColor, int ledForm) {
        Japi2.ensureIsIn(
                ledForm, 
                Japi2Constants.J_ROUND,
                Japi2Constants.J_RECT
        );
        this.ledForm = ledForm;
        if (ledForm == Japi2Constants.J_RECT) {
            setSize(20, 15);
        } else {
            setSize(15, 15);
        }
        setForeground(ledColor);
    }

    /**
     * An alias for <code>setOn(value != 0)</code>.
     * 
     * @param value turns this led on if the value is not 0 and in case the 
     * value is 0 the led is turned of.
     */
    @Override
    public void setValue(int value) {
        setOn(value != 0);
    }

    /**
     * Turns the led on or off and repaints the scene.
     * 
     * <p>
     * This is an  replacement for <code>public void setState(boolean b)</code>
     * of <code>JAPI_Led</code>.
     * </p>
     * 
     * @param on <code>true</code>the led is turned on. This means the value of
     * the superclass {@link AbstractJapi2ValueComponent} is set to 0xff. If
     * <code>false</code> is given the value is set to 0x00 and the led is 
     * turned off.
     */
    public void setOn(boolean on) {
        int oldValue = value;
        super.setValue(on ? 255 : 0);
        if (value != oldValue) {
            repaint();
        }
    }
    
    /**
     * Determines if this led is currently turned on. This method replaces the
     * Method <code>public boolean getState()</code> of <code>JAPI_Led</code> 
     * due to the fact that the term "state" is not appropriate here.
     * 
     * <p>
     * This method is an alias for: <code>getValue() == 0xff</code>.
     * </p>
     * 
     * @return <code>true</code> if the led is turned on and otherwise 
     * <code>false</code>.
     */
    public boolean isOn() {
        return value == 0xff;
    }

    @Override
    public void setForeground(Color fg) {
        super.setForeground(fg);
        ledColorOff = new Color(fg.getRed()/3, fg.getGreen()/3, fg.getBlue()/3);
        repaint();
    }

    @Override
    protected void draw(Graphics2D g, int w, int h) {
        if(ledForm == Japi2Constants.J_RECT) {
            g.setColor(ledColorOff);
            g.draw3DRect(0, 0, w-1, h-1, true);
            g.draw3DRect(1, 1, w-3, h-3, true);
            g.setColor(isOn() ? getForeground() : ledColorOff);
            g.fillRect(2, 2, w-4, h-4);
            g.setColor(Color.black);
            g.drawRect(0, 0, w, h);
        } else {
            g.setColor(ledColorOff);
            g.fillOval(0, 0, w-1, h-1);
            g.setColor(Color.black);
            g.drawOval(0, 0, w-1, h-1);
            g.setColor(isOn() ? getForeground() : ledColorOff);
            g.fillOval(2, 2, w-5, h-5);
            g.setColor(Color.white);
            g.fillOval(w/4, h/4, 3, 3);
        }
    }
    
}
