package io.github.xeyez.domain;

public class NewUserVO extends UserVO {
	private String confirm;

	public String getConfirm() {
		return confirm;
	}

	public void setConfirm(String confirm) {
		this.confirm = confirm;
	}
	
	public boolean isPasswordAndConfirmSame() {
		return userpw.equals(confirm);
	}

	@Override
	public String toString() {
		return "NewUserVO [confirm=" + confirm + ", userid=" + userid + ", userpw=" + userpw + ", username=" + username
				+ ", role=" + role + "]";
	}
}
