package listerns;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class MyListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println("Servlet Context Created");
        ServletContext servletContext = servletContextEvent.getServletContext();
        servletContext.setAttribute("pkey","PASAN");
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("Servlet Context Destroyed");
    }
}


//What is a listener
//What is a Servlet Container.?
//What are the other names for Servlet Container.?
//What are the lifecycle methods of a Servlet.?
//What happened after init method invocation of a servlet
//When the destroy method invoked in a Servlet
//How to put values inside a Servlet Container
//Why we need to use ServletContextListener
