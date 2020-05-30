package de.japi;

import de.japi.calls.CommandCalls;
import de.japi.calls.ConstructionCalls;
import de.japi.calls.GraphicCalls;
import de.japi.calls.LayoutCalls;
import de.japi.calls.ListenerCalls;
import de.japi.calls.QuestionCalls;
import de.japi.components.AbstractJapi2ValueComponent;
import de.japi.components.Japi2Button;
import de.japi.components.Japi2Canvas;
import de.japi.components.Japi2CheckBox;
import de.japi.components.Japi2CheckMenuItem;
import de.japi.components.Japi2Choice;
import de.japi.components.Japi2DebugWindow;
import de.japi.components.Japi2Dialog;
import de.japi.components.Japi2Frame;
import de.japi.components.Japi2GraphicButton;
import de.japi.components.Japi2GraphicLabel;
import de.japi.components.Japi2Label;
import de.japi.components.Japi2Led;
import de.japi.components.Japi2List;
import de.japi.components.Japi2Menu;
import de.japi.components.Japi2MenuBar;
import de.japi.components.Japi2MenuItem;
import de.japi.components.Japi2Meter;
import de.japi.components.Japi2Panel;
import de.japi.components.Japi2TabbedPane;
import de.japi.components.Japi2PrintJob;
import de.japi.components.Japi2RadioButton;
import de.japi.components.Japi2RadioGroup;
import de.japi.components.Japi2ScrollPane;
import de.japi.components.Japi2TextArea;
import de.japi.components.Japi2TextField;
import de.japi.components.Japi2FormattedTextField;
import de.japi.components.Japi2Window;
import de.japi.components.listeners.Japi2FocusListener;
import de.japi.components.listeners.Japi2KeyListener;
import de.japi.components.listeners.Japi2MouseListener;
import de.japi.components.listeners.Japi2MouseMotionListener;
import java.applet.AudioClip;
import java.awt.Adjustable;
import java.awt.Component;
import java.awt.Container;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.MenuComponent;
import java.awt.Toolkit;
import java.awt.Window;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PushbackInputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketException;
import java.text.MessageFormat;
import java.util.Arrays;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JComponent;
import javax.swing.JPopupMenu;
import javax.swing.JProgressBar;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.text.JTextComponent;

/**
 * This class represents the main session of a JAPI2 kernel connection. It 
 * manages the execution of so called "JAPI calls". This are commands from the
 * client to perform a specific action (e.g. open a frame etc.). In this 
 * Java context the execution of a JAPI call is considered as a <b>JAPI2 service
 * call</b> execution.
 * 
 * <p>
 * A JAPI call or JAPI2 service call is an identifying number (id) of a specific
 * action. By example: if the client sends the id or command "2112" he wants to
 * let the computer beep. So this session needs to execute some code to perfom
 * this action. The code for those commands is packed into static methods which
 * are then executed.
 * </p>
 * 
 * <p>
 * This class provides seven methods to read parameters from the client during
 * the JAPI2 service execution from the socket's input stream. Those methods 
 * are (see the individual method documentation for further information):
 * </p>
 * <ul>
 * <li>{@link #read()}</li>
 * <li>{@link #read(byte[], int)}</li>
 * <li>{@link #readString(int)}</li>
 * <li>{@link #readInt()}</li>
 * <li>{@link #readLine()}</li>
 * </ul>
 *  
 * <p>
 * This class also provides three methods to write return values of a JAPI2
 * service execution back to the client. Since the JAPI2 kernel creates two
 * output connections to the client (the command output and the action output),
 * the methods require an additional parameter to specify the target stream.
 * Due to the fact that the command stream is used more extensively, this class
 * provides aliases for all write methods which will be directly write to
 * the command stream. All supported methods are:
 * </p>
 * <ul>
 * <li>{@link #writeBytes(byte[], de.japi.Japi2Session.TargetStream)} and
 * {@link #writeBytes(byte[])}</li>
 * <li>{@link #writeInt(int, de.japi.Japi2Session.TargetStream)} and 
 * {@link #writeInt(int)}</li>
 * <li>{@link #writeString(java.lang.String, de.japi.Japi2Session.TargetStream)}
 * and {@link #writeString(java.lang.String)}</li>
 * </ul>
 *  
 * <p>
 * Beside the methods for reading and writing to the client this class provides
 * also methods for the management of the GUI objects assigned to this 
 * session and the logging appropriate to the specification of the JAPI docs.
 * </p>
 */
public class Japi2Session implements Runnable {

    /**
     * The first id which will be assigned to an object in this session.
     */
    private static final int START_ID = 42;
    
    /**
     * Array of objects of this session.
     */
    private Object[] array;
    
    /**
     * The GUI element id counter.
     */
    private int elementId;
    
    /**
     * The command and action {@link Socket} objects connected to the client.
     */
    private Socket commandSocket, actionSocket;
    
    /**
     * The {@link InputStream} from the client to read data from (e.g. the next
     * JAPI call etc.). This input stream is wrapped in a 
     * {@link PushbackInputStream} to make reading strings easier.
     */
    private PushbackInputStream in;
    
    /**
     * The {@link OutputStream}s for the command and action socket to return
     * values after call execution to the client.
     */
    private DataOutputStream out, action;
    
    /**
     * A buffer for bytes to accellerate reading from the steram.
     */
    private final byte[] buff = new byte[128];
    
    /**
     * The {@link Japi2} singelton provided for convenience for logging. This
     * object can be retrieved at any time using: <code>Japi2.getInstance()</code>.
     */
    private final Japi2 japi2 = Japi2.getInstance();
    
    /**
     * The {@link Japi2DebugWindow} to output the JAPI specific debug output
     * in an extra message window. See class for further documentation.
     */
    private Japi2DebugWindow debugWindow;
    
    /**
     * Little indicator to indicate if this session is already closed.
     */
    private boolean closed = false;
    
    /**
     * To transfer "large" resources from the JAPI client to this session 
     * a HTTP connection is used. The JAPI client starts a HTTP server. This
     * attribute contains the server's hostname or IP address.
     */
    private String resourceHost;
    
    /**
     * See {@link #resourceHost}. The port on which the HTTP server is 
     * listening.
     */
    private int resourcePort;
    
    /**
     * Textual representation of this object.
     */
    private String toString;
    
    /**
     * Constructs a new JAPI2 session.
     * 
     * @param commandSocket the command socket object.
     * @param actionSocket the action socket object.
     * @throws SocketException if there is an error in the underlying protocol.
     * @throws NullPointerException if any argument is <code>null</code>.
     */
    public Japi2Session(Socket commandSocket, Socket actionSocket) 
            throws SocketException, NullPointerException {
        if (commandSocket == null || actionSocket == null) {
            throw new NullPointerException();
        }
        
        this.commandSocket = commandSocket;
        this.actionSocket = actionSocket;
        debugWindow = new Japi2DebugWindow(this);
        array = new Object[84];
        elementId = 42;
        
        InetSocketAddress addr = (InetSocketAddress) commandSocket
                .getLocalSocketAddress();
        toString = addr.getHostString() + "@" + addr.getPort();
        
        // Apply properties
        this.commandSocket.setTcpNoDelay(false);
        this.actionSocket.setTcpNoDelay(true);
    }
    
    /**
     * Returns the {@link Japi2DebugWindow} instance which is associated to this
     * session.
     * 
     * @return the debug window and never <code>null</code>.
     */
    public Japi2DebugWindow getDebugWindow() {
        return debugWindow;
    }
    
    /**
     * Closes this JAPI2 session by disconnecting from the network streams and
     * removing all GUI elements.
     * 
     * @throws IOException if an I/O error occurs when closing this socket.
     */
    public synchronized void exit() throws IOException {
        if (closed) {
            return; // Already interrupted
        }
        closed = true;
        
        try {
            while (in.available() > 0)
                in.read();
            in.close();
        } catch (Exception e) { /* Ignore */ }
        
        try {
            out.close();
            commandSocket.close();
        } catch (Exception e) { /* Ignore */ }
        out = null;
        commandSocket = null;
        
        try {
            action.close();
            actionSocket.close();
        } catch (Exception e) { /* Ignore */ }
        action = null;
        actionSocket = null;
        
        // Cleanup: clear all elements
        for (int i = 0; i < array.length; i++) {
            try {
                if (array[i] instanceof JComponent) {
                    ((JComponent) array[i]).setVisible(false);
                } else if (array[i] instanceof Window) {
                    ((Window) array[i]).dispose();
                }
            } catch (Exception ex) {
                /* Silence is gold */
            }   
        }
        array = null;
        
        debugWindow.dispose();
        debugWindow = null;
        
        System.gc();
        Japi2.getInstance().removeSession(this);
        
        japi2.debug("SESSION_HLT for {0}", toString());
    }

    /**
     * Returns the hostname of the resource server on the other end of the 
     * socket.
     * 
     * @return the hostname of the resource server.
     */
    public String getResourceHost() {
        return resourceHost;
    }

    /**
     * Returns the port of the resource server on the other end of the 
     * socket.
     * 
     * @return the port of the resource server.
     */
    public int getResourcePort() {
        return resourcePort;
    }
    
    /**
     * Adds a new GUI object to this session.
     * 
     * @param object the object to add.
     * @return the id assigned to the new object.
     * @throws NullPointerException if <code>object</code> has the value 
     * <code>null</code>.
     */
    public synchronized int addObject(Object object) throws NullPointerException {
        if (object == null) {
            throw new NullPointerException("Object in addObject() can't be null");
        }
        
        if (elementId >= array.length) {
            // Make the array bigger
            array = Arrays.copyOf(array, array.length * 2);
        }
        
        
        int id = elementId;
        elementId++;
        array[id] = object;
        japi2.debug("(>) Register {0} ({1}) with id {2}", object.getClass(), object, id);
        return id;
    }
    
    /**
     * Deletes an object from the list of to this session related GUI objects.
     * 
     * @param object the object to delete.
     */
    public void deleteObject(Object object) {
        for (int i = 0; i < array.length; i++) {
            if (array[i] == object) {
                array[i] = null;
            }
        }
    }
    
    /**
     * Deletes an object from the list of to this session related GUI objects
     * identified by its id.
     * 
     * @param id the id of the object to remove.
     */
    public void deleteObject(int id) {
        try {
            array[id] = null;
        } catch (Exception e) {
            // Silence is gold
        }
    }
    
    /**
     * Retrives an object related to the current session identified by the given
     * id.
     * 
     * @param <T> this method uses generic type parameters to create properly
     * typed code at compile time.
     * @param id the id of the object.
     * @param type the type of the expected object.
     * @return the object or <code>null</code> if the id is not existing or the
     * object cannot be cast to the desired type.
     * @throws UnsupportedOperationException is thrown if the value cannot be
     * casted to the desired type.
     */
    public <T> T getObjectById(int id, Class<T> type) throws UnsupportedOperationException {
        try {
            return type.cast(array[id]);
        } catch (ClassCastException e) {
            throw new UnsupportedOperationException(
                    "Cannot cast >" + array[id] + "< to " + type
            );
        }
    }
    
    /**
     * Looks up the id for a given GUI object.
     * 
     * @param object the GUI object (hopefully) related to this session to get
     * the id for.
     * @return the id of the object (always greater than 0) or -1.
     */
    public int getIdByObject(Object object) {
        if (object == null) {
            return -1;
        }
        
        for (int i = 0; i < array.length; i++) {
            if (array[i] == object) {
                return i;
            }
        }
        return -1;
    }
    
    /**
     * Run method for the {@link Runnable} interface. This method should not
     * be called directly.
     */
    @Override
    public void run() {
        try {
            in = new PushbackInputStream(commandSocket.getInputStream());
            out = new DataOutputStream(commandSocket.getOutputStream());
            action = new DataOutputStream(actionSocket.getOutputStream());
        } catch (Exception ex) {
            japi2.debug("Failed to open streams: {0}", ex);
            return;
        }
        
        try {
            internalRun();
        } catch (IOException ex) {
            japi2.debug("Remote socket possibly closed ({0})", ex);
        } catch (Exception ex) {
            if (closed) {
                // Ignore!
                japi2.debug("Killed session threw an exception while going "
                        + "down (ignore it): {0}", ex);
                return;
            }
            japi2.debug("Exception on internal run: {0}", ex);
        }
        
    }
    
    /**
     * Internal run method. Basically this method is used to catch any 
     * exceptions in the {@link #run()} method which arise from the following
     * code and provide a graceful exit (including a cleanup).
     * 
     * @throws Exception any exception.
     */
    private void internalRun() throws Exception {
        InetSocketAddress addr;
        
        // Write the magic number
        Japi2Session.this.writeInt(1234, TargetStream.COMMAND);
        
        // Read the debug level
        int debugLevel = readInt();
        debugWindow.setLevel(debugLevel);
        
        // Print some useful information
        addr = (InetSocketAddress) commandSocket.getLocalSocketAddress();
        log1("Command stream connected to: {0}@{1}", 
                addr.getHostString(), addr.getPort());
        addr = (InetSocketAddress) actionSocket.getLocalSocketAddress();
        log1("Action stream connected to: {0}@{1}", 
                addr.getHostString(), addr.getPort());
        log1("Debug level set to: {0}", debugLevel);
        
        // Get the HTTP connection data to transfer resources
        resourceHost = readLine();
        resourcePort = readInt();
        log1("HTTP resource socket: {0}@{1}", resourceHost, resourcePort);
        
        // Main command execution loop
        int command, oid;
        Object obj;
        
        while (!closed) {
            // Read the next command or JAPI Call
            in.read(buff, 0, 4);
            command = (buff[0] & 0xff) | 
                      ((buff[1] & 0xff) << 8) | 
                      ((buff[2] & 0xff) << 16) | 
                      ((buff[3] & 0xff) << 24);
            
            // Break on command 0
            if (command == 0) {
                japi2.debug("Command 0 seen: exit!");
                break;
            }
            
            // Read the argument id and get the object (if possible)
            in.read(buff, 0, 4);
            oid = (buff[0] & 0xff) | 
                  ((buff[1] & 0xff) << 8) | 
                  ((buff[2] & 0xff) << 16) | 
                  ((buff[3] & 0xff) << 24);
            obj = null;
            if (START_ID <= oid && oid < array.length) {
                obj = array[oid];
            }
            
            log1("JAPI Call #{0} on object {1} (oid {2})", command, obj, oid);
            
            // Find the right method for handling
            try {
                switch (command) {
                    case Japi2Calls.JAPI_FOREGROUNDCOLOR: 
                            if (obj instanceof Japi2Frame)
                                    GraphicCalls.setFgColor(this, (Japi2Frame) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.setFgColor(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.setFgColor(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.setFgColor(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_BACKGROUNDCOLOR: 
                            if (obj instanceof Japi2Frame)
                                    GraphicCalls.setBgColor(this, (Japi2Frame) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.setBgColor(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.setBgColor(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.setBgColor(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETXOR: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.setXOR(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.setXOR(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.setXOR(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.setXOR(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DRAWSTRING: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.drawString(this, (Japi2Canvas) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.drawString(this, (Japi2PrintJob) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.drawString(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.drawString(this, (Image) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_CLIPRECT: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.clipRect(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.clipRect(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.clipRect(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.clipRect(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_TRANSLATE: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.translate(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.translate(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.translate(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.translate(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DRAWLINE: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.drawLine(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.drawLine(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.drawLine(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.drawLine(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DRAWRECT: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.drawRect(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.drawRect(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.drawRect(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.drawRect(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FILLRECT: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.fillRect(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.fillRect(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.fillRect(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.fillRect(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_POLYLINE: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.polyline(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.polyline(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.polyline(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.polyline(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DRAWARC: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.drawArc(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.drawArc(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.drawArc(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.drawArc(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FILLARC: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.fillArc(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.fillArc(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.fillArc(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.fillArc(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DRAWOVAL: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.drawOval(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.drawOval(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.drawOval(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.drawOval(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FILLOVAL: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.fillOval(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.fillOval(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.fillOval(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.fillOval(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_POLYGON: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.polygon(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.polygon(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.polygon(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.polygon(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FILLPOLYGON: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.fillPolygon(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.fillPolygon(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.fillPolygon(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.fillPolygon(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ROUNDRECT: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.roundRect(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.roundRect(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.roundRect(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.roundRect(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FILLROUNDRECT: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.fillRoundRect(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.fillRoundRect(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.fillRoundRect(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.fillRoundRect(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_LOADIMAGE: 
                            GraphicCalls.loadImage(this);
                            break;
                    case Japi2Calls.JAPI_DRAWIMAGE: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.drawImage(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.drawImage(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.drawImage(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.drawImage(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DRAWSCALEDIMAGE: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.drawScaledImage(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    GraphicCalls.drawScaledImage(this, (Component) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.drawScaledImage(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.drawScaledImage(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETIMAGE: 
                            if (obj instanceof Japi2Canvas) 
                                    GraphicCalls.getImage(this, (Japi2Canvas) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETSCALEDIMAGE: 
                            if (obj instanceof Japi2Canvas) 
                                    GraphicCalls.getScaledImage(this, (Japi2Canvas) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETIMAGESOURCE: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.getImageSource(this, (Japi2Canvas) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.getImageSource(this, (Image) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DRAWIMAGESOURCE: 
                            if (obj instanceof Japi2Canvas)
                                    GraphicCalls.drawImageSource(this, (Japi2Canvas) obj);
                            else if (obj instanceof Image)
                                    GraphicCalls.drawImageSource(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    GraphicCalls.drawImageSource(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SELECTTEXT: 
                            if (obj instanceof Japi2TextArea) 
                                    CommandCalls.selectText(this, (Japi2TextArea) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETECHOCHAR: 
                            if (obj instanceof Japi2TextField) 
                                    CommandCalls.setEchoChar(this, (Japi2TextField) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_PACK: 
                            if (obj instanceof Window) 
                                    CommandCalls.pack(this, (Window) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETHGAP: 
                            if (obj instanceof Container) 
                                    CommandCalls.setHGap(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETVGAP: 
                            if (obj instanceof Container) 
                                    CommandCalls.setVGap(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETINSETS: 
                            if (obj instanceof Japi2Frame)
                                    CommandCalls.setInsets(this, (Japi2Frame) obj);
                            else if (obj instanceof Japi2Dialog)
                                    CommandCalls.setInsets(this, (Japi2Dialog) obj);
                            else if (obj instanceof Japi2Window)
                                    CommandCalls.setInsets(this, (Japi2Window) obj);
                            else if (obj instanceof Japi2Panel)
                                    CommandCalls.setInsets(this, (Japi2Panel) obj);
                            else if (obj instanceof Japi2TabbedPane)
                                    CommandCalls.setInsets(this, (Japi2TabbedPane) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETALIGN: 
                            if (obj instanceof Japi2Label)
                                    CommandCalls.setAlign(this, (Japi2Label) obj);
                            else if (obj instanceof Container)
                                    CommandCalls.setAlign(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_HIDE: 
                            if (obj instanceof Component) 
                                    CommandCalls.hide(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DISPOSE: 
                            if (obj instanceof Window)
                                    CommandCalls.dispose(this, (Window) obj);
                            else if (obj instanceof Component)
                                    CommandCalls.dispose(this, (Component) obj);
                            else if (obj instanceof JComponent)
                                    CommandCalls.dispose(this, (JComponent) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    CommandCalls.dispose(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_CURSOR: 
                            if (obj instanceof Component) 
                                    CommandCalls.cursor(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETVALUE: 
                            if (obj instanceof Adjustable)
                                    CommandCalls.setValue(this, (Adjustable) obj);
                            else if (obj instanceof AbstractJapi2ValueComponent)
                                    CommandCalls.setValue(this, (AbstractJapi2ValueComponent) obj);
                            else if (obj instanceof JProgressBar)
                                    CommandCalls.setValue(this, (JProgressBar) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETUNITINC: 
                            if (obj instanceof Adjustable) 
                                    CommandCalls.setUnitInc(this, (Adjustable) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETBLOCKINC: 
                            if (obj instanceof Adjustable) 
                                    CommandCalls.setBlockInc(this, (Adjustable) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETMIN: 
                            if (obj instanceof Adjustable)
                                    CommandCalls.setMin(this, (Adjustable) obj);
                            else if (obj instanceof AbstractJapi2ValueComponent)
                                    CommandCalls.setMin(this, (AbstractJapi2ValueComponent) obj);
                            else if (obj instanceof JProgressBar)
                                    CommandCalls.setMin(this, (JProgressBar) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETMAX: 
                            if (obj instanceof Adjustable)
                                    CommandCalls.setMax(this, (Adjustable) obj);
                            else if (obj instanceof AbstractJapi2ValueComponent)
                                    CommandCalls.setMax(this, (AbstractJapi2ValueComponent) obj);
                            else if (obj instanceof JProgressBar)
                                    CommandCalls.setMax(this, (JProgressBar) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETVISIBLE: 
                            if (obj instanceof Adjustable) 
                                    CommandCalls.setVisible(this, (Adjustable) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SHOWPOPUP: 
                            if (obj instanceof JPopupMenu) 
                                    CommandCalls.showPopUp(this, (JPopupMenu) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETFONT: 
                            if (obj instanceof Component)
                                    CommandCalls.setFont(this, (Component) obj);
                            else if (obj instanceof JComponent)
                                    CommandCalls.setFont(this, (JComponent) obj);
                            else if (obj instanceof Image)
                                    CommandCalls.setFont(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    CommandCalls.setFont(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETFONTNAME: 
                            if (obj instanceof Component)
                                    CommandCalls.setFontName(this, (Component) obj);
                            else if (obj instanceof JComponent)
                                    CommandCalls.setFontName(this, (JComponent) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    CommandCalls.setFontName(this, (Japi2PrintJob) obj);
                            else if (obj instanceof Image)
                                    CommandCalls.setFontName(this, (Image) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETFONTSIZE: 
                            if (obj instanceof Component)
                                    CommandCalls.setFontSize(this, (Component) obj);
                            else if (obj instanceof JComponent)
                                    CommandCalls.setFontSize(this, (JComponent) obj);
                            else if (obj instanceof Image)
                                    CommandCalls.setFontSize(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    CommandCalls.setFontSize(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETFONTSTYLE: 
                            if (obj instanceof Component)
                                    CommandCalls.setFontStyle(this, (Component) obj);
                            else if (obj instanceof MenuComponent)
                                    CommandCalls.setFontStyle(this, (MenuComponent) obj);
                            else if (obj instanceof Image)
                                    CommandCalls.setFontStyle(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    CommandCalls.setFontStyle(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_QUIT: 
                            CommandCalls.quit(this);
                            break;
                    case Japi2Calls.JAPI_KILL: 
                            // ------
                            // Kills the entire Japi2 Kernel
                            // ------
                            log2("Bye bye ...");
                            System.exit(0);
                            // ------
                            break;
                    case Japi2Calls.JAPI_SETSIZE: 
                            if (obj instanceof Japi2Canvas)
                                    CommandCalls.setSize(this, (Japi2Canvas) obj);
                            else if (obj instanceof Component)
                                    CommandCalls.setSize(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SHOW: 
                            if (obj instanceof Component) 
                                    CommandCalls.show(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETSTATE: 
                            if (obj instanceof Japi2CheckMenuItem)
                                    CommandCalls.setState(this, (Japi2CheckMenuItem) obj);
                            else if (obj instanceof Japi2CheckBox)
                                    CommandCalls.setState(this, (Japi2CheckBox) obj);
                            else if (obj instanceof Japi2RadioButton)
                                    CommandCalls.setState(this, (Japi2RadioButton) obj);
                            else if (obj instanceof Japi2Led)
                                    CommandCalls.setState(this, (Japi2Led) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_BORDERPOS: 
                            if (obj instanceof Component) 
                                    CommandCalls.setBorderLayoutConstraint(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETPOS: 
                            if (obj instanceof Component) 
                                    CommandCalls.setPos(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DISABLE: 
                            if (obj instanceof Component)
                                    CommandCalls.disable(this, (Component) obj);
                            else if (obj instanceof Japi2Menu)
                                    CommandCalls.disable(this, (Japi2Menu) obj);
                            else if (obj instanceof Japi2MenuItem)
                                    CommandCalls.disable(this, (Japi2MenuItem) obj);
                            else if (obj instanceof JCheckBoxMenuItem)
                                    CommandCalls.disable(this, (JCheckBoxMenuItem) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ENABLE: 
                            if (obj instanceof Component)
                                    CommandCalls.enable(this, (Component) obj);
                            else if (obj instanceof Japi2Menu)
                                    CommandCalls.enable(this, (Japi2Menu) obj);
                            else if (obj instanceof Japi2MenuItem)
                                    CommandCalls.enable(this, (Japi2MenuItem) obj);
                            else if (obj instanceof JCheckBoxMenuItem)
                                    CommandCalls.enable(this, (JCheckBoxMenuItem) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETFOCUS: 
                            if (obj instanceof Component) 
                                    CommandCalls.setFocus(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETSHORTCUT: 
                            if (obj instanceof Japi2MenuItem) 
                                    CommandCalls.setShortCut(this, (Japi2MenuItem) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DEBUG: 
                            CommandCalls.debug(this);
                            break;
                    case Japi2Calls.JAPI_ADDITEM: 
                            if (obj instanceof Japi2List)
                                    CommandCalls.addItem(this, (Japi2List) obj);
                            else if (obj instanceof Japi2Choice)
                                    CommandCalls.addItem(this, (Japi2Choice) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SELECT: 
                            if (obj instanceof Japi2List)
                                    CommandCalls.select(this, (Japi2List) obj);
                            else if (obj instanceof Japi2Choice)
                                    CommandCalls.select(this, (Japi2Choice) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DESELECT: 
                            if (obj instanceof Japi2List) 
                                    CommandCalls.deselect(this, (Japi2List) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_MULTIPLEMODE: 
                            if (obj instanceof Japi2List) 
                                    CommandCalls.multipleMode(this, (Japi2List) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_INSERT: 
                            if (obj instanceof Japi2List)
                                    CommandCalls.insert(this, (Japi2List) obj);
                            else if (obj instanceof Japi2Choice)
                                    CommandCalls.insert(this, (Japi2Choice) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_REMOVE: 
                            if (obj instanceof Japi2List)
                                    CommandCalls.remove(this, (Japi2List) obj);
                            else if (obj instanceof Japi2Choice)
                                    CommandCalls.remove(this, (Japi2Choice) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_REMOVEALL: 
                            if (obj instanceof Japi2List)
                                    CommandCalls.removeAll(this, (Japi2List) obj);
                            else if (obj instanceof Japi2Choice)
                                    CommandCalls.removeAll(this, (Japi2Choice) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SELECTALL: 
                            if (obj instanceof JTextComponent) 
                                    CommandCalls.selectAll(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    CommandCalls.selectAll(this, ((Japi2TextArea) obj).getComponent());
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_REPLACETEXT: 
                            if (obj instanceof Japi2TextArea) 
                                    CommandCalls.replaceText(this, (Japi2TextArea) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DELETE: 
                            if (obj instanceof Japi2TextArea) 
                                    CommandCalls.delete(this, (Japi2TextArea) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETCURPOS: 
                            if (obj instanceof JTextComponent) 
                                    CommandCalls.setCurPos(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    CommandCalls.setCurPos(this, ((Japi2TextArea) obj).getComponent());
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_INSERTTEXT: 
                            if (obj instanceof Japi2TextArea) 
                                    CommandCalls.insertText(this, (Japi2TextArea) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETTEXT: 
                            if (obj instanceof Japi2Frame)
                                    CommandCalls.setText(this, (Japi2Frame) obj);
                            else if (obj instanceof Japi2Dialog)
                                    CommandCalls.setText(this, (Japi2Dialog) obj);
                            else if (obj instanceof Japi2Button)
                                    CommandCalls.setText(this, (Japi2Button) obj);
                            else if (obj instanceof Japi2Label)
                                    CommandCalls.setText(this, (Japi2Label) obj);
                            else if (obj instanceof Japi2Menu)
                                    CommandCalls.setText(this, (Japi2Menu) obj);
                            else if (obj instanceof Japi2MenuItem)
                                    CommandCalls.setText(this, (Japi2MenuItem) obj);
                            else if (obj instanceof Japi2CheckMenuItem)
                                    CommandCalls.setText(this, (Japi2CheckMenuItem) obj);
                            else if (obj instanceof JTextComponent)
                                    CommandCalls.setText(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    CommandCalls.setText(this, 
                                            ((Japi2TextArea) obj).getComponent());
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_EDITABLE: 
                            if (obj instanceof JTextComponent) 
                                    CommandCalls.editable(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    CommandCalls.editable(this, ((Japi2TextArea) obj).getComponent());
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_PRINT: 
                            if (obj instanceof Japi2Canvas)
                                    CommandCalls.print(this, (Japi2Canvas) obj);
                            else if (obj instanceof Image)
                                    CommandCalls.print(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    CommandCalls.print(this, (Japi2PrintJob) obj);
                            else if (obj instanceof Component)
                                    CommandCalls.print(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_PLAYSOUNDFILE: 
                            CommandCalls.playSoundFile(this);
                            break;
                    case Japi2Calls.JAPI_SOUND: 
                            CommandCalls.sound(this);
                            break;
                    case Japi2Calls.JAPI_PLAY: 
                            if (obj instanceof AudioClip) 
                                    CommandCalls.play(this, (AudioClip) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ADD: 
                            if (obj instanceof Component) 
                                    CommandCalls.add(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_RELEASE: 
                            if (obj instanceof Component) 
                                    CommandCalls.release(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_RELEASEALL: 
                            if (obj instanceof Container) 
                                    CommandCalls.releaseAll(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FILLFLOWLAYOUT: 
                            if (obj instanceof Container) 
                                    CommandCalls.fillFlowLayout(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETRESIZABLE: 
                            if (obj instanceof Japi2Frame)
                                    CommandCalls.setResizable(this, (Japi2Frame) obj);
                            else if (obj instanceof Japi2Dialog)
                                    CommandCalls.setResizable(this, (Japi2Dialog) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETICON: 
                            if (obj instanceof Japi2Frame) 
                                    CommandCalls.setIcon(this, (Japi2Frame) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETROWS: 
                            if (obj instanceof Japi2TextArea)
                                    CommandCalls.setRows(this, (Japi2TextArea) obj);
                            else if (obj instanceof GridLayout)
                                    CommandCalls.setRows(this, (GridLayout) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETCOLUMNS: 
                            if (obj instanceof Japi2TextArea)
                                    CommandCalls.setColumns(this, (Japi2TextArea) obj);
                            else if (obj instanceof Japi2TextField) 
                                    CommandCalls.setColumns(this, (Japi2TextField) obj);
                            else if (obj instanceof Japi2FormattedTextField) 
                                    CommandCalls.setColumns(this, (Japi2FormattedTextField) obj);
                            else if (obj instanceof GridLayout)
                                    CommandCalls.setColumns(this, (GridLayout) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETIMAGE: 
                            if (obj instanceof Japi2GraphicButton)
                                    CommandCalls.setImage(this, (Japi2GraphicButton) obj);
                            else if (obj instanceof Japi2GraphicLabel)
                                    CommandCalls.setImage(this, (Japi2GraphicLabel) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETRADIOGROUP: 
                            if (obj instanceof Japi2CheckBox) 
                                    CommandCalls.setRadioGroup(this, (Japi2CheckBox) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_REMOVEITEM: 
                            if (obj instanceof Japi2List)
                                    CommandCalls.removeItem(this, (Japi2List) obj);
                            else if (obj instanceof Japi2Choice)
                                    CommandCalls.removeItem(this, (Japi2Choice) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_APPENDTEXT: 
                            if (obj instanceof Japi2TextArea) 
                                    CommandCalls.appendText(this, (Japi2TextArea) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_BEEP: 
                            Toolkit.getDefaultToolkit().beep();
                            break;
                    case Japi2Calls.JAPI_SETDANGER: 
                            if (obj instanceof Japi2Meter) 
                                    CommandCalls.setDanger(this, (Japi2Meter) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SETSPLITPANELEFT: 
                            if (obj instanceof JSplitPane) 
                                    CommandCalls.setLeftSplitPaneComponent(this, (JSplitPane) obj);
                            else 
                                    throw new NotHandledException();
                            break;  
                    case Japi2Calls.JAPI_SETSPLITPANERIGHT: 
                            if (obj instanceof JSplitPane) 
                                    CommandCalls.setRightSplitPaneComponent(this, (JSplitPane) obj);
                            else 
                                    throw new NotHandledException();
                            break; 
                    case Japi2Calls.JAPI_GETKEYCHAR: 
                            if (obj instanceof Japi2KeyListener) 
                                    QuestionCalls.getChar(this, (Japi2KeyListener) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETKEYCODE: 
                            if (obj instanceof Japi2KeyListener) 
                                    QuestionCalls.getKeyCode(this, (Japi2KeyListener) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_HASFOCUS: 
                            if (obj instanceof Japi2FocusListener) 
                                    QuestionCalls.hasFocus(this, (Japi2FocusListener) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETMOUSEX: 
                            if (obj instanceof Japi2MouseListener)
                                    QuestionCalls.getMouseX(this, (Japi2MouseListener) obj);
                            else if (obj instanceof Japi2MouseMotionListener)
                                    QuestionCalls.getMouseX(this, (Japi2MouseMotionListener) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETMOUSEY: 
                            if (obj instanceof Japi2MouseListener)
                                    QuestionCalls.getMouseY(this, (Japi2MouseListener) obj);
                            else if (obj instanceof Japi2MouseMotionListener)
                                    QuestionCalls.getMouseY(this, (Japi2MouseMotionListener) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETMOUSEBUTTON: 
                            if (obj instanceof Japi2MouseListener)
                                    QuestionCalls.getMouseButton(this, (Japi2MouseListener) obj);
                            else if (obj instanceof Japi2MouseMotionListener)
                                    QuestionCalls.getMouseButton(this, (Japi2MouseMotionListener) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETSTATE: 
                            if (obj instanceof Japi2CheckMenuItem)
                                    QuestionCalls.getState(this, (Japi2CheckMenuItem) obj);
                            else if (obj instanceof Japi2CheckBox)
                                    QuestionCalls.getState(this, (Japi2CheckBox) obj);
                            else if (obj instanceof Japi2RadioButton)
                                    QuestionCalls.getState(this, (Japi2RadioButton) obj);
                            else if (obj instanceof Japi2Led)
                                    QuestionCalls.getState(this, (Japi2Led) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETSELECT: 
                            if (obj instanceof Japi2List)
                                    QuestionCalls.getSelect(this, (Japi2List) obj);
                            else if (obj instanceof Japi2Choice)
                                    QuestionCalls.getSelect(this, (Japi2Choice) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ISSELECT: 
                            if (obj instanceof Japi2List) 
                                    QuestionCalls.isSelect(this, (Japi2List) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETTEXT: 
                            if (obj instanceof JTextComponent)
                                    QuestionCalls.getText(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    QuestionCalls.getText(this, ((Japi2TextArea) obj).getComponent());
                            else if (obj instanceof Japi2Frame)
                                    QuestionCalls.getText(this, (Japi2Frame) obj);
                            else if (obj instanceof Japi2Dialog)
                                    QuestionCalls.getText(this, (Japi2Dialog) obj);
                            else if (obj instanceof Japi2Button)
                                    QuestionCalls.getText(this, (Japi2Button) obj);
                            else if (obj instanceof Japi2Label)
                                    QuestionCalls.getText(this, (Japi2Label) obj);
                            else if (obj instanceof Japi2Menu)
                                    QuestionCalls.getText(this, (Japi2Menu) obj);
                            else if (obj instanceof Japi2MenuItem)
                                    QuestionCalls.getText(this, (Japi2MenuItem) obj);
                            else if (obj instanceof Japi2CheckMenuItem)
                                    QuestionCalls.getText(this, (Japi2CheckMenuItem) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETLENGTH: 
                            if (obj instanceof JTextComponent)
                                    QuestionCalls.getLength(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    QuestionCalls.getLength(this, ((Japi2TextArea) obj).getComponent());
                            else if (obj instanceof Japi2Frame)
                                    QuestionCalls.getLength(this, (Japi2Frame) obj);
                            else if (obj instanceof Japi2Button)
                                    QuestionCalls.getLength(this, (Japi2Button) obj);
                            else if (obj instanceof Japi2Menu)
                                    QuestionCalls.getLength(this, (Japi2Menu) obj);
                            else if (obj instanceof Japi2MenuItem)
                                    QuestionCalls.getLength(this, (Japi2MenuItem) obj);
                            else if (obj instanceof Japi2CheckMenuItem)
                                    QuestionCalls.getLength(this, (Japi2CheckMenuItem) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETSELSTART: 
                            if (obj instanceof JTextComponent) 
                                    QuestionCalls.getSelectionStart(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    QuestionCalls.getSelectionStart(this, ((Japi2TextArea) obj).getComponent());
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETSELEND: 
                            if (obj instanceof JTextComponent) 
                                    QuestionCalls.getSelectionEnd(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    QuestionCalls.getSelectionEnd(this, ((Japi2TextArea) obj).getComponent());
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETSELTEXT: 
                            if (obj instanceof JTextComponent) 
                                    QuestionCalls.getSelText(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    QuestionCalls.getSelText(this, ((Japi2TextArea) obj).getComponent());
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETCURPOS: 
                            if (obj instanceof JTextComponent) 
                                    QuestionCalls.getCurPos(this, (JTextComponent) obj);
                            else if (obj instanceof Japi2TextArea)
                                    QuestionCalls.getCurPos(this, ((Japi2TextArea) obj).getComponent());
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETWIDTH: 
                            if (obj instanceof Component)
                                    QuestionCalls.getWidth(this, (Component) obj);
                            else if (obj instanceof Image)
                                    QuestionCalls.getWidth(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    QuestionCalls.getWidth(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETHEIGHT: 
                            if (obj instanceof Component)
                                    QuestionCalls.getHeight(this, (Component) obj);
                            else if (obj instanceof Image)
                                    QuestionCalls.getHeight(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    QuestionCalls.getHeight(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETXPOS: 
                            if (obj instanceof Component) 
                                    QuestionCalls.getXPos(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETYPOS: 
                            if (obj instanceof Component) 
                                    QuestionCalls.getYPos(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETVALUE: 
                            if (obj instanceof Adjustable)
                                    QuestionCalls.getValue(this, (Adjustable) obj);
                            else if (obj instanceof AbstractJapi2ValueComponent)
                                    QuestionCalls.getValue(this, (AbstractJapi2ValueComponent) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_VIEWHEIGHT: 
                            if (obj instanceof Japi2ScrollPane) 
                                    QuestionCalls.viewHeight(this, (Japi2ScrollPane) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_VIEWWIDTH: 
                            if (obj instanceof JScrollPane) 
                                    QuestionCalls.viewWidth(this, (JScrollPane) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SYNC: 
                            log2("SYNC requested");
                            writeInt(Japi2Constants.J_TRUE);
                            break;
                    case Japi2Calls.JAPI_STRINGWIDTH: 
                            if (obj instanceof Component)
                                    QuestionCalls.stringWidth(this, (Component) obj);
                            else if (obj instanceof Image)
                                    QuestionCalls.stringWidth(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    QuestionCalls.stringWidth(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FONTHEIGHT: 
                            if (obj instanceof Component)
                                    QuestionCalls.fontHeight(this, (Component) obj);
                            else if (obj instanceof Image)
                                    QuestionCalls.fontHeight(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    QuestionCalls.fontHeight(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FONTASCENT: 
                            if (obj instanceof Component)
                                    QuestionCalls.fontAscent(this, (Component) obj);
                            else if (obj instanceof Image)
                                    QuestionCalls.fontAscent(this, (Image) obj);
                            else if (obj instanceof Japi2PrintJob)
                                    QuestionCalls.fontAscent(this, (Japi2PrintJob) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETITEM: 
                            if (obj instanceof Japi2List)
                                    QuestionCalls.getItem(this, (Japi2List) obj);
                            else if (obj instanceof Japi2Choice)
                                    QuestionCalls.getItem(this, (Japi2Choice) obj);
                            else if (obj instanceof Japi2Menu)
                                    QuestionCalls.getItem(this, (Japi2Menu) obj);
                            else if (obj instanceof Japi2MenuBar)
                                    QuestionCalls.getItem(this, (Japi2MenuBar) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETITEMCOUNT: 
                            if (obj instanceof Japi2List)
                                    QuestionCalls.getItemCount(this, (Japi2List) obj);
                            else if (obj instanceof Japi2Choice)
                                    QuestionCalls.getItemCount(this, (Japi2Choice) obj);
                            else if (obj instanceof Japi2Menu)
                                    QuestionCalls.getItemCount(this, (Japi2Menu) obj);
                            else if (obj instanceof Japi2MenuBar)
                                    QuestionCalls.getItemCount(this, (Japi2MenuBar) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETINWIDTH: 
                            if (obj instanceof Container)
                                    QuestionCalls.getInWidth(this, (Container) obj);
                            else if (obj instanceof Container)
                                    QuestionCalls.getInsetWidth(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETINHEIGHT: 
                            if (obj instanceof Container) 
                                    QuestionCalls.getInHeight(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETINSETS: 
                            if (obj instanceof Container) 
                                    QuestionCalls.getInsets(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ISRESIZABLE: 
                            if (obj instanceof Japi2Frame)
                                    QuestionCalls.isResizable(this, (Japi2Frame) obj);
                            else if (obj instanceof Japi2Dialog)
                                    QuestionCalls.isResizable(this, (Japi2Dialog) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETSCREENWIDTH: 
                            QuestionCalls.getScreenWidth(this);
                            break;
                    case Japi2Calls.JAPI_GETSCREENHEIGHT: 
                            QuestionCalls.getScreenHeight(this);
                            break;
                    case Japi2Calls.JAPI_GETPARENTID: 
                            if (obj instanceof Japi2RadioButton)
                                    QuestionCalls.getParentId(this, (Japi2RadioButton) obj);
                            else if (obj instanceof Component)
                                    QuestionCalls.getParentId(this, (Component) obj);
                            else if (obj instanceof JComponent)
                                    QuestionCalls.getParentId(this, (JComponent) obj);
                            else if (obj instanceof Japi2RadioGroup)
                                    QuestionCalls.getParentId(this, (Japi2RadioGroup) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETROWS: 
                            if (obj instanceof Japi2TextArea)
                                    QuestionCalls.getRows(this, (Japi2TextArea) obj);
                            else if (obj instanceof Japi2List)
                                    QuestionCalls.getRows(this, (Japi2List) obj);
                            else if (obj instanceof GridLayout)
                                    QuestionCalls.getRows(this, (GridLayout) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETCOLUMNS: 
                            if (obj instanceof Japi2TextArea)
                                    QuestionCalls.getColumns(this, (Japi2TextArea) obj);
                            else if (obj instanceof Japi2TextField)
                                    QuestionCalls.getColumns(this, (Japi2TextField) obj);
                            else if (obj instanceof Japi2FormattedTextField)
                                    QuestionCalls.getColumns(this, (Japi2FormattedTextField) obj);
                            else if (obj instanceof GridLayout)
                                    QuestionCalls.getColumns(this, (GridLayout) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETLAYOUTID: 
                            if (obj instanceof Container) 
                                    QuestionCalls.getLayoutId(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ISPARENT: 
                            if (obj instanceof Japi2RadioButton)
                                    QuestionCalls.isParent(this, (Japi2RadioButton) obj);
                            else if (obj instanceof Component)
                                    QuestionCalls.isParent(this, (Component) obj);
                            else if (obj instanceof JComponent)
                                    QuestionCalls.isParent(this, (JComponent) obj);
                            else if (obj instanceof Japi2RadioGroup)
                                    QuestionCalls.isParent(this, (Japi2RadioGroup) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ISVISIBLE: 
                            if (obj instanceof Component) 
                                    QuestionCalls.isVisible(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GETDANGER: 
                            if (obj instanceof Japi2Meter) 
                                    QuestionCalls.getDanger(this, (Japi2Meter) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FRAME: 
                            ConstructionCalls.createJFrame(this);
                            break;
                    case Japi2Calls.JAPI_CANVAS: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createCanvas(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_BUTTON: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createButton(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_MENUBAR: 
                            if (obj instanceof Japi2Frame) 
                                    ConstructionCalls.createMenuBar(this, (Japi2Frame) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_MENU: 
                            if (obj instanceof Japi2MenuBar)
                                    ConstructionCalls.createMenu(this, (Japi2MenuBar) obj);
                            else if (obj instanceof Japi2Menu)
                                    ConstructionCalls.createMenu(this, (Japi2Menu) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_HELPMENU: 
                            if (obj instanceof Japi2MenuBar) 
                                    ConstructionCalls.createHelpMenu(this, (Japi2MenuBar) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_MENUITEM: 
                            if (obj instanceof Japi2Menu)
                                    ConstructionCalls.createMenuItem(this, (Japi2Menu) obj);
                            else if (obj instanceof JPopupMenu)
                                    ConstructionCalls.showMenuItem(this, (JPopupMenu) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_CHECKMENUITEM: 
                            if (obj instanceof Japi2Menu) 
                                    ConstructionCalls.createCheckmenuItem(this, (Japi2Menu) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SEPERATOR: 
                            if (obj instanceof Japi2Menu) 
                                    ConstructionCalls.createSeperator(this, (Japi2Menu) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_PANEL: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createPanel(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_TABBEDPANE: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createTabbedPane(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ADDTAB: 
                            if (obj instanceof Japi2TabbedPane)
                                    ConstructionCalls.createTab(this, (Japi2TabbedPane) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ADDTABWITHICON: 
                            if (obj instanceof Japi2TabbedPane)
                                    ConstructionCalls.createTabWithIcon(this, (Japi2TabbedPane) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_LABEL: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createLabel(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_CHECKBOX: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createCheckBox(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_RADIOGROUP: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createRadioGroup(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_RADIOBUTTON: 
                            if (obj instanceof Japi2RadioGroup) 
                                    ConstructionCalls.createRadioButton(this, (Japi2RadioGroup) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_LIST: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createList(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_CHOICE: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createChoice(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_TEXTAREA: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createTextArea(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_TEXTFIELD: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createTextField(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FORMATTEDTEXTFIELD: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createFormattedTextField(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FILEDIALOG: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createFileDialog(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_DIALOG: 
                            if (obj instanceof Japi2Frame) 
                                    ConstructionCalls.createDialog(this, (Japi2Frame) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_WINDOW: 
                            if (obj instanceof Japi2Frame) 
                                    ConstructionCalls.createWindow(this, (Japi2Frame) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_POPMENU: 
                            if (obj instanceof Component) 
                                    ConstructionCalls.showPopMenu(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SCROLLPANE: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createScrollPane(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_VSCROLL: // aka JSlider
                            if (obj instanceof JScrollPane)
                                    ConstructionCalls.setVScroll(this, (JScrollPane) obj);
                            else if (obj instanceof Container)
                                    ConstructionCalls.createVSlider(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_HSCROLL: // aka JSlider 
                            if (obj instanceof JScrollPane)
                                    ConstructionCalls.setHScroll(this, (JScrollPane) obj);
                            else if (obj instanceof Container)
                                    ConstructionCalls.createHSlider(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_MESSAGEBOX: 
                            if (obj instanceof Japi2Frame) 
                                    ConstructionCalls.showMessageBox(this, (Japi2Frame) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_ALERTBOX: 
                            if (obj instanceof Japi2Frame) 
                                    ConstructionCalls.showAlertBox(this, (Japi2Frame) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_CHOICEBOX2: 
                            if (obj instanceof Japi2Frame) 
                                    ConstructionCalls.showChoiceBox2(this, (Japi2Frame) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_CHOICEBOX3: 
                            if (obj instanceof Japi2Frame) 
                                    ConstructionCalls.showChoiceBox3(this, (Japi2Frame) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GRAPHICBUTTON: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createGraphicButton(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GRAPHICLABEL: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createGraphicLabel(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_RULER: // aka JSeperator
                            if (obj instanceof Container) 
                                    ConstructionCalls.createRuler(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_PRINTER: 
                            if (obj instanceof Japi2Frame) 
                                    ConstructionCalls.createPrinter(this, (Japi2Frame) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_IMAGE: 
                            ConstructionCalls.showImage(this);
                            break;
                    case Japi2Calls.JAPI_PROGRESSBAR: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createProgressBar(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_LED: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createLed(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SEVENSEGMENT: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createSevenSegment(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_METER: 
                            if (obj instanceof Container) 
                                    ConstructionCalls.createMeter(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_SPLITPANE:
                            if (obj instanceof Container) 
                                    ConstructionCalls.createSplitPane(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_KEYLISTENER: 
                            if (obj instanceof Component) 
                                    ListenerCalls.installKeyListener(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FOCUSLISTENER: 
                            if (obj instanceof Component) 
                                    ListenerCalls.installFocusListener(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_MOUSELISTENER: 
                            if (obj instanceof Component) 
                                    ListenerCalls.installMouseListener(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_COMPONENTLISTENER: 
                            if (obj instanceof Component) 
                                    ListenerCalls.installComponentListener(this, (Component) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_WINDOWLISTENER: 
                            if (obj instanceof Window) 
                                    ListenerCalls.installWindowListener(this, (Window) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_FLOWLAYOUT: 
                            if (obj instanceof Container) 
                                    LayoutCalls.createFlowLayout(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_GRIDLAYOUT: 
                            if (obj instanceof Container) 
                                    LayoutCalls.createGridLayout(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_BORDERLAYOUT: 
                            if (obj instanceof Container) 
                                    LayoutCalls.createBorderLayout(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_CARDLAYOUT: 
                            if (obj instanceof Container) 
                                    LayoutCalls.createCardLayout(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    case Japi2Calls.JAPI_NOLAYOUT: 
                            if (obj instanceof Container) 
                                    LayoutCalls.createNoLayout(this, (Container) obj);
                            else 
                                    throw new NotHandledException();
                            break;
                    default:
                        throw new NotHandledException();
                }
            } catch (NotHandledException ex) {
                log1("No service available to handle command {0}", command);
                if (!Japi2.getInstance().getTray()
                        .showUnknownCommandError(command)) {
                    break;
                } else {
                    // Send only error code back and continue
                    if (sendResult(command)) {
                        writeInt(Japi2Constants.J_NULL);
                    }
                }
            } catch (UnsupportedOperationException ex) {    
                // Compose a message
                StringBuilder msg = new StringBuilder();
                if (ex.getMessage() == null) {
                    msg.append(ex.toString());
                    StackTraceElement ste = ex.getStackTrace()[0];
                    if (ste != null) {
                        msg.append("<br/> at ");
                        msg.append(ste);
                    }
                } else {
                    msg.append(ex.getMessage());
                }

                if (ex instanceof UnsupportedOperationException) {
                    msg.append(" (not appliable)");
                }
                
                log1("Command {0} not appliable: {1}", command, msg.toString());

                // Should we continue
                if (!Japi2.getInstance().getTray().showNotSupportedObjectError(
                        msg.toString())) {
                    break; // User cancelled
                }
                
                // Send error code back
                if (sendResult(command)) {
                    writeInt(Japi2Constants.J_NULL);
                }
            } catch (Exception ex) {
                log1("General exception when executing command {0} : {1}", 
                        command, ex.toString());
                
                // Should we continue
                if (!Japi2.getInstance().getTray().showGeneralError(command, ex)) {
                    break; // User cancelled
                }
                
                // Send error code back
                if (sendResult(command)) {
                    writeInt(Japi2Constants.J_NULL);
                }
            }
        }
        
        exit(); // Cleanup
    }
    
    /**
     * This method indicated if a negative result (i.e. the integer 
     * <code>-1</code>) should be send to the client if an exception occurred 
     * during the execution of a Japi call. If this Japi call whould normally
     * return an ID to the client, on error a <code>-1</code> must be send.
     * 
     * @param command the id of the Japi call to check.
     * @return <code>true</code> if the negative result should be send or
     * <code>false</code> if nothing should be done.
     */
    public static final boolean sendResult(int command) {
        int cmdmask = ((1<<30)-1)<<10;
        int cmdgroup =	command & cmdmask;
        return  command == Japi2Calls.JAPI_LOADIMAGE ||
                command == Japi2Calls.JAPI_SOUND ||
                cmdgroup == Japi2Calls.JAPI_QUESTIONS || // all
                (
                    cmdgroup == Japi2Calls.JAPI_CONSTRUCTORS && 
                    command != Japi2Calls.JAPI_SEPERATOR
                ) ||
                cmdgroup == Japi2Calls.JAPI_LISTENERS;
    }    

    @Override
    public String toString() {
        return toString;
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // Stateful logging
    // --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    
    /**
     * Logs a program debug message of level 1. This logging message is
     * sent to the {@link Japi2DebugWindow} (if the appropriate log level
     * is set) and to the debug output method (only if program in developer
     * mode) {@link Japi2#debug(java.lang.String, java.lang.Object...)}.
     * 
     * <p>
     * By defioniton of the JAPI documentation, this method should be called
     * to log messages of the following type:
     * </p>
     * <pre>
     * Rueckmeldung der konstruktiven Funktionen. Nur das Erzeugen der 
     * graphischen Objekte wird protokolliert. 
     * </pre>
     * 
     * @param msg the message to log. This message is send through the formatter
     * of {@link MessageFormat}. That means, placeholders of the type 
     * <code>'{' [0-9] '}</code> can be used to insert an argument from the
     * <code>args</code> array.
     * @param args The arguments to place in the message.
     */
    public final void log1(String msg, Object...args) {
        if (Japi2.getInstance().isLoggingPaused()) {
            return;
        }
        
        if (Japi2.DEVELOPER) {
            Japi2.getInstance().debug(msg, Japi2DebugWindow.prettifyArguments(args));
        }
        
        if (debugWindow != null) {
            debugWindow.println(1, msg, args);
        }
    }
    
    /**
     * Logs a program debug message of level 2. This logging message is
     * sent to the {@link Japi2DebugWindow} (if the appropriate log level
     * is set) and to the debug output method (only if program in developer
     * mode) {@link Japi2#debug(java.lang.String, java.lang.Object...)}.
     * 
     * <p>
     * By defioniton of the JAPI documentation, this method should be called
     * to log messages of the following type:
     * </p>
     * <pre>
     * Wie 1, zusaetzliche Ausgabe aller Aktionen, die vom Benutzer ausgefuehrt 
     * werden. 
     * </pre>
     *  
     * @param msg the message to log. This message is send through the formatter
     * of {@link MessageFormat}. That means, placeholders of the type 
     * <code>'{' [0-9] '}</code> can be used to insert an argument from the
     * <code>args</code> array.
     * @param args The arguments to place in the message.
     */
    public final void log2(String msg, Object...args) {
        if (Japi2.getInstance().isLoggingPaused()) {
            return;
        }
        
        if (Japi2.DEVELOPER) {
            Japi2.getInstance().debug(msg, Japi2DebugWindow.prettifyArguments(args));
        }
        
        if (debugWindow != null) {
            debugWindow.println(2, msg, args);
        }
    }
    
    /**
     * Logs a program debug message of level 3. This logging message is
     * sent to the {@link Japi2DebugWindow} (if the appropriate log level
     * is set) and to the debug output method (only if program in developer
     * mode) {@link Japi2#debug(java.lang.String, java.lang.Object...)}.
     * 
     * <p>
     * By defioniton of the JAPI documentation, this method should be called
     * to log messages of the following type:
     * </p>
     * <pre>
     * Wie 2, zusaetzlich werden alle weiteren Funktionen (ausser den 
     * graphischen Befehlen) protokoliert.
     * </pre>
     *  
     * @param msg the message to log. This message is send through the formatter
     * of {@link MessageFormat}. That means, placeholders of the type 
     * <code>'{' [0-9] '}</code> can be used to insert an argument from the
     * <code>args</code> array.
     * @param args The arguments to place in the message.
     */
    public final void log3(String msg, Object...args) {
        if (Japi2.getInstance().isLoggingPaused()) {
            return;
        }
        
        if (Japi2.DEVELOPER) {
            Japi2.getInstance().debug(msg, Japi2DebugWindow.prettifyArguments(args));
        }
        
        if (debugWindow != null) {
            debugWindow.println(3, msg, args);
        }
    }
    
    /**
     * Logs a program debug message of level 4. This logging message is
     * sent to the {@link Japi2DebugWindow} (if the appropriate log level
     * is set) and to the debug output method (only if program in developer
     * mode) {@link Japi2#debug(java.lang.String, java.lang.Object...)}.
     * 
     * <p>
     * By defioniton of the JAPI documentation, this method should be called
     * to log messages of the following type:
     * </p>
     * <pre>
     * Wie 3, zusaetzlich mit allen graphischen Befehlen. 
     * </pre>
     *  
     * @param msg the message to log. This message is send through the formatter
     * of {@link MessageFormat}. That means, placeholders of the type 
     * <code>'{' [0-9] '}</code> can be used to insert an argument from the
     * <code>args</code> array.
     * @param args The arguments to place in the message.
     */
    public final void log4(String msg, Object...args) {
        if (Japi2.getInstance().isLoggingPaused()) {
            return;
        }
        
        if (Japi2.DEVELOPER) {
            Japi2.getInstance().debug(msg, Japi2DebugWindow.prettifyArguments(args));
        }
        
        if (debugWindow != null) {
            debugWindow.println(4, msg, args);
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // Client I/O: Read methods
    // --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    
    /**
     * Reads a byte from the input stream. This method blocks.
     * 
     * @see InputStream#read()
     * @return the read byte.
     * @throws IOException if an I/O error occurs.
     */
    public byte read() throws IOException {
        return (byte) in.read();
    }
    
    /**
     * Reads an unsigned byte from the input stream. This method blocks.
     * 
     * @see InputStream#read()
     * @return the read unsigned byte.
     * @throws IOException if an I/O error occurs.
     */
    public int readByte() throws IOException {
        return in.read() & 0xff;
    }
    
//    /**
//     * Reads <code>n</code> bytes from the stream into a byte buffer.
//     * 
//     * @param n the number of bytes to read.
//     * @return the byte buffer containung the read <code>n</code> bytes starting
//     * at index 0.
//     * @throws IOException 
//     */
//    public byte[] read(int n) throws IOException {
//        if (n >= buff.length) {
//            throw new IOException("Byte buffer has max size of " + buff.length);
//        }
//        in.read(buff, 0, n);
//        
//        
//        System.out.println("read(), n = " + n);
//        for (int i = 0; i < n; i++) {
//            System.out.print(String.format("0x%02x, ", buff[i]));
//        }
//        System.out.println("");
//        System.out.println(" available? " + in.available());
//        
//        
//        return buff;
//    }
    
    /**
     * Reads the given number of bytes (<code>length</code>) from the input 
     * stream and stores them into the given byte array. This method is a 
     * blocking method, i.e. it will only return if <code>length</code> number
     * of bytes are read.
     * 
     * @param buf the array to store the read data into.
     * @param length the number of bytes to read.
     * @throws IOException if an I/O error occurs.
     * @throws ArrayIndexOutOfBoundsException if the array <code>buf</code> is
     * shorter than <code>length</code>.
     */
    public void read(byte[] buf, int length) throws IOException, 
            ArrayIndexOutOfBoundsException {
        if (buf == null || buf.length < length) {
            throw new ArrayIndexOutOfBoundsException("Array is not long enough");
        }
        
        // Read all requested bytes
        int offset = 0, read, totalBytes = 0;
        while (true) {
           read = in.read(buf, offset, length - totalBytes); // Try to read all bytes
           totalBytes += read;
           if (totalBytes >= length) {
               break; // Everything fine - nothing to read anymore
           }
           offset = totalBytes;
        }
    }

    /**
     * Reads a {@link String} from the input stream with a fixed length. This
     * method is a blocking method.
     * 
     * @param length the number of bytes to read (length of the string).
     * @return the {@link String} read in and never <code>null</code>.
     * @throws IOException if an I/O error occurs.
     */
    public String readString(int length) throws IOException {
        if (length < 0) {
            return new String();
        }
        byte[] buf = new byte[length];
        in.read(buf);
        return new String(buf);
    }
    
    /**
     * Reads the next {@link Integer} from the input stream. An integer number
     * consists of four bytes of data. The endian scheme for decoding is defined
     * by Japi2Session#toInt(byte[]). This method is a blocking call, 
     * i.e. once the stream has only three bytes left, this method call will
     * only return if the fourth byte is available.
     * 
     * @return the read {@link Integer} as primitive type (never 
     * <code>null</code>).
     * @throws IOException if an I/O error occurs.
     */
    public int readInt() throws IOException {
        in.read(buff, 0, 4);
        return  (buff[0] & 0xff) | 
                ((buff[1] & 0xff) << 8) | 
                ((buff[2] & 0xff) << 16) | 
                ((buff[3] & 0xff) << 24);
    }
    
    /**
     * Reads the next line of characters from the input stream. A line is 
     * terminated by a line feet or an <code>\n</code> escape sign. This method
     * does <u>not</u> block if the stream is fully read and the line is not
     * terminated. In this case the read string is returned. This implementation
     * adapts the (deprecated) implementation of 
     * {@link DataInputStream#readLine()}.
     * 
     * @return the string read from the input socket which is terminated by a
     * line feet.
     * @throws IOException if an I/O error occurs.
     */
    public String readLine() throws IOException {
        StringBuilder buf = new StringBuilder();
        int c;
        while (true) {
            c = in.read();
            
            // If a <LF> is discovered or EOF encountered return
            if (c == '\n' || c == -1 /* EOF */) {
                break; // Finished
            }
            
            // On windows systems a line is terminated by <CR><LF> so this 
            // case is needed to read lines from windows systems properly
            if (c == '\r') {
                c = in.read();
                if (c != '\n' && c != -1) {
                    in.unread(c);
                }
                break;
            }
            
            buf.append((char) c);
        }
        return buf.toString();
    }

//    /**
//     * Tests if the input stream is ready to read at least one byte.
//     * 
//     * @return <code>true</code> iff one byte can be read without blocking or
//     * <code>false</code> iff no bytes can be read.
//     * @throws IOException if an I/O error occurs.
//     */
//    public boolean canRead() throws IOException {
//        return in.available() > 0;
//    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // Client I/O: Write methods
    // --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    
    /**
     * This enum is used on write methods of the class {@link Japi2Session} to
     * specify the right stream to write on.
     */
    public enum TargetStream {
        COMMAND, ACTION;
    }
    
    /**
     * Sends an {@link Integer} to the client through the command socket. This
     * call is an alias for <code>writeInt(i, TargetStream.COMMAND)</code>.
     * 
     * @param i the {@link Integer} to write.
     * @throws IOException if an I/O error occurs.
     */
    public void writeInt(int i) throws IOException {
        writeInt(i, TargetStream.COMMAND);
    }
    
    /**
     * Writes an {@link Integer}, consisting of four bytes, onto the given
     * socket stream (<code>target</code>). The endian encoding of the integer
     * is defined by the method toByte(int).
     * 
     * @param a the {@link Integer} to write.
     * @param target the target stream to write to.
     * @throws IOException if an I/O error occurs.
     */
    public void writeInt(int a, TargetStream target) throws IOException {
        byte[] bb = new byte[] {
            (byte) (a & 0xff),
            (byte) ((a>>8) & 0xff),
            (byte) ((a>>16) & 0xff),
            (byte) ((a>>24) & 0xff)
        };
        
        if (target == TargetStream.COMMAND) {
            out.write(bb);
        } else {
            action.write(bb);
        }
    }
    
    /**
     * Wrties a {@link Boolean} value onto the command stream. The boolean value
     * <code>true</code> is represented by a <code>1</code> and the boolen value
     * <code>false</code> is represented by a <code>0</code>. The value is 
     * written as an {@link Integer} number onto the stream, meaning that four
     * bytes are used to encode the boolean.
     * 
     * @param b the boolean to write.
     * @throws IOException if an I/O error occurs.
     */
    public void writeBoolean(boolean b) throws IOException {
        writeInt(b == true ? 1 : 0, TargetStream.COMMAND);
    }
    
    /**
     * Writes a {@link String} object onto the command socket. This method call
     * is an alias for <code>writeString(str, TargetStream.COMMAND)</code>.
     * 
     * @param str the {@link String} to write.
     * @throws IOException if an I/O error occurs.
     */
    public void writeString(String str) throws IOException {
        writeString(str, TargetStream.COMMAND);
    }
    
    /**
     * Writes a {@link String} object onto the given socket stream 
     * (<code>target</code>). This is done in this way:
     * <ol>
     * <li>the number of characters of the string is written onto the 
     * stream</li>
     * <li>all characters of the string are written individually onto the 
     * stream</li>
     * </ol>
     * 
     * @param str the {@link String} to write. If it is <code>null</code> then
     * an empty string is written onto the stream.
     * @param target the target stream to write to.
     * @throws IOException if an I/O error occurs.
     */
    public void writeString(String str, TargetStream target) 
            throws IOException {
        if (str == null) {
            writeInt(0, target);
            return;
        }
        
        writeInt(str.length(), target);
        if (target == TargetStream.COMMAND) {
            out.write(str.getBytes());
        } else {
            action.write(str.getBytes());
        }
    }
    
    /**
     * Writes an array of {@link Byte}s onto the command socket stream. This
     * method is an alias for: <code>writeBytes(b, TargetStream.COMMAND)</code>.
     * 
     * @param b the bytes to write.
     * @throws IOException if an I/O error occurs.
     */
    public void writeBytes(byte[] b) throws IOException {
        writeBytes(b, TargetStream.COMMAND);
    }
    
    /**
     * Writes an array of {@link Byte}s onto the given socket stream 
     * (<code>target</code>).
     * 
     * @param b the bytes to write.
     * @param target the target stream to write to.
     * @throws IOException if an I/O error occurs.
     */
    public void writeBytes(byte[] b, TargetStream target) 
            throws IOException {
        if (target == TargetStream.COMMAND) {
            out.write(b);
        } else {
            action.write(b);
        }
    }
    
    /**
     * Simple custom exception to indicate a case which is not handled (e.g. in
     * this context: a JAPI Call which is not handled).
     */
    private class NotHandledException extends Exception { }
    
}
