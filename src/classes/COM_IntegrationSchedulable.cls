/*

@author: Sukrut Wagh

This schedulable Apex encapsulates the logic for queuing the Batch Apex responsible for all integrations.
As per: http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_batch_interface.htm 
Upto five queued or active batch jobs are allowed for Apex

Due to this governor limit, batch jobs are queued to be executed at a later time.
Please refer COM_Batch_Queue__c.class for the details around execution of batch jobs in org. 

Please refer the Batchable Apex implementation for the integration details.

Most likely this class will be scheduled in your org by Admins.

https://www.salesforce.com/us/developer/docs/apexcode/Content/apex_scheduler.htm 

Alternately, this class can be scheduled as below:
COM_IntegrationSchedulable intSchedule = new COM_IntegrationSchedulable();
String sch = '0 0 0 * * ?';
System.schedule('SYSTEM:COM_IntegrationSchedulable', sch, intSchedule);

Note:
1.A check is made if any Sfdc Object type is enabled for integrations. 
Refer sObject=INT_SETUP__c to understand how integrations are enabled administratively
2.Batches are scheduled only if #1 is true

*/ 

global class COM_IntegrationSchedulable implements Schedulable {
	
	private static final String CLASSNAME = 'COM_IntegrationSchedulable';
	private static final String BATCH_CLASSNAME = 'COM_IntegrationBatch';
	private static final COM_Logger LOGGER = new COM_Logger(CLASSNAME);
	
	global void execute(SchedulableContext cxt) {
		String methodName = 'execute';
		LOGGER.entry(methodName);
		/*	Check if integration is enabled on any sObject
		*/
		Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetups(new String[]{CLASSNAME});
		LOGGER.info('Found integration setups:'+setups);
		
		
		//Set<INT_SETUP__c> setups = COM_IntegrationUtils.getSetupsForSystem(new List<String>{'CM_ETMF_Schedulable'},COM_IntegrationConstants.INT_SYSTEM_ETMF);
		//
		
		/*Proceed to create batches
		*/
		List<String> jobIds = new List<String>();
		String jobId = null;
		if(null != setups && !setups.isEmpty()) {
			LOGGER.info('Queuing batches...');
			for(INT_SETUP__c setup: setups) {
				jobId = COM_BatchQueue.addJob(BATCH_CLASSNAME, 
				Json.serialize(new List<String>{setup.System__r.System__c, setup.Type_API_Name__c, COM_IntegrationConstants.EMAIL_RECIPIENT}),null);
				jobIds.add(jobId);
			}
		}
		LOGGER.info('Job Ids for scheduled batches:'+jobIds);
		LOGGER.exit(methodName);
	}

}