<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <title>Spring Board</title>

  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- <link rel="icon" type="image/x-icon" href="favicon.ico"> -->
  
  <style>
  	body {
  		background-color: #eeeeee;
	}
  
  	.fa {
  		font-size: 100px;
  		margin-bottom: 30px;
  	}
  </style>
</head>
<body>
	<div>
		<i class="fa fa-frown-o center-align"></i>
	</div>

	<h4>${exception.getClass().getName()}</h4>

	<ul>
	<c:forEach	items="${exception.getStackTrace()}" var="e">
		<li>${e.toString()}</li>
	</c:forEach>
	</ul>
</body>
</html>