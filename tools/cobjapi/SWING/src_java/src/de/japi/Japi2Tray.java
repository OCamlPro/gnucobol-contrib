package de.japi;

import de.japi.components.Japi2AboutWindow;
import de.japi.components.Japi2AlertDialog;
import java.awt.AWTException;
import java.awt.CheckboxMenuItem;
import java.awt.Image;
import java.awt.MenuItem;
import java.awt.PopupMenu;
import java.awt.SystemTray;
import java.awt.TrayIcon;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.lang.reflect.Method;
import java.text.MessageFormat;
import java.util.List;

/**
 * This class provides an integration into the system tray of the JAPI2 kernel
 * in order to provide a simple way of terminating the kernel to the user.
 * 
 * <p>
 * Beside terminating specific sessions, the user can also perform some other
 * useful tasks:
 * <ul>
 * <li>allow or disallow remote connections to the JAPI2 kernel instance</li>
 * <li>quit the JAPI2 kernel gracefully (not supported in previous releases)</li>
 * <li>view about information and the version</li>
 * </ul>
 * This class performs also the icon (e.g. dock icon) and command integration 
 * (quit and about on the Apple-Menu (top left)) on MacOS systems.
 * </p>
 */
public class Japi2Tray implements ActionListener {
    
    /**
     * The popup menu of the tray icon.
     */
    private PopupMenu popup;
    
    /**
     * The tray icon related to this application.
     */
    private TrayIcon trayIcon;
    
    /**
     * The system tray instance.
     */
    private SystemTray tray;
    
    /**
     * Reference to the main class (mainly as shortcut for debugging).
     */
    private final Japi2 japi;
    
    /**
     * Constructs a new system tray for the Japi2 Kernel.
     */
    public Japi2Tray() {
        japi = Japi2.getInstance();
        initGui();
    }
    
    /**
     * Is triggered when a new session is created or an existing session is
     * closed. This method manages the list of open sessions in the system's
     * tray menu.
     */
    void sessionsChanged() {
        // Find the last seperator of the menu
        List<Japi2Session> sessions = Japi2.getInstance().getSessions();
        int length = popup.getItemCount();
        int lastSeparator = -1;
        for (int i = 0; i < length; i++) {
            if ("-".equals(popup.getItem(i).getLabel())) {
                lastSeparator = i;
            }
        }
        if (lastSeparator < 0) {
            return;
        }
        
        // Remove all elements after the last seperator
        for (int i = 1; i < (length - lastSeparator); i++) {
            popup.remove(lastSeparator + 1);
        }
        
        // Add message if no sessions are open
        if (sessions.isEmpty()) {
            popup.add(getTextItem(japi.getString("Label.noOpenSessions")));
            return;
        } else {
            popup.add(getTextItem(japi.getString("Label.openSessions")));
        }
        
        // Add sessions and attach kill action
        for (final Japi2Session session : sessions) {
            MenuItem item = new MenuItem(MessageFormat.format(
                    japi.getString("Tray.session"), session.toString()
            ));
            item.addActionListener(new ActionListener() {

                @Override
                public void actionPerformed(ActionEvent e) {
                    Japi2.getInstance().debug("Trying to kill session: {0}", 
                            session);
                    try {
                        session.exit();
                    } catch (IOException ex) {
                        Japi2.getInstance().debug("Failed to kill session {0}: "
                                + "{1}", session, ex);
                    }
                }
            });
            popup.add(item);
        }
    }
    
    /**
     * Is called when the JAPI2 kernel is going to be terminated.
     */
    void exit() {
        tray.remove(trayIcon);
    }
    
    /**
     * Creates the tray menu and tries to setup the tray.
     */
    private void initGui() {
        // Set up MacOS specific actions and the dock icon
        setMacIcon();
        installMacCommands();
        
        // Check the SystemTray support
        if (!SystemTray.isSupported()) {
            Japi2.getInstance().debug("System tray icon not supported!");
            return;
        }
        
        // Create the popup menu
        popup = new PopupMenu();
        int iconSize = System.getProperty("os.name")
                .toLowerCase()
                .contains("mac") ? 24 : 16;
        trayIcon = new TrayIcon(Icon.getAppIcon(iconSize));
        tray = SystemTray.getSystemTray();

        // Menu item to en/disable remote access
        {
            MenuItem item = new MenuItem();
            setState(item, "Tray.remoteAccessAllow", "Tray.remoteAccessDeny", 
                    Japi2.getInstance().getAllowRemoteAccess());
            item.setActionCommand("remote");
            popup.add(item);
        }
        
        // Suspend logging button
        {
            MenuItem item = new MenuItem();
            setState(item, "Tray.enableLogging", "Tray.disableLogging", 
                    !Japi2.getInstance().isLoggingPaused());
            item.setActionCommand("pause");
            popup.add(item);
        }
        
        popup.addSeparator();
        
        // Menu item for about
        {
            MenuItem item = new MenuItem(japi.getString("Tray.about"));
            item.addActionListener(this);
            item.setActionCommand("about");
            popup.add(item);
        }
        
        // Exit menu item
        {
            MenuItem item = new MenuItem(japi.getString("Tray.exit"));
            item.addActionListener(this);
            item.setActionCommand("exit");
            popup.add(item);
        }

        // Dynamic menu area to display open sessions and to terminate
        // them
        popup.addSeparator();
        sessionsChanged();
        
        // Try to add it to the system tray
        try {
            trayIcon.setPopupMenu(popup);
            tray.add(trayIcon);
        } catch (AWTException ex) {
            Japi2.getInstance().debug("Could not add tray icon: {0}", ex);
        }
    }
    
    /**
     * Due to the fact that {@link CheckboxMenuItem} does not seem to work
     * properly ({@link ActionEvent} not fired on click), this method converts
     * a plain {@link MenuItem} to a statefull toggleable menu entry.
     * 
     * @param item the item to convert.
     * @param trueKey language key for the message on <code>true</code> state.
     * @param falseKey language key for the message on <code>false</code> state.
     * @param initialValue the initial state value.
     */
    private void setState(final MenuItem item, final String trueKey, 
            final String falseKey, boolean initialValue) {
        item.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                // Get state and apply new value
                boolean isSelected = trueKey.equals(item.getName());
                item.setName(isSelected ? falseKey : trueKey);
                item.setLabel(Japi2.getInstance().getString(item.getName()));
                
                // Handle action
                try {
                    handleAction(item.getActionCommand(), isSelected);
                } catch (Exception ex) {
                    japi.debug("TrayIcon action handler exception: {0}", ex);
                }
            }
        });
        
        // Set initial state
        item.setName(initialValue ? falseKey : trueKey);
        item.setLabel(Japi2.getInstance().getString(item.getName()));
    }
    
    /**
     * Internal action handler method which is {@link Exception} protected.
     * 
     * @param actionCommand the action command of the component which fired the
     * action.
     * @param state the boolean state, if component was prepared as replacement
     * for {@link CheckboxMenuItem}.
     */
    private void handleAction(String actionCommand, boolean state) {
        if ("exit".equals(actionCommand)) {
            japi.exit();
        } else if ("about".equals(actionCommand)) {
            new Japi2AboutWindow().placeAndShow();
        } else if ("remote".equals(actionCommand)) {
            japi.setAllowRemoteAccess(state);
        } else if ("pause".equals(actionCommand)) {
            japi.setLoggingPaused(!state);
        }
    }
    
    @Override
    public void actionPerformed(ActionEvent e) {
        try {
            handleAction(e.getActionCommand(), false);
        } catch (Exception ex) {
            japi.debug("TrayIcon action handler exception: {0}", ex);
        }
    }
    
    /**
     * Shows a question dialog to the user when an unknown JAPI command
     * was send to the JAPI2 kernel.
     * 
     * @param cmd the unknown command id.
     * @return <code>true</code> if the user wants to resume the current session
     * and <code>false</code> otherwise.
     */
    public boolean showUnknownCommandError(int cmd) {
        String fieldName = String.format("%d (0x%08x)", cmd, cmd);
        
        // Display message
        Japi2AlertDialog alert = new Japi2AlertDialog(
                null, 
                Japi2.getInstance().getString("Alert.unknownCmd.title"), 
                MessageFormat.format(
                    Japi2.getInstance().getString("Alert.unknownCmd"),
                    fieldName
                ), 
                Japi2.getInstance().getString("Button.continue"), 
                Japi2.getInstance().getString("Button.halt")
        );
        
        return alert.getValue() == 1;
    }
    
    /**
     * Shows a question dialog when an internal exception during the execution
     * of a JAPI call occurs.
     * 
     * @param msg the message of the error.
     * @return <code>true</code> if the user wants to resume the current session
     * and <code>false</code> otherwise.
     */
    public boolean showNotSupportedObjectError(String msg) {
        // Display message
        Japi2AlertDialog alert = new Japi2AlertDialog(
                null, 
                Japi2.getInstance().getString("Alert.serviceErr.title"), 
                MessageFormat.format(
                    Japi2.getInstance().getString("Alert.serviceErr"),
                    shortify(msg, 60)
                ), 
                Japi2.getInstance().getString("Button.continue"), 
                Japi2.getInstance().getString("Button.halt")
        );
        
        return alert.getValue() == 1;
    }
    
    /**
     * Shows a general error dialog.
     * 
     * @param command the id of the JAPI call which produced this error.
     * @param ex the {@link Exception} occurred.
     * @return <code>true</code> if the user wants to resume the current session
     * and <code>false</code> otherwise.
     */
    public boolean showGeneralError(int command, Exception ex) {
        // Display message
        Japi2AlertDialog alert = new Japi2AlertDialog(
                null, 
                Japi2.getInstance().getString("Alert.generalError.title"), 
                MessageFormat.format(
                    Japi2.getInstance().getString("Alert.generalError"), 
                    command, 
                    shortify(ex, 3)
                ), 
                Japi2.getInstance().getString("Button.continue"), 
                Japi2.getInstance().getString("Button.halt")
        );
        
        return alert.getValue() == 1;
    }
    
    /**
     * Attaches command handlers to the MacOSX system commands like "About" 
     * and "Quit". This method will return on non-OSX systems.
     */
    private void installMacCommands() {
        if (!System.getProperty("os.name").toLowerCase().contains("mac")) {
            return;
        }

        // Try to set OS X about handler
        try {
            // The com.apple.eawt.Application is only available on MacOS 
            // JVM implementations. So use reflection to aviod static linking
            // to those classes
            Class<?> c = Class.forName("com.apple.eawt.Application");
            Object app = c.getMethod("getApplication").invoke(null);
            
            // Set about menu option handler
            try {
                Class<?> clazz = Class.forName("com.apple.eawt.AboutHandler");
                Object handler = java.lang.reflect.Proxy.newProxyInstance(
                    getClass().getClassLoader(), 
                    new java.lang.Class[] { clazz }, 
                    new java.lang.reflect.InvocationHandler(){

                        @Override
                        public Object invoke(Object proxy, Method method,
                                        Object[] args) throws Throwable {
                                actionPerformed(
                                        new ActionEvent(
                                                Japi2Tray.this, 1001, "about"
                                        )
                                );
                                return null;
                        }
                    }
                );
                Method about = app.getClass().getMethod("setAboutHandler", clazz);
                about.invoke(app, handler);
            } catch (Exception ex) {
                Japi2.getInstance().debug(
                        "MacOSX: set about handler failed, {0}", ex
                );
            }
            
            // Set exit menu option handler
            try {
                Class<?> clazz = Class.forName("com.apple.eawt.QuitHandler");
                Object handler = java.lang.reflect.Proxy.newProxyInstance(
                    getClass().getClassLoader(), 
                    new java.lang.Class[] { clazz }, 
                    new java.lang.reflect.InvocationHandler(){

                        @Override
                        public Object invoke(Object proxy, Method method,
                                        Object[] args) throws Throwable {
                                actionPerformed(new ActionEvent(
                                        Japi2Tray.this, 1001, "exit"
                                ));
                                return null;
                        }
                    }
                );
                Method about = app.getClass().getMethod("setQuitHandler", clazz);
                about.invoke(app, handler);
            } catch(Exception ex) {
                Japi2.getInstance().debug(
                        "MacOSX: set quit handler failed, {0}", ex
                );
            }
        } catch (Exception ex) {
            Japi2.getInstance().debug(
                    "MacOSX: can't attach menu handlers, {0}", ex
            );
        }
    }
    
    /**
     * Set the icon of the Japi2 kernel in the System Dock on MacOS systems. 
     * This method will return on non-OSX systems.
     */
    private void setMacIcon() {
        if (!System.getProperty("os.name").toLowerCase().contains("mac")) {
            return;
        }
        
        try {
            // The com.apple.eawt.Application is only available on MacOS 
            // JVM implementations. So use reflection to aviod static linking
            // to those classes
            Class<?> c = Class.forName("com.apple.eawt.Application");
            Object app = c.getMethod("getApplication").invoke(null);
            Method icon = app.getClass().getMethod("setDockIconImage", Image.class);
            icon.invoke(app, Icon.getAppIcon(96));
        } catch (Exception ex) {
            Japi2.getInstance().debug(
                        "MacOSX: set icon failed, {0}", ex
                );
        }
    }

    /**
     * Creates a text-only AWT {@link MenuItem}.
     * 
     * @param text the text to display.
     * @return the created {@link MenuItem}.
     */
    private static MenuItem getTextItem(String text) {
        MenuItem item = new MenuItem(text);
        item.setEnabled(false);
        return item;
    }
    
    /**
     * Abbreviates a string.
     * 
     * @param str the string to abbreviate.
     * @param maxLength the maximum number of characters allowed.
     * @return the abbreviated string.
     */
    public static String shortify(String str, int maxLength) {
        if (maxLength < 0 || str.length() < maxLength) {
            return str;
        }
        return str.substring(0, maxLength) + "...";
    }
    
    /**
     * Converts a {@link Throwable} to a string.
     * 
     * @param e the {@link Throwable} to stringify.
     * @param maxDepth the depth of stack traces to print.
     * @return the abbreviated, stringified {@link Throwable}.
     */
    public String shortify(Throwable e, int maxDepth) {
        StringBuilder sb = new StringBuilder();
        sb.append(shortify(e.toString(), 84));
        sb.append("\n");
        for (StackTraceElement element : e.getStackTrace()) {
            sb.append("at ");
            sb.append(shortify(element.toString(), 80));
            sb.append("\n");
            maxDepth--;
            if (maxDepth == 0) {
                return sb.toString();
            }
        }
        return sb.toString();
    }
    
}
