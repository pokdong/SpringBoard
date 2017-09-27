<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- <%@include file="include/header.jsp" %>

    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">HOME PAGE</h3>
		            </div>
		        </div>
	        </div>
        
      	</div>
   	</section>
    
    </div>
    
<%@include file="include/footer.jsp" %> --%>

<%@include file="include/header2.jsp" %>

<!-- <div class="row table-head">
  <div class="col s1">번호</div>
  <div class="col s6">제목</div>
  <div class="col s2">작성자</div>
  <div class="col s2">날짜</div>
  <div class="col s1">조회</div>
</div>

<div class="row table-content">
  <div class="col s1 text-center">1</div>
  <div class="col s6">2</div>
  <div class="col s2 text-center">3</div>
  <div class="col s2 text-center">4</div>
  <div class="col s1 text-center">5</div>
</div> -->

<div class="row">
	<div class="input-field col s3">
		<select>
			<option value="" disabled selected>Choose your option</option>
			<option value="1">Option 1</option>
			<option value="2">Option 2</option>
			<option value="3">Option 3</option>
		</select> <label>Materialize Select</label>
	</div>
	
	<div class="input-field col s7">
      <input placeholder="Placeholder" id="first_name" type="text" class="validate">
      <label for="first_name">First Name</label>
    </div>

	<button class="col s2 waves-effect waves-light btn">검색</button>    
</div>



<div>
  <div class="input-field col s12">
    <select>
      <option value="" disabled selected>Choose your option</option>
      <option value="1">Option 1</option>
      <option value="2">Option 2</option>
      <option value="3">Option 3</option>
    </select>
    <label>Materialize Select</label>
  </div>
  
  
</div>

<div>
	<label>Browser Select</label>
	<select class="browser-default">
	  <option value="" disabled selected>Choose your option</option>
	  <option value="1">Option 1</option>
	  <option value="2">Option 2</option>
	  <option value="3">Option 3</option>
	</select>
</div>

<div>
	<label>Browser Select</label>
	<select class="browser-default">
	  <option value="" disabled selected>Choose your option</option>
	  <option value="1">Option 1</option>
	  <option value="2">Option 2</option>
	  <option value="3">Option 3</option>
	</select>
</div>
          

<%@include file="include/footer2.jsp" %>