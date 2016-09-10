<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%@ page session="false" %> --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
<script src="../resources/js/jquery.form.js"></script>

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
	
	#center { position:absolute; top:50%; left:50%; width:300px; height:200px; overflow:hidden; background-color:#FC0; margin-top:-150px; margin-left:-100px;}
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
<form id="registerForm" role="form" action="write" method="post">

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
			     <input name="attachFile" id="attachFile" type="file" >
			     <button type="button" id="fileSubmitBtn" class="btn bg-yellow">추가</button>
			</form>
		</div>
	</div>
	
	<ul class="mailbox-attachments clearfix uploadedList">
	</ul>

	<button type="submit" id="btn_confirm" class="btn btn-primary" style="float: right;">확인</button> <!-- btn-primary : 배경 및 글자 색상 변경 -->
</div>



					</div>
		            
		        </div>
	        </div>
        
      	</div>
   	</section>
   	
	</div>
    
<%@include file="../include/footer.jsp" %>




<script id="template" type="text/x-handlebars-template">
<li>
  <span class="mailbox-attachment-icon has-img">
	<img src="{{imgsrc}}" alt="Attachment">
  </span>

  <div class="mailbox-attachment-info">
	<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
	<span data-src="{{fullName}}" class="btn btn-default btn-xs pull-right delbtn">
		<i class="fa fa-fw fa-remove"></i>
	</span>
  </div>
</li>                
</script>

<script>
	function checkImageFile(fullName) {
		return fullName.match(/jpg|jpeg|gif|png/i);
	}

	function getFileInfo(fullName) {
		var fileName, imgsrc, getLink;
		var fileLink;
		
		if(checkImageFile(fullName)) {
			imgsrc = "/displayFile?fileName="+fullName; //thumbnail
			fileLink = fullName.substr(fullName.lastIndexOf('/') + 3); //UID_파일명
			getLink = "/displayFile?fileName="+fullName.replace(/s_/, ''); //실제파일
		}
		else {
			imgsrc ="/resources/dist/img/file.png";
			fileLink = fullName.substr(fullName.lastIndexOf('/') + 1); //UID_파일명
			getLink = "/displayFile?fileName="+fullName;
		}
		
		fileName = fileLink.substr(fileLink.indexOf("_")+1);
		
		return  {fileName:fileName, imgsrc:imgsrc, getLink:getLink, fullName:fullName};
	}
</script>

<script>
	var template = Handlebars.compile($("#template").html());

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
	
	
	$('#btn_confirm').on("click", function() {
		
		alert('ok0');
		
		$("#registerForm").submit(function(event){
			alert('ok1');
			event.preventDefault();
			alert('ok2');
			
			
			var that = $(this);
			
			var str ="";
			$(".uploadedList .delbtn").each(function(index){
				 str += "<input type='hidden' name='files["+index+"]' value='"+$(this).attr("data-src") +"'> ";
			});
			
			that.append(str);
			
			
			
			//that.get(0).submit();
		});
	});
	
</script>