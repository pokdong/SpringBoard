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
			line-height: 160px;
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
    		
    		
    		var maxUploadSize = 10485760;
    		
    		//var defaultProfilePath = '/resources/dist/img/user_160x160.jpg';
    		var defaultProfilePath = null;
    		var tempProfilePath = null;
    		var pureFilePath = null;
    		
    		
    		function changeProfileImage(fileName) {
				$('#img_profile').attr('src', "/displayProfile?fileName=" + fileName);
				$('#img_profile').attr('data-changed', 'true');
				
				tempProfilePath = "/displayProfile?fileName=" + fileName;
				pureFilePath = fileName;
			}
    		
    		//저장된 ProfilePath가 있으면 이미 교체
    		var isProfilepathExists = '${authUser.profilepath != null}';
			if(isProfilepathExists == 'true') {
				defaultProfilePath = "/displayProfile?fileName=${authUser.profilepath}";
				$('#img_profile_current').attr('src', defaultProfilePath);
				$('#img_profile').attr('src', defaultProfilePath);
				$('#img_profile').attr('data-changed', 'false');
			}
    		
    		
    		var formObj = $("form[role='form']");
    		var userpwObj = formObj.find('input[name=userpw]');
    		
    		var passwordErrorObj =  $('#passwordError');
    		
    		$('#btn_withdrawal').on('click', function(e) {
				$('#div_withdrawal').toggle('fast', function() {
					$('#passwordError').html('');
					$('#passwordError').slideUp('fast');
				});
			});
    		
			$('#btn_withdrawal_pwConfirm').on('click', function(e) {
				e.preventDefault();
				
				var userid = formObj.find('input[name=userid]').val();
				var userpw = userpwObj.val();

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
								passwordErrorObj.slideUp('fast', function() {
									passwordErrorObj.html('암호가 일치하지 않습니다.');
									
									passwordErrorObj.slideDown('fast');
								});
								break;
						}
					},
					error : function(request, status, error) {
						if(request.responseText == 'EMPTY') {
							passwordErrorObj.slideUp('fast', function() {
								passwordErrorObj.html('공백은 허용되지 않습니다.');
								
								passwordErrorObj.slideDown('fast');
							});
						}
					}
				});
				
				formObj.find('input[name=userpw]').val('');
				
			});
			
			//enter 눌렀을 때 submit 방지.
			formObj.on('keydown', function(event) {
				if(event.keyCode == 13) {
					$(this).attr('onsubmit', 'return false;');
					$('#btn_withdrawal_pwConfirm').trigger('click');
				}
				else {
					$(this).removeAttr('onsubmit');
				}
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
			
			
			
			var formInfoObj = $('#from_info');
			var userpw_newObj = formInfoObj.find('input[name=userpw_new]');
			
			// 닫기 Aniamtion 이후 취소/확인에 따라 새로 추가했던 프로필 이미지를 기준으로
			// 확인이면 새 이미지 제외 모두 삭제
			// 취소이면 새 이미지만 삭제
			function close(isConfirm) {
				
				// form 초기화
				formInfoObj.find('input[name=userpw]').val('');
				formInfoObj.find('input[name=confirm]').val('');
				userpw_newObj.val('');
				
				div_modify.slideUp('fast', function() {
					div_main.slideDown('fast', function() {
						$.ajax({
							type : "POST",
							url : "/deleteProfile",
							data : {
								fileName : tempProfilePath,
								isConfirm : isConfirm
							},
							dataType : "text",
							success : function(response) {
								tempProfilePath = null;
							},
							error : function(request, status, error) {
								alert("code : " + request.status + "\n"
										+ "message : " + request.responseText + "\n" 
										+ "error : " + error);
							}
						});
					});
				});
			}
			
			
			var username_error = $('#username_error');
			var userpw_error = $('#userpw_error');
			var confirm_error = $('#confirm_error');
			var userpw_new_error = $('#userpw_new_error');
			
			$('#div_modify_buttons').on('click', 'button', function(event) {
				username_error.text('');
    			userpw_error.text('');
    			confirm_error.text('');
    			userpw_new_error.text('');
				
				var id = event.target.id
				
				
				
				var username = formInfoObj.find('input[name=username]').val();
				var userpw = formInfoObj.find('input[name=userpw]').val();
				var confirm = formInfoObj.find('input[name=confirm]').val();
				var userpw_new = formInfoObj.find('input[name=userpw_new]').val();
				
				var isImageChanged = $('#img_profile').attr('data-changed');
				
				switch (id) {
					case 'btn_modify_cancel':
						//DB에 저장된 Image가 없는 경우
						if(defaultProfilePath == null)
							defaultProfilePath = '/resources/dist/img/user_160x160.jpg';
						
						$('#img_profile').attr('src', defaultProfilePath);
						$('#img_profile').attr('data-changed', 'false');
						
						close(false);
						break;

					case 'btn_modify_confirm':
						
						var data = {
								username : username,
								userpw : userpw,
								confirm : confirm,
								userpw_new : userpw_new,
								profilepath : null
							};
						
						// image가 변경된 적 있으면 기본 image 변경
						if(isImageChanged == 'true') {
							data.profilepath = pureFilePath;
						}
						
						
						$.ajax({
							type : "PATCH",
							url : "/user/profile",
							headers : {
								"Content-Type" : "application/json",
								"X-HTTP-Method-Override" : "PATCH"
							},
							data : JSON.stringify(data),
							dataType : "text",
							success : function(response) {
								
								var obj = JSON.parse(response);
								
								if(obj.result == 'SUCCESS') {
									//alert('ok!');
									
									// Image 교체된 적이 있다면 교체
									if(isImageChanged == 'true') {
										defaultProfilePath = $('#img_profile').attr('src');
										
										$('#img_profile_current').attr('src', defaultProfilePath);
										$('#img_profile').attr('data-changed', 'false');
									}
									
									// Username 교체
									$('#span_username').text(username);
									formInfoObj.find('input[name=username]').val(username);
									
									close(true);
								}
								else if(obj.result == 'ERROR') {
									
									$.each(obj, function(key, value) {
										switch (key) {
											case 'username':
												username_error.text(value);
												break;
												
											case 'userpw':
												userpw_error.text(value);
												break;
												
											case 'confirm':
												confirm_error.text(value);
												break;
												
											case 'userpw_new':
												userpw_new_error.text(value);
												break;
										}
									});
								}
								
							},
							error : function(request, status, error) {
								alert("code : " + request.status + "\n"
										+ "message : " + request.responseText + "\n" 
										+ "error : " + error);
							}
						});
						
						break;
				}
				
				
			});
			
			//enter 동작하도록 설정.
			userpw_newObj.on('keydown', function(event) {
				if(event.keyCode == 13) {
					$('#btn_modify_confirm').trigger('click');
				}
			});
			
			
			
			$('.fileDrop_profile').on('dragenter dragover', function(event) {
				event.preventDefault();
				$(this).css('background-color', '#17B3E4');
			});
			
			$('.fileDrop_profile').on('drop', function(event) {
				event.preventDefault();
				$(this).css('background-color', 'white');
				
				var files = event.originalEvent.dataTransfer.files;
				var file = files[0];
				
				if(file.size >= maxUploadSize) {
					alert('10MB를 초과할 수 없습니다');
					return;
				}
				
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
			
			
			$('.fileDrop_profile').on('mousedown', function(event) {
				event.preventDefault();
				
				$(':file').trigger('click');
			});
			
			$(':file').change(function(event) {
				event.preventDefault();
				
				var fileSize = this.files[0].size;
				
				if(fileSize >= maxUploadSize) {
					alert('10MB를 초과할 수 없습니다');
					return;
				}
				
				if(fileSize > 0) {

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
			<img id="img_profile_current" src="/resources/dist/img/user_160x160.jpg" class="img-circle" />
		</div>
		
		
		<div class="textArea bold">
			${authUser.userid}
			<div>
				(<span id="span_username">${authUser.username}</span>)
			</div>
		</div>
		
		<div class="textArea">
			${authUser.regdate}
		</div>
		
	</div>
	
	<div class="form-group">
		<a href='/user/logout' class="btn btn-flat btn-warning form-control">로그 아웃</a>
	</div>
	
<c:if test="${isAdmin}">
	<div class="form-group">
		<button type="button" class="btn btn-flat bg-green form-control" onclick="self.location='/admin'">관리</button>
	</div>
</c:if>
	
	<div class="form-group">
		<button type="button" id="btn_modify" class="btn btn-flat btn-info form-control">회원정보 수정</button>
	</div>
	
<c:if test="${!isAdmin}">
	<div class="form-group" style="margin-bottom: 30px;">
		<button type="button" id="btn_withdrawal" class="btn btn-flat btn-danger form-control">회원 탈퇴</button>
		
		<div id="div_withdrawal" style="margin-top: 10px;" hidden="true">
			<span id="passwordError" class="error" hidden="true"></span>
		
			<form role="form" method="post">
				<input type='hidden' name='userid' value="${authUser.userid}">
				
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






<div id="div_modify" hidden="true">
	<form id="fileSubmitForm" enctype="multipart/form-data" method="post" hidden="true">
	     <input name="attachFile" type="file" accept="image/*" >
	</form>

	<div class="form-group">
		<div class="fileDrop_profile" >
			<div class="profileArea">
				<img id="img_profile" src="/resources/dist/img/user_160x160.jpg" class="img-circle" data-changed="false" />
			</div>
		
			사진을 변경하려면<br>
			클릭하거나<br>
			Drag & Drop 하세요.
		</div>
	</div>
	
	
	
	<div style="margin-top: 30px">
	</div>
	
	<form id="from_info" action="/user/profile" method="post">
		<div class="form-group has-feedback">
		    <input type="text" name="username" class="form-control" maxlength="10" placeholder="Nickname" value="${authUser.username}"/>
		    <span class="glyphicon glyphicon-info-sign form-control-feedback"></span>
		    
		    <div class="formError">
	    		<span id="username_error"></span>
	    	</div>
		</div>
		
		<div style="margin-top: 30px">
		</div>
		
		<div class="form-group has-feedback">
		    <input type="password" name="userpw" maxlength="30" class="form-control" placeholder="Password" />
		    <span class="glyphicon glyphicon-lock form-control-feedback"></span>
		    
		    <div class="formError">
	    		<span id="userpw_error"></span>
	    	</div>
		</div>
		
		<div class="form-group has-feedback">
		    <input type="password" name="confirm" maxlength="30" class="form-control" placeholder="Confirm Password" />
		    <span class="glyphicon glyphicon-check form-control-feedback"></span>
		    
		    <div class="formError">
	    		<span id="confirm_error"></span>
	    	</div>
		</div>
		
		<div class="form-group has-feedback">
		    <input type="password" name="userpw_new" maxlength="30" class="form-control" placeholder="New Password" />
		    <span class="glyphicon glyphicon-ok form-control-feedback"></span>
		    
		    <div class="formError">
	    		<span id="userpw_new_error"></span>
	    	</div>
		</div>
	</form>
	

	<div id="div_modify_buttons" align="right">
		<button type="button" id="btn_modify_cancel" class="btn btn-warning">취소</button>
		<button type="button" id="btn_modify_confirm" class="btn btn-danger">확인</button>
	</div>
</div>




      </div><!-- /.login-box-body -->
    </div><!-- /.login-box -->

  </body>
</html>