package kr.go.culture;

import com.opensymphony.sitemesh.webapp.SiteMeshFilter;
import kr.go.culture.config.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

import javax.servlet.Filter;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;

public class CultureWebApplicationInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
    private static Logger logger = LoggerFactory.getLogger(CultureWebApplicationInitializer.class);

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        servletContext.setInitParameter("sitemesh.configfile", "/WEB-INF/sitemesh.xml");
        super.onStartup(servletContext);
    }

    @Override
    protected Filter[] getServletFilters() {
//        XssEscapeServletFilter xssEscapeServletFilter = new XssEscapeServletFilter();
        SiteMeshFilter siteMeshFilter = new SiteMeshFilter();
        return new Filter[]{
//                xssEscapeServletFilter
                siteMeshFilter
        };
    }

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[]{
                RootConfiguration.class,
                DataSourceConfiguration.class,
                OrmConfiguration.class,
                WebSecurityConfiguration.class
        };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[]{
                WebConfiguration.class
        };
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"*.do", "*.ajax"};
    }


}
