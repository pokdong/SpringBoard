<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<style>
	.fileDrop {
	  width: 80%;
	  height: 120px;
	  border: 3px dashed gray;
	  margin: auto;
	  text-align: center;
	  line-height: 40px;
	  font-weight: bold;
	}
	
	.uploadedList {
		display: table;
		margin-left: auto;
		margin-right: auto;
	}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script src="/resources/xeyez/js/jquery.form.js"></script>

<script>
	 
	 function isSupportedIE() { 
		 var word; 
		 var version = "N/A"; 

		 var agent = navigator.userAgent.toLowerCase(); 
		 var name = navigator.appName; 

		 // IE old version ( IE 10 or Lower ) 
		 if (name == "Microsoft Internet Explorer")
			 word = "msie "; 

		 else { 
			 if ( agent.search("trident") > -1 ) // IE 11 
				 word = "trident/.*rv:"; 
			 else if ( agent.search("edge/") > -1 ) // Microsoft Edge
				 word = "edge/"; 
		 } 

		 var reg = new RegExp( word + "([0-9]{1,})(\\.{0,}[0-9]{0,1})" ); 
		 //var reg = new RegExp( word + "([0-9]{1,})" ); 

		 if (  reg.exec( agent ) != null  ) version = RegExp.$1 + RegExp.$2; 

		 return version < 10;
	}
</script>

<script>	
	function checkImageFile(fileName) {
		return fileName.match(/jpg|jpeg|gif|png/i);
	}
	
	function getOriginalFileName(fileName) {
		if(checkImageFile(fileName))
			return;
		
		return fileName.substr(fileName.indexOf('_') + 1);
	}
	
	function getFileLink(fileName) {
		if(!checkImageFile(fileName))
			return;
		
		return fileName.replace(/s_/, '');
	}
	
	function printData(fileName) {
		var str = '';
		
		if(checkImageFile(fileName)) {
			str = "<div>"
					+ "<a href='displayFile?fileName=" + getFileLink(fileName) + "'>"
						+ "<img src='displayFile?fileName=" + fileName + "'/>"
					+ "</a>"
					+ "<small data-src='" + fileName + "'>X</small>"
				+ "</div>";
		}
		else {
			str = "<div>" 
					+ "<a href='displayFile?fileName=" + fileName + "'>" 
						+ getOriginalFileName(fileName) 
					+ "</a>" 
					+ "<small data-src='" + fileName + "'>X</small>"
				+ "</div>";
		}
		
		$('.uploadedList').append(str);
	}
	
</script>

<script>
	$(document).ready(function() {
		var maxUploadSize = 10485760;
		
		//IE10 이하면 Drag&Drop 지원하지 않음.
		if(isSupportedIE()) {
			$('.fileDrop').html('파일을 추가하려면<br>클릭하세요.');
		}
		
		
		$('.fileDrop').on('dragenter dragover', function(event) {
			event.preventDefault();
			$(this).css('background-color', '#F39C12');
		});
		
		$('.fileDrop').on('drop', function(event) {
			event.preventDefault();
			$(this).css('background-color', 'white');
			
			var files = event.originalEvent.dataTransfer.files;
			var file = files[0];
			
			if(file.size >= maxUploadSize) {
				alert('10MB를 초과할 수 없습니다');
				return;
			}
			
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
					printData(fileName);
				},
				error : function(request, status, error) {
					alert("code : " + request.status + "\n"
							+ "message : " + request.responseText + "\n" 
							+ "error : " + error);
				}
			});
		});

		
		
		
		
		$('.fileDrop').on('mousedown', function(event) {
			event.preventDefault();
			$(':file').trigger('click');
		});
		
		$(':file').change(function(e) {
			var fileSize = this.files[0].size;
			
			if(fileSize >= maxUploadSize) {
				alert('10MB를 초과할 수 없습니다');
				return;
			}
			
			if(fileSize > 0) {
				var options = {
	            		url: '/uploadAjax',
	                    type: 'POST',
	                    dataType : "text",
	                    success : function (fileName){
	                    	printData(fileName);
	                    },
	    				error : function(request, status, error) {
	    					alert("code : " + request.status + "\n"
	    							+ "message : " + request.responseText
	    							+ "\n" + "error : " + error);
	    				}
	                };
	                
	            
	            var func = $("#fileSubmitForm").ajaxForm(options).submit();
	            
	            $(":file").val("");
	            
	            $('.fileDrop').css('background-color', 'white');
			}
		});
		
		
		
		
		$('.uploadedList').on('click', 'small', function() {
			
			var smallObj  = $(this);
			
			$.ajax({
				type : 'POST',
				url : '/deleteFile',
				data : {
					fileName : smallObj.attr('data-src')
				},
				dataType : "text",
				success : function(response) {
					if(response != 'SUCCESS')
						return;
					
					smallObj.parent('div').remove();
				},
				error : function(request, status, error) {
					alert("code : " + request.status + "\n"
							+ "message : " + request.responseText
							+ "\n" + "error : " + error);
				}
			});
		});
	});	
</script>


<title>upload</title>
</head>
<body>
	<form id="fileSubmitForm" enctype="multipart/form-data" method="post" hidden="true">
	     <input name="attachFile" type="file">
	</form>

	<div class="fileDrop" >
		파일을 추가하려면<br>
		클릭하거나<br>
		파일을 Drag & Drop 하세요.
	</div>
	
	<div class="uploadedList">
	</div>
	
	
</body>
</html>