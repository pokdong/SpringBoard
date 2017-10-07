<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
  	
  	<style type="text/css">
  		body {
  			background-color: #eeeeee;
  		}
  		
  		.outer {
		  display: table;
		  position: absolute;
		  left: 0;
		  height: 100%;
		  width: 100%;
		  z-index: 10;
		}
		
		.middle {
		  display: table-cell;
		  vertical-align: middle;
		}
		
		.inner {
		  margin-left: auto;
		  margin-right: auto;
		  width: 400px;
		}
  	
		.formError {
			margin-bottom: 10px;
			text-align: right;
			font-size: smaller;
			color: red;
		}
		
		.signup-result-message {
			text-align: center;
			font-size: smaller;
			font-weight: bold;
			color: red;
		}
		
		.full-width {
			width: 100%;
		}
		
		.margin-top-15px {
			margin-top: 15px;
		}
		
		.btn {
			margin-top: 15px;
		}
	</style>
  	
  	<!-- Polyfill -->
	<script src="https://cdn.polyfill.io/v2/polyfill.min.js"></script>
	
	<!--Import jQuery before materialize.js-->
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
  	<!-- Compiled and minified JavaScript -->
  	<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
	
  </head>
  
  <body>
	  <div class="outer">
	  	<div class="middle">
	  		<div class="inner">
  