package io.github.xeyez.domain;

import java.sql.Date;

public class UserVO {
	protected String userid;
	protected String userpw;
	protected String username;
	protected String role;
	protected long upoint;
	protected String profilepath;
	protected Date regdate;
	
	public UserVO() {
	}
	
	public UserVO(String userid, String userpw, String username) {
		this.userid = userid;
		this.userpw = userpw;
		this.username = username;
		this.role = "USER";
	}
	
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
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
		this.role = role;
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

	@Override
	public String toString() {
		return "UserVO [userid=" + userid + ", userpw=" + userpw + ", username=" + username + ", role=" + role
				+ ", upoint=" + upoint + ", profilepath=" + profilepath + ", regdate=" + regdate + "]";
	}
}
