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

	public PageMaker() {
	}
	
	public PageMaker(Criteria cri, int totalPostCount) {
		this.cri = cri;
		setTotalPostCount(totalPostCount);
	}
	
	public Criteria getCri() {
		return cri;
	}

	public void setCri(Criteria cri) {
		this.cri = cri;
	}

	public int getTotalPostCount() {
		return totalPostCount;
	}

	public void setTotalPostCount(int totalPostCount) {
		this.totalPostCount = totalPostCount;
		
		calcPaging();
	}

	private void calcPaging() {
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

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}
	
	public String makeQuery(int page) {
		UriComponents comp = UriComponentsBuilder.newInstance()
				.queryParam("page", page)
				.queryParam("postCount", cri.getPostCount())
				.build();
		
		return comp.toUriString();
	}

	@Override
	public String toString() {
		return "PageMaker [cri=" + cri + ", totalPostCount=" + totalPostCount + ", startPage=" + startPage
				+ ", endPage=" + endPage + ", prev=" + prev + ", next=" + next + ", pageCount=" + pageCount + "]";
	}
}
