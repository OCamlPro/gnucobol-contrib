package de.japi.components;

import de.japi.Japi2;
import de.japi.Japi2Session;
import de.japi.components.listeners.AbstractJapi2Listener;
import java.awt.Color;
import java.awt.Font;
import java.awt.Insets;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.util.List;
import javax.swing.JTree;
import javax.swing.border.EmptyBorder;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeCellRenderer;
import javax.swing.tree.TreeSelectionModel;

/**
 * Tree class to contruct a Tree based on JTree.
 */
public class Japi2Tree extends JTree {

    /**
     * The internal Tree component.
     */
    private final JTree tree;
    Japi2Session session;
    DefaultTreeCellRenderer renderer;
    Insets inset;
    boolean doubleClickAction;

    /**
     * Creates a new Tree
     * @param rootNode the root node for thos tree.
     * @param sessionIn the session
     * 
     */
    public Japi2Tree(DefaultMutableTreeNode rootNode, Japi2Session sessionIn) {
        super(rootNode);
        tree = this;
        session = sessionIn;
        this.setOpaque(false);
        // only one leaf selectable
        tree.getSelectionModel().setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);
        renderer = (DefaultTreeCellRenderer) tree.getCellRenderer();
        doubleClickAction = false;
    }
   
    /**
     * Enables all components inside the Tree if b is true.
     * @param b 
     */
    @Override
    public void setEnabled(boolean b) {
        for (int i = 0; i < getComponentCount(); i++) {
            getComponent(i).setEnabled(b);
        }
    }

    /**
     * Sets the inset for this tree.
     * @param insets 
     */
    public void setInsets(Insets insets) {
        super.setBorder(new EmptyBorder(insets));
    }

    /**
     * Sets the font of this component. The font of all components
     * insise the tabbedPane is also set to the Font f.
     * @param f 
     */
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

    /**
     * Returns the String representation of this component and its values.
     * @return String representation
     */
    @Override
    public String toString() {
        return "Tree[#children= " + getComponentCount() + "]";
    }

    @Override
    public void setBackground(Color bg) {
        super.setBackground(bg);
        super.setOpaque(bg != null);
    }

    public void setTextSelectionColor(Color color) {
        renderer.setTextSelectionColor(color);
    }

    public void setBackgroundSelectionColor(Color color) {
        renderer.setBackgroundSelectionColor(color);
    }

    public void setBorderSelectionColor(Color color) {
        renderer.setBorderSelectionColor(color);
    }

    public void setTextNonSelectionColor(Color color) {
        renderer.setTextNonSelectionColor(color);
    }

    public void setBackgroundNonSelectionColor(Color color) {
        renderer.setBackgroundNonSelectionColor(color);
    }
    
    @Override
    public synchronized void addMouseListener(MouseListener l) {
        if (l instanceof AbstractJapi2Listener) {
            tree.addMouseListener(l);
        } else {
            super.addMouseListener(l);
        }
    }

    @Override
    public synchronized void addMouseMotionListener(MouseMotionListener l) {
        if (l instanceof AbstractJapi2Listener) {
            tree.addMouseMotionListener(l);
        } else {
            super.addMouseMotionListener(l);
        }
    }
    
    public void enableDoubleClickAction() {
        doubleClickAction = true;
    }

    public void disableDoubleClickAction() {
        doubleClickAction = false;
    }
    
    /**
     * Attaches an {@link ActionListener} to this list to be compatible to
     * the AWT {@link List}. The {@link ActionListener} is fired, if a list item
     * is double clicked.
     * 
     * @param l the listener.
     */
    public final void setActionListener(final ActionListener l) {
        if (l == null) {
            throw new NullPointerException("Null listener given.");
        }
        
        // Add listener mouse listener to synthesize an action event
        tree.addMouseListener(new MouseAdapter() {
            
            @Override
            public void mouseClicked(MouseEvent e) {
                if ((e.getClickCount() == 1 && !doubleClickAction) || 
                    (e.getClickCount() == 2 && doubleClickAction)) {
                    DefaultMutableTreeNode node = (DefaultMutableTreeNode)
                                                    tree.getLastSelectedPathComponent();
                    if (node != null) {
                        int nodeId = session.getIdByObject(node);
                        try {
                            session.writeInt(nodeId, Japi2Session.TargetStream.ACTION);
                        } catch (Exception ex) {
                            Japi2.getInstance().debug("Can't write list action "
                                                         + "event: {0}", ex);
                        }
                    }
                }
            }
        });
        
    }

//    public static void main(String[] args) {
//        JTree tree;
//        JFrame frame = new JFrame();
//
//        DefaultMutableTreeNode root = new DefaultMutableTreeNode("root");
//        DefaultMutableTreeNode node1 = new DefaultMutableTreeNode("node1");
//        root.add(node1);
//        DefaultMutableTreeNode node2 = new DefaultMutableTreeNode("node2");
//        root.add(node2);
//        
//        tree = new JTree(root);
//        
//        frame.add(tree);
//        frame.pack();
//        frame.setVisible(true);
//    }
    
}
