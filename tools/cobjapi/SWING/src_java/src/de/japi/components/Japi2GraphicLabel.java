package de.japi.components;

import de.japi.Japi2Session;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.MediaTracker;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import javax.imageio.ImageIO;
import javax.swing.JLabel;

/**
 * A display area for a an image.
 */
public class Japi2GraphicLabel extends JLabel {

    /**
     * The image object which is currently displayed.
     */
    private Image image;
    
    /**
     * The size of this component.
     */
    private Dimension size;

    /**
     * Creates a new {@link Japi2GraphicLabel} instance and loads the image from
     * the remote HTTP server of the JAPI library.
     *
     * @param filename name of the file to load.
     * @param session the {@link Japi2Session} object with the HTTP server data.
     * @throws IOException if the image can't be read.
     * @throws MalformedURLException if the URL to the image is invalid.
     * @throws InterruptedException if the loading process is aborted.
     */
    public Japi2GraphicLabel(Japi2Session session, String filename) 
            throws IOException, MalformedURLException, InterruptedException {
        Image picture = ImageIO.read(new URL(
                "http", 
                session.getResourceHost(), 
                session.getResourcePort(), 
                filename
        ));
        MediaTracker tracker = new MediaTracker(this);
        tracker.addImage(picture, 0);
        tracker.waitForID(0);
        this.setSize(picture.getWidth(null), picture.getHeight(null));
        this.setImage(picture);
    }

    /**
     * Set the image to display for this graphic label.
     * 
     * @param image the image to display, never <code>null</code>.
     */
    public final void setImage(Image image) {
        if (image == null) {
            throw new NullPointerException("Image in graphic label can't be null");
        }
        this.image = image;
        repaint();
    }

    @Override
    public final void setSize(int width, int height) {
        size = new Dimension(width, height);
        super.setSize(size.width, size.height);
    }

    @Override
    public Dimension getPreferredSize() {
        return size;
    }

    @Override
    public Dimension getMinimumSize() {
        return size;
    }

    @Override
    protected void paintComponent(Graphics g) {
        g.drawImage(image, 0, 0, size.width, size.height, null);
        super.paintComponent(g); // Paint text on top of the image
    }

    @Override
    public String toString() {
        return "GraphicLabel[image=" + 
                (image == null ? "--none--" :
                    image.getWidth(null) + "x" + image.getHeight(null))
                + ",size=" + size.width + "x" + size.height + "]";
    }
    
}
