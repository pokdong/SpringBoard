<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set value="/resources/dist/img/user_160x160.jpg" var="defaultImgURI" />
<c:set value="/displayProfile?fileName=${authUser.profilepath}" var="authUserImgURL" />
   
<sec:authorize access="isAuthenticated()" var="isAuthenticated">
	<sec:authentication property="name" var="userid"/>
</sec:authorize>
<sec:authorize access="hasRole('ADMIN')" var="isAdmin" />
   
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8">
    <title>Spring Board</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    
    <style>
    	@import url(https://fonts.googleapis.com/earlyaccess/nanumgothic.css);
    </style>
    
    <!-- Font Awesome Icons -->
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    
    <!--Import Google Icon Font-->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!-- Compiled and minified CSS -->
  	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css" media="screen,projection"/>
  	
  	<link rel="stylesheet" href="/resources/xeyez/css/layout.css">
  	<link rel="stylesheet" href="/resources/xeyez/css/rx.css">
  	
  	
  	<!-- Polyfill -->
	<script src="https://cdn.polyfill.io/v2/polyfill.min.js"></script>
	
	<!--Import jQuery before materialize.js-->
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
  	<!-- Compiled and minified JavaScript -->
  	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
  	
  	<!-- IE 10 이하 from 이용 파일 업로드 지원 -->
	<script src="/resources/xeyez/js/jquery.form.js"></script>
	
	<script>
	  	$( document ).ready(function(){
	  		$(".button-collapse").sideNav();
	  		$('select').material_select();
	  	});
  	</script>
  </head>
  <body>
  
  <header>
	  <nav>
	  	<div class="nav-wrapper">
	      <a href="/" class="brand-logo">Spring Board</a>
	      <a href="#" data-activates="mobile-demo" class="button-collapse"><i class="material-icons">menu</i></a>
	      
	      <ul class="right hide-on-med-and-down">
	      
	      	<sec:authorize access="!isAuthenticated()">
		        <li><a href="/user/signup">Sign-up</a></li>
		        <li><a href="/user/login">Log-in</a></li>
        	</sec:authorize>
	        <sec:authorize access="isAuthenticated()">
	        	<li><a href="/user/profile">Profile</a></li>
		        <li><a href="/user/logout">Log-out</a></li>
	        </sec:authorize>
	      </ul>
	      
	      <ul class="side-nav" id="mobile-demo">
	        <li><a href="/user/signup">Sign-up</a></li>
	        <li><a href="/user/login">Log-in</a></li>
	      </ul>
	    </div>
	    
	  </nav>
	  
  </header>
  
  <main class="rx-row">
  	<section class="rx-col12 main-content">
  