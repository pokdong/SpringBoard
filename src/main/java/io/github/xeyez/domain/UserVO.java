package io.github.xeyez.domain;

public class UserVO {
	String userid;
	String userpw;
	String username;
	String role;
	
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
	
	@Override
	public String toString() {
		return "UserVO [userid=" + userid + ", userpw=" + userpw + ", username=" + username + ", role=" + role + "]";
	}
}
