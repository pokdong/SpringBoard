<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<style>
	.fileDrop {
		width: 100%;
		height: 200px;
		border: 1px dotted blue;
	}
	
	small {
		margin-left: 3px;
		font-weight: bold;
		color: gray;
	}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script src="../resources/js/jquery.form.js"></script>

<script>
	var agent = navigator.userAgent.toLowerCase(); 
	var name = navigator.appName; 
	 
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
	function isImage(fileName) {
		return fileName.match(/jpg|jpeg|gif|png/i);
	}
	
	function getOriginalFileName(fileName) {
		if(isImage(fileName))
			return;
		
		return fileName.substr(fileName.indexOf('_') + 1);
	}
	
	function getFileLink(fileName) {
		if(!isImage(fileName))
			return;
		
		return fileName.replace(/s_/, '');
	}
	
	function printData(fileName) {
		var str = '';
		
		if(isImage(fileName)) {
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
		//IE10 이하면 Drag&Drop 숨김
		if(isSupportedIE()) {
			$('.fileDrop').hide(0);
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
		
		$('#submitBtn').on('click', function() {
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
                
            
            $("#submitForm").ajaxForm(options).submit();
            
            $("#attachFile").val("");
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
				}
			});
		});
	});	
</script>


<title>upload</title>
</head>
<body>
	<form id="submitForm" enctype="multipart/form-data" method="post">
         <input name="attachFile" id="attachFile" type="file">
         <button type="button" id="submitBtn">전송</button>
    </form>


	<div class="fileDrop">
	</div>
	
	<div class="uploadedList">
	</div>
	
	
</body>
</html>