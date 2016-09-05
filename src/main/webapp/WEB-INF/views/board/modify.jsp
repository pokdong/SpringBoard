<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%@ page session="false" %> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp" %>


    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">MODIFY</h3>
		            </div>
		            
<!-- Content -->

<form role="form" method="post">

<%-- 
	<input type='hidden' name='page' value="${cri.page}">
	<input type='hidden' name='postCount' value="${cri.postCount}">
 --%>	
	

	<div class="box-body"> <!-- box-body : 전체 margin -->
		<div class="form-group"> <!-- form-group : 하단 여백 -->
			<label>Title</label>
			<input type="text" name="title" class="form-control" value="${boardVO.title}" > <!-- form-control : 테두리 및 개행 -->
		</div>
		
		<div class="form-group">
			<label>Content</label>
			<textarea name="content" class="form-control" rows="3" cols="1" >${boardVO.content}</textarea>
		</div>
		
		<div class="form-group">
			<label>Writer</label>
			<input type="text" name="writer" class="form-control" value="${boardVO.writer}" readonly="readonly" onfocus="this.blur()">
		</div>
	</div>
</form>


<div class="box-footer"> <!-- box-footer : 전체 여백 + 상단 테두리 -->
	<button type="submit" class="btn btn-primary">저장</button> <!-- btn-primary : 배경 및 글자 색상 변경 -->
	<button type="submit" class="btn btn-warning">취소</button>
</div>

		            
		        </div>
	        </div>
        
      	</div>
   	</section>
   	
	</div>
    
    
    
<script>
	var formObj = $("form[role='form']");
	
	console.log(formObj);
	
	$(".btn-primary").on("click", function() {
		formObj.submit();
	});
	
	$(".btn-warning").on("click", function() {
		self.location = "/board/listPage${cri.makeQuery()}";
	});
</script>
    
    
<%@include file="../include/footer.jsp" %>