package de.japi;

import de.japi.components.Japi2Led;
import de.japi.components.Japi2Panel;

/**
 * Constants for the JAPI2 kernel.
 */
public class Japi2Constants {

    /**
     * Full application name.
     */
    public static final String APP_NAME = "JAPI2 Kernel";

    /**
     * Build id of the current version.
     */
    public static final String BUILD_ID = "2.42";

    /**
     * Constant representing <code>null</code> values.
     */
    public static final int J_NULL = -1;
    
    /**
     * Constants representing boolean values.
     */
    public static final int J_TRUE = 1, J_FALSE = 0;

    /**
     * Constants representing position values.
     */
    public static final int J_LEFT = 0, 
            J_CENTER = 1,
            J_RIGHT = 2,
            J_TOP = 3,
            J_BOTTOM = 4,
            J_TOPLEFT = 5,
            J_TOPRIGHT = 6,
            J_BOTTOMLEFT = 7,
            J_BOTTOMRIGHT = 8;

    /**
     * Differen cursor types.
     */
    public static final int J_DEFAULT_CURSOR = 0,
            J_CROSSHAIR_CURSOR = 1,
            J_TEXT_CURSOR = 2,
            J_WAIT_CURSOR = 3,
            J_SW_RESIZE_CURSOR = 4,
            J_SE_RESIZE_CURSOR = 5,
            J_NW_RESIZE_CURSOR = 6,
            J_NE_RESIZE_CURSOR = 7,
            J_N_RESIZE_CURSOR = 8,
            J_S_RESIZE_CURSOR = 9,
            J_W_RESIZE_CURSOR = 10,
            J_E_RESIZE_CURSOR = 11,
            J_HAND_CURSOR = 12,
            J_MOVE_CURSOR = 13;

    /**
     * Orientation types.
     */
    public static final int J_HORIZONTAL = 0, J_VERTICAL = 1;

    /**
     * Font styles and types.
     */
    public static final int J_PLAIN = 0,
            J_BOLD = 1,
            J_ITALIC = 2,
            J_COURIER = 1,
            J_HELVETIA = 2,
            J_TIMES = 3,
            J_DIALOGIN = 4,
            J_DIALOGOUT = 5;

    /**
     * Predefined color values.
     */
    public static final int J_BLACK = 0,
        J_WHITE = 1,
        J_RED = 2,
        J_GREEN = 3,
        J_BLUE = 4,
        J_CYAN = 5,
        J_MAGENTA = 6,
        J_YELLOW = 7,
        J_ORANGE = 8,
        J_GREEN_YELLOW = 9,
        J_GREEN_CYAN = 10,
        J_BLUE_CYAN = 11,
        J_BLUE_MAGENTA = 12,
        J_RED_MAGENTA = 13,
        J_DARK_GRAY = 14,
        J_LIGHT_GRAY = 15,
        J_GRAY = 16;

    /**
     * Styles of the border. See {@link Japi2Panel}.
     */
    public static final int J_NONE = 0,
        J_LINEDOWN = 1,
        J_LINEUP = 2,
        J_AREADOWN = 3,
        J_AREAUP = 4;

    /**
     * Mouse listener events.
     */
    public static final int J_MOVED = 0,
        J_DRAGGED = 1,
        J_PRESSED = 2,
        J_RELEASED = 3,
        J_ENTERERD = 4,
        J_EXITED = 5,
        J_DOUBLECLICK = 6;

    /**
     * Component listener event types.
     */
    public static final int J_RESIZED = 1,
        J_HIDDEN = 2,
        J_SHOWN = 3;
    
    /**
     * Window listener event types.
     */
    public static final int J_ACTIVATED = 0,
        J_DEACTIVATED = 1,
        J_OPENED = 2,
        J_CLOSED = 3,
        J_ICONIFIED = 4,
        J_DEICONIFIED = 5,
        J_CLOSING = 6;

    /**
     * Image types.
     */
    public static final int J_GIF = 0,
        J_JPG = 1,
        J_PPM = 2,
        J_BMP = 3;
    
    /**
     * Box styles. See {@link Japi2Led}.
     */
    public static final int J_ROUND = 0, 
        J_RECT = 1;

}
