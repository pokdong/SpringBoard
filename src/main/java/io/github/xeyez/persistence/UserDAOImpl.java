package io.github.xeyez.persistence;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import io.github.xeyez.domain.UserVO;

@Repository
public class UserDAOImpl implements UserDAO {

	@Inject
	private SqlSession session;
		
	@Value("${mybatis.user}")
	private String namespace;
	
	@Override
	public UserVO getUser(String userid) throws Exception {
		return session.selectOne(namespace + ".getUser", userid);
	}
	
	@Override
	public List<UserVO> getUsers() throws Exception {
		return session.selectList(namespace + ".getUsers");
	}

	@Override
	public void createUser(UserVO userVO) {
		session.insert(namespace + ".createUser", userVO);
	}

	@Override
	public void updateUser(UserVO userVO) {
		if(userVO.getProfilepath() == null || userVO.getProfilepath().trim().isEmpty())
			session.update(namespace + ".updateUser", userVO);
		else
			session.update(namespace + ".updateUserWithProfile", userVO);
	}
	
	@Override
	public void changeRole(String userid, String role) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("userid", userid);
		paramMap.put("role", role);
		
		session.update(namespace + ".changeRole", paramMap);
	}

	@Override
	public void deleteUser(String userid) {
		session.delete(namespace + ".deleteUser", userid);
	}
	
	@Override
	public void withdrawal(String userid) throws Exception {
		session.update(namespace + ".withdrawal", userid);
	}

	@Override
	public void changePassword(String userid, String userpw) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("userid", userid);
		paramMap.put("userpw", userpw);
		
		session.update(namespace + ".changePassword", paramMap);
	}

	@Override
	public boolean userIdExists(String userid) {
		int count = session.selectOne(namespace + ".userIdExists", userid); 
		return count > 0;
	}

	@Override
	public boolean userNameExists(String userid, String username) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("userid", userid);
		paramMap.put("username", username);
		
		int count = session.selectOne(namespace + ".userNameExists", paramMap); 
		return count > 0;
	}

	@Override
	public void deactiveUser(boolean isDeactive, String userid, Date deactiveDate) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("isDeactive", isDeactive);
		paramMap.put("userid", userid);
		paramMap.put("deactiveDate", deactiveDate);
		
		session.update(namespace + ".deactiveUser", paramMap);
	}

	@Override
	public boolean isWithdrawal(String userid) throws Exception {
		int count = session.selectOne(namespace + ".isWithdrawal", userid);
		return count > 0;
	}
}
