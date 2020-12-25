package de.japi.components;

import de.japi.Japi2;
import de.japi.components.layout.Japi2FixLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Insets;
import java.awt.LayoutManager;
import java.awt.Point;
import javax.swing.JFrame;
import javax.swing.JInternalFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

/**
 * An extended version of the {@link JFrame} that adds support for settings
 * {@link Insets} since this is required by JAPI.
 */
public class Japi2InternalFrame extends JInternalFrame {
    
    /**
     * The internal content pane. This special pane is needed to provide an
     * insets option due to the fact that {@link JFrame} does not support 
     * AWT like insets.
     */
    private final JPanel contentPanel;
    
    /**
     * Creates a new frame.
     * 
     * @param title the title of the frame.
     * @param resizableFlag if frame resizable.
     * @param closableFlag if frame closable.
     * @param maximizableFlag if frame maximizable.
     * @param iconifiableFlag if frame iconifiable.
     */
    public Japi2InternalFrame(String title, boolean resizableFlag, boolean closableFlag, boolean maximizableFlag, boolean iconifiableFlag) {
        super(title, resizableFlag, closableFlag, maximizableFlag, iconifiableFlag);
        super.setContentPane(contentPanel = new JPanel());
        contentPanel.setLayout(new Japi2FixLayout());
        
        // Yet another chapter of the book of strange SWING bugs: if the following
        // line is omitted (or replaced by s.th. like frame.setLocationByPlatform(true);)
        // the Frame will slide over the screen (tested on Mac OS X) if the
        // resizeable property is changed
        super.setLocation(new Point(0, 0));
        
        setInsets(null);
        setContentSize(400, 300);
    }
    
    /**
     * Sets the inner size of this {@link JFrame}.
     * 
     * @param width the new width of the window.
     * @param height the new height of the window.
     */
    public final void setContentSize(int width, int height) {
        super.setSize(new Dimension(
                width - (super.getInsets().left + super.getInsets().right),
                height - (super.getInsets().top + super.getInsets().bottom)
        ));
    }

    /**
     * <span style="color:red;">
     * Warning: this method should not be used and is reserved for the SWING 
     * system. Use instead {@link #getInsetsReal()}.
     * </span>
     * 
     * @return the {@link Insets} for the SWING system.
     */
    @Override
    public final Insets getInsets() {
        return super.getInsets();
    }
    
    /**
     * Returns the "real" {@link Insets} of this frame set by the corresponding
     * method {@link #setInsets(java.awt.Insets)}.
     * 
     * @return the {@link Insets}, never <code>null</code>.
     */
    public final Insets getInsetsReal() {
        if (contentPanel == null || contentPanel.getBorder() == null) {
            return new Insets(0, 0, 0, 0);
        } else {
            return contentPanel.getBorder().getBorderInsets(contentPanel);
        }
    }
    
    /**
     * Sets the {@link Insets} of this frame by creating an empty border with
     * the specified thickness due to the fact that {@link Insets} is not 
     * (directly) supported by SWING.
     * 
     * @param insets the {@link Insets} to set or <code>null</code> to clear
     * the active {@link Insets}.
     */
    public final void setInsets(Insets insets) {
        if (insets == null) {
            contentPanel.setBorder(new EmptyBorder(new Insets(0, 0, 0, 0)));
        } else {
            contentPanel.setBorder(new EmptyBorder(insets));
        }
    }

    @Override
    public void setResizable(boolean resizable) {
        super.setResizable(resizable);
    }

    @Override
    public void revalidate() {
        super.revalidate();
        getContentPane().revalidate();
    }

    @Override
    public void setLayout(LayoutManager manager) {
        super.setLayout(manager);   
        if (contentPanel != null) {
            contentPanel.setLayout(manager);
        }
    }

    @Override
    public LayoutManager getLayout() {
        if (contentPanel == null) {
            return super.getLayout();
        } else {
            return contentPanel.getLayout();
        }
    }
    
    @Override
    public void setEnabled(boolean b) {
        super.setEnabled(b);
        for (int i = 0; i < getComponentCount(); i++) {
            getComponent(i).setEnabled(b);
        }
        
        if (getJMenuBar() != null) {
            getJMenuBar().setEnabled(b);
        }
        
        if (getMenuBar() != null) {
            Japi2.getInstance().debug("WARNING: AWT MenuBar set on {0}: {1}", 
                    getClass().getSimpleName(), getMenuBar());
        }
    }

    @Override
    public void setBackground(Color bgColor) {
        super.setBackground(bgColor);
        for (int i = 0; i < getComponentCount(); i++) {
            getComponent(i).setBackground(bgColor);
        }
    }

    @Override
    public void setFont(Font f) {
        super.setFont(f);
        for (int i = 0; i < getComponentCount(); i++) {
            getComponent(i).setFont(f);
        }
    }
    
    @Override
    public String toString() {
        return "InternalFrame[title=" + getTitle() + "," + getWidth() + "x" 
                + getHeight() + "," + (isVisible() ? "visible" : "hidden") 
                + ",layout=" + (getLayout() == null ? "NULL" : 
                getLayout().getClass().getSimpleName()) + "]";
    }
    
}
