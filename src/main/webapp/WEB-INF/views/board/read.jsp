<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@include file="../include/header.jsp" %>

<link rel="stylesheet" href="/resources/lightbox2/css/lightbox.min.css">

<script src="/resources/js/handlebars4.0.5.js"></script>
<script src="/resources/js/upload.js"></script>

<form role="form" method="post">
	<input type='hidden' name='bno' value="${boardVO.bno}">
	<input type='hidden' name='page' value="${cri.page}">
	<input type='hidden' name='postCount' value="${cri.postCount}">
	
	<input type='hidden' name='pageCount' value="${pageMaker.pageCount}">
	<input type='hidden' name='searchType' value="${cri.searchType}">
	<input type='hidden' name='keyword' value="${cri.keyword}">
</form>

    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">READ</h3>
		            </div>
		            
<!-- Content -->
					<div class="box-body"> <!-- box-body : 전체 margin -->
<div class="form-group"> <!-- form-group : 하단 여백 -->
	<label>제목</label>
	<input type="text" name="title" class="form-control" value="${boardVO.title}" readonly="readonly" onfocus="this.blur()"> <!-- form-control : 테두리 및 개행 -->
</div>

<div class="form-group">
	<label>내용</label>
	<textarea name="content" class="form-control" rows="3" cols="1" readonly="readonly" onfocus="this.blur()">${boardVO.content}</textarea>
</div>

<div class="form-group">
	<label>닉네임</label>
	<input type="text" name="writer" class="form-control" value="${boardVO.writer}" readonly="readonly" onfocus="this.blur()">
</div>


					</div>


<div class="box-footer"> <!-- box-footer : 전체 여백 + 상단 테두리 -->

	<ul class="mailbox-attachments clearfix uploadedList">
	</ul>
	
	<div class="form-control" align="right">
		<button type="submit" id="btn_modify" class="btn btn-warning">수정</button> <!-- btn-primary : 배경 및 글자 색상 변경 -->
		<button type="submit" id="btn_remove" class="btn btn-danger">삭제</button>
		<button type="submit" id="btn_list" class="btn btn-primary">목록으로</button>
	</div>
</div>

		            
		        </div>
	        </div>
        
      	</div>
      	
<%@include file="reply.jsp" %>
      	
   	</section>
   	
	</div>
    
<%@include file="../include/footer.jsp" %>




<script id="templateAttach" type="text/x-handlebars-template">
<li>
  <span class="mailbox-attachment-icon has-img">
	<img src="{{imgsrc}}" alt="Attachment">
  </span>

  <div class="mailbox-attachment-info">
	{{#if isImage}}
		<a href="{{getLink}}" class="mailbox-attachment-name" data-lightbox="img">{{fileName}}</a>
	{{else}}
		<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
	{{/if}}
  </div>
</li>
</script>

<script>
	var formObj = $("form[role='form']");
	
	console.log(formObj);
	
	// 수정
	$("#btn_modify").on("click", function() {
		formObj.attr("action", "/board/modify");
		formObj.attr("method", "get");
		formObj.submit();
	});
	
	// 삭제
	$("#btn_remove").on("click", function() {
		formObj.attr("action", "/board/remove");
		formObj.attr("method", "post"); // 삭제 후 현재 보던 페이지로 유지 필요
		formObj.submit();
	});
	
	// 목록
	$("#btn_list").on("click", function() {
		// self.location = "/board/listPage";
		
		//var test = formObj.find("input[name='bno']").val();
		
		formObj.attr("action", "/board/list");
		formObj.attr("method", "get");
		formObj.submit();
	});
	
</script>


<script>
	$(document).ready(function() {
		// bno는 reply.jsp 에 위치
		
		// 처음 갱신.
		
		var isMoveToReply = ${reply}
		
		if(isMoveToReply) {
			var replyInfo = new ReplyInfo(replyAction.SHOW_WITH_REPLY, -1);
			updatePage(bno, 1, replyInfo);
		}
		else {
			updatePage(bno, 1, null);
		}
		
		

		$(window).scroll(function() {
			// endPage, replyPage는 reply.jsp 에 위치
			if(endPage < replyPage)
				return;
			
			var scrollHeight = $(window).scrollTop() + $(window).height();
			var documentHeight = $(document).height();
			
			if(scrollHeight == documentHeight) {
				
				updatePage(bno, replyPage, null);
			}
		});
	});
	
</script>



<script>
	//bno는 reply.jsp에 있음.
	var template = Handlebars.compile($('#templateAttach').html());
		
		
	console.log("ㅇㅋ?????");
	console.log("bno : " + bno);
	
	var template = Handlebars.compile($("#templateAttach").html());
	
	$.getJSON("/board/getAttach/"+bno, function(list){
		
		$(list).each(function(){
			
			var fileInfo = getFileInfo(this);
			console.log("fileInfo : " + fileInfo);
			
			var html = template(fileInfo);
			
			 $(".uploadedList").append(html);
			
		});
	});
</script>


<script src="/resources/lightbox2/js/lightbox.min.js"></script>