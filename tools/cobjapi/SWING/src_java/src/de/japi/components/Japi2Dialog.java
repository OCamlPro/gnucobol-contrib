package de.japi.components;

import de.japi.components.layout.Japi2FixLayout;
import java.awt.Font;
import java.awt.Insets;
import javax.swing.JDialog;
import javax.swing.JFrame;

/**
 * Adapted implementation of JDialog for the Japi2 Kernel.
 */
public class Japi2Dialog extends JDialog {

    private Insets inset;

    public Japi2Dialog(JFrame parent, String title) {
        super(parent, title, false);
        this.setLayout(new Japi2FixLayout());
    }

//    @Override
//    public void setResizable(boolean set) {
//        resizable = set;
//        repaint(-1);
//    }
    
//    @Override
//    public void paint(Graphics g) {
//        if (isResizable() != resizable) {
//            super.setResizable(resizable);
//        }
//    }

    @Override
    public void setEnabled(boolean b) {
        for (int i = 0; i < getComponentCount(); i++) {
            getComponent(i).setEnabled(b);
        }
    }

    public void setInsets(int top, int bottom, int left, int right) {
        inset = new Insets(top, left, bottom, right);
    }
    
    @Override
    public void revalidate() {
        super.revalidate();
        getContentPane().revalidate();
    }

    @Override
    public Insets getInsets() {
        if (inset != null) {
            return (inset);
        } else {
            return (super.getInsets());
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
        return "Dialog[title=" + getTitle() + "]";
    }
    
}
