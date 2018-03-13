package de.japi.components;

import java.awt.Dimension;
import java.awt.Font;
import java.awt.TextArea;
import java.awt.event.TextEvent;
import java.awt.event.TextListener;
import java.util.ArrayList;
import java.util.List;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.UIManager;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.plaf.ComponentUI;
import javax.swing.text.JTextComponent;

/**
 * A multi-line area that displays plain text. To stay compatible to the 
 * original JAPI kernel implementation this component is a {@link JScrollPane} 
 * containing a {@link JTextArea}. This is, because the original AWT component
 * ({@link TextArea}) already contained scroll bars. In SWING scrollbars must
 * be created extra for a {@link JTextArea}.
 * 
 * <p>
 * This class contains some {@link JTextArea} related methods which are only
 * mapped to their matching neighbours of {@link JTextArea} and not documented.
 * See documentation of {@link JTextArea} instead.
 * </p>
 */
public class Japi2TextArea extends JScrollPane implements DocumentListener {

    static {
        // Bugfix: since the default font on a JTextArea is a proportional-width 
        // font, the calculation of the width is not right, e.g. the letter 
        // 'm' is wider than 'i' and the width is calculated by getColumns()*width
        // of widest letter. So using a monospaced font will help to look
        // nicer and not produce so wide fields
        UIManager.put("TextArea.font", Font.decode(Font.MONOSPACED));
    }
    
    /**
     * The internal {@link JTextArea} component.
     */
    private final JTextArea textArea;
    
    /**
     * Width and height property of this component.
     */
    private int w = 0, h = 0;

    /**
     * All registered {@link TextListener} objects to listen on text change.
     */
    private final List<TextListener> textListeners;
//    private JScrollPane scrollPane;

    /**
     * Constructs a new empty Japi2TextArea with the specified number of rows
     * and columns and adds a DocumentListener for this object. A default model
     * is created, and the initial string is null.
     *
     * @param rows the number of rows &gt;= 0
     * @param columns the number of columns &gt;= 0
     * @exception IllegalArgumentException if the rows or columns arguments are
     * negative.
     */
    public Japi2TextArea(int rows, int columns) {
        super(new JTextArea(rows, columns));
        // Recreate the AWT look
        setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        textListeners = new ArrayList<TextListener>();
        
        // Get the text area
        textArea = (JTextArea) getViewport().getComponent(0);
        textArea.getDocument().addDocumentListener(this);
    }

    /**
     * Adds an AWT {@link TextListener} to this SWING component. Due to the
     * requirement of JAPI this AWT listener is emulated by this class. It
     * behaves the same way as the original AWT semantics dictates.
     *
     * @param listener the listener to add, not <code>null</code>.
     */
    public void addTextListener(TextListener listener) {
        if (listener == null) {
            throw new NullPointerException("TextListener can't be null");
        }
        textListeners.add(listener);
    }

    /**
     * Removes the given {@link TextListener}.
     *
     * @param listener the listener to remove.
     */
    public void removeTextListener(TextListener listener) {
        textListeners.remove(listener);
    }

    /**
     * Emulates an AWT {@link TextListener}'s {@link TextEvent} and notifies all
     * registered {@link TextListener} objects.
     */
    private void dispatchTextListenerEvent() {
        TextEvent evt = new TextEvent(this, TextEvent.TEXT_VALUE_CHANGED);
        for (TextListener textListener : textListeners) {
            textListener.textValueChanged(evt);
        }
    }


    @Override
    public String toString() {
        StringBuilder buf = new StringBuilder("TextArea[");
        buf.append(textArea.getRows());
        buf.append("x");
        buf.append(textArea.getColumns());
        buf.append(']');
        return buf.toString();
    }

    @Override
    public void insertUpdate(DocumentEvent e) {
        dispatchTextListenerEvent();
    }

    @Override
    public void removeUpdate(DocumentEvent e) {
        dispatchTextListenerEvent();
    }

    @Override
    public void changedUpdate(DocumentEvent e) {
        dispatchTextListenerEvent();
    }

    /**
     * Sets the new dimension of this {@link Japi2TextArea} object.
     * If the number of rows or columns is below 0, 0 is set as the default
     * value.
     *
     * @param width new width of this component.
     * @param height new height of this component.
     */
    @Override
    public void setSize(int width, int height) {
        w = width > 0 ? width : 0;
        h = height > 0 ? height : 0;
        super.setSize(w, h);
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

    // Undocumented alias methods
    
    public JTextComponent getComponent() {
        return textArea;
    }
    
    public void setColumns(int val) {
        textArea.setColumns(val);
    }

    public void replaceRange(String string, int start, int end) {
        textArea.replaceRange(string, start, end);
    }

    public void append(String string) {
        textArea.append(string);
    }

    public void setRows(int val) {
        textArea.setRows(val);
    }

    public void select(int start, int end) {
        textArea.select(start, end);
    }

    public void insert(String string, int pos) {
        textArea.insert(string, pos);
    }

    public int getColumns() {
        return textArea.getColumns();
    }

    public int getRows() {
        return textArea.getRows();
    }

}
