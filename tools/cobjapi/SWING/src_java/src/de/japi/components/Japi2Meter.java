package de.japi.components;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import javax.swing.UIManager;

/**
 * This is a SWING component to provide a gauge meter GUI component which is
 * controlled by a single value (sets the pointer).
 */
public class Japi2Meter extends AbstractJapi2ValueComponent {

    /**
     * The title to display in the middle of the gauge.
     */
    private String title;
    
    /**
     * Integer values needed for computation.
     */
    private int dangerValue, oldValue, radius;
    
    /**
     * Arc value.
     */
    private double arc;
    
    /**
     * Constructs a new gauge meter. If optimized rendering is enabled the 
     * background is painted lighter than the normal panel background (see
     * {@link AbstractJapi2ValueComponent#isOptimizationEnabled()}).
     * 
     * @param title the title to display, not <code>null</code>.
     */
    public Japi2Meter(String title) {
        setTitle(title);
        setSize(new Dimension(150, 120));
        setPreferredSize(new Dimension(150, 120));
        setFont(new Font(Font.DIALOG, Font.PLAIN, 12));
        this.dangerValue = 80;
        if (AbstractJapi2ValueComponent.isOptimizationEnabled()) {
            setBackground(UIManager.getColor("Panel.background").brighter());
        }
    }
    
    /**
     * Returns the danger value. The zone between <code>dangerValue</code> and
     * <code>max</code> is considered as danger zone. If <code>value</code> gets
     * into this zone the pointer gets red. Also this zone is marked red on
     * the scale.
     * 
     * @return lower bound of the dangerous zone.
     */
    public int getDangerValue() {
        return dangerValue;
    }

    /**
     * Sets the danger zone. See {@link #getDangerValue()} for information.
     * 
     * @param dangerValue lower bound of the dangerous zone.
     */
    public void setDangerValue(int dangerValue) {
        this.dangerValue = dangerValue;
    }

    /**
     * Sets the title to display on the gauge meter.
     * 
     * @param title the title to display, not <code>null</code>.
     */
    public final void setTitle(String title) {
        if (title == null) {
            throw new NullPointerException("Title can't be null");
        }
        this.title = title;
    }

    @Override
    public void setValue(int value) {
        oldValue = super.value;
        super.setValue(value);
        if (oldValue != value) {
            repaint();
        }
    }
    
    @Override
    protected void draw(Graphics2D g, int w, int h) {
        // Compute key values
        radius = (int) (0.7*h);
        if((int) (0.4*w) < radius) {
            arc = Math.asin((0.4*w)/radius);
        } else {
            arc = Math.PI/2d;
        }
	
        // Fill background
        g.setColor(getBackground());
        g.fillRect(0, 0, w, h);
        
        // Draw other components
    	drawTics(g, w, h);
    	drawText(g, w, h);
    	drawPointer(g, w, h);
        
        // Draw border around
        g.setColor(getBackground().darker().darker());
        g.drawRect(0, 0, w-1, h-1);
        g.setColor(getBackground());
        g.draw3DRect(1, 1, w-3, h-3, false);
        g.draw3DRect(2, 2, w-5, h-5, false);
    }

    /**
     * Draw the tick marks and the danger zone.
     * 
     * @param g the {@link Graphics} object to draw onto.
     * @param w the width of the component.
     * @param h the height of the component.
     */
    private void drawTics(Graphics g, int w, int h) {
        // Draw the danger zone mark
        if(dangerValue > min && dangerValue < max) {
            g.setColor(Color.red);
            int langle = (int) Math.round(
                    2*arc/Math.PI*180*(double)(max - dangerValue)/
                            (double)(max - min)
            );
            g.fillArc(
                    (int) (0.5*w-radius), 
                    (int) (0.8*h-radius), 
                    2*radius,2*radius, 
                    (int) Math.round(90-arc/Math.PI*180), 
                    langle
            );
            g.setColor(getBackground());
            g.fillArc(
                    (int) (0.5*w-0.97*radius), 
                    (int) (0.8*h-0.97*radius), 
                    (int) (1.94*radius), 
                    (int) (1.94*radius), 
                    (int) Math.round(90-arc/Math.PI*180)-10, 
                    langle+20
            );
        }

        g.setColor(getForeground());
       	g.setClip(
                (int) (0.5*w-Math.sin(arc)*radius),
                (int) (0.1*h),
                (int) (2*Math.sin(arc)*radius)+1,
                (int) (radius-Math.cos(arc)*radius)+1
        );
        g.drawOval(
                (int) (0.5*w-radius),
                (int) (0.8*h-radius),
                2*radius,
                2*radius
        );
        g.setClip(0, 0, w, h);
        g.fillOval(w/2-5, (int) (0.8*h)-5, 10, 10);

    	// Draw about 20 tick marks
    	double a = arc;
        int innerRadius = (int) (radius - (radius / 15));
     	int middleRadius = (int) (radius - (radius / 30));
    	for (int i=0; i<=20; i++, a -= (2*arc)/20) {
            int x2,y2;
            int x1 = (int) (0.5*w - Math.sin(a)*radius);
            int y1 = (int) (0.8*h - Math.cos(a)*radius);
            if (i%5 == 0) { 
                x2 = (int) (0.5*w - Math.sin(a)*innerRadius);
                y2 = (int) (0.8*h - Math.cos(a)*innerRadius);
            } else { 
                x2 = (int) (0.5*w - Math.sin(a)*middleRadius);
                y2 = (int) (0.8*h - Math.cos(a)*middleRadius);
            }
            g.drawLine(x1, y1, x2, y2);
    	}
    }

    /**
     * Draw the labels for the ticks and the main title of the gauge meter.
     * 
     * @param g the {@link Graphics} object to draw onto.
     * @param w the width of the component.
     * @param h the height of the component.
     */
    private void drawText(Graphics g, int w, int h) {
    	int stringWidth = g.getFontMetrics().stringWidth(title);
    	int stringHeight =  g.getFontMetrics().getHeight();

        // Display minimal value
     	g.setColor(getForeground());
    	g.drawString(title, (w-stringWidth)/2, (h/2)+stringHeight);
    	stringWidth = g.getFontMetrics().stringWidth(String.valueOf(min));
    	g.drawString(
                String.valueOf(min),
                (int) (0.5*w - Math.sin(arc)*0.8*radius - stringWidth/2),
                (int) (0.8*h - Math.cos(arc)*0.8*radius + stringHeight/2)
        );

        // Display value in half of [min, max]
    	stringWidth = g.getFontMetrics().stringWidth(
                String.valueOf((int) (0.5*(max + min)))
        );
    	g.drawString(
                String.valueOf((int)(0.5*(max+min))),
                (int) (0.5*w - stringWidth/2),
                (int) (0.8*h - 0.8*radius + stringHeight/2)
        );

        // Display maximal value
    	stringWidth = g.getFontMetrics().stringWidth(String.valueOf(max));
    	g.drawString(
                String.valueOf(max),
                (int) (0.5*w + Math.sin(arc)*0.8*radius  - stringWidth/2),
                (int) (0.8*h - Math.cos(arc)*0.8*radius + stringHeight/2)
        );
    }

    /**
     * Draws the pointer of the gauge meter.
     * 
     * @param g the {@link Graphics} object to draw onto.
     * @param w the width of the component.
     * @param h the height of the component.
     */
    private void drawPointer(Graphics g, int w, int h) {
     	double a = arc-((double)(oldValue-min)/(double)(max - min))*(2*arc);
      	int x = (int) (0.5*w - Math.sin(a)*radius*0.9);
        int y = (int) (0.8*h - Math.cos(a)*radius*0.9);
        if(oldValue < dangerValue && dangerValue > min) {
            g.setColor(getForeground());
        } else {
            g.setColor(Color.red);
        }
    	g.drawLine((int) (0.5*w), (int) (0.8*h), x, y);
    	g.setColor(Color.orange);
        g.fillOval(w/2-5, (int) (0.8*h)-5, 10, 10);
    }

    @Override
    public String toString() {
        return "Meter[title=" + title + ",value=" + value + ",min=" + min 
                + ",max=" + max  + ",optimization? " 
                + AbstractJapi2ValueComponent.isOptimizationEnabled() + "]";
    }
    
}
