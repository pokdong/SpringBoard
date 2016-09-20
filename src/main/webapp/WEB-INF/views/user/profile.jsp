<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="hasRole('ADMIN')" var="isAdmin" />

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Profile</title>
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

	<link rel="stylesheet" href="/resources/xeyez/css/attachment.css">
    
    <script src="/resources/xeyez/js/upload.js"></script>
    
    <style>
    	img {
		    display: block;
		    margin: auto;
		}
		
		.textArea {
			margin: 5px;
			text-align: center;
		}
		
		.bold {
			font-weight: bold;
			font-size: large;
		}
		
		.error {
			color: red;
			font-weight: bold;
		}
		
    	div .formError {
    		text-align: right;
    		font-size: smaller;
    		color: red;
    	}
    </style>
    
    <script src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script>
    	$(document).ready(function() {
    		// 모바일이거나 IE10 이하면 Drag & Drop 영역 숨김
    		var isUnavailableBrowser = isMobile() || (IEVersionCheck() < 10);
    		if(isUnavailableBrowser) {
    			$('.fileDrop').attr('hidden', 'true');
    		}
    		
    		
    		var formObj = $("form[role='form']");
    		
    		$('#btn_withdrawal').on('click', function(e) {
				$('#div_withdrawal').toggle('fast', function() {
					$('#passwordError').html('');
					$('#passwordError').slideUp('fast');
				});
			});
    		
			$('#btn_withdrawal_pwConfirm').on('click', function(e) {
				e.preventDefault();
				
				var userid = formObj.find('input[name=userid]').val();
				var userpw = formObj.find('input[name=userpw]').val();

				$.ajax({
					type : "POST",
					url : '/user/confirmPassword',
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
								formObj.attr("action", "/user/withdrawal");
								formObj.attr("method", "post");
								formObj.submit();
								
								break;
								
							case 'FAIL':
								var html = $('#passwordError').html('암호가 일치하지 않습니다.');
								html.ready(function() {
									$('#passwordError').slideDown('fast');
								});
								break;
						}
					}
				});
				
				formObj.find('input[name=userpw]').val('');
				
			});
			
			
			var div_main = $('#div_main');
			var div_modify = $('#div_modify'); 
			
			$('#btn_modify').on('click', function() {
				$('#div_withdrawal').slideUp(0, function() {
					formObj.find('input[name=userpw]').val('');
					$('#passwordError').html('');
					$('#passwordError').slideUp('fast');
				});
				
				div_main.slideUp('fast', function() {
					div_modify.slideDown('fast', function() {
						
					});
				});
				
				
			});
			
			$('#btn_modify_cancel').on('click', function() {
				
				
				div_modify.slideUp('fast', function() {
					div_main.slideDown('fast', function() {
						
					});
				});
			});
		});
    </script>
    
  </head>
  <body class="login-page">
    <div class="login-box">
      <div class="login-logo">
        <a href="/board/list"><b>Spring</b>Board</a>
      </div><!-- /.login-logo -->
      <div class="login-box-body">


<div id="div_main">
	<div class="form-group">
		<img src="/resources/dist/img/user_160x160.jpg" class="img-circle" />
		
		<div class="textArea bold">
			${userVO.userid}<br>
			(${userVO.username})
		</div>
		
		<div class="textArea">
			${userVO.regdate}
		</div>
		
	</div>
	
	<div class="form-group">
		<button type="button" id="btn_modify" class="btn btn-flat btn-info form-control">회원정보 수정</button>
	</div>
	
<c:if test="${!isAdmin}">
	<div class="form-group" style="margin-bottom: 30px;">
		<button type="button" id="btn_withdrawal" class="btn btn-flat btn-danger form-control">회원 탈퇴</button>
		
		<div id="div_withdrawal" style="margin-top: 10px;" hidden="true">
			<span id="passwordError" class="error" hidden="true"></span>
		
			<form role="form" method="post">
				<input type='hidden' name='userid' value="${userVO.userid}">
				
				<div class="has-feedback">
					<input type="password" name="userpw" class="form-control" placeholder="Password">
					<span class="glyphicon glyphicon-lock form-control-feedback"></span>
				</div>
			</form>
			
			<button type="button" id="btn_withdrawal_pwConfirm" class="btn btn-danger pull-right" style="margin-top: 5px">확인</button>
		</div>
		
	</div>
</c:if>
</div>

<div id="div_modify" >
	<div id="div_imgArea">
		<img src="/resources/dist/img/user_160x160.jpg" class="img-circle" />
	</div>
	
	<div class="form-group">
		<div class="fileDrop" >
			여기에 파일을 Drag & Drop 하세요.
		</div>
		
		<div class="fileForm" >
			<form id="fileSubmitForm" enctype="multipart/form-data" method="post" >
			     <input name="attachFile" id="attachFile" type="file" style="margin-bottom: 1px">
			     <button type="button" id="fileSubmitBtn" class="btn bg-yellow">추가</button>
			</form>
		</div>
	</div>
	
	<div style="margin-top: 30px">
	</div>
	
	<form id="from_info" action="/user/profile" method="post">
		<div class="form-group has-feedback">
		    <input type="text" name="userid" class="form-control" placeholder="Nickname" value="${userVO.username}"/>
		    <span class="glyphicon glyphicon-info-sign form-control-feedback"></span>
		    
		    <div class="formError">
	    		<span id="username_error"></span>
	    	</div>
		</div>
		
		<div style="margin-top: 30px">
		</div>
		
		<div class="form-group has-feedback">
		    <input type="text" name="userpw" class="form-control" placeholder="Password" />
		    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
		    
		    <div class="formError">
	    		<span id="userpw_error"></span>
	    	</div>
		</div>
		
		<div class="form-group has-feedback">
		    <input type="text" name="confirm" class="form-control" placeholder="Confirm Password" />
		    <span class="glyphicon glyphicon-check form-control-feedback"></span>
		    
		    <div class="formError">
	    		<span id="confirm_error"></span>
	    	</div>
		</div>
	</form>
	

	<div align="right">
		<button type="button" id="btn_modify_cancel" class="btn btn-warning">취소</button>
		<button type="button" id="btn_modify_confirm" class="btn btn-danger">확인</button>
	</div>
</div>




      </div><!-- /.login-box-body -->
    </div><!-- /.login-box -->
  </body>
</html>