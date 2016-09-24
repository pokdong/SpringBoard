package io.github.xeyez.domain;

public class NewUserVO extends UserVO {
	protected String confirm;

	protected final int MIN_LENGHTH = 8;
	
	//admin 페이지에서 처음 admin 가입시 이용.
	private boolean adminExists = true;
	
	//관리자에 의해 사용자가 생성/삭제/수정 되는가?
	private boolean controlbyAdmin = false;
	
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
	
	public boolean isAdminExists() {
		return adminExists;
	}

	public void setAdminExists(boolean adminExists) {
		this.adminExists = adminExists;
	}

	public boolean isControlbyAdmin() {
		return controlbyAdmin;
	}

	public void setControlbyAdmin(boolean controlbyAdmin) {
		this.controlbyAdmin = controlbyAdmin;
	}

	@Override
	public String toString() {
		return "NewUserVO [confirm=" + confirm + ", MIN_LENGHTH=" + MIN_LENGHTH + ", userid=" + userid + ", userpw="
				+ userpw + ", username=" + username + ", role=" + role + ", upoint=" + upoint + ", profilepath="
				+ profilepath + ", regdate=" + regdate + "]";
	}
}
