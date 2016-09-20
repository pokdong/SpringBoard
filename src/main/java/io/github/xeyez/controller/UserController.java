package io.github.xeyez.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.github.xeyez.domain.ModifiedUserVO;
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
	public void profile(Model model, Authentication auth) throws Exception {
		logger.info("=========== profile / " + auth.getName());
		
		UserVO userVO = userDetailsService.getUser(auth.getName());
		model.addAttribute(userVO);
	}
	
	public ResponseEntity<String> profile(@RequestBody ModifiedUserVO vo) {
		
		logger.info(vo.getUserid() + " / " + vo.getUserpw() + "/" + vo.getUserpw_new());
		
		ResponseEntity<String> entity = null;

		try {
			entity = new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} catch (Exception e) {
			entity = new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	// 로그인 ID 존재 여부 및 비밀번호 확인
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
			entity = new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	// 회원 탈퇴 이전 비밀번호 확인 후 탈퇴.
	@RequestMapping(value = "/withdrawal", method = RequestMethod.DELETE)
	public String withdrawal(UserVO vo) throws Exception {
		logger.info("========= withdrawal : " + vo.getUserid());
		
		userDetailsService.withdrawal(vo.getUserid());
		
		return "redirect:/user/logout";
	}
	
	@RequestMapping("/accessdenied")
	public String accessDenied(RedirectAttributes rttr) {
		rttr.addFlashAttribute("auth", "error");
		return "redirect:/board/list";
	}
}
