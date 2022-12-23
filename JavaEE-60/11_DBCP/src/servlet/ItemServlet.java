package servlet;

import org.apache.commons.dbcp2.BasicDataSource;


import javax.json.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet(urlPatterns = "/item")
public class ItemServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        try ( Connection connection = ((BasicDataSource) getServletContext().getAttribute("dbcp")).getConnection()){
            PreparedStatement pstm = connection.prepareStatement("select * from Item");
            ResultSet rst = pstm.executeQuery();
//
            JsonArrayBuilder allItems = Json.createArrayBuilder();
            while (rst.next()) {
                JsonObjectBuilder item = Json.createObjectBuilder();
                item.add("code", rst.getString("code"));
                item.add("description", rst.getString("description"));
                item.add("qtyOnHand", rst.getString("qtyOnHand"));
                item.add("unitPrice", rst.getDouble("unitPrice"));
                allItems.add(item.build());
            }


            JsonObjectBuilder job = Json.createObjectBuilder();
            job.add("state","Ok");
            job.add("message","Successfully Loaded..!");
            job.add("data",allItems.build());
            resp.getWriter().print(job.build());

        } catch (SQLException e){
            JsonObjectBuilder rjo = Json.createObjectBuilder();
            rjo.add("state","Error");
            rjo.add("message",e.getLocalizedMessage());
            rjo.add("data","");
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().print(rjo.build());
        }
    }

    //Query String
    // Form Data (x-www-form-urlencoded)
    //JSON
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        String description = req.getParameter("description");
        String qtyOnHand = req.getParameter("qtyOnHand");
        String unitPrice = req.getParameter("unitPrice");
        try( Connection connection = ((BasicDataSource) getServletContext().getAttribute("dbcp")).getConnection()){
            PreparedStatement pstm = connection.prepareStatement("insert into Item values(?,?,?,?)");
            pstm.setObject(1, code);
            pstm.setObject(2, description);
            pstm.setObject(3, qtyOnHand);
            pstm.setObject(4, unitPrice);
            boolean b = pstm.executeUpdate() > 0;
            if (b) {
                JsonObjectBuilder responseObject = Json.createObjectBuilder();
                responseObject.add("state","Ok");
                responseObject.add("message","Successfully added..!");
                responseObject.add("data","");
                resp.getWriter().print(responseObject.build());
            }
        } catch (SQLException e) {
            JsonObjectBuilder error = Json.createObjectBuilder();
            error.add("state","Error");
            error.add("message",e.getLocalizedMessage());
            error.add("data","");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().print(error.build());
        }
    }


    //Query String
    //JSON
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String code = req.getParameter("code");
        try( Connection connection = ((BasicDataSource) getServletContext().getAttribute("dbcp")).getConnection()) {
            PreparedStatement pstm = connection.prepareStatement("delete from Item where code=?");
            pstm.setObject(1, code);
            boolean b = pstm.executeUpdate() > 0;
            if (b) {
                JsonObjectBuilder rjo = Json.createObjectBuilder();
                rjo.add("state","Ok");
                rjo.add("message","Successfully Deleted..!");
                rjo.add("data","");
                resp.getWriter().print(rjo.build());
            }else{
                throw new RuntimeException("There is no such customer for that ID..!");
            }
        } catch (SQLException | RuntimeException e) {
            JsonObjectBuilder rjo = Json.createObjectBuilder();
            rjo.add("state","Error");
            rjo.add("message",e.getLocalizedMessage());
            rjo.add("data","");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().print(rjo.build());
        }

    }

    //Query String
    //JSON
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JsonReader reader = Json.createReader(req.getReader());
        JsonObject customer = reader.readObject();
        String code = customer.getString("code");
        String description = customer.getString("description");
        String qtyOnHand = customer.getString("qtyOnHand");
        String unitPrice = customer.getString("unitPrice");

        try( Connection connection = ((BasicDataSource) getServletContext().getAttribute("dbcp")).getConnection()){
            PreparedStatement pstm = connection.prepareStatement("update Item set description=?,qtyOnHand=?,unitPrice=? where code=?");
            pstm.setObject(4, code);
            pstm.setObject(1, description);
            pstm.setObject(2, qtyOnHand);
            pstm.setObject(3, unitPrice);
            boolean b = pstm.executeUpdate() > 0;
            if (b) {
                JsonObjectBuilder responseObject = Json.createObjectBuilder();
                responseObject.add("state","Ok");
                responseObject.add("message","Successfully Updated..!");
                responseObject.add("data","");
                resp.getWriter().print(responseObject.build());
            }else{
                throw new RuntimeException("Wrong ID, Please Check The ID..!");
            }

        } catch (SQLException | RuntimeException e) {
            JsonObjectBuilder rjo = Json.createObjectBuilder();
            rjo.add("state","Error");
            rjo.add("message",e.getLocalizedMessage());
            rjo.add("data","");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().print(rjo.build());
        }
    }

}
