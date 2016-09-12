package io.github.xeyez.security;

import org.springframework.security.core.userdetails.UserDetailsService;

import io.github.xeyez.domain.UserVO;

public interface CustomUserDetailsService extends UserDetailsService {
	
	public abstract void signUp(UserVO vo) throws Exception;

	public abstract void updateInfo(UserVO vo) throws Exception;

	public abstract void withdrawal(String userid) throws Exception;

	public abstract void changePassword(String userid, String userpw) throws Exception;

	public abstract boolean userExists(String userid) throws Exception;
}
