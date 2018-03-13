package de.japi.components;

import de.japi.Icon;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import javax.swing.Box;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;
import javax.swing.WindowConstants;
import javax.swing.border.EmptyBorder;

/**
 * This class provides modal dialogs for the Japi2 Kernel. Beneath an alert
 * dialog (with an warning icon) also multiple modal dialogs to prompt the
 * user are possible.
 */
public class Japi2AlertDialog extends JDialog implements ActionListener, WindowListener {

    private final String text;
    private final ImageIcon icon;
    private final JButton[] buttons;
    private int retVal;
    
    /**
     * Displays an information dialog (non blocking).
     * 
     * @param parent the parent frame.
     * @param title the title.
     * @param text the content.
     */
    public Japi2AlertDialog(JFrame parent, String title, String text) {
        super(parent, title, true);
        this.text = text;
        this.icon = Icon.DIALOG_INFO;
        this.buttons = new JButton[] {};
        setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
        initGui();
        placeAndShow(false);
    }
    
    /**
     * Displays an alert dialog (blocking).
     * 
     * @param parent the parent frame.
     * @param title the title.
     * @param text the message.
     * @param b1 the single button to quit this dialog.
     */
    public Japi2AlertDialog(JFrame parent, String title, String text, String b1) {
        super(parent, title, true);
        this.text = text;
        this.icon = Icon.DIALOG_ERROR;
        this.buttons = new JButton[] {new JButton(b1)};
        this.retVal = 0;
        setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
        addWindowListener(this);
        initGui();
        placeAndShow(true);
    }
    
    /**
     * Displays a question dialog with two buttons (blocking).
     * 
     * @param parent the parent frame.
     * @param title the title of this dialog.
     * @param text the message.
     * @param b1 caption of the first button.
     * @param b2 caption of the second button.
     */
    public Japi2AlertDialog(JFrame parent, String title, String text, String b1, String b2) {
        super(parent, title, true);
        this.text = text;
        this.icon = Icon.DIALOG_QUESTION;
        this.buttons = new JButton[] {new JButton(b1), new JButton(b2)};
        this.retVal = 0;
        setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
        addWindowListener(this);
        initGui();
        placeAndShow(true);
    }
    
    /**
     * Displays a question dialog with three buttons (blocking).
     * 
     * @param parent the parent frame.
     * @param title the title of this dialog.
     * @param text the message.
     * @param b1 caption of the first button.
     * @param b2 caption of the second button.
     * @param b3 caption of the third button.
     */
    public Japi2AlertDialog(JFrame parent, String title, String text, String b1, String b2, String b3) {
        super(parent, title, true);
        this.text = text;
        this.icon = Icon.DIALOG_QUESTION;
        this.buttons = new JButton[] {new JButton(b1), new JButton(b2), new JButton(b3)};
        this.retVal = 0;
        setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
        addWindowListener(this);
        initGui();
        placeAndShow(true);
    }
    
    /**
     * Sets up the GUI.
     */
    private void initGui() {
        JPanel contentPane = new JPanel(new BorderLayout());
        setContentPane(contentPane);
        
        // Place icon and text message
        JPanel panel = new JPanel(new BorderLayout(16, 16));
        panel.setBorder(new EmptyBorder(16, 16, 16, 16));
        contentPane.add(panel, BorderLayout.NORTH);
        panel.add(new JLabel(icon), BorderLayout.WEST);
        panel.add(new JLabel("<html>" + text
//                .replaceAll("<", "&lt;")
//                .replaceAll(">", "&gt;")
                .replaceAll("[\n|\r\n]", "<br/>")), 
                BorderLayout.CENTER
        );
        
        // Place buttons
        Box hBox = Box.createHorizontalBox();
        hBox.add(Box.createHorizontalGlue());
        for (int i = 0; i < buttons.length; i++) {
            JButton button = buttons[i];
            button.addActionListener(this);
            hBox.add(button);
            if (i < buttons.length - 1) {
                hBox.add(Box.createHorizontalStrut(3));
            }
        }
        panel.add(hBox, BorderLayout.SOUTH);
    }
    
    /**
     * Displays the GUI.
     * 
     * @param block Indicates if this method should block until the dialog
     * is closed.
     */
    public final void placeAndShow(boolean block) {
        if (block) {
            pack();
            setMinimumSize(new Dimension(460, 0));
            setResizable(false);
            setLocationRelativeTo(getParent());
            toFront();
            setVisible(true);
            return;
        }
        
        // Run in EDT
        SwingUtilities.invokeLater(new Runnable() {

            @Override
            public void run() {
                pack();
                setMinimumSize(new Dimension(460, 0));
                setResizable(false);
                setLocationRelativeTo(getParent());
                setVisible(true);
                toFront();
            }
        });
    }
    
    /**
     * Returns the index of the clicked button. This number will start with
     * the first button and index <u>1</u>.
     * 
     * @return the index of the clicked button or an other value set through
     * {@link #setRetVal(int)}.
     */
    public int getValue() {
        return retVal;
    }

    /**
     * Predefines a return value, see {@link #getValue()}.
     * 
     * @param retVal the predefined return value.
     */
    public void setRetVal(int retVal) {
        this.retVal = retVal;
    }

    @Override
    public String toString() {
        StringBuilder buf = new StringBuilder("Japi2AlertBox[title=");
        buf.append(getTitle());
        buf.append(", buttons={");
        for (JButton button : buttons) {
            buf.append(button.getText());
            buf.append(", ");
        }
        if (buttons.length > 0) {
            buf.setLength(buf.length() - 1);
        }
        buf.append("}, parent=");
        buf.append(String.valueOf(getParent()));
        buf.append(']');
        return buf.toString();
    }
    
    @Override
    public void actionPerformed(ActionEvent e) {
        retVal = 0;
        for (int i = 0; i < buttons.length; i++) {
            if (buttons[i] == e.getSource()) {
                retVal = i + 1;
                break;
            }
        }
        dispose();
    }

    @Override
    public void windowOpened(WindowEvent e) {
        // Unused
    }

    @Override
    public void windowClosing(WindowEvent e) {
        retVal = 0;
        dispose();
    }

    @Override
    public void windowClosed(WindowEvent e) {
        // Unused
    }

    @Override
    public void windowIconified(WindowEvent e) {
        // Unused
    }

    @Override
    public void windowDeiconified(WindowEvent e) {
        // Unused
    }

    @Override
    public void windowActivated(WindowEvent e) {
        if (buttons.length > 0) {
            buttons[0].requestFocus();
        }
    }

    @Override
    public void windowDeactivated(WindowEvent e) {
        // Unused
    }
    
}
