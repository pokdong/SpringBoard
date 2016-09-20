<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp" %>

<link rel="stylesheet" href="/resources/lightbox2/css/lightbox.min.css">
<link rel="stylesheet" href="/resources/xeyez/css/attachment.css">

<script src="/resources/xeyez/js/handlebars4.0.5.js"></script>
<script src="/resources/xeyez/js/upload.js"></script>
<script src="/resources/xeyez/js/utils.js"></script>


<form role="form" method="post">
	<input type='hidden' name='bno' value="${boardVO.bno}">
	<input type='hidden' name='page' value="${cri.page}">
	<input type='hidden' name='postCount' value="${cri.postCount}">
	
	<input type='hidden' name='pageCount' value="${pageMaker.pageCount}">
	<input type='hidden' name='searchType' value="${cri.searchType}">
	<input type='hidden' name='keyword' value="${cri.keyword}">
	
	<input type='hidden' name='writer' value="${boardVO.writer}">
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
	<textarea name="content" class="form-control" rows="10" cols="1" readonly="readonly" onfocus="this.blur()" style="resize: none;">${boardVO.content}</textarea>
</div>

<div class="form-group">
	<label>작성자</label>
	<input type="text" name="writer" class="form-control" value="${boardVO.writer}" readonly="readonly" onfocus="this.blur()">
</div>


					</div>


<div class="box-footer"> <!-- box-footer : 전체 여백 + 상단 테두리 -->

	<ul class="mailbox-attachments clearfix uploadedList">
	</ul>
	
	<div align="right">
		<sec:authorize access="isAuthenticated()">
			<c:if test="${userid == boardVO.writer || isAdmin}">
				<button type="submit" id="btn_modify" class="btn btn-warning">수정</button>
				<button type="submit" id="btn_remove" class="btn btn-danger">삭제</button>
			</c:if>
		</sec:authorize>
		<button type="submit" id="btn_list" class="btn btn-primary">목록으로</button>
	</div>
</div>

		            
		        </div>
	        </div>
	        
<!-- <button id="testbtn">test</button> -->

      	</div>
      	
<%@include file="reply.jsp" %>
      	
   	</section>
   	
	</div>
    
<%@include file="../include/footer.jsp" %>




<script id="templateAttach_read" type="text/x-handlebars-template">
<li>
  <span class="mailbox-attachment-icon has-img">
	<img src="{{imgsrc}}" alt="Attachment">
  </span>

  <div class="mailbox-attachment-info" data-src="{{fullName}}">
	{{#if isImage}}
		<a href="{{getLink}}" class="mailbox-attachment-name" data-lightbox="img">{{fileName}}</a>
	{{else}}
		<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
	{{/if}}
  </div>
</li>
</script>

<script>
	/* 첨부파일 출력, 불러오기, Load */
	
	//bno는 reply.jsp에 있음.
	//var bno = ${boardVO.bno};
	var template = Handlebars.compile($('#templateAttach_read').html());
	
	$.getJSON("/board/getAttach/"+bno, function(list){
		
		$(list).each(function(){
			
			var fileInfo = getFileInfo(this);
			console.log("fileInfo : " + fileInfo);
			
			var html = template(fileInfo);
			
			 $(".uploadedList").append(html);
			
		});
	});
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
		
		//var replyCnt =  $("#replycnt").html().replace(/[^0-9]/g, "");
		//var replyCnt = ${boardVO.replycnt};
		
		// 실시간으로 댓글 개수 얻고 삭제
		
		$.ajax({
			type : "POST",
			url : '/replies/count/' + bno,
			headers : {
				"Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "POST"
			},
			dataType : "text",
			success : function(replyCnt) {
				console.log("response : " + replyCnt);
				
				if(replyCnt > 0) {
					alert("댓글이 달린 게시물을 삭제할 수 없습니다.");
					return;
				}
				
				formObj.attr("action", "/board/remove");
				formObj.attr("method", "post"); // 삭제 후 현재 보던 페이지로 유지 필요
				formObj.submit();
				
			},
			error : function(request, status, error) {
				alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	});
	
	// 목록
	$("#btn_list").on("click", function() {
		// self.location = "/board/listPage";
		
		//var test = formObj.find("input[name='bno']").val();
		
		formObj.attr("action", "/board/list");
		formObj.attr("method", "get");
		formObj.submit();
	});
	
	function deleteAllFiles() {
		var arr = [];
		$(".uploadedList .mailbox-attachment-info").each(function(index){
			 arr.push($(this).attr("data-src"));
		});
		
		console.log(arr);
		
		if(arr.length > 0){
			$.post("/deleteAllFiles", {files:arr}, function(){
				
			});
		}
	}
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
		
		
		$('#testbtn').click(function(e) {
			e.preventDefault();
			
			/* var arr = [];
			$(".uploadedList .mailbox-attachment-info").each(function(index){
				 arr.push($(this).attr("data-src"));
			});
			
			console.log(arr);
			
			if(arr.length > 0){
				$.post("/deleteAllFiles", {files:arr}, function(){
					
				});
			} */
			
			//var replyCnt = ${boardVO.replycnt};
			$.ajax({
				type : "POST",
				url : '/replies/count/' + bno,
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
				},
				dataType : "text",
				success : function(response) {
					console.log("response : " + response);
				},
				error : function(request, status, error) {
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
			
		});
	});
	
</script>


<script src="/resources/lightbox2/js/lightbox.min.js"></script>