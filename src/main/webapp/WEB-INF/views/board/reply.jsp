<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div id="replies-container" class="row">

	<div class="col s12">
		<div class="userid blue-text">
			<i class="fa fa-user"></i> <span id="newReplyWriter">${userid}</span>
		</div>


		<div class="pull-right">
			<span id="replyTextCount"></span> <span>/</span> <span
				id="replyTextLimit"></span>
		</div>

		<div class="input-field">
			<textarea id="newReplyText" name="newReplyText"
				class="materialize-textarea" rows="3" cols="1" maxlength="300"
				style="resize: none;"></textarea>
			<label for="newReplyText">댓글</label>
		</div>
	</div>

	<div class="col s12">
		<button type="button" id="btn_replyUpdate" class="btn blue">
			<i class="material-icons">autorenew</i>
		</button>
		<button type="submit" id="btn_replyAdd"
			class="btn btn-success pull-right">등록</button>
	</div>

	<ul class="timeline col s12">
		<li class="row" id="repliesDiv">
			<button type="button" id="btn_top" class="btn blue col s12">
				<i class="material-icons">vertical_align_top</i>
			</button>
		</li>
	</ul>
</div>


<div id="modal-modify" class="modal bottom-sheet">
	<div class="modal-content">
		<div class="modal-header">
			<h1 class="modal-title" hidden="true"></h1>
			<h1 class="modal-title2" hidden="true"></h1>
		</div>

		<div class="modal-body" data-rno=''>
			<input type="text" id="replytext">
		</div>

	</div>
	<div class="modal-footer">
		<button type="button" class="modal-action modal-close waves-effect waves-green btn btn-info" id="btn_replyMod">수정</button>
		<button type="button" class="modal-action modal-close waves-effect waves-green btn blue">취소</button>
	</div>
</div>

<div id="modal-delete" class="modal bottom-sheet">
	<div class="modal-content">
		<div class="modal-header">
			<h1 class="modal-title" hidden="true"></h1>
			<h1 class="modal-title2" hidden="true"></h1>
		</div>

		<div class="modal-body" data-rno=''>
			<h5>삭제하시겠습니까?</h5>
		</div>
	</div>
	<div class="modal-footer">
		<button type="button" class="modal-action modal-close waves-effect waves-green btn red" id="btn_replyDel">삭제</button>
		<button type="button" class="modal-action modal-close waves-effect waves-green btn blue">취소</button>
	</div>
</div>




<script>
	var replyAction = {
		ADD : 0,
		DELETE : 1,
		MODIFY : 2,
		SHOW_WITH_REPLY : 3,
		UPDATE : 4
	};

	function ReplyInfo(replyAction, rno) {
		this.action = replyAction;
		this.rno = rno;
	}
</script>

<script id="template" type="text/x-handlebars-template">
    {{#each .}}
        <li class="replyLi" data-rno={{rno}} data-replyer={{replyer}}>
            <div class="card">
	            <span class="card-title blue-text">
					<i class="fa fa-user"></i>
					<span>{{replyer}}</span>
				</span>
	            <div class="card-content timeline-body">
		            {{replytext}}
	            </div>
	            <div class="right-align">
		            <i class="fa fa-clock-o"></i>
		            <span>{{prettifyDate updatedate}}</span>
	            </div>

				{{#hasAuthority replyer}}
            	<div class="card-action right-align">
					<button type="button" class="btn" id="btn_modifyDialog">수정</button>
					<button type="button" class="btn red" id="btn_deleteDialog">삭제</button>
            	</div>
				{{/hasAuthority}}
            </div>
        </li>
    {{/each}}
</script>

<script>
	$.ajaxSetup({ cache: false });

	var bno = ${boardVO.bno}
	var replyPage = 1;
	var endPage = 1;

	//추가, 수정, 삭제시 Animation을 주기 위함.
	var recentRno = Number.MAX_VALUE;

	// fmt tag로 대체 필요?
	Handlebars.registerHelper("prettifyDate", function(timeValue) {
			var dateObj = new Date(timeValue);
			
			var year = dateObj.getFullYear();
			var month = dateObj.getMonth() + 1;
			var date = dateObj.getDate();
			
			var hour = dateObj.getHours();
			var min = dateObj.getMinutes();
			var sec = dateObj.getSeconds();
			return year + "/" + month + "/" + date + " " + hour + ":" + min + ":" + sec;
	});
	
	Handlebars.registerHelper("hasAuthority", function(replyer, options) {
		var hasAuth = options.inverse(this);
		
		var isAdmin = '${isAdmin}';
		var isAuthenticated = '${isAuthenticated}';
		var userid = '${userid}';
		if((isAuthenticated == 'true' && userid == replyer) || isAdmin == 'true')
			hasAuth = options.fn(this);
		
		return hasAuth;
	});
	
	function printReply(replyArr, target, templateObject, replyInfo) {
		var template = Handlebars.compile(templateObject.html());
		var html = template(replyArr);
		
		
		//$(".replyLi").remove(); //전체 갱신을 위한 임시 해결책
		
		if(replyInfo != null) {
			switch (replyInfo.action) {
				case replyAction.ADD:
					// 1. 댓글 전부 삭제
					// 2. 1page만 갱신
					// 3. 갱신된 댓글에서 최근 댓글만 Aniamtion
					
					var removeObj = $(".replyLi").remove();
					
					removeObj.ready(function() {
						console.log("remove is ready!");
						
						var htmlObj = target.before(html);
						
						htmlObj.ready(function() {
							var newPost = $('.replyLi[data-rno=' + replyInfo.rno + ']');
							
							newPost.hide(0, function() {
								newPost.slideDown('fast');
							});
						});
						
					});
					
					break;
					
				case replyAction.DELETE:
					// 1. 스크롤 상단으로 올림
					// 2. 1page까지만 갱신
					
					var targetReply = $('.replyLi[data-rno=' + replyInfo.rno + ']');
					targetReply.slideUp(1200, function() {
						
						var offset = $('#replies-container').offset();
						$('html, body').animate({scrollTop: offset.top}, 500, function() {
							
							var removeObj = $(".replyLi").remove();
							removeObj.ready(function() {
								
								target.before(html);
								
								/* var allReplies = $('#replies-container .timeline');
								
								allReplies.fadeOut(0, function () {
									allReplies.fadeIn();
					            }); */
							});
						});
					});
					break;
					
				case replyAction.MODIFY:
					
					// 갱신하지 않음.
					// Animation만.
					
					break;
					
				case replyAction.SHOW_WITH_REPLY:
					var htmlObj = target.before(html);
					htmlObj.ready(function() {
						//replies-container는 reply.jsp에 위치.
						var offset = $('#replies-container .timeline').offset();
						$('html, body').animate({scrollTop: offset.top}, 500);
					});
					break;
					
				case replyAction.UPDATE :
					var offset = $('#replies-container').offset();
					$('html, body').animate({scrollTop: offset.top}, 250, function() {
						
						var removeObj = $(".replyLi").remove();
						removeObj.ready(function() {
							
							target.before(html);
							
						});
					});
					break;
			}
		}
		else {
			var htmlObj = target.before(html);
		}
		
		
	}
	
	function updatePage(pBno, pReplyPage, replyInfo) {
		var url = '/replies/' + pBno + '/' + pReplyPage;
		//console.log(url);
		
		$.getJSON(url, function(data) {
			//console.log(data.list.length);
			endPage = data.pageMaker.endPage;
			replyPage++;
			
			printReply(data.list, $("#repliesDiv"), $('#template'), replyInfo);
		});
	}
	
	
	
	$('#btn_top').on('click', function(e) {
		e.preventDefault();
		
		var offset = $('#replies-container').offset();
		$('html, body').animate({scrollTop: offset.top}, 450);
	});
	
	$('#btn_replyAdd').on('click', function(event) {
		
		var replyerObj = $('#newReplyWriter');
		var replyTextObj = $('#newReplyText');
		
		//var replyer = replyerObj.val();
		var replyer = replyerObj.html();
		var replyText = trim(replyTextObj.val());
		
		if(replyText.length == 0) {
			alert('내용을 입력해주세요.');
			return;
		}
		
		$.ajax({
			type : 'POST',
			url : '/replies/',
			headers : {
				"Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "POST"
			},
			data : JSON.stringify({
				bno : bno,
				replyer : replyer,
				replytext : replyText
			}),
			dataType : "text",
			success : function(response) {
				var obj = JSON.parse(response);
				
				if(obj.message != 'SUCCESS')
					return;
				
				recentRno = obj.rno;
				console.log("recentRno : " + recentRno)
				
				replyPage = 1;
				
				
				var replyInfo = new ReplyInfo(replyAction.ADD, recentRno);
				updatePage(bno, replyPage, replyInfo); //data 전달 필요
				
				replyerObj.val('');
				replyTextObj.val('');
			}
		});
	});
	
	
	/* modal 열기 */
	$(".timeline").on("click", ".replyLi button", function(event){
		
		var reply = $(this).parent().parent().parent();
		
		var buttonId = event.target.id;
		
		var rno = reply.attr("data-rno");
		var replyer = reply.attr("data-replyer");
		
		switch (buttonId) {
			case 'btn_modifyDialog':
				$(".modal-title").html(rno);
				$(".modal-title2").html(replyer);
				
				var replyText = trim(reply.find('.timeline-body').text());
				$("#replytext").val(replyText);
				
				$("#modal-modify").modal('open');
				break;
				
			case 'btn_deleteDialog':
				$(".modal-title").html(rno);
				$(".modal-title2").html(replyer);
				
				$("#modal-delete").modal('open');
				break;
		}
	});
	
	$('#btn_replyMod').on('click', function(event) {
		var rno = $(".modal-title").html();
		var replyer = $(".modal-title2").html();
		var replyText = trim($('#replytext').val());
		
		$.ajax({
			type : 'PUT',
			url : '/replies/' + rno,
			headers : {
				"Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "PUT"
			},
			data : JSON.stringify({
				replyer : replyer,
				replytext : replyText
			}),
			dataType : "text",
			success : function(response) {
				if(response != 'SUCCESS')
					return;
				
				var targetReply = $('.replyLi[data-rno=' + rno + ']');
				targetReply.find('.timeline-body').text(replyText);
				
				//갱신하지 않음.
				//animation만 설정.
				targetReply.fadeOut(0, function() {
					targetReply.fadeIn('slow');
				});
			},
			error : function(request, status, error) {
				if(request.responseText == 'ACCESS_DENIED')
					alert('권한이 없습니다.');
				else
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
		
	});
	
	$('#btn_replyDel').on('click', function(event) {
		var rno = $(".modal-title").html();
		var replyer = $(".modal-title2").html();
		
		$.ajax({
			type : 'DELETE',
			url : "/replies/" + rno,
			headers : {
				"Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "DELETE"
			},
			data : replyer,
			dataType : "text",
			success : function(response) {
				if(response != 'SUCCESS')
					return;
				
				replyPage = 1;
				
				var replyInfo = new ReplyInfo(replyAction.DELETE, rno);
				updatePage(bno, replyPage, replyInfo);
			},
			error : function(request, status, error) {
				if(request.responseText == 'ACCESS_DENIED')
					alert('권한이 없습니다.');
				else
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	});
	
	$('#btn_replyUpdate').on('click', function(e) {
		e.preventDefault();
		
		replyPage = 1;
		
		var replyInfo = new ReplyInfo(replyAction.UPDATE, -1);
		updatePage(bno, replyPage, replyInfo);
		
	});
	
	/* 
	$('#btn_test').on('click', function() {
		//$('#replies-container .timeline').slideUp('fast');
		
		var targetReply = $('.replyLi[data-rno=' + 164 + ']');
		var replyText = targetReply.find('.timeline-body').text().replace(/(^\s*)|(\s*$)/gi, "");
		
		alert(replyText);
	});
	 */
</script>


<script>
	//newReplyText
	//isAuthenticated
	
	var isAuthenticated = ${isAuthenticated};
	
	var newReplyText = $('#newReplyText');
	var btn_replyAdd = $('#btn_replyAdd');
	
	if(isAuthenticated) {
		newReplyText.removeAttr('disabled');
		newReplyText.removeAttr('placeholder');
		
		btn_replyAdd.removeAttr('disabled');
	}
	else {
		//newReplyText.attr('disabled', 'true');
		newReplyText.focus(function(e) {
			e.preventDefault();
			this.blur();
		});
		
		newReplyText.attr('placeholder', '로그인 하세요.');
		newReplyText.on('click', function(e) {
			e.preventDefault();
			
			var curUrl = $(location).attr('href');
			self.location = '/user/login' + "?returl=" + curUrl;
			
			//alert('/user/login' + "?returl=" + curUrl);
		});
		
		btn_replyAdd.attr('disabled', 'true');
	}
	
	// Text count
	$('#replyTextCount').html(prependZero(0, 3));
	btn_replyAdd.attr('disabled', 'true'); //초기 비활성화
	$('#replyTextLimit').html(newReplyText.attr('maxlength'));
	
	newReplyText.on('keyup', function(e) {
		var len = trim(newReplyText.val()).length;
		
		if(len <= 0) {
			//엔터이거나 스페이스인 경우
			if(e.keyCode == 13 || e.keyCode == 32)
				$(this).val('');
			
			btn_replyAdd.attr('disabled', 'true');
		}
		else
			btn_replyAdd.removeAttr('disabled');
		
		$('#replyTextCount').html(prependZero(len, 3));
	});
	
	/* Firefox에서 한글 인식 문제로 포커스 잃을 때 재계산 */
	newReplyText.blur(function(e) {
		var len = trim(newReplyText.val()).length;
		
		if(len <= 0) {
			//엔터이거나 스페이스인 경우
			if(e.keyCode == 13 || e.keyCode == 32) {
				$(this).val('');
			}
			
			btn_replyAdd.attr('disabled', 'true');
		}
		else
			btn_replyAdd.removeAttr('disabled');
		
		$('#replyTextCount').html(prependZero(len, 3));
	});
	
</script>