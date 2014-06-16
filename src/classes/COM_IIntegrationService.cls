/*

@author: Sukrut Wagh

@description:
Integration framework is a custom PRA framework developed to perform integrations with external
systems (mainly on-premises) in a standard & reusable fashion.

It is a lean framework consisting sObjects starting with INT_* & some common services (COM_Integration*)
that interact with these sObjects.

The idea is to administratively enable sObject types for integrations. Write 'integration services' that encapsulate the
business logic for making the external invocations. By nature, majority of the integrations are web services based & will deal with callouts.
As a practice, to align to apex's 'bulk processing' nature & get around the governer limits, 
the external web services should be designed for processing bulk records.

Typically, an integration service will have the below three lifecycle phases:
1. Prepare		: Any pre-processing/initilization is performed in this phase
2. Invoke		: External invocations are performed. E.g: callouts via the SOAP or HttpClient Wrappers  
3. processResult: In case of synchronous operations, the results are processed. This could be persisting the response, notifying someone, etc.

Note:
1. An concrete implementation of the integration service class must follow the below class name convention:
<PROJECT_PREFIX>_<INTEGRATION_SYSTEM_NAME><SOBJECT_APINAME>IS
Examples:
CM_ETMFApttusAptsAgreementIS
CM_CTMSApttusAptsAgreementIS

2. Default no-arg constructor is necessary

For further details, please refer -> COM_ServiceFactory:getISClassName

*/
public interface COM_IIntegrationService {

	/* Integration system */	
	String getIntSystem();
	
	/* API name for sObjType to be integrated */
	String getSObjectType();
	
	/* Due to the lack of reflection API in Apex to pass constructor args, making the setters public. Refer COM_ServiceFactory */
	void setIntSystem(final String intSystem);
	void setSObjectType(final String sObjType);
	
	/*
	*	Query to fetch the records to be processed
	*	This will be used during the batch execution mode
	*/
	String getProcessingQuery();
	
	/* Comma or semi-colon separated email addressess	
	   Optionally, recipients to include for sending out emails to notify job completion
	*/
	String getEmailRecipients();
	
	/*	Optionally, service may choose to perform any pre-processing in this method
	*/
	void prepare();
	
	/*	Service processing/execution happens. Processing could mean different things for different services.
		Some might execute business logic within sfdc context, some might execute callouts & so forth.  
		@scope:		Records to be processed
	*/
	COM_ServiceResult invoke(List<sObject> scope);
	
	/*	Optionally, service may perform any post processing on the results
	*/	
	Boolean processResult(List<COM_ServiceResult> results);
}