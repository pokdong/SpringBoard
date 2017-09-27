<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="../include/header2.jsp" %>

<link rel="stylesheet" href="/resources/lightbox2/css/lightbox.min.css">
<link rel="stylesheet" href="/resources/xeyez/css/attachment.css">

<script src="/resources/xeyez/js/handlebars4.0.5.js"></script>
<script src="/resources/lightbox2/js/lightbox.min.js"></script>
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


<div class="row">
	<form class="col s12">
	
		<div class="input-field col s12">
          <input disabled type="text" name="title" value="${boardVO.title}" onfocus="this.blur()">
          <label for="title">제목</label>
        </div>
        
        <div class="input-field col s12">
			<textarea disabled name="content" class="materialize-textarea" rows="10" cols="1" onfocus="this.blur()" style="resize: none;">${boardVO.content}</textarea>
			<label for="content">내용</label>
		</div>
		
		<div class="input-field col s12">
			<input disabled type="text" name="writer" value="${boardVO.writer}" onfocus="this.blur()">
			<label for="writer">작성자</label>
		</div>
	
	</form>
</div>

<div>
	<ul class="uploadedList center-align">
	</ul>
	
	<div class="right-align">
		<sec:authorize access="isAuthenticated()">
			<c:if test="${userid == boardVO.writer || isAdmin}">
				<button type="submit" id="btn_modify" class="btn btn-warning">수정</button>
				<button type="submit" id="btn_remove" class="btn btn-danger">삭제</button>
			</c:if>
		</sec:authorize>
		<button type="submit" id="btn_list" class="btn blue">목록으로</button>
	</div>
</div>

<%@include file="reply.jsp" %>
    
<%@include file="../include/footer2.jsp" %>


<script id="templateAttach_read" type="text/x-handlebars-template">
<li>
  <span class="mailbox-attachment-icon has-img">
	{{#if isImage}}
		<a href="{{getLink}}" data-lightbox="img"><img src="{{imgsrc}}" alt="Attachment"></a>
	{{else}}
		<a href="{{getLink}}"><i class="fa fa-file"></i></a>
	{{/if}}
  </span>

  <div class="mailbox-attachment-info" data-src="{{fullName}}">
	{{#if isImage}}
		<a href="{{getLink}}" data-lightbox="img">{{fileName}}</a>
	{{else}}
		<a href="{{getLink}}">{{fileName}}</a>
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
			//console.log("fileInfo : " + fileInfo);
			
			var html = template(fileInfo);
			
			 $(".uploadedList").append(html);
		});
	});
</script>

<script>
	var formObj = $("form[role='form']");
	
	//console.log(formObj);
	
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
		$(".uploadedList").each(function(index){
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

