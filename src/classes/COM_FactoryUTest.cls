@isTest
private class COM_FactoryUTest {

    static testMethod void getIntegrationServiceTest() {
        COM_IIntegrationService iService = null;
        try {
            iService = COM_Factory.getIntegrationService(null, null);
        } catch(COM_Exception ex) {
            system.assertEquals(COM_ErrorCode.INTEGRATION_SERVICE_NOT_FOUND, ex.getCode());
        }
        try {
            iService = COM_Factory.getIntegrationService(COM_IntegrationConstants.INT_SYSTEM_ETMF, null);
        } catch(COM_Exception ex) {
            system.assertEquals(COM_ErrorCode.INTEGRATION_SERVICE_NOT_FOUND, ex.getCode());
        }
        try {
            iService = COM_Factory.getIntegrationService(null, COM_IntegrationConstants.API_APTTUS_APTS_AGREEMENT);
        } catch(COM_Exception ex) {
            system.assertEquals(COM_ErrorCode.INTEGRATION_SERVICE_NOT_FOUND, ex.getCode());
        }
        try {
            iService = COM_Factory.getIntegrationService('Invalid System', 'Invalid Type');
        } catch(COM_Exception ex) {
            system.assertEquals(COM_ErrorCode.INTEGRATION_SERVICE_NOT_FOUND, ex.getCode());
        }
        iService = COM_Factory.getIntegrationService(COM_IntegrationConstants.INT_SYSTEM_ETMF, COM_IntegrationConstants.API_APTTUS_APTS_AGREEMENT);
        system.assertNotEquals(null, iService);
        system.assertEquals(COM_IntegrationConstants.INT_SYSTEM_ETMF, iService.getIntSystem());
        system.assertEquals(COM_IntegrationConstants.API_APTTUS_APTS_AGREEMENT, iService.getSObjectType());
        iService.invoke();
        
    }
}