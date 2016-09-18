package io.github.xeyez.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;

/*@Controller
@RequestMapping("/sec")*/
public class SecurityController {
	
	private static final Logger logger = LoggerFactory.getLogger(SecurityController.class);
	
	@RequestMapping("/index")
	public void index() {
		logger.info("=========== index");
	}
	
	@RequestMapping("/all")
	public void all() {
		logger.info("=========== all");
	}
	
	@RequestMapping("/manager")
	public void manager() {
		logger.info("=========== manager");
	}
	
	@RequestMapping("/admin")
	public void admin() {
		logger.info("=========== admin");
	}
	
	@RequestMapping("/member")
	public void member() {
		logger.info("=========== member");
	}
	
	@RequestMapping("/denied")
	public void denied() {
		logger.info("=========== denied");
	}
	
	@RequestMapping("/user/loginform")
	public void loginform() {
		logger.info("=========== loginform");
	}
}
