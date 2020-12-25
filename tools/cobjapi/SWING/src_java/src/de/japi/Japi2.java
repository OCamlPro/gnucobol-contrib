package de.japi;

import de.japi.components.Japi2AlertDialog;
import de.japi.components.Japi2DebugWindow;
import de.japi.components.Japi2SevenSegment;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import javax.swing.UIManager;

/**
 * The main class of the JAPI2 kernel, which manages all tasks and handles all
 * requests of the JAPI2 kernel. This class is the JVM entrance point.
 * 
 * <p>The main use cases which are handled by this class are:
 * </p>
 * <ul>
 * <li>setting up a {@link ServerSocket} to accept new connections</li>
 * <li>accepting new connections to the JAPI2 kernel and forward them to a
 * dedicated {@link Japi2Session} which is responsponsible for incomming 
 * requests from this connection</li>
 * <li>running all {@link Japi2Session}s in a ThreadPool to save
 * performance and bound the number of parallel working threads</li>
 * <li>supports rudimentary logging features through the method 
 * {@link #debug(java.lang.String, java.lang.Object...)}</li>
 * <li>blocks remote connections if only local connections should be
 * accepted</li>
 * <li>provides a tray icon through {@link Japi2Tray} to enable the user
 * to manage the JAPI2 kernel (e.g. quit it, set connection policy, ...)</li>
 * <li>provides a storage for messages keys used to display user messages 
 * with in the right language. See {@link #getString(java.lang.String)}</li>
 * </ul>
 * 
 */
public class Japi2 {

    /**
     * The singelton instance of this class.
     */
    private static Japi2 SINGELTON;
    
    /**
     * Iff <code>true</code> the method {@link #debug(java.lang.String, 
     * java.lang.Object...)} will print debug messages. 
     */
    public static boolean DEVELOPER = false;
    
    /**
     * Turns the optimized rendering on. This includes anti-alias drawing for
     * text and graphic primitves and also some modifications to modernize the
     * component and their appearance.
     */
    private static boolean OPTIMIZED = false;
    
    /**
     * The system tray icon.
     */
    private Japi2Tray trayIcon;
    
    /**
     * The thread pool, which efficiently schedules the execution of the 
     * {@link Japi2Session} objects.
     */
    private final ThreadPoolExecutor threadPool;
    
    /**
     * The main server socket.
     */
    private ServerSocket serverSocket;
    
    /**
     * All currently active {@link Japi2Session} sessions.
     */
    private final List<Japi2Session> sessions;
    
    /**
     * Iff <code>true</code> the JAPI2 kernel will accept remote connections.
     * Otherwise only local connections are accepted.
     */
    private boolean allowRemoteAccess;
    
    /**
     * Is <code>true</code>, iff the logging is paused.
     */
    public boolean loggingPaused;
    
    /**
     * The container for the language specific JAPI messages. See method
     * {@link #getString(java.lang.String)).
     */
    private ResourceBundle messages;
    
    /**
     * Contains the language locale requested by a commandline argument of JAPI
     * or is <code>null</code> if no language argument was given.
     */
    private static Locale cmdLineLocale;
    
    /**
     * Constructs a new instance of this class by setting up the required
     * data structures (thread pool, blocking queue, session list, etc.).
     */
    private Japi2() {
        sessions = new ArrayList<Japi2Session>();
        threadPool = new ThreadPoolExecutor(
                2, // Parallel running worker threads
                10, // Max. # of parallel running worker threads
                1000, // Keep alive while waiting for a new job
                TimeUnit.SECONDS, 
                new ArrayBlockingQueue(5)
        );
        allowRemoteAccess = false;
        loggingPaused = false;
        
        try {
            initMessages();
        } catch (Exception ex) {
            debug("Failed to load messages", ex);
        }
    }
    
    /**
     * Loads the messages, appropriate for the current locale, from the 
     * message file. After this method the message string of the language can
     * be get via {@link #getString(java.lang.String)}. This method might 
     * throw an {@link Exception}.
     * 
     * <p>
     * The default language is <code>en</code> and gets automagically choosen
     * if the given commandline locale or systems locale is not available.
     * </p>
     */
    private void initMessages() {
        if (cmdLineLocale != null) {
            messages = ResourceBundle.getBundle("de.japi.Language", 
                    cmdLineLocale);
            
            // In case of locale not found use fallback to englsh
            if (!messages.getLocale().equals(cmdLineLocale)) {
                messages = ResourceBundle.getBundle("de.japi.Language", 
                        Locale.ENGLISH);
            }
        } else {
            messages = ResourceBundle.getBundle("de.japi.Language");
        }
        
        // Apply the desired locale to the entire JVM
        Locale.setDefault(messages.getLocale());
        debug("Loading JAPI2 messages for locale {0}", messages.getLocale());
        debug("Given commandline locale: {0}", cmdLineLocale);
    }
    
    /**
     * Returns a message for the given key and the currently set {@link Locale}.
     * 
     * @param key the key string.
     * @return the associated message string or an error message, never 
     * <code>null</code>.
     */
    public final String getString(String key) {
        if (messages == null) {
            return "???Language not loaded???";
        }
        
        if (key == null || !messages.containsKey(key)) {
            return "???";
        }
        
        return messages.getString(key);
    }
    
    /**
     * Removes the given JAPI2 session from the list of currently active
     * sessions. This method is 
     * 
     * @param session the {@link Japi2Session} to remove.
     */
    void removeSession(Japi2Session session) {
        sessions.remove(session);
        if (trayIcon != null) { // Inform tray to update the GUI
            trayIcon.sessionsChanged();
        }
    }
    
    /**
     * Adds a new {@link Japi2Session} to the list of currently active
     * sessions.
     * 
     * @param session the {@link Japi2Session} to add.
     */
    private void addSession(Japi2Session session) {
        sessions.add(session);
        if (trayIcon != null) { // Inform tray to update the GUI
            trayIcon.sessionsChanged();
        }
    }
    
    /**
     * Returns a list of all currently active JAPI2 sessions.
     * 
     * @return the list of sessions.
     */
    public List<Japi2Session> getSessions() {
        return sessions;
    }
    
    /**
     * Returns the class which handles the system tray of the JAPI2 kernel.
     * 
     * @return The system tray handler.
     */
    public Japi2Tray getTray() {
        return trayIcon;
    }
    
    /**
     * Tests if the graphic optimization is enabled. See {@link #OPTIMIZED}.
     * 
     * @return a boolean to indicate the state.
     */
    public boolean isOptimizationEnabled() {
        return OPTIMIZED;
    }
    
    /**
     * The maximum number of lines to buffer in the  {@link Japi2DebugWindow}.
     * 
     * @return an {@link Integer} with value greater than 0.
     */
    public int getDebugLineBuffer() {
        return 1000;
    }
    
    /**
     * Sets the policy to accept or not accept remote connections.
     * 
     * @param allowRemoteAccess <code>true</code> iff remote connections should
     * be accepted otherwise <code>false</code>.
     */
    public void setAllowRemoteAccess(boolean allowRemoteAccess) {
        this.allowRemoteAccess = allowRemoteAccess;
    }
    
    /**
     * Tests if the JAPI2 kernel accepts remote connections.
     * 
     * @return <code>true</code> iff remote connections are accepted otherwise
     * <code>false</code>.
     */
    public boolean getAllowRemoteAccess() {
        return allowRemoteAccess;
    }

    /**
     * Tests if the logging is paused.
     * 
     * @return <code>true</code> if the entire JAPI2 Kernel does no logging
     * output anymore, otherwise <code>false</code>.
     */
    public boolean isLoggingPaused() {
        return loggingPaused;
    }
    
    /**
     * Pauses the entire logging of the JAPI2 Kernel.
     * 
     * @param paused if the logging should be paused.
     */
    public void setLoggingPaused(boolean paused) {
        loggingPaused = paused;
    }
    
    /**
     * Tries to start the JAPI2 kernel at the specified <code>port</code>. If 
     * this fails the JVM is terminated.
     * 
     * @param port to let the {@link ServerSocket} listen on.
     */
    public void start(int port) {
        // Start the server
        try {
            serverSocket = new ServerSocket(port);
        } catch (IOException ex) {
            debug("Failed to start JAPI2 kernel: {0}", ex);
            debug("The port {0} might be occupied", port);
            
            // Show graphical message
            Japi2AlertDialog alert = new Japi2AlertDialog(
                    null, 
                    getString("Alert.startupError.title"), 
                    MessageFormat.format(
                            getString("Alert.startupError"), 
                            port, 
                            ex.getMessage()
                    ), 
                    getString("Button.ok")
            );
            alert.dispose();
            
            debug("Terminating.");
            System.exit(1); // Terminate
        }
        
        // Start the system tray icon
        debug("JAPI kernel listening on port #{0}", port);
        trayIcon = new Japi2Tray();
        
        // Main loop to accept new connections
        Socket csock = null, asock = null;
        while (true) {
            // Accept the two sockets
            try {
                csock = serverSocket.accept();
                asock = serverSocket.accept();
                
                if (!isValidLocal(csock) || !isValidLocal(asock)) {
                    csock = asock = null;
                    continue;
                }
            } catch (Exception ex) {
                if (serverSocket.isClosed()) {
                    // If the server socket is closed an exception is thrown
                    return; 
                }
                debug("Failed to accept two new sockets: {0}", ex);
                continue;
            }
            
            try {
                Japi2Session sess = new Japi2Session(csock, asock);
                threadPool.execute(sess);
                addSession(sess);
            } catch (Exception ex) {
                debug("Failed to execute new JAPI session (C_SOCK={0},"
                        + "A_SOCK={1}): {2}", csock, asock, ex);
            }
        }
    }
    
    /**
     * Tests if the given {@link Socket} is a valid socket from a local source
     * when the {@link #allowRemoteAccess} field is set to <code>false</code>.
     * Otherwise this method returns always <code>true</code>.
     * 
     * @param sock the {@link Socket} to test.
     * @return <code>true</code> if {@link #allowRemoteAccess} is not set and 
     * the socket is local or {@link #allowRemoteAccess} is set. 
     * <code>false</code> if {@link #allowRemoteAccess} is not set and the 
     * socket is not local.
     */
    private boolean isValidLocal(Socket sock) {
        if (allowRemoteAccess) {
            return true; // Always true
        } else {
            InetAddress addr = sock.getInetAddress();
            boolean acc = addr.isAnyLocalAddress() || addr.isLoopbackAddress();
            debug("New connection from {0}. Accept? {1}", addr, acc);
            return acc;
        }
    }
    
    /**
     * Exits this application by closing / releasing all ressourced and then
     * exiting the JVM by {@link System#exit(int)} with status <code>0</code>.
     */
    public void exit() {
        try {
            internalExit();
        } catch (Exception ex) {
            // Is not important at this point
        }
        
        debug("Bye.");
        System.exit(0);
    }
    
    /**
     * Internal exit method which might throw an exception.
     */
    private void internalExit() {
        // Disable system tray
        trayIcon.exit();
        
        // Shutdown all sessions
        List<Japi2Session> sessionCopy = new ArrayList<Japi2Session>(sessions);
        for (Japi2Session session : sessionCopy) {
            try {
                session.exit();
            } catch (Exception ex) {
                /* Silence is gold */
            }
        }
        
        // Shutdown the thread pool and wait max. 2 secons
        threadPool.shutdown();
        try {
            threadPool.awaitTermination(2L, TimeUnit.SECONDS);
        } catch (Exception ex) {
            debug("Failed to await termination of thread pool: {0}", ex);
        }
        
        // Close the server socket
        try {
            serverSocket.close();
        } catch (IOException ex) {
            debug("Failed to close server socket: {0}", ex);
        }
    }
    
    /**
     * Prints a debug message iff the {@link #DEVELOPER} field is set to
     * <code>true</code>. Additional arguments can be inserted into the message 
     * string by using placeholders. A placeholder, e.g. <code>{0}</code>, 
     * consists of an index number in-between two brackets. The given index is 
     * the index of the object in the <code>args</code> array which should be
     * inserted at this location.
     * 
     * @param msg message to print with placeholders if needed.
     * @param args arguments to place in the <code>msg</code> string at the
     * corresponding placeholders to form a debug message.
     */
    public final void debug(String msg, Object...args) {
        if (DEVELOPER && !loggingPaused) {
            System.out.println(MessageFormat.format(msg, args));
        }
    }
    
    /**
     * Ensures that an argument is in a specific set or range.
     * 
     * @param <T> the type of the value to check.
     * @param value the value itself to check.
     * @param range the values which are possible.
     * @throws IllegalArgumentException is thrown if the value is not in range.
     */
    @Deprecated
    public static <T> void ensureIsIn(T value, T...range) 
            throws IllegalArgumentException {
        for (T entry : range) {
            if (entry.equals(value)) {
                return;
            }
        }
        
        throw new IllegalArgumentException("Argument '" + value 
                + "' not in valid range!");
    }
    
    /**
     * Tests if a value is contained in an array.
     * 
     * @param <T> the type of the value to check.
     * @param needle the value itself to check.
     * @param haystack the array of values to check if needle is contained.
     * @return <code>true</code> iff needle is contained in the array haystack.
     * Otherwise <code>false</code> is returned.
     */
    public static <T> boolean inArray(T needle, T...haystack) {
        for (T entry : haystack) {
            if (entry.equals(needle)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Returns the instance of this class. Since this class implements the
     * singelton pattern only one instance can exist during runtime. 
     * 
     * @return The {@link Japi2} instance, never <code>null</code>.
     */
    public static final Japi2 getInstance() {
        return SINGELTON;
    }
    
    /**
     * Main entrance point to launch the JAPI kernel. Possible commandline 
     * arguments are:
     * <pre>
     *  [0 - 65535]     Number of port on which the JAPI2 kernel listens for
     *                  clients. If an invalid number is given or the argument
     *                  is missing, the value {@link Japi2Calls#JAPI_PORT}
     *                  is used instead.
     * 
     *  -d              Exteneded debug mode is enabled. Beside the optinal
     *                  JAPI logging - which is bound to a session - other
     *                  debug messages are printed out on the stdio.
     * 
     *  -o              Turns the optimized rendering on. This means that 
     *                  graphic objects use anti-alias and some components will
     *                  use some modernized look and feel in comparsion to the
     *                  JAPI kernel 1.0.9. See {@link Japi2SevenSegment}
     *                  component for example.
     * 
     *  -l:[iso639]     Sets the locale for messages of the JAPI2 kernel. The
     *                  placeholder "iso639" expects an ISO 639 alpha-2 key to
     *                  identify the desired locale. By example "de" will stand
     *                  for German and "en" for English.
     * </pre>
     * 
     * @param args the command line arguments.
     */
    public static void main(String[] args) {
        // Parse the commandline arguments and get port number
        int port = Japi2Calls.JAPI_PORT;
        for (String arg : args) {
            if (arg.matches("[0-9]+")) { 
                port = Integer.parseInt(arg); // Port number
                if (port < 0 || port > 65535) {
                    port = Japi2Calls.JAPI_PORT;
                }
            } else if ("-d".equals(arg)) { 
                DEVELOPER = true; // Developer mode
            } else if ("-o".equals(arg)) { 
                OPTIMIZED = true; // Optimized rendering
            } else if (arg.startsWith("-l:") && arg.length() > 3) {
                cmdLineLocale = new Locale(arg.substring(3));
            }
        }
        
        SINGELTON = new Japi2();
        getInstance().debug("JAPI2 commandline arguments: {0}", (args == null || 
                args.length < 1 ? "- none -" : Arrays.toString(args)));
        
        // Apply UI defaults
        System.setProperty("apple.laf.useScreenMenuBar", "true");
        System.setProperty("com.apple.mrj.application.apple.menu.about.name", 
                Japi2Constants.APP_NAME);
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            
            
//            UIManager.setLookAndFeel("javax.swing.plaf.metal.MetalLookAndFeel");
            
        } catch (Exception ex) {
            getInstance().debug("Cannot set system LaF: {0}", ex);
        }
        
        // Start the kernel
        getInstance().start(port);
    }
    
}
