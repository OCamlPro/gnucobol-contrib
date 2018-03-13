package de.japi.components.listeners;

import de.japi.Japi2Session;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.IOException;

/**
 * JAPI2 wrapper for an {@link KeyListener}.
 */
public class Japi2KeyListener extends AbstractJapi2Listener implements KeyListener {

    /**
     * Data storages for characters.
     */
    private int lastChar, lastKeyCode;
    
    /**
     * Constructs a new JAPI2 key listener.
     * 
     * <p>
     * <b>Important:</b> this constructor already adds this listener to the
     * objects map through {@link Japi2Session#addObject(java.lang.Object)}.
     * </p>
     * 
     * @param session the session object to operate on.
     * @throws IOException if an I/O error occurs.
     */
    public Japi2KeyListener(Japi2Session session) throws IOException {
        super(session, -1);
        super.id = session.addObject(this);
        session.writeInt(super.id);
    }

    /**
     * Returns the most recently pressed character.
     * 
     * @return the most recently pressed character.
     */
    public int getLastCharacter() {
        return lastChar;
    }
    
    /**
     * Returns the most recently pressed key code.
     * 
     * @return the most recently pressed key code.
     */
    public int getLastKeyCode() {
        return lastKeyCode;
    }

    @Override
    public void keyPressed(KeyEvent e) {
        trigger();
        lastChar = (int) e.getKeyChar();
        lastKeyCode = e.getKeyCode();
    }

    @Override
    public void keyTyped(KeyEvent e) {
        // Not used yet
    }

    @Override
    public void keyReleased(KeyEvent e) {
        // Not used yet
    }

    @Override
    public String toString() {
        return "KeyListener[for=" + id + ",currentChar=" + lastChar 
                + ",currentKeyCode=" + lastKeyCode + "]";
    }
    
}
