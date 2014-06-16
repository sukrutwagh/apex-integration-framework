/*
*	@author: 		Sukrut Wagh
*	@description:	Logger Wrapper providing methods to log consistently
*	@usage:			
*					Declare your logger instance in the class:
*					private static final COM_Logger logger = new COM_Logger('MyClass');
*
*					Inside your method, declare a local variable that holds the method name
*					String method = 'my_method_1';
*					logger.entry(method);
*					try {
*						logger.info('Message to log');
*					} catch (SomeException ex) {
*						logger.error('Message to log', ex);
*					}
*					logger.exit(method);
*   
*/
global class COM_Logger {

	private static final String LOG_FORMAT_PREFIX = '**************';
	private static final String LOG_FORMAT_SUFFIX = '**************';
	private static final String LOG_FORMAT_ENTRY = '-------------->';
	private static final String LOG_FORMAT_EXIT = '<--------------';
	
	private String className;

	public String getClassName() {
		return this.className;
	}

	public COM_Logger(final String className) {
		this.className = className;
	}

	public void error(final Object msg) {
			this.error(msg, null);
	}
	
	public void error(final Object msg, final Exception ex) {
		system.debug(System.Logginglevel.ERROR, getMsgStr(msg,ex));
	}
	
	public void warn(final Object msg) {
		this.warn(msg, null);
	}
	
	public void warn(final Object msg, final Exception ex) {
		system.debug(System.LoggingLevel.WARN, getMsgStr(msg,ex));
	}
	
	public void info(final Object msg) {
		system.debug(System.LoggingLevel.INFO, getMsgStr(msg));
	}
	
	public void debug(final Object msg) {
		system.debug(getMsgStr(msg));
	}
	
	public void fine(final Object msg) {
		system.debug(System.LoggingLevel.FINE, getMsgStr(msg));
	}
	
	public void finer(final Object msg) {
		system.debug(System.LoggingLevel.FINER, getMsgStr(msg));
	}
	
	public void finest(final Object msg) {
		system.debug(System.LoggingLevel.FINEST, getMsgStr(msg));
	}
	
	public void entry(final String methodName) {
		system.debug(getMsgStr(LOG_FORMAT_ENTRY+methodName));
	}

	public void exit(final String methodName) {
		system.debug(getMsgStr(LOG_FORMAT_EXIT+methodName));
	}
	
	private String getMsgStr(final Object msg) {
		return getMsgStr(msg,null);
	}
	
	private String getMsgStr(final Object msg, final Exception ex) {
		String msgStr = LOG_FORMAT_PREFIX+':'+this.className+':';
		if(null != msg) {
			if(msg instanceof Exception) {
				Exception e = ((Exception)msg);
				msgStr += 'Exception:Message:'+e.getMessage()+'\n';
				msgStr += 'Exception:Trace:'+e.getStackTraceString()+'\n';
			} else {
				msgStr += msg;
			}
		}
		if(null != ex) {
			msgStr += 'Exception:Message:'+ex.getMessage()+'\n';
			msgStr += 'Exception:Trace:'+ex.getStackTraceString()+'\n';
		}
		msgStr += ':'+LOG_FORMAT_SUFFIX;
		return msgStr;
	}

}