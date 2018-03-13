package de.japi.components;

import de.japi.Japi2;
import de.japi.Japi2Session;
import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Container;
import java.awt.Font;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.Panel;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.ClipboardOwner;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Transferable;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.text.MessageFormat;
import javax.swing.Box;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComponent;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.SwingUtilities;
import javax.swing.border.EmptyBorder;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;
import javax.swing.text.Element;
import javax.swing.text.PlainDocument;

/**
 * Debug window for a {@link Japi2Session}. This debug window displays only the
 * log messages which arise from the session.
 */
public class Japi2DebugWindow extends JDialog implements ClipboardOwner, 
        ActionListener {

    /**
     * The main text area for displaying the debug messages.
     */
    private JTextArea textArea;
    
    /**
     * Action buttons of this debug window.
     */
    private JButton copyBtn, closeBtn;
    
    /**
     * Checkbox indicating if the scrolling should be performed automatically.
     */
    private JCheckBox autoScroll;
    
    /**
     * The log level set for this component.
     */
    private int logLevel;
    
    /**
     * Constructs a new debug window.
     * 
     * @param session the session to which this debug window is bound to.
     */
    public Japi2DebugWindow(Japi2Session session) {
        this.logLevel = -1;
        setTitle(MessageFormat.format(
                Japi2.getInstance().getString("Title.debugConsole"), 
                session.toString()
        ));
        setModal(false);
        initGui();
    }
    
    /**
     * Creates all components and adds them to the window.
     */
    private void initGui() {
        // Create buttons
        copyBtn = new JButton(
                Japi2.getInstance().getString("Button.copyCB")
        );
        copyBtn.setAlignmentX(JComponent.CENTER_ALIGNMENT);
        copyBtn.setMnemonic(KeyEvent.VK_Y);
        copyBtn.addActionListener(this);
        
        closeBtn = new JButton(
                Japi2.getInstance().getString("Button.close")
        );
        closeBtn.setAlignmentX(JComponent.CENTER_ALIGNMENT);
        closeBtn.setMnemonic(KeyEvent.VK_E);
        closeBtn.addActionListener(this);
        
        // Text area
        textArea = new JTextArea("", 26, 75);
        textArea.setDocument(new RotatingDocument());
        textArea.setFont(Font.decode(Font.MONOSPACED));
        textArea.setEditable(false);
        
        autoScroll = new JCheckBox(
                Japi2.getInstance().getString("CheckBox.autoScroll"),
                true
        );

        // Layout
        setContentPane(new JPanel(new BorderLayout(4, 4)));
        ((JPanel) getContentPane()).setBorder(new EmptyBorder(0, 0, 4, 0));
        add(new JScrollPane(textArea), BorderLayout.CENTER);
        Box hor = Box.createHorizontalBox();
        hor.add(Box.createHorizontalGlue());
        hor.add(copyBtn);
        hor.add(closeBtn);
        hor.add(autoScroll);
        hor.add(Box.createHorizontalGlue());
        add(hor, BorderLayout.SOUTH);
    }
    
    /**
     * Sets the log level for this debug window.
     * 
     * @param level the new log level. If the level is greater than zero, the
     * debug window is automatically displayed. Otherwise the window is hidden
     * if it was visible.
     */
    public void setLevel(int level) {
        this.logLevel = level;
        
        if (level > 0) {
            display();
        } else {
            SwingUtilities.invokeLater(new Runnable() {

                @Override
                public void run() {
                    setVisible(false);
                }
            });
        }
    }
    
    /**
     * Displays this debug window if not already visible.
     */
    public final void display() {
        if (isVisible()) {
            return;
        }
        
        SwingUtilities.invokeLater(new Runnable() {

            @Override
            public void run() {
                pack();
                
                // Place window in the right top of the screen
                GraphicsEnvironment ge = GraphicsEnvironment
                        .getLocalGraphicsEnvironment();
                GraphicsDevice defaultScreen = ge.getDefaultScreenDevice();
                Rectangle rect = defaultScreen.getDefaultConfiguration()
                        .getBounds();
                setLocation((int) (rect.getMaxX() - getWidth()), 0);
                
                setVisible(true);
            }
        });
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == closeBtn) {
            dispose();
        } else if (e.getSource() == copyBtn) {
            Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
            clipboard.setContents(new StringSelection(textArea.getText()), this);
        }
    }

    @Override
    public void lostOwnership(Clipboard clipboard, Transferable contents) {
        // Ignore
    }
    
    /**
     * Prints a message on this debug window, iff the given <code>level</code> 
     * for this message is less than the global logging level set via the
     * {@link #setLevel(int)} method.
     * 
     * <p>
     * See also {@link Japi2Session} especially the logging methods and 
     * {@link #prettifyArguments(java.lang.Object[])} for argument preprocessing.
     * </p>
     * 
     * @param level the level of this message.
     * @param msg the message itself.
     * @param args the arguments to place inside the message
     */
    public synchronized void println(int level, String msg, Object...args) {
        if (logLevel > level) {
            textArea.append(MessageFormat.format(
                    msg, prettifyArguments(args)
            ) + "\n"
            );
            
            if (autoScroll.isSelected()) {
                textArea.setCaretPosition(textArea.getDocument().getLength());
            }
        }
    }
    
    /**
     * This {@link Document} keeps no more than a sepecific amount of text 
     * line, {@link Japi2#getDebugLineBuffer()} many. The lines are rotated.
     * That means the oldest message is deleted first.
     */
    private class RotatingDocument extends PlainDocument {

        @Override
        public void insertString(int offs, String str, AttributeSet a) 
                throws BadLocationException {
            // Insert the string
            super.insertString(offs, str, a);
            
            // Remove the first lines if needed
            Element es = getDefaultRootElement();
            if (es.getElementCount() > Japi2.getInstance().getDebugLineBuffer()) {
                Element e0 = es.getElement(0);
                replace(
                        e0.getStartOffset(), 
                        e0.getEndOffset() - e0.getStartOffset(), 
                        "", 
                        null
                );
            }
        }

    }
    
    /**
     * Parses the arguments for logging and converts them into a nice textual
     * representation which is not too short and not too long to display.
     * 
     * @param args the arguments to prettify or <code>null</code>.
     * @return the prettified arguments as {@link String}s.
     */
    public static Object[] prettifyArguments(Object...args) {
        Object[] args2 = new Object[args == null ? 0 : args.length];
        for (int i = 0; i < args2.length; i++) {
            args2[i] = toString(args[i]);
        }
        return args2;
    }

    /**
     * Converts an {@link Object} to a nice textual representation.
     * 
     * @param o the {@link Object} to convert.
     * @return the textual representation as {@link String}.
     */
    public static String toString(Object o) {
        if (o != null && o.getClass().getSimpleName().toLowerCase().contains("japi2")) {
            return o.toString();
        }
        
        if (o instanceof JFrame) {
            return "JFrame@" + o.hashCode();
        } else if (o instanceof JDialog) {
            return "JDialog@" + o.hashCode();
        }
        
        if (o instanceof BufferedImage) {
            
            String type = "";
            switch (((BufferedImage) o).getType()) {
                case BufferedImage.TYPE_INT_RGB:
                    type = "RGB";
                    break;
                    
                case BufferedImage.TYPE_INT_ARGB:
                    type = "ARGB";
                    break;
                    
                default:
                    type = "OTHER(" + ((BufferedImage) o).getType() + ")";
            }
            
            return "BImage[" + ((BufferedImage) o).getWidth() + "x" + 
                    ((BufferedImage) o).getHeight() + ",type=" +
                    type + ",id=" + Integer.toHexString(o.hashCode()) + "]";
            
        }
        
        if (o instanceof Panel) {
            return "Panel@" + o.hashCode() + "[parent=" 
                    + toString(((Panel) o).getParent()) + "]";
        } else if (o instanceof Component) {
            return "Component@" + o.hashCode();
        } else if (o instanceof Container) {
            return "Container@" + o.hashCode();
        } else {
            return String.valueOf(o);
        }
    }
    
}
