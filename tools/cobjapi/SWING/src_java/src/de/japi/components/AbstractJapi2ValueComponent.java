package de.japi.components;

import de.japi.Japi2;
import java.awt.Dimension;

/**
 * Abstraction of a component displaying integer values in a complex diagram 
 * ({@link Japi2SevenSegment}, {@link Japi2Led}, {@link Japi2Meter}) which 
 * provides convenience methods for common properties of the subclasses.
 */
public abstract class AbstractJapi2ValueComponent extends AbstractDrawable {

    /**
     * Value of the components and bounds.
     */
    protected int value, min, max;
    
    /**
     * Fills the attributes with default values. 
     */
    public AbstractJapi2ValueComponent() {
        value = 0;
        min = 0;
        max = 100;
    }

    /**
     * Returns the current value of this component.
     * 
     * @return the current value.
     */
    public int getValue() {
        return value;
    }

    /**
     * Sets the current value of this component.
     * 
     * @param value the value for this component. If the given value is not in
     * the interval <code>[min, max]</code>, the lower or upper bound will be
     * set instead.
     */
    public void setValue(int value) {
        this.value = Math.max(min, Math.max(value, min));
    }

    /**
     * Returns the currently set lower bound for <code>value</code>.
     * 
     * @return the lower bound currently active.
     */
    public int getMin() {
        return min;
    }

    /**
     * Sets the lower bound for <code>value</code> to the given value.
     * 
     * @param min the new lower bound.
     */
    public void setMin(int min) {
        this.min = min;
    }

    /**
     * Returns the currently set upper bound for <code>value</code>.
     * 
     * @return the upper bound currently active.
     */
    public int getMax() {
        return max;
    }

    /**
     * Sets the upper bound for <code>value</code> to the given value.
     * 
     * @param max the new upper bound.
     */
    public void setMax(int max) {
        this.max = max;
    }

    @Override
    public void setSize(int width, int height) {
        super.setSize(Math.max(0, width), Math.max(0, height));
    }
    

    @Override
    public Dimension getPreferredSize() {
        return new Dimension(
                Math.max(0, super.getSize().width),
                Math.max(0, super.getSize().height)
        );
    }

    @Override
    public Dimension getMinimumSize() {
        return getPreferredSize();
    }

    @Override
    public Dimension getMaximumSize() {
        return getPreferredSize();
    }
    
    /**
     * Tests if optimized rendering is enabled. 
     * 
     * @return <code>true</code> if optimized rendering should be used (slower 
     * but nicer) and otherwise <code>false</code> if the graphics should be
     * rendered normally (faster but ugly).
     */
    public static boolean isOptimizationEnabled() {
        return Japi2.getInstance().isOptimizationEnabled();
    }
    
}
