package kr.go.culture.login;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.PortResolverImpl;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.DefaultSavedRequest;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Service;

@Service
public class AdminAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

	private static final Logger logger = LoggerFactory.getLogger(AdminAuthenticationSuccessHandler.class);

	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
		
		SavedRequest savedRequest =  new DefaultSavedRequest(request, new PortResolverImpl());

		if (logger.isDebugEnabled()) {
			logger.debug("redirectUrl:" + savedRequest.getRedirectUrl());

			logger.debug("name: {}", authentication.getName());
			logger.debug("detal: {}", authentication.getDetails());
			logger.debug("detal: {}", authentication.getAuthorities());

			logger.debug("OpadmAuthenticationSuccessHandler request URI: {}", request.getRequestURI());
		}

		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		HttpSession session = request.getSession(true);
		
		// put the UserDetails object here.
		session.setAttribute("userDetails", principal);
		session.setAttribute("admin_id", authentication.getName());


		if (logger.isDebugEnabled()) {
			logger.debug("userDetails: {}", session.getAttribute("userDetails"));
			logger.debug("{}", principal.getClass());
		}
		//사용자에 따른 첫 페이지 정할수 있겠다..
		setDefaultTargetUrl("/index.do");
		
        super.onAuthenticationSuccess(request, response, authentication);
    }
}