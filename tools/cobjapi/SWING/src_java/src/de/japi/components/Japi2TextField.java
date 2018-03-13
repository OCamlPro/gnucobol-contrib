package de.japi.components;

import java.awt.Dimension;
import javax.swing.JTextField;
import javax.swing.plaf.ComponentUI;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.PlainDocument;

/**
 * Component that allows the editing of a single line of text.
 */
public class Japi2TextField extends JTextField {

    /**
     * The size properties for this text field.
     */
    private int w = 0, h = 0;
    
    /**
     * The text inserted into this text field.
     */
    private final StringBuilder text;

    /**
     * Constructs a new empty <code>Japi2TextField</code> with the specified
     * number of columns.
     *
     * @param col the number of columns to use to calculate the preferred width;
     * if columns is set to zero, the preferred width will be whatever naturally
     * results from the component implementation
     */
    public Japi2TextField(int col) {
        super(col);
        setDocument(new Japi2EchoCharDocument(null));
        text = new StringBuilder();
    }
    
    /**
     * Sets the echo character for this text field or resets it to default
     * behaviour if the given character is <code>null</code>.
     * 
     * @param c the character to use as echo character.
     */
    public void setEchoChar(Character c) {
        String text = getText();
        setText("");
        setDocument(new Japi2EchoCharDocument(c));
        setText(text);
    }

    @Override
    public String getText() {
        return text.toString();
    }
    
    @Override
    public void setSize(int width, int height) {
        w = width > 0 ? width : 0;
        h = height > 0 ? height : 0;
        super.setSize(w, h);
    }

    @Override
    public String toString() {
        StringBuilder buf = new StringBuilder("Japi2TextField[columns=");
        buf.append(getColumns());

        buf.append(", parent=");
        buf.append(String.valueOf(getParent()));
        buf.append(']');

        return buf.toString();
    }

    /**
     * Returns a Dimension object with the preferred size of the TextArea. This
     * is the maximum of the size needed to display the text and the size
     * requested for the viewport.
     *
     * @return the size
     */
    @Override
    public Dimension getPreferredSize() {
        Dimension dim = super.getPreferredSize();
        dim.width = w > 0 ? w : dim.width;
        dim.height = h > 0 ? h : dim.height;
        return (dim);
    }

    /**
     * If the minimum size has been set to a non-<code>null</code> value just
     * returns it. If the UI delegate's <code>getMinimumSize</code> method
     * returns a non-<code>null</code> value then return that; otherwise defer
     * to the component's layout manager.
     *
     * @return the value of the <code>minimumSize</code> property
     * @see #setMinimumSize
     * @see ComponentUI
     */
    @Override
    public Dimension getMinimumSize() {
        Dimension dim = super.getMinimumSize();
        dim.width = w > 0 ? w : dim.width;
        dim.height = h > 0 ? h : dim.height;
        return (dim);
    }
    
    /**
     * Special document to create a echo char.
     */
    private class Japi2EchoCharDocument extends PlainDocument {

        /**
         * The echo character for this text field or <code>null</code> if not 
         * used.
         */
        private final Character echoChar;
        
        /**
         * Creates a new document with the given echo character.
         * 
         * @param echoChar the echo character. 
         */
        private Japi2EchoCharDocument(Character echoChar) {
            this.echoChar = echoChar;
        }
        
        @Override
        public void insertString(int offs, String str, AttributeSet a) 
                throws BadLocationException {
            // Insert new text
            if (echoChar == null) {
                super.insertString(offs, str, a);
            } else {
                String replacement = "";
                for (int i = 0; i < str.length(); i++) {
                    replacement += echoChar;
                }
                super.insertString(offs, replacement, a);
            }
            
            // Remember the text inserted
            text.insert(offs, str);
        }

        @Override
        public void remove(int offs, int len) throws BadLocationException {
            super.remove(offs, len);
            text.delete(offs, offs + len);
        }
        
    }
    
    /*
    public static void main(String[] args) {
        JFrame f = new JFrame();
        f.setLayout(new FlowLayout());
        
        final Japi2TextField tf = new Japi2TextField(15);
        f.add(tf);
        
        JButton btn = new JButton(new AbstractAction("Set echo char") {

            @Override
            public void actionPerformed(ActionEvent e) {
                String str = JOptionPane.showInputDialog("Character or nothing for null");
                
                if (str != null) {
                    if (str.trim().isEmpty()) {
                        tf.setEchoChar(null);
                    } else {
                        tf.setEchoChar(str.trim().charAt(0));
                    }
                }
            }
        });
        f.add(btn);
        
        btn = new JButton(new AbstractAction("Get text") {

            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println(">" + tf.getText() + "<");
            }
        });
        f.add(btn);
        
        
        f.pack();
        f.setVisible(true);
    }
    */
    
}
