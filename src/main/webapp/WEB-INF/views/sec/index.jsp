<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
	<title>Spring Security</title>
</head>
<body>

<sec:authorize access="!isAuthenticated()">
	<%-- <a href="<c:url value='spring_security_login' />">Login</a> <br> --%>
	<a href="<c:url value='/user/loginform' />">Login</a> <br>
	<a href="<c:url value='/user/join' />">회원 가입</a>
</sec:authorize>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="name" var="name"/>
	<a href="<c:url value='/j_spring_security_logout' />">Logout (${name})</a>
</sec:authorize>

<br>

<ul>
	<li><a href="<c:url value='/all' />">/all</a></li>
	
	<sec:authorize access="isAuthenticated()">
		<li><a href="<c:url value='/member' />">/member</a></li>
	</sec:authorize>
	
	<sec:authorize access="hasRole('MANAGER')">
		<li><a href="<c:url value='/manager' />">/manager</a></li>
	</sec:authorize>
	
	<sec:authorize access="hasRole('ADMIN')">
		<li><a href="<c:url value='/admin' />">/admin</a></li>
	</sec:authorize>
</ul>
</body>
</html>
