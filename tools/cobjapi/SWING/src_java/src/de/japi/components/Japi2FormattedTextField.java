package de.japi.components;

import java.awt.Dimension;
import java.awt.FlowLayout;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.plaf.ComponentUI;
import javax.swing.text.AttributeSet;
import javax.swing.text.BadLocationException;
import javax.swing.text.MaskFormatter;
import javax.swing.text.PlainDocument;

/**
 * <p>
 * Component that allows the editing of a single line of text with a 
 * formatting mask.
 * 
 * The following table shows the characters that you can use in the formatting
 * mask.
 * </p>
 * 
 * <pre> 
 * Char:  Description:
 * #      - Any valid number.
 * '      - (single quote) Escape character, used to escape any of the special 
 *          formatting characters.
 * U      - Any character. All lowercase letters are mapped to uppercase.
 * L      - Any character. All uppercase letters are mapped to lowercase.
 * A      - Any character or number.
 * ?      - Any character.
 * *      - Anything.
 * H      - Any hex character (0-9, a-f or A-F).
 * </pre>
 * 
 */
public class Japi2FormattedTextField extends JFormattedTextField {

    /**
     * The size properties for this text field.
     */
    private int w = 0, h = 0;
    
    /**
     * Constructs a new empty <code>Japi2FormattedTextField</code> with the specified
     * mask, place holder and number of columns.
     *
     * @param maskStr mask string for the formatting;
     * @param placeHldr place holder char;
     * @param col the number of columns to use to calculate the preferred width;
     * if columns is set to zero, the preferred width will be whatever naturally
     * results from the component implementation
     */
    public Japi2FormattedTextField(String maskStr, Character placeHldr, int col) {
        super();
        setColumns(col);
        setMask(maskStr, placeHldr);
    }
    
    public void setMask(String maskStr, Character placeHldr) {
        try {
            MaskFormatter mask = new MaskFormatter(maskStr);
            mask.setPlaceholderCharacter(placeHldr);
            mask.install(this);
        } catch (java.text.ParseException e) {e.printStackTrace();}
    }
    
    @Override
    public void setSize(int width, int height) {
        w = width > 0 ? width : 0;
        h = height > 0 ? height : 0;
        super.setSize(w, h);
    }

    @Override
    public String toString() {
        StringBuilder buf = new StringBuilder("Japi2FormattedTextField[columns=");
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
    
//    public static void main(String[] args) {
//        Japi2FormattedTextField ftf;
//        JFrame f = new JFrame();
//        f.setLayout(new FlowLayout());
//        
//        ftf = new Japi2FormattedTextField("######.##", '_', 20);
//        
//        f.add(ftf);
//        f.pack();
//        f.setVisible(true);
//    }

}
