package servlet;

import org.apache.commons.dbcp2.BasicDataSource;

import javax.json.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(urlPatterns = "/purchase")
public class PurchaseOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        JsonReader reader = Json.createReader(req.getReader());
        JsonObject jsonObject = reader.readObject();
        String oid = jsonObject.getString("oid");
        String cusId = jsonObject.getString("cusID");
        String date = jsonObject.getString("date");

        try (Connection connection = ((BasicDataSource) getServletContext().getAttribute("dbcp")).getConnection();){

            connection.setAutoCommit(false);

            PreparedStatement pstm = connection.prepareStatement("insert into Orders values(?,?,?)");
            pstm.setObject(1,oid);
            pstm.setObject(2,date);
            pstm.setObject(3,cusId);
            if (!(pstm.executeUpdate()>0)) {
                connection.rollback();
                connection.setAutoCommit(true);
                throw new RuntimeException("Order Issue");
            }else{
                JsonArray orderDetails = jsonObject.getJsonArray("orderDetails");
                for (JsonValue orderDetail : orderDetails) {
                    String code = orderDetail.asJsonObject().getString("code");
                    String qty = orderDetail.asJsonObject().getString("qty");
                    String price = orderDetail.asJsonObject().getString("price");

                    PreparedStatement pstms = connection.prepareStatement("insert into OrderDetails values(?,?,?,?)");
                    pstms.setObject(1,oid);
                    pstms.setObject(2,code);
                    pstms.setObject(3,qty);
                    pstms.setObject(4,price);
                    if (!(pstms.executeUpdate()>0)) {
                        connection.rollback();
                        connection.setAutoCommit(true);
                        throw new RuntimeException("Order Details Issue");
                    }
                }

                connection.commit();
                connection.setAutoCommit(true);

                JsonObjectBuilder error = Json.createObjectBuilder();
                error.add("state","Success");
                error.add("message","Order Successfully Purchased..!");
                error.add("data","");
                resp.getWriter().print(error.build());

            }

        } catch (SQLException | RuntimeException e) {
            JsonObjectBuilder error = Json.createObjectBuilder();
            error.add("state","Error");
            error.add("message",e.getLocalizedMessage());
            error.add("data","");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().print(error.build());
        }

    }
}
