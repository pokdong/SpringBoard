<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>

<%@include file="../include/header2.jsp" %>

<div>
	<div class="row table-head">
	  <div class="col s1">번호</div>
	  <div class="col s6">제목</div>
	  <div class="col s2">작성자</div>
	  <div class="col s2">날짜</div>
	  <div class="col s1">조회</div>
	</div>
	
	<c:forEach items="${list}" var="boardVO">
		<div class="row table-content">
		  <div class="col s1 text-center">${boardVO.bno}</div>
		  <div class="col s6">
		  	<a href="/board/read${pageMaker.makeSearchQuery(boardVO.bno, pageMaker.cri.page)}&reply=false">${boardVO.title}</a>
				
			<c:if test="${boardVO.replycnt > 0}">
				<a href="/board/read${pageMaker.makeSearchQuery(boardVO.bno, pageMaker.cri.page)}&reply=true"><strong><small>[${boardVO.replycnt}]</small></strong></a>
			</c:if>
			<c:if test="${boardVO.filescnt > 0}">
				<img src="/resources/xeyez/images/attach_small.png">
			</c:if>
		  </div>
		  <div class="col s2 text-center">${boardVO.writer}</div>
		  <div class="col s2 text-center"><fmt:formatDate value="${boardVO.regdate}" pattern="yyyy-MM-dd HH:mm" /></div>
		  <div class="col s1 text-center"><span class="bg-round">${boardVO.viewcnt}</span></div>
		</div>
	</c:forEach>
</div>

<div class="pagination-container">
	<ul class="pagination">
		<c:if test="${pageMaker.prev}">
			<li>
				<a href="list${pageMaker.makeSearchQuery(pageMaker.startPage - 1)}">
					<i class="material-icons">chevron_left</i>
				</a>
			</li>
		</c:if>
		
		<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
			<li <c:out value="${pageMaker.cri.page == idx ? 'class = active' : ''}"/>>
				<a href="list${pageMaker.makeSearchQuery(idx)}">${idx}</a>
			</li>
		</c:forEach>
		
		<c:if test="${pageMaker.next}">
			<li>
				<a href="list${pageMaker.makeSearchQuery(pageMaker.endPage + 1)}">
					<i class="material-icons">chevron_right</i>
				</a>
			</li>
		</c:if>
	</ul>
</div>


<!-- Modal Structure -->
<div id="modal1" class="modal bottom-sheet">
  <div class="modal-content">
    
    <div class="row">
		<div class="col s2">
			<select name="searchType" class="browser-default">
				<option value="n" <c:out value="${cri.searchType == null?'selected':''}"/>>-</option>
				<option value="t" <c:out value="${cri.searchType eq 't'?'selected':''}"/>>제목</option>
				<option value="c" <c:out value="${cri.searchType eq 'c'?'selected':''}"/>>내용</option>
				<option value="w" <c:out value="${cri.searchType eq 'w'?'selected':''}"/>>닉네임</option>
				<option value="tc" <c:out value="${cri.searchType eq 'tc'?'selected':''}"/>>제목+내용</option>
				<option value="cw" <c:out value="${cri.searchType eq 'cw'?'selected':''}"/>>제목+닉네임</option>
				<option value="tcw" <c:out value="${cri.searchType eq 'tcw'?'selected':''}"/>>제목+내용+닉네임</option>
			</select>
		</div>
		
		<div class="col s8">
	      <input type="text" name='keyword' id="keywordInput" maxlength="20" value='${cri.keyword }'>
	    </div>
	
		<button class="col s2 waves-effect waves-light btn blue" id='btn-search'>
			<i class="material-icons">search</i>
		</button>
	</div>
    
  </div>
</div>


<div class="fixed-action-btn click-to-toggle">
  <a class="btn-floating btn-large red">
    <i class="large material-icons">keyboard_arrow_up</i>
  </a>
  <ul>
    <li><a class="btn-floating green" id="fab-write"><i class="material-icons">mode_edit</i></a></li>
    <li><a class="btn-floating blue" id="fab-search"><i class="material-icons">search</i></a></li>
  </ul>
</div>


<script>
$( document ).ready(function(){
	$('.modal').modal({
      dismissible: true, // Modal can be dismissed by clicking outside of the modal
      opacity: .5, // Opacity of modal background
      inDuration: 300, // Transition in duration
      outDuration: 200, // Transition out duration
      startingTop: '4%', // Starting top style attribute
      endingTop: '10%', // Ending top style attribute
      ready: function(modal, trigger) { // Callback for Modal open. Modal and trigger parameters available.
        //alert("Ready");
        console.log(modal, trigger);
      },
      complete: function() {
    	  
      } // Callback for Modal close
    });
	
	$('#fab-search').on('click', function(event) {
		 $('.fixed-action-btn').closeFAB();
	  	 $('#modal1').modal('open');
	});
	
	
	$('#btn-search').on("click", function(ev) {
		var searchType = $("select option:selected").val()
		var keyword = $('#keywordInput').val().replace(/(^\s*)|(\s*$)/gi, "");
		
		var isNotSelectedSearchType = searchType == 'n';
		var isEmptyKeyword = keyword.length <= 0;
		
		if(isNotSelectedSearchType && isEmptyKeyword) {
			alert('검색 유형을 선택하고, 검색어를 입력하세요.');
			return;
		}
		else if(isNotSelectedSearchType) {
			alert('검색 유형을 선택하세요.');
			return;
		}
		else if(isEmptyKeyword) {
			alert('검색어를 입력하세요.');
			return;
		}
		
		var query = '${pageMaker.makeQuery(1)}'
					+ "&searchType=" + searchType
					+ "&keyword=" + keyword;
		
		self.location = "list" + query;
	});

	$('#fab-write').on("click", function(ev) {
		var query = '${pageMaker.makeQueryForWrite()}'
		
		self.location = "write" + query;
	});
	
	
	if('${auth}' == 'error') {
		alert('권한이 없습니다.');
	}
})
</script>
    
<%@include file="../include/footer2.jsp" %>