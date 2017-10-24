package io.github.xeyez.controller;

import java.util.Locale;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import io.github.xeyez.security.CustomUserDetailsService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Inject
	private CustomUserDetailsService userService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		return "redirect:/board/list";
	}
	
	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public void admin(Model model) throws Exception {
		model.addAttribute("adminExists", userService.userIdExists("admin"));
	}

	//권한 제어가 처리됨.
	@RequestMapping(value = "/admin_config", method = RequestMethod.GET)
	public void admin_config(Model model, Authentication auth) throws Exception {
		model.addAttribute("authUser",  userService.getUser(auth.getName()));
	}
}