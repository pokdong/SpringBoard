<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="hasRole('ADMIN')" var="isAdmin" />

<c:if test="${adminExists}">
	<c:if test="${isAdmin}">
		<jsp:forward page="/admin_config"/> 
	</c:if>
	
	<c:if test="${!isAdmin}">
		<!-- 로그인하지 않은 상태에서 접근시 -->
		<sec:authorize access="!isAuthenticated()">
			<script>
				self.location = '/user/login?returl=' + window.location.href;
			</script>
		</sec:authorize>
		
		<!-- 로그인했지만 admin이 아닐 시 -->
		<sec:authorize access="isAuthenticated()">
			<script>
				alert('권한이 없습니다.');
				self.location = '/board/list';
			</script>
		</sec:authorize>
	</c:if>
</c:if>

<!-- 게시판 첫 생성후 관리자가 존재하지 않는 경우 -->
<c:if test="${!adminExists}">
	<script>
		self.location = '/user/signup';
	</script>
</c:if>