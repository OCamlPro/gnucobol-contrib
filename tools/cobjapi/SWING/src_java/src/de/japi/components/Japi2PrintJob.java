package de.japi.components;

import de.japi.Japi2;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.PrintJob;
import java.awt.image.BufferedImage;
import java.awt.print.PageFormat;
import java.awt.print.Paper;
import java.awt.print.Printable;
import static java.awt.print.Printable.NO_SUCH_PAGE;
import static java.awt.print.Printable.PAGE_EXISTS;
import java.awt.print.PrinterException;
import java.awt.print.PrinterJob;
import java.util.ArrayList;
import java.util.List;

/**
 * This class is a more sophisticated custom implementation of a Java 
 * {@link PrintJob}. The problem with plain {@link PrintJob}s is that one can't
 * obtain the size of the border and might draw outside of the printable area.
 * This problem is solved by this class: the method {@link #getPageDimension()}
 * and {@link #getGraphics()} will return dimenstions or graphics which
 * automagical consider the page border and the user of this class does not 
 * need to care about this.
 */
public class Japi2PrintJob {
    
    /**
     * The {@link PrinterJob}.
     */
    private PrinterJob job;
    
    /**
     * List of all pages which are going to be painted.
     */
    private List<PrintPage> pages;
    
    /**
     * Pointer to the actual page.
     */
    private int pagePointer;
    
    /**
     * A single page consisting of a {@link BufferedImage} and the opened
     * {@link Graphics} object.
     */
    private class PrintPage {
        BufferedImage buf;
        Graphics graphics;
    }

    /**
     * The format of the page which gets printed.
     */
    private PageFormat pageFormt;
    
    /**
     * The printed page dimensions containing <u>NOT</u> the page border.
     */
    private Dimension size;
    
    /**
     * Enum to provide standard page sizes.
     */
    public enum Page {
        A4(.4, .4, 8.268, 11.693);
        
        Paper paper;
        
        Page(double bX, double bY, double w, double h) {
            paper = new Paper();
            int pxbx = (int) Math.round(bX * 72d);
            int pxby = (int) Math.round(bY * 72d);
            paper.setImageableArea(pxbx, pxby,  
                    (w * 72d) - 2*pxbx, (h * 72d) - 2*pxby);
            paper.setSize(w * 72d, h * 72d);
        }
        
    }
    
    /**
     * Constructs a new {@link Japi2PrintJob} with an <code>DIN A4</code> sized
     * paper.
     * 
     * @throws IllegalStateException is thrown if the job was cancelled by 
     * the user or can't be created due to the fact that the current system does 
     * not support printing.
     */
    public Japi2PrintJob() throws IllegalStateException {
        this(Page.A4);
    }
    
    /**
     * Constructs a new {@link Japi2PrintJob}.
     * 
     * <p>
     * A known bug is the fact, that the border at the bottom is bigger than
     * the other borders.
     * </p>
     * 
     * @param page the {@link Page} size.
     * @throws IllegalStateException is thrown if the job was cancelled by 
     * the user or can't be created due to the fact that the current system does 
     * not support printing.
     */
    public Japi2PrintJob(Page page) throws IllegalStateException {
        // Try to get a job
        try {
            job = PrinterJob.getPrinterJob();
        } catch (Exception ex) {
            Japi2.getInstance().debug("Can't create print job!", ex);
            job = null;
        }
        
        if (job == null) {
            throw new IllegalStateException();
        }
        // Create the page format and setup the job
        pageFormt = new PageFormat();
        pageFormt.setPaper(page.paper);
        pageFormt.setOrientation(PageFormat.PORTRAIT);
        pageFormt = job.getPageFormat(null);
        job.setPrintable(new Japi2Printable(), pageFormt);

        // Show the print dialog
        if (!job.printDialog()) {
            // The user cancelled printing ...
            throw new IllegalStateException();
        }
        
        // Prepare the "off-screen" image to print on
        Paper p = pageFormt.getPaper();
        size = new Dimension(
                (int) p.getImageableWidth(),
                (int) p.getImageableHeight()
        );
        
        // Create a new page
        pages = new ArrayList<PrintPage>();
        pagePointer = -1;
        newPage();
    }
    
    /**
     * Returns the {@link Dimension} of the imageable area of the page. The 
     * result of this method already takes the page border into account.
     * 
     * @return the size of the page.
     */
    public Dimension getPageDimension() {
        return size;
    }
    
    /**
     * Creates a new page on this print job.
     */
    public final void newPage() {
        // Dispose the graphics
        if (pagePointer >= 0) {
            pages.get(pagePointer).graphics.dispose();
        }
        
        // Create a new graphics aka "page"
        pagePointer++;
        PrintPage newPage = new PrintPage();
        pages.add(newPage);
        
        // Setup the page
        newPage.buf = new BufferedImage(size.width, size.height, 
                BufferedImage.TYPE_INT_RGB);
        // Clear background
        newPage.graphics = newPage.buf.getGraphics();
        newPage.graphics.setColor(Color.WHITE);
        newPage.graphics.fillRect(0, 0, size.width, size.height);
        
        // Initial setup
        newPage.graphics.setColor(Color.BLACK);
        newPage.graphics.setFont(new Font(Font.DIALOG, Font.PLAIN, 12));
    }
    
    /**
     * Ends this print job, meaning that the page is going to be printed.
     * 
     * @return <code>true</code> if the page was send successfully to the 
     * printer and otherwise <code>false</code>.
     */
    public boolean end() {
        // Dispose the last graphics
        if (pagePointer >= 0) {
            pages.get(pagePointer).graphics.dispose();
        }
        
        try {
            job.print();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * The {@link Graphics} object of this print job. One can draw directly
     * to this graphic without taking the page border into account. Also
     * multiple calls will provide the same {@link Graphics} object.
     * 
     * @return the graphics, never <code>null</code>.
     */
    public Graphics getGraphics() {
        // Dispose the graphics
        if (pagePointer >= 0) {
            return pages.get(pagePointer).graphics;
        }
        
        throw new IllegalStateException("No page available to draw to.");
    }
    
    /**
     * Internal {@link Printable} to print the image.
     */
    private class Japi2Printable implements Printable {

        @Override
        public int print(Graphics g, PageFormat f, int p) throws PrinterException {
            if (p >= pages.size()) {
                return NO_SUCH_PAGE; // Only one page
            }
            g.translate((int) f.getImageableX(), (int) f.getImageableY());
            g.drawImage(pages.get(p).buf, 0, 0, null);
            return PAGE_EXISTS;
        }
    }
    
}
