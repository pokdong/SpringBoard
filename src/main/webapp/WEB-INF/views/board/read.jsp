<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@include file="../include/header.jsp" %>

<form role="form" method="post">
	<input type='hidden' name='bno' value="${boardVO.bno}">
	<input type='hidden' name='page' value="${cri.page}">
	<input type='hidden' name='postCount' value="${cri.postCount}">
	<!-- totalPostCount 필요 -->
</form>

    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">READ</h3>
		            	<span style="float: right;"><fmt:formatDate value="${boardVO.regdate}" pattern="yyyy-MM-dd HH:mm" /></span>
		            </div>
		            
<!-- Content -->
					<div class="box-body"> <!-- box-body : 전체 margin -->
<div class="form-group"> <!-- form-group : 하단 여백 -->
	<label>제목</label>
	<input type="text" name="title" class="form-control" value="${boardVO.title}" readonly="readonly" onfocus="this.blur()"> <!-- form-control : 테두리 및 개행 -->
</div>

<div class="form-group">
	<label>내용</label>
	<textarea name="content" class="form-control" rows="3" cols="1" readonly="readonly" onfocus="this.blur()">${boardVO.content}</textarea>
</div>

<div class="form-group">
	<label>닉네임</label>
	<input type="text" name="writer" class="form-control" value="${boardVO.writer}" readonly="readonly" onfocus="this.blur()">
</div>


					</div>


<div class="box-footer" align="right"> <!-- box-footer : 전체 여백 + 상단 테두리 -->
	<button type="submit" class="btn btn-warning">수정</button> <!-- btn-primary : 배경 및 글자 색상 변경 -->
	<button type="submit" class="btn btn-danger">삭제</button>
	<button type="submit" class="btn btn-primary">목록으로</button>
</div>

		            
		        </div>
	        </div>
        
      	</div>
   	</section>
   	
	</div>
    
    
    
<script>
	var formObj = $("form[role='form']");
	
	console.log(formObj);
	
	$(".btn-warning").on("click", function() {
		formObj.attr("action", "/board/modify");
		formObj.attr("method", "get");
		formObj.submit();
	});
	
	$(".btn-danger").on("click", function() {
		formObj.attr("action", "/board/remove");
		formObj.attr("method", "post"); // 삭제 후 현재 보던 페이지로 유지 필요
		formObj.submit();
	});
	
	$(".btn-primary").on("click", function() {
		// self.location = "/board/listPage";
		formObj.attr("action", "/board/list");
		formObj.attr("method", "get");
		formObj.submit();
	});
</script>
    
    
<%@include file="../include/footer.jsp" %>