package io.github.xeyez.security;

import java.util.Date;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetailsService;

import io.github.xeyez.domain.ModifiedUserVO;
import io.github.xeyez.domain.NewUserVO;
import io.github.xeyez.domain.UserVO;
import io.github.xeyez.security.CustomUserDetailsServiceImpl.Role;

public interface CustomUserDetailsService extends UserDetailsService {

	void signUp(NewUserVO vo) throws Exception;

	void updateInfo(ModifiedUserVO vo) throws Exception;
	
	void changeRole(String userid, Role role) throws Exception;

	void withdrawal(String userid) throws Exception;

	void changePassword(String userid, String userpw) throws Exception;

	boolean userIdExists(String userid) throws Exception;
	
	UserVO getUser(String userId) throws Exception;
	
	boolean hasAuthority(String writer, Authentication auth) throws Exception;

	boolean userNameExists(String userid, String username) throws Exception;
	
	void deactive(boolean isDeactive, String userid, Date deactiveDate);
	
	boolean isWithdrawal(String userid) throws Exception;
}
