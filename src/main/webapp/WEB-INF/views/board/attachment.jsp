<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
	// 모바일이거나 IE10 이하면 Drag & Drop 지원하지 않음.
	var isUnavailableBrowser = isMobile() || (IEVersionCheck() < 10);
	if(isUnavailableBrowser) {
		$('.fileDrop').html('파일을 추가하려면<br>클릭하세요.');
	}
</script>

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

	<span class="btn btn-default btn-xs pull-right delbtn" data-deltype="write">
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
		$(this).css('background-color', '#F39C12');
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
				printData(fileName);
			},
			error : function(request, status, error) {
				alert("code : " + request.status + "\n"
						+ "message : " + request.responseText + "\n" 
						+ "error : " + error);
			}
		});
		
		$(this).css('background-color', 'white');
	});
	
	
	// 클릭시 추가
	$('.fileDrop').on('click dragstart contextmenu selectstart', function(event) {
		event.preventDefault();
		$(':file').trigger('click');
	});
	
	$(':file').change(function(e) {
		if(this.files[0].size > 0) {
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
	
	
	var tempDeleteFilesArr = [];
	
	//삭제
	$('.uploadedList').on('click', '.delbtn', function() {
		var that = $(this);
		
		//수정시 기존파일은 진짜 삭제가 되면 안되므로
		//가삭제를 위해 구분.

		var deltype = that.attr('data-deltype');
		
		if (deltype == 'modify') {
			//가삭제
			tempDeleteFilesArr.push(that.parent().attr('data-src'));
			that.parent().parent().remove();
		}
		else if(deltype == 'write') {
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
				},
				error : function(request, status, error) {
					alert("code : " + request.status + "\n"
							+ "message : " + request.responseText + "\n" 
							+ "error : " + error);
				}
			});
		}
		
		
	});
</script>