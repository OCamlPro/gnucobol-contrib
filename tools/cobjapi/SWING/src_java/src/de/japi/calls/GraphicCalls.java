package de.japi.calls;

import de.japi.Japi2;
import de.japi.Japi2Constants;
import de.japi.Japi2Session;
import de.japi.components.Japi2Canvas;
import de.japi.components.Japi2Frame;
import de.japi.components.Japi2InternalFrame;
import de.japi.components.Japi2PrintJob;
import de.japi.components.Japi2Table;
import de.japi.components.Japi2Tree;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Image;
import java.awt.MediaTracker;
import java.awt.Toolkit;
import java.awt.image.MemoryImageSource;
import java.awt.image.PixelGrabber;
import java.io.IOException;
import java.net.URL;
import javax.swing.BorderFactory;
import javax.swing.JFrame;
import javax.swing.UIManager;

/**
 * This class contains all JAPI calls which are related to graphics.
 */
public class GraphicCalls {
    
    /**
     * A buffer.
     */
    private static final byte[] buf = new byte[128];
    
    /*
     * These methods set the color of a Component, Image or PrintJob to a given 
     * (r,g,b)-value. It is important to differentiate between Japi2Frame and
     * Component, because in SWING colors can only be added to the contentPane
     * of JFrame-Components and not to the frame directly.
     */
    
    public static void setFgColor(Japi2Session session, Japi2Frame frame) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();
  
        session.log3("Set fg color (1) in {0}: {1}, {2}, {3}", frame, red, green, blue);
        frame.getContentPane().setForeground(new Color(red, green, blue));
    } 

    public static void setFgColor(Japi2Session session, Japi2InternalFrame internalFrame) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();
  
        session.log3("Set fg color (1) in {0}: {1}, {2}, {3}", internalFrame, red, green, blue);
        internalFrame.getContentPane().setForeground(new Color(red, green, blue));
    } 
    
    public static void setFgColor(Japi2Session session, Japi2Table table) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();
  
        session.log3("Set fg color (4) in {0}: {1}, {2}, {3}", table, red, green, blue);
        table.getTable().setForeground(new Color(red, green, blue));
    }
    
    public static void setFgColor(Japi2Session session, Component component) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();
  
        session.log3("Set fg color (2) in {0}: {1}, {2}, {3}", component, red, green, blue);
        component.setForeground(new Color(red, green, blue));
    }
    
    public static void setFgColor(Japi2Session session, Image image) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();
  
        session.log3("Set fg color (3) in {0}: {1}, {2}, {3}", image, red, green, blue);
        Color c = new Color(red, green, blue);
        image.getGraphics().setColor(c);
    }
    
    public static void setFgColor(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();
  
        session.log3("Set fg color (4) in {0}: {1}, {2}, {3}", printJob, red, green, blue);
        printJob.getGraphics().setColor(new Color(red, green, blue));
    }

    /*
     * These methods set the background color of a Component, Image or Print Job
     * to a given (r,g,b)-value. It is important to differentiate between Japi2Frame and
     * Component, because in SWING colors can only be added to the contentPane
     * of JFrame-Components and not to the frame directly.
     */
    
    public static void setBgColor(Japi2Session session, Japi2Frame frame) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set backgroundcolor in {0}: {1}, {2}, {3}", frame, red, green, blue);
        frame.getContentPane().setBackground(new Color(red, green, blue));
    }

    public static void setBgColor(Japi2Session session, Japi2InternalFrame internalFrame) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set backgroundcolor in {0}: {1}, {2}, {3}", internalFrame, red, green, blue);
        internalFrame.getContentPane().setBackground(new Color(red, green, blue));
    }
    
    public static void setBgColor(Japi2Session session, Japi2Table table) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set backgroundcolor in {0}: {1}, {2}, {3}", table, red, green, blue);
        table.getTable().setBackground(new Color(red, green, blue));
    }
    
    public static void setBgColor(Japi2Session session, Component component) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set backgroundcolor in {0}: {1}, {2}, {3}", component, red, green, blue);
        component.setBackground(new Color(red, green, blue));
    }
    
    public static void setBgColor(Japi2Session session, Image image) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();
        session.log3("Set backgroundcolor in {0}: {1}, {2}, {3}", image, red, green, blue);

        Dimension d = new Dimension();
        d.width = image.getWidth(session.getDebugWindow());
        d.height = image.getHeight(session.getDebugWindow());
        
        Color c = image.getGraphics().getColor();
        image.getGraphics().setColor(new Color(red, green, blue));
        image.getGraphics().fillRect(0, 0, d.width, d.height);
        image.getGraphics().setColor(c);
    }
    
    public static void setBgColor(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();
        session.log3("Set backgroundcolor in {0}: {1}, {2}, {3}", printJob, red, green, blue);

        Dimension d = printJob.getPageDimension();
        Color c = printJob.getGraphics().getColor();
        printJob.getGraphics().setColor(new Color(red, green, blue));
        printJob.getGraphics().fillRect(0, 0, d.width, d.height);
        printJob.getGraphics().setColor(c);
    }

    public static void setTreeTextSelColor(Japi2Session session, Japi2Tree tree) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set textSelectionColor in {0}: {1}, {2}, {3}", tree, red, green, blue);
        tree.setTextSelectionColor(new Color(red, green, blue));
    }

    public static void setTreeBgSelColor(Japi2Session session, Japi2Tree tree) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set backgroundSelectionColor in {0}: {1}, {2}, {3}", tree, red, green, blue);
        tree.setBackgroundSelectionColor(new Color(red, green, blue));
    }

    public static void setTreeBorderSelColor(Japi2Session session, Japi2Tree tree) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set borderSelectionColor in {0}: {1}, {2}, {3}", tree, red, green, blue);
        tree.setBorderSelectionColor(new Color(red, green, blue));
    }

    public static void setTreeTextNonSelColor(Japi2Session session, Japi2Tree tree) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set textNonSelectionColor in {0}: {1}, {2}, {3}", tree, red, green, blue);
        tree.setTextNonSelectionColor(new Color(red, green, blue));
    }

    public static void setTreeBgNonSelColor(Japi2Session session, Japi2Tree tree) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set backgroundNonSelectionColor in {0}: {1}, {2}, {3}", tree, red, green, blue);
        tree.setBackgroundNonSelectionColor(new Color(red, green, blue));
    }

    public static void setGridColor(Japi2Session session, Japi2Table table) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set GridColor in {0}: {1}, {2}, {3}", table, red, green, blue);
        table.getTable().setGridColor(new Color(red, green, blue));
    }

    public static void setHeaderColor(Japi2Session session, Japi2Table table) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set HeaderColor in {0}: {1}, {2}, {3}", table, red, green, blue);
        table.getTable().getTableHeader().setForeground(new Color(red, green, blue));
    }

    public static void setHeaderColorBg(Japi2Session session, Japi2Table table) throws IOException {
        int red = session.readByte();
        int green = session.readByte();
        int blue = session.readByte();

        session.log3("Set HeaderColorBg in {0}: {1}, {2}, {3}", table, red, green, blue);
        table.getTable().getTableHeader().setBackground(new Color(red, green, blue));
        table.setBackground(new Color(red, green, blue));
    }
    
    /*
     * The following four methods set the paint Mode of Japi2Canvas,
     * Components, Images and PrintJobs to XOR-Mode if value is true. 
     * XOR-Mode means that pixels of the current color are changed to the 
     * specified color (here white), and vice versa.
     */
    
    public static void setXOR(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int value = session.readInt();
        session.log3("Set XOR in {0} to {1}", canvas, value);
        
        if(value != Japi2Constants.J_FALSE) 
            canvas.setXORMode(Color.white);
        else 
            canvas.setPaintMode();  
    }
    
    public static void setXOR(Japi2Session session, Component component) throws IOException {
        int value = session.readInt();
        session.log3("Set XOR in {0} to {1}", component, value);
        
        if(value != Japi2Constants.J_FALSE) 
            component.getGraphics().setXORMode(Color.white);
        else 
            component.getGraphics().setPaintMode();  
    }
    
    public static void setXOR(Japi2Session session, Image image) throws IOException {
        int value = session.readInt();
        session.log3("Set XOR in {0} to {1}", image, value);
        
        if(value != Japi2Constants.J_FALSE) 
            image.getGraphics().setXORMode(Color.white);
        else 
            image.getGraphics().setPaintMode();  
    }
    
    public static void setXOR(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int value = session.readInt();
        session.log3("Set XOR in {0} to {1}", printJob, value);
        
        if(value != Japi2Constants.J_FALSE) 
            printJob.getGraphics().setXORMode(Color.white);
        else 
            printJob.getGraphics().setPaintMode();  
    }
    
    /*
     * These methods draw the text given by the specified string to Japi2Canvas,
     * Component, Image or PrintJob using its graphics context's current font 
     * and color. 
     */
    
    public static void drawString(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        String s = session.readLine();
        
        session.log3("String in {0} at {1} {2} : {3}", canvas, x, y, s);
        canvas.getGraphics().drawString(s, x, y);
    }
    
    public static void drawString(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        String s = session.readLine();
        
        session.log3("String in {0} at {1} {2} : {3}", component, x, y, s); 
        component.getGraphics().drawString(s, x, y);
    }
     
    public static void drawString(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        String s = session.readLine();
        
        session.log3("String in {0} at {1} {2} : {3}", image, x, y, s); 
        image.getGraphics().drawString(s, x, y);
    }
    
    public static void drawString(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        String s = session.readLine();
        
        session.log3("String in {0} at {1} {2} : {3}", printJob, x, y, s); 
        printJob.getGraphics().drawString(s, x, y);
    }
    
    /*
     * These methods set the clip of Japi2Canvas, Component, Image and PrintJob
     * to the intersection of the current clip and the specified Rectangle.
     * If there is no current clip specified, the specified Rectangle becomes
     * the new clip.
    */
    
    public static void clipRect(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("CLIP RECT in {0} to {1} {2} {3} {4}", canvas, x, y, width, height);
        canvas.clipRect(x, y, width, height); 
    }
    
    public static void clipRect(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("CLIP RECT in {0} to {1} {2} {3} {4}", component, x, y, width, height);
        component.getGraphics().clipRect(x, y, width, height); 
    }
    
    public static void clipRect(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("CLIP RECT in {0} to {1} {2} {3} {4}", image, x, y, width, height);
        image.getGraphics().clipRect(x, y, width, height); 
    }
    
    public static void clipRect(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("CLIP RECT in {0} to {1} {2} {3} {4}", printJob, x, y, width, height);
        printJob.getGraphics().clipRect(x, y, width, height); 
    }
    
    /*
     * These methods translate the origin of the graphics context of Japi2Canvas,
     * Component, Image or Japi2PrintJob to the point (x, y) in the current 
     * coordinate system. 
     */
    
    public static void translate(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        session.log3("Translate in {0} to Pos {1}:{2}", canvas, x, y);
        canvas.translate(x, y);
    }
    
    public static void translate(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        session.log3("Translate in {0} to Pos {1}:{2}", component, x, y);
        component.getGraphics().translate(x, y);
    }
    
    public static void translate(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        session.log3("Translate in {0} to Pos {1}:{2}", image, x, y);
        image.getGraphics().translate(x, y);
    }
    
    public static void translate(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        session.log3("Translate in {0} to Pos {1}:{2}", printJob, x, y);
        printJob.getGraphics().translate(x, y);
    }
    
    /*
     * The following four methods are used to draw a line from Point (x1,y1) to 
     * Point (x2,y2). Here the weight is important, because Japi2Canvas is
     * an element of Component, so Japi2Canvas needs to be checked first. 
     */  
    
    public static void drawLine(Japi2Session session, Japi2Canvas canvas) throws IOException {
        // High performance for pixel manipulation
        session.read(buf, 16);
        int x1 = (buf[0] & 0xff) | 
                ((buf[1] & 0xff) << 8) | 
                ((buf[2] & 0xff) << 16) | 
                ((buf[3] & 0xff) << 24);
        int y1 = (buf[4] & 0xff) | 
                ((buf[5] & 0xff) << 8) | 
                ((buf[6] & 0xff) << 16) | 
                ((buf[7] & 0xff) << 24);
        int x2 = (buf[8] & 0xff) | 
                ((buf[9] & 0xff) << 8) | 
                ((buf[10] & 0xff) << 16) | 
                ((buf[11] & 0xff) << 24);
        int y2 = (buf[12] & 0xff) | 
                ((buf[13] & 0xff) << 8) | 
                ((buf[14] & 0xff) << 16) | 
                ((buf[15] & 0xff) << 24);
        
        if (x1 == x2 && y1 == y2) {
            canvas.drawPixel(x1, y1);
        } else {
            session.log3("Line in {0}: ({1}, {2}) to ({3}, {4})", canvas, x1, y1, x2, y2);
            canvas.getGraphics().drawLine(x1, y1, x2, y2);
        }
    }
    
    public static void drawLine(Japi2Session session, Component component) throws IOException {
        int x1 = session.readInt();
        int y1 = session.readInt();
        int x2 = session.readInt();
        int y2 = session.readInt();        
       
        session.log3("Line in {0}: ({1}, {2}) to ({3}, {4})", component, x1, y1, x2, y2);
        component.getGraphics().drawLine(x1, y1, x2, y2);
    }
    
    public static void drawLine(Japi2Session session, Image image) throws IOException {
        int x1 = session.readInt();
        int y1 = session.readInt();
        int x2 = session.readInt();
        int y2 = session.readInt();        
       
        session.log3("Line in {0}: ({1}, {2}) to ({3}, {4})", image, x1, y1, x2, y2);
        image.getGraphics().drawLine(x1, y1, x2, y2);
    }
    
    public static void drawLine(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x1 = session.readInt();
        int y1 = session.readInt();
        int x2 = session.readInt();
        int y2 = session.readInt();        
       
        session.log3("Line in {0}: ({1}, {2}) to ({3}, {4})", printJob, x1, y1, x2, y2);
        printJob.getGraphics().drawLine(x1, y1, x2, y2);
    }
    
    /*
     * These methods draw the outline of a rectangle to Japi2Canvas, Component, 
     * Image or Japi2PrintJob. The left and right edges of the rectangle are at 
     * x and x + width. The top and bottom edges are at y and y + height.
     */
    
    public static void drawRect(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw Rectangle in {0}: {1} {2} {3} {4}", canvas, x, y, width, height);
        canvas.getGraphics().drawRect(x, y, width, height);
    }
    
    public static void drawRect(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw Rectangle in {0}: {1} {2} {3} {4}", component, x, y, width, height);
        component.getGraphics().drawRect(x, y, width, height);
    }
    
    public static void drawRect(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw Rectangle in {0}: {1} {2} {3} {4}", image, x, y, width, height);
        image.getGraphics().drawRect(x, y, width, height);
    }
    
    public static void drawRect(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw Rectangle in {0}: {1} {2} {3} {4}", printJob, x, y, width, height);
        printJob.getGraphics().drawRect(x, y, width, height);
    }
    
    /*
     * These methods fill the specified rectangle and draw it on Japi2Canvas, 
     * Component, Image or Japi2PrintJob.
     */
    
    public static void fillRect(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw filled rectangle in {0}: {1} {2} {3} {4}", canvas, x, y, width, height);
        canvas.getGraphics().fillRect(x, y, width, height);
    }
    
    public static void fillRect(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw filled rectangle in {0}: {1} {2} {3} {4}", component, x, y, width, height);
        component.getGraphics().fillRect(x, y, width, height);
    }
     
    public static void fillRect(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw filled rectangle in {0}: {1} {2} {3} {4}", image, x, y, width, height);
        image.getGraphics().fillRect(x, y, width, height);
    } 
    
    public static void fillRect(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw filled rectangle in {0}: {1} {2} {3} {4}", printJob, x, y, width, height);
        printJob.getGraphics().fillRect(x, y, width, height);
    }
    
    /*
     * These methods draw a sequence of connected lines defined by arrays 
     * of x and y coordinates on Japi2Canvas, Component, Image or PrintJob. 
     */
    
    public static void polyline(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int n = session.readInt();
        int [] x = new int[n];
        int [] y = new int[n];
        
        for (int i = 0; i < n; i++) 
            x[i] = session.readInt();
        for (int i = 0; i < n; i++) 
            y[i] = session.readInt();
        
        session.log3("POLYLINE in {0}, Number of Points = {1}", canvas, n);
        canvas.getGraphics().drawPolyline(x, y, n);
    }
    
    public static void polyline(Japi2Session session, Component component) throws IOException {
        int n = session.readInt();
        int [] x = new int[n];
        int [] y = new int[n];
        
        for (int i = 0; i < n; i++) 
            x[i] = session.readInt();
        for (int i = 0; i < n; i++) 
            y[i] = session.readInt();
        
        session.log3("POLYLINE in {0}, Number of Points = {1}", component, n);
        component.getGraphics().drawPolyline(x, y, n);
    }
    
    public static void polyline(Japi2Session session, Image image) throws IOException {
        int n = session.readInt();
        int [] x = new int[n];
        int [] y = new int[n];
        
        for (int i = 0; i < n; i++) 
            x[i] = session.readInt();
        for (int i = 0; i < n; i++) 
            y[i] = session.readInt();
        
        session.log3("POLYLINE in {0}, Number of Points = {1}", image, n);
        image.getGraphics().drawPolyline(x, y, n);
    }
    
    public static void polyline(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int n = session.readInt();
        int [] x = new int[n];
        int [] y = new int[n];
        
        for (int i = 0; i < n; i++) 
            x[i] = session.readInt();
        for (int i = 0; i < n; i++) 
            y[i] = session.readInt();
        
        session.log3("POLYLINE in {0}, Number of Points = {1}", printJob, n);
        printJob.getGraphics().drawPolyline(x, y, n);
    }
    
    /*
     * The methods draw the outline of a circular or elliptical arc 
     * covering the specified rectangle onto a Japi2Canvas, Component, 
     * Image or Japi2PrintJob. The center of the arc is the center of the 
     * rectangle whose origin is (x, y) and whose size is specified 
     * by the width and height arguments.
     */
    
    public static void drawArc(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw ARC in {0}: {1} {2} {3} {4}", canvas, x, y, width, height, a, b);
        canvas.getGraphics().drawArc(x, y, width, height, a, b);
    }
    
    public static void drawArc(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw ARC in {0}: {1} {2} {3} {4}", component, x, y, width, height, a, b);
        component.getGraphics().drawArc(x, y, width, height, a, b);
    }
    
    public static void drawArc(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw ARC in {0}: {1} {2} {3} {4}", image, x, y, width, height, a, b);
        image.getGraphics().drawArc(x, y, width, height, a, b);
    }
    
    public static void drawArc(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw ARC in {0}: {1} {2} {3} {4}", printJob, x, y, width, height, a, b);
        printJob.getGraphics().drawArc(x, y, width, height, a, b);
    }
    
    /*
     * These methods fill a circular or elliptical arc 
     * covering the specified rectangle onto a Japi2Canvas, Component, 
     * Image or Japi2PrintJob. The center of the arc is the center of the 
     * rectangle whose origin is (x, y) and whose size is specified 
     * by the width and height arguments.
     */
    
    public static void fillArc(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Fill ARC in {0}: {1} {2} {3} {4}", canvas, x, y, width, height, a, b);
        canvas.getGraphics().fillArc(x, y, width, height, a, b);
    }
    
    public static void fillArc(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Fill ARC in {0}: {1} {2} {3} {4}", component, x, y, width, height, a, b);
        component.getGraphics().fillArc(x, y, width, height, a, b);
    }
    
    public static void fillArc(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Fill ARC in {0}: {1} {2} {3} {4}", image, x, y, width, height, a, b);
        image.getGraphics().fillArc(x, y, width, height, a, b);
    }
    
    public static void fillArc(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Fill ARC in {0}: {1} {2} {3} {4}", printJob, x, y, width, height, a, b);
        printJob.getGraphics().fillArc(x, y, width, height, a, b);
    }

    /*
     * These methods draw the outline of an oval to a Japi2Canvas, Component, 
     * Japi2PrintJob or Image. The drawn circle or ellipse fits 
     * within the rectangle specified by the x, y, width, and height arguments.
     */
    
    public static void drawOval(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw Oval in {0}: {1} {2}", canvas, x, y, width, height);
        canvas.getGraphics().drawOval(x, y, width, height);
    }
    
    public static void drawOval(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw Oval in {0}: {1} {2}", component, x, y, width, height);
        component.getGraphics().drawOval(x, y, width, height);
    }
    
    public static void drawOval(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw Oval in {0}: {1} {2}", image, x, y, width, height);
        image.getGraphics().drawOval(x, y, width, height);
    }
    
    public static void drawOval(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Draw Oval in {0}: {1} {2}", printJob, x, y, width, height);
        printJob.getGraphics().drawOval(x, y, width, height);
    }
    
    /*
     * These methods fill an oval on a Japi2Canvas, Component, 
     * Japi2PrintJob or Image. The drawn oval fits 
     * within the rectangle specified by the x, y, width, and height arguments.
     */
    
    public static void fillOval(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Fill Oval in {0}: {1} {2}", canvas, x, y, width, height);
        canvas.getGraphics().fillOval(x, y, width, height);
    }
    
    public static void fillOval(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Fill Oval in {0}: {1} {2}", component, x, y, width, height);
        component.getGraphics().fillOval(x, y, width, height);
    }
    
    public static void fillOval(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Fill Oval in {0}: {1} {2}", image, x, y, width, height);
        image.getGraphics().fillOval(x, y, width, height);
    }
    
    public static void fillOval(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();

        session.log3("Fill Oval in {0}: {1} {2}", printJob, x, y, width, height);
        printJob.getGraphics().fillOval(x, y, width, height);
    }
    
    /*
     * These methods draw a closed polygon with n line segments, defined by the
     * Points (x, y) in the arrays x and y onto Japi2Canvas, Component, 
     * Image or Japi2PrintJob.
     */
    
    public static void polygon(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int n = session.readInt();
        int[] x = new int[n];
        int[] y = new int[n];

        for (int i = 0; i < n; i++) {
            x[i] = session.readInt();
        }
        for (int i = 0; i < n; i++) {
            y[i] = session.readInt();
        }
        session.log3("Polygon in {0}, Number of Points= {2}", canvas, n);
        canvas.getGraphics().drawPolygon(x, y, n);
    }
    
    public static void polygon(Japi2Session session, Component component) throws IOException {
        int n = session.readInt();
        int[] x = new int[n];
        int[] y = new int[n];

        for (int i = 0; i < n; i++) {
            x[i] = session.readInt();
        }
        for (int i = 0; i < n; i++) {
            y[i] = session.readInt();
        }
        session.log3("Polygon in {0}, Number of Points= {2}", component, n);
        component.getGraphics().drawPolygon(x, y, n);
    }
    
    public static void polygon(Japi2Session session, Image image) throws IOException {
        int n = session.readInt();
        int[] x = new int[n];
        int[] y = new int[n];

        for (int i = 0; i < n; i++) {
            x[i] = session.readInt();
        }
        for (int i = 0; i < n; i++) {
            y[i] = session.readInt();
        }
        session.log3("Polygon in {0}, Number of Points= {2}", image, n);
        image.getGraphics().drawPolygon(x, y, n);
    }
    
    public static void polygon(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int n = session.readInt();
        int[] x = new int[n];
        int[] y = new int[n];

        for (int i = 0; i < n; i++) {
            x[i] = session.readInt();
        }
        for (int i = 0; i < n; i++) {
            y[i] = session.readInt();
        }
        session.log3("Polygon in {0}, Number of Points= {2}", printJob, n);
        printJob.getGraphics().drawPolygon(x, y, n);
    }
    
    /*
     * These methods fill a closed polygon with n line segments, defined by the
     * Points (x, y) in the arrays x and y onto Japi2Canvas, Component, 
     * Image or Japi2PrintJob.
     */
    
    public static void fillPolygon(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int n = session.readInt();
        int[] x = new int[n];
        int[] y = new int[n];

        for (int i = 0; i < n; i++) {
            x[i] = session.readInt();
        }
        for (int i = 0; i < n; i++) {
            y[i] = session.readInt();
        }
        session.log3("Fill Polygon in {0}, Number of Points= {2}", canvas, n);
        canvas.getGraphics().fillPolygon(x, y, n);
    }
    
    public static void fillPolygon(Japi2Session session, Component component) throws IOException {
        int n = session.readInt();
        int[] x = new int[n];
        int[] y = new int[n];

        for (int i = 0; i < n; i++) {
            x[i] = session.readInt();
        }
        for (int i = 0; i < n; i++) {
            y[i] = session.readInt();
        }
        session.log3("Fill Polygon in {0}, Number of Points= {2}", component, n);
        component.getGraphics().fillPolygon(x, y, n);
    }
    
    public static void fillPolygon(Japi2Session session, Image image) throws IOException {
        int n = session.readInt();
        int[] x = new int[n];
        int[] y = new int[n];

        for (int i = 0; i < n; i++) {
            x[i] = session.readInt();
        }
        for (int i = 0; i < n; i++) {
            y[i] = session.readInt();
        }
        session.log3("Fill Polygon in {0}, Number of Points= {2}", image, n);
        image.getGraphics().fillPolygon(x, y, n);
    }
    
    public static void fillPolygon(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int n = session.readInt();
        int[] x = new int[n];
        int[] y = new int[n];

        for (int i = 0; i < n; i++) {
            x[i] = session.readInt();
        }
        for (int i = 0; i < n; i++) {
            y[i] = session.readInt();
        }
        session.log3("Fill Polygon in {0}, Number of Points= {2}", printJob, n);
        printJob.getGraphics().fillPolygon(x, y, n);
    }
    
    /*
     * These methods draw an outlined round-cornered rectangle to Japi2Canvas,
     * Component, Image or Japi2PrintJob. The left and right edges of the 
     * rectangle are at x and x + width. The top and bottom edges of the 
     * rectangle are at y and y + height.
     */
    
    public static void roundRect(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw Round Rect in {0}: {1} {2} {3} {4}", canvas, x, y, width, height, a, b);
        canvas.getGraphics().drawRoundRect(x, y, width, height, a, b);
    }
    
    public static void roundRect(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw Round Rect in {0}: {1} {2} {3} {4}", component, x, y, width, height, a, b);
        component.getGraphics().drawRoundRect(x, y, width, height, a, b);
    }
    
    public static void roundRect(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw Round Rect in {0}: {1} {2} {3} {4}", image, x, y, width, height, a, b);
        image.getGraphics().drawRoundRect(x, y, width, height, a, b);
    }
    
    public static void roundRect(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw Round Rect in {0}: {1} {2} {3} {4}", printJob, x, y, width, height, a, b);
        printJob.getGraphics().drawRoundRect(x, y, width, height, a, b);
    }
    
    /*
     * These methods draw a filled round-cornered rectangle to Japi2Canvas,
     * Component, Image or Japi2PrintJob. The left and right edges of the 
     * rectangle are at x and x + width. The top and bottom edges of the 
     * rectangle are at y and y + height.
     */
    
    public static void fillRoundRect(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw Filled Round Rect in {0}: {1} {2} {3} {4}", canvas, x, y, width, height, a, b);
        canvas.getGraphics().fillRoundRect(x, y, width, height, a, b);
    }
    
    public static void fillRoundRect(Japi2Session session, Component component) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw Filled Round Rect in {0}: {1} {2} {3} {4}", component, x, y, width, height, a, b);
        component.getGraphics().fillRoundRect(x, y, width, height, a, b);
    }
    
    public static void fillRoundRect(Japi2Session session, Image image) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw Filled Round Rect in {0}: {1} {2} {3} {4}", image, x, y, width, height, a, b);
        image.getGraphics().fillRoundRect(x, y, width, height, a, b);
    }
    
    public static void fillRoundRect(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int x = session.readInt();
        int y = session.readInt();
        int width = session.readInt();
        int height = session.readInt();
        int a = session.readInt();
        int b = session.readInt();

        session.log3("Draw Filled Round Rect in {0}: {1} {2} {3} {4}", printJob, x, y, width, height, a, b);
        printJob.getGraphics().fillRoundRect(x, y, width, height, a, b);
    }
    
    /**
     * This method loads an image from a given URL and adds it to the session 
     * Objects.
     * 
     * @param session the session context element.
     * @throws IOException is thrown if an IO error occurrs.
     */
    public static void loadImage(Japi2Session session) throws IOException {
        String title = session.readLine();
        
        Image image = Toolkit.getDefaultToolkit().getImage(new URL(
                "http", 
                session.getResourceHost(), 
                session.getResourcePort(), 
                title
        ));
        int oid = session.addObject(image);
        
        MediaTracker mt = new MediaTracker(session.getDebugWindow());
        mt.addImage(image, 0);
         try {
             mt.waitForAll();
         } catch (InterruptedException ex) {
             Japi2.getInstance().debug("Failed to wait for all media: {0}", ex);
         }
         
         session.log1("LOADIMAGE {0} (ID = {1})", title, oid);
         session.log1("{0} {1} {2}", session.getResourceHost(), 
                 session.getResourcePort(),title);

         if(image.getWidth(session.getDebugWindow()) < 0) {
             session.writeInt(-1);
         } else {
             session.writeInt(oid);
         }
    }
    
    /*
     * These methods draw a previously loaded Image to the 
     * graphics Object of a Component, Canvas, Image or PrintJob.
     */
    
    public static void drawImage(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int img = session.readInt();
        int x = session.readInt();
        int y = session.readInt();
        session.log3("DRAWIMAGE (1) {0} in {1}  at pos {2}:{3}", img, canvas, x, y);
        
        Image image = session.getObjectById(img, Image.class);
        canvas.getGraphics().drawImage(image, x, y, session.getDebugWindow()); 
    }
    
    public static void drawImage(Japi2Session session, Component component) throws IOException {
        int img = session.readInt();
        int x = session.readInt();
        int y = session.readInt();
        session.log3("DRAWIMAGE (2) {0} in {1}  at pos {2}:{3}", img, component, x, y);
        
        Image image = session.getObjectById(img, Image.class);
        component.getGraphics().drawImage(image, x, y, session.getDebugWindow()); 
    }
    
    public static void drawImage(Japi2Session session, Image pic) throws IOException {
        int img = session.readInt();
        int x = session.readInt();
        int y = session.readInt();
        session.log3("DRAWIMAGE (3) {0} in {1}  at pos {2}:{3}", img, pic, x, y);
        
        Image image = session.getObjectById(img, Image.class);
        pic.getGraphics().drawImage(image, x, y, session.getDebugWindow()); 
    }
    
    public static void drawImage(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int img = session.readInt();
        int x = session.readInt();
        int y = session.readInt();
        session.log3("DRAWIMAGE (4) {0} in {1}  at pos {2}:{3}", img, printJob, x, y);

        Image image = session.getObjectById(img, Image.class);
        printJob.getGraphics().drawImage(image, x, y, session.getDebugWindow()); 
    }  
    
    /*
     * Draws as much of the specified image as is currently available onto the 
     * graphic Object of a Japi2Canvas, Component, Image or Japi2PrintJob. 
     */
    
    public static void drawScaledImage(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int img = session.readInt();
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        int dx = session.readInt();
        int dy = session.readInt();
        int dw = session.readInt();
        int dh = session.readInt();
        session.log3("DRAWSCALEDIMAGE {0} in {1} at pos {2}:{3}:{4}:{5} => "
                + "{6}:{7}:{8}:{9}", img, canvas, sx, sy, sw, sh, dx, dy, dw, dh);
        
        Image image = session.getObjectById(img, Image.class);
        canvas.getGraphics().drawImage(image, dx, dy, dw, dh, sx, sy, sw, sh, canvas); 
    }
    
    public static void drawScaledImage(Japi2Session session, Component component) throws IOException {
        int img = session.readInt();
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        int dx = session.readInt();
        int dy = session.readInt();
        int dw = session.readInt();
        int dh = session.readInt();
        session.log3("DRAWSCALEDIMAGE {0} in {1} at pos {2}:{3}:{4}:{5} => "
                + "{6}:{7}:{8}:{9}", img, component, sx, sy, sw, sh, dx, dy, dw, dh);
        
        Image image = session.getObjectById(img, Image.class);
        component.getGraphics().drawImage(image, dx, dy, dw, dh, sx, sy, sw, sh, component); 
    }
    
    public static void drawScaledImage(Japi2Session session, Image pic) throws IOException {
        int img = session.readInt();
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        int dx = session.readInt();
        int dy = session.readInt();
        int dw = session.readInt();
        int dh = session.readInt();
        session.log3("DRAWSCALEDIMAGE {0} in {1} at pos {2}:{3}:{4}:{5} => "
                + "{6}:{7}:{8}:{9}", img, pic, sx, sy, sw, sh, dx, dy, dw, dh);
        
        Image image = session.getObjectById(img, Image.class);
        pic.getGraphics().drawImage(image, dx, dy, dw, dh, sx, sy, sw, sh, new JFrame()); 
    }
    
    public static void drawScaledImage(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int img = session.readInt();
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        int dx = session.readInt();
        int dy = session.readInt();
        int dw = session.readInt();
        int dh = session.readInt();
        session.log3("DRAWSCALEDIMAGE {0} in {1} at pos {2}:{3}:{4}:{5} => "
                + "{6}:{7}:{8}:{9}", img, printJob, sx, sy, sw, sh, dx, dy, dw, dh);
        
        Image image = session.getObjectById(img, Image.class);
        printJob.getGraphics().drawImage(image, dx, dy, dw, dh, sx, sy, sw, sh, new JFrame()); 
    }
    
    /*
     * A copy of the image attatched to the canvas is returned.
     */
    
    public static void getImage(Japi2Session session, Japi2Canvas canvas) throws IOException {
        session.log3("GETIMAGE from Object {0}", canvas);
        Image image = canvas.getImageCopy();
        session.writeInt(session.addObject(image));
    }
    
    /*
     * A copy of the scaled image attatched to the canvas is returned.
     */
    
    public static void getScaledImage(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        int dx = session.readInt();
        int dy = session.readInt();
        
        session.log3("GETSCALEDIMAGE from Object {0} from {1}:{2}:{3}:{4} => "
                + "{5}:{6}", canvas, sx, sy, sw, sh, dx, dy);
        Image image = canvas.getScaledImageCopy(sx, sy, sw, sh, dx, dy);
        session.writeInt(session.addObject(image));
    }
   
    /*
     * The following two methods get an image source from a Japi2Canvas or an 
     * image. The ordering is not relevant here. To write the information
     * back to the stream the methode writeBytes(byte[] b) is used. There is 
     * no need to specifiy the range to 0 to length. The array of bytes is 
     * initialized with length as its size.
     */
    
    public static void getImageSource(Japi2Session session, Japi2Canvas canvas) throws IOException, IllegalStateException {
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        session.log3("Get IMAGE SOURCE (1) from Object {0} from {1} : {2} : "
                + "{3} : {4}", canvas, sx, sy, sw, sh);
        
        int length = sw * sh;
        Image img = canvas.getImageCopy();
        int[] pic = new int[length];
        byte[] b = new byte[length];
        PixelGrabber grab = new PixelGrabber(img, sx, sy, sw, sh, pic, 0, sw); 
        
        try {
            grab.grabPixels();
        } catch (InterruptedException e) {
            throw new IllegalStateException("Can't grab pixels", e);
        }
        
        for (int i = 0; i < length; i++) {
            b[i] = (byte) (((pic[i] & 0x00ff0000) >> 16) & 0xff);
        }
        session.writeBytes(b); 
        for (int i = 0; i < length; i++) {
            b[i] = (byte) (((pic[i] & 0x0000ff00) >> 8) & 0xff);
        }
        session.writeBytes(b);
        for (int i = 0; i < length; i++) {
            b[i] = (byte) ((pic[i] & 0x000000ff) & 0xff);
        }
        session.writeBytes(b);
    }
    
    public static void getImageSource(Japi2Session session, Image image) throws IOException, IllegalStateException {
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        session.log3("Get IMAGE SOURCE (2) from Object {0} from {1} : {2} : "
                + "{3} : {4}", image, sx, sy, sw, sh);
 
        int length = sw * sh;
        Image img = image;
        int[] pic = new int[length];
        byte[] b = new byte[length];
        PixelGrabber grab = new PixelGrabber(img, sx, sy, sw, sh, pic, 0, sw); 
        
        try {
            grab.grabPixels();
        } catch (InterruptedException e) {
            throw new IllegalStateException("Can't grab pixels", e);
        }
        
        for (int i = 0; i < length; i++) {
            b[i] = (byte) (((pic[i] & 0x00ff0000) >> 16) & 0xff);
        }
        session.writeBytes(b); 
        for (int i = 0; i < length; i++) {
            b[i] = (byte) (((pic[i] & 0x0000ff00) >> 8) & 0xff);
        }
        session.writeBytes(b);
        for (int i = 0; i < length; i++) {
            b[i] = (byte) ((pic[i] & 0x000000ff) & 0xff);
        }
        session.writeBytes(b);
    }
    
    /*
     * The following three methods draw an Image to a Japi2Canvas, Image or 
     * PrintJob Object. The order of these methods is not important.  
     */
    
    public static void drawImageSource(Japi2Session session, Japi2Canvas canvas) throws IOException {
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        session.log3("Draw IMAGE SOURCE in Object {0} at {1} : {2} : {3} : {4}", 
                canvas, sx, sy, sw, sh);

        int length = sw * sh;
        int[] pic = new int[length];
        byte[] b = new byte[length];
        
        for (int i = 0; i < length; i++) {
            pic[i] = 0xff;
        }
        session.read(b, length);
        
        for (int i = 0; i < length; i++) {
            pic[i] = ((pic[i] << 8) | (b[i] > 0 ? b[i] : 256 + b[i]));
        }
        session.read(b, length);
        
        for (int i = 0; i < length; i++) {
            pic[i] = ((pic[i] << 8) | (b[i] > 0 ? b[i] : 256 + b[i]));
        }
        session.read(b, length);
        
        for (int i = 0; i < length; i++) {
            pic[i] = ((pic[i] << 8) | (b[i] > 0 ? b[i] : 256 + b[i]));
        }
        MemoryImageSource memimg = new MemoryImageSource(sw, sh, pic, 0, sw);
        
        Image img = canvas.createImage(memimg);
        canvas.getGraphics().drawImage(img, sx, sy, canvas);
    }
    
    
    public static void drawImageSource(Japi2Session session, Image image) throws IOException {
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        session.log3("Draw IMAGE SOURCE in Object {0} at {1} : {2} : {3} : {4}", 
                image, sx, sy, sw, sh);

        int length = sw * sh;
        int[] pic = new int[length];
        byte[] b = new byte[length];
        
        for (int i = 0; i < length; i++) {
            pic[i] = 0xff;
        }
        session.read(b, length);
        
        for (int i = 0; i < length; i++) {
            pic[i] = ((pic[i] << 8) | (b[i] > 0 ? b[i] : 256 + b[i]));
        }
        session.read(b, length);
        
        for (int i = 0; i < length; i++) {
            pic[i] = ((pic[i] << 8) | (b[i] > 0 ? b[i] : 256 + b[i]));
        }
        session.read(b, length);
        
        for (int i = 0; i < length; i++) {
            pic[i] = ((pic[i] << 8) | (b[i] > 0 ? b[i] : 256 + b[i]));
        }
        MemoryImageSource memimg = new MemoryImageSource(sw, sh, pic, 0, sw);
        
        Image img = session.getDebugWindow().createImage(memimg);
        image.getGraphics().drawImage(img, sx, sy, session.getDebugWindow());
    }
    
    public static void drawImageSource(Japi2Session session, Japi2PrintJob printJob) throws IOException {
        int sx = session.readInt();
        int sy = session.readInt();
        int sw = session.readInt();
        int sh = session.readInt();
        session.log3("Draw IMAGE SOURCE in Object {0} at {1} : {2} : {3} : {4}", 
                printJob, sx, sy, sw, sh);

        int length = sw * sh;
        int[] pic = new int[length];
        byte[] b = new byte[length];
        
        for (int i = 0; i < length; i++) {
            pic[i] = 0xff;
        }
        session.read(b, length);
        
        for (int i = 0; i < length; i++) {
            pic[i] = ((pic[i] << 8) | (b[i] > 0 ? b[i] : 256 + b[i]));
        }
        session.read(b, length);
        
        for (int i = 0; i < length; i++) {
            pic[i] = ((pic[i] << 8) | (b[i] > 0 ? b[i] : 256 + b[i]));
        }
        session.read(b, length);
        
        for (int i = 0; i < length; i++) {
            pic[i] = ((pic[i] << 8) | (b[i] > 0 ? b[i] : 256 + b[i]));
        }
        MemoryImageSource memimg = new MemoryImageSource(sw, sh, pic, 0, sw);
        
        Toolkit tk = Toolkit.getDefaultToolkit();
        Image img = tk.createImage(memimg);
        
        printJob.getGraphics().drawImage(img, sx, sy, null);
    }
    
}
