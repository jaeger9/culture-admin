package kr.go.culture.login;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.PortResolverImpl;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.DefaultSavedRequest;
import org.springframework.security.web.savedrequest.SavedRequest;

public class AdminAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler   {
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
		
		SavedRequest savedRequest =  new DefaultSavedRequest(request, new PortResolverImpl());
		
		System.out.println("redirectUrl:" + savedRequest.getRedirectUrl());
		
		System.out.println("name:" + authentication.getName());
		System.out.println("detal:" + authentication.getDetails());
		System.out.println("detal:" + authentication.getAuthorities());
		
		System.out.println("OpadmAuthenticationSuccessHandler request URI:" + request.getRequestURI());
		
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		HttpSession session = request.getSession(true);
		
		// put the UserDetails object here.
		session.setAttribute("userDetails", principal);
		session.setAttribute("admin_id", authentication.getName());
		
		
		System.out.println("userDetails:" + session.getAttribute("userDetails"));
		System.out.println(principal.getClass());
		//사용자에 따른 첫 페이지 정할수 있겠다..
		setDefaultTargetUrl("/index.do");
		
        super.onAuthenticationSuccess(request, response, authentication);
    }
}