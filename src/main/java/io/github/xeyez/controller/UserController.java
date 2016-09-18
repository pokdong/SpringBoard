package io.github.xeyez.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import io.github.xeyez.domain.UserVO;
import io.github.xeyez.security.CustomUserDetailsService;
import io.github.xeyez.security.CustomUserDetailsServiceImpl;

@Controller
@RequestMapping("/user")
public class UserController {
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Inject
	private CustomUserDetailsService userDetailsService;
	
	@RequestMapping("/login")
	public void login() {
		logger.info("=========== login");
	}
	
	@RequestMapping("/profile")
	public void profile() {
		logger.info("=========== profile");
	}
	
	// 회원 탈퇴 이전 비밀번호 확인
	@ResponseBody
	@RequestMapping("/confirmPassword")
	public ResponseEntity<String> confirmPassword(@RequestBody UserVO vo) {

		CustomUserDetailsServiceImpl customService = (CustomUserDetailsServiceImpl) userDetailsService;
		
		logger.info(vo.getUserid() + " / " + vo.getUserpw());
		
		ResponseEntity<String> entity = null;

		try {
			UserDetails userDetails = customService.loadUserByUsername(vo.getUserid());

			if(!customService.getPasswordEncoder().matches(vo.getUserpw(), userDetails.getPassword()))
				entity = new ResponseEntity<>("FAIL", HttpStatus.OK);
			else
				entity = new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} catch (Exception e) {
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	// 회원 탈퇴 이전 비밀번호 확인 후 탈퇴.
	@RequestMapping(value = "/withdrawal", method = RequestMethod.POST)
	public String withdrawal(UserVO vo) throws Exception {
		logger.info("========= withdrawal : " + vo.getUserid());
		
		userDetailsService.withdrawal(vo.getUserid());
		
		return "redirect:/user/logout";
	}
}
