<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<title>회원 가입</title>
</head>
<body>

<form:form method="post" commandName="newUser">
    <label for="userid">사용자이름</label>:
    <form:input path="userid"/> 
    <form:errors path="userid"/> <br/>
    
    <label for="userpw">암호</label>:
    <form:password path="userpw"/> 
    <form:errors path="userpw"/> <br/>
    
    <label for="confirm">암호 확인</label>:
    <form:password path="confirm"/> 
    <form:errors path="confirm"/> <br/>
    
    <input type="submit" value="가입" />
</form:form>

</body>
</html>