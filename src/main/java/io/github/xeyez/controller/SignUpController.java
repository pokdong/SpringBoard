package io.github.xeyez.controller;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.github.xeyez.domain.NewUserVO;
import io.github.xeyez.security.CustomUserDetailsService;
import io.github.xeyez.security.NewUserValidator;

@Controller
@RequestMapping("/user/signup")
public class SignUpController {
	private static final Logger logger = LoggerFactory.getLogger(SignUpController.class);
	
	@Inject
	private CustomUserDetailsService userService;
	
	@Inject
	private MessageSource messageSource;
	
	@RequestMapping(value = "/validate", method = RequestMethod.POST)
	public ResponseEntity<Map<String, String>> signUpAjax(@RequestBody NewUserVO newUser, Errors errors) throws Exception {
		ResponseEntity<Map<String, String>> entity = null;
		
		Map<String, String> paramMap = new HashMap<>();
		
		try {
			logger.info(newUser.toString());
			
			if(userService.userIdExists(newUser.getUserid()))
				errors.rejectValue("userid", "duplicate");
			
			new NewUserValidator().validate(newUser, errors);
			
			
			if(!errors.hasErrors()) {
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
	
	@RequestMapping(value = "", method = RequestMethod.POST)
	public String submit(NewUserVO newUser, RedirectAttributes rttr) {
		try {
			userService.signUp(newUser);
			
			rttr.addFlashAttribute("message", "SIGNUP_SUCCESS");
			return "redirect:/user/login";
		} catch (Exception e) {
			e.printStackTrace();
			return "/user/signup";
		}
	}
}