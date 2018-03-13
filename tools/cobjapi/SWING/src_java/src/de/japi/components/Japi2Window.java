/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.japi.components;

import de.japi.components.layout.Japi2FixLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.Insets;
import javax.swing.JFrame;
import javax.swing.JWindow;

/**
 * An adaption of {@link JWindow} for the needs of the Japi2 Kernel.
 */
public class Japi2Window extends JWindow {

    private Insets inset;

    public Japi2Window(JFrame parent) {
        super(parent);
        this.setLayout(new Japi2FixLayout());
    }

    @Override
    public void setEnabled(boolean b) {
        int i;
        for (i = 0; i < getComponentCount(); i++) {
            getComponent(i).setEnabled(b);
        }
    }

    /**
     * Sets the {@link Insets} of this frame.
     * 
     * @param insets the {@link Insets} to set or <code>null</code> to clear
     * the active {@link Insets}.
     */
    public void setInsets(Insets insets) {
        this.inset = insets;
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
        int i;
        super.setFont(f);
        for (i = 0; i < getComponentCount(); i++) {
            if (getComponent(i).isDisplayable()) {
                getComponent(i).setFont(f);
            }
        }
    }

    @Override
    public void setBackground(Color c) {
        super.setBackground(c);
        int i;
        for (i = 0; i < getComponentCount(); i++) {
            getComponent(i).setBackground(c);
        }
        // menus haben keine Funktionen zum Setzen der Farben
    }

}
