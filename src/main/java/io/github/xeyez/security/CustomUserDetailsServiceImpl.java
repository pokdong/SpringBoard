package io.github.xeyez.security;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.xeyez.domain.UserVO;
import io.github.xeyez.persistence.UserDAO;

@Service
public class CustomUserDetailsServiceImpl implements CustomUserDetailsService {

	private static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsServiceImpl.class);

	private PasswordEncoder passwordEncoder;
	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}
	
	@Inject
	private UserDAO dao;

	@Override
	public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {

		try {
			UserVO vo;
			vo = dao.getUser(userId);
			if(vo == null)
				throw new UsernameNotFoundException(userId);

			logger.info("UserServiceImpl.loadUserByUsername() : " + vo.toString());
			
			/* Table 1개로 권한을 하나밖에 사용하지 않음. */
			List<GrantedAuthority> auth = new ArrayList<>();
			auth.add(new SimpleGrantedAuthority(vo.getRole()));
			
			logger.info(">>>>> vo.getUserpw() : " + vo.getUserpw());
			
			return new User(userId, vo.getUserpw(), auth);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

	@Transactional
	@Override
	public void signUp(UserVO vo) throws Exception {
		
		logger.info(vo.toString());
		
		logger.info("PasswordEncoder is NULL??? " + (passwordEncoder == null));
		
		String id = vo.getUserid();
		//String pw = vo.getUserpw();
		String pw = passwordEncoder.encode(vo.getUserpw().toLowerCase());
		
		logger.info("encoded Password : " + pw);
		
		
		if(id == null || id.isEmpty())
			throw new NullPointerException("ID is null or empty.");
		else if(pw == null || pw.isEmpty())
			throw new NullPointerException("Password is null or empty.");
		
		if(id.contains("admin") || id.contains("manager"))
			throw new UnavailableIDException(id);
		
		if(dao.userExists(id))
			throw new DuplicateKeyException(id);
		
		
		vo.setUsername(id); // default : id
		vo.setUserpw(pw); // 암호화된 Password 삽입
		vo.setRole("USER"); // 기본 ROLE
		
		dao.createUser(vo);
	}

	@Transactional
	@Override
	public void updateInfo(UserVO vo) throws Exception {
		
		logger.info(vo.toString());
		
		String id = vo.getUserid();
		//String pw = vo.getUserpw();
		String pw = passwordEncoder.encode(vo.getUserpw().toLowerCase());
		String username = vo.getUsername();
		
		if(id == null || id.isEmpty())
			throw new NullPointerException("ID is null or empty.");
		else if(pw == null || pw.isEmpty())
			throw new NullPointerException("Password is null or empty.");
		else if(username == null || username.isEmpty())
			throw new NullPointerException("Username is null or empty.");
		
		if(id.contains("admin"))
			throw new UnavailableIDException("\"admin\"은 포함될 수 없습니다.");
		if(id.contains("manager"))
			throw new UnavailableIDException("\"manager\"는 포함될 수 없습니다.");
		else if (!id.matches("[0-9|a-z|A-Z]*"))
			throw new UnavailableIDException("영문 대소문자 및 숫자 외에 다른 문자는 포함될 수 없습니다.");
		
		vo.setUserpw(pw); // 암호화된 Password 삽입
		dao.updateUser(vo);
	}

	@Transactional
	@Override
	public void withdrawal(String userid) throws Exception {
		if(userid == null || userid.isEmpty())
			throw new NullPointerException("ID is null or empty.");
		
		dao.deleteUser(userid);
	}

	@Transactional
	@Override
	public void changePassword(String userid, String userpw) throws Exception {
		String id = userid;
		//String pw = vo.getUserpw();
		String pw = passwordEncoder.encode(userpw.toLowerCase());
		
		if(id == null || id.isEmpty())
			throw new NullPointerException("ID is null or empty.");
		else if(pw == null || pw.isEmpty())
			throw new NullPointerException("Password is null or empty.");
		
		dao.changePassword(userid, userpw);
	}

	@Override
	public boolean userExists(String userid) throws Exception {
		if(userid == null || userid.isEmpty())
			throw new NullPointerException("ID is null or empty.");
		
		return dao.userExists(userid);
	}

}
