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
	var isIE = false;

	var agent = navigator.userAgent.toLowerCase();
	if ( (navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || (agent.indexOf("msie") != -1)) {
		var IEVersion = function () {
	         var rv = -1; // Return value assumes failure.    
	         if (navigator.appName == 'Microsoft Internet Explorer') {        
	              var ua = navigator.userAgent;        
	              var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");        
	              if (re.exec(ua) != null)            
	                  rv = parseFloat(RegExp.$1);    
             }
	         return rv; 
		}

		isIE = IEVersion() <= 9;
	}
	

	function isImage(fileName) {
		return fileName.match(/jpg|jpeg|gif|png/i);
	}
	
	function printData(fileName) {
		var str = '';
		
		if(isImage(fileName)) {
			str = "<div><img src='displayFile?fileName=" + fileName + "'/>" + fileName + "</div>";
		}
		else {
			str = "<div>" + fileName + "</div>";
		}
		
		$('#uploadedList').append(str);
	}
	
	
	$(document).ready(function() {
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

		
		
		$('#submitBtn').click(function() {
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
	
	<div id="uploadedList">
	</div>
	
	
</body>
</html>