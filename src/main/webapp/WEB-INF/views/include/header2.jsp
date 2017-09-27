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
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    
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
	  		$('.modal').modal({
	  	      dismissible: true, // Modal can be dismissed by clicking outside of the modal
	  	      opacity: .5, // Opacity of modal background
	  	      inDuration: 300, // Transition in duration
	  	      outDuration: 200, // Transition out duration
	  	      startingTop: '4%', // Starting top style attribute
	  	      endingTop: '10%', // Ending top style attribute
	  	      ready: function(modal, trigger) { // Callback for Modal open. Modal and trigger parameters available.
	  	        //alert("Ready");
	  	        //console.log(modal, trigger);
	  	      },
	  	      complete: function() {
	  	    	  
	  	      } // Callback for Modal close
	  	    });
	  	});
  	</script>
  </head>
  <body>
  
  <header>
	  <nav>
	  	<div class="nav-wrapper">
	      <a href="/" class="brand-logo">Spring Board</a>
	      
	      <ul id="nav-buttons" class="right">
	      
	      	<sec:authorize access="!isAuthenticated()">
		        <li><a href="/user/signup">Sign-up</a></li>
		        <li><a href="/user/login">Log-in</a></li>
        	</sec:authorize>
	        <sec:authorize access="isAuthenticated()">
	        	<li>
	        		<a id="btn-profile" class="waves-effect waves-teal btn-flat blue" href="/user/profile">
	        			<c:if test="${authUser.profilepath == null}">
	               			<img src="${defaultImgURI}" class="profile-image circle" alt="User Image"/>
	                	</c:if>
	                	<c:if test="${authUser.profilepath != null}">
	                		<img src="${authUserImgURL}" class="profile-image circle" alt="User Image"/>
	                	</c:if>
	        		</a>
	        	</li>
		        <li>
		        	<a href="/user/logout">
		        		<i class="fa fa-sign-out"></i>
		        		<span>${authUser.userid}</span>
			        </a>
		        </li>
	        </sec:authorize>
	      </ul>
	      
	    </div>
	    
	  </nav>
	  
  </header>
  
  <main class="rx-row">
  	<section class="rx-col12 main-content">
  