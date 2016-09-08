<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 스크롤 중(조회) 다른사람이 글을 써서 갱신된다면???
...최근 번호가 같은 지 비교하고 상단 갱신? or ...무시????... 하면 꼬임 -->
<!-- 혹은 얼굴책처럼 새 댓글 알림..하고 누르면 그만큼만 붙이기 -->

<!-- 추가시 다른 사람이 이미 추가했다면??? ...전체 갱신하면 Risk!! 10p만 보인다?
혹은 추가된 만큼만 붙이기. ...그러려면 내 화면에 보이는 가장 큰 최근 번호 필요 -->

<script src="../resources/js/handlebars4.0.5.js"></script>

<div class="row">
	<div class="col-md-12">
		
		<div class="box box-success">
			<div class="box-header">
			</div>
			
			<div class="box-body">
				<input type="text" id="newReplyWriter" placeholder="USER ID" style="margin-bottom: 5px">
				<textarea class="form-control" id="newReplyText" maxlength="100" placeholder="reply text"></textarea>
			</div>
			
			<div class="box-footer" align="right">
				<button type="submit" class="btn btn-primary">등록</button>
			</div>
			
		</div>
		
		<ul class="timeline">
			<li class="time-label" id="repliesDiv">
				<button id="topBtn" class="btn bg-green">맨 위로 가기</button>
			</li>
		</ul>
		
	</div>
</div>



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

                <div class="timeline-footer">
                    <a class="btn btn-primary btn-xs" data-toggle="modal" data-target="#modifyModal">수정</a>
                </div>

            </div>
        </li>
    {{/each}}
</script>

<script>
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
	
	var printData = function(replyArr, target, templateObject) {
		var template = Handlebars.compile(templateObject.html());
	
		var html = template(replyArr);
		target.before(html);
	}
	
	var bno = ${boardVO.bno}
	var replyPage = 1;
	var endPage = 1;
	
	function updatePage(url) {
		console.log(url);
		
		$.getJSON(url, function(data) {
		console.log(data.list.length);
			
			printData(data.list, $("#repliesDiv"), $('#template'));

			endPage = data.pageMaker.endPage;
			
			replyPage++;
		});
	}
	
	$("#topBtn").on("click", function() {
		$('html, body').animate({scrollTop: 0}, 300); 
	});
</script>
