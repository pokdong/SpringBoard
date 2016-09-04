package io.github.xeyez.domain;

public class Criteria {
	private int page;
	private int postCount;
	
	public Criteria() {
		page = 1;
		postCount = 10;
	}
	
	public Criteria(int page, int postCount) {
		this.page = page;
		this.postCount = postCount;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page < 1 ? 1 : page;
	}

	public int getPostCount() {
		return postCount;
	}

	public void setPostCount(int postCount) {
		this.postCount = postCount < 1 || postCount > 100 ? 10 : postCount;
	}
	
	public int getPostStart() {
		return (this.page - 1) * postCount;
	}

	@Override
	public String toString() {
		return "Criteria [page=" + page + ", postCount=" + postCount + "]";
	}
}
