package de.japi;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

/**
 * Simple class to cache icons used by this program.
 */
public class Icon {
    
    /**
     * The icon map.
     */
    private static Image IMAGE;
    
    /**
     * All application icons.
     */
    private static List<Image> APP_ICONS;
    
    /**
     * Usable program icons.
     */
    public static final ImageIcon 
            DIALOG_ERROR = create(0, 0, 64),
            DIALOG_QUESTION = create(64, 0, 64),
            DIALOG_INFO = create(128, 0, 64);
    
    /**
     * Returns a list of icons of this application in different sizes.
     * 
     * @return different sized icons for JAPI2.
     */
    public static List<Image> getAppIcons() {
        if (APP_ICONS == null) {
            APP_ICONS = new ArrayList<Image>();
            int accu = 0;
            for (int i : new int[] {256, 128, 96, 64, 32, 24, 16}) {
                APP_ICONS.add(create(accu, 64 + (256 - i), i).getImage());
                accu += i;
            }
        }
        return APP_ICONS;
    }
    
    /**
     * Looks up a JAPI2 application icon with a size near to 
     * <code>resolution</code>.
     * 
     * @param resolution the icon size in pixel to find.
     * @return the found icon.
     */
    public static Image getAppIcon(int resolution) {
        List<Image> appIcons = getAppIcons();
        Image bestMatch = null;
        int score = Integer.MAX_VALUE;
        for (Image appIcon : appIcons) {
            int tmp = Math.abs(
                    (appIcon.getWidth(null) + appIcon.getHeight(null)) - 
                            (2*resolution)
            );
            if (tmp < score) {
                score = tmp;
                bestMatch = appIcon;
            }
        }
        return bestMatch;
    }
    
    /**
     * Extracts an icon from the icon map.
     * 
     * @param x the x coordinate of the icon's origin.
     * @param y the y coordinate of the icon's origin.
     * @param size the size of the icon (it needs to be square).
     * @return the {@link ImageIcon}, never <code>null</code>.
     */
    private static ImageIcon create(int x, int y, int size) {
        try {
            // If not present yet ...
            if (IMAGE == null) {
                IMAGE = ImageIO.read(Icon.class.getResource("iconset.png"));
            }
             
            return new ImageIcon(((BufferedImage) IMAGE).getSubimage(
                    x, y, size, size
            ));
        } catch (Exception ex) {
            Japi2.getInstance().debug("Failed to create icon: {0}", ex);
            BufferedImage buf = new BufferedImage(size, size, BufferedImage.TYPE_INT_ARGB);
            Graphics g = buf.getGraphics();
            g.setColor(Color.red);
            g.drawLine(0, 0, size, size);
            g.drawLine(size, 0, 0, size);
            g.dispose();
            return new ImageIcon(buf); // Fallback image
        }
    }
        
}
