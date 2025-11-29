import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.sql.*;
import java.util.Vector;

public class GiaoDienSHOP extends JFrame {

    private static final String CONNECT_URL = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=SHOP1;encrypt=false;";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "9999999999";

    private JTable table;
    private JLabel statusLabel;

    public GiaoDienSHOP() {
        super("Giao diện quản lí SHOP");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1100, 650);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout());

        // Bảng kết quả
        table = new JTable();
        table.setFillsViewportHeight(true); // Tự động giãn chiều cao
        table.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS); // Tự động giãn chiều ngang cột
        table.setRowHeight(25); // (Tùy chọn) Tăng chiều cao dòng cho dễ nhìn
        table.setFont(new Font("Segoe UI", Font.PLAIN, 14)); // (Tùy chọn) Chữ to hơn
        add(new JScrollPane(table), BorderLayout.CENTER);

        // Thanh trạng thái
        statusLabel = new JLabel("Ready");
        statusLabel.setBorder(BorderFactory.createEmptyBorder(5,10,5,10));
        add(statusLabel, BorderLayout.SOUTH);

        // Panel truy vấn nằm bên trái
        add(buildLeftPanel(), BorderLayout.WEST);
    }

    /** PANEL BÊN TRÁI - DANH SÁCH TRUY VẤN */
    private JPanel buildLeftPanel() {
        JPanel panel = new JPanel();
        panel.setLayout(new BorderLayout());
        panel.setPreferredSize(new Dimension(420, 0)); // rộng bên trái

        JLabel title = new JLabel("GIAO DIỆN QUẢN LÍ", SwingConstants.CENTER);
        title.setFont(new Font("Segoe UI", Font.BOLD, 16));
        title.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panel.add(title, BorderLayout.NORTH);
            
        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new GridLayout(10, 1, 10, 10));
        buttonPanel.setBorder(BorderFactory.createEmptyBorder(10,10,10,10));

        // ======= DANH SÁCH TRUY VẤN =======
        buttonPanel.add(makeButton("1. Tổng số lượng tồn kho của từng kho",
                "SELECT sl.location_id, sl.name AS location_name, SUM(i.quantity) AS total_quantity FROM INVENTORY i JOIN STOCK_LOCATION sl ON sl.location_id = i.location_id GROUP BY sl.location_id, sl.name;"));

        buttonPanel.add(makeButton("2. Top 5 sản phẩm bán chạy nhất",
                "SELECT TOP 5 p.product_name, SUM(sd.quantity) AS total_sold FROM SALES_DETAIL sd JOIN SALES_ORDER so ON sd.order_id = so.order_id AND so.status = 'Completed' JOIN PRODUCT_VARIANT pv ON sd.variant_id = pv.variant_id JOIN PRODUCT p ON pv.product_id = p.product_id GROUP BY p.product_name ORDER BY total_sold DESC;"));

        buttonPanel.add(makeButton("3. Doanh thu theo từng cửa hàng",
                "SELECT sl.location_id, sl.name, SUM(so.total_amount) AS revenue FROM SALES_ORDER so JOIN STOCK_LOCATION sl ON so.location_id = sl.location_id WHERE so.status = 'Completed' GROUP BY sl.location_id, sl.name;"));

        buttonPanel.add(makeButton("4. Doanh thu mỗi ngày",
                "SELECT order_date, SUM(total_amount) AS daily_revenue FROM SALES_ORDER WHERE status = 'Completed' GROUP BY order_date ORDER BY order_date;"));

        buttonPanel.add(makeButton("5. Tồn kho chi tiết từng sản phẩm ở mỗi kho",
                "SELECT sl.name AS location_name, pv.sku, pv.color, pv.size, i.quantity FROM INVENTORY i JOIN PRODUCT_VARIANT pv ON i.variant_id = pv.variant_id JOIN STOCK_LOCATION sl ON i.location_id = sl.location_id ORDER BY sl.location_id, pv.variant_id;"));

        buttonPanel.add(makeButton("6. Tổng nhập của mỗi sản phẩm",
                "SELECT pv.variant_id, pv.sku, SUM(id.quantity) AS total_imported FROM IMPORT_DETAIL id JOIN PRODUCT_VARIANT pv ON id.variant_id = pv.variant_id GROUP BY pv.variant_id, pv.sku;"));

        buttonPanel.add(makeButton("7. Tổng xuất kho theo từng kho",
                "SELECT st.from_location, sl.name, SUM(std.quantity) AS total_transfer_out FROM STOCK_TRANSFER_DETAIL std JOIN STOCK_TRANSFER st ON std.transfer_id = st.transfer_id JOIN STOCK_LOCATION sl ON st.from_location = sl.location_id GROUP BY st.from_location, sl.name;"));

        buttonPanel.add(makeButton("8. Khách hàng mua nhiều nhất",
                "SELECT c.customer_id, CONCAT(c.fname, ' ', c.lname) AS fullname, SUM(so.total_amount) AS total_spent FROM SALES_ORDER so JOIN CUSTOMER c ON so.customer_id = c.customer_id WHERE so.status = 'Completed' GROUP BY c.customer_id, c.fname, c.lname ORDER BY total_spent DESC;"));

        buttonPanel.add(makeButton("9. Lợi nhuận theo từng sản phẩm",
                "SELECT p.product_name, SUM((sd.unit_price - pv.import_price) * sd.quantity) AS profit FROM SALES_DETAIL sd JOIN SALES_ORDER so ON sd.order_id = so.order_id AND so.status = 'Completed' JOIN PRODUCT_VARIANT pv ON sd.variant_id = pv.variant_id JOIN PRODUCT p ON pv.product_id = p.product_id GROUP BY p.product_name;"));

        buttonPanel.add(makeButton("10. Nhân viên tạo nhiều đơn bán nhất",
                "SELECT e.employee_id, CONCAT(e.fname, ' ', e.lname) AS employee_name, COUNT(*) AS total_orders FROM SALES_ORDER so JOIN EMPLOYEE e ON so.employee_id = e.employee_id WHERE so.status = 'Completed' GROUP BY e.employee_id, e.fname, e.lname ORDER BY total_orders DESC;"));

        panel.add(buttonPanel, BorderLayout.CENTER);

        return panel;
    }

    /** BUTTON ĐẸP */
    private JButton makeButton(String title, String sql) {
        JButton btn = new JButton("<html><b>" + title + "</b></html>");
        btn.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        btn.setFocusPainted(false);
        btn.setBackground(new Color(66, 135, 245));  // xanh nhẹ
        btn.setForeground(Color.WHITE);
        btn.setOpaque(true);
        btn.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(40, 90, 200)),
                BorderFactory.createEmptyBorder(8, 10, 8, 10)
        ));

        btn.addActionListener(e -> runQuery(sql, title));
        return btn;
    }

    /** THỰC THI TRUY VẤN */
    private void runQuery(String sql, String title) {
        statusLabel.setText("Running: " + title);

        new SwingWorker<DefaultTableModel, Void>() {
            String message = null;

            @Override
            protected DefaultTableModel doInBackground() {
                try (Connection conn = DriverManager.getConnection(CONNECT_URL, DB_USER, DB_PASSWORD);
                     Statement st = conn.createStatement();
                     ResultSet rs = st.executeQuery(sql)) {

                    return buildTableModel(rs);
                } catch (SQLException ex) {
                    message = ex.getMessage();
                    return null;
                }
            }

            @Override
            protected void done() {
                try {
                    DefaultTableModel model = get();
                    if (model != null) {
                        table.setModel(model);
                        statusLabel.setText("Hoàn thành truy vấn: " + title + " — Số dòng dữ liệu: " + model.getRowCount());
                    } else {
                        statusLabel.setText("Error: " + message);
                        JOptionPane.showMessageDialog(GiaoDienSHOP.this, message, "SQL Error", JOptionPane.ERROR_MESSAGE);
                    }
                } catch (Exception ex) {
                    JOptionPane.showMessageDialog(GiaoDienSHOP.this, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        }.execute();
    }

    private DefaultTableModel buildTableModel(ResultSet rs) throws SQLException {
        ResultSetMetaData meta = rs.getMetaData();
        int columnCount = meta.getColumnCount();

        Vector<String> colNames = new Vector<>();
        for (int i = 1; i <= columnCount; i++)
            colNames.add(meta.getColumnLabel(i));

        Vector<Vector<Object>> data = new Vector<>();
        while (rs.next()) {
            Vector<Object> row = new Vector<>();
            for (int i = 1; i <= columnCount; i++)
                row.add(rs.getObject(i));
            data.add(row);
        }

        return new DefaultTableModel(data, colNames);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new GiaoDienSHOP().setVisible(true));
    }
}
