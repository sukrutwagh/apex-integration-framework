@isTest
public with sharing class COM_IntegrationUtilsUTest {
	
	static testMethod void getSetupsTest_Empty (){
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetups(new List<String>{'Unauthorized_Schedulable 1','Unauthorized_Schedulable 2'});
		system.assertEquals(0, setups.size(), 'Integration Setups found when no data exists!');
	}
	
	static testMethod void getSetupsTest (){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		Test.startTest();
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetups(new List<String>{setup.Allowed_Schedulables__c});
		Test.stopTest();
		system.assertEquals(1, setups.size(), 'Integration Setups not found!');
		for(INT_SETUP__c retSetup: setups) {
			system.assertEquals(setup.Id, retSetup.Id, 'Integration Setup - Id do not match!');
			system.assertEquals(sys.Id, retSetup.System__c , 'Integration Setup - System do not match!');
			break;
		}
	}
	
	static testMethod void getSetupsForSystemTest_Empty (){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<String> allowed = new List<String>{setup.Allowed_Schedulables__c};
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetups(allowed);
		system.assertEquals(1, setups.size(), 'No Integration Setups found!');
		Test.startTest();
		setups = COM_IntegrationUtils.getSetupsForSystem(allowed,'System X');
		Test.stopTest();
		system.assertEquals(0, setups.size(), 'Integration Setups found for non-existent system!');
	}
	
	static testMethod void getSetupsForSystemTest (){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<String> allowed = new List<String>{setup.Allowed_Schedulables__c};
		Test.startTest();
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetupsForSystem(allowed,sys.System__c);
		Test.stopTest();
		system.assertEquals(1, setups.size(), 'Integration Setups not found!');
		for(INT_SETUP__c retSetup: setups) {
			system.assertEquals(setup.Id, retSetup.Id, 'Integration Setup - Id do not match!');
			system.assertEquals(sys.Id, retSetup.System__c , 'Integration Setup - System do not match!');
			break;
		}
	}
	
	static testMethod void getSetupsForSObjectTypeTest_Empty (){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<String> allowed = new List<String>{setup.Allowed_Schedulables__c};
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetups(allowed);
		system.assertEquals(1, setups.size(), 'No Integration Setups found!');
		Test.startTest();
		setups = COM_IntegrationUtils.getSetupsForSObjectType(allowed,'Type_X__c');
		Test.stopTest();
		system.assertEquals(0, setups.size(), 'Integration Setups found for non-existent sObject type!');
	}
	
	static testMethod void getSetupsForSObjectTypeTest (){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<String> allowed = new List<String>{setup.Allowed_Schedulables__c};
		Test.startTest();
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetupsForSObjectType(allowed,setup.Type_API_Name__c);
		Test.stopTest();
		system.assertEquals(1, setups.size(), 'Integration Setups not found!');
		for(INT_SETUP__c retSetup: setups) {
			system.assertEquals(setup.Id, retSetup.Id, 'Integration Setup - Id do not match!');
			system.assertEquals(sys.Id, retSetup.System__c , 'Integration Setup - System do not match!');
			system.assertEquals(setup.Type_API_Name__c, retSetup.Type_API_Name__c , 'Integration Setup - sObject type do not match!');
			break;
		}
	}
	
	static testMethod void getSetupsForSystemTypeTest_Empty (){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<String> allowed = new List<String>{setup.Allowed_Schedulables__c};
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetups(allowed);
		system.assertEquals(1, setups.size(), 'No Integration Setups found!');
		Test.startTest();
		setups = COM_IntegrationUtils.getSetupsForSystemType(allowed,'SYS_TYPE_X');
		Test.stopTest();
		system.assertEquals(0, setups.size(), 'Integration Setups found for non-existent System type!');
	}
	
	static testMethod void getSetupsForSystemTypeTest (){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<String> allowed = new List<String>{setup.Allowed_Schedulables__c};
		Test.startTest();
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetupsForSystemType(allowed,sysType.Type__c);
		Test.stopTest();
		system.assertEquals(1, setups.size(), 'Integration Setups not found!');
		for(INT_SETUP__c retSetup: setups) {
			system.assertEquals(setup.Id, retSetup.Id, 'Integration Setup - Id do not match!');
			system.assertEquals(sys.Id, retSetup.System__c , 'Integration Setup - System do not match!');
			system.assertEquals(sysType.Type__c, retSetup.System__r.SystemType__r.Type__c , 'Integration Setup - system type do not match!');
			break;
		}
	}
	
	static testMethod void getSetupsForSObjectTypeAndSystemTest_Empty (){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<String> allowed = new List<String>{setup.Allowed_Schedulables__c};
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetups(allowed);
		system.assertEquals(1, setups.size(), 'No Integration Setups found!');
		Test.startTest();
		INT_SETUP__c retSetup = COM_IntegrationUtils.getSetupsForSObjectTypeAndSystem(allowed,setup.Type_API_Name__c,'SYS_TYPE_X');
		system.assertEquals(null, retSetup, 'Integration Setup found for non-existent System type!');
		
		retSetup = COM_IntegrationUtils.getSetupsForSObjectTypeAndSystem(allowed,'Type_X__c',sys.System__c);
		system.assertEquals(null, retSetup, 'Integration Setup found for non-existent sObject type!');
		Test.stopTest();
	}
	
	static testMethod void getSetupsForSObjectTypeAndSystemTest (){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<String> allowed = new List<String>{setup.Allowed_Schedulables__c};
		Test.startTest();
		INT_SETUP__c retSetup = COM_IntegrationUtils.getSetupsForSObjectTypeAndSystem(allowed,setup.Type_API_Name__c,sys.System__c);
		Test.stopTest();
		system.assertNotEquals(null, retSetup, 'Integration Setup not found!');
		system.assertEquals(setup.Id, retSetup.Id, 'Integration Setup - Id do not match!');
		system.assertEquals(setup.Type_API_Name__c, retSetup.Type_API_Name__c, 'Integration Setup - Type_API_Name__c do not match!');
		system.assertEquals(sys.Id, retSetup.System__c , 'Integration Setup - System do not match!');
		system.assertEquals(sysType.Type__c, retSetup.System__r.SystemType__r.Type__c , 'Integration Setup - system type do not match!');
	}
	
	static testMethod void getSetupStatusesTest_Empty(){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<INT_STATUS__c> statuses = getIntStatuses(4);
		insert statuses;
		Test.startTest();
		
		//No integration status filter
		Set<INT_SETUP_STATUS__c> retSetupStatusesNoIntStatusFilter = COM_IntegrationUtils.getSetupStatuses(null,
									 setup.Type_API_Name__c,sys.System__c);
		
		List<INT_SETUP_STATUS__c> setupStatuses = getSetupStatuses(6, setup, statuses);
		insert setupStatuses;
		
		//Filter by a invalid integration status
		Set<INT_SETUP_STATUS__c> retSetupStatusesFilterOneIntStatus = 
									COM_IntegrationUtils.getSetupStatuses(new List<String>{'Invalid status'},
									 setup.Type_API_Name__c,sys.System__c);
		//Pass all integration status for filter											
		Set<INT_SETUP_STATUS__c> retSetupStatusesAllIntStatus = COM_IntegrationUtils.getSetupStatuses(getIntStatusesString(statuses),
									 setup.Type_API_Name__c,sys.System__c);									 
		Test.stopTest();
		system.assertEquals(0, retSetupStatusesNoIntStatusFilter.size());
		system.assertEquals(0, retSetupStatusesFilterOneIntStatus.size());
		system.assertNotEquals(null, retSetupStatusesAllIntStatus);
		system.assertEquals(6, retSetupStatusesAllIntStatus.size());
		
	}
	
	static testMethod void getSetupStatusesTest(){
		INT_SYSTEM_TYPE__c sysType = getSystemTypes(1).get(0);
		insert sysType;
		INT_SYSTEM__c sys = getSystems(1, sysType).get(0);
		insert sys;
		INT_SETUP__c setup = getSystemSetups(1, sys).get(0);
		insert setup;
		List<INT_STATUS__c> statuses = getIntStatuses(4);
		insert statuses;
		List<INT_SETUP_STATUS__c> setupStatuses = getSetupStatuses(6, setup, statuses);
		insert setupStatuses;
		Test.startTest();
		//Filter by a integration status
		Set<INT_SETUP_STATUS__c> retSetupStatusesFilterOneIntStatus = 
									COM_IntegrationUtils.getSetupStatuses(new List<String>{statuses.get(0).Status__c},
									 setup.Type_API_Name__c,sys.System__c);
		//No integration status filter
		Set<INT_SETUP_STATUS__c> retSetupStatusesNoIntStatusFilter = COM_IntegrationUtils.getSetupStatuses(null,
									 setup.Type_API_Name__c,sys.System__c);
		//Pass all integration status for filter											
		Set<INT_SETUP_STATUS__c> retSetupStatusesAllIntStatus = COM_IntegrationUtils.getSetupStatuses(getIntStatusesString(statuses),
									 setup.Type_API_Name__c,sys.System__c);
		Test.stopTest();
		system.assertNotEquals(null, retSetupStatusesFilterOneIntStatus);
		system.assertNotEquals(null, retSetupStatusesNoIntStatusFilter);
		system.assertNotEquals(null, retSetupStatusesAllIntStatus);
		
		system.assertEquals(1, retSetupStatusesFilterOneIntStatus.size());
		system.assertEquals(6, retSetupStatusesNoIntStatusFilter.size());
		system.assertEquals(6, retSetupStatusesAllIntStatus.size());
		
	}
	
	/*************************** Boilerplate helper methods  ****************************/
	
	private static List<INT_SYSTEM_TYPE__c> getSystemTypes(Integer size) {
		List<INT_SYSTEM_TYPE__c> types = new List<INT_SYSTEM_TYPE__c>();
		INT_SYSTEM_TYPE__c sysType = null; 
		for(Integer i=0;i<size;i++) {
			sysType = new INT_SYSTEM_TYPE__c(Type__c='SYS TYPE-'+i, Description__c='DESC-'+i);
			sysType.Name = sysType.Type__c;
			types.add(sysType);
		}
		return types;
	}
	
	private static List<INT_STATUS__c> getIntStatuses(Integer size) {
		List<INT_STATUS__c> statuses = new List<INT_STATUS__c>();
		INT_STATUS__c status = null; 
		for(Integer i=0;i<size;i++) {
			status = new INT_STATUS__c(Status__c='STATUS-'+i, Description__c='DESC-'+i);
			status.Name = status.Status__c;
			statuses.add(status);
		}
		return statuses;
	}
	
	private static List<String> getIntStatusesString(final List<INT_STATUS__c> statuses) {
		List<String> statusesStr = new List<String>();
		if(COM_Utils.isNotEmpty(statuses)) {
			for(INT_STATUS__c status: statuses) {
				statusesStr.add(status.Status__c);
			}
		}
		return statusesStr;
	}
	
	private static List<INT_SYSTEM__c> getSystems(Integer size, final INT_SYSTEM_TYPE__c sysType) {
		List<INT_SYSTEM__c> systems = new List<INT_SYSTEM__c>();
		if(null != sysType) {
			INT_SYSTEM__c sys = null; 
			for(Integer i=0;i<size;i++) {
				sys = new INT_SYSTEM__c(System__c='SYS-'+i, Description__c='DESC-'+i, SystemType__c=sysType.Id);
				sys.Name = sys.System__c;
				systems.add(sys);
			}
		}
		return systems;
	}
	
	private static List<INT_SETUP__c> getSystemSetups(Integer size, final INT_SYSTEM__c sys) {
		List<INT_SETUP__c> setups = new List<INT_SETUP__c>();
		if(null != sys) {
			INT_SETUP__c setup = null; 
			for(Integer i=0;i<size;i++) {
				setup = new INT_SETUP__c(Enabled__c=true,Allowed_Schedulables__c='Sched-'+i,Type_API_Name__c='API TYPE-'+i,System__c=sys.Id);
				setup.Name = sys.Name + '-' + setup.Type_API_Name__c;
				setups.add(setup);
			}
		}
		return setups;
	}
	
	private static List<INT_SETUP_STATUS__c> getSetupStatuses(Integer size, final INT_SETUP__c setup, final List<INT_STATUS__c> statuses) {
		List<INT_SETUP_STATUS__c> setupStatuses = new List<INT_SETUP_STATUS__c>();
		if(null != setup && COM_Utils.isNotEmpty(statuses)) {
			INT_SETUP_STATUS__c setupStatus = null;
			INT_STATUS__c status = statuses.get(0);
			for(Integer i=0;i<size;i++) {
				if(i < statuses.size()) {
					status = statuses.get(i);
				}
				setupStatus = new INT_SETUP_STATUS__c(Attributes_JSON__c='JSON data-'+i, Exception__c='', IntegrationSetup__c=setup.Id,
													 IntegrationStatus__c=status.Id, Unique_Key__c='UK-'+i);
				setupStatus.Name = status.Name +'-'+setupStatus.Unique_Key__c;										 
				setupStatuses.add(setupStatus);
			}
		}
		return setupStatuses;
	}
	
}