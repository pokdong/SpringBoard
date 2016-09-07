package io.github.xeyez.domain;

import java.util.Date;

public class ReplyVO {
	private long rno;
	private long bno;
	private String replytext;
	private String replyer;
	private Date regdate;
	private Date updatedate;
	private long modcnt;
	
	private long goodcnt;
	private long badcnt;
	
	public long getRno() {
		return rno;
	}
	public void setRno(long rno) {
		this.rno = rno;
	}
	public long getBno() {
		return bno;
	}
	public void setBno(long bno) {
		this.bno = bno;
	}
	public String getReplytext() {
		return replytext;
	}
	public void setReplytext(String replytext) {
		this.replytext = replytext;
	}
	public String getReplyer() {
		return replyer;
	}
	public void setReplyer(String replyer) {
		this.replyer = replyer;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	public Date getUpdatedate() {
		return updatedate;
	}
	public void setUpdatedate(Date updatedate) {
		this.updatedate = updatedate;
	}
	
	public long getModcnt() {
		return modcnt;
	}
	public void setModcnt(long modcnt) {
		this.modcnt = modcnt;
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
	
	@Override
	public String toString() {
		return "ReplyVO [rno=" + rno + ", bno=" + bno + ", replytext=" + replytext + ", replyer=" + replyer
				+ ", regdate=" + regdate + ", updatedate=" + updatedate + ", modcnt=" + modcnt + ", goodcnt=" + goodcnt
				+ ", badcnt=" + badcnt + "]";
	}
}
