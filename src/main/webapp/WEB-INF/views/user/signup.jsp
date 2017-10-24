<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="../include/header-user.jsp"%>

<div class="card-content blue white-text">
<span class="card-title">Sign-up</span>	
</div>

<div class="card-content">
	<form id="from-user" action="/user/signup" method="post">
		<input type="hidden" name="adminExists" value="${adminExists}">
		
		<div class="input-field">
			<c:if test="${adminExists}">
				<input type="text" id="userid" name="userid" class="validate">
			</c:if>
			<c:if test="${!adminExists}">
				<input type="text" id="userid" name="userid" class="validate" value="admin" readonly onfocus="this.blur()">
			</c:if>
			
			<label for="userid">ID</label>
			
			<div class="formError">
				<span id="userid_error"></span>
			</div>
		</div>

		<div class="input-field">
			<input type="password" id="userpw" name="userpw" class="validate">
			<label for="userpw">Password</label>

			<div class="formError">
				<span id="userpw_error"></span>
			</div>
		</div>

		<div class="input-field">
			<input type="password" id="confirm" name="confirm" class="validate">
			<label for="confirm">Confirm Password</label>

			<div class="formError">
				<span id="confirm_error"></span>
			</div>
		</div>
	</form>
		
	<a id="btn-signup" class="waves-effect waves-light btn blue white-text full-width">Sign-up</a>
</div>

<script>
	var isAdminExists = '${adminExists}';

	$(document).ready(function() {

		var userid_error = $('#userid_error');
		var userpw_error = $('#userpw_error');
		var confirm_error = $('#confirm_error');

		$('#btn-signup').on('click', function() {
			
			userid_error.text('');
			userpw_error.text('');
			confirm_error.text('');

			var formObj = $('#from-user');

			var userid = formObj.find('input[name=userid]').val();
			var userpw = formObj.find('input[name=userpw]').val();
			var confirm = formObj.find('input[name=confirm]').val();

			
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
					confirm : confirm,
					adminExists : isAdminExists
				}),
				success : function(response) {
					var obj = JSON.parse(response);

					if (obj.result == 'SUCCESS') {
						formObj.submit();
					} else if (obj.result == 'ERROR') {

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

<%@include file="../include/footer-user.jsp"%>