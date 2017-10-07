<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<%@include file="include/header-user.jsp"%>

<style>
div .formError {
	text-align: right;
	font-size: smaller;
	color: red;
}
</style>


<div class="form-user card">
	<div class="card-content blue white-text">
		<span class="card-title">사용자 생성</span>
	</div>
	
	<div class="card-content">
		<form id="from_info">
			<select name="role">
				<option value="USER" selected="selected">USER</option>
				<option value="MANAGER">MANAGER</option>
			</select>
	
	
			<div class="input-field">
				<input type="text" name="userid" />
				<label for="userid">ID</label>
	
				<div class="formError">
					<span id="userid_error"></span>
				</div>
			</div>
	
			<div class="input-field">
				<input type="password" name="userpw" />
				<label for="userpw">Password</label>
	
				<div class="formError">
					<span id="userpw_error"></span>
				</div>
			</div>
	
			<div class="input-field">
				<input type="password" name="confirm" />
				<label for="confirm">Confirm</label>
	
				<div class="formError">
					<span id="confirm_error"></span>
				</div>
			</div>
	
		</form>
		
		<a id="btn-signup" class="waves-effect waves-light btn blue white-text full-width">생성</a>
		<a href="/" class="waves-effect waves-light btn green white-text full-width">취소</a>
	</div>
</div>


<script>
	$(document).ready(function() {

		var formObj = $('#from_info');

		var useridObj = formObj.find('input[name=userid]');
		var userpwObj = formObj.find('input[name=userpw]');
		var confirmObj = formObj.find('input[name=confirm]');

		var userid_error = $('#userid_error');
		var userpw_error = $('#userpw_error');
		var confirm_error = $('#confirm_error');

		$('#btn-signup').on('click', function() {
			userid_error.text('');
			userpw_error.text('');
			confirm_error.text('');

			var userid = useridObj.val();
			var userpw = userpwObj.val();
			var confirm = confirmObj.val();
			var role_seleted = formObj.find('option:selected').val();

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
					confirm : confirm,
					role : role_seleted,
					adminExists : true,
					controlbyAdmin : true
				}),
				success : function(response) {
					var obj = JSON.parse(response);

					if (obj.result == 'SUCCESS') {
						useridObj.val('');
						userpwObj.val('');
						confirmObj.val('');

						alert('생성되었습니다.');
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

<%@include file="include/footer-user.jsp"%>