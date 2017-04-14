<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%@ page session="false" %> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="include/header.jsp" %>

    <style>
    	div .formError {
    		text-align: right;
    		font-size: smaller;
    		color: red;
    	}
    </style>
    
    <script src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <script>
    	$(document).ready(function() {

    		var formObj = $('#from_info');
    		
    		var useridObj = formObj.find('input[name=userid]');
    		var userpwObj = formObj.find('input[name=userpw]');
    		var confirmObj = formObj.find('input[name=confirm]');
    		
    		var userid_error = $('#userid_error');
			var userpw_error = $('#userpw_error');
			var confirm_error = $('#confirm_error');
    		
    		$('.btn-success').on('click', function() {
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
						
						if(obj.result == 'SUCCESS') {
							useridObj.val('');
							userpwObj.val('');
							confirmObj.val('');
							//formObj.find('select').val('USER').prop("selected", true);
							
							alert('생성되었습니다.');
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


    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">Under construction...</h3>
		            </div>

<!-- Content -->
					<div class="box-body">

<h1>사용자 생성</h1>
<form id="from_info">
	<select name="role">
		<option value="USER" selected="selected">USER</option>
		<option value="MANAGER">MANAGER</option>
	</select>
	

  <div class="form-group has-feedback">
    <input type="text" name="userid" class="form-control" placeholder="USER ID" />
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
    	<button type="button" class="btn btn-success btn-block btn-flat">가입</button>
   	</div>
</div>

					
					</div>

					<div class="box-footer">
		            	Footer
		            </div>
		            
		        </div>
	        </div>
        
      	</div>
   	</section>
   	
	</div>
    
<%@include file="include/footer.jsp" %>