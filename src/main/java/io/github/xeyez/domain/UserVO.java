package io.github.xeyez.domain;

import java.util.Date;

public class UserVO {
	protected String userid;
	protected String userpw;
	protected String username;
	protected String role;
	protected long upoint;
	protected String profilepath;
	protected Date regdate;
	
	protected boolean deactive;
	protected Date deactivedate;
	protected boolean withdrawal;
	
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid.toLowerCase();
	}
	
	public String getUserpw() {
		return userpw;
	}
	public void setUserpw(String userpw) {
		this.userpw = userpw;
	}
	
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role.toUpperCase();
	}

	public long getUpoint() {
		return upoint;
	}
	public void setUpoint(long upoint) {
		this.upoint = upoint;
	}

	public String getProfilepath() {
		return profilepath;
	}
	public void setProfilepath(String profilepath) {
		this.profilepath = profilepath;
	}

	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	
	
	public boolean isDeactive() {
		return deactive;
	}
	public void setDeactive(int deative) {
		this.deactive = (deative == 1);
	}
	
	public Date getDeactivedate() {
		return deactivedate;
	}
	public void setDeactivedate(Date deactivedate) {
		this.deactivedate = deactivedate;
	}
	
	public boolean isWithdrawal() {
		return withdrawal;
	}
	public void setWithdrawal(int withdrawal) {
		this.withdrawal = (withdrawal == 1);
	}
	
	
	@Override
	public String toString() {
		return "UserVO [userid=" + userid + ", userpw=" + userpw + ", username=" + username + ", role=" + role
				+ ", upoint=" + upoint + ", profilepath=" + profilepath + ", regdate=" + regdate + ", deactive="
				+ deactive + ", deactivedate=" + deactivedate + ", withdrawal=" + withdrawal + "]";
	}
}
