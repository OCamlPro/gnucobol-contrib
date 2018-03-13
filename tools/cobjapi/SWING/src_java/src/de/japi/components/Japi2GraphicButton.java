package de.japi.components;

import de.japi.Japi2;
import de.japi.Japi2Session;
import de.japi.Japi2Session.TargetStream;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.MediaTracker;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.net.MalformedURLException;
import java.net.URL;
import javax.swing.ImageIcon;
import javax.swing.JButton;

/**
 * Creates a button which displays an image.
 */
public class Japi2GraphicButton extends JButton {

    /**
     * Id of this object.
     */
    private int id;

    /**
     * Constructs a new Japi2GraphicButton which displays the image with the
     * given filename. The function of a button is simulated with an image that
     * processes mouse events. This is done by tracking the image with a
     * {@link MediaTracker} object and enabling mouse events to be delivered to
     * this component.
     *
     * @param filename the name of the image file that should be displayed by
     * the button
     * @param session the running Japi2Session
     * @throws MalformedURLException
     */
    public Japi2GraphicButton(final Japi2Session session, String filename)
            throws MalformedURLException {
        super();
        
        // Load the image
        Image picture = Toolkit.getDefaultToolkit().getImage(new URL(
                "http",
                session.getResourceHost(),
                session.getResourcePort(),
                filename)
        );

        // Use a media tracker to get the image
        MediaTracker tracker = new MediaTracker(this);
        tracker.addImage(picture, 0);
        try {
            tracker.waitForID(0);
        } catch (InterruptedException ex) {
            Japi2.getInstance().debug("Failed to get image for graphic "
                    + "button: {0}", ex);
        }
        
        // Apply the image
        setImage(picture);
    
        // The action listener listens on click events
        addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    // Write out the action
                    session.writeInt(id, TargetStream.ACTION);
                } catch (Exception ex) {
                    Japi2.getInstance().debug("Can't write action event of "
                            + "graphic button to the stream: {0}", ex);
                }
            }
        });
    }

    /**
     * Sets the object id. The value is given by 
     * {@link Japi2Session#addObject(java.lang.Object)}.
     * 
     * @param id the id of this object.
     */
    public final void setId(int id) {
        this.id = id;
    }

    /**
     * Sets the given image as icon for the button.
     * 
     * @param image the image to set or <code>null</code> to remove the current
     * icon.
     */
    public final void setImage(Image image) {
        // Create a copy, because during development there were some really
        // strange errors when using the given image directly
        BufferedImage buf = new BufferedImage(
                image.getWidth(this), 
                image.getHeight(this), 
                BufferedImage.TYPE_INT_ARGB
        );
        Graphics g = buf.getGraphics();
        g.drawImage(image, 0, 0, null);
        g.dispose();
        super.setIcon(new ImageIcon(buf));
    }

}
