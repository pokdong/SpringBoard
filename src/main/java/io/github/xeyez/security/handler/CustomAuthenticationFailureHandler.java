package io.github.xeyez.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {

	private Logger logger = LoggerFactory.getLogger(CustomAuthenticationFailureHandler.class);
	
	private String loginPath;
	
	public void setLoginPath(String loginPath) {
		this.loginPath = loginPath;
	}
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request,	HttpServletResponse response, AuthenticationException paramAuthenticationException)
			throws IOException, ServletException {
		
		logger.info("####### FAIL : " + loginPath);
		
		request.getRequestDispatcher(loginPath).forward(request, response);
	}
}