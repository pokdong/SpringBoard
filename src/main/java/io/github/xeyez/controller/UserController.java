package io.github.xeyez.controller;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.github.xeyez.domain.ModifiedUserVO;
import io.github.xeyez.domain.UserVO;
import io.github.xeyez.security.CustomUserDetailsService;
import io.github.xeyez.security.CustomUserDetailsServiceImpl;
import io.github.xeyez.security.ModifiedUserValidator;

@Controller
@RequestMapping("/user")
public class UserController {
	
	private static final Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Inject
	private CustomUserDetailsService userService;
	
	@Inject
	private MessageSource messageSource;
	
	@RequestMapping("/login")
	public void login() {
		logger.info("=========== login");
	}
	
	@RequestMapping(value = "/profile", method = RequestMethod.GET)
	public void profile(Model model, Authentication auth) throws Exception {
		logger.info("=========== profile / " + auth.getName());
		
		if(auth != null && auth.isAuthenticated()) {
			model.addAttribute("authUser", userService.getUser(auth.getName()));
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "/profile", method = RequestMethod.PATCH)
	public ResponseEntity<Map<String, String>> profile(@RequestBody ModifiedUserVO vo, Errors errors, Authentication auth) {
		
		logger.info(vo.getUsername() + "/" + vo.getUserpw() + "/" + vo.getUserpw_new() + "/" + vo.getProfilepath());
		
		ResponseEntity<Map<String, String>> entity = null;

		Map<String, String> paramMap = new HashMap<>();
		
		try {
			String username = vo.getUsername();
			
			//비밀번호 검증을 위해 권한 객체를 이용하여 ID 얻음.
			vo.setUserid(auth.getName());
			if(userService.userNameExists(vo.getUserid(), username))
				errors.rejectValue("username", "duplicate");
			
			new ModifiedUserValidator().validate(vo, errors);

			if(!isMatchesPassword(vo)) {
				errors.rejectValue("confirm", "notCorrect");
			}
			
			//admin, manager 권한 제외하고 닉네임을 admin 혹은 manager로 지정할 때
			for(GrantedAuthority gAuth : auth.getAuthorities()) {
				if(!gAuth.getAuthority().equals("ADMIN") && !gAuth.getAuthority().equals("MANAGER")) {
					logger.info("gAuth : " + gAuth.getAuthority());
					
					if(username.contains("admin") || username.contains("manager")) {
						errors.rejectValue("userid", "unavailable");
						break;
					}
				}
			}
			
			
			
			if(!errors.hasErrors()) {
				
				// Update
				userService.updateInfo(vo);
				
				
				paramMap.put("result", "SUCCESS");
				entity = new ResponseEntity<>(paramMap, HttpStatus.OK);
			}
			else {
				paramMap.put("result", "ERROR");
				
				for (ObjectError objError : errors.getAllErrors()) {
				    if(objError instanceof FieldError) {
				        FieldError fieldError = (FieldError) objError;
				        
				        // Use null as second parameter if you do not use i18n (internationalization)
				        String message = messageSource.getMessage(fieldError, null);
				        
				        logger.info(fieldError.getField() + " / " + message);
				        paramMap.put(fieldError.getField(), message);
				    }
				}
				
				entity = new ResponseEntity<>(paramMap, HttpStatus.OK);
			}
		} catch (Exception e) {
			e.printStackTrace();
			paramMap.put("result", e.getMessage());
			entity = new ResponseEntity<>(paramMap, HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	// 로그인 ID 존재 여부 및 비밀번호 확인
	// 회원 탈퇴 이전 비밀번호 확인
	@ResponseBody
	@RequestMapping(value = "/confirmPassword", method = RequestMethod.POST)
	public ResponseEntity<String> confirmPassword(@RequestBody UserVO vo) {

		logger.info(vo.getUserid() + " / " + vo.getUserpw());
		
		ResponseEntity<String> entity = null;

		try {
			if(!isMatchesPassword(vo))
				entity = new ResponseEntity<>("FAIL", HttpStatus.OK);
			else
				entity = new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} catch (Exception e) {
			entity = new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	private boolean isMatchesPassword(UserVO vo) throws Exception {
		CustomUserDetailsServiceImpl customService = (CustomUserDetailsServiceImpl) userService;
		UserDetails userDetails = customService.loadUserByUsername(vo.getUserid());
		return customService.getPasswordEncoder().matches(vo.getUserpw(), userDetails.getPassword());
	}
	
	// 회원 탈퇴 이전 비밀번호 확인 후 탈퇴.
	@RequestMapping(value = "/withdrawal", method = RequestMethod.POST)
	public String withdrawal(UserVO vo) throws Exception {
		logger.info("========= withdrawal : " + vo.getUserid());
		
		userService.withdrawal(vo.getUserid());
		
		return "redirect:/user/logout";
	}
	
	@RequestMapping("/accessdenied")
	public String accessDenied(RedirectAttributes rttr) {
		rttr.addFlashAttribute("auth", "error");
		return "redirect:/board/list";
	}
}
