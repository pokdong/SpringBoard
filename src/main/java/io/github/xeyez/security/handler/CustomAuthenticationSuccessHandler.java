package io.github.xeyez.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

	private Logger logger = LoggerFactory.getLogger(CustomAuthenticationSuccessHandler.class);
	
	private String defaultTargetUrl;
	
	public void setDefaultTargetUrl(String defaultTargetUrl) {
		this.defaultTargetUrl = defaultTargetUrl;
	}

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request,	HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		String retUrl = request.getParameter("returl");
		logger.info("####### SUCCESS / returl : " + retUrl);
		
		String redirectUrl = retUrl != null && !retUrl.trim().isEmpty() ? retUrl : defaultTargetUrl;
		logger.info("####### SUCCESS / redirectUrl : " + redirectUrl);
		
		response.sendRedirect(redirectUrl);
	}
}