package io.github.xeyez.security;

import java.util.Collection;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {
	private static final Logger logger = LoggerFactory.getLogger(CustomAuthenticationProvider.class);
	
	@Inject
	private CustomUserDetailsService userDetailsService;

	private PasswordEncoder passwordEncoder;
	
	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

	@Override
	public Authentication authenticate(Authentication auth) throws AuthenticationException {
		String userid = auth.getName();
		String userpw = (String) auth.getCredentials();
		
		UserDetails principal = userDetailsService.loadUserByUsername(userid);
		
		logger.info("id from login :" + userid);
		logger.info("password from login :" + userpw.toLowerCase());
		logger.info("possword from DB : " + principal.getPassword());
		
		
		if(principal == null || !principal.getUsername().equalsIgnoreCase(userid))
			throw new UsernameNotFoundException("Username not found.");
		
		/*if (!userpw.equals(principal.getPassword()))
			throw new BadCredentialsException("Wrong password.");*/
				
		// 첫 번째 parameter가 평문(로그인시 전달), 두 번째 Parameter가 암호문(DB에서 전달)
		if(!passwordEncoder.matches(userpw.toLowerCase(), principal.getPassword())) {
			throw new BadCredentialsException("Wrong password.");
		}
		
		
		Collection<? extends GrantedAuthority> authorities = principal.getAuthorities();
		
		return new UsernamePasswordAuthenticationToken(principal, null, authorities);
	}

	@Override
	public boolean supports(Class<?> paramClass) {
		return true;
	}
}
