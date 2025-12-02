import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.*;
import java.sql.*;
import java.util.Vector;

public class ShopManagerPro extends JFrame {

    private static final String DB_URL = "jdbc:sqlserver://localhost;instanceName=SQLEXPRESS;databaseName=SHOP1;encrypt=false;trustServerCertificate=true;";
    private static final String DB_USER = "sa";
    private static final String DB_PASS = "9999999999";

    public ShopManagerPro() {
        super("Hệ thống Quản lý SHOP");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1300, 800);
        setLocationRelativeTo(null);

        UIManager.put("Table.font", new Font("Segoe UI", Font.PLAIN, 14));
        UIManager.put("Label.font", new Font("Segoe UI", Font.PLAIN, 14));
        UIManager.put("Button.font", new Font("Segoe UI", Font.BOLD, 13));
        UIManager.put("TextField.font", new Font("Segoe UI", Font.PLAIN, 14));

        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Segoe UI", Font.BOLD, 14));

        // ========== MASTER DATA ==========
        tabs.add("Brand", new CrudPanel("BRAND",
                new String[]{"Mã Hãng", "Tên Hãng", "Xuất Xứ"},
                new String[]{"brand_id", "name", "origin"},
                "SELECT * FROM BRAND"));

        tabs.add("Category", new CrudPanel("CATEGORY",
                new String[]{"Mã Loại", "Tên Loại", "Cha (parent_id)"},
                new String[]{"category_id", "category_name", "parent_id"},
                "SELECT * FROM CATEGORY"));

        tabs.add("Product", new CrudPanel("PRODUCT",
                new String[]{"Mã SP", "Tên SP", "Trạng thái", "Brand", "Category"},
                new String[]{"product_id", "product_name", "status", "brand_id", "category_id"},
                "SELECT * FROM PRODUCT"));

        tabs.add("Product Variant", new CrudPanel("PRODUCT_VARIANT",
                new String[]{"Mã Variant", "Mã SP", "SKU", "Màu", "Size", "Chất liệu", "Giá nhập", "Giá bán"},
                new String[]{"variant_id", "product_id", "sku", "color", "size", "material", "import_price", "retail_price"},
                "SELECT * FROM PRODUCT_VARIANT"));

        tabs.add("Supplier", new CrudPanel("SUPPLIER",
                new String[]{"Mã NCC", "Tên NCC", "SĐT"},
                new String[]{"supplier_id", "name", "phone"},
                "SELECT * FROM SUPPLIER"));

        tabs.add("Supplier Product", new CrudPanel("SUPPLIER_PRODUCT",
                new String[]{"Mã NCC", "Variant", "Giá NCC"},
                new String[]{"supplier_id", "variant_id", "supplier_price"},
                "SELECT * FROM SUPPLIER_PRODUCT"));

        tabs.add("Stock Location", new CrudPanel("STOCK_LOCATION",
                new String[]{"Mã Kho", "Tên Kho", "TP", "Quận", "Đường"},
                new String[]{"location_id", "name", "city", "district", "street"},
                "SELECT * FROM STOCK_LOCATION"));

        tabs.add("Employee", new CrudPanel("EMPLOYEE",
                new String[]{"Mã NV", "Họ", "Tên đệm", "Tên", "SĐT", "Lương", "Kho làm việc"},
                new String[]{"employee_id", "lname", "mname", "fname", "phone", "salary", "location_id"},
                "SELECT * FROM EMPLOYEE"));

        tabs.add("Customer", new CrudPanel("CUSTOMER",
                new String[]{"Mã KH", "Họ", "Tên đệm", "Tên", "SĐT"},
                new String[]{"customer_id", "lname", "mname", "fname", "phone"},
                "SELECT * FROM CUSTOMER"));

        // ========== TRANSACTIONS ==========
        tabs.add("Import Order", new CrudPanel("IMPORT_ORDER",
                new String[]{"Mã Nhập", "Ngày", "Tổng tiền", "Trạng thái", "Mã NV", "Mã NCC", "Mã Kho"},
                new String[]{"import_id", "import_date", "total_amount", "status", "employee_id", "supplier_id", "location_id"},
                "SELECT * FROM IMPORT_ORDER"));

        tabs.add("Import Detail", new CrudPanelNoUpdate("IMPORT_DETAIL",
                new String[]{"Mã Nhập", "Variant", "Số lượng", "Đơn giá"},
                new String[]{"import_id", "variant_id", "quantity", "unit_price"},
                "SELECT * FROM IMPORT_DETAIL"));

        tabs.add("Stock Transfer", new CrudPanel("STOCK_TRANSFER",
                new String[]{"Mã Chuyển", "Từ Kho", "Đến Kho", "Ngày chuyển", "Ngày nhận", "Trạng thái", "NV"},
                new String[]{"transfer_id", "from_location", "to_location", "transfer_date", "received_date", "status", "employee_id"},
                "SELECT * FROM STOCK_TRANSFER"));

        tabs.add("Transfer Detail", new CrudPanelNoUpdate("STOCK_TRANSFER_DETAIL",
                new String[]{"Mã Chuyển", "Variant", "Số lượng"},
                new String[]{"transfer_id", "variant_id", "quantity"},
                "SELECT * FROM STOCK_TRANSFER_DETAIL"));

        tabs.add("Sales Order", new CrudPanel("SALES_ORDER",
                new String[]{"Mã HĐ", "Ngày", "Trạng thái", "Tổng tiền", "KH", "NV", "Kho"},
                new String[]{"order_id", "order_date", "status", "total_amount", "customer_id", "employee_id", "location_id"},
                "SELECT * FROM SALES_ORDER"));

        tabs.add("Sales Detail", new CrudPanelNoUpdate("SALES_DETAIL",
                new String[]{"Mã HĐ", "Variant", "Số lượng", "Giá", "Discount"},
                new String[]{"order_id", "variant_id", "quantity", "unit_price", "discount"},
                "SELECT * FROM SALES_DETAIL"));

        tabs.add("Inventory", new CrudPanelNoUpdate("INVENTORY",
                new String[]{"Mã Kho", "Variant", "Tồn"},
                new String[]{"location_id", "variant_id", "quantity"},
                "SELECT * FROM INVENTORY"));

        add(tabs);
    }

    // =============================================================
    // CRUD PANEL – Version Thanh Lịch & Gọn
    // =============================================================
    class CrudPanel extends JPanel {

        String table, sql;
        String[] labels, cols;

        JTable tbl;
        DefaultTableModel model;
        JTextField[] tf;

        public CrudPanel(String table, String[] labels, String[] cols, String sql) {
            this.table = table; this.labels = labels; this.cols = cols; this.sql = sql;

            setLayout(new BorderLayout(10, 10));
            setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

            // ================== TABLE ==================
            model = new DefaultTableModel(labels, 0);
            tbl = new JTable(model);
            tbl.setRowHeight(28);
            tbl.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 14));
            tbl.setSelectionBackground(new Color(220, 240, 255));

            tbl.addMouseListener(new MouseAdapter() {
                @Override
                public void mouseClicked(MouseEvent e) {
                    int r = tbl.getSelectedRow();
                    for (int i = 0; i < tf.length; i++)
                        tf[i].setText(model.getValueAt(r, i) + "");
                }
            });

            add(new JScrollPane(tbl), BorderLayout.CENTER);

            // ================== FORM ==================
            JPanel form = new JPanel(new GridLayout(labels.length, 2, 10, 10));
            form.setBorder(BorderFactory.createTitledBorder("Thông tin"));

            tf = new JTextField[labels.length];

            for (int i = 0; i < labels.length; i++) {
                JLabel lb = new JLabel(labels[i]);
                lb.setHorizontalAlignment(SwingConstants.RIGHT);

                tf[i] = new JTextField();
                tf[i].setBorder(BorderFactory.createCompoundBorder(
                        BorderFactory.createLineBorder(Color.GRAY),
                        BorderFactory.createEmptyBorder(5, 8, 5, 8)
                ));

                form.add(lb);
                form.add(tf[i]);
            }

            // ================== BUTTON BAR ==================
            JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 15, 10));

            JButton addBtn = styledBtn("Thêm", new Color(52, 168, 83));
            JButton updBtn = styledBtn("Sửa", new Color(66, 133, 244));
            JButton delBtn = styledBtn("Xóa", new Color(234, 67, 53));
            JButton clrBtn = styledBtn("Clear", new Color(150, 150, 150));
            JButton reloadBtn = styledBtn("Reload", new Color(255, 171, 0));

            btnPanel.add(addBtn);
            btnPanel.add(updBtn);
            btnPanel.add(delBtn);
            btnPanel.add(clrBtn);
            btnPanel.add(reloadBtn);

            JPanel bottom = new JPanel(new BorderLayout());
            bottom.add(form, BorderLayout.CENTER);
            bottom.add(btnPanel, BorderLayout.SOUTH);

            add(bottom, BorderLayout.SOUTH);

            // ================== EVENTS ==================
            load();

            reloadBtn.addActionListener(e -> load());
            clrBtn.addActionListener(e -> { for (JTextField x : tf) x.setText(""); });

            addBtn.addActionListener(e -> exec(buildInsert(), "Đã thêm!"));
            updBtn.addActionListener(e -> exec(buildUpdate(), "Đã cập nhật!"));
            delBtn.addActionListener(e -> exec("DELETE FROM " + table + " WHERE " + cols[0] + "=" + tf[0].getText(), "Đã xóa!"));
        }

        JButton styledBtn(String text, Color bg) {
            JButton b = new JButton(text);
            b.setForeground(Color.WHITE);
            b.setBackground(bg);
            b.setFocusPainted(false);
            b.setBorder(BorderFactory.createEmptyBorder(8, 15, 8, 15));
            return b;
        }

        // ================== DATA OPS ==================
        void load() {
            model.setRowCount(0);
            try (Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 Statement s = c.createStatement();
                 ResultSet rs = s.executeQuery(sql)) {

                while (rs.next()) {
                    Vector<Object> v = new Vector<>();
                    for (String col : cols) v.add(rs.getObject(col));
                    model.addRow(v);
                }
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Lỗi SQL: " + ex.getMessage());
            }
        }

        String buildInsert() {
            StringBuilder sb = new StringBuilder("INSERT INTO " + table + " VALUES(");
            for (int i = 0; i < tf.length; i++) {
                sb.append("N'").append(tf[i].getText()).append("'");
                if (i < tf.length - 1) sb.append(",");
            }
            sb.append(")");
            return sb.toString();
        }

        String buildUpdate() {
            StringBuilder sb = new StringBuilder("UPDATE " + table + " SET ");
            for (int i = 1; i < cols.length; i++) {
                sb.append(cols[i]).append("=N'").append(tf[i].getText()).append("'");
                if (i < cols.length - 1) sb.append(",");
            }
            sb.append(" WHERE ").append(cols[0]).append("=").append(tf[0].getText());
            return sb.toString();
        }

        void exec(String q, String msg) {
            try (Connection c = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                 Statement s = c.createStatement()) {
                s.executeUpdate(q);
                JOptionPane.showMessageDialog(this, msg);
                load();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Lỗi SQL: " + ex.getMessage());
            }
        }
    }

    // =============================================================
    // BẢNG DETAIL – KHÔNG CHO UPDATE
    // =============================================================
    class CrudPanelNoUpdate extends CrudPanel {

        public CrudPanelNoUpdate(String table, String[] labels, String[] cols, String sql) {
            super(table, labels, cols, sql);
        }

        @Override
        String buildUpdate() {
            return null;
        }

        @Override
        void exec(String q, String msg) {
            if (q == null) {
                JOptionPane.showMessageDialog(this, "Bảng này có khóa kép → KHÔNG hỗ trợ UPDATE");
                return;
            }
            super.exec(q, msg);
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new ShopManagerPro().setVisible(true));
    }
}
