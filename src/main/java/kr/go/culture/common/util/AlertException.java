package kr.go.culture.common.util;

public class AlertException extends Exception{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3879813289240059721L;
	private String errorMessage;
	private String redirectUrl;
	private Integer errorCode;
	public String getErrorMessage() {
		return errorMessage;
	}
	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	public String getRedirectUrl() {
		return redirectUrl;
	}
	public void setRedirectUrl(String redirectUrl) {
		this.redirectUrl = redirectUrl;
	}
	public Integer getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(Integer errorCode) {
		this.errorCode = errorCode;
	}
	
	public AlertException(){
		
	}
	
	public AlertException(String errorMessage){
		super(errorMessage);
		this.errorMessage = errorMessage;
	}
	
	public AlertException(int errorCode, String errorMessage){
		super(errorMessage);
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}
	
	public AlertException(int errorCode, String errorMessage, String redirectUrl){
		super(errorMessage);
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
		this.redirectUrl= redirectUrl;
	}
	
}
