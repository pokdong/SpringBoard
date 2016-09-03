<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%@ page session="false" %> --%>

<%@include file="include/header.jsp" %>

    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">${exception.getMessage()}</h3>
		            </div>
		            
		            <div class="box-body"> <!-- box-body : 전체 margin -->
<h4>${exception.getClass().getName()}</h4>

<ul>
<c:forEach	items="${exception.getStackTrace()}" var="e">
	<li>${e.toString()}</li>
</c:forEach>
</ul>
		            </div>
		            
		        </div>
	        </div>
        
      	</div>
   	</section>
    
    </div>
    
<%@include file="include/footer.jsp" %>