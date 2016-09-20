package io.github.xeyez.persistence;

import io.github.xeyez.domain.UserVO;

public interface UserDAO {

	UserVO getUser(String userid) throws Exception;
	
	void createUser(UserVO userVO) throws Exception;
	
	void updateUser(UserVO userVO) throws Exception;
	
	void changeRole(String userid, String role) throws Exception;
	
	void deleteUser(String userid)  throws Exception;
	
	void changePassword(String userid, String userpw) throws Exception;
	
	boolean userIdExists(String userid) throws Exception;
	
	boolean userNameExists(String userid, String username) throws Exception;
}
