package io.github.xeyez.domain;

public class ModifiedUserVO extends NewUserVO {
	private String userpw_new;

	public String getUserpw_new() {
		return userpw_new;
	}

	public void setUserpw_new(String userpw_new) {
		this.userpw_new = userpw_new;
	}
	
	public boolean isNewPasswordGreaterThanMinLength() {
		return userpw_new.length() >= MIN_LENGHTH;
	}

	@Override
	public String toString() {
		return "ModifiedUserVO [userpw_new=" + userpw_new + ", confirm=" + confirm + ", MIN_LENGHTH=" + MIN_LENGHTH
				+ ", userid=" + userid + ", userpw=" + userpw + ", username=" + username + ", role=" + role
				+ ", upoint=" + upoint + ", profilepath=" + profilepath + ", regdate=" + regdate + ", deative="
				+ deactive + ", deactivedate=" + deactivedate + ", withdrawal=" + withdrawal + "]";
	}
}
