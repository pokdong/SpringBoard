package io.github.xeyez.security;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import io.github.xeyez.domain.NewUserVO;

public class NewUserValidator implements Validator {
	
	@Override
	public boolean supports(Class<?> clazz) {
		return NewUserVO.class.isAssignableFrom(clazz);
	}

	@Override
	public void validate(Object target, Errors errors) {
		//System.out.println("======================== requiredFieldMessage : " + requiredFieldMessage);
		
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "userid", "required", "필수 항목");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "userpw", "required", "필수 항목");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "confirm", "required", "필수 항목");
		
		NewUserVO newUser = (NewUserVO) target;
		if (!newUser.isPasswordAndConfirmSame())
			errors.rejectValue("confirm", "notSame");
	}

}
