package io.github.xeyez.security;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.xeyez.domain.ModifiedUserVO;
import io.github.xeyez.domain.NewUserVO;
import io.github.xeyez.domain.UserVO;
import io.github.xeyez.persistence.UserDAO;

@Service
public class CustomUserDetailsServiceImpl implements CustomUserDetailsService {
	
	public enum Role {
		ADMIN, MANAGER, USER;
	}
	
	private static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsServiceImpl.class);

	@Inject
	private PasswordEncoder passwordEncoder;

	// 회원탈퇴할 때 암호화된 문자열 비교시 사용
	public PasswordEncoder getPasswordEncoder() {
		return passwordEncoder;
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
	public void signUp(NewUserVO vo) throws Exception {
		
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
		
		if(dao.userIdExists("admin") && id.toLowerCase().contains("admin"))
			throw new UnavailableIDException(id);
		
		if(dao.userIdExists(id))
			throw new DuplicateKeyException(id);
		
		
		vo.setUsername(id); // default : id
		vo.setUserpw(pw); // 암호화된 Password 삽입
		
		// 첫 ADMIN 가입시. 이외는 Default "USER"
		vo.setRole(!vo.isAdminExists() ? Role.ADMIN.name() : Role.USER.name());
		
		dao.createUser(vo);
	}

	@Transactional
	@Override
	public void updateInfo(ModifiedUserVO vo) throws Exception {
		
		logger.info(vo.toString());
		
		//String pw = vo.getUserpw();
		String pw = passwordEncoder.encode(vo.getUserpw_new().toLowerCase());
		String username = vo.getUsername().trim();
		
		if(pw == null || pw.isEmpty())
			throw new NullPointerException("Password is null or empty.");
		else if(username == null || username.isEmpty())
			throw new NullPointerException("Username is null or empty.");
		
		vo.setUserpw(pw); // 암호화된 Password 삽입
		dao.updateUser(vo);
	}
	
	@Override
	public void changeRole(String userid, Role role) throws Exception {
		dao.changeRole(userid, role.name());
	}

	@Transactional
	@Override
	public void withdrawal(String userid) throws Exception {
		if(userid == null || userid.isEmpty())
			throw new NullPointerException("ID is null or empty.");
		
		//삭제 하지 않고, 탈퇴시켜 같은 ID로 가입시키지 못하게 함.
		//dao.deleteUser(userid);
		dao.withdrawal(userid);
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
	public boolean userIdExists(String userid) throws Exception {
		/*if(userid == null || userid.isEmpty())
			throw new NullPointerException("ID is null or empty.");*/
		
		return dao.userIdExists(userid);
	}

	@Override
	public UserVO getUser(String userId) throws Exception {
		UserVO vo;
		vo = dao.getUser(userId);
		if(vo == null)
			throw new UsernameNotFoundException(userId);
		
		return vo;
	}

	@Override
	public boolean hasAuthority(String writer, Authentication auth) {
		boolean isAdmin = false;
		@SuppressWarnings("unchecked")
		List<GrantedAuthority> authList = (List<GrantedAuthority>) auth.getAuthorities();
		for(GrantedAuthority gAuth : authList) {
			if(gAuth.getAuthority().equals("ADMIN")) {
				isAdmin = true;
				break;
			}
		}
		
		logger.info("isAdmin : " + isAdmin);
		
		// 로그인한 id와 작성자가가 같은 지 비교 (단, 예외로 admin은 허용)
		return auth.getName().equals(writer) || isAdmin;
	}

	@Override
	public boolean userNameExists(String userid, String username) throws Exception {
		return dao.userNameExists(userid, username);
	}

	@Override
	public void deactive(boolean isDeactive, String userid, Date deactiveDate) {
		dao.deactiveUser(isDeactive, userid, deactiveDate);
	}

	@Override
	public boolean isWithdrawal(String userid) throws Exception {
		return dao.isWithdrawal(userid);
	}
}
