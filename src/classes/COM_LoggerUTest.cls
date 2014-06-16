/*
*	The test methods will not have assertions as there is no way to assert if something was logged successfully.
*	Test methods in this class just serve as a means for code coverage. This will ensure at least there are on exceptions
*	being thrown when wierd input parameters are passed to the logger methods
*/
@isTest
public with sharing class COM_LoggerUTest {
	
	private static final String CLASS_NAME = 'COM_LoggerUTest';
	private static final String METHOD_NAME = 'someMethod';
	private static final String MSG = 'Some message to be logged.';
	private static final Exception EX = new COM_Exception('Some exception');
	
	static testMethod void constructorTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		system.assertNotEquals(null, logger);
		final COM_Logger loggerNoClass = new COM_Logger(null);
		system.assertNotEquals(null, loggerNoClass);
	}
	
	static testMethod void errorTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		logger.error(null);
		logger.error(MSG);
		logger.error(EX);
		logger.error(null, null);
		logger.error(MSG, null);
		logger.error(MSG, EX);
		logger.error(null, EX);
	}
	
	static testMethod void warnTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		logger.warn(null);
		logger.warn(MSG);
		logger.warn(EX);
		logger.warn(null, null);
		logger.warn(MSG, null);
		logger.warn(MSG, EX);
		logger.warn(null, EX);
	}
	
	static testMethod void infoTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		logger.info(null);
		logger.info(MSG);
		logger.info(EX);
	}
	
	static testMethod void debugTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		logger.debug(null);
		logger.debug(MSG);
		logger.debug(EX);
	}
	
	static testMethod void fineTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		logger.fine(null);
		logger.fine(MSG);
		logger.fine(EX);
	}
	
	static testMethod void finerTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		logger.finer(null);
		logger.finer(MSG);
		logger.finer(EX);
	}
	
	static testMethod void finestTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		logger.finest(null);
		logger.finest(MSG);
		logger.finest(EX);
	}
	
	static testMethod void entryTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		logger.entry(null);
		logger.entry(METHOD_NAME);
	}

	static testMethod void exitTest() {
		final COM_Logger logger = new COM_Logger(CLASS_NAME);
		logger.exit(null);
		logger.exit(METHOD_NAME);
	}

}