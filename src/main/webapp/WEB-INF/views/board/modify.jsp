<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
			<input type="text" name="title" class="form-control" maxlength="30" value="${boardVO.title}" placeholder="Enter Title"> <!-- form-control : 테두리 및 개행 -->
		</div>
		
		<div class="form-group">
			<label>내용</label>
			<textarea name="content" class="form-control" rows="3" cols="1" maxlength="1000" placeholder="Enter Title">${boardVO.content}</textarea>
		</div>
		
		<div class="form-group">
			<label>닉네임</label>
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
		<button type="submit" class="btn btn-primary">확인</button> <!-- btn-primary : 배경 및 글자 색상 변경 -->
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

	<span data-src="{{fullName}}" class="btn btn-default btn-xs pull-right delbtn">
		<i class="fa fa-fw fa-remove"></i>
	</span>
  </div>
</li>
</script>

<script>
	var formObj = $("form[role='form']");
	
	console.log(formObj);
	
	// 확인
	$(".btn-primary").on("click", function() {
		formObj.submit();
	});
	
	// 취소
	$(".btn-warning").on("click", function() {
		
		var query = "/board/list?"
			+ "page=${cri.page}"
			+ "&postCount=${cri.postCount}"
			+ "&pageCount=${pageMaker.pageCount}";
			
		var searchType = "${cri.searchType}"
		var keyword = "${cri.keyword}".replace(/(^\s*)|(\s*$)/gi, "");
		
		// searchType의 글자 처리 필요
		if((searchType.length != 0 && searchType != 'n') && keyword.length != null) {
			query += ("&searchType=" + searchType
					+ "&keyword=" + keyword);
		}
			
		self.location = query;
	});
</script>

<script>
	/* 첨부파일 출력 */
	
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
    
<script>
	var template = Handlebars.compile($("#templateAttach").html());

	function printData(fullName) {
		var fileInfo = getFileInfo(fullName);
		var html = template(fileInfo);
		$('.uploadedList').append(html);
	}

	$('.fileDrop').on('dragenter dragover', function(event) {
		event.preventDefault();
	});
	
	$('.fileDrop').on('drop', function(event) {
		event.preventDefault();
		
		var files = event.originalEvent.dataTransfer.files;
		var file = files[0];
		
		//console.log(file);
		
		// IE10부터 formData 지원
		var formData = new FormData();
		formData.append("file", file);
		
		$.ajax({
			type : 'POST',
			url : '/uploadAjax',
			processData : false,
			contentType : false,
			data : formData,
			dataType : "text",
			success : function(fileName) {
				//alert(response);
				
				printData(fileName);
			}
		});
	});
	
	//삭제
	$('.uploadedList').on('click', '.delbtn', function() {
		var that  = $(this);
		
		$.ajax({
			type : 'POST',
			url : '/deleteFile',
			data : {
				fileName : that.attr('data-src')
			},
			dataType : "text",
			success : function(response) {
				if(response != 'SUCCESS')
					return;
				
				that.parent().parent().remove();
			}
		});
	});
	
	
	
	// Form을 이용하여 파일 업로드
	$('#fileSubmitBtn').on('click', function(event) {
		
		var attachFile = $("#attachFile");
		
		if(attachFile.val().length <= 0) {
			alert('파일을 선택해주세요.')
			return;
		}
		
        var options = {
        		url: '/uploadAjax',
                type: 'POST',
                dataType : "text",
                success : function (fileName){
                    //alert(fileName);
                    
                	printData(fileName);
                },
                error:function(e){e.responseText();}
            };
            
        
        $("#fileSubmitForm").ajaxForm(options).submit();
        
        attachFile.val("");
    });
	
	
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
		
		var str ="";
		$(".uploadedList .delbtn").each(function(index){
			 str += "<input type='text' name='files["+index+"]' value='"+$(this).attr("data-src") +"'> ";
		});
		
		formObj.append(str);
		
		formObj.submit();
	});
</script>


<script src="/resources/lightbox2/js/lightbox.min.js"></script>