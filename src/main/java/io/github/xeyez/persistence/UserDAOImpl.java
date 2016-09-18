package io.github.xeyez.persistence;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import io.github.xeyez.domain.UserVO;

@Repository
public class UserDAOImpl implements UserDAO {

	private static final Logger logger = Logger.getLogger(UserDAOImpl.class);
	
	@Inject
	private SqlSession session;
		
	@Value("${mybatis.user}")
	private String namespace;
	
	@Override
	public UserVO getUser(String userid) throws Exception {
		
		logger.info("-----------------------getUSER");
		
		return session.selectOne(namespace + ".getUser", userid);
		
	}

	@Override
	public void createUser(UserVO userVO) {
		session.insert(namespace + ".createUser", userVO);
	}

	@Override
	public void updateUser(UserVO userVO) {
		session.update(namespace + ".updateUser", userVO);
	}

	@Override
	public void deleteUser(String userid) {
		session.delete(namespace + ".deleteUser", userid);
	}

	@Override
	public void changePassword(String userid, String userpw) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("userid", userid);
		paramMap.put("userpw", userpw);
		
		session.update(namespace + ".changePassword", paramMap);
	}

	@Override
	public boolean userExists(String userid) {
		int count = session.selectOne(namespace + ".userExists", userid); 
		return count > 0;
	}

}
