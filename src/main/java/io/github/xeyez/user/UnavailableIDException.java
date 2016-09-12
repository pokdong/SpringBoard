package io.github.xeyez.user;

@SuppressWarnings("serial")
public class UnavailableIDException extends RuntimeException {
	public UnavailableIDException(String message) {
		super(message);
	}
}
