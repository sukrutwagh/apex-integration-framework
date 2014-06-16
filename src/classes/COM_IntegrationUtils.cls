/*

@author: Sukrut Wagh

Utility providing helper methods for sObjects related to integration framework.
Integration framework is a custom PRA framework developed to perform integrations with external
systems (mainly on-premises) in a standard & reusable fashion.

It is a lean framework consisting sObjects starting with INT_* & some common services (COM_Integration*)
that interact with these sObjects.

The idea is to administratively enable sObject types for integrations. Write 'integration services' that encapsulate the
business logic for making the external invocations. By nature, majority of the integrations are web services based & will deal with callouts.
As a practice, to align to apex's 'bulk processing' nature & get around the governer limits, 
the external web services should be designed for processing bulk records.

*/
public class COM_IntegrationUtils {
	
	private static final String SEMICOLON = ';';
	private static final String COMMA = ',';
	private COM_IntegrationUtils() {}
	private static final COM_Logger LOGGER = new COM_Logger('COM_IntegrationUtils'); 
	
	/**
	* Returns all the integration setups
	* @author	Sukrut Wagh
	* @allowed	allowed schedulables			optional. List of allowed schedulables. 
	* 											Please refer sObject-INT_SETUP__c definition for details 
	* @return	Set<INT_SETUP__c>		Returns all the integration setups
	*/
	public static Set<INT_SETUP__c> getSetups(final List<String> allowed) {
		List<INT_SETUP__c> setups = COM_SObjectUtils.getSelectedFieldsByDynamicSOQL(getIntSetupSelectFields(),COM_IntegrationConstants.API_INT_SETUP, 
		getIntSetupWhereClause(allowed, null, null, null), Limits.getLimitQueryRows());
		return new Set<INT_SETUP__c>(setups);
	}
	
	/**
	* Returns the integration setups
	* @author	Sukrut Wagh
	* @allowed	allowed schedulables			optional. List of allowed schedulables. 
	* 											Please refer sObject-INT_SETUP__c definition for details 	
	* @param	sysType							Integration system type	
	* @return	Set<INT_SETUP__c>		
	*/
	public static Set<INT_SETUP__c> getSetupsForSystemType(final List<String> allowed,final String sysType) {
		Set<INT_SETUP__c> resp = new Set<INT_SETUP__c>();
		if (COM_Utils.isNotEmpty(sysType)) {
			List<INT_SETUP__c> setups = COM_SObjectUtils.getSelectedFieldsByDynamicSOQL(getIntSetupSelectFields(),COM_IntegrationConstants.API_INT_SETUP, 
			getIntSetupWhereClause(allowed, sysType, null, null), Limits.getLimitQueryRows());
			resp = new Set<INT_SETUP__c>(setups);
		}
		return resp;
	}
	
	/**
	* Returns the integration setups
	* @author	Sukrut Wagh
	* @allowed	allowed schedulables			optional. List of allowed schedulables. 
	* 											Please refer sObject-INT_SETUP__c definition for details 	
	* @param	sys		Integration system
	* @return	Set<INT_SETUP__c>		
	*/
	public static Set<INT_SETUP__c> getSetupsForSystem(final List<String> allowed,final String sys) {
		Set<INT_SETUP__c> resp = new Set<INT_SETUP__c>();		
		if (COM_Utils.isNotEmpty(sys)) {
			List<INT_SETUP__c> setups = COM_SObjectUtils.getSelectedFieldsByDynamicSOQL(getIntSetupSelectFields(),COM_IntegrationConstants.API_INT_SETUP, 
			getIntSetupWhereClause(allowed, null, sys, null), Limits.getLimitQueryRows());
			resp = new Set<INT_SETUP__c>(setups);
		}
		return resp;
	}
	
	/**
	* Returns the integration setups
	* @author	Sukrut Wagh
	* @allowed	allowed schedulables			optional. List of allowed schedulables. 
	* 											Please refer sObject-INT_SETUP__c definition for details 	
	* @param	sObjType		sObject Type API name
	* @return	Set<INT_SETUP__c>		
	*/
	public static Set<INT_SETUP__c> getSetupsForSObjectType(final List<String> allowed,final String sObjType) {
		Set<INT_SETUP__c> resp = new Set<INT_SETUP__c>();
		if (COM_Utils.isNotEmpty(sObjType)) {
			List<INT_SETUP__c> setups = COM_SObjectUtils.getSelectedFieldsByDynamicSOQL(getIntSetupSelectFields(),COM_IntegrationConstants.API_INT_SETUP, 
			getIntSetupWhereClause(allowed, null, null, sObjType), Limits.getLimitQueryRows());
			resp = new Set<INT_SETUP__c>(setups);
		}
		return resp;
	}
	
	/**
	* Returns the integration setups
	* @author	Sukrut Wagh
	* @allowed	allowed schedulables			optional. List of allowed schedulables. 
	* 											Please refer sObject-INT_SETUP__c definition for details 	
	* @param	sObjType		sObject Type API name
	* @param	sys				Integration system
	* @return	Set<INT_SETUP__c>		
	*/
	public static INT_SETUP__c getSetupsForSObjectTypeAndSystem(final List<String> allowed,final String sObjType, final String sys) {
		INT_SETUP__c resp = null;
		if (COM_Utils.isNotEmpty(sObjType) && COM_Utils.isNotEmpty(sys)) {
			List<INT_SETUP__c> setups = COM_SObjectUtils.getSelectedFieldsByDynamicSOQL(getIntSetupSelectFields(),COM_IntegrationConstants.API_INT_SETUP, 
			getIntSetupWhereClause(allowed, null, sys, sObjType), 1);
			if(COM_Utils.isNotEmpty(setups)) {
				resp = setups.get(0);
			}
		}
		return resp;
	}
	
	/**
	* Returns the integration setup statuses for the given criteria
	* @author	Sukrut Wagh
	* @statuses	statuses		optional. List of valid statuses. Refer COM_IntegrationConstants.STATUS_* & sObject=INT_Status__c 
	* @param	sObjType		sObject Type API name
	* @param	sys				Integration system
	* @return	Set<INT_SETUP_STATUS__c>		
	*/
	public static Set<INT_SETUP_STATUS__c> getSetupStatuses(final List<String> statuses,final String sObjType, final String sys) {
		Set<INT_SETUP_STATUS__c> resp = new Set<INT_SETUP_STATUS__c>();
		if (COM_Utils.isNotEmpty(sObjType) && COM_Utils.isNotEmpty(sys)) {
			List<INT_SETUP_STATUS__c> intStatuses = COM_SObjectUtils.getSelectedFieldsByDynamicSOQL(getIntSetupStatusSelectFields(),
			COM_IntegrationConstants.API_INT_SETUP_STATUS, 
			getIntSetupStatusWhereClause(statuses, sys, sObjType), Limits.getLimitQueryRows());
			resp = new Set<INT_SETUP_STATUS__c>(intStatuses);
		}
		return resp;
	}
	
	/*
	*	Returns the fields to be queried for sObject=INT_SETUP__c
	*/
	private static String getIntSetupSelectFields() {
		String methodName = 'getIntSetupSelectFields';
		LOGGER.entry(methodName);
		String selectFields = 'Allowed_Schedulables__c, CreatedById, CreatedDate, IsDeleted, Enabled__c, Name, System__c,'+ 
				'LastModifiedById, LastModifiedDate, OwnerId, Id, SystemModstamp, Type_API_Name__c,'+ 
				'System__r.System__c, System__r.SystemType__r.Type__c';
		LOGGER.debug(selectFields);
		LOGGER.exit(methodName);
		return selectFields;
	}
	
	/*
	*	Creates the filter criteria for sObject=INT_SETUP__c
	*/
	private static String getIntSetupWhereClause(final List<String> allowed, final String sysType, final String sys, final String sObjType) {
		String methodName = 'getIntSetupWhereClause';
		LOGGER.entry(methodName);
		String whereClause = 'Enabled__c=true AND (allowed_schedulables__c = \'\' ';
		String allowedStr = COM_Utils.toString(allowed,SEMICOLON,null);
		if(COM_Utils.isNotEmpty(allowedStr)) {
			whereClause += 'or allowed_schedulables__c includes (\''+allowedStr+'\')';
		}
		whereClause += ')';
		
		if(COM_Utils.isNotEmpty(sysType)) {
			whereClause += ' AND System__r.SystemType__r.Type__c=\''+sysType+'\'';
		}
		if(COM_Utils.isNotEmpty(sys)) {
			whereClause += ' AND System__r.System__c= \''+sys+'\'';
		}
		if(COM_Utils.isNotEmpty(sObjType)) {
			whereClause += ' AND Type_API_Name__c=\''+sObjType+'\'';
		}
		LOGGER.debug(whereClause);
		LOGGER.exit(methodName);
		return whereClause;
	}
	
	/*
	*	Returns the fields to be queried for sObject=INT_SETUP_STATUS__c
	*/
	public static String getIntSetupStatusSelectFields() {
		String methodName = 'getIntSetupStatusSelectFields';
		LOGGER.entry(methodName);
		String selectFields = 'Attributes_JSON__c, CreatedById, CreatedDate, IsDeleted, Exception__c, IntegrationStatus__c, LastModifiedById, LastModifiedDate, OwnerId, Id,'+ 
				'SystemModstamp, IntegrationSetup__c, Name, Unique_Key__c, '+ 
				'IntegrationStatus__r.Status__c, IntegrationSetup__r.Type_API_Name__c, IntegrationSetup__r.System__r.System__c';
		LOGGER.debug(selectFields);
		LOGGER.exit(methodName);
		return selectFields;
	}
	
	/*
	*	Creates the filter criteria for sObject=INT_SETUP_STATUS__c
	*/
	private static String getIntSetupStatusWhereClause(final List<String> statuses, final String sys, final String sObjType) {
		String methodName = 'getIntSetupStatusWhereClause';
		LOGGER.entry(methodName);
		String whereClause = '';
		String andStr = ' AND ';
		String statusesStr = COM_Utils.toString(statuses,COMMA,'\'');
		if(COM_Utils.isNotEmpty(statusesStr)) {
			whereClause += 'IntegrationStatus__r.Status__c IN ('+statusesStr+')';
		}
		if(COM_Utils.isNotEmpty(sys)) {
			whereClause += andStr+' IntegrationSetup__r.System__r.System__c = \''+sys+'\'';
		}
		if(COM_Utils.isNotEmpty(sObjType)) {
			whereClause += andStr+' IntegrationSetup__r.Type_API_Name__c=\''+sObjType+'\'';
		}
		if(COM_Utils.isNotEmpty(whereClause) && whereClause.startsWithIgnoreCase(andStr)) {
			whereClause = whereClause.removeStartIgnoreCase(andStr);
		}
		LOGGER.debug(whereClause);
		LOGGER.exit(methodName);
		return whereClause;
	}
	
}