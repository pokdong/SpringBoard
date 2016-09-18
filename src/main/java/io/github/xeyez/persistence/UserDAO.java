package io.github.xeyez.persistence;

import io.github.xeyez.domain.UserVO;

public interface UserDAO {

	UserVO getUser(String userid) throws Exception;
	
	void createUser(UserVO userVO);
	
	void updateUser(UserVO userVO);
	
	void deleteUser(String userid);
	
	void changePassword(String userid, String userpw);
	
	boolean userExists(String userid);
}
