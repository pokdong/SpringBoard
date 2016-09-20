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
    
    <script src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- IE 10 이하 from 이용 파일 업로드 지원 -->
	<script src="/resources/xeyez/js/jquery.form.js"></script>
    
    <script src="/resources/xeyez/js/handlebars4.0.5.js"></script>
	<script src="/resources/xeyez/js/upload.js"></script>
	<script src="/resources/xeyez/js/utils.js"></script>
    
    <style>
    	img {
		    /* display: block;
		    margin: auto; */
		    width: 160px;
		    vertical-align: middle;
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
    	
    	div .profileArea {
    		height: 160px;
    		line-height: 160px;
    	}
    	
    	div .profileArea2 {
    		width: 80%;
			height: 160px;
			margin: auto;
			text-align: center;
    	}
    </style>
    
    
    
    <script>
    	$(document).ready(function() {
    		// 모바일이거나 IE10 이하면 Drag & Drop 지원하지 않음.
    		var isUnavailableBrowser = isMobile() || (IEVersionCheck() < 10);
    		if(isUnavailableBrowser) {
    			$('.fileDrop').html('사진을 변경하려면<br>클릭하세요.');
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
					type : "DELETE",
					url : '/user/confirmPassword',
					headers : {
						"Content-Type" : "application/json",
						"X-HTTP-Method-Override" : "DELETE"
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
			
			
			
			function changeProfileImage(fileName) {
				$('#img_profile').attr('src', "/displayProfile?fileName=" + fileName);
			}
			
			
			$('.fileDrop_profile').on('dragenter dragover', function(event) {
				event.preventDefault();
				$(this).css('background-color', '#17B3E4');
			});
			
			$('.fileDrop_profile').on('drop', function(event) {
				event.preventDefault();
				$(this).css('background-color', 'white');
				
				var files = event.originalEvent.dataTransfer.files;
				var file = files[0];
				
				var fileName = file.name;
				
				if(checkImageFile(fileName) == null)
					return;
				
				// IE10부터 formData 지원
				var formData = new FormData();
				formData.append("file", file);
				
				$.ajax({
					type : 'POST',
					url : '/uploadProfile',
					processData : false,
					contentType : false,
					data : formData,
					dataType : "text",
					success : function(fileName) {
						//alert(fileName);
						changeProfileImage(fileName);
					},
					error : function(request, status, error) {
						alert("code : " + request.status + "\n"
								+ "message : " + request.responseText + "\n" 
								+ "error : " + error);
					}
				});
				
				
			});
			
			$('.fileDrop_profile').on('click dragstart contextmenu selectstart', function(event) {
				event.preventDefault();
				$(':file').trigger('click');
			});
			
			$(':file').change(function(e) {
				if(this.files[0].size > 0) {

					var fileName = this.files[0].name;
					
					if(checkImageFile(fileName) == null)
						return;
					
					
					var options = {
		            		url: '/uploadProfile',
		                    type: 'POST',
		                    dataType : "text",
		                    success : function (fileName){
		                    	//alert(fileName);
		                    	changeProfileImage(fileName);
		                    },
		    				error : function(request, status, error) {
		    					alert("code : " + request.status + "\n"
										+ "message : " + request.responseText + "\n" 
										+ "error : " + error);
		    				}
		                };
		                
		            
		            var func = $("#fileSubmitForm").ajaxForm(options).submit();
		            
		            $(":file").val("");
		            
		            $('.fileDrop_profile').css('background-color', 'white');
				}
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
		<div class="profileArea2">
			<img src="/resources/dist/img/user_160x160.jpg" class="img-circle" />
		</div>
		
		
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
	
	
	<div class="form-group">
		<div class="fileDrop_profile" >
			<div class="profileArea">
				<img id="img_profile" src="/resources/dist/img/user_160x160.jpg" class="img-circle" />
			</div>
		
			사진을 변경하려면<br>
			클릭하거나<br>
			Drag & Drop 하세요.
		</div>
		
		<form id="fileSubmitForm" enctype="multipart/form-data" method="post" hidden="true">
		     <input name="attachFile" type="file" accept="image/*" >
		</form>
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
		
		<div class="form-group has-feedback">
		    <input type="text" name="userpw_new" class="form-control" placeholder="New Password" />
		    <span class="glyphicon glyphicon-ok form-control-feedback"></span>
		    
		    <div class="formError">
	    		<span id="userpw_new_error"></span>
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