package io.github.xeyez.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import io.github.xeyez.domain.NewUserVO;
import io.github.xeyez.security.CustomUserDetailsService;
import io.github.xeyez.security.NewUserValidator;
import io.github.xeyez.security.UnavailableIDException;

@Controller
@RequestMapping("/sec/user/join")
public class JoinController {
	private static final Logger logger = LoggerFactory.getLogger(JoinController.class);
	
	public static final String USER_JOIN_SUCCESS = "sec/user/joinsuccess";
	public static final String USER_JOIN_FORM = "sec/user/joinform";

	//private UserJoinService userJoinService;
	
	@Inject
	private CustomUserDetailsService userJoinService;
	
	
	@ModelAttribute("newUser")
	public NewUserVO formBacking() {
		logger.info("============== formBacking()");
		
		return new NewUserVO();
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public String form() {
		logger.info("============== form()");
		
		return USER_JOIN_FORM;
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public String submit(@ModelAttribute("newUser") NewUserVO newUser, Errors errors) throws Exception {
		logger.info("============== submit()");

		//joinform.jsp의 form:form Tag와 연동.
		//errors가 스프링에 의해 객체가 만들어지고
		
		//입력 값 검증
		new NewUserValidator().validate(newUser, errors);
		
		//계속 참조되어 전달됨.
		
		if (errors.hasErrors())
			return USER_JOIN_FORM;
		
		try {
			// 가입(생성) 처리
			userJoinService.signUp(newUser);
			
			return USER_JOIN_SUCCESS;
		} catch (DuplicateKeyException e) {
			errors.rejectValue("userid", "duplicate");
			return USER_JOIN_FORM;
		} catch (UnavailableIDException e) {
			errors.rejectValue("userid", "unavailable");
			return USER_JOIN_FORM;
		}
	}
	
}