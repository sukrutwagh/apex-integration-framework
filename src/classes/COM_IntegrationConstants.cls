public with sharing class COM_IntegrationConstants {
	
	//TODO: Define & read the constants from an CustomSetting 
	
	/*	Register all the integration system types & systems here */
	public static final String INT_SYSTEM_TYPE_ETMF = 'ETMF';
	public static final String INT_SYSTEM_TYPE_CTMS = 'CTMS';
	
	/* Despite the system type & systems are same here (an co-incidence), they mean different things.
	   Think of a scenario where you have to integrate with multiple systems of the same family/type.
	   Example, you have multiple CTMS instances. 
	*/
	public static final String INT_SYSTEM_ETMF = 'ETMF';
	public static final String INT_SYSTEM_CTMS = 'CTMS';
	
	/* sObject API Name */
	public static final String API_INT_SETUP = 'INT_SETUP__c';
	public static final String API_INT_SETUP_STATUS = 'INT_SETUP_STATUS__c';
	public static final String API_APTTUS_APTS_AGREEMENT = 'Apttus__APTS_Agreement__c';
	
	/* Integration Statuses	*/
	/* Record is in-sync with the integrated system.
	*  Whenever the transaction (synchronous or asynchronous) is successful, record will be in-sync status 
	*/
	public static final String STATUS_INSYNC = 'INSYNC';
	/* Record is not in sync with the integrated system
	*  TODO: List the scenarios for this status 
	*/
	public static final String STATUS_OUTSYNC = 'OUTSYNC';
	/* Record errored out. The exception/error field should indicate the failure reasons
	*  There could be various possibilities for this status:
	*  1. Validation failures before making the integration transaction
	*  2. Integration transaction retuned specific errors, possibly with error codes & reasons
	*  3. TODO: Add additional scenarios
	*
	*  Some errors might be unrecoverable & might need to bring in to attention by an email notification
	*   
	*/
	public static final String STATUS_ERROR = 'ERROR';
	
	/*Record is in-transit with the integrated system. Means the transaction is in process / request was sent.
	* In case of an asynchronous integration (most of the WS will be designed for bulk processing),
	* it might take hours for the external system to respond back & update the record with appropriate status.
	*/
	public static final String STATUS_TRANSIT_ADD = 'TRANSIT_ADD';
	public static final String STATUS_TRANSIT_UPDATE = 'TRANSIT_UPDATE';
	public static final String STATUS_TRANSIT_DELETE = 'TRANSIT_DELETE';
	
	/* Comma or semi-colon separated email addressess	*/
	public static final String EMAIL_RECIPIENT = 'waghsukrut@praintl.com';

}