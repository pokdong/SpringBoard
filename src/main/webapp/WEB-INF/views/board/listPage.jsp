<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false"%>

<%@include file="../include/header.jsp" %>

    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">LIST</h3>
		            </div>
		            

<!-- Content -->
					<div class="box-body">
					
<table class="table table-bordered"> <!-- table 자동 여백 맞춤 -->
	<tr>
		<th style="width: 70px">번호</th>
		<th>제목</th>
		<th>닉네임</th>
		<th>날짜</th>
		<th style="width: 100px">조회</th>
	</tr>
	
<c:forEach items="${list}" var="boardVO">
	<tr>
		<td>${boardVO.bno}</td>
		<td><a href="/board/read${pageMaker.makeQuery(pageMaker.cri.page)}&bno=${boardVO.bno}">${boardVO.title}</a></td>
		<td>${boardVO.writer}</td>
		<td><fmt:formatDate value="${boardVO.regdate}" pattern="yyyy-MM-dd HH:mm" /></td>
		<td><span class="badge bg-red">${boardVO.viewcnt }</span></td>
	</tr>
</c:forEach>
	
</table>
					
					
					</div>

					<div class="box-footer">

<div class="text-center">
	<ul class="pagination">
		<c:if test="${pageMaker.prev}">
			<li><a href="listPage${pageMaker.makeQuery(pageMaker.startPage - 1)}">&laquo;</a></li>
		</c:if>
		
		<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
			<li <c:out value="${pageMaker.cri.page == idx ? 'class = active' : ''}"/>>
				<a href="listPage${pageMaker.makeQuery(idx)}">${idx}</a>
			</li>
		</c:forEach>
		
		<c:if test="${pageMaker.next}">
			<li><a href="listPage${pageMaker.makeQuery(pageMaker.endPage + 1)}">&raquo;</a></li>
		</c:if>
	</ul>
</div>

		            </div>
		            
		        </div>
	        </div>
        
      	</div>
   	</section>
   	
	</div>
    
    
    
    
<script>
	var result = ${msg}
	if(result == 'SUCESS') {
		alert("처리가 완료되었습니다.");
	}
</script>
    
<%@include file="../include/footer.jsp" %>