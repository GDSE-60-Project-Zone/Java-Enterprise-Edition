package filters;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class DefaultFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        //http://localhost:3306/filter/b
        //a?name=ijse //true -> dispatch to a
        //b?name=ijse //true -> dispatch to b
        String name = servletRequest.getParameter("name");
        HttpServletRequest req = (HttpServletRequest) servletRequest;
        String servletPath = req.getServletPath();

        if (name.equals("ijse")&& servletPath.equals("/a")){
            filterChain.doFilter(servletRequest,servletResponse);

        } else if (name.equals("ijse")&& servletPath.equals("/b")) {
            filterChain.doFilter(servletRequest,servletResponse);

        } else{
            servletResponse.getWriter().write("<h1>Wade awul</h1>");
        }
    }

    @Override
    public void destroy() {

    }
}
