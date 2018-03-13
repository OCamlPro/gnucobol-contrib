package de.japi.components;

import de.japi.Japi2;
import java.awt.Color;
import java.awt.Composite;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GraphicsConfiguration;
import java.awt.Image;
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
 * A simple custom image with the simple mission to prevent the user from 
 * calling the graphic's <code>dispose()</code> method. Due to the fact that 
 * the graphic is modified multiple times a dispose call would clear the image
 * and all subsequet modifications will be done on a cleared graphic or with
 * other settings. To dispose the graphic, the method 
 * {@link Japi2Image#dispose()} can be used.
 */
public class Japi2Image extends BufferedImage {
    
    /**
     * The internal ("raw") graphics object.
     */
    private final Graphics2D graphics;
    
    /**
     * The external graphics object preventing the user from calling the
     * {@link Japi2Graphics#dispose()} methods.
     */
    private Japi2Graphics externalGraphics;
    
    /**
     * Indicates if this image is open for graphic manipulations.
     */
    private boolean isOpen;
    
    /**
     * Creates a new empty image with colorspace RGB.
     * 
     * @param width the width of the new image.
     * @param height the height of the new image.
     */
    public Japi2Image(int width, int height) {
        super(width, height, BufferedImage.TYPE_INT_RGB);
        graphics = (Graphics2D) super.getGraphics();
        isOpen = true;
        
        // Setup defaults
        graphics.setFont(new Font("Dialog", Font.PLAIN, 12));
        graphics.setColor(Color.white);
        graphics.fillRect(0, 0, width, height);
        graphics.setColor(Color.black);
    }

    @Override
    public final Graphics getGraphics() {
        if (!isOpen) {
            throw new IllegalStateException("Graphics already closed!");
        }
        
        if (externalGraphics == null) {
            externalGraphics = new Japi2Graphics();
        }
        return externalGraphics;
    }
    
    /**
     * Disposes the image. All subsequent calls of {@link #getGraphics()} will
     * throw an {@link IllegalStateException}.
     */
    public final void dispose() {
        graphics.dispose();
        isOpen = false;
    }
    
    /**
     * Internal graphic object with the single purpose to prevent the user
     * from calling {@link Japi2Graphics#dispose()}. Instead call
     * {@link Japi2Image#dispose()} when the object is not used anymore.
     */
    private class Japi2Graphics extends Graphics2D {

        /**
         * Prevent the user from disposing the image.
         */
        @Override
        public void dispose() {
            Japi2.getInstance().debug("Can't call dispose() on this graphics "
                    + "directly; call dispose on the Japi2Image!");
        }
        
        @Override
        public Graphics create() {
            return graphics.create();
        }

        @Override
        public void translate(int x, int y) {
            graphics.translate(x, y);
        }

        @Override
        public Color getColor() {
            return graphics.getColor();
        }

        @Override
        public void setColor(Color c) {
            graphics.setColor(c);
        }

        @Override
        public void setPaintMode() {
            graphics.setPaintMode();
        }

        @Override
        public void setXORMode(Color c1) {
            graphics.setXORMode(c1);
        }

        @Override
        public Font getFont() {
            return graphics.getFont();
        }

        @Override
        public void setFont(Font font) {
            graphics.setFont(font);
        }

        @Override
        public FontMetrics getFontMetrics(Font f) {
            return graphics.getFontMetrics(f);
        }

        @Override
        public Rectangle getClipBounds() {
            return graphics.getClipBounds();
        }

        @Override
        public void clipRect(int x, int y, int width, int height) {
            graphics.clipRect(x, y, width, height);
        }

        @Override
        public void setClip(int x, int y, int width, int height) {
            graphics.setClip(x, y, width, height);
        }

        @Override
        public Shape getClip() {
            return graphics.getClip();
        }

        @Override
        public void setClip(Shape clip) {
            graphics.setClip(clip);
        }

        @Override
        public void copyArea(int x, int y, int width, int height, int dx,
                int dy) {
            graphics.copyArea(x, y, width, height, dx, dy);
        }

        @Override
        public void drawLine(int x1, int y1, int x2, int y2) {
            graphics.drawLine(x1, y1, x2, y2);
        }

        @Override
        public void fillRect(int x, int y, int width, int height) {
            graphics.fillRect(x, y, width, height);
        }

        @Override
        public void clearRect(int x, int y, int width, int height) {
            graphics.clearRect(x, y, width, height);
        }

        @Override
        public void drawRoundRect(int x, int y, int width, int height,
                int arcWidth, int arcHeight) {
            graphics.drawRoundRect(x, y, width, height, arcWidth,
                    arcHeight);
        }

        @Override
        public void fillRoundRect(int x, int y, int width, int height,
                int arcWidth, int arcHeight) {
            graphics.fillRoundRect(x, y, width, height, arcWidth,
                    arcHeight);
        }

        @Override
        public void drawOval(int x, int y, int width, int height) {
            graphics.drawOval(x, y, width, height);
        }

        @Override
        public void fillOval(int x, int y, int width, int height) {
            graphics.fillOval(x, y, width, height);
        }

        @Override
        public void drawArc(int x, int y, int width, int height, int startAngle,
                int arcAngle) {
            graphics.drawArc(x, y, width, height, startAngle, arcAngle);
        }

        @Override
        public void fillArc(int x, int y, int width, int height, int startAngle,
                int arcAngle) {
            graphics.fillArc(x, y, width, height, startAngle, arcAngle);
        }

        @Override
        public void drawPolyline(int[] xPoints, int[] yPoints, int nPoints) {
            graphics.drawPolyline(xPoints, yPoints, nPoints);
        }

        @Override
        public void drawPolygon(int[] xPoints, int[] yPoints, int nPoints) {
            graphics.drawPolygon(xPoints, yPoints, nPoints);
        }

        @Override
        public void fillPolygon(int[] xPoints, int[] yPoints, int nPoints) {
            graphics.fillPolygon(xPoints, yPoints, nPoints);
        }

        @Override
        public void drawString(String str, int x, int y) {
            graphics.drawString(str, x, y);
        }

        @Override
        public void drawString(AttributedCharacterIterator iterator, int x,
                int y) {
            graphics.drawString(iterator, x, y);
        }

        @Override
        public boolean drawImage(Image img, int x, int y,
                ImageObserver observer) {
            return graphics.drawImage(img, x, y, observer);
        }

        @Override
        public boolean drawImage(Image img, int x, int y, int width, int height,
                ImageObserver observer) {
            return graphics.drawImage(img, x, y, width, height,
                    observer);
        }

        @Override
        public boolean drawImage(Image img, int x, int y, Color bgcolor,
                ImageObserver observer) {
            return graphics.drawImage(img, x, y, bgcolor,
                    observer);
        }

        @Override
        public boolean drawImage(Image img, int x, int y, int width, int height,
                Color bgcolor, ImageObserver observer) {
            return graphics.drawImage(img, x, y, width, height,
                    bgcolor, observer);
        }

        @Override
        public boolean drawImage(Image img, int dx1, int dy1, int dx2, int dy2,
                int sx1, int sy1, int sx2, int sy2, ImageObserver observer) {
            return graphics.drawImage(img, dx1, dy1, dx2, dy2,
                    sx1, sy1, sx2, sy2, observer);
        }

        @Override
        public boolean drawImage(Image img, int dx1, int dy1, int dx2, int dy2,
                int sx1, int sy1, int sx2, int sy2, Color bgcolor,
                ImageObserver observer) {
            return graphics.drawImage(img, dx1, dy1, dx2, dy2,
                    sx1, sy1, sx2, sy2, bgcolor, observer);
        }

        @Override
        public void draw(Shape s) {
            graphics.draw(s);
        }

        @Override
        public boolean drawImage(Image img, AffineTransform xform,
                ImageObserver obs) {
            return graphics.drawImage(img, xform, obs);
        }

        @Override
        public void drawImage(BufferedImage img, BufferedImageOp op, int x,
                int y) {
            graphics.drawImage(img, op, x, y);
        }

        @Override
        public void drawRenderedImage(RenderedImage img, AffineTransform xform) {
            graphics.drawRenderedImage(img, xform);
        }

        @Override
        public void drawRenderableImage(RenderableImage img,
                AffineTransform xform) {
            graphics.drawRenderableImage(img, xform);
        }

        @Override
        public void drawString(String str, float x, float y) {
            graphics.drawString(str, x, y);
        }

        @Override
        public void drawString(AttributedCharacterIterator iterator, float x,
                float y) {
            graphics.drawString(iterator, x, y);
        }

        @Override
        public void drawGlyphVector(GlyphVector g, float x, float y) {
            graphics.drawGlyphVector(g, x, y);
        }

        @Override
        public void fill(Shape s) {
            graphics.fill(s);
        }

        @Override
        public boolean hit(Rectangle rect, Shape s, boolean onStroke) {
            return graphics.hit(rect, s, onStroke);
        }

        @Override
        public GraphicsConfiguration getDeviceConfiguration() {
            return graphics.getDeviceConfiguration();
        }

        @Override
        public void setComposite(Composite comp) {
            graphics.setComposite(comp);
        }

        @Override
        public void setPaint(Paint paint) {
            graphics.setPaint(paint);
        }

        @Override
        public void setStroke(Stroke s) {
            graphics.setStroke(s);
        }

        @Override
        public void setRenderingHint(RenderingHints.Key hintKey,
                Object hintValue) {
            graphics.setRenderingHint(hintKey, hintValue);
        }

        @Override
        public Object getRenderingHint(RenderingHints.Key hintKey) {
            return graphics.getRenderingHint(hintKey);
        }

        @Override
        public void setRenderingHints(Map<?, ?> hints) {
            graphics.setRenderingHints(hints);
        }

        @Override
        public void addRenderingHints(Map<?, ?> hints) {
            graphics.addRenderingHints(hints);
        }

        @Override
        public RenderingHints getRenderingHints() {
            return graphics.getRenderingHints();
        }

        @Override
        public void translate(double tx, double ty) {
            graphics.translate(tx, ty);
        }

        @Override
        public void rotate(double theta) {
            graphics.rotate(theta);
        }

        @Override
        public void rotate(double theta, double x, double y) {
            graphics.rotate(theta, x, y);
        }

        @Override
        public void scale(double sx, double sy) {
            graphics.scale(sx, sy);
        }

        @Override
        public void shear(double shx, double shy) {
            graphics.shear(shx, shy);
        }

        @Override
        public void transform(AffineTransform Tx) {
            graphics.transform(Tx);
        }

        @Override
        public void setTransform(AffineTransform Tx) {
            graphics.setTransform(Tx);
        }

        @Override
        public AffineTransform getTransform() {
            return graphics.getTransform();
        }

        @Override
        public Paint getPaint() {
            return graphics.getPaint();
        }

        @Override
        public Composite getComposite() {
            return graphics.getComposite();
        }

        @Override
        public void setBackground(Color color) {
            graphics.setBackground(color);
        }

        @Override
        public Color getBackground() {
            return graphics.getBackground();
        }

        @Override
        public Stroke getStroke() {
            return graphics.getStroke();
        }

        @Override
        public void clip(Shape s) {
            graphics.clip(s);
        }

        @Override
        public FontRenderContext getFontRenderContext() {
            return graphics.getFontRenderContext();
        }

    }
    
}
