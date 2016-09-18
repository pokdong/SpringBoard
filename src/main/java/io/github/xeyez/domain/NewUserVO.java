package io.github.xeyez.domain;

public class NewUserVO extends UserVO {
	private String confirm;

	private final int MIN_LENGHTH = 8;
	
	public String getConfirm() {
		return confirm;
	}

	public void setConfirm(String confirm) {
		this.confirm = confirm;
	}
	
	public boolean isPasswordAndConfirmSame() {
		return userpw.equals(confirm);
	}
	
	public boolean isPasswordGreaterThanMinLength() {
		return isPasswordAndConfirmSame() && (userpw.length() >= MIN_LENGHTH);
	}

	@Override
	public String toString() {
		return "NewUserVO [confirm=" + confirm + ", userid=" + userid + ", userpw=" + userpw + ", username=" + username
				+ ", role=" + role + "]";
	}
}
