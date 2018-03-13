package de.japi.components;

import de.japi.components.AbstractJapi2ValueComponent;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Polygon;
import java.awt.geom.AffineTransform;

/**
 * Seven-segment display component for SWING. This component displays a single
 * seven-segment "character". Values are set through {@link #setValue(int)} and
 * range from <code>0 (0x0)</code> to <code>15 (0xf)</code>.
 * 
 * <p>
 * This component supports optimized rendering. See {@link AbstractJapi2ValueComponent} 
 * for more information. Once optimized rendering is enabled, this component
 * is drawn with anti-alias and a slightly sheared to match real seven-segement
 * displays.
 * </p>
 */
public class Japi2SevenSegment extends AbstractJapi2ValueComponent {
    
    /**
     * Indicates if a specific segement of the seven-segment display is turned
     * on for a numeric value. The numeric value is the first index of the 
     * array and ranges from <code>0 (0x0)</code> to <code>15 (0xf)</code>.
     */
    private static final int CODEPAGE[][] = {
        {1,1,0,1,1,1,1}, {0,0,0,1,0,0,1}, {1,0,1,1,1,1,0}, {1,0,1,1,0,1,1},
        {0,1,1,1,0,0,1}, {1,1,1,0,0,1,1}, {1,1,1,0,1,1,1}, {1,0,0,1,0,0,1},
        {1,1,1,1,1,1,1}, {1,1,1,1,0,1,1}, {1,1,1,1,1,0,1}, {0,1,1,0,1,1,1},
        {1,1,0,0,1,1,0}, {0,0,1,1,1,1,1}, {1,1,1,0,1,1,0}, {1,1,1,0,1,0,0}
    };
    
    /**
     * Color array containing the background (index 0) and foreground (index 1)
     * color of the component.
     */
    private final Color[] colors = new Color[2];
        
    /**
     * Constructs a new seven-segment display.
     * 
     * @param segmentColor the color of the segments turned on.
     */
    public Japi2SevenSegment(Color segmentColor) {
        super.setSize(20, 40);
        super.setBackground(Color.black);
        setForeground(segmentColor);
    }

    @Override
    public final void setForeground(Color fg) {
        super.setForeground(fg);
        colors[1] = fg;
        colors[0] = new Color(
                (9*getBackground().getRed()+fg.getRed())/10,
                (9*getBackground().getGreen()+fg.getGreen())/10,
                (9*getBackground().getBlue()+fg.getBlue())/10
        );
    }

    @Override
    public final void setBackground(Color bg) {
        super.setBackground(bg);
        colors[0] = new Color(
                (9*bg.getRed()+colors[1].getRed())/10,
                (9*bg.getGreen()+colors[1].getGreen())/10,
                (9*bg.getBlue()+colors[1].getBlue())/10
        );
    }

    /**
     * Sets the value to display by this seven-segment display.
     * 
     * @param value the value to display, ranging from <code>0 (0x0)</code> to 
     * <code>15 (0xf)</code>. Negative values are turned automatically into
     * positive values.
     */
    @Override
    public void setValue(int value) {
        super.setValue(Math.abs(value) % 16);
        repaint();
    }
    
    @Override
    protected void draw(Graphics2D g, int w, int h) {
        // Fill background
        g.setColor(getBackground());
        g.fillRect(0, 0, w, h);
        
        // Test if the image should be sheared
        double translateX = w*0.035, shearX = -0.07;
        if (AbstractJapi2ValueComponent.isOptimizationEnabled()) {
            g.translate(translateX, 0);
            g.transform(AffineTransform.getShearInstance(shearX, 0));
        }
        
        // Draw the seven segment display
        double pwgt=0.12;
        int wgt= (int)(pwgt*(h/2)<pwgt*w ? pwgt*(h/2) : pwgt*w);
        int border = wgt;
        int lsep = wgt/10+2;
     	int sw = w-(border+border);
    	int sh = h-(border+border);
      	int hlen = sw-wgt;
       	int vlen = (sh-wgt)/2;

        // Horizontal segments
        Polygon p = new Polygon();
        p.addPoint(border+wgt/2+lsep,border+wgt/2+1);
        p.addPoint(border+wgt+lsep,border);
        p.addPoint(border+hlen-lsep,border);
        p.addPoint(border+hlen+wgt/2-lsep,border+wgt/2+1);
        p.addPoint(border+hlen-lsep,border+wgt+1);
        p.addPoint(border+wgt+lsep,border+wgt+1);

        g.setColor(colors[CODEPAGE[value][0]]);
        g.fillPolygon(p);

        g.setColor(colors[CODEPAGE[value][2]]);
        p.translate(0, vlen-1);
        g.fillPolygon(p);

        g.setColor(colors[CODEPAGE[value][5]]);
        p.translate(0, vlen-1);
        g.fillPolygon(p);

      	// Vertical segments
    	p = new Polygon();
        p.addPoint(border+wgt/2+1,border+wgt/2+lsep);
    	p.addPoint(border,border+wgt+lsep);
    	p.addPoint(border,border+vlen-lsep);
    	p.addPoint(border+wgt/2+1,border+vlen+wgt/2-lsep);
    	p.addPoint(border+wgt+1,border+vlen-lsep);
    	p.addPoint(border+wgt+1,border+wgt+lsep);

    	g.setColor(colors[CODEPAGE[value][1]]);
    	g.fillPolygon(p);

    	g.setColor(colors[CODEPAGE[value][3]]);
    	p.translate(hlen-1, 0);
    	g.fillPolygon(p);

    	g.setColor(colors[CODEPAGE[value][6]]);
    	p.translate(0, vlen-1);
    	g.fillPolygon(p);

    	g.setColor(colors[CODEPAGE[value][4]]);
    	p.translate(-(hlen-1), 0);
    	g.fillPolygon(p);
        
        // Test if the image should be sheared
        if (AbstractJapi2ValueComponent.isOptimizationEnabled()) {
            g.translate(-translateX, 0);
            g.transform(AffineTransform.getShearInstance(-shearX, 0));
        }
    }

    @Override
    public String toString() {
        return "SevenSegment[value=" + value + ",min=" + min + ",max=" + max 
                + ",optimization? " + AbstractJapi2ValueComponent
                        .isOptimizationEnabled() + "]";
    }
    
}
