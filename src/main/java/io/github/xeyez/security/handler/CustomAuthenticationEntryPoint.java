package io.github.xeyez.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.util.UrlUtils;

public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {

	private Logger logger = LoggerFactory.getLogger(CustomAuthenticationEntryPoint.class);
	
	private String loginPath;
	
	public void setLoginPath(String loginPath) {
		this.loginPath = loginPath;
	}

	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authenticationException) 
			throws IOException, ServletException {
		
		String redirectUrl = UrlUtils.buildFullRequestUrl(request);
		String encoded = response.encodeRedirectURL(redirectUrl);
		String fullUrl = request.getContextPath() + loginPath + "?returl=" + encoded;
		
		logger.info(redirectUrl + " /// " + encoded);
		
		logger.info("####### entryPoint : " + fullUrl);
		
		response.sendRedirect(fullUrl);
	}
}