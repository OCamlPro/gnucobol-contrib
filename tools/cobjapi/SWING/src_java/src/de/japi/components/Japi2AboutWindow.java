package de.japi.components;

import de.japi.Icon;
import de.japi.Japi2;
import de.japi.Japi2Constants;
import java.awt.BorderLayout;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.MessageFormat;
import javax.swing.Box;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.UIManager;
import javax.swing.WindowConstants;
import javax.swing.border.EmptyBorder;

/**
 * This class is a simple about dialog for the Japi2 Kernel.
 */
public class Japi2AboutWindow extends JFrame implements ActionListener {
    
    /**
     * Constructs the about window.
     */
    public Japi2AboutWindow() {
        super(Japi2.getInstance().getString("Tray.about"));
        setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
        initGui();
    }
    
    /**
     * Sets up the GUI.
     */
    private void initGui() {
        JPanel contentPane = new JPanel(new BorderLayout(16, 16));
        setContentPane(contentPane);
        contentPane.setBorder(new EmptyBorder(16, 16, 16, 16));
        contentPane.add(new JLabel(new ImageIcon(Icon.getAppIcon(256))), 
                BorderLayout.NORTH);
        contentPane.add(new JLabel("<html><center>" + 
                MessageFormat.format(Japi2.getInstance().getString("About"), 
                        Japi2Constants.BUILD_ID).replaceAll("\n","<br>")), 
                BorderLayout.CENTER);
        Box hBox = Box.createHorizontalBox();
        hBox.add(Box.createHorizontalGlue());
        JButton close = new JButton(UIManager.getString("OptionPane.okButtonText"));
        close.addActionListener(this);
        hBox.add(close);
        contentPane.add(hBox, BorderLayout.SOUTH);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        dispose();
    }
    
    /**
     * Displays the about window.
     */
    public void placeAndShow() {
        // Run in EDT
        SwingUtilities.invokeLater(new Runnable() {

            @Override
            public void run() {
                pack();
                setResizable(false);
                setVisible(true);
                Dimension dim = Toolkit.getDefaultToolkit().getScreenSize();
                setLocation(
                        dim.width/2-getSize().width/2, 
                        dim.height/2-getSize().height/2
                );
                setAlwaysOnTop(true);
            }
        });
    }
    
}
