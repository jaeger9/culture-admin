package kr.go.culture.login;

import java.util.Collection;
import java.util.Iterator;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.authentication.InsufficientAuthenticationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.FilterInvocation;

public class AdminAccessDecisionManager implements AccessDecisionManager {

	private static final Logger logger = LoggerFactory.getLogger(AdminAccessDecisionManager.class);

	// In this method, need to compare authentication with configAttributes.
	// 1, A object is a URL, a filter was find permission configuration by this
	// URL, and pass to here.
	// 2, Check authentication has attribute in permission configuration
	// (configAttributes)
	// 3, If not match corresponding authentication, throw a
	// AccessDeniedException.
	public void decide(Authentication authentication, Object object,
			Collection<ConfigAttribute> configAttributes)
			throws AccessDeniedException, InsufficientAuthenticationException {

		if (logger.isDebugEnabled()) {
			logger.debug("SampleAccessDecisionManager[decide]");
		}

		FilterInvocation filterInvocation = null;
		HttpServletResponse response = null;
		
		String requestUrl = null;
		
		if (configAttributes == null) {
			return;
		}

		if (logger.isDebugEnabled()) {
			logger.debug("object is url: {}", object.toString()); // object is a URL.
		}

		Iterator<ConfigAttribute> ite = configAttributes.iterator();
		
		while (ite.hasNext()) {
		
			ConfigAttribute ca = ite.next();
			String needRole = ((SecurityConfig) ca).getAttribute();
			
			for (GrantedAuthority ga : authentication.getAuthorities()) {
			
				if (needRole.equals(ga.getAuthority())) { // ga is user's role.
					return;
				}
			}
		}
		
		throw new AccessDeniedException("no right");
	}

	public boolean supports(ConfigAttribute attribute) {
		// TODO Auto-generated method stub
		return true;
	}

	public boolean supports(Class<?> clazz) {
		return true;
	}

}