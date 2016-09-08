package io.github.xeyez.domain;

import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

public class Criteria {
	private long page;
	private int postCount;
	
	public Criteria() {
		page = 1;
		postCount = 10;
	}

	public long getPage() {
		return page;
	}

	public void setPage(long page) {
		this.page = page < 1 ? 1 : page;
	}

	public int getPostCount() {
		return postCount;
	}

	public void setPostCount(int postCount) {
		this.postCount = postCount < 1 || postCount > 100 ? 10 : postCount;
	}
	
	public long getPostStart() {
		return (this.page - 1) * postCount;
	}
	
	public String makeQuery() {
		UriComponents comp = UriComponentsBuilder.newInstance()
				.queryParam("page", this.page)
				.queryParam("postCount", this.postCount)
				.build();
		
		return comp.toUriString();
	}

	@Override
	public String toString() {
		return "Criteria [page=" + page + ", postCount=" + postCount + "]";
	}
}
