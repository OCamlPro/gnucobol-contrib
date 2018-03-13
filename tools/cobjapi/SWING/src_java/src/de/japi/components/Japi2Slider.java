package de.japi.components;

import de.japi.Japi2;
import java.awt.AWTEventMulticaster;
import java.awt.Adjustable;
import java.awt.event.AdjustmentEvent;
import java.awt.event.AdjustmentListener;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import javax.swing.JLabel;
import javax.swing.JSlider;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

/**
 * This component wraps a JSlider and adds a further feature: this class 
 * implements the {@link Adjustable} interface to be fully compatible to the 
 * JAPI2 kernel.
 */
public class Japi2Slider extends JSlider implements Adjustable, ChangeListener {
    
    /**
     * List of {@link AdjustmentListener}s listening on this object.
     */
    private final List<AdjustmentListener> adjustmentListenerList;
    
    boolean isHorizontal;
    
    /**
     * Creates a new JSlider component.
     * 
     * @param isHorizontal <code>true</code> if the slider should slide 
     * horizontally otherwise <code>false</code>.
     */
    public Japi2Slider(boolean isHorizontal) {
        super(isHorizontal ? JSlider.HORIZONTAL : JSlider.VERTICAL);
        this.isHorizontal = isHorizontal;
        adjustmentListenerList = new ArrayList<AdjustmentListener>();
        addChangeListener(this);
        setMinimum(0);
        setMaximum(100);
        setValue(0);
        setOpaque(false);
    }

    @Override
    public final void setMinimum(int minimum) {
        super.setMinimum(minimum);
        adjustTicks();
    }

    @Override
    public final void setMaximum(int maximum) {
        super.setMaximum(maximum);
        adjustTicks();
    }
    
    /**
     * This method adjusts the spacing of the ticks and the displayed min and 
     * max value.
     */
    private void adjustTicks() {
        if (isHorizontal) {
            // Create a Hashtable with the first and the last value to display
            Hashtable labelTable = new Hashtable();
            labelTable.put(new Integer(getMinimum()), 
                    new JLabel(String.valueOf(getMinimum())));
            labelTable.put(new Integer(getMaximum()), 
                    new JLabel(String.valueOf(getMaximum())));
            setLabelTable(labelTable);
            setPaintLabels(true);
        } else {
            setPaintLabels(false);
        }

        // Set other properties
        setSnapToTicks(false);
        setPaintTicks(true);
        setMajorTickSpacing((int) ((getMaximum() - getMinimum()) * 0.10d));
    }

    @Override
    public void setUnitIncrement(int u) {
        Japi2.getInstance().debug("setUnitIncrement({0}) for "
                + "Japi2Slider not supported!", u);
    }

    @Override
    public int getUnitIncrement() {
        return 1;
    }

    @Override
    public void setBlockIncrement(int b) {
        Japi2.getInstance().debug("setBlockIncrement({0}) for "
                + "Japi2Slider not supported!", b);
    }

    @Override
    public int getBlockIncrement() {
        return 1;
    }

    @Override
    public void setVisibleAmount(int v) {
        Japi2.getInstance().debug("setVisibleAmount({0}) for "
                + "Japi2Slider not supported!", v);
    }

    @Override
    public int getVisibleAmount() {
        return 1;
    }

    @Override
    public void addAdjustmentListener(AdjustmentListener l) {
        adjustmentListenerList.add(l);
    }

    @Override
    public void removeAdjustmentListener(AdjustmentListener l) {
        adjustmentListenerList.remove(l);
    }

    @Override
    public void stateChanged(ChangeEvent evt) {
        // Forward the event
        for (AdjustmentListener a : adjustmentListenerList) {
            a.adjustmentValueChanged(new AdjustmentEvent(
                    this, 
                    AdjustmentEvent.ADJUSTMENT_VALUE_CHANGED, 
                    AdjustmentEvent.TRACK, 
                    getValue()
            ));
        }
    }

    @Override
    public String toString() {
        return "Slider[" + getMinimum() + " -| " + getValue() 
                + " |-> " + getMaximum() + "]";
    }
    
}
