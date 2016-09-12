package io.github.xeyez.user;

import java.util.Arrays;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class UserJoinService {
	private UserDetailsManager userDetailsManager;
	private PasswordEncoder passwordEncoder;

	public void setUserDetailsManager(UserDetailsManager userDetailsManager) {
		this.userDetailsManager = userDetailsManager;
	}
	
	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

	@Transactional
	public void join(NewUser newUser) {
		String id = newUser.getName();
		if(id.contains("admin"))
			throw new UnavailableIDException("\"admin\"은 포함될 수 없습니다.");
		if(id.contains("manager"))
			throw new UnavailableIDException("\"manager\"는 포함될 수 없습니다.");
		else if (!id.matches("[0-9|a-z|A-Z]*"))
			throw new UnavailableIDException("영문 대소문자 및 숫자 외에 다른 문자는 포함될 수 없습니다.");
		
		
		String encodedPassword = passwordEncoder.encode(newUser.getPassword());
		
		UserDetails user = new User(id, encodedPassword,
				Arrays.asList(new SimpleGrantedAuthority("USER")));
		
		try {
			userDetailsManager.createUser(user);
		} catch (DuplicateKeyException ex) {
			throw new DuplicateKeyException(String.format("Username [%s] is aleady exists", newUser.getName()), ex);
		}
	}
}
