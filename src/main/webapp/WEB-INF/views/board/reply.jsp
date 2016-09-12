<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="repliesArea" class="row">
	
	<div class="col-md-12">
		
		<div class="box box-success">
			<div class="box-header">
			</div>
			
			<div class="box-body">
				<input type="text" id="newReplyWriter" placeholder="USER ID" style="margin-bottom: 5px">
				<textarea class="form-control" id="newReplyText" maxlength="100" placeholder="reply text"></textarea>
			</div>
			
			<div class="box-footer">
				<button type="button" id="btn_replyUpdate" class="btn bg-green">갱신</button>
				<button type="submit" id="btn_replyAdd" class="btn btn-primary" style="float: right;">등록</button>
			</div>
			
		</div>
		
		<ul class="timeline">
			<li class="time-label" id="repliesDiv">
				<button type="button" id="btn_top" class="btn bg-green">▲ 맨 위로 가기</button>
			</li>
		</ul>
		
	</div>
</div>



<!-- Modal -->
<div id="modifyModal" class="modal modal-primary fade" role="dialog">
  	<div class="modal-dialog">
  
    	<!-- Modal content-->
    	<div class="modal-content">
    		<div class="modal-header">
        		<button type="button" class="close" data-dismiss="modal">&times;</button>
	        	<h4 class="modal-title" hidden="true"></h4>
       		</div>
       	
      		<div class="modal-body" data-rno>
        		<p><input type="text" id="replytext" class="form-control"></p>
      		</div>
      		
      		<div class="modal-footer">
        		<button type="button" class="btn btn-info" id="btn_replyMod" data-dismiss="modal">수정</button>
        		<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
      		</div>
   		</div>
	</div>
</div>

<!-- template 작성은 나중으로 -->
<div id="deleteModal" class="modal modal-primary fade" role="dialog">
  	<div class="modal-dialog">
  
    	<!-- Modal content-->
    	<div class="modal-content">
    		<div class="modal-header">
        		<button type="button" class="close" data-dismiss="modal">&times;</button>
        		<h4 class="modal-title" hidden="true"></h4>
       		</div>
       	
      		<div class="modal-body" data-rno>
        		<p>삭제하시겠습니까?</p>
      		</div>
      		
      		<div class="modal-footer">
        		<button type="button" class="btn btn-danger" id="btn_replyDel" data-dismiss="modal">삭제</button>
        		<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
      		</div>
   		</div>
	</div>
</div>

<!-- <button id="btn_test">test</button> -->



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
        <li class="replyLi" data-rno={{rno}}>
            <i class="fa fa-comments bg-blue"></i>
            <div class="timeline-item">
                <span class="time">
                    <i class="fa fa-clock-o"></i>{{prettifyDate updatedate}}
                </span>

                <h3 class="timeline-header">
                    <strong>{{rno}} {{replyer}}</strong>
                </h3>

                <div class="timeline-body">
                    {{replytext}}
                </div>

                <div class="timeline-footer" align="right">
                    <button type="button" class="btn btn-warning btn-xs" id="btn_modifyDialog" data-toggle="modal" data-target="#modifyModal">수정</button>
					<button type="button" class="btn btn-danger btn-xs" id="btn_deleteDialog" data-toggle="modal" data-target="#deleteModal">삭제</button>
                </div>

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
	
	function printData(replyArr, target, templateObject, replyInfo) {
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
						
						var offset = $('#repliesArea').offset();
						$('html, body').animate({scrollTop: offset.top}, 500, function() {
							
							var removeObj = $(".replyLi").remove();
							removeObj.ready(function() {
								
								target.before(html);
								
								/* var allReplies = $('#repliesArea .timeline');
								
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
						//repliesArea는 reply.jsp에 위치.
						var offset = $('#repliesArea .timeline').offset();
						$('html, body').animate({scrollTop: offset.top}, 500);
					});
					break;
					
				case replyAction.UPDATE :
					var offset = $('#repliesArea').offset();
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
			
			printData(data.list, $("#repliesDiv"), $('#template'), replyInfo);
		});
	}
	
	
	
	$('#btn_top').on('click', function(e) {
		e.preventDefault();
		
		var offset = $('#repliesArea').offset();
		$('html, body').animate({scrollTop: offset.top}, 450);
	});
	
	$('#btn_replyAdd').on('click', function(event) {
		
		var replyerObj = $('#newReplyWriter');
		var replyTextObj = $('#newReplyText');
		
		var replyer = replyerObj.val();
		var replyText = replyTextObj.val().replace(/(^\s*)|(\s*$)/gi, "");
		
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
	
	
	
	$(".timeline").on("click", ".replyLi button", function(event){
		
		var reply = $(this).parent().parent().parent();
		
		var buttonId = event.target.id;
		
		switch (buttonId) {
			case 'btn_modifyDialog':
				$(".modal-title").html(reply.attr("data-rno"));
				
				var replyText = reply.find('.timeline-body').text().replace(/(^\s*)|(\s*$)/gi, "");
				$("#replytext").val(replyText);
				break;
				
			case 'btn_deleteDialog':
				$(".modal-title").html(reply.attr("data-rno"));
				break;
		}
	});
	
	$('#btn_replyMod').on('click', function(event) {
		
		var rno = $(".modal-title").html();
		var replyText = $('#replytext').val().replace(/(^\s*)|(\s*$)/gi, "");
		
		$.ajax({
			type : 'PUT',
			url : '/replies/' + rno,
			headers : {
				"Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "PUT"
			},
			data : JSON.stringify({
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
				
			}
		});
		
	});
	
	$('#btn_replyDel').on('click', function(event) {
		var rno = $(".modal-title").html();
		
		$.ajax({
			type : 'DELETE',
			url : "/replies/" + rno,
			headers : {
				"Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "DELETE"
			},
			dataType : "text",
			success : function(response) {
				if(response != 'SUCCESS')
					return;
				
				replyPage = 1;
				
				var replyInfo = new ReplyInfo(replyAction.DELETE, rno);
				updatePage(bno, replyPage, replyInfo);
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
		//$('#repliesArea .timeline').slideUp('fast');
		
		var targetReply = $('.replyLi[data-rno=' + 164 + ']');
		var replyText = targetReply.find('.timeline-body').text().replace(/(^\s*)|(\s*$)/gi, "");
		
		alert(replyText);
	});
	 */
</script>
