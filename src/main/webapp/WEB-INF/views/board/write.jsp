<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="../include/header2.jsp" %>

<link rel="stylesheet" href="/resources/lightbox2/css/lightbox.min.css">
<link rel="stylesheet" href="/resources/xeyez/css/attachment.css">

<script src="/resources/xeyez/js/handlebars4.0.5.js"></script>
<script src="/resources/xeyez/js/upload.js"></script>
<script src="/resources/xeyez/js/utils.js"></script>


<!-- Content -->
<form role="form" action="write" method="post">

	<input type='hidden' name='postCount' value="${cri.postCount}">
	<input type='hidden' name='pageCount' value="${pageMaker.pageCount}">
	<input type="hidden" name="writer" value="${authUser.userid}">
	
	<div class="input-field">
		<div class="pull-right">
			<span id="titleCount"></span>
			<span>/</span>
			<span id="titleLimit"></span>
		</div>
		
		<input type="text" name="title" maxlength="30">
		<label for="title">제목</label>
	</div>
	
	<div class="input-field">
		<div class="pull-right">
			<span id="contentCount"></span>
			<span>/</span>
			<span id="contentLimit"></span>
		</div>
		
		<textarea name="content" class="materialize-textarea" rows="10" cols="1" maxlength="2000"></textarea>
		<label for="content">내용</label>
	</div>
	
</form>

<div class="box-footer" > <!-- box-footer : 전체 여백 + 상단 테두리 -->
	
	<div>
		<form id="fileSubmitForm" enctype="multipart/form-data" method="post" hidden="true">
		     <input name="attachFile" type="file">
		</form>
	
		<div class="fileDrop" >
			파일을 추가하려면<br>
			클릭하거나<br>
			파일을 Drag & Drop 하세요.
		</div>
	</div>
	
	<ul class="mailbox-attachments clearfix uploadedList">
	</ul>

	<div align="right">
		<button type="submit" id="btn_confirm" class="btn btn-primary">확인</button> <!-- btn-primary : 배경 및 글자 색상 변경 -->
	</div>
</div>



<%@include file="../include/footer2.jsp" %>


<%@include file="attachment.jsp" %>

<script>
	var btn_confirm = $('#btn_confirm');
	
	var formObj = $("form[role='form']");
	var title = formObj.find("input[name=title]");
	var content = formObj.find("textarea[name=content]");

	btn_confirm.on("click", function() {
		
		// 파일 추가 후 삭제한 경우를 대비해 reset 필요
		formObj.find("input").each(function(index) {
			var nameAttr = $(this).attr('name');
			
			if(nameAttr.includes('files')) {
				$(this).remove();
			}
		});


		var titleLength = trim(title.val()).length;
		if(titleLength <= 0) {
			alert('제목을 입력하세요.');
			return;
		}
		
		var contentLength = trim(content.val()).length;
		if(contentLength <= 0) {
			alert('내용을 입력하세요.');
			return;
		}
		
		//파일 첨부
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
	
	
	btn_confirm.attr('disabled', 'true'); //초기 비활성화
	
	$('#titleCount').html(prependZero(0, 2));
	$('#titleLimit').html(title.attr('maxlength'));
	
	title.on('keyup', function(e) {
		enabledConfirmButton($(this), e.keyCode);
		
		var len = trim($(this).val()).length;
		$('#titleCount').html(prependZero(len, 2));
	});
	
	

	$('#contentCount').html(prependZero(0, 3));
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