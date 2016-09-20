package io.github.xeyez.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

	private Logger logger = LoggerFactory.getLogger(CustomAuthenticationSuccessHandler.class);
	
	private String defaultTargetUrl;
	
	/*@Inject
	private CustomUserDetailsService userService;*/
	
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	
	public void setDefaultTargetUrl(String defaultTargetUrl) {
		this.defaultTargetUrl = defaultTargetUrl;
	}

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request,	HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		
		//clearAuthenticationAttributes(request);
		
		String retUrl = request.getParameter("returl");
		logger.info("####### SUCCESS / returl : " + retUrl);
		
		String redirectUrl = retUrl != null && !retUrl.trim().isEmpty() ? retUrl : defaultTargetUrl;
		logger.info("####### SUCCESS / redirectUrl : " + redirectUrl);
		
		//response.sendRedirect(redirectUrl);
		
		/*try {
			logger.info("set session");
			request.getSession().setAttribute("authUser", userService.getUser(authentication.getName()));
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		
		redirectStrategy.sendRedirect(request, response, redirectUrl);
	}

	private void clearAuthenticationAttributes(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if(session == null)
			return;
		
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
		session.invalidate();
	}
}