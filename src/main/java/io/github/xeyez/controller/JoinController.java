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

import io.github.xeyez.user.NewUser;
import io.github.xeyez.user.NewUserValidator;
import io.github.xeyez.user.UserJoinService;

@Controller
@RequestMapping("/sec/user/join")
public class JoinController {
	private static final Logger logger = LoggerFactory.getLogger(JoinController.class);
	
	public static final String USER_JOIN_SUCCESS = "user/joinsuccess";
	public static final String USER_JOIN_FORM = "user/joinform";
	
	@Inject
	private UserJoinService userJoinService;
	
	@ModelAttribute("newUser")
	public NewUser formBacking() {
		logger.info("============== formBacking()");
		
		return new NewUser();
	}

	@RequestMapping(method = RequestMethod.GET)
	public String form() {
		logger.info("============== form()");
		
		return USER_JOIN_FORM;
	}

	@RequestMapping(method = RequestMethod.POST)
	public String submit(@ModelAttribute("newUser") NewUser newUser, Errors errors) {
		logger.info("============== submit()");
		
		new NewUserValidator().validate(newUser, errors);
		if (errors.hasErrors())
			return USER_JOIN_FORM;
		
		try {
			if(newUser == null)
				throw new NullPointerException("newUser is NULL!!");
			else
				logger.info(">>>>>>>>>>>>>>>>>" + newUser.toString());
			
			userJoinService.join(newUser);
			return USER_JOIN_SUCCESS;
		} catch (DuplicateKeyException ex) {
			errors.rejectValue("name", "duplicate");
			return USER_JOIN_FORM;
		}
	}
}