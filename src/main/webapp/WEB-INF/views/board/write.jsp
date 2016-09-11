<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%@ page session="false" %> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp" %>

<link rel="stylesheet" href="/resources/lightbox2/css/lightbox.min.css">

<script src="/resources/js/handlebars4.0.5.js"></script>
<script src="/resources/js/upload.js"></script>


<style>
	.fileDrop {
	  width: 80%;
	  height: 100px;
	  border: 3px dashed gray;
	  margin: auto;
	  text-align: center;
	  line-height: 100px;
	  font-weight: bold;
	}
	
	.uploadedList {
		display: table;
		margin-left: auto;
		margin-right: auto;
	}
	
	.fileForm {
		width: 80%;
		margin-top: 10px;
		margin-bottom: auto;
		margin-left: auto;
		margin-right: auto;
	}
	
	#fileSubmitBtn {
		width: 100%;
	}
</style>


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

	function isMobile() {
		var filter = "win16|win32|win64|mac";
	
		if (navigator.platform) {
			return 0 > filter.indexOf(navigator.platform.toLowerCase());
		}
		else
			return false;
	}
	
	function IEVersionCheck() {
		 
	    var word;
	    var version = "N/A";
	
	    var agent = navigator.userAgent.toLowerCase();
	    var name = navigator.appName;
	
	    // IE old version ( IE 10 or Lower )
	    if ( name == "Microsoft Internet Explorer" ) word = "msie ";
	
	    else {
	        // IE 11
	        if ( agent.search("trident") > -1 ) word = "trident/.*rv:";
	
	        // IE 12  ( Microsoft Edge )
	        else if ( agent.search("edge/") > -1 ) word = "edge/";
	    }
	
	    var reg = new RegExp( word + "([0-9]{1,})(\\.{0,}[0-9]{0,1})" );
	    if (  reg.exec( agent ) != null  )
	        version = RegExp.$1 + RegExp.$2;
	
	    return version;
	};

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


	/* $(window).unload(function() {
		console.log('unload');
		
		$(".uploadedList .delbtn").each(function(index){
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
					
					//that.parent().parent().remove();
					
					console.log('삭제!!!');
				}
			});
		});
	}); */
	
</script>


<script src="/resources/lightbox2/js/lightbox.min.js"></script>