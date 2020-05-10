package de.japi.components;

import de.japi.components.listeners.Japi2ComponentListener;
import java.awt.Color;
import java.awt.Composite;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Image;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GraphicsConfiguration;
import java.awt.Paint;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.Shape;
import java.awt.Stroke;
import java.awt.font.FontRenderContext;
import java.awt.font.GlyphVector;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.awt.image.BufferedImageOp;
import java.awt.image.ImageObserver;
import java.awt.image.RenderedImage;
import java.awt.image.renderable.RenderableImage;
import java.text.AttributedCharacterIterator;
import java.util.Map;

/**
 * This class is a simple SWING implemenation for {@link Japi2Canvas} to match 
 * the needs of the original JAPI kernel. It contains a sophisticated repaint 
 * strategy to save performance.
 * 
 * <p>
 * Graphic calls or the execution of graphic primitives (i.e. drawing a circle) 
 * on this canvas occur with a specific pattern: for a short time period the 
 * graphic primitives are invoked and for the other time nothing is manipulated.
 * It stands to reason that only everytime a graphic primitive is invoked the
 * canvas gets repainted through a {@link #repaint()} call. But those periods
 * with many graphic calls are very short and contain lots of updates (e.g. see
 * example <code>mandel</code> or <code>canvas</code> of JAPI kernel examples).
 * So if the {@link #repaint()} method is called every time a graphic primitive
 * is executed the repaint event queue would get jammed. Instead the method
 * {@link #triggerUpdate()} is called. This method only calls every
 * {@link #REPAINT_INTERVAL} milliseconds the {@link #repaint()} method 
 * (ignoring how often this method is called) and avoids that the repaint event 
 * queue gets jammed. Due to the fact that the last graphic primitive (for a 
 * longer time) will be not exactly at the end of a time period, the last 
 * changes might not be painted onto the screen. So a watchdog executed another
 * {@link #REPAINT_INTERVAL} milliseconds after the last graphic manipulation
 * calls then the {@link #repaint()} method to bring the last changes onto the
 * screen. This call is omitted iff no other graphic manipulation happend in
 * the last {@link #REPAINT_INTERVAL} milliseconds.
 * </p>
 * 
 * <p>
 * This repaint management <i>algorithm</i> makes it possible, that this canvas
 * consumes almost no CPU when no graphic manipulation is going on. Through the
 * setting of {@link #REPAINT_INTERVAL} one can control the CPU load when the
 * graphic gets manipulated. If this number is smaller the CPU load is higher.
 * </p>
 */
public class Japi2Canvas extends AbstractDrawable {

    /**
     * Time interval to trigger an {@link #repaint()} event.
     */
    private static final int REPAINT_INTERVAL = 42;
    
    /**
     * The buffered image.
     */
    private BufferedImage buffer;
    
    /**
     * The graphic of the buffered image.
     */
    private Graphics2D bufferGraphics;
    
    /**
     * The external {@link Graphics2D} object for external access. All methods
     * trigger the {@link #triggerUpdate()} method when the graphic is modified
     * to update it on the screen.
     */
    private Japi2Graphics externalGraphics;
    
    /**
     * The foreground color.
     */
    private int fgColor;
    
    /**
     * The color for the XOR mode.
     */
    private Color xorColor;
    
    /**
     * Indicator if the graphic buffer image is valid.
     */
    private boolean isValidBuffer;
    
    /**
     * Clip rectangle.
     */
    private Rectangle clip;
    
    /**
     * Translate coordinates.
     */
    private int translateX, translateY;
    
    /**
     * Temporal variables to manage repaint.
     */
    private long lastRepaint, nextRepaint;
    
    /**
     * Repaint watchdog thread.
     */
    private final Thread repaintWatchdog;
    
    /**
     * Constructs a new canvas drawing area.
     * 
     * @param width the width of the canvas.
     * @param height the height of the canvas.
     */
    public Japi2Canvas(int width, int height) {
        isValidBuffer = false;
        setSize(width, height);
        setBackground(Color.white);
        setForeground(Color.black);
        triggerUpdate();
        
        // This watchdog is responsible for repainting the canvas after the last
        // block of graphic manipulation calls.
        repaintWatchdog = new Thread(new Runnable() {

            @Override
            public void run() {
                while (!Thread.interrupted()) {
                    if (nextRepaint == 0) {
                        try {
                            Thread.sleep(100);
                        } catch (Exception ex) {
                            // Ignore
                        }
                        continue;
                    }
                    
                    if (nextRepaint > System.currentTimeMillis()) {
                        try {
                            Thread.sleep(nextRepaint-System.currentTimeMillis());
                        } catch (Exception ex) {
                            // Ignore
                        }
                    } else {
                        triggerRepaint();
                        nextRepaint = 0;
                    }
                }
            }
        });
        repaintWatchdog.start();
    }
    
    /**
     * Is called by the {@link Japi2ComponentListener} if the parent container
     * is resized to resize this canvas.
     */
    public final void notifyResized() {
        update(getSize().width, getSize().height);
    }
    
    @Override
    public synchronized final void setSize(int width, int height) {
        super.setSize(Math.max(0, width), Math.max(0, height));
        super.setPreferredSize(new Dimension(Math.max(0, width), Math.max(0, height)));
        update(width, height);
    }
    
    /**
     * Updates the internal buffered canvas image to the new size. 
     * 
     * @param width the width of the new canvas.
     * @param height the height of the new canvas.
     */
    private void update(int width, int height) {
        if (width < 1 || height < 1) {
            return;
        }
        
        BufferedImage newBuffer = new BufferedImage(width, height, 
                BufferedImage.TYPE_INT_ARGB);
        Graphics2D newBufferGraphics = (Graphics2D) newBuffer.getGraphics();
        
        if (buffer != null) {
            // Copy image
            newBufferGraphics.setColor(Color.WHITE);
            newBufferGraphics.fillRect(0, 0, width, height);
            newBufferGraphics.drawImage(buffer, 0, 0, null);
            
            // Copy attributes
            newBufferGraphics.setColor(bufferGraphics.getColor());
            newBufferGraphics.setFont(bufferGraphics.getFont());
            if (xorColor == null) {
                newBufferGraphics.setPaintMode();
            } else {
                newBufferGraphics.setXORMode(xorColor);
            }
            
            // "Copy" clip
            if (clip != null && clip.width > 0 && clip.height > 0) {
                newBufferGraphics.clipRect(clip.x, clip.y, clip.width, clip.height);
            }
            
            newBufferGraphics.translate(translateX, translateY);
        }
        
        // Set "new" attributes
        buffer = newBuffer;
        if (bufferGraphics != null) {
            bufferGraphics.dispose();
        }
        bufferGraphics = newBufferGraphics;
        isValidBuffer = true;
    }

    @Override
    public final void setBackground(Color bg) {
        Color b4 = bufferGraphics.getColor();
        bufferGraphics.setColor(bg);
        bufferGraphics.fillRect(0, 0, getWidth(), getHeight());
        bufferGraphics.setColor(b4);
        triggerUpdate(); // Repaint the scene
    }

    @Override
    public final void setForeground(Color fg) {
        fgColor = fg.getRGB();
        bufferGraphics.setColor(fg);
    }

    @Override
    public Color getForeground() {
        return bufferGraphics.getColor();
    }
    
    @Override
    public void setFont(Font font) {
        bufferGraphics.setFont(font);
    }

    @Override
    public Font getFont() {
        return bufferGraphics.getFont();
    }

    @Override
    public Graphics getGraphics() {
        if (externalGraphics == null) {
            externalGraphics = new Japi2Graphics();
        }
        return externalGraphics;
    }
    
    /**
     * See {@link Graphics#setXORMode(java.awt.Color)}.
     * 
     * @param c the {@link Color} for the XOR mode.
     */
    public void setXORMode(Color c) {
        bufferGraphics.setXORMode(xorColor = c);
    }

    /**
     * See {@link Graphics#setPaintMode()}.
     */
    public void setPaintMode() {
        bufferGraphics.setPaintMode();
        xorColor = null;
    }
    
    /**
     * Tests if the screen buffer is valid.
     * 
     * @return <code>true</code> if the screen buffer is ready and otherwise
     * <code>false</code>.
     */
    public boolean waitForNewScreenBuf() {
        return isValidBuffer;
    }
    
    /**
     * Translates the graphic, see {@link Graphics2D#translate(int, int)}.
     * 
     * @param x the specified x coordinate.
     * @param y the specified y coordinate.
     */
    public void translate(int x, int y) {
        translateX += x;
        translateY += y;
        bufferGraphics.translate(x, y);
    }

    /**
     * Clips the graphic, see {@link Graphics2D#clipRect(int, int, int, int)}.
     * 
     * @param x the x coordinate of the rectangle to intersect the clip with.
     * @param y the y coordinate of the rectangle to intersect the clip with.
     * @param width the width of the rectangle to intersect the clip with.
     * @param height the height of the rectangle to intersect the clip with.
     */
    public void clipRect(int x, int y, int width, int height) {
        clip = new Rectangle(x, y, width, height);
        bufferGraphics.clipRect(x, y, width, height);
        triggerUpdate();
    }
    
    /**
     * Shortcut method to directly draw a pixel. This method is accellerated
     * in contrast to a {@link Graphics#drawLine(int, int, int, int)} call with
     * the same x- and y-coordinates since it writes directly to the 
     * underlying raster.
     * 
     * @param x the x coordinate of the pixel.
     * @param y the y coordinate of the pixel.
     */
    public void drawPixel(int x, int y) {
        try {
            buffer.setRGB(x, y, fgColor);
        } catch (Exception ex) {
            // Don't watch, outside of image (not visible)
        }
        triggerUpdate();
    }
    
    @Override
    protected void draw(Graphics2D g, int w, int h) {
        g.drawImage(buffer, 0, 0, this);
    }
    
    /**
     * Triggers a repaint event for this canvas. The actual {@link #repaint()} 
     * method call is only executed in a fixed time period. If there are many
     * updates to the graphic the repaint event queue is not overfilled.
     */
    private void triggerUpdate() {
        // Trigger a repaint only if there are pending changes and 
        // only if the last repaint was 42 seconds ago
        if ((System.currentTimeMillis() - lastRepaint) > REPAINT_INTERVAL) {
            repaint();
            lastRepaint = System.currentTimeMillis();
            nextRepaint = lastRepaint + REPAINT_INTERVAL;
        }
    }
    
    @Override
    public String toString() {
        return "Canvas[size=" + getWidth() + "x" + getHeight() + "]";
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        repaintWatchdog.interrupt();
    }
    
    public Image getImage() {
        return buffer;
    }

    public Image getImageCopy() {
        BufferedImage buf = new BufferedImage(buffer.getWidth(), 
                buffer.getHeight(), buffer.getType());
        Graphics g = buf.getGraphics();
        g.drawImage(buffer, 0, 0, null);
        g.dispose();
        return buf;
    }

    public Image getScaledImageCopy(int sx, int sy, int sw, int sh, int dw, int dh) {
        BufferedImage buf = new BufferedImage(buffer.getWidth(), 
                buffer.getHeight(), buffer.getType());
        Graphics g = buf.getGraphics();
        g.drawImage(buffer, 0, 0, dw, dh, sx, sy, sw, sh, null);
        g.dispose();
        return buf;
    }
    
    /**
     * A special {@link Graphic2D} implementation to trigger the method
     * {@link #triggerUpdate()} if a graphic command is executed. This method
     * is used to trigger a repaint.
     */
    private class Japi2Graphics extends Graphics2D {
        
        @Override
        public Graphics create() {
            Graphics g = bufferGraphics.create();
            triggerUpdate();
            return g;
        }

        @Override
        public void translate(int x, int y) {
            bufferGraphics.translate(x, y);
            triggerUpdate();
        }

        @Override
        public Color getColor() {
            return bufferGraphics.getColor();
        }

        @Override
        public void setColor(Color c) {
            bufferGraphics.setColor(c);
        }

        @Override
        public void setPaintMode() {
            bufferGraphics.setPaintMode();
        }

        @Override
        public void setXORMode(Color c1) {
            bufferGraphics.setXORMode(c1);
        }

        @Override
        public Font getFont() {
            return bufferGraphics.getFont();
        }

        @Override
        public void setFont(Font font) {
            bufferGraphics.setFont(font);
        }

        @Override
        public FontMetrics getFontMetrics(Font f) {
            return bufferGraphics.getFontMetrics(f);
        }

        @Override
        public Rectangle getClipBounds() {
            return bufferGraphics.getClipBounds();
        }

        @Override
        public void clipRect(int x, int y, int width, int height) {
            bufferGraphics.clipRect(x, y, width, height);
            triggerUpdate();
        }

        @Override
        public void setClip(int x, int y, int width, int height) {
            bufferGraphics.setClip(x, y, width, height);
            triggerUpdate();
        }

        @Override
        public Shape getClip() {
            return bufferGraphics.getClip();
        }

        @Override
        public void setClip(Shape clip) {
            bufferGraphics.setClip(clip);
            triggerUpdate();
        }

        @Override
        public void copyArea(int x, int y, int width, int height, int dx, 
                int dy) {
            bufferGraphics.copyArea(x, y, width, height, dx, dy);
            triggerUpdate();
        }

        @Override
        public void drawLine(int x1, int y1, int x2, int y2) {
            bufferGraphics.drawLine(x1, y1, x2, y2);
            triggerUpdate();
        }

        @Override
        public void fillRect(int x, int y, int width, int height) {
            bufferGraphics.fillRect(x, y, width, height);
            triggerUpdate();
        }

        @Override
        public void clearRect(int x, int y, int width, int height) {
            bufferGraphics.clearRect(x, y, width, height);
            triggerUpdate();
        }

        @Override
        public void drawRoundRect(int x, int y, int width, int height, 
                int arcWidth, int arcHeight) {
            bufferGraphics.drawRoundRect(x, y, width, height, arcWidth, 
                    arcHeight);
            triggerUpdate();
        }

        @Override
        public void fillRoundRect(int x, int y, int width, int height, 
                int arcWidth, int arcHeight) {
            bufferGraphics.fillRoundRect(x, y, width, height, arcWidth, 
                    arcHeight);
            triggerUpdate();
        }

        @Override
        public void drawOval(int x, int y, int width, int height) {
            bufferGraphics.drawOval(x, y, width, height);
            triggerUpdate();
        }

        @Override
        public void fillOval(int x, int y, int width, int height) {
            bufferGraphics.fillOval(x, y, width, height);
            triggerUpdate();
        }

        @Override
        public void drawArc(int x, int y, int width, int height, int startAngle, 
                int arcAngle) {
            bufferGraphics.drawArc(x, y, width, height, startAngle, arcAngle);
            triggerUpdate();
        }

        @Override
        public void fillArc(int x, int y, int width, int height, int startAngle, 
                int arcAngle) {
            bufferGraphics.fillArc(x, y, width, height, startAngle, arcAngle);
            triggerUpdate();
        }

        @Override
        public void drawPolyline(int[] xPoints, int[] yPoints, int nPoints) {
            bufferGraphics.drawPolyline(xPoints, yPoints, nPoints);
            triggerUpdate();
        }

        @Override
        public void drawPolygon(int[] xPoints, int[] yPoints, int nPoints) {
            bufferGraphics.drawPolygon(xPoints, yPoints, nPoints);
            triggerUpdate();
        }

        @Override
        public void fillPolygon(int[] xPoints, int[] yPoints, int nPoints) {
            bufferGraphics.fillPolygon(xPoints, yPoints, nPoints);
            triggerUpdate();
        }

        @Override
        public void drawString(String str, int x, int y) {
            bufferGraphics.drawString(str, x, y);
            triggerUpdate();
        }

        @Override
        public void drawString(AttributedCharacterIterator iterator, int x, 
                int y) {
            bufferGraphics.drawString(iterator, x, y);
            triggerUpdate();
        }

        @Override
        public boolean drawImage(Image img, int x, int y, 
                ImageObserver observer) {
            boolean retval = bufferGraphics.drawImage(img, x, y, observer);
            triggerUpdate();
            return retval;
        }

        @Override
        public boolean drawImage(Image img, int x, int y, int width, int height, 
                ImageObserver observer) {
            boolean retval = bufferGraphics.drawImage(img, x, y, width, height, 
                    observer);
            triggerUpdate();
            return retval;
        }

        @Override
        public boolean drawImage(Image img, int x, int y, Color bgcolor, 
                ImageObserver observer) {
            boolean retval = bufferGraphics.drawImage(img, x, y, bgcolor, 
                    observer);
            triggerUpdate();
            return retval;
        }

        @Override
        public boolean drawImage(Image img, int x, int y, int width, int height, 
                Color bgcolor, ImageObserver observer) {
            boolean retval = bufferGraphics.drawImage(img, x, y, width, height, 
                    bgcolor, observer);
            triggerUpdate();
            return retval;
        }

        @Override
        public boolean drawImage(Image img, int dx1, int dy1, int dx2, int dy2, 
                int sx1, int sy1, int sx2, int sy2, ImageObserver observer) {
            boolean retval = bufferGraphics.drawImage(img, dx1, dy1, dx2, dy2, 
                    sx1, sy1, sx2, sy2, observer);
            triggerUpdate();
            return retval;
        }

        @Override
        public boolean drawImage(Image img, int dx1, int dy1, int dx2, int dy2, 
                int sx1, int sy1, int sx2, int sy2, Color bgcolor, 
                ImageObserver observer) {
            boolean retval = bufferGraphics.drawImage(img, dx1, dy1, dx2, dy2, 
                    sx1, sy1, sx2, sy2, bgcolor, observer);
            triggerUpdate();
            return retval;
        }

        @Override
        public void dispose() {
            bufferGraphics.dispose();
        }

        @Override
        public void draw(Shape s) {
            bufferGraphics.draw(s);
            triggerUpdate();
        }

        @Override
        public boolean drawImage(Image img, AffineTransform xform, 
                ImageObserver obs) {
            boolean retval = bufferGraphics.drawImage(img, xform, obs);
            triggerUpdate();
            return retval;
        }

        @Override
        public void drawImage(BufferedImage img, BufferedImageOp op, int x, 
                int y) {
            bufferGraphics.drawImage(img, op, x, y);
            triggerUpdate();
        }

        @Override
        public void drawRenderedImage(RenderedImage img, AffineTransform xform) {
            bufferGraphics.drawRenderedImage(img, xform);
            triggerUpdate();
        }

        @Override
        public void drawRenderableImage(RenderableImage img, 
                AffineTransform xform) {
            bufferGraphics.drawRenderableImage(img, xform);
            triggerUpdate();
        }

        @Override
        public void drawString(String str, float x, float y) {
            bufferGraphics.drawString(str, x, y);
            triggerUpdate();
        }

        @Override
        public void drawString(AttributedCharacterIterator iterator, float x, 
                float y) {
            bufferGraphics.drawString(iterator, x, y);
            triggerUpdate();
        }

        @Override
        public void drawGlyphVector(GlyphVector g, float x, float y) {
            bufferGraphics.drawGlyphVector(g, x, y);
            triggerUpdate();
        }

        @Override
        public void fill(Shape s) {
            bufferGraphics.fill(s);
            triggerUpdate();
        }

        @Override
        public boolean hit(Rectangle rect, Shape s, boolean onStroke) {
            boolean retval = bufferGraphics.hit(rect, s, onStroke);
            triggerUpdate();
            return retval;
        }

        @Override
        public GraphicsConfiguration getDeviceConfiguration() {
            GraphicsConfiguration gc = bufferGraphics.getDeviceConfiguration();
            triggerUpdate();
            return gc;
        }

        @Override
        public void setComposite(Composite comp) {
            bufferGraphics.setComposite(comp);
            triggerUpdate();
        }

        @Override
        public void setPaint(Paint paint) {
            bufferGraphics.setPaint(paint);
            triggerUpdate();
        }

        @Override
        public void setStroke(Stroke s) {
            bufferGraphics.setStroke(s);
            triggerUpdate();
        }

        @Override
        public void setRenderingHint(RenderingHints.Key hintKey, 
                Object hintValue) {
            bufferGraphics.setRenderingHint(hintKey, hintValue);
        }

        @Override
        public Object getRenderingHint(RenderingHints.Key hintKey) {
            return bufferGraphics.getRenderingHint(hintKey);
        }

        @Override
        public void setRenderingHints(Map<?, ?> hints) {
            bufferGraphics.setRenderingHints(hints);
        }

        @Override
        public void addRenderingHints(Map<?, ?> hints) {
            bufferGraphics.addRenderingHints(hints);
        }

        @Override
        public RenderingHints getRenderingHints() {
            return bufferGraphics.getRenderingHints();
        }

        @Override
        public void translate(double tx, double ty) {
            bufferGraphics.translate(tx, ty);
            triggerUpdate();
        }

        @Override
        public void rotate(double theta) {
            bufferGraphics.rotate(theta);
            triggerUpdate();
        }

        @Override
        public void rotate(double theta, double x, double y) {
            bufferGraphics.rotate(theta, x, y);
            triggerUpdate();
        }

        @Override
        public void scale(double sx, double sy) {
            bufferGraphics.scale(sx, sy);
            triggerUpdate();
        }

        @Override
        public void shear(double shx, double shy) {
            bufferGraphics.shear(shx, shy);
            triggerUpdate();
        }

        @Override
        public void transform(AffineTransform Tx) {
            bufferGraphics.transform(Tx);
            triggerUpdate();
        }

        @Override
        public void setTransform(AffineTransform Tx) {
            bufferGraphics.setTransform(Tx);
            triggerUpdate();
        }

        @Override
        public AffineTransform getTransform() {
            return bufferGraphics.getTransform();
        }

        @Override
        public Paint getPaint() {
            return bufferGraphics.getPaint();
        }

        @Override
        public Composite getComposite() {
            return bufferGraphics.getComposite();
        }

        @Override
        public void setBackground(Color color) {
            bufferGraphics.setBackground(color);
            triggerUpdate();
        }

        @Override
        public Color getBackground() {
            return bufferGraphics.getBackground();
        }

        @Override
        public Stroke getStroke() {
            return bufferGraphics.getStroke();
        }

        @Override
        public void clip(Shape s) {
            bufferGraphics.clip(s);
            triggerUpdate();
        }

        @Override
        public FontRenderContext getFontRenderContext() {
            return bufferGraphics.getFontRenderContext();
        }
        
    }
    
}
