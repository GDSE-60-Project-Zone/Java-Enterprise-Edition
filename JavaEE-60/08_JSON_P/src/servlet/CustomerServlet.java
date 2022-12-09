package servlet;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet(urlPatterns = "/customer")
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/company", "root", "sanu1234");
            PreparedStatement pstm = connection.prepareStatement("select * from Customer");
            ResultSet rst = pstm.executeQuery();
//
            JsonArrayBuilder allCustomers = Json.createArrayBuilder();
            while (rst.next()) {
                JsonObjectBuilder customer = Json.createObjectBuilder();
                customer.add("id",rst.getString("id"));
                customer.add("name",rst.getString("name"));
                customer.add("address",rst.getString("address"));
                customer.add("salary",rst.getDouble("salary"));
                allCustomers.add(customer.build());
            }
            resp.addHeader("Content-Type","application/json");
            resp.getWriter().print(allCustomers.build());

        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        String name = req.getParameter("name");
        String address = req.getParameter("address");
        String option = req.getParameter("option");

        try {

            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/company", "root", "sanu1234");

            if (option.equals("add")) {
                double salary = Double.parseDouble(req.getParameter("salary"));
                PreparedStatement pstm = connection.prepareStatement("insert into Customer values(?,?,?,?)");
                pstm.setObject(1, id);
                pstm.setObject(2, name);
                pstm.setObject(3, address);
                pstm.setObject(4, salary);
                boolean b = pstm.executeUpdate() > 0;
                resp.setStatus(201);//created

            } else if (option.equals("remove")) {
                PreparedStatement pstm = connection.prepareStatement("delete from Customer where id=?");
                pstm.setObject(1, id);
                boolean b = pstm.executeUpdate() > 0;

            } else if (option.equals("update")) {
                double salary = Double.parseDouble(req.getParameter("salary"));
                PreparedStatement pstm = connection.prepareStatement("update Customer set name=?,address=?,salary=? where id=?");
                pstm.setObject(4, id);
                pstm.setObject(1, name);
                pstm.setObject(2, address);
                pstm.setObject(3, salary);
                boolean b = pstm.executeUpdate() > 0;
            }

        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
