package io.github.xeyez.domain;

import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

public class PageMaker {
	private Criteria cri;
	
	private int totalPostCount;
	private int startPage;
	private int endPage;
	private boolean prev;
	private boolean next;
	
	private int pageCount = 10;
	
	public void calcPaging(Criteria cri, int totalPostCount) {
		this.cri = cri;
		this.totalPostCount = totalPostCount;
		
		// 하단 Paging 전체 개수 (= 마지막 Paging 번호)
		int totalPageCount = (int) Math.ceil(totalPostCount / (double) cri.getPostCount());
		
		// 하단 Paging 묶음 개수 (10개씩 보인다면 1~10, 11~21, ...)
		int totalPageSet = (int) Math.ceil(totalPageCount / (double) pageCount);
		
		// 현재 속한 Paging 묶음
		int currentPageSet = (int) Math.ceil(cri.getPage() / (double) pageCount);
		
		startPage = (pageCount * (currentPageSet - 1)) + 1;
		
		// 마지막 Page (마지막 Page 처리되지 않음) 
		// (하단에 10개씩 보일 때, 현재 속한 pageSet이 2이면 마지막 Page는 20.)
		endPage = pageCount * currentPageSet;
		
		// 마지막 Page일 때 예외 처리
		if(endPage > totalPageCount)
			endPage = totalPageCount;
		
		prev = startPage != 1;
		next = (currentPageSet < totalPageSet) && endPage > 0;
	}
	
	public void setPageCount(int pageCount) {
		if(pageCount < 10)
			pageCount = 10;
		else if(pageCount > 30)
			pageCount = 30;
		
		this.pageCount = pageCount;
	}
	
	// 검색시 사용
	public String makeQuery(int page) {
		UriComponents comp = UriComponentsBuilder.newInstance()
				.queryParam("page", page)
				.queryParam("postCount", cri.getPostCount())
				.queryParam("pageCount", pageCount)
				.build();
		
		return comp.toUriString();
	}
	
	public String makeSearchQuery(int page) {
		SearchCriteria sCri = (SearchCriteria) cri;
		
		UriComponentsBuilder compBuilder = UriComponentsBuilder.newInstance()
				.queryParam("page", page)
				.queryParam("postCount", sCri.getPostCount())
				.queryParam("pageCount", pageCount);
		
		String searchType = sCri.getSearchType();
		String keyword = sCri.getKeyword();
		
		if(searchType != null && keyword != null) {
			if(!searchType.isEmpty() && !keyword.isEmpty()) {
				compBuilder.queryParam("searchType", sCri.getSearchType())
				.queryParam("keyword", sCri.getKeyword());
			}
		}
		
		return compBuilder.build().toUriString();
	}
	
	//수정에서 취소누를 때 사용
	public String makeSearchQuery() {
		SearchCriteria sCri = (SearchCriteria) cri;
		
		UriComponentsBuilder compBuilder = UriComponentsBuilder.newInstance()
				.queryParam("page", sCri.getPage())
				.queryParam("postCount", sCri.getPostCount())
				.queryParam("pageCount", pageCount);
		
		String searchType = sCri.getSearchType();
		String keyword = sCri.getKeyword();
		
		if(searchType != null && keyword != null) {
			if(!searchType.isEmpty() && !keyword.isEmpty()) {
				compBuilder.queryParam("searchType", sCri.getSearchType())
				.queryParam("keyword", sCri.getKeyword());
			}
		}
		
		return compBuilder.build().toUriString();
	}
	
	// 게시글 클릭시 이용
	public String makeSearchQuery(int bno, int page) {
		SearchCriteria sCri = (SearchCriteria) cri;
		
		UriComponentsBuilder compBuilder = UriComponentsBuilder.newInstance()
				.queryParam("bno", bno)
				.queryParam("page", page)
				.queryParam("postCount", sCri.getPostCount())
				.queryParam("pageCount", pageCount);
		
		String searchType = sCri.getSearchType();
		String keyword = sCri.getKeyword();
		
		if(searchType != null && keyword != null) {
			if(!searchType.isEmpty() && !keyword.isEmpty()) {
				compBuilder.queryParam("searchType", sCri.getSearchType())
				.queryParam("keyword", sCri.getKeyword());
			}
		}
		
		return compBuilder.build().toUriString();
	}

	public Criteria getCri() {
		return cri;
	}
	
	public int getTotalPostCount() {
		return totalPostCount;
	}
	
	public int getStartPage() {
		return startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public boolean isPrev() {
		return prev;
	}

	public boolean isNext() {
		return next;
	}

	public int getPageCount() {
		return pageCount;
	}

	@Override
	public String toString() {
		return "PageMaker [cri=" + cri + ", totalPostCount=" + totalPostCount + ", startPage=" + startPage
				+ ", endPage=" + endPage + ", prev=" + prev + ", next=" + next + ", pageCount=" + pageCount + "]";
	}
}
