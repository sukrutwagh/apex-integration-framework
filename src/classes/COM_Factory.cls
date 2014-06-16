/**
* @author:	 	Sukrut Wagh
* @description:	Factory pattern for creating objects of Apex classes
* 
* References: 
* http://www.oodesign.com/factory-pattern.html
* http://jessealtman.com/2014/03/dependency-injection-in-apex/
*/
public class COM_Factory {
    
    private static final COM_Logger LOGGER = new COM_Logger('COM_Factory'); 
    
    /*
    *   Returns a new instance for the requested Integration Service
    *	Throws COM_Exception (COM_ErrorCode.INTEGRATION_SERVICE_NOT_FOUND) - If no service implmentation found
    */
    public static COM_IIntegrationService getIntegrationService(final String sys, final String sObjType) {
        String methodName = 'getIntegrationService';
        LOGGER.entry(methodName);
        COM_IIntegrationService service = null;
        String serviceClassName = getISClassName(sys, sObjType);
        LOGGER.info('Service Class for sys:'+sys+', sObjType:'+sObjType+' resolved to:'+serviceClassName);
        if(COM_Utils.isEmpty(serviceClassName)) {
            throw new COM_Exception(COM_ErrorCode.INTEGRATION_SERVICE_NOT_FOUND,
            'Apex class not found for integration service system:'+sys+', sObjType:'+sObjType);
        } else {
            Type obType = Type.forName(serviceClassName);
            service = (obType == null) ? null : (COM_IIntegrationService)obType.newInstance();
            if(null != service) {
                //Set the props
                service.setSObjectType(sObjType);
                service.setIntSystem(sys);
            }
        }
        LOGGER.exit(methodName);
        return service;
    }
    
    /*
        Returns the Apex class name for the Integration service
        Note:
        An concrete implementation of the integration service class must follow the below class name convention:
        <PROJECT_PREFIX>_<INTEGRATION_SYSTEM_NAME><SOBJECT_APINAME>IS
        Examples:
        CM_ETMFApttusAptsAgreementIS
        CM_CTMSApttusAptsAgreementIS
    */
    private static String getISClassName(final String sys, final String sObjType) {
        String serviceClassName = '';
        if(COM_Utils.isNotEmpty(sys) && COM_Utils.isNotEmpty(sObjType)) {
            String likeStr = sObjType.replaceAll('__c', '');
            likeStr = likeStr.replaceAll('_', '');
            likeStr = '%'+sys+likeStr+'IS';
            LOGGER.debug('likeStr:'+likeStr);
            ApexClass apexClass = null;
            try {
                apexClass = [SELECT Name FROM ApexClass WHERE Status='Active' AND IsValid=true AND Name LIKE :likeStr ];
            } catch (QueryException ex) {
                LOGGER.error(ex.getMessage(), ex);
            }
            if(null != apexClass) {
                serviceClassName = apexClass.Name;
            }
        }
        return serviceClassName;
    }
    
}