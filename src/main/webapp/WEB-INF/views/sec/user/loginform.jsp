<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    </style>
    
  </head>
  <body class="login-page">
    <div class="login-box">
      <div class="login-logo">
        <a href="/board/list"><b>Spring</b>Board</a>
      </div><!-- /.login-logo -->
      <div class="login-box-body">
        <!-- <p class="login-box-msg">Sign in to start your session</p> -->

<form action="<c:url value='/sec/user/login'/>" method="post">
  <div class="form-group has-feedback">
    <input type="text" name="userid" class="form-control" placeholder="USER ID"/>
    <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
  </div>
  
  <div class="form-group has-feedback">
    <input type="password" name="password" class="form-control" placeholder="Password"/>
    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
    
    <c:if test="${param.error == 'true'}">
		<div class="formError">
	    	아이디와 암호가 일치하지 않습니다.
	    </div>
  	</c:if>
  </div>
  
  <div class="row">
    <div class="col-xs-8">    
      <div class="checkbox icheck">
        <label>
          <input type="checkbox" id = "remember_me" name ="_spring_security_remember_me" > 로그인 상태 유지
        </label>
      </div>                        
    </div><!-- /.col -->
    <div class="col-xs-4">
      <button type="submit" class="btn btn-primary btn-block btn-flat">로그인</button>
    </div><!-- /.col -->
  </div>
</form>


        <!-- <a href="#">비밀번호 찾기</a><br> -->
        <a href="/sec/user/join" class="text-center">회원 가입</a>

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
      });
    </script>
  </body>
</html>