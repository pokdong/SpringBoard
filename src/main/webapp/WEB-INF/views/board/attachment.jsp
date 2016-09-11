<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script id="templateAttach" type="text/x-handlebars-template">
<li>
  <span class="mailbox-attachment-icon has-img">
	<img src="{{imgsrc}}" alt="Attachment">
  </span>

  <div class="mailbox-attachment-info" data-src="{{fullName}}">
	{{#if isImage}}
		<a href="{{getLink}}" class="mailbox-attachment-name" data-lightbox="img">{{fileName}}</a>
	{{else}}
		<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
	{{/if}}

	<span class="btn btn-default btn-xs pull-right delbtn">
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
				fileName : that.parent().attr('data-src')
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
</script>