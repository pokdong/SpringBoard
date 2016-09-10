package io.github.xeyez.domain;

import java.util.Arrays;
import java.util.Date;

public class BoardVO {
	private long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private long modcnt;
	private long viewcnt;
	private long replycnt;
	
	private long goodcnt;
	private long badcnt;
	
	private String[] files;
	
	public BoardVO() {
	}
	
	
	public BoardVO(long bno) {
		this.bno = bno;
	}
	
	public BoardVO(String title, String content, String writer) {
		this.title = title;
		this.content = content;
		this.writer = writer;
	}
	
	public BoardVO(int bno, int viewcnt) {
		this.bno = bno;
		this.viewcnt = viewcnt;
	}
	
	
	public long getBno() {
		return bno;
	}
	public void setBno(long bno) {
		this.bno = bno;
	}
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	
	public long getModcnt() {
		return modcnt;
	}
	public void setModcnt(long modcnt) {
		this.modcnt = modcnt;
	}

	public long getViewcnt() {
		return viewcnt;
	}
	public void setViewcnt(long viewcnt) {
		this.viewcnt = viewcnt;
	}
	
	public long getReplycnt() {
		return replycnt;
	}
	public void setReplycnt(long replycnt) {
		this.replycnt = replycnt;
	}

	public long getGoodcnt() {
		return goodcnt;
	}
	public void setGoodcnt(long goodcnt) {
		this.goodcnt = goodcnt;
	}
	
	public long getBadcnt() {
		return badcnt;
	}
	public void setBadcnt(long badcnt) {
		this.badcnt = badcnt;
	}
	
	public String[] getFiles() {
		return files;
	}
	public void setFiles(String[] files) {
		this.files = files;
	}

	@Override
	public String toString() {
		return "BoardVO [bno=" + bno + ", title=" + title + ", content=" + content + ", writer=" + writer + ", regdate="
				+ regdate + ", modcnt=" + modcnt + ", viewcnt=" + viewcnt + ", replycnt=" + replycnt + ", goodcnt="
				+ goodcnt + ", badcnt=" + badcnt + ", files=" + Arrays.toString(files) + "]";
	}
}