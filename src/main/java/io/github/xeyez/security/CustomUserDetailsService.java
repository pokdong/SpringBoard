package io.github.xeyez.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetailsService;

import io.github.xeyez.domain.UserVO;

public interface CustomUserDetailsService extends UserDetailsService {

	void signUp(UserVO vo) throws Exception;

	void updateInfo(UserVO vo) throws Exception;

	void withdrawal(String userid) throws Exception;

	void changePassword(String userid, String userpw) throws Exception;

	boolean userExists(String userid) throws Exception;
	
	UserVO getUser(String userId) throws Exception;
	
	boolean hasAuthority(String writer, Authentication auth);
}
