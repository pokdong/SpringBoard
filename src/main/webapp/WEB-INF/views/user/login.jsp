<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="../include/header-user.jsp"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="returl"	value="${fn:replace(pageContext.request.queryString, 'returl=', '')}" />


<c:if test="${message == 'SIGNUP_ADMIN_SUCCESS'}">
	<div class="signup-result-message">관리자(admin)님 환영합니다! 로그인 하세요.</div>
</c:if>

<c:if test="${message == 'SIGNUP_SUCCESS'}">
	<div class="signup-result-message">회원가입이 완료되었습니다. 로그인 하세요.</div>
</c:if>


<div class="form-user card">
	<div class="card-content blue white-text">
		<span class="card-title">Login</span>
	</div>

	<div class="card-content">
		<form id="form_login" action="<c:url value='/user/login_processing'/>" method="post">
			<input type="hidden" name="returl" value="${returl}">
			
			<div class="input-field">
		      	<input type="text" id="userid" name="userid" class="validate">
		      	<label for="userid">ID</label>
		    </div>
		    
		    <div class="input-field">
		      	<input type="password" id="userpw" name="userpw" class="validate">
		      	<label for="userpw">Password</label>
		      
		      	<div class="formError"></div>
		    </div>
		    
		    <button type="button" id="btn_check" class="waves-effect waves-light btn blue white-text full-width">Login</button>
		    
		    <div class="margin-top-15px">
				<input type="checkbox" class="filled-in" id="remember_me" name="_spring_security_remember_me" />
		      	<label for="remember_me">Remeber me!</label>
			</div>
		</form>
	</div>
	
	<div class="card-action center-align">
		<a href="/user/signup" class="blue-text">Sign-up</a>
	</div>
</div>


<script>
	$( document ).ready(function(){
		var formObj = $('#form_login');
		var userpwObj = formObj.find('input[name=userpw]');
		
		// 사용자 유무, 비밀번호를 AJAX로 검증 후 전송
		// 뒤로 가기 페이지 없애기 위함.
		$('#btn_check').on('click', function() {
			var formErrorObj = $('.formError');
			
			var userid = formObj.find('input[name=userid]').val();
			var userpw = userpwObj.val();
		
			$.ajax({
				type : "POST",
				url : "/user/confirmPassword",
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
				},
				data : JSON.stringify({
					userid : userid,
					userpw : userpw
				}),
				dataType : "text",
				success : function(response) {
					var responseArray = JSON.parse(response);
					formErrorObj.text(responseArray[1]);
					
					if(responseArray[0] === 'SUCCESS')
						formObj.submit();
				},
				error : function(request, status, error) {
					formErrorObj.text(JSON.parse(request.responseText)[1]);
				}
			});
		});
		
		//enter 동작하도록 설정
		userpwObj.on('keyup', function(event) {
			event.preventDefault();
			if (event.keyCode == 13) {
				$('#btn_check').trigger('click');
			}
		});
	});
</script>

<%@include file="../include/footer-user.jsp"%>