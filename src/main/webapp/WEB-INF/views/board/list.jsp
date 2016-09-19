<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>

<%@include file="../include/header.jsp" %>

    <!-- Main content -->
	<section class="content">
    	<div class="row">
    	
	    	<!-- left column -->
	    	<div class="col-md-12">
	    		<!-- general form elements -->
	  			<div class="box">
		            <div class="box-header with-border">
		            	<h3 class="box-title">LIST</h3>
		            	
		            	<div style="position: relative; float: right;">
							<button class="btn btn-primary" id='newBtn' style="font-weight: bold;">글쓰기</button>
						</div>
		            </div>
		            

<!-- Content -->
					<div class="box-body">
					
<table class="table table-bordered"> <!-- table 자동 여백 맞춤 -->
	<tr>
		<th style="width: 70px">번호</th>
		<th>제목</th>
		<th>작성자</th>
		<th>날짜</th>
		<th style="width: 100px">조회</th>
	</tr>
	
<c:forEach items="${list}" var="boardVO">
	<tr>
		<td>${boardVO.bno}</td>
		<td>
			<a href="/board/read${pageMaker.makeSearchQuery(boardVO.bno, pageMaker.cri.page)}&reply=false">${boardVO.title}</a>
			
			<c:if test="${boardVO.replycnt > 0}">
				<a href="/board/read${pageMaker.makeSearchQuery(boardVO.bno, pageMaker.cri.page)}&reply=true"><strong><small>[${boardVO.replycnt}]</small></strong></a>
			</c:if>
			<c:if test="${boardVO.filescnt > 0}">
				<img src="/resources/xeyez/images/attach_small.png">
			</c:if>
		</td>
		<td>${boardVO.writer}</td>
		<td><fmt:formatDate value="${boardVO.regdate}" pattern="yyyy-MM-dd HH:mm" /></td>
		<td><span class="badge bg-red">${boardVO.viewcnt }</span></td>
	</tr>
</c:forEach>
	
</table>
					
					
					</div>

					<div class="box-footer">

<div class="text-center">
	<ul class="pagination">
		<c:if test="${pageMaker.prev}">
			<li><a href="list${pageMaker.makeSearchQuery(pageMaker.startPage - 1)}">&laquo;</a></li>
		</c:if>
		
		<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
			<li <c:out value="${pageMaker.cri.page == idx ? 'class = active' : ''}"/>>
				<a href="list${pageMaker.makeSearchQuery(idx)}">${idx}</a>
			</li>
		</c:forEach>
		
		<c:if test="${pageMaker.next}">
			<li><a href="list${pageMaker.makeSearchQuery(pageMaker.endPage + 1)}">&raquo;</a></li>
		</c:if>
	</ul>
</div>

<div class="box-body">
	<div style="text-align: center;">
		<select name="searchType">
			<option value="n" <c:out value="${cri.searchType == null?'selected':''}"/>>
				-</option>
			<option value="t" <c:out value="${cri.searchType eq 't'?'selected':''}"/>>
				제목</option>
			<option value="c" <c:out value="${cri.searchType eq 'c'?'selected':''}"/>>
				내용</option>
			<option value="w" <c:out value="${cri.searchType eq 'w'?'selected':''}"/>>
				닉네임</option>
			<option value="tc" <c:out value="${cri.searchType eq 'tc'?'selected':''}"/>>
				제목+내용</option>
			<option value="cw" <c:out value="${cri.searchType eq 'cw'?'selected':''}"/>>
				제목+닉네임</option>
			<option value="tcw" <c:out value="${cri.searchType eq 'tcw'?'selected':''}"/>>
				제목+내용+닉네임</option>
		</select>
	
		<input type="text" name='keyword' id="keywordInput" maxlength="20" value='${cri.keyword }'>
		<button class="btn btn-primary" id='searchBtn'>검색</button>
	</div>
	
</div>


		            </div>
		            
		        </div>
	        </div>
        
      	</div>
   	</section>
   	
	</div>
    
    
    
    
<script>
	
	$(document).ready(function() {
		
		$('#searchBtn').on("click",	function(ev) {
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

		$('#newBtn').on("click", function(ev) {
			var query = '${pageMaker.makeQueryForWrite()}'
			
			self.location = "write" + query;
		});
		
		
		if('${auth}' == 'error') {
			alert('권한이 없습니다.');
		}
	})
	
</script>
    
<%@include file="../include/footer.jsp" %>