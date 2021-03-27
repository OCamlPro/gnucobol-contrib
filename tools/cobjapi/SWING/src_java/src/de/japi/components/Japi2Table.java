package de.japi.components;

import de.japi.Japi2;
import de.japi.Japi2Session;
import de.japi.components.listeners.AbstractJapi2Listener;
import de.japi.components.listeners.Japi2ActionListener;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import static javax.swing.JTable.AUTO_RESIZE_ALL_COLUMNS;
import static javax.swing.JTable.AUTO_RESIZE_OFF;
import javax.swing.ListSelectionModel;
import javax.swing.UIManager;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;

/**
 * A simple table component. This component already contains scroll bars.
 */
// public class Japi2Table extends JScrollPane {
public class Japi2Table extends JPanel {
    
    /**
     * The table dimensions.
     */
    private int width = 0, height = 0;
    
    /**
     * The table model.
     */
    private final Japi2TableModel model;
    
    /**
     * The internal table component.
     */
    private final JTable table;
    private final JPanel thisPanel;
    private Japi2ActionListener japiListener;
    
    private JScrollPane scrollPane;

    Japi2Session session;
    
    /**
     * Creates a new Table. 
     * @param sessionIn the session
     * @param columnNames names of the columns
     */
    public Japi2Table(Japi2Session sessionIn, Object[] columnNames) {
        thisPanel = this;
        table = new JTable();
        scrollPane = new JScrollPane(table);
        thisPanel.add(scrollPane);

        session = sessionIn;
        table.setModel(model = new Japi2TableModel(columnNames, 0));
        // set some default configurations
        table.setFocusable(false);
        table.getTableHeader().setReorderingAllowed(false);
        table.getTableHeader().setResizingAllowed(true);
        // for header background color
//        table.getTableHeader().setOpaque(false);
//        thisPanel.setOpaque(false);
//        scrollPane.getViewport().setOpaque(false);

        // center header
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) table.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);

        
        table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        table.setColumnSelectionAllowed(false);
        table.setRowSelectionAllowed(true); 
        //  table.setAutoResizeMode(AUTO_RESIZE_ALL_COLUMNS);
        table.setAutoResizeMode(AUTO_RESIZE_OFF);
        // table.setCellSelectionEnabled(false);
        
        table.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent me) {
                if (me.getClickCount() == 2) {     // to detect doble click events
//                    int tableId = session.getIdByObject(thisTable);                    
                    int tableId = session.getIdByObject(thisPanel);                    
                    try {
                        session.writeInt(tableId, Japi2Session.TargetStream.ACTION);
                    } catch (Exception ex) {
                        Japi2.getInstance().debug("Can't write table action "
                                + "event: {0}", ex);
                    }
                }
            }
        });
    }

    /**
     * A very simple custom table model.
     */
    private class Japi2TableModel extends DefaultTableModel {
        /**
         * Creates a new Japi2TableModel. 
        */
        public Japi2TableModel(Object[] columnNames, int rowCount) {
            super(columnNames, rowCount);
        }
        
        @Override
        public boolean isCellEditable(int row, int column) {
            return false;
        }        
    }
    
    /**
     * The internal table component.
     * 
     * @return the table.
     */
    public JTable getTable() {
        return table;
    }
    
    @Override
    public synchronized void addMouseListener(MouseListener l) {
        if (l instanceof AbstractJapi2Listener) {
            table.addMouseListener(l);
        } else {
            super.addMouseListener(l);
        }
    }

    @Override
    public synchronized void addMouseMotionListener(MouseMotionListener l) {
        if (l instanceof AbstractJapi2Listener) {
            table.addMouseMotionListener(l);
        } else {
            super.addMouseMotionListener(l);
        }
    }

    /**
     * Returns the action listener for this component.
     * @return Japi2ActionListener
     */
    public Japi2ActionListener getJapiListener() {
        return japiListener;
    }

    /**
     * Setts an action listener for this component.
     * @param tl 
     */
    public void setJapiListener(Japi2ActionListener tl) {
        japiListener = tl;
    } 
    
    /**
     * Adds a new item to the table.
     * 
     * @param rowData the textual representation of the row data to add.
     */
    public void addRow(Object [] rowData) {
        model.addRow(rowData);
        model.fireTableDataChanged();
    }
    
    /**
     * Clears the contents of the table.
     */
    public void clear() {
        int rowCount = model.getRowCount();
        model.setNumRows(0);
        model.fireTableDataChanged();
    }

    /**
     * Adds a new item to the table.
     * 
     * @param columnWidths the column widths.
     */
    public void setColumnWidths(Object [] columnWidths) {
        TableColumnModel columnModel = table.getColumnModel();
        for (int i = 0; i < columnWidths.length; i++) {
            if (i < columnModel.getColumnCount()) {
                columnModel.getColumn(i).setPreferredWidth( Integer.parseInt(columnWidths[i].toString()));
            } else {
                break;
            }
        }
        model.fireTableDataChanged();
    }

    /**
     * Triggers a re-render event of the table.
     */
    public void update() {
        model.fireTableDataChanged();
    }
    
    /**
     * Sets the size to the given dw and dh values or to zero if they are smaler
     * than zero.
     * @param dw
     * @param dh 
     */
    @Override
    public void setSize(int dw, int dh) {
        width = dw > 0 ? dw : 0;
        height = dh > 0 ? dh : 0;
        super.setSize(width, height);
    }
    
    /**
     * Returns the preferredSize of this component. If width/height values are
     * greater zero they are returned instead of the preferred Size of the 
     * super class.
     * @return the preferred Size as Dimension 
     */
    @Override
    public Dimension getPreferredSize() {
        Dimension dim = super.getPreferredSize();
        dim.width = width > 0 ? width : dim.width;
        dim.height = height > 0 ? height : dim.height;
        return (dim);
    }
    
    /**
     * Returns the minimum size by overwriting getMinimumSize of JCheckBox.
     * @return minimum Size as Dimension
     */
    @Override
    public Dimension getMinimumSize() {
        Dimension dim = super.getMinimumSize();
        dim.width = width > 0 ? width : dim.width;
        dim.height = height > 0 ? height : dim.height;
        return (dim);
    }
    
//    public static void main(String[] args) {
//        Japi2Table table;
//        JFrame frame = new JFrame("Japi2Table Demo");
//        frame.setLayout(new BorderLayout());
//        JPanel panel = new JPanel();
//
//        String[] columnNames = {"First Name", "Last Name", "Sport", "# of Years", "Vegetarian"};
//        String[] row1 = {"László", "Erdős", "Yoga", "30", "Yes"};
//        String[] row2 = {"John", "Doe", "Rowing", "23", "No"};
//        String[] row3 = {"John", "Doe", "Rowing", "23", "No"};
//        String[] row4 = {"John", "Doe", "Rowing", "23", "No"};
//        String[] row5 = {"John", "Doe", "Rowing", "23", "No"};
//        
//        table = new Japi2Table(null, columnNames);
//        table.getTable().setPreferredScrollableViewportSize(new Dimension(500, 70));
//        table.getTable().setFillsViewportHeight(true);
//        
//        table.addRow(row1);
//        table.addRow(row2);
//        table.addRow(row3);
//        table.addRow(row4);
//        table.addRow(row5);
//
//        panel.add(table);
//        frame.add(panel, BorderLayout.CENTER);
//        
//        frame.pack();
//        frame.setVisible(true);
//        
//        System.out.println(table.getBounds().height + ", " + table.getBounds().width);
//    }
    
}
