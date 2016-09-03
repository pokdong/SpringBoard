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
		            	<h3 class="box-title">WRITE</h3>
		            </div>
	
					<div class="box-body"> <!-- box-body : 전체 margin -->
<!-- Content -->
<form role="form" method="post">
	
	<div class="form-group"> <!-- form-group : 하단 여백 -->
		<label>Title</label>
		<input type="text" name="title" class="form-control" placeholder="Enter Title"> <!-- form-control : 테두리 및 개행 -->
	</div>
	
	<div class="form-group">
		<label>Content</label>
		<textarea name="content" class="form-control" rows="3" cols="1" placeholder="Enter content"></textarea>
	</div>
	
	<div class="form-group">
		<label>Writer</label>
		<input name="writer" type="text" class="form-control" placeholder="Enter Writer">
	</div>
	
	<div class="box-footer"> <!-- box-footer : 전체 여백 + 상단 테두리 -->
		<button type="submit" class="btn btn-primary">Submit</button> <!-- btn-primary : 배경 및 글자 색상 변경 -->
	</div>
	
</form>

					</div>
		            
		        </div>
	        </div>
        
      	</div>
   	</section>
   	
	</div>
    
<%@include file="../include/footer.jsp" %>