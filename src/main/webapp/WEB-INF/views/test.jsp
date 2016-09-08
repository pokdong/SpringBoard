<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ajax test</title>

<style>
	#modDiv {
		width: 300px;
		height: 100px;
		background-color: gray;
		position: absolute;
		top: 50%;
		left: 50%;
		margin-top: -50px;
		margin-left: -150px;
		padding: 10px;
		z-index: 1000;
		
		display: none;
	}
	
	.pagination {
		width: 100%;
	}
	
	.pagination li{
		list-style: none;
		float: left; 
	  	padding: 3px; 
	  	border: 1px solid blue;
	  	margin:3px;  
	}
	
	.pagination li a{
	  	margin: 3px;
	  	text-decoration: none;  
	}
</style>

<script src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script>
	var replyAction = {
		ADD : 0,
		DELETE : 1,
		MODIFY : 2,
		SHOW : Number.MAX_VALUE
	};
	
	function ReplyInfo(replyAction, rno) {
		this.action = replyAction;
		this.rno = rno;
	}
	
</script>

<script>
	$(document).ready(function() {
		var bno = 917482;
		var page = 1;
		
		var replyInfo = new ReplyInfo(replyAction.SHOW, Number.MIN_VALUE);
		//getAllList(replyInfo);
		getPageList(replyInfo, page);
		
/* 		
		function getAllList(replyInfo) {
			$.getJSON("/replies/all/" + bno, function(data) {
				console.log(data.length);

				var isAdd = replyInfo.action == replyAction.ADD;
				
				var str = '';
				
				$(data).each(function() {
					
					// str += "<li data-rno='" + this.rno + "' class='replyLi''>"
					//	+ this.rno + ":" + this.replytext
					//	+ "</li>";
					
					if(isAdd && replyInfo.rno == this.rno)
						str += "<li data-rno='" + this.rno + "' class='replyLi' hidden='true''>";
					else
						str += "<li data-rno='" + this.rno + "' class='replyLi''>";
					
					str += "<span>" + this.rno + ":" + this.replytext + "</span>"
						+ "<button>수정</button>"
						+ "</li>";
				});
				
				var html = $('#replies').html(str);
				
				if(isAdd) {
					html.ready(function() {
						$('#replies li[hidden=true]').slideDown();
					});
				}
			});
		}
 */
		
		function getPageList(replyInfo, page) {
			$.getJSON("/replies/" + bno + "/" + page, function(data) {
				console.log(data.list.length);

				var isAdd = replyInfo.action == replyAction.ADD;
				
				var str = '';
				
				$(data.list).each(function() {
					if(isAdd && replyInfo.rno == this.rno)
						str += "<li data-rno='" + this.rno + "' class='replyLi' hidden='true''>";
					else
						str += "<li data-rno='" + this.rno + "' class='replyLi''>";
					
					str += "<span>" + this.rno + ":" + this.replytext + "</span>"
						+ "<button>수정</button>"
						+ "</li>";
				});
				
				
				var html = $('#replies').html(str);
				
				if(isAdd) {
					html.ready(function() {
						$('#replies li[hidden=true]').slideDown();
					});
				}
				
				printPaging(data.pageMaker);
			});
		}
		
		function printPaging(pageMaker) {
			var str = '';
			
			if(pageMaker.prev)
				str += "<li><a href='"+(pageMaker.startPage-1)+"'> << </a></li>";
			
			for(var i=pageMaker.startPage ; i <= pageMaker.endPage; i++) {
				var strClass = pageMaker.cri.page == i ? 'class=active' : '';
				
				str += "<li "+strClass+"><a href='"+i+"'>"+i+"</a></li>";
			}
			
			if(pageMaker.next)
				str += "<li><a href='"+(pageMaker.endPage + 1)+"'> >> </a></li>";
			
			$('.pagination').html(str);	
		}
		
		
		/* Paging 클릭 */
		$(".pagination").on("click", "li a", function(event) {
			event.preventDefault();
			
			page = $(this).attr("href");
			
			var replyInfo = new ReplyInfo(replyAction.SHOW, Number.MIN_VALUE);
			getPageList(replyInfo, page);
		});
		
		
		
		$("#replyAddBtn").on("click", function() {
			
			var replyer = $("#newReplyWriter").val();
			var replytext = $("#newReplyText").val();
			
			$.ajax({
				type : 'post',
				url : '/replies',
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
				},
				data : JSON.stringify({
					bno : bno,
					replyer : replyer,
					replytext : replytext
				}),
				dataType : "text",
				success : function(response) {
					/* if(response != 'SUCCESS')
						return; */
						
					var obj = JSON.parse(response);	
					if(obj.message != 'SUCCESS')
						return;
						
					var replyInfo = new ReplyInfo(replyAction.ADD, obj.rno);
					//getAllList(replyInfo);
					
					page = 1;
					getPageList(replyInfo, page);
				}
			});
		});
		
		// 수정
		$("#replies").on("click", '.replyLi button', function() {
			var reply = $(this).parent();
			//var rno = reply.data('rno');
			var rno = reply.attr('data-rno');
			var replyText = reply.find('span').text();
			
			// rno 저장
			$('#modDiv .modal-title').attr("data-rno", rno);
			
			
			$('#modDiv #replytext').val(replyText);
			//$('#modDiv').show('fast');
			$('#modDiv').fadeIn('fast');
		});
		
		$('#modDiv button').on('click', function(event) {
			var id = event.target.id;

			var rno = $('#modDiv .modal-title').attr("data-rno");
			var target = $('#replies li[data-rno='+ rno +']');
			
			
			switch (id) {
				case 'replyModBtn':
					
					var replytext = $('#modDiv #replytext').val();
					
					$.ajax({
						type : 'PUT',
						url : '/replies/' + rno,
						headers : {
							"Content-Type" : "application/json",
							"X-HTTP-Method-Override" : "PUT"
						},
						data : JSON.stringify({
							replytext : replytext
						}),
						dataType : "text",
						success : function(response) {
							if(response != 'SUCCESS')
								return;

							
							// 눈속임
							var textForm = $("#replies").find('li[data-rno='+ rno +']').find('span');
							//textForm.text(replytext);
							textForm.text(rno + ":" +replytext); //임시
							
							
							target.fadeOut(0, function() {
								target.fadeIn('slow', function() {
									var replyInfo = new ReplyInfo(replyAction.MODIFY, rno);
									//getAllList(replyInfo);
									getPageList(replyInfo, page);
								});
							});
							
							$('#modDiv').fadeOut('fast');
						}
					});
					break;
					
				case 'replyDelBtn':
					
					$.ajax({
						type : 'DELETE',
						url : '/replies/' + rno,
						headers : {
							"Content-Type" : "application/json",
							"X-HTTP-Method-Override" : "DELETE"
						},
						dataType : "text",
						success : function(response) {
							if(response != 'SUCCESS')
								return;
							
							target.slideUp('fast', function() {
								// 삭제는 rno를 넘겨 처리할 필요 없음.
								var replyInfo = new ReplyInfo(replyAction.DELETE, Number.MIN_VALUE);
								//getAllList(replyInfo);		
								getPageList(replyInfo, page);		
							});
							
							$('#modDiv').fadeOut('fast');
						}
					});
					break;
					
				case 'replyCloseBtn':
					$('#modDiv').fadeOut('fast');
					break;
			}
		});
		
		$('#testbtn').click(function(e) {
			e.preventDefault();
			
			alert("" + page);
		});
	});
	
</script>
</head>
<body>
	<div id="modDiv">
		<div class="modal-title"></div>
		<div>
			<input type="text" id="replytext">
		</div>
		<div>
			<button id="replyModBtn">수정</button>
			<button id="replyDelBtn">삭제</button>
			<button id="replyCloseBtn">닫기</button>
		</div>
	</div>
	

	<div>
		<div>
			replyer <input type="text" name="replyer" id='newReplyWriter'>
		</div>
		<div>
			replytext <input type="text" name="replytext" id='newReplyText'>
		</div>
		<button id="replyAddBtn">Add Reply</button>
	</div>

	<ul id="replies">
	</ul>
	
	<ul class="pagination">
	</ul>
	
	<br>
	<br>
	<button id='testbtn'>test</button>
	
</body>
</html>