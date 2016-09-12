package io.github.xeyez.security;

@SuppressWarnings("serial")
public class UnavailableIDException extends RuntimeException {
	public UnavailableIDException(String message) {
		super(message);
	}
}
