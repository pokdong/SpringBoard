<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="returl" value="${fn:replace(pageContext.request.queryString, 'returl=', '')}" />

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Sign in</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <!-- Bootstrap 3.3.4 -->
    <link href="/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <!-- Font Awesome Icons -->
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <!-- Theme style -->
    <link href="/resources/dist/css/AdminLTE.min.css" rel="stylesheet" type="text/css" />
    <!-- iCheck -->
    <link href="/resources/plugins/iCheck/square/blue.css" rel="stylesheet" type="text/css" />

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    
    <style>
    	div .formError {
    		text-align: right;
    		font-size: smaller;
    		color: red;
    	}
    	
    	div .message {
    		text-align: center;
    		font-size: smaller;
    		font-weight: bold;
    		color: red;
    		margin-bottom: 15px;
    	}
    </style>
    
  </head>
  <body class="login-page">
    <div class="login-box">
      <div class="login-logo">
        <a href="/board/list"><b>Spring</b>Board</a>
      </div><!-- /.login-logo -->
      <div class="login-box-body">
        <!-- <p class="login-box-msg">Sign in to start your session</p> -->


<c:if test="${message == 'SIGNUP_ADMIN_SUCCESS'}">
	<div class="message">
		관리자(admin)님 환영합니다! 로그인 하세요.
	</div>
</c:if>

<c:if test="${message == 'SIGNUP_SUCCESS'}">
	<div class="message">
		회원가입이 완료되었습니다. 로그인 하세요.
	</div>
</c:if>

<form id="form_login" action="<c:url value='/user/login_processing'/>" method="post">
	<input type="hidden" name="returl" value="${returl}">

  <div class="form-group has-feedback">
    <input type="text" name="userid" class="form-control" placeholder="USER ID"/>
    <span class="glyphicon glyphicon-user form-control-feedback"></span>
  </div>
  
  <div class="form-group has-feedback">
    <input type="password" name="userpw" class="form-control" placeholder="Password"/>
    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
    
	<div class="formError">
    </div>
  </div>
  
  <div class="row">
    <div class="col-xs-8">    
      <div class="checkbox icheck">
        <label>
          <input type="checkbox" id="remember_me" name="_spring_security_remember_me" > 로그인 상태 유지
        </label>
      </div>                        
    </div><!-- /.col -->
    <div class="col-xs-4">
      <button type="button" id="btn_check" class="btn btn-primary btn-block btn-flat">로그인</button>
    </div><!-- /.col -->
  </div>
</form>


        <!-- <a href="#">비밀번호 찾기</a><br> -->
        <a href="/user/signup" class="text-center">회원 가입</a>

      </div><!-- /.login-box-body -->
    </div><!-- /.login-box -->

    <!-- jQuery 2.1.4 -->
    <script src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- Bootstrap 3.3.2 JS -->
    <script src="/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <!-- iCheck -->
    <script src="/resources/plugins/iCheck/icheck.min.js" type="text/javascript"></script>
    <script>
      $(function () {
	        $('input').iCheck({
	          checkboxClass: 'icheckbox_square-blue',
	          radioClass: 'iradio_square-blue',
	          increaseArea: '20%' // optional
	        });
	        
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
						
						switch (response) {
							case 'SUCCESS':
								formErrorObj.text('');
								formObj.submit();
								break;
								
							case 'FAIL':
								formErrorObj.text('비밀번호가 일치하지 않습니다.');
								break;
						}
					},
					error : function(request, status, error) {
						if(request.responseText == 'EMPTY')
							formErrorObj.text('공백은 허용되지 않습니다.');
						else
							formErrorObj.text('존재하지 않는 ID입니다.');
					}
				});
			});
	        
	        //enter 동작하도록 설정
	        userpwObj.on('keyup', function(event) {
				event.preventDefault();
				if(event.keyCode == 13) {
					$('#btn_check').trigger('click');
				}
			});
      });
    </script>
  </body>
</html>