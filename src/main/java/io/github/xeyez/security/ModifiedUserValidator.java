package io.github.xeyez.security;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import io.github.xeyez.domain.ModifiedUserVO;
import io.github.xeyez.domain.NewUserVO;

public class ModifiedUserValidator implements Validator {
	
	@Override
	public boolean supports(Class<?> clazz) {
		return NewUserVO.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "username", "required", "필수 항목");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "userpw", "required", "필수 항목");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "confirm", "required", "필수 항목");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "userpw_new", "required", "필수 항목");
		
		ModifiedUserVO modUser = (ModifiedUserVO) target;
		if(!errors.hasErrors()) {
			if (!modUser.isPasswordAndConfirmSame())
				errors.rejectValue("confirm", "notSame");
			else if(!modUser.isPasswordGreaterThanMinLength())
				errors.rejectValue("confirm", "pwLength");
			
			if(!modUser.isNewPasswordGreaterThanMinLength())
				errors.rejectValue("userpw_new", "pwLength");
		}
	}

}
