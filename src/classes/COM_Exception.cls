/*
*	@author: 		Sukrut Wagh
*	@description:	Custom Exception class defined for error code support
*/

public class COM_Exception extends Exception {

	private COM_ErrorCode code;
	
	public COM_ErrorCode getCode() {
		return this.code;
	}
	
	public COM_Exception(COM_ErrorCode code,String message) {
		this.setMessage(message);
		this.code = code;
	}
	
	public COM_Exception(COM_ErrorCode code, String message, Exception cause) {
		this.setMessage(message);
		this.code = code;
		this.initCause(cause);
	}
	
}