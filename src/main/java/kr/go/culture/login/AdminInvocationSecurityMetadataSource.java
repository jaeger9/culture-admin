package kr.go.culture.login;

import java.util.Collection;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.login.service.UrlResourceService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;
import org.springframework.security.web.util.AntPathRequestMatcher;

public class AdminInvocationSecurityMetadataSource implements
		FilterInvocationSecurityMetadataSource {
	// private UrlMatcher urlMatcher = new AntUrlPathMatcher(); spring security 3.1 ???�놈???�다;;;;
	
	private UrlResourceService urlResourceService;
	
	private static Map<String, Collection<ConfigAttribute>> resourceMap = null;
	
	public AdminInvocationSecurityMetadataSource() {
		loadResourceDefine();
	}

	/**
	 * 
	 */
	private void loadResourceDefine() {
		/* DB ?�을??권한 ?�던�?
		resourceMap = new HashMap<String, Collection<ConfigAttribute>>();
		Collection<ConfigAttribute> atts = new ArrayList<ConfigAttribute>();
		Collection<ConfigAttribute> atts2 = new ArrayList<ConfigAttribute>();
		Collection<ConfigAttribute> atts3 = new ArrayList<ConfigAttribute>();
		Collection<ConfigAttribute> atts4 = new ArrayList<ConfigAttribute>();
		ConfigAttribute ca = new SecurityConfig("ROLE_ADMIN");
		ConfigAttribute ca2 = new SecurityConfig("ROLE_TESTER");
		ConfigAttribute ca3 = new SecurityConfig("ROLE_MANAGER");
		ConfigAttribute ca4 = new SecurityConfig("permitAll");
		atts.add(ca);
		atts2.add(ca);
		atts2.add(ca2);
		atts3.add(ca3);
		atts4.add(ca4);
		
		resourceMap.put("/welcome.do", atts);
		resourceMap.put("/test1.do", atts2);
		resourceMap.put("/test2.do", atts2);
		
		resourceMap.put("/list.do", atts3);
		resourceMap.put("/bookmark.do", atts3);
		
		System.out.println("resourceMap:" + resourceMap);*/
		

		/*resourceMap.put("/", atts4);*/
	}
	
	/**
	 *According to a URL, Find out permission configuration of this URL. 
	 */
	public Collection<ConfigAttribute> getAttributes(Object object)  
            throws IllegalArgumentException {  
        // guess object is a URL.  
        HttpServletRequest request =  ((FilterInvocation)object).getRequest();
    	AntPathRequestMatcher matcher = null;
    	
        String url = ((FilterInvocation)object).getRequestUrl();  

        Iterator<String> ite = resourceMap.keySet().iterator();  
 
        while (ite.hasNext()) { 
        	String resURL = ite.next();
            matcher = new AntPathRequestMatcher(resURL);
            
            if (matcher.matches(request)) {  
                return resourceMap.get(resURL);  
             }  
         }  
        return null;  
     }
	public boolean supports(Class<?> clazz) {
		return true;
	}

	public Collection<ConfigAttribute> getAllConfigAttributes() {
		return null;
	}

	public UrlResourceService getUrlResourceService() {
		return urlResourceService;
	}

	/**
	 * urlResourceService Autowired ?�기???�에 loadResourceDefine() ?�출?�서�?
	 * Autowired ?�때 resourceMap ?�기???�정 ?�버�?...
	 * 
	 * @param urlResourceService
	 */
	@Autowired
	public void setUrlResourceService(UrlResourceService urlResourceService) {
		this.urlResourceService = urlResourceService;
		
		try {
			resourceMap = urlResourceService.getResource();
			System.out.println("resourceMap:" + resourceMap);				
		} catch (Exception e) {
			

		}
	}
}