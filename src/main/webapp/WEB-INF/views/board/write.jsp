<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%@ page session="false" %> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp" %>

<link rel="stylesheet" href="/resources/lightbox2/css/lightbox.min.css">
<link rel="stylesheet" href="/resources/xeyez/css/attachment.css">

<script src="/resources/xeyez/js/handlebars4.0.5.js"></script>
<script src="/resources/xeyez/js/upload.js"></script>


    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">WRITE</h3>
		            </div>
	
					<div class="box-body"> <!-- box-body : 전체 margin -->
<!-- Content -->
<form role="form" action="write" method="post">

	<input type='hidden' name='postCount' value="${cri.postCount}">
	<input type='hidden' name='pageCount' value="${pageMaker.pageCount}">
	
	<div class="form-group"> <!-- form-group : 하단 여백 -->
		<label>제목</label>
		<input type="text" name="title" class="form-control" maxlength="30" placeholder="Enter Title"> <!-- form-control : 테두리 및 개행 -->
	</div>
	
	<div class="form-group">
		<label>내용</label>
		<textarea name="content" class="form-control" rows="3" cols="1" maxlength="1000" placeholder="Enter content"></textarea>
	</div>
	
	<div class="form-group">
		<label>닉네임</label>
		<input name="writer" type="text" class="form-control" placeholder="Enter Writer"> <!-- 로그인 기능이 구현되면 readonly 필요 -->
	</div>
	
</form>

<div class="box-footer" > <!-- box-footer : 전체 여백 + 상단 테두리 -->
	
	<div class="form-group">
		<div class="fileDrop" >
			여기에 파일을 Drag & Drop 하세요.
		</div>
		
		<div class="fileForm" >
			<form id="fileSubmitForm" enctype="multipart/form-data" method="post" >
			     <input name="attachFile" id="attachFile" type="file" style="margin-bottom: 1px">
			     <button type="button" id="fileSubmitBtn" class="btn bg-yellow">추가</button>
			</form>
		</div>
	</div>
	
	<ul class="mailbox-attachments clearfix uploadedList">
	</ul>

	<div align="right">
		<button type="submit" id="btn_confirm" class="btn btn-primary">확인</button> <!-- btn-primary : 배경 및 글자 색상 변경 -->
	</div>
</div>



					</div>
		            
		        </div>
	        </div>
        
      	</div>
   	</section>
   	
	</div>

<%@include file="../include/footer.jsp" %>


<script>
	// 모바일이거나 IE10 이하면 Drag & Drop 영역 숨김
	var isUnavailableBrowser = isMobile() || (IEVersionCheck() < 10);
	if(isUnavailableBrowser) {
		$('.fileDrop').attr('hidden', 'true');
	}
</script>

<%@include file="attachment.jsp" %>

<script>
	$('#btn_confirm').on("click", function(event) {
		event.preventDefault();
		
		var formObj = $("form[role='form']");
		
		// 파일 추가 후 삭제한 경우를 대비해 reset 필요
		formObj.find("input").each(function(index) {
			var nameAttr = $(this).attr('name');
			
			if(nameAttr.includes('files')) {
				$(this).remove();
			}
		});


		var titleLength = formObj.find("input[name=title]").val().replace(/(^\s*)|(\s*$)/gi, "").length;
		if(titleLength <= 0) {
			alert('제목을 입력하세요.');
			return;
		}
		
		var contentLength = formObj.find("textarea[name=content]").val().replace(/(^\s*)|(\s*$)/gi, "").length;
		if(contentLength <= 0) {
			alert('내용을 입력하세요.');
			return;
		}
		
		var str ="";
		$(".uploadedList .mailbox-attachment-info").each(function(index){
			 str += "<input type='hidden' name='files["+index+"]' value='"+$(this).attr("data-src") +"'> ";
		});
		
		formObj.append(str);
		
		formObj.submit();
	});


	//뒤로 가기나 다른 페이지 갈 때 첨부했던 파일 삭제
	/* $(window).unload(function() {
		deleteAllFiles();
	});
	
	function deleteAllFiles() {
		var arr = [];
		$(".uploadedList .mailbox-attachment-info").each(function(index){
			 arr.push($(this).attr("data-src"));
		});
		
		if(arr.length > 0){
			$.post("/deleteAllFiles", {files:arr}, function(){
				
			});
		}
	} */
</script>

<script src="/resources/lightbox2/js/lightbox.min.js"></script>