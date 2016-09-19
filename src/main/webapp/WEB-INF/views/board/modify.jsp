<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="isAuthenticated()" var="isAuthenticated">
	<sec:authentication property="name" var="userid"/>
</sec:authorize>
<sec:authorize access="hasRole('ADMIN')" var="isAdmin" />

<c:if test="${userid != boardVO.writer && !isAdmin}">
	<c:redirect url="/user/accessdenied"/>
</c:if>


<%@include file="../include/header.jsp" %>

<link rel="stylesheet" href="/resources/lightbox2/css/lightbox.min.css">
<link rel="stylesheet" href="/resources/xeyez/css/attachment.css">

<script src="/resources/xeyez/js/handlebars4.0.5.js"></script>
<script src="/resources/xeyez/js/upload.js"></script>
<script src="/resources/xeyez/js/utils.js"></script>


    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">MODIFY</h3>
		            </div>
		            
<!-- Content -->

<form role="form" action="modify"  method="post">

	<input type='hidden' name='bno' value="${boardVO.bno}">
	<input type='hidden' name='page' value="${cri.page}">
	<input type='hidden' name='postCount' value="${cri.postCount}">
	
	<input type='hidden' name='pageCount' value="${pageMaker.pageCount}">
	<input type='hidden' name='searchType' value="${cri.searchType}">
	<input type='hidden' name='keyword' value="${cri.keyword}">
 
	<!-- totalPostCount 필요 -->

	<div class="box-body"> <!-- box-body : 전체 margin -->
		<div class="form-group"> <!-- form-group : 하단 여백 -->
			<label>제목</label>
			
			
			<div class="pull-right">
				<span id="titleCount"></span>
				<span>/</span>
				<span id="titleLimit"></span>
			</div>
			
			<input type="text" name="title" class="form-control" maxlength="30" value="${boardVO.title}" placeholder="Enter Title"> <!-- form-control : 테두리 및 개행 -->
		</div>
		
		<div class="form-group">
			<label>내용</label>
			
			<div class="pull-right">
				<span id="contentCount"></span>
				<span>/</span>
				<span id="contentLimit"></span>
			</div>
			
			<textarea name="content" class="form-control" rows="10" cols="1" maxlength="2000" placeholder="Enter content" style="resize: none;">${boardVO.content}</textarea>
		</div>
		
		<div class="form-group">
			<label>작성자</label>
			<input type="text" name="writer" class="form-control" value="${boardVO.writer}" readonly="readonly" onfocus="this.blur()">
		</div>
	</div>
</form>


<div class="box-footer"> <!-- box-footer : 전체 여백 + 상단 테두리 -->

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
		<button type="submit" id="btn_confirm" class="btn btn-primary">확인</button>
		<button type="submit" class="btn btn-warning">취소</button>
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

<script>
	var btn_confirm = $('#btn_confirm');
	
	var formObj = $("form[role='form']");
	var title = formObj.find("input[name=title]");
	var content = formObj.find("textarea[name=content]");
	
	
	// 확인
	$("#btn_confirm").on("click", function() {
		var titleLength = trim(formObj.find("input[name=title]").val()).length;
		if(titleLength <= 0) {
			alert('제목을 입력하세요.');
			return;
		}
		
		var contentLength = trim(formObj.find("textarea[name=content]").val()).length;
		if(contentLength <= 0) {
			alert('내용을 입력하세요.');
			return;
		}
		
		formObj.submit();
	});
	
	// 취소
	$(".btn-warning").on("click", function() {
		
		var query = "/board/list?"
			+ "page=${cri.page}"
			+ "&postCount=${cri.postCount}"
			+ "&pageCount=${pageMaker.pageCount}";
			
		var searchType = "${cri.searchType}"
		var keyword = trim("${cri.keyword}");
		
		// searchType의 글자 처리 필요
		if((searchType.length != 0 && searchType != 'n') && keyword.length != null) {
			query += ("&searchType=" + searchType
					+ "&keyword=" + keyword);
		}
			
		self.location = query;
	});
	
	
	
	//글자 count
	function enabledConfirmButton(obj, keyCode) {
		
		var objLength = trim(obj.val()).length;
		if(objLength <= 0) {
			//엔터이거나 스페이스인 경우
			if(keyCode == 13 || keyCode == 32)
				obj.val('');
		}
		
		var titleLength = trim(title.val()).length;
		var contentLength = trim(content.val()).length;
		
		if(titleLength <= 0 || contentLength <= 0)
			btn_confirm.attr('disabled', 'true');
		else
			btn_confirm.removeAttr('disabled');
	}
	
	
	$('#titleCount').html(prependZero(title.val().length, 2));
	$('#titleLimit').html(title.attr('maxlength'));
	
	title.on('keyup', function(e) {
		enabledConfirmButton($(this), e.keyCode);
		
		var len = trim($(this).val()).length;
		$('#titleCount').html(prependZero(len, 2));
	});
	
	

	$('#contentCount').html(prependZero(content.val().length, 3));
	$('#contentLimit').html(content.attr('maxlength'));
	
	content.on('keyup', function(e) {
		enabledConfirmButton($(this), e.keyCode);
		
		var len = trim($(this).val()).length;
		$('#contentCount').html(prependZero(len, 3));
	});
	
	
	/* Firefox에서 한글 인식 문제로 포커스 잃을 때 재계산 */
	title.blur(function(e) {
		enabledConfirmButton($(this), e.keyCode);
		
		var len = trim($(this).val()).length;
		$('#titleCount').html(prependZero(len, 2));
	});
	
	content.blur(function(e) {
		enabledConfirmButton($(this), e.keyCode);
		
		var len = trim($(this).val()).length;
		$('#contentCount').html(prependZero(len, 3));
	});
</script>

<%@include file="attachment.jsp" %>

<!-- 출력 후 삭제하면 이전 첨부된 파일이 실제 삭제됨. 이 때, 취소를 누를 때 추가 로직 필요.. -->
<!-- 
<script>
	/* 첨부파일 출력 */
	
	//templateAttach는 attachment.jsp
	
	var bno = ${boardVO.bno};
	var template = Handlebars.compile($('#templateAttach').html());
	
	$.getJSON("/board/getAttach/"+bno, function(list){
		
		$(list).each(function(){
			
			var fileInfo = getFileInfo(this);
			console.log("fileInfo : " + fileInfo);
			
			var html = template(fileInfo);
			
			 $(".uploadedList").append(html);
			
		});
	});
</script>
 -->

<script src="/resources/lightbox2/js/lightbox.min.js"></script>