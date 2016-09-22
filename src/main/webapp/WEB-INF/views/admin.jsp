<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="hasRole('ADMIN')" var="isAdmin" />

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>ADMIN</title>
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
    
    <script src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    
<c:if test="${adminExists}">
    <script>
    	$(document).ready(function() {
    		
    		var userid_error = $('#userid_error');
			var userpw_error = $('#userpw_error');
			var confirm_error = $('#confirm_error');
    		
    		$('.btn-primary').on('click', function() {
    			userid_error.text('');
    			userpw_error.text('');
    			confirm_error.text('');
    			
    			var formObj = $('#from_info');
    			
    			var userid = formObj.find('input[name=userid]').val();
    			var userpw = formObj.find('input[name=userpw]').val();
    			var confirm = formObj.find('input[name=confirm]').val();
    			
    			//var span_test = $('#span_test');
    			
				$.ajax({
					type : "POST",
					url : "/user/signup/validate",
					headers : {
						"Content-Type" : "application/json",
						"X-HTTP-Method-Override" : "POST"
					},
					dataType : "text",
					data : JSON.stringify({
						userid : userid,
						userpw : userpw,
						confirm : confirm
					}),
					success : function(response) {
						var obj = JSON.parse(response);
						
						if(obj.result == 'SUCCESS') {
							formObj.submit();
						}
						else if(obj.result == 'ERROR') {
							
							$.each(obj, function(key, value) {
								switch (key) {
									case 'userid':
										userid_error.text(value);
										break;
										
									case 'userpw':
										userpw_error.text(value);
										break;
										
									case 'confirm':
										confirm_error.text(value);
										break;
								}
							});
						}
						
					},
					error : function(request, status, error) {
						alert("code : " + request.status + "\n" 
								+ "message : " + request.result.responseText + "\n" 
								+ "error : " + error);
					}
				});
			});
		});
    </script>
</c:if>

    
  </head>


  
<c:if test="${adminExists}">
	<c:if test="${isAdmin}">
		<jsp:forward page="/admin_config"/> 
	</c:if>
	
	<c:if test="${!isAdmin}">
		<!-- 로그인하지 않은 상태에서 접근시 -->
		<sec:authorize access="!isAuthenticated()">
			<script>
				self.location = '/user/login?returl=' + window.location.href;
			</script>
		</sec:authorize>
		
		<!-- 로그인했지만 admin이 아닐 시 -->
		<sec:authorize access="isAuthenticated()">
			<script>
				alert('권한이 없습니다.');
				self.location = '/board/list';
			</script>
		</sec:authorize>
	</c:if>
</c:if>
  
  
  
  <body class="login-page">
    <div class="login-box">
      <div class="login-logo">
        <a href="/board/list"><b>Admin</b></a>
      </div><!-- /.login-logo -->
      <div class="login-box-body">
        <!-- <p class="login-box-msg">Sign in to start your session</p> -->


<c:if test="${!adminExists}">
	<form id="from_info" action="/user/signup" method="post">
		<input type="hidden" value="${adminExists}" >
		
	  <div class="form-group has-feedback">
	    <input type="text" name="userid" class="form-control" placeholder="USER ID" value="admin" readonly="readonly" onfocus="this.blur()" />
	    <span class="glyphicon glyphicon-user form-control-feedback"></span>
	    
	    <div class="formError">
	    	<span id="userid_error"></span>
	    </div>
	  </div>
	  
	  <div class="form-group has-feedback">
	    <input type="password" name="userpw" class="form-control" placeholder="Password" />
	    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
	    
	    <div class="formError">
	    	<span id="userpw_error"></span>
	    </div>
	  </div>
	  
	  <div class="form-group has-feedback">
	    <input type="password" name="confirm" class="form-control" placeholder="Confirm Password" />
	    <span class="glyphicon glyphicon-check form-control-feedback"></span>
	    
	    <div class="formError">
	    	<span id="confirm_error"></span>
	    </div>
	  </div>
	  
	</form>
	
	<div class="row">
		<div class="col-xs-8">
	   	</div>
	   
	   	<div class="col-xs-4">
	    	<button type="button" class="btn btn-primary btn-block btn-flat">가입</button>
	   	</div>
	</div>
</c:if>



      </div><!-- /.login-box-body -->
    </div><!-- /.login-box -->

  </body>
</html>